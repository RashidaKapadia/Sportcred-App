package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBTrivia{
	
	
	public static boolean resetTriviaCount(String username) {
		boolean successfulChange = false;

		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		
	    	        System.out.println("returnindfdf");
					Result result = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' SET u.triviaMultiPlays = 5", username));
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
	
	public static boolean subtractTriviaCount(String username) {
		boolean successfulChange = false;

		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		
	    	        System.out.println("subtracting");
					Result result = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' SET u.triviaMultiPlays = u.triviaMultiPlays - 1", username));
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
    
	public static int getTriviaCount(String username) {
		int remainingPlays = 0;
		
		 try (Session session = Connect.driver.session()){
	        	try (Transaction tx = session.beginTransaction()) {
	        		int plays;
	    	        System.out.println("getting trivia Count");
					Result result = tx.run(String.format("MATCH (u:user) WHERE u.username = '%s' RETURN u.triviaMultiPlays as plays", username));
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
	
	
    
}