package underdevelopment.api;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBDailyCounts;
import underdevelopment.db.DBDailyServer;
import underdevelopment.db.DBUserInfo;

// Handles the resetting of daily server things
public class DailyServerHandler {
	
	public static JsonRequestHandler sendDailyNotification() {
        return (JSONObject jsonObj) -> {
            String username, activity;
            // Get and validate input
           

            // Get questions from the db
            Boolean dailyQuestions = DBDailyServer.sendDailyQuestionNotification();
            
            		//DBTrivia.resetTriviaCount(username);
            return new JsonHttpReponse(Status.OK, null);
           
        };
    }   
}