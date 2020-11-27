package underdevelopment.api;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBUserInfo;

public class DailyDebateQuestion {

 public static JsonRequestHandler handleGetDailyDebateQuestion() {
        return (JSONObject jsonObj) -> {
            String username;
            String response;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            String tier = DBUserInfo.getUserTier(username);

            // Check that tier is not empty
            if (tier == ""){
                try {
                    response = new JSONObject().put("message", "User does not exist!").toString();
                    return new JsonHttpReponse(Status.NOTFOUND, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Get the question

            try {
                
                // Build the daily question
                response = new JSONObject().put("dailyQuestion", "What's up?")
                                           .put("id", "123")
                                           .toString();
                                           
                // Create the json response

                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
}