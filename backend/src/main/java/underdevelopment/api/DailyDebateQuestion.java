package underdevelopment.api;

import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBDebateDailyQuestion;
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

            // Get the given user's tier
            String tier = DBUserInfo.getUserTier(username);

            // Check that tier is not empty
            if (tier == "") {
                try {
                    response = new JSONObject().put("message", "User does not exist!").toString();
                    return new JsonHttpReponse(Status.NOTFOUND, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Get the question
            String question = DBDebateDailyQuestion.getDailyDebateQuestion(tier);
            System.out.println("QUESTION: " + question);

            // If quesiton is empty, it could not be retrieved
            if (question == "") {
                try {
                    response = new JSONObject().put("Could not get daily question", tier).toString();
                    return new JsonHttpReponse(Status.SERVERERROR);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            try {
                // Build the daily question
                response = new JSONObject().put("dailyQuestion", question).toString();

                // Create the json response
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler handleAddResponseToDailyDebateQuestion() {
        return (JSONObject jsonObj) -> {
            String username;
            String analysis;
            String response;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                analysis = jsonObj.getString("analysis");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            String tier = DBUserInfo.getUserTier(username);

            // Check that tier is not empty
            if (tier == "") {
                try {
                    response = new JSONObject().put("message", "User does not exist!").toString();
                    return new JsonHttpReponse(Status.NOTFOUND, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Get the id of the added response
            int id = DBDebateDailyQuestion.addResponse(username, analysis);

            // If id == -1, it means that the response could not be added
            if (id == -1) {
                try {
                    response = new JSONObject().put("Could not add response", id).toString();
                    return new JsonHttpReponse(Status.SERVERERROR);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Add relationship between response and dailyQuestion of user's tier
            boolean relAdded = DBDebateDailyQuestion.addResponseToQuestion(tier, id);

            // Check that the relationship is added properly
            if (!relAdded) {
                try {
                    response = new JSONObject().put("Could not add response to question", relAdded).toString();
                    return new JsonHttpReponse(Status.SERVERERROR);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Create the json response
            return new JsonHttpReponse(Status.OK);

        };
    }

    public static JsonRequestHandler handleGetResponseToDailyDebateQuestion() {
        return (JSONObject jsonObj) -> {
            String username;
            String response;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Get the current user's tier
            String tier = DBUserInfo.getUserTier(username);

            System.out.println("Tier: " + tier);

            // Check that tier is not empty
            if (tier == "") {
                try {
                    response = new JSONObject().put("message", "User does not exist!").toString();
                    return new JsonHttpReponse(Status.NOTFOUND, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Get the id of the added response
            String analysis = DBDebateDailyQuestion.getResponseToDailyQuestion(tier, username);

            // If analysis is an empty string, user did not submit their response yet
            if (analysis == "") {
                try {
                    response = new JSONObject().put("Error", "No response or could not get response").toString();
                    return new JsonHttpReponse(Status.SERVERERROR);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Return the analysis of the given user
            try {
                response = new JSONObject().put("analysis", analysis).toString();
                // Create the json response
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);

            }

        };
    }
}