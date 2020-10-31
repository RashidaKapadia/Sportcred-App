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
	 public static int editACS(String username, int ammount, String date) {
		 System.out.println("editing ACS");
		 Record record;
		 Record data = null;
		 int newACS;
		 try (Session session = Connect.driver.session()) {
	    	try (Transaction tx = session.beginTransaction()) {
	    		// Update the person's ACS score
				Result result = tx.run(String.format("MATCH (n { username: '%s' }) SET n.acs = %d + toInteger(n.acs)  RETURN n.username as username, n.acs as acs", username, ammount));
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
							+ "CREATE (n:ACSRecord { ammount: %d, date: '%s' })"
							+ "CREATE ((m)-[h:ACSRecord]-> (n))"
							+ "CREATE ((n)-[i:ACSRecord]-> (o))"
							+ "DELETE r "
							, username, ammount, date));
	    		}else {
	    			System.out.println("has no next");
	    			tx.run(String.format("MATCH (n:user {username: '%s'})" + 
	    					"CREATE (m:ACSRecord { ammount: %d, date: '%s' })" + 
	    					"CREATE (n)-[:ACSRecord]->(m)", username, ammount, date));
	    		}		

				tx.commit();
				System.out.println("new acs is is gonna be: " + newACS);
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
	  * Finds the corresponding user's ACS, returns an array of length limit, with each element containing the ACS change. If we ask for more records than there are items, the array has null
	  */
	 public static String[][] getACS(String username, int limit) {
		 /*
		  * MATCH (tgtUser:user { username:"banana420" })-[:ACSRecord *1..]->(ACSRecord: ACSRecord)
		  * RETURN ACSRecord.ammount, ACSRecord.date;
		  */
 		String[][] retVal = new String[2][];

		 System.out.println("running the getting ACS");
		 try (Session session = Connect.driver.session()) {
		    	try (Transaction tx = session.beginTransaction()) {
		    		Result result = tx.run(String.format("MATCH (tgtUser:user { username: '%s' })-[:ACSRecord *1..%d]->(ACSRecord: ACSRecord)"
		    				+ " RETURN ACSRecord.ammount as ammount, ACSRecord.date as date", username, limit) );
		    		
		    		// I use String cause it auto fills with null.
		    		String ammounts[] = new String[limit];
		    		String dates[] = new String[limit];
		    		retVal[0] = ammounts;
		    		retVal[1] = dates;
		    		int i = 0;
		    		System.out.println("looping stuff");
		    		while(result.hasNext() && i < limit) {
		    			Record data = result.next();
		    			ammounts[i] = Integer.toString(data.get("ammount").asInt());
		    			dates[i]= data.get("date").asString();
		    			//System.out.println(ammounts[i]);
		    			//System.out.println(dates[i]);
		    			i++;
		    		}
		    		System.out.println("We are returning");
		    		for(int j = 0; j < limit; j++) {
		    			System.out.println(retVal[0][j]);
		    			System.out.println(retVal[1][j]);

		    		}
		    	}catch (Exception e) {
	                e.printStackTrace();
	    	        return null;
		    	}
		 }catch (Exception e) {
             e.printStackTrace();
	        return null;
	      }
		 
		 return retVal;
		 
	 }
}
//Result result = session.writeTransaction(tx -> tx.run( String.format("MATCH (n { username: '%s' }) SET n.acs = %d RETURN n.name, n.acs", username, ammount)));
