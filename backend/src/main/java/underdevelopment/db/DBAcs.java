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
		 Record data = null;
		    try (Session session = Connect.driver.session()) {
		    	try (Transaction tx = session.beginTransaction()) {
					Result result = tx.run(String.format("MATCH (n { username: '%s' }) SET n.acs = %d  RETURN n.username as username, n.acs as acs", username, ammount));
					Record record;
					record = result.next();
	
					System.out.println("new acis is gonna be: " + record.get("acs"));
					session.close();
					return record.get("acs").asInt();
				}
		      } catch (Exception e) {
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
