package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBNotifications {
	
	public static int createNotification(String username, String type, String category, int ID, String title) {
		int notifID = -1;

		try (Session session = Connect.driver.session()) {
			try (Transaction tx = session.beginTransaction()) {
				System.out.println("getting trivia Count");
				
				// See if the person has any notifications
				Result result = tx.run(String.format("MATCH(u:user) WHERE (u.username = '%s')"
						+ "RETURN EXISTS((u)-[:hasANotification]->()) as notification", username));
				Boolean hasNotification = result.next().get("notification").asBoolean();
				if(hasNotification) {
					tx.run(String.format(
							"MATCH(m {username: '%s'}) -[r:hasANotification]->(o)" +  
							"CREATE (n:notification) SET n.type = '%s', n.category = '%s', n.infoID = %d, n.title = '%s', n.read = False" + 
							"CREATE ((m)-[h:hasANotification]-> (n))" + 
							"CREATE ((n)-[i:hasANotification]-> (o))" + 
							"DELETE r", username, type, category, ID, title));
				}else {
					tx.run(String
							.format("MATCH(u:user) WHERE (u.username = '%s')" +
									"CREATE (n:notification) SET n.type = '%s', n.category = '%s', n.infoID = %d, n.title = '%s', n.read = False" + 
									"CREATE(u)-[r:hasANotification]->(n) ", username, type, category, ID, title));	
				}
			
				tx.commit();
				tx.close();
				session.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return notifID;
	}
	
	public static String[][] getNotification(String username, int limit) {
		 /*
		  * MATCH (tgtUser:user { username:"banana420" })-[:ACSRecord *1..]->(ACSRecord: ACSRecord)
		  * RETURN ACSRecord.amount, ACSRecord.date;
		  */
		String[][] retVal = new String[6][];

		 System.out.println("running the getting ACS");
		 try (Session session = Connect.driver.session()) {
		    	try (Transaction tx = session.beginTransaction()) {
		    		Result result = tx.run(String.format("MATCH (tgtUser:user { username: '%s' })-[:hasANotification *1..]->(n: notification)"
		    				+ " RETURN n.category, n.infoID", username) );
		    		
		    		// I use String cause it auto fills with null.
		    		String ID[] = new String[limit];
		    		String type[] = new String[limit];
		    		String category[] = new String[limit];
		    		String title[] = new String[limit];
		    		String infoID[] = new String[limit];
		    		String read[] = new String[limit];
		    		
		    		retVal[0] = ID;
		    		retVal[1] = type;
		    		retVal[2] = category;
		    		retVal[3] = title;
		    		retVal[4] = infoID;
		    		retVal[5] = read;

		    		int i = 0;
		    		System.out.println("looping stuff");
		    		while(result.hasNext() && i < limit) {
		    			Record data = result.next();
		    			//amounts[i] = Integer.toString(data.get("amount").asInt());
		    			//dates[i]= data.get("date").asString();
		    			//oppUsernames[i] = data.get("oppUsername").asString();
		    			//gameType[i] = data.get("game").asString();
		    			//System.out.println(amounts[i]);
		    			//System.out.println(dates[i]);
		    			i++;
		    		}
		    		/*
		    		System.out.println("We are returning");
		    		for(int j = 0; j < limit; j++) {
		    			System.out.println(retVal[0][j]);
		    			System.out.println(retVal[1][j]);

		    		}
		    		*/
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