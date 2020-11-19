package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;
import java.time.LocalDate;

public class DBTrivia{
	/*
	 * Backend generates list of questions (maybe use existing DB method)
		Pass those questions so we can make our TriviaInProgressMulti node
		Backend removes 1 daily invite from the user
		creates a TriviaInProgressMulti node,  
		updates the node with game and users
		creates a notification node for the other user
		sends the frontend the game

	 */
	
	public static int startMultiplayerTrivia(String username, String oppUsername) {
		int ID = -1;
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		// Generate a list of questions'
	        		 ArrayList<Map<String, Object>> questions = DBQuestion.getQuestions("basketball", 10);
	        		 
	        		 // Insert the question IDs into an array
	        		 long questionSequence[] = new long[10];
	        		 for(int i = 0; i < questions.size(); i++) {
	        			 questionSequence[i] = (long) questions.get(i).get("questionId");
	        			 System.out.println(questionSequence[i]);
	        		 }
	        		// removes 1 daily invite from the user
	        		DBDailyCounts.subtractTriviaCount(username, "triviaMultiPlays");
	        		
	        		// Get current date
	        		String curDate = LocalDate.now().toString();
	        		
	        		// Create TriviaInProgressMulti node
	        		/*	TriviaInProgressMulti
	        		 * 	> ID				-Auto created
	        		 * 	> questionSequence	-From above
	        		 * 	> inviterUsername	- Username
	        		 * 	> oppUsername		- Given
	        		 * 	> inviterAnswers	- Create empty?
	        		 * 	> oppAnswers		- Create empty?
	        		 * 	> inviterScore		- Create empty?
	        		 * 	> oppScore		- Create empty?
	        		 * 	> inviteDate		- today's date
	        		 * 	> acceptDate
	        		 */
	        		Result result = tx.run(String.format("CREATE (n:triviaInProgress) SET n.questionSequence = %s,"
	        				+ " n.inviterUsername = '%s' , "
	        				+ "n.oppUsername  = '%s', "
	        				+ "n.inviterAnswers = null, "
	        				+ "n.oppAnswers = null, "
	        				+ "n.inviterScore = null, "
	        				+ "n.oppScore = null, "	        				
	        				+ "n.inviteDate = '%s', "
	        				+ "n.acceptDate = null "
	        				+ "RETURN ID(n) As ID", Arrays.toString(questionSequence), username, oppUsername, curDate ));
	        		// Send frotend the game 
	        		ID = result.next().get("ID").asInt();
	        		
	        		// Create the notifications
	        		//DBNotifications.createNotification(username, "trivia", "triviaMultiPlays", ID, "new trivia game");
	        		DBNotifications.createNotification(oppUsername, "invite", "trivia", ID, username + " has invited you to play multiplayer trivia! Are you up for the challenge?");

					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return ID;
	}
	
	
	
	// Returns 1 if succress, -1 if fails.
	/*
	 * 	List of answers get and scores get sent to the backend, and updated in the gameID
		Last one that finishes adds the notifications to both users
		Winner gets 5 points, the loser loses 5 points.
		Update Accept date
		Updates ASC score for players
		Updates ACS history for players

	 */
	public static int endMultiplayerTrivia(String username, int gameID,  int gameScore, String answerString) {
		int success = -1;
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		System.out.println("hello");
	        		// Create TriviaInProgressMulti node
	        		/*	TriviaInProgressMulti
	        		 * 	> ID				- We find using this
	        		 * 	> questionSequence	- Already Exists
	        		 * 	> inviterUsername	- Username
	        		 * 	> oppUsername		- Given
	        		 * 	> inviterAnswers	- answers
	        		 * 	> oppAnswers		- Create empty?
	        		 * 	> inviterScore		- gameScore
	        		 * 	> oppScore		- Create empty?
	        		 * 	> inviteDate		- Already Exists
	        		 * 	> acceptDate		- Today's date (if we are the opponent)
	        		 */
	        		
	        		// Check the gameID to find out if we are the inviter or the opponent
	        		Result result = tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d RETURN n.inviterUsername as inviterUsername, n.oppUsername as oppUsername", gameID));
	        		Record record = result.next();
	        		String inviterUsername = record.get("inviterUsername").asString();
	        		String oppUsername = record.get("oppUsername").asString();
	        		System.out.println("inviterUsername is: " + inviterUsername);
	        		System.out.println("oppUsername is: " + oppUsername);
	        		String curDate =  LocalDate.now().toString();
	        		if(username.equals(inviterUsername)) {
	        			System.out.println("we are the inbiter");
	        			// Update inviterAnswers and inviterScore
	        			tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d SET n.inviterAnswers = '%s', n.inviterScore = %d", gameID, answerString, gameScore));
	        		}else if(username.equals(oppUsername)) {
	        			System.out.println("we are the opponent");
	        			// Update opponentAnswers, opponentScore and acceptDate
	        			tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d SET n.oppAnswers = '%s', n.oppScore = %d, n.acceptDate = '%s'", gameID, answerString, gameScore,curDate));
	        		}else {
	        			return -1;
	        		}
	        		
	        		// check to see if both scores exist
	        		result = tx.run(String.format("MATCH (n:triviaInProgress) WHERE ID(n) = %d RETURN"
	        				+ " CASE WHEN ( n.inviterScore is not null) and (n.oppScore is not null) "
	        				+ "THEN True ELSE False END as gameCompleted", gameID));
	        		Boolean gameCompleted = result.next().get("gameCompleted").asBoolean();
	        		
	        		// If yes, then we got a lot more stuff to do
	        		if(gameCompleted) {
	        			// Check who scored more
	        			System.out.println("game completed");
	        			// Winner gets 5 points, loser gets -5 points, draw means both get 0 points
	        			// Give a notification to both of them
	        			result = tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d RETURN n.inviterScore as inviterScore, n.oppScore as oppScore", gameID));
	        			record = result.next();
	        			int inviterScore = record.get("inviterScore").asInt();
	        			int oppScore = record.get("oppScore").asInt();
	        			if(inviterScore < oppScore) {
	        				System.out.println("opponent wins");
	        				// inviter loses 5 points
	        				DBAcs.editACS(inviterUsername, -5, oppUsername, "trivia", curDate);
	        				// opponent gets 5 points
	        				DBAcs.editACS(oppUsername, 5, inviterUsername, "trivia", curDate);
	        				
	        				//createNotification(String username, String type, String category, int ID, String title) 
	        			}else if(inviterScore > oppScore) {
	        				System.out.println("inviter wins");
	        				// inviter gets 5 points
	        				DBAcs.editACS(inviterUsername, 5, oppUsername, "trivia", curDate);
	        				// opponent loses 5 points
	        				DBAcs.editACS(oppUsername, -5, inviterUsername, "trivia", curDate);
	        			}else {
	        				System.out.println("draw");
	        				// both get 0 points
	        				DBAcs.editACS(inviterUsername, 0, oppUsername, "trivia", curDate);
	        				// opponent loses 5 points
	        				DBAcs.editACS(oppUsername, 0, inviterUsername, "trivia", curDate);
	        			}
        				DBNotifications.createNotification(inviterUsername, "results", "trivia", gameID, "Multiplayer trivia results between " + inviterUsername + " and " + oppUsername + " are in!");
        				DBNotifications.createNotification(oppUsername, "results", "trivia", gameID, "Multiplayer trivia results between " + inviterUsername + " and " + oppUsername + " are in!");

	        		}
	        		// Send frotend the game 
					tx.commit();
					tx.close();
					session.close();
	        		success = 1;

	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return success;
	}
	
	// Create TriviaInProgressMulti node
	/*	TriviaInProgressMulti
	 * 	> ID				- We find using this
	 * 	> questionSequence	- Already Exists
	 * 	> inviterUsername	- Username
	 * 	> oppUsername		- Given
	 * 	> inviterAnswers	- answers
	 * 	> oppAnswers		- Create empty?
	 * 	> inviterScore		- gameScore
	 * 	> oppScore			- Create empty?
	 * 	> inviteDate		- Already Exists
	 * 	> acceptDate		- Today's date (if we are the opponent)
	 */
	
	public static ArrayList<Map<String, Object>> getMultiplayerTrivia(int gameID, String username) {
		ArrayList<Map<String, Object>> retVal = new ArrayList<Map<String, Object>>();
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		// Find out if we are the inviter or opponent
	        		Result result = tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d RETURN n.inviterUsername as  inviterUsername, "
	        				+ " n.oppUsername as oppUsername, "
	        				+ "n.inviterScore as inviterScore,"
	        				+ "n.oppScore as oppScore, "
	        				+ "n.inviterAnswers as inviterAnswers, "
	        				+ "n.oppAnswers as oppAnswers", gameID));
	        		Record record = result.next();
	        		String inviterUsername = record.get("inviterUsername").asString();
	        		String oppUsername = record.get("oppUsername").asString();
	        		int inviterScore = record.get("inviterScore").asInt();
	        		int oppScore = record.get("oppScore").asInt();
	        		String inviterAnswers = record.get("inviterAnswers").asString();
	        		String oppAnswers = record.get("oppAnswers").asString();	        		
	        		
	        		System.out.println(inviterAnswers);
	        		System.out.println(oppAnswers);

	        		// The first element is "you"
	        		// Find and insert the username, gameScore and answers
	        		// The second element is "otherPlayer"
        			Map<String, Object> you = new HashMap<String, Object>();
        			HashMap<String, Object> opponent = new HashMap<String, Object>();
	        		if(username.equals(inviterUsername)) {
	        			you.put("username", inviterUsername);
	        			you.put("gameScore", Integer.toString(inviterScore));
	        			you.put("answers", inviterAnswers);
	        			opponent.put("username", oppUsername);
	        			opponent.put("gameScore", Integer.toString(oppScore));
	        			opponent.put("answers", oppAnswers);
	        		}else if(username.equals(oppUsername)) {
	        			opponent.put("username", inviterUsername);
	        			opponent.put("gameScore", Integer.toString(inviterScore));
	        			opponent.put("answers", inviterAnswers);
	        			you.put("username", oppUsername);
	        			you.put("gameScore", Integer.toString(oppScore));
	        			you.put("answers", oppAnswers);
	        		}else {
	        			return null;
	        		}
	        		retVal.add(you);
	        		retVal.add(opponent);
	        		
					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return retVal;
	}
	
	
	public static ArrayList<Map<String, Object>>  joinMultiplayerTrivia(int gameID) {
		ArrayList<Map<String, Object>> retVal = new ArrayList<Map<String, Object>>();
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		// Find out if we are the inviter or opponent
	        		Result result = tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d RETURN n.questionSequence as questionSequence", gameID));
	        		Record record = result.next();
	        		List questionSequence = record.get("questionSequence").asList();
	        		int questions[] = new int[questionSequence.size()];
	        		for(int i =0; i < questions.length; i++) {
	        			questions[i] = Integer.valueOf(String.valueOf(questionSequence.get(i)));
	        			System.out.println(questions[i]);
	        		}
	        		retVal = DBQuestion.getSpecificQuestions(questions);
					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return retVal;
	}
	
	public static String  getMultiplayerTriviaInviter(int gameID) {
		String retVal = null;
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		// Find out if we are the inviter or opponent
	        		Result result = tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d RETURN n.inviterUsername as inviterUsername", gameID));
	        		Record record = result.next();
	        		retVal = record.get("inviterUsername").asString();
					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return retVal;
	}
	
	public static String  getMultiplayerTriviaInviteDate(int gameID) {
		String retVal = null;
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		// Find out if we are the inviter or opponent
	        		Result result = tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d RETURN n.inviteDate as inviteDate", gameID));
	        		Record record = result.next();
	        		retVal = record.get("inviteDate").asString();
					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return retVal;
	}
    
	public static String  getMultiplayerTriviaAcceptDate(int gameID) {
		String retVal = null;
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		// Find out if we are the inviter or opponent
	        		Result result = tx.run(String.format("match(n:triviaInProgress) WHERE ID(n) = %d RETURN n.acceptDate as acceptDate", gameID));
	        		Record record = result.next();
	        		retVal = record.get("acceptDate").asString();
					tx.commit();
					tx.close();
					session.close();
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return retVal;
	}
}