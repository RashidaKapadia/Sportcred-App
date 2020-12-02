package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.util.ArrayList;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBNotifications {
	
	// give category: "multiTrivia" for trivia
	// infoID is for the trivia ID
	// title is well a title.
	public static int createNotification(String username, String type, String category, int ID, String title) {
		int notifID = -1;

		try (Session session = Connect.driver.session()) {
			try (Transaction tx = session.beginTransaction()) {
				System.out.println("getting trivia Count");
				
				// See if the person has any notifications
				Result result = tx.run(String.format("MATCH(u:user) WHERE (u.username = \"%s\")"
						+ "RETURN EXISTS((u)-[:hasANotification]->()) as notification", username));
				Boolean hasNotification = result.next().get("notification").asBoolean();
				if(hasNotification) {
					tx.run(String.format(
							"MATCH(m {username: '%s'}) -[r:hasANotification]->(o)" +  
							"CREATE (n:notification) SET n.type = \"%s\", n.category = \"%s\", n.infoID = %d, n.title = \"%s\", n.read = False " + 
							"CREATE ((m)-[h:hasANotification]-> (n))" + 
							"CREATE ((n)-[i:hasANotification]-> (o))" + 
							"DELETE r", username, type, category, ID, title));
				}else {
					tx.run(String.format("MATCH(u:user) WHERE (u.username = '%s')" +
									"CREATE (n:notification) SET n.type = \"%s\", n.category = \"%s\", n.infoID = %d, n.title = \"%s\", n.read = False " + 
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
	
	public static int markRead( int[] IDs) {
		int notifID = -1;

		try (Session session = Connect.driver.session()) {
			try (Transaction tx = session.beginTransaction()) {
				for(int i = 0; i < IDs.length; i++) {
					tx.run(String.format("match(n:notification) WHERE  ID(n) = %d SET n.read = True", IDs[i]));
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
	
	
	public static ArrayList<ArrayList<String>> getNotification(String username ) {
		 /*
		  * MATCH (tgtUser:user { username:"banana420" })-[:ACSRecord *1..]->(ACSRecord: ACSRecord)
		  * RETURN ACSRecord.amount, ACSRecord.date;
		  */
		ArrayList<ArrayList<String>> retVal = new ArrayList<ArrayList<String>>();

		 System.out.println("running the getting ACS");
		 try (Session session = Connect.driver.session()) {
		    	try (Transaction tx = session.beginTransaction()) {
		    		Result result = tx.run(String.format("MATCH (tgtUser:user { username: '%s' })-[:hasANotification *1..]->(n: notification)"
		    				+ " RETURN ID(n) as ID, n.type as type, n.category as category, n.title as title, n.infoID as infoID, n.read as read", username) );
		    		
		    		// I use String cause it auto fills with null.
		    		ArrayList<String> ID = new ArrayList<String>();
		    		ArrayList<String> type = new ArrayList<String>();
		    		ArrayList<String> category = new ArrayList<String>();
		    		ArrayList<String> title = new ArrayList<String>();
		    		ArrayList<String> infoID = new ArrayList<String>();
		    		ArrayList<String> read = new ArrayList<String>();
		    		
		    		retVal.add(ID);
		    		retVal.add(type);
		    		retVal.add(category);
		    		retVal.add(title);
		    		retVal.add(infoID);
		    		retVal.add(read);

		    		int i = 0;
		    		System.out.println("looping stuff");
		    		while(result.hasNext()) {
		    			Record data = result.next();
		    			ID.add(Integer.toString(data.get("ID").asInt()));
		    			category.add(data.get("category").asString());
		    			type.add(data.get("type").asString());
		    			title.add(data.get("title").asString());
		    			infoID.add(Integer.toString(data.get("infoID").asInt()));
		    			read.add(Boolean.toString(data.get("read").asBoolean()));
		    			i++;
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
	
	
	public static int deleteNotification( int[] IDs) {
		int notifID = 1;

		try (Session session = Connect.driver.session()) {
			try (Transaction tx = session.beginTransaction()) {
				for(int i = 0; i < IDs.length; i++) {
					System.out.println("hello tere");
					Result result = tx.run(String.format("MATCH (n:notification) WHERE ID(n) = %d OPTIONAL MATCH (n)-[r:hasANotification]->(a) RETURN  CASE WHEN a is null THEN False ELSE True End As hasNext" , IDs[i]));
					Record record= result.next();
					Boolean found = record.get("hasNext").asBoolean();
					// found is true if they are in the middle
					if(found) {
						tx.run(String.format("MATCH (n:notification) WHERE ID(n) = %d "
								+ "MATCH (n)-[r:hasANotification]->(a) "
								+ "MATCH (n)<-[r2:hasANotification]-(p) "
								+ "DELETE r, r2, n "
								+ "CREATE (p)-[:hasANotification]->(a) "
								+ "", IDs[i]));
					}else {
						tx.run(String.format("MATCH (n:notification) WHERE ID(n) = %d MATCH (n)<-[r:hasANotification]-(p) DELETE r, n ", IDs[i]));
					}
				}
				tx.commit();
				tx.close();
				session.close();
			} catch (Exception e) {
				e.printStackTrace();
				return -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		return notifID;
	}

}