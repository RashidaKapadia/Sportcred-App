package underdevelopment.db;

import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;

/* TODO Change */
public class Connect {

	public static String uriDb = "bolt://localhost:7687";
    public static String uriUser ="http://localhost:8080";
    public static Driver driver;

    public static void connectDB(String username, String password) {
        driver = GraphDatabase.driver(uriDb, AuthTokens.basic(username, password));
    }

    /**
     * Verifies whether DB is connected
     */
    public static boolean checkConnection() {
        try (Session session = Connect.driver.session()) {
            session.run("return 1 + 2");
            return true; 
        }
        catch (Exception e) {
            return false; // server error probably
        }
    }

}