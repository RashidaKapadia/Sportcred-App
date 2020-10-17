package underdevelopment.api;

import java.io.OutputStream;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;

public class ProfileHandler {

    private static String placeHolderDB(String text) {
        return "added text is: " + text;
    }

    public static JsonRequestHandler updateStatus() {
        return (JSONObject jsonObj) -> {

            String status;

            // Get input
            try {
                status = jsonObj.getString("status");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run the database command (currently a placeholder)
            String textResponse = placeHolderDB(status);
            try {
                String response = new JSONObject()
                    .put("token", textResponse)
                    .toString();
                	return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler getStatus() {
        return (JSONObject jsonObj) -> {

            String username;

            // Get input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run the database command (currently a placeholder)
            String textResponse = placeHolderDB(username);
            try {
                String response = new JSONObject()
                    .put("token", textResponse)
                    .toString();
                	return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler updateUserInfo() {
        return (JSONObject jsonObj) -> {

            String username, email, phoneNumber, birthday, about;

            // Get input
            try {
                username = jsonObj.getString("username");
                email = jsonObj.getString("email");
                phoneNumber = jsonObj.getString("phoneNumber");
                birthday = jsonObj.getString("birthday");
                about = jsonObj.getString("about");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run the database command (currently a placeholder)
            String textResponse = placeHolderDB(about);
            try {
                String response = new JSONObject()
                    .put("token", textResponse)
                    .toString();
                	return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler getUserInfo() {
        return (JSONObject jsonObj) -> {

            String username;

            // Get input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run the database command (currently a placeholder)
            String textResponse = placeHolderDB(username);
            try {
                String response = new JSONObject()
                    .put("token", textResponse)
                    .toString();
                	return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
}