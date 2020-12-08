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
					// Loop through the groups
					while(result.hasNext()) {
						// groupID
						String ID = result.next().get("ID").asString();
						// Get the winner of the group
						Map<String, Object> winner = findWinner(ID, tx);
						String message = "Voting for debate has ended and results are now out."; 
						Map<String, Double> avgScores = (Map<String, Double>) winner.get("userScores");
						tx.run(String.format("MATCH (u:DebateGroup) WHERE u.id =~ \"%s\" SET u.winner = \"%s\"",  ID, winner.get("winner")));
						// Loop through all the responses and send a notification to all of them
						List<String> responseUsers = DBDebateGroups.getUserList(ID);
						for(int i = 0; i < responseUsers.size(); i++) {
							System.out.println(responseUsers.get(i));
							String currentUser = responseUsers.get(i).substring(1,responseUsers.get(i).length() - 1);
							//	createNotification(String username, String type, String category, int ID, String title) {
							DBNotifications.createNotification(currentUser, "results",  "debate",  0,  message);
							// how do i get the IDs?
							
							// We need to change their ACS too
							
							int bonus = avgScores.get(currentUser).intValue() + 1;
							if(currentUser == winner.get("winner")) {
								bonus += 5;
							}
							DBAcs.editACS(currentUser,  bonus, null, "debate", LocalDate.now().toString());
							
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

	// Finds the winners. Also stores a map of users -> average score
	// If there is a draw?????
	private static Map<String, Object> findWinner(String groupID, Transaction tx) {
		// Find all responses in the group
		Result responses = tx.run(String.format("MATCH (n:DebateResponse)<-[:hasResponse]-(u:DebateGroup) WHERE u.id = '%s' RETURN n.username as username, ID(n) as ID, n.avgScore as avgScore", groupID));
		double max = 0;
		String winner = null;
		Map<String, Object> retVal =  new HashMap();
		Map<String, Double> scores = new HashMap();
		// Loop through the responses in the group
		while(responses.hasNext()) {
			Record response = responses.next();
			String username = response.get("username").asString();
			double cur = response.get("avgScore", 0.0);
			if(max < cur) {
				max = cur;
				winner = username;
			}else if(max == cur) {
				// No winne
				winner = "draw";
			}
			scores.put(username, cur);
		}
		retVal.put("winner", winner);
		retVal.put("score", max);
		retVal.put("userScores", scores);
		System.out.println("winner for the groups: " + groupID + " is:" +  winner);
		//System.out.println(max);
		return retVal;
	}
}
























