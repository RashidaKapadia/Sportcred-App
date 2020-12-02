package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.util.ArrayList;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBParticipation {
	
	// Participation mark: 0.5 points ; capped at a total ACS to a max of 10% of current ACS.
	// Returns -1 if failed
	// Returns new part mark if success
	public static double editParticipation(String username, double amount, Transaction tx) {
		double retVal = -1;

		System.out.println("getting trivia Count");
		
		// First, we get their current participation mark and acs
		Result result = tx.run(String.format("MATCH(u:user) WHERE (u.username = '%s')"
				+ "RETURN u.participation as participation, u.acs as acs", username));
		Record user = result.next();
		int acs = user.get("acs").asInt();
		double participation = user.get("participation", 0.0);
		System.out.println(participation);
		System.out.println(acs);
		// Make sure we aren't above the threshold before we give him more marks
		int threshold = (int) acs/10;
		if(participation < threshold) {
			result = tx.run(String.format("MATCH(u:user) WHERE (u.username = '%s') SET u.participation = %f RETURN u.participation as participation", username, participation + amount));
			user = result.next();
			retVal = user.get("participation").asDouble();
		}else {
			retVal = participation;
		}
		
		return retVal;
	}
	
	public static double getParticipation(String username) {
		double retVal = -1;
		try (Session session = Connect.driver.session()) {
			try (Transaction tx = session.beginTransaction()) {
				System.out.println("getting trivia Count");
				
				// First, we get their current participation mark and acs
				Result result = tx.run(String.format("MATCH(u:user) WHERE (u.username = '%s')"
						+ "RETURN u.participation as participation", username));
				Record user = result.next();
				double participation = user.get("participation", 0.0);
				retVal = participation;
				
				tx.commit();
				tx.close();
				session.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return retVal;
	}


}