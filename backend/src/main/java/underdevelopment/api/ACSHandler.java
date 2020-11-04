package underdevelopment.api;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBAcs;
import underdevelopment.db.DBUserInfo;

public class ACSHandler {
	 public static JsonRequestHandler getACS() {
		 return (JSONObject jsonObj) -> {
			 	System.out.println("getting ACS");
	            String username;
	            int ammount;

	            String response;

	            try {
	                username = jsonObj.getString("username");
	                ammount = jsonObj.getInt("amount");
	            } catch (Exception e) {
	                return new JsonHttpReponse(Status.BADREQUEST);
	            }
	            
	            // Check if the username exists
	            if ( ! DBUserInfo.checkUsernameExists(username) ) {
	          	  try {
	                  response = new JSONObject()
	                      .put("Error", "Username doesn't exist")
	                      .toString();
	                  	return new JsonHttpReponse(Status.CONFLICT, response);
	              } catch (JSONException e) {
	                  e.printStackTrace();
	                  return new JsonHttpReponse(Status.SERVERERROR);
	              }
	            }
	            
	            // Make sure we have a positive number.....
	            if(ammount < 0) {
	            	return new JsonHttpReponse(Status.BADREQUEST);
	            }
	            
	            // Run the database command 			
	            try {
		    		System.out.println("running the edit ACS");

	            	String[][] newACS = DBAcs.getACS(username, ammount);
	                response = new JSONObject()
	                    .put("amount", newACS[0])
	                    .put("date", newACS[1])
	                    .put("oppUserane", newACS[2])
	                    .put("gameType", newACS[3])
	                    .toString();
	               // System.out.println("New ACS is: " + newACS);
	                	return new JsonHttpReponse(Status.OK, response);
	            } catch (JSONException e) {
	                e.printStackTrace();
	                return new JsonHttpReponse(Status.SERVERERROR);
	                
	            } 
	        };
		 
	 }
	 public static JsonRequestHandler handleACS() {
		 return (JSONObject jsonObj) -> {
	            String username, oppUsername, game;
	            int ammount;
	            String date;
	            
	            String response;

	            // Check to make sure the variables exist
	            try {
	                username = jsonObj.getString("username");
	                oppUsername = jsonObj.getString("oppUsername");
	                game = jsonObj.getString("gameType");
	                ammount = jsonObj.getInt("amount");
	                date = jsonObj.getString("date");
	            } catch (Exception e) {
	                return new JsonHttpReponse(Status.BADREQUEST);
	            }
	            
	            // Check if the username exists
	            if ( ! DBUserInfo.checkUsernameExists(username) ) {
	          	  try {
	                  response = new JSONObject()
	                      .put("Error", "Username doesn't exist")
	                      .toString();
	                  	return new JsonHttpReponse(Status.CONFLICT, response);
	              } catch (JSONException e) {
	                  e.printStackTrace();
	                  return new JsonHttpReponse(Status.SERVERERROR);
	              }
	            }
	            // Run the database command 			
	            try {
		    		System.out.println("running the edit ACS");

	            	int newACS = DBAcs.editACS(username, ammount, oppUsername, game, date);
	                response = new JSONObject()
	                    .put("Response", "new ACS is:  " + newACS)
	                    .toString();
	                System.out.println("New ACS is: " + newACS);
	                	return new JsonHttpReponse(Status.OK, response);
	            } catch (JSONException e) {
	                e.printStackTrace();
	                return new JsonHttpReponse(Status.SERVERERROR);
	                
	            } 
	        };
		 
	 }
}
