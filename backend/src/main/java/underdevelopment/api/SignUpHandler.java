package underdevelopment.api;

import java.io.OutputStream;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JWTSessionManager;
import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;

public class SignUpHandler {

	
    private static boolean matchingPassword (String password1, String password2) {
    	return (! (password1 == password2));
    }

    private static String placeHolderDB(String email, String username, String phoneNumber) {
    	
    	return "email is: " + email + " username is: " + username + " phoneNumber is: " + phoneNumber;
    }
    
    public static JsonRequestHandler handleSignUp() {
        return (JSONObject jsonObj) -> {

            String email, username, password1, password2, phoneNumber, favSport, _sportLevel, _sportToLearn, _favTeam;

            // Get and validate input
            try {
                email = jsonObj.getString("email");
                username = jsonObj.getString("username");
                password1 = jsonObj.getString("password1");
                password2 = jsonObj.getString("password2");
                phoneNumber = jsonObj.getString("phoneNumber");
                favSport = jsonObj.getString("favSport");
                _sportLevel = jsonObj.getString("_sportLevel");
                _sportToLearn = jsonObj.getString("_sportToLearn");
                _favTeam = jsonObj.getString("_favTeam");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Make sure they passwords are different
            if (!matchingPassword(password1, password2)) {
                return new JsonHttpReponse(Status.CONFLICT);
            }
            
            // Run the database command (currently a placeholder)
            String textResponse = placeHolderDB(email, username, phoneNumber);
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
