package underdevelopment.api;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBDailyCounts;
import underdevelopment.db.DBTrivia;
import underdevelopment.db.DBUserInfo;

public class DailyCountHandler {
    
    // Multiplayer stuff
    public static JsonRequestHandler resetCount() {
        return (JSONObject jsonObj) -> {

            System.out.println("resetting trivia count");
            String username, activity;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                activity = jsonObj.getString("activity");

            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            
            // Check if the username exists
            if ( ! DBUserInfo.checkUsernameExists(username) ) {
          	  try {
                  String response = new JSONObject()
                      .put("Error", "Username doesn't exist")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }

            // Get questions from the db
            Boolean success = DBDailyCounts.resetCount(username, activity + "Plays"); 
            		//DBTrivia.resetTriviaCount(username);
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = new JSONObject()
                    .put("questions", questionsJSON)
                    .toString();

                return new JsonHttpReponse(Status.OK, null);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }   
    
    public static JsonRequestHandler subtractCount() {
        return (JSONObject jsonObj) -> {

            System.out.println("resetting trivia count");
            String username, activity;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                activity = jsonObj.getString("activity");
                
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            
            // Check if the username exists
            if ( ! DBUserInfo.checkUsernameExists(username) ) {
          	  try {
                  String response = new JSONObject()
                      .put("Error", "Username doesn't exist")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }

            // Get questions from the db
            Boolean success = DBDailyCounts.subtractTriviaCount(username, activity + "Plays");
            		//DBTrivia.subtractTriviaCount(username);
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = new JSONObject()
                    .put("questions", questionsJSON)
                    .toString();

                return new JsonHttpReponse(Status.OK, null);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
    
    public static JsonRequestHandler getCount() {
        return (JSONObject jsonObj) -> {

            System.out.println("getting trivia count");
            String username, activity;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                activity = jsonObj.getString("activity");
                
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Check if the username exists
            if ( ! DBUserInfo.checkUsernameExists(username) ) {
          	  try {
                  String response = new JSONObject()
                      .put("Error", "Username doesn't exist")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }           
            // Get questions from the db
            int remainingPlays = DBDailyCounts.getCount(username, activity + "Plays");
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = new JSONObject()
                	.put("available", remainingPlays > 0)
                    .put("gamesLeft", remainingPlays)
                    .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }   
    
 
}
