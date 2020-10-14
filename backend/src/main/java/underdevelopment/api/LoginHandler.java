package underdevelopment.api;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.Utils;
import underdevelopment.api.utils.JWTSessionManager;
import underdevelopment.api.utils.ResponseWriter;
import underdevelopment.api.utils.Status;

public class LoginHandler {

    private static boolean validCredentials (String username, String password) {
        return username.equals("test") && password.equals("test");
    }

    public static HttpHandler createSession() {

        return (HttpExchange r) -> {
            System.out.println("(Debug) login user");

            String username, password;

            // Get and validate input
            try {
                JSONObject deserialized = new JSONObject(Utils.convert(r.getRequestBody()));
                username = deserialized.getString("username");
                password = deserialized.getString("password");
            } catch (Exception e) {
                ResponseWriter.sendStatus(r, Status.BADREQUEST);
                return;
            }

            // TODO: Check creditials
            if (!validCredentials(username, password)) {
                ResponseWriter.sendStatus(r, Status.FORBIDDEN);
                return;
            }

            // Return a session token
            try {
                String sessionToken = JWTSessionManager.createToken(username);
                String response = new JSONObject()
                    .put("token", sessionToken)
                    .toString();
                ResponseWriter.writeReponse(r, Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                ResponseWriter.sendStatus(r, Status.SERVERERROR);
            }
        };
    }

    // public static HttpHandler validateLogin() {
    //     return (HttpExchange r) -> {
    //         System.out.println("TODO validate login");
    //     };
    // }

    public static HttpHandler verifySession() {
        return (HttpExchange r) -> {
            System.out.println("TODO verify session");
            String sessionToken;
            try {
                JSONObject deserialized = new JSONObject(Utils.convert(r.getRequestBody()));
                sessionToken = deserialized.getString("token");
            } catch (Exception e) {
                ResponseWriter.sendStatus(r, Status.BADREQUEST);
                return;
            }

            // Return a session token
            try {
                String response = new JSONObject()
                    .put("success", JWTSessionManager.validateToken(sessionToken))
                    .toString();
                ResponseWriter.writeReponse(r, Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                ResponseWriter.sendStatus(r, Status.SERVERERROR);
            }
        };
    }
}
