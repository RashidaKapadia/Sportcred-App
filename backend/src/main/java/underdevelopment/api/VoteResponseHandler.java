package underdevelopment.api;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.neo4j.driver.Record;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBDebateGroups;
import underdevelopment.db.DBNotifications;
import underdevelopment.db.DBParticipation;
import underdevelopment.db.DBUserInfo;
import underdevelopment.db.DBVoteResponse;


public class VoteResponseHandler {
	
	/*
		 * {
	Id: “response123”,
		usernames: [ bob, alice, mallory],
	ratings: [0.4, 0.5, 0.3]
	}

	 */
    public static JsonRequestHandler voteResponse() {
        return (JSONObject jsonObj) -> {
        	String groupID;
        	JSONArray usernames;
        	JSONArray ratings;
        	List<String> usernameList = new ArrayList<String>();
        	List<Double> ratingsList = new ArrayList<Double>();
        	
            // Get input
            try {
                groupID = jsonObj.getString("Id");
                usernames =  jsonObj.getJSONArray("usernames");
                ratings = jsonObj.getJSONArray("ratings");
                for(int i = 0; i < usernames.length(); i++) {
                	usernameList.add(usernames.getString(i));
                	ratingsList.add(ratings.getDouble(i));
                }
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            String response;

            // Run DB command            
            try {
            	// First, we gotta check to make sure our usernames aren't in the list
            	List<String> groupOwners = DBDebateGroups.getUserList(groupID);
            	for(int j = 0; j < groupOwners.size(); j++) {
            		System.out.println(groupOwners.get(j));
            	}
            	for(int i = 0; i < usernameList.size(); i++) {
            		if(groupOwners.contains("\"" + usernameList.get(i).toString() + "\"")){
                        return new JsonHttpReponse(Status.UNAUTHORIZED);
            		}
            	}
            	// Insert the usernames in
            	double newScore = DBVoteResponse.voteResponse(groupID, usernameList, ratingsList); 
            	response = new JSONObject()
	                      .put("participation score", newScore)
	                      .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
   
}