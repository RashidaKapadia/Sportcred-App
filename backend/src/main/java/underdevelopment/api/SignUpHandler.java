package underdevelopment.api;

import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JWTSessionManager;
import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBUserInfo;

public class SignUpHandler {

	
    private static boolean matchingPassword (String password1, String password2) {
    	return (! (password1 == password2));
    }
    /*
    private static String placeHolderDB(String email, String username, String phoneNumber) {
    	
    	return "email is: " + email + " username is: " + username + " phoneNumber is: " + phoneNumber;
    }
    */
    /*
     * 'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNum,
      'favSport': favSport,
      'sportLevel': sportLevel,
      'sportToLearn': sportToLearn,
      'favTeam': favTeam,
      'dob': dob
     */
    public static JsonRequestHandler handleSignUp() {
        return (JSONObject jsonObj) -> {
            String email, username, password, phoneNumber, favSport, sportLevel, sportToLearn, favTeam;
            //Date dob;
            String dob;
           // SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");  

            String response;
            // Get and validate input

            try {
                username = jsonObj.getString("username");
                email = jsonObj.getString("email");
                password = jsonObj.getString("password");
                //password2 = jsonObj.getString("password2");
                phoneNumber = jsonObj.getString("phoneNumber");
                favSport = jsonObj.getString("favSport");
                sportLevel = jsonObj.getString("sportLevel");
                sportToLearn = jsonObj.getString("sportToLearn");
                favTeam = jsonObj.getString("favTeam");
                //dob = formatter.parse(jsonObj.getString("dob"));
                dob = jsonObj.getString("dob");

            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            // Check if the username exists
            if ( DBUserInfo.checkUsernameExists(username) ) {
          	  try {
                  response = new JSONObject()
                      .put("Error", "Username already exists")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }

            if( DBUserInfo.checkEmailExists(email)) {
          	  try {
                  response = new JSONObject()
                      .put("Error", "Email already exists")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }
                       
            // Run the database command 			
            try {
            	//formattedDob = formatter.parse(dob);
            	//System.out.println("formatted dob is: ");           
            	//System.out.println(formattedDob);
            	boolean success = DBUserInfo.addUser(email, username, password, phoneNumber, favSport, sportLevel, sportToLearn, favTeam, dob);
                response = new JSONObject()
                    .put("Response", "Added " + username + " to the database")
                    .toString();
                System.out.println(success);
                	return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
                
            } 
        };
    }

}