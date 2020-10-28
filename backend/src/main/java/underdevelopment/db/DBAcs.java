package underdevelopment.db;

import org.neo4j.driver.Session;
import static org.neo4j.driver.Values.parameters;

import java.util.List;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Transaction;



public class DBAcs {
	private Driver driver;

	public DBAcs() {
		driver = Connect.driver;
	}
	
	/*
	 * Finds the corresponding user, edits their ACS by that ammount.
	 * Also updates their ACS history
	 * Returns the new ACS on success, and -1 on failure
	 */
	 public static int editACS(String username, int ammount) {
		 System.out.println("editing ACS");
		 Record record;
		 Record data = null;
		 int newACS;
		    try (Session session = Connect.driver.session()) {
		    	try (Transaction tx = session.beginTransaction()) {
		    		// Update the person's ACS score
					Result result = tx.run(String.format("MATCH (n { username: '%s' }) SET n.acs = %d + n.acs  RETURN n.username as username, n.acs as acs", username, ammount));
					//Result result = tx.run("MATCH (n { username: 'banana420' }) SET n.acs = 5556  RETURN n.username as username, n.acs as acs");
		    		record = result.next();
		    		newACS = record.get("acs").asInt();
	    			
		    		
		    		System.out.println("checking");
		    		// Check if the person has played any games at all.
		    		Result result2 = tx.run(String.format("MATCH (n:user {username: '%s'})-[r:ACSRecord]-() RETURN n", username));
		    		System.out.println("checking 2");

		    		if (result2.hasNext()) {
		    			System.out.println("has next");
		    			// Update the person's ACS history
						tx.run(String.format("MATCH(m {username: '%s'}) -[r:ACSRecord]->(o) "
								+ "CREATE (n:ACSRecord { ammount: %d, date: 'placeholder' })"
								+ "CREATE ((m)-[h:ACSRecord]-> (n))"
								+ "CREATE ((n)-[i:ACSRecord]-> (o))"
								+ "DELETE r "
								, username, ammount));
		    		}else {
		    			System.out.println("has no next");
		    			tx.run(String.format("MATCH (n:user {username: '%s'})" + 
		    					"CREATE (m:ACSRecord { ammount: %d, date: 'placeholder' })" + 
		    					"CREATE (n)-[:ACSRecord]->(m)", username, ammount));
		    		}
		    		
					
					
					System.out.println("new acs is is gonna be: " + newACS);

					tx.commit();
					tx.close();
				}
		    	
		    	session.close();
				return newACS;
		      } catch (Exception e) {
	                e.printStackTrace();
		        return -1;
		      }
	 }
	 
	 /*
	  * Finds the corresponding user's ACS
	  */
	 public static int getACS(String username) {
		 
		 
		 
		 return 2;
		 
	 }
}
//Result result = session.writeTransaction(tx -> tx.run( String.format("MATCH (n { username: '%s' }) SET n.acs = %d RETURN n.name, n.acs", username, ammount)));
