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

// Handles the resetting and sending of daily server things
public class DailyServerHandler {

	public static JsonRequestHandler nextDay() {
        return (JSONObject jsonObj) -> {
            String username, activity;
            // Get and validate input
           
            // Create groups for ystd
            DebateGroups.createDebateGroups();
            // Get questions from the db
            Boolean dailyQuestions = DBDailyServer.sendDailyQuestionNotification();
            Boolean debateResults = DBDailyServer.sendDebateResultNotification();

            		//DBTrivia.resetTriviaCount(username);
            if(dailyQuestions && debateResults) {
                return new JsonHttpReponse(Status.OK, null);
            }else {
                return new JsonHttpReponse(Status.SERVERERROR, null);

            }
           
        };
    }   
	
	// Lets all players know that there is a new question
	private static JsonRequestHandler sendDailyNotification() {
        return (JSONObject jsonObj) -> {
            String username, activity;
            // Get and validate input
           

            // Get questions from the db
            Boolean success = DBDailyServer.sendDailyQuestionNotification();
            
            		//DBTrivia.resetTriviaCount(username);
            if(success) {
                return new JsonHttpReponse(Status.OK, null);
            }else {
                return new JsonHttpReponse(Status.SERVERERROR, null);

            }
           
        };
    }   
	
	// Lets the players that participated in debate know their results
	private static JsonRequestHandler sendDebateResultNotification() {
        return (JSONObject jsonObj) -> {
            String username, activity;
            // Get and validate input
            // Get questions from the db
            Boolean success = DBDailyServer.sendDebateResultNotification();
            if(success) {
                return new JsonHttpReponse(Status.OK, null);
            }else {
                return new JsonHttpReponse(Status.SERVERERROR, null);

            }

           
        };
    }  
	
	
}