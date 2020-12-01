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


	 */
	// Find the appropriate response
	// Calculate new average rating for that response
	// Call participation for the voter.
	public static double voteResponse(String group, List<Long> IDs, List<Double> ratings, String voter) {
		double retVal = -1;
		try (Session session = Connect.driver.session()) {
			try (Transaction tx = session.beginTransaction()) {
				// Make sure he hasn't voted yet.
				boolean valid = checkVotedUsers(tx, group, voter);
				if(! valid) {
					return -1;
				}
				// Change the ratings.
				for(int i = 0; i < IDs.size(); i++) {
					Result response = tx.run(String.format("match(n:DebateResponse) WHERE ID(n) = %d RETURN n.avgScore as avgScore,  n.count as count", IDs.get(i)));
					Record rating = response.next();
					double avgScore = rating.get("avgScore", 0.0);
					int count = rating.get("count", 0);
					double totalScore = avgScore * count + ratings.get(i);
					count++;
					avgScore = totalScore / count;
					tx.run(String.format("Match(n:DebateResponse) WHERE ID(n) = %d SET n.avgScore  = %f, n.count = %d ", IDs.get(i), avgScore, count));
				}
				DBParticipation.editParticipation(voter, 0.5, tx);

				
				System.out.println("Adding the vote response");
				retVal = 1;
				
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
	
	private static boolean checkVotedUsers(Transaction tx, String group, String voter) {
		// Find the appropriate response group
		Result tgtGroup = tx.run(String.format("MATCH(u:DebateGroup) WHERE (u.id = '%s')"
				+ " RETURN u.userList as userList", group));
		Record record = tgtGroup.next();
		List<String> users = (List<String>) record.get("userList", new ArrayList<String>());
		List<String> curUsernames = new ArrayList<String>();
		for(int i = 0; i < users.size(); i++) {
			curUsernames.add(users.get(i));
		}
		long size = curUsernames.size();
		boolean contains = false;
		// Check if our voter is in our list already. Return -1 if it is.
		// Also add that user
		if(curUsernames.contains(voter)) {
			return false;
		}else {
			curUsernames.add(voter);
		}
		
		JSONArray jsonArr = new JSONArray();
		
		for(int i = 0; i < curUsernames.size(); i++) {
			jsonArr.put(curUsernames.get(i));
		}
		tx.run(String.format("MATCH(u:DebateGroup) WHERE (u.id = '%s') SET u.userList = %s", group, jsonArr.toString()));
		return true;
	}



}