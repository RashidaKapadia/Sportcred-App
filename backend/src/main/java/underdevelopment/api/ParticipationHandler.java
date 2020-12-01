package underdevelopment.api;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.neo4j.driver.Record;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBNotifications;
import underdevelopment.db.DBParticipation;
import underdevelopment.db.DBUserInfo;


public class ParticipationHandler {
	
	// This was just for testing. not used anymore
	/*
    public static JsonRequestHandler editParticipation() {
        return (JSONObject jsonObj) -> {
        	String username;
            // Get input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            String response;

            // Run DB command            
            try {
            	double newScore = DBParticipation.editParticipation(username, 0.5);
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
   */
}