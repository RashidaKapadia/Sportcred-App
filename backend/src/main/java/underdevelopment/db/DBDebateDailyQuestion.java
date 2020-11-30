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

    /**
     * Returns the daily debate question for the given tier
     * @param tier
     * @return
     */
    public static String getDailyDebateQuestion(String tier){
        try (Session session = Connect.driver.session()) {
            String date = LocalDate.now().toString();

            System.out.println(date);

            // ***NEED TO UPDATE "d" to point to date***

            // Query to get the daily debate question for the given tier
            Result result = session.run("MATCH (q:DebateQuestion {tier: $t, date: $d} ) RETURN q",
                                        parameters("t", tier, "d", "2020-12-02"));
            
            if (result.hasNext()){
                Record r = result.single();

                String question = r.get("q").get("question").asString();

                return question;
            }
            return "";
        }
        catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * Creates a response node to add user's analysis for their daily debate question and returns the id of the newly
     * created response node.
     * @param username
     * @param analysis
     * @return 
     */
    public static int addResponse(String username, String analysis){
        try (Session session = Connect.driver.session()) {

            // Query to create response node for the analysis of the user with given username
            Result result = session.run("MERGE (r:DebateResponse {username: $u}) ON CREATE SET r.debateAnalysis = $a " 
                                      + "ON MATCH SET r.debateAnalysis = $a RETURN ID(r) as id",
                                        parameters("u", username, "a", analysis));
            
            if (result.hasNext()){
                Record r = result.next();

                int id = r.get("id").asInt();

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

    /**
     * Returns the given user's response to the daily question if they have already submitted their analysis.
     */
    public static String getResponseToDailyQuestion(String tier, String username){
        try (Session session = Connect.driver.session()) {
            String date = LocalDate.now().toString();

            // NEED TO CHANGE "d" to point to date
            // Query to get the response of the given user to their tier's daily debate question
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

    /**
     * Returns true if and only if the relationship between the question node and the response node was added successfully.
     * @param tier
     * @param id
     * @return
     */
    public static boolean addResponseToQuestion(String tier, int id){
        try (Session session = Connect.driver.session()) {
            String date = LocalDate.now().toString();

            // NEED TO CHANGE "d" to point to date
            // Query to add relationship between the given tier's daily debate question and the reponse with the given id
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