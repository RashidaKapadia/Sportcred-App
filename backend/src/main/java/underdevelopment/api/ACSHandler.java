package underdevelopment.api;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBAcs;
import underdevelopment.db.DBUserInfo;

public class ACSHandler {
	 public static JsonRequestHandler handleACS() {
		 return (JSONObject jsonObj) -> {
	            String username;
	            int ammount;

	            String response;


	            try {
	                username = jsonObj.getString("username");
	                ammount = jsonObj.getInt("ammount");
	            } catch (Exception e) {
	                return new JsonHttpReponse(Status.BADREQUEST);
	            }
	            
                  
	            // Run the database command 			
	            try {
	            	int newACS = DBAcs.editACS(username, ammount);
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
