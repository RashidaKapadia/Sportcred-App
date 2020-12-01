package underdevelopment.db;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBDailyServer {
	
	public static boolean sendDailyQuestionNotification() {
		boolean retVal = false;
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		
	        		// Get list of users.
					Result result = tx.run(String.format("MATCH (u:user) RETURN u.username as username"));
					// Loop through the users
					while(result.hasNext()) {
						String username = result.next().get("username").asString();
						// Get the user's tier
						String tier = DBUserInfo.getUserTier(username);
						// Get his daily question
						String question = DBDebateDailyQuestion.getDailyDebateQuestion(tier);
						//createNotification(String username, String type, String category, int ID, String title) 
						DBNotifications.createNotification(username, "notification",  "debate",  0,  question);
					}
					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
		retVal = true; 
        return retVal;
	}

}