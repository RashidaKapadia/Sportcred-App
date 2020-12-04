package underdevelopment.db;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Map;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Value;

import static org.neo4j.driver.Values.parameters;

public class DBDebate {

    private static ArrayList<Map<String, Object>> getQuestionByQuery(String query, Value value) {

        try (Session session = Connect.driver.session()) {
            Result result = session.run(query, value);
            ArrayList<Map<String, Object>> questions = new ArrayList<>();
            while (result.hasNext()) {
                questions.add(result.next().get("question").asMap());
            }
            return questions;
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static ArrayList<Map<String, Object>> getQuestionByDate(String date) {
        return getQuestionByQuery("match (n:DebateQuestion {date: $d}) return {id: ID(n), tier: n.tier, question: n.question} as question",
                                  parameters("d", date));
    }

    // /api/debate/get-ongoing-questions 
    public static ArrayList<Map<String, Object>> getOngoingQuesions() {
        return getQuestionByDate(LocalDate.now().minusDays(1).toString());
    }

    // /api/debate/get-finished-questions
    public static ArrayList<Map<String, Object>> getFinishedQuesions() {
        return getQuestionByDate(LocalDate.now().minusDays(2).toString());
    }

    public static String getTier(double acs) {
        if (acs <= 300) {
            return "FANALYST";
        } else if (acs <= 600) {
            return "ANALYST";
        } else if (acs <= 900) {
            return "PRO ANALYST";
        } else if (acs <= 1100) {
            return "EXPERT ANALYST";
        } else {
            return "";
        }
    }

    private static double getACS(String username) {
        double acs = -1;
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (u:user {username: $u}) return u.acs as acs", parameters("u", username));
            if (result.hasNext()) {
                acs = result.next().get("acs").asDouble();
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return acs;
    }

    private static ArrayList<Record> getResponsesByQuery(String query, Value value) {
        try (Session session = Connect.driver.session()) {
            Result result = session.run(query, value);
            ArrayList<Record> reponseGroups = new ArrayList<>();
            while (result.hasNext()) {
                reponseGroups.add(result.next());
            }
            return reponseGroups;
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    } 

    // /api/debate/get-group-responses-my-question
    public static ArrayList<Record> getResponsesMyQuestion(String username) {
        return getResponsesByQuery("match (n:DebateQuestion {tier: $t, date: $d})-[:hasGroup]-(g:DebateGroup) with g match (g:DebateGroup)-[:hasResponse]-(r:DebateResponse) return g.id as groupId, collect({response: r.debateAnalysis, responseId: ID(r)}) as responses", 
                                    parameters("d", LocalDate.now().minusDays(1).toString(), "t", getTier(getACS(username))));
    }

    // /api/debate/get-previous-topic-result
    public static Record getResultMyPreviousQuestion(String username) {
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (r:DebateResponse {username: $u, date: $d})-[:hasResponse]-(g:DebateGroup)-[:hasResponse]-(o:DebateResponse) return ID(g) as groupId, g.winner as winner, case when g.winner = $u then 5 else 0 end + toInteger(r.avgScore) as yourScore, r as yours, collect(o) as theirs",
                                        parameters("d", LocalDate.now().minusDays(2).toString(), "u", username));
            return (result.hasNext()) ? result.next() : null;
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }  

    // /api/debate/get-group-responses
    public static ArrayList<Record> getResponsesOngoing(int questionId) {
        return getResponsesByQuery("match (n:DebateQuestion)-[:hasGroup]-(g:DebateGroup) where ID(n) = $q with g match (g:DebateGroup)-[:hasResponse]-(r:DebateResponse) return g.id as groupId, collect({response: r.debateAnalysis, responseId: ID(r)}) as responses", 
                                    parameters("q", questionId));
    }

    // /api/debate/get-debate-group-responses-n-results
    public static ArrayList<Record> getResponsesFinished(int questionId) {
        return getResponsesByQuery("match (q:DebateQuestion)-[:hasGroup]-(g:DebateGroup)-[:hasResponse]-(o:DebateResponse) where ID(q)=$q return ID(g) as groupId, g.winner as winner, collect(o) as responses", 
                                    parameters("q", questionId));
    }
}
