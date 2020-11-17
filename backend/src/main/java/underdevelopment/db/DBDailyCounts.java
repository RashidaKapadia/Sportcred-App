package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBDailyCounts{
	
	
	public static int getCount(String username, String activity) {
		int remainingPlays = 0;
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		int plays;
	    	        System.out.println("getting trivia Count");
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