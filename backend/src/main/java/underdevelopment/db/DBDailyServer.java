package underdevelopment.db;

import java.time.LocalDate;
import java.time.Period;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
						DBNotifications.createNotification(username, "invite",  "debate",  0,  question);
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
	
	public static boolean sendDebateResultNotification() {
		boolean retVal = false;
		// Find ystd's date
		String ystd =  LocalDate.now().minus(Period.ofDays(1)).toString();
		System.out.println(ystd);
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		
	        		// Loop through all the group responses that start with ystd's date
					Result result = tx.run(String.format("MATCH (u:DebateGroup) WHERE u.id =~ '%s' RETURN u.id as ID", ystd + ".*"));
					System.out.println(String.format("MATCH (u:DebateResponse) WHERE u.id =~ '%s' RETURN u.id as ID", ystd + ".*"));
					System.out.println(result.hasNext());
					// Loop through the groups
					while(result.hasNext()) {
						String ID = result.next().get("ID").asString();
						// Get the winner of the group
						Map<String, Object> winner = findWinner(ID, tx);
						String message = "Voting for debate has ended. The winner is: " + winner.get("winner") + " with an average score of: " + winner.get("score"); 
						System.out.println(message);
						// Loop through all the responses and send a notification to all of them
						List<String> responseUsers = DBDebateGroups.getUserList(ID);
						for(int i = 0; i < responseUsers.size(); i++) {
							System.out.println(responseUsers.get(i));
							//	public static int createNotification(String username, String type, String category, int ID, String title) {
							DBNotifications.createNotification(responseUsers.get(i).substring(1,responseUsers.get(i).length() - 1), "results",  "debate",  0,  message);
						}
					}
					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        		return retVal;
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        		return retVal;

        	}
		retVal = true; 
        return retVal;
	}

	
	private static Map<String, Object> findWinner(String groupID, Transaction tx) {
		// Find all responses in the group
		Result responses = tx.run(String.format("MATCH (n:DebateResponse)<-[:hasResponse]-(u:DebateGroup) WHERE u.id = '%s' RETURN n.username as username, ID(n) as ID, n.avgScore as avgScore", groupID));
		double max = 0;
		String winner =null;
		Map<String, Object> retVal =  new HashMap();
		// Loop through the responses in the group
		while(responses.hasNext()) {
			Record response = responses.next();
			String username = response.get("username").asString();
			double cur = response.get("avgScore", 0.0);
			if(max < cur) {
				max = cur;
				winner = username;
			}
		}
		retVal.put("winner", winner);
		retVal.put("score", max);
		System.out.println(winner);
		System.out.println(max);
		return retVal;
	}
}
























