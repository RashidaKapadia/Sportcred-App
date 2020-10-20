package underdevelopment.db;

import java.lang.reflect.Parameter;
import static org.neo4j.driver.Values.parameters;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBProfile{

    String username = "";
    String email = "";
    String phoneNumber = "";
    String about = "";
    String status = "";
    String dob = "";
    int acs = 100;
    String tier = "";

    // DB command for upadting user status
    public static Boolean updateUserInfo(String username, String status, String email, 
                                    String about, String dob, String acs, String tier){
        
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (u:user) WHERE u.username = $username SET u.status = $status, u.email = $email, u.about = $about, u.dob = $dob, u.acs = $acs, u.tier = $tier",
                parameters("username", username, "status", status, "email", email, "about", about, "dob", dob, "acs", acs, "tier", tier)));
            
            session.close();
            return true;
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
            return false;
        }
    }

    // DB command for getting user status
    public static Result getUserInfo(String username){

        try (Session session = Connect.driver.session()) {
            Result node_result = session.writeTransaction(tx -> tx.run(
                "MATCH (u:user) WHERE u.username = $username WITH u RETURN properties(u)",
                parameters("username", username)));
            session.close();
            return node_result;
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
            return null;
        }
    }
}