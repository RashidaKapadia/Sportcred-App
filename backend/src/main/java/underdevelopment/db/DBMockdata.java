package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

// TODO: might want to split responsibilities
public class DBMockdata {

    private final static int VERSION_TIMESTAMP = 11;

    public static void checkAndUpdate() {

        System.out.print("Checking mock data ... ");

        // Get version
        int currentVersion = getCurrentVersion();

        // Check version
        if (currentVersion >= VERSION_TIMESTAMP) {
            System.out.println("up to date");
            return;
        }

        // Ask to update if needed
        System.out.println("\nYour mockdata is behind, do you want to update now? [Y/N]");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        try {
            String response = reader.readLine();
            if (response.trim().equals("Y")) {
                if (updateMockData(currentVersion)) {
                    System.out.println("Mock data updated successfully");
                } else {
                    System.out.println("Update failed");
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // merge (n:Mockdata) on create set n.timestamp = 2 on match set n.timestamp = 3
    // match (n:Mockdata) delete n

    /**
     * Returns current version timestamp or defaults to 0
     */
    private static int getCurrentVersion() {
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (n:Mockdata) return n.timestamp as timestamp");
            if (result.hasNext())
                return result.next().get("timestamp", 0);
            else
                return 0;
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
            return 0;
        }
    }

    private static boolean updateMockData(int oldTimestamp) {
        try {
            Session session = Connect.driver.session();
            Transaction tx = session.beginTransaction();

            // Remove old mock data and create new mock data and update the timestamp
            removeOldMockTriviaQuestions(tx, oldTimestamp);
            createMockTriviaQuestions(tx);
            updateTimeStamp(tx);

            tx.commit();
            tx.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static void updateTimeStamp(Transaction tx) {
        tx.run("merge (n:Mockdata) on create set n.timestamp = $x on match set n.timestamp = $x",
                parameters("x", VERSION_TIMESTAMP));
    }

    private static void removeOldMockTriviaQuestions(Transaction tx, int oldTimestamp) {
        tx.run("match (n:Question {version: $x}) delete n",
                parameters("x", oldTimestamp));
    }

    private static boolean createMockTriviaQuestions(Transaction tx) {
        
        String resource = "mockdata/triviaQuestions.json";
        JSONObject jsonObj;
        
        // Get json file
        InputStream is = DBMockdata.class.getClassLoader().getResourceAsStream(resource);
        Reader reader = new InputStreamReader(is);
        JSONTokener tokener = new JSONTokener(reader);
        
        // Parse json file
        try {
            jsonObj = new JSONObject(tokener);
        } catch (JSONException e) {
            e.printStackTrace();
            throw new NullPointerException("Cannot parse json resource file " + resource);
        }

        // Read questions and insert into the db
        try {
            JSONArray questions = (JSONArray) jsonObj.get("questions");
            for (int i = 0; i < questions.length(); i++) {
                JSONObject q = (JSONObject) questions.get(i);
                tx.run("create (n:Question {questionId: $i, category: $c, question: $q, star: $s, answer: $a, options: $o, version: $t})",
                    parameters(
                        "i", (int) q.get("questionId"),
                        "c", q.get("category").toString(),
                        "q", q.get("question").toString(),
                        "s", q.get("star").toString(),
                        "a", q.get("answer").toString(),
                        "o", q.get("options").toString(),    
                        "t", VERSION_TIMESTAMP
                    ));
                System.out.println(q);
            }
        } catch (JSONException e) {
            e.printStackTrace();
            throw new NullPointerException("Error reading questions from " + resource);
        }
        return false;
    }
}
