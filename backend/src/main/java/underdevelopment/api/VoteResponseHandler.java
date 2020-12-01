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
        	String groupID, voter;
        	JSONArray responseIDs;
        	JSONArray ratings;
        	List<Long> responseIDsList = new ArrayList<Long>();
        	List<Double> ratingsList = new ArrayList<Double>();
        	
            // Get input
            try {
                groupID = jsonObj.getString("groupId");
                voter = jsonObj.getString("voter");
                responseIDs =  jsonObj.getJSONArray("responseIds");
                ratings = jsonObj.getJSONArray("ratings");
                for(int i = 0; i < responseIDs.length(); i++) {
                	responseIDsList.add(responseIDs.getLong(i));
                	ratingsList.add(ratings.getDouble(i));
                }
            } catch (Exception e) {
            	e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            String response;

            // Run DB command            
            try {
            	// First, we gotta check to make sure our voter isn't one of the responders
            	List<String> groupOwners = DBDebateGroups.getUserList(groupID);
        		if(groupOwners.contains( "\"" + voter + "\"")){
        			response = new JSONObject()
  	                      .put("Error", "You cannot vote in a group you are in")
  	                      .toString();
                    return new JsonHttpReponse(Status.UNAUTHORIZED, response);
        		}
   
            	// Vote
            	double newScore = DBVoteResponse.voteResponse(groupID, responseIDsList, ratingsList, voter); 
            	if(newScore != -1) {
                    return new JsonHttpReponse(Status.OK);
            	}else {
                    return new JsonHttpReponse(Status.SERVERERROR);
            	}
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
   
}