package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import org.neo4j.driver.Result;
import org.neo4j.driver.Session;

import java.io.BufferedReader; 
import java.io.IOException; 
import java.io.InputStreamReader; 

public class DBMockdata {
    
    // private final static int VERSION_TIMESTAMP = 1603768492;
    private final static int VERSION_TIMESTAMP = 3;

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
                    System.out.println("Update failed, data may be corrupted");
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    // merge (n:Mockdata) on create set n.timestamp = 2 on match set n.timestamp = 3
    // match (n:Mockdata) delete n

    private static int getCurrentVersion() {
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (n:Mockdata) return n.timestamp as timestamp");
            if (result.hasNext()) 
                return result.next().get("timestamp", 0);
            else 
                return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
            return 0;
        }    
    }

    private static boolean updateMockData(int oldTimestamp) {
        try (Session session = Connect.driver.session()) {
            session.run("merge (n:Mockdata) on create set n.timestamp = $x on match set n.timestamp = $x", parameters("x", VERSION_TIMESTAMP));
            return true; 
        }
        catch (Exception e) {
            return false;
        }
    }

    private static boolean createMockTriviaQuestions() {
        return false;
    }
}
