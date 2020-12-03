package underdevelopment.db;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Map;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import static org.neo4j.driver.Values.parameters;

public class DBDebate {

    private static ArrayList<Map<String, Object>> getQuestionByDate(String date) {
        // match (n:DebateQuestion {date: "2020-12-01"}) return questions
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (n:DebateQuestion {date: $d}) return {id: ID(n), tier: n.tier, question: n.question} as question",
                                        parameters("d", date));

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

    // /api/debate/get-ongoing-questions 
    public static ArrayList<Map<String, Object>> getOngoingQuesions() {
        return getQuestionByDate(LocalDate.now().toString());
    }

    // /api/debate/get-finished-questions
    public static ArrayList<Map<String, Object>> getFinishedQuesions() {
        return getQuestionByDate(LocalDate.now().minusDays(1).toString());
    }


    // TODO: /api/debate/get-group-responses-my-question
    public static void getResponsesMyQuestion(String username) {
        
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
