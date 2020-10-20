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
                                    String about, String dob, int acs, String tier){
        
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) SET a.status = $status AND a.email = $email AND a.about = $about AND a.dob = $dob AND a.acs = $acs AND a.tier = $tier RETURN a",
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
    public static Boolean getUserInfo(String username){

        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) RETURN a",
                parameters("username", username)));
            
            session.close();
            return true;
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
            return false;
        }
    }
}