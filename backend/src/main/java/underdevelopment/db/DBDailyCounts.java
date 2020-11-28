package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.time.LocalDate;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBDailyCounts{
	
	
	public static int getCount(String username, String activity, String dateName) {
		int remainingPlays = 0;
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		// Check if we need to reset our activity's count
	        		resetCheck(username, activity, dateName);
	    	        System.out.println("getting trivia Count");
	        		int plays;
					Result result = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' RETURN u.%s as plays", username, activity));
					if(result.hasNext()) {
						Record rec = result.next();
						remainingPlays = rec.get("plays").asInt();
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
	        return remainingPlays;
	}
	
	public static void resetCheck(String username, String activity, String dateName) {
		String curDate =  LocalDate.now().toString();
		try(Session session = Connect.driver.session()){
			try(Transaction tx = session.beginTransaction()){
    	        Result trivPlays = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' return u.%s as lastTriviaDate", username, dateName));
        		if(trivPlays.hasNext()) {
        			String lastDate = trivPlays.next().get("lastTriviaDate").asString();
        			if(lastDate.equals("null")) {
        				tx.run(String.format(String.format("MATCH (u:user) WHERE u.username = '%s' SET u.%s = '%s'", username,dateName, curDate )));
        				lastDate = curDate;
        			}
	        		// If his last played for trivia was ystd, then we reset their plays.
	        		// str1.compareTo(str2) returns 1 if str1 > str2, -1 if str2 < str1, 0 if same
        			// If current date is bigger than lastDate, we can reset the counts
	        		if(curDate.compareTo(lastDate) > 0) {
	        			tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' SET u.%s = '%s', u.%s = 5", username, dateName,curDate, activity));
	        			System.out.println(String.format("MATCH (u:user) WHERE u.username = '%s' SET u.%s = '%s', u.%s = 5", username, dateName,curDate, activity));
	        		}else {
	        			System.out.println("wtf man");
	        		}
	        		tx.commit();
        		}
        		tx.close();	
			}
		}
	}
	
	public static boolean subtractTriviaCount(String username, String activity) {
		boolean successfulChange = false;

		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		
	    	        System.out.println("subtracting");
					Result result = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' SET u.%s = u.%s - 1", username, activity, activity));
					// We know username exists, so password exists
					tx.commit();
					tx.close();
					session.close();
					successfulChange = true;
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return successfulChange;
	}
    
	public static boolean resetCount(String username, String activity) {
		boolean successfulChange = false;
		
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		
	    	        System.out.println("resetting the " + activity);
					Result result = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' SET u.%s = 5", username, activity));
					// We know username exists, so password exists
					tx.commit();
					tx.close();
					session.close();
					successfulChange = true;
	        	}catch(Exception e) {
	        		e.printStackTrace();
	        	}
	        }catch(Exception e) {
        		e.printStackTrace();
        	}
	        return successfulChange;
	}
	
	
	
	
    
}