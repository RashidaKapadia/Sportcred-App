package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBVoteResponse {
	

	/*
	 * /api/debate/vote-response

	Parameters
	{
	Id: “response123”,
		usernames: [ bob, alice, mallory],
	ratings: [0.4, 0.5, 0.3]
	}
	
	Return 
	{
	avgRating: 0.48
	}

	 */
	// Find the appropriate response
	// Add the list of usernames to the record
	// Calculate new average rating
	// Call participation for all 3 users.
	public static double voteResponse(String group, List<String> usernames, List<Double> ratings) {
		double retVal = -1;
		try (Session session = Connect.driver.session()) {
			try (Transaction tx = session.beginTransaction()) {
				System.out.println("Adding the vote response");
				
				// Find the appropriate response group
				Result tgtGroup = tx.run(String.format("MATCH(u:DebateGroup) WHERE (u.id = '%s')"
						+ "RETURN u.userList as userList, u.avgScore as avgScore", group));
				Record record = tgtGroup.next();
				List<String> users = (List<String>) record.get("userList", new ArrayList<String>());
				List<String> curUsernames = new ArrayList<String>();
				for(int i = 0; i < users.size(); i++) {
					curUsernames.add(users.get(i));
				}
				double avgScore = record.get("avgScore",0.0);
				long size = curUsernames.size();
				double totalScore = avgScore * size;
				boolean contains = false;
				// Check if usernames is in our list already. Return -1 if it is.
				// We add all the ratings to total score and calculate new average
				// Also add that user
				for(int i = 0; i < usernames.size(); i++) {
					if(curUsernames.contains(usernames.get(i))) {
						return -1;
					}else {
						totalScore += ratings.get(i);
						curUsernames.add(usernames.get(i).toString());
					}
				}
				JSONArray jsonArr = new JSONArray();
				
				for(int i = 0; i < curUsernames.size(); i++) {
					jsonArr.put(curUsernames.get(i));
				}
				tx.run(String.format("MATCH(u:DebateGroup) WHERE (u.id = '%s')"
						+ "SET u.userList = %s, u.avgScore = %f", group, jsonArr.toString(), totalScore/curUsernames.size()));
				retVal = totalScore/curUsernames.size();
				// Give everyone a participation mark
				for(int i = 0; i < usernames.size(); i++) {
					DBParticipation.editParticipation(usernames.get(i), 0.5, tx);
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
		
		return retVal;
	}



}