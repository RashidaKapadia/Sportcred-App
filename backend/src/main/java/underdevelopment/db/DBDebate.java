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
        return getQuestionByDate(LocalDate.now().toString());
    }

    // /api/debate/get-finished-questions
    public static ArrayList<Map<String, Object>> getFinishedQuesions() {
        return getQuestionByDate(LocalDate.now().minusDays(1).toString());
    }

    public static String getTier(int acs) {
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

    private static int getACS(String username) {
        int acs = -1;
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (u:user {username: $u}) return u.acs as acs", parameters("u", username));
            if (result.hasNext()) {
                acs = result.next().get("acs").asInt();
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return acs;
    }

    // TODO: /api/debate/get-group-responses-my-question
    public static ArrayList<Record> getResponsesMyQuestion(String username) {
        
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (n:DebateQuestion {tier: $t, date: $d})-[:hasGroup]-(g:DebateGroup) with g match (g:DebateGroup)-[:hasResponse]-(r:DebateResponse) return g.id as groupId, collect({response: r.debateAnalysis, responseId: ID(r)}) as responses", 
                                        parameters("d", LocalDate.now().toString(), "t", getTier(getACS(username))));
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

    // TODO: /api/debate/get-previous-topic-result
    public static void getResultMyPreviousQuestion(String username) {

    }  

    // TODO: /api/debate/get-group-responses
    public static void getResponsesOngoing(String questionId) {
        /*
         match (n:DebateQuestion)-[:hasGroup]-(g:DebateGroup) where ID(n)=49 with g match (g:DebateGroup)-[:hasResponse]-(r:DebateResponse) return g.id as groupId, collect(r) as responses
         */
    }

    // TODO: /api/debate/get-debate-group-responses-n-results
    public static void getResponsesFinished(String questionId) {
        
    }
}
