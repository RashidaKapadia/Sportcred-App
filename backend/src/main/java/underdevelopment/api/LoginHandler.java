package underdevelopment.api;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JWTSessionManager;
import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBLogin;


public class LoginHandler {

    public static boolean validCredentials (String username, String password) {
        // TODO: remove test user
        return ((username.equals("test") && password.equals("test")) 
            || new DBLogin().verifyUser(username, password)); 
    }

    public static JsonRequestHandler createSession() {
        return (JSONObject jsonObj) -> {

            System.out.println("Calling login handler");
            String username, password;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                password = jsonObj.getString("password");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Check credentials
            if (!validCredentials(username, password)) {
                return new JsonHttpReponse(Status.FORBIDDEN);
            }

            // Return a session token
            try {
                String sessionToken = JWTSessionManager.createToken(username);
                String response = new JSONObject()
                    .put("token", sessionToken)
                    .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler verifySession() {
        return (JSONObject jsonObj) -> {
            
            String sessionToken;
            try {
                sessionToken = jsonObj.getString("token");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            try {
                String response = new JSONObject()
                    .put("success", JWTSessionManager.validateToken(sessionToken))
                    .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler testAuthorizedRoute() {
        return (JSONObject jsonObj) -> {
            return new JsonHttpReponse(Status.OK);
        };
    }

    public static JsonRequestHandler testNonAuthorizedRoute() {
        return (JSONObject jsonObj) -> {
            return new JsonHttpReponse(Status.OK);
        };
    }

    public static JsonRequestHandler testGet() {
        return (JSONObject jsonObj) -> {
            try {
                String response = new JSONObject()
                    .put("message", "Hello world!!!!")
                    .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
}
