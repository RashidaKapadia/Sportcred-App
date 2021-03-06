package underdevelopment.db;


import static org.neo4j.driver.Values.parameters;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;

public class DBLogin{
    
    // verify the user credentials
    public boolean verifyUser(String username, String password){
        try (Session session = Connect.driver.session()) {
        	Result result = session.run("MATCH (u:user) WHERE u.username = $x AND u.password = $y RETURN u IS NOT NULL",
                                        parameters("x",  username, "y", password));
            return result.hasNext();
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
