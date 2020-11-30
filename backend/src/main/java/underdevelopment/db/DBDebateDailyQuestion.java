package underdevelopment.db;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

import static org.neo4j.driver.Values.parameters;


public class DBDebateDailyQuestion {

     
    public static Map<String, String> getDailyDebateQuestion(String tier){

        System.out.println(LocalDate.now().toString());

        try (Session session = Connect.driver.session()) {
            // NEED TO UPDATE DATE TO LOCAL DATE AFTER DEC 1
            Result result = session.run("MATCH (q:DebateQuestion {tier: $t, date: $d} ) RETURN q",
                                        parameters("t", tier, "d", "2020-12-02"));
            
            if (result.hasNext()){
                Record r = result.single();

                Map<String, String> question = new HashMap<>();
                question.put("question", r.get("q").get("question").asString());

                return question;
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }

    public static int addResponse(String username, String analysis){
        try (Session session = Connect.driver.session()) {

            Result result = session.run("MERGE (r:DebateResponse {username: $u}) ON CREATE SET r.debateAnalysis = $a " 
                                      + "ON MATCH SET r.debateAnalysis = $a RETURN ID(r) as id",
                                        parameters("u", username, "a", analysis));
            
            if (result.hasNext()){
                Record r = result.next();

                int id = r.get("id").asInt();

                System.out.println(id);

                session.close();

                return id;

            }
            return -1;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public static String getResponseToDailyQuestion(String tier, String username){
        try (Session session = Connect.driver.session()) {

            Result result = session.run("MATCH (q:DebateQuestion {tier: $t, date: $d})-[:hasResponse]->"
                                      + "(r:DebateResponse {username: $u}) " 
                                      + "RETURN r.debateAnalysis as analysis",
                                        parameters("t", tier, "d", "2020-12-01", "u", username));
            
            if (result.hasNext()){
                Record r = result.next();

                String analysis = r.get("analysis").asString();

                System.out.println(analysis);

                session.close();
                
                return analysis;

            }
            return "";
        }
        catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static boolean addResponseToQuestion(String tier, int id){
        try (Session session = Connect.driver.session()) {
            
            // NEED TO CHANGE DATE TO LocalDate.now().toString()
            session.writeTransaction(tx -> tx.run("MATCH (q:DebateQuestion {tier: $t, date: $d}), (a:DebateResponse) " 
            + "WHERE ID(a) = $i MERGE (q)-[r:hasResponse]->(a) RETURN r",
                                        parameters("t", tier, "d", "2020-12-01", "i", id)));
            session.close();
            return true;
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}