package underdevelopment.db;

import java.time.LocalDate;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import static org.neo4j.driver.Values.parameters;

public class DBDebate {

    // TODO: /api/debate/get-ongoing-questions 
    public static void getOngoingQuesions() {
        
    }

    // TODO: /api/debate/get-finished-questions
    public static void getFinishedQuesions() {
        
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
