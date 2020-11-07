package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBProfile{
	
	
	public static boolean checkPassword(String username, String password) {
		boolean correctPassword = false;

		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		
	    	        System.out.println("returnindfdf");
					Result result = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' RETURN u.password = '%s' as correct", username, password));
					// We know username exists, so password exists
					Record record = result.next();
					correctPassword = record.get("correct").asBoolean();
			        System.out.println("returning: " + correctPassword);

					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        System.out.println("returning: " + correctPassword);
	        return correctPassword;
	}
	
    // DB command for upadting user password
    public static void updateUserPassword(String username, String newPassword) {
        System.out.println("updating password");
        System.out.println(newPassword);
        try (Session session = Connect.driver.session()) {
        	try(Transaction tx = session.beginTransaction()){
        		 tx.run(String.format( "MATCH (u:user) WHERE u.username = '%s' SET u.password = '%s'", username, newPassword));               
        	     tx.commit();
        	     tx.close();
        	                session.close();
        	}
             
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }
    
    // DB command for upadting user status
    public static void updateUserContact(String username, String email, String phoneNumber){
        System.out.println("updating contact info");

        try (Session session = Connect.driver.session()) {
               	try(Transaction tx = session.beginTransaction()){
               		 tx.run(String.format( "MATCH (u:user) WHERE u.username = '%s' SET u.email = '%s', u.phoneNumber = '%s'", username, email, phoneNumber));               
               	     tx.commit();
               	     tx.close();
               	                session.close();
               	}
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }

    // DB command for upadting user status
    public static void updateUserInfo(String username, String firstname, String lastname, String status, String email, 
                                    String about, String dob, String acs){
        
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (u:user) WHERE u.username = $username SET u.firstname = $firstname, u.lastname = $lastname, u.status = $status, u.email = $email, u.about = $about, u.dob = $dob, u.acs = $acs",
                parameters("username", username, "firstname", firstname, "lastname",lastname, "status", status, "email", email, "about", about, "dob", dob, "acs", acs)));
            
            session.close();
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }
    
    // DB command for getting user status
    public static Record getUserInfo(String username){
        try (Session session = Connect.driver.session()) {
            try (Transaction tx = session.beginTransaction()) {
              Result node_result = tx.run("MATCH (u:user) WHERE u.username = $username WITH u RETURN u.username as username, u.firstname as firstname, u.lastname as lastname, u.email as email, u.dob as dob, u.about as about, u.phoneNumber as phoneNumber, u.status as status, toInteger(u.acs) as acs",
              parameters("username", username));
      
              // If any results have been returned, return the record
              if (node_result.hasNext()) {
                return node_result.next();
              }
            }
        }
        return null;
    }
    
}