package underdevelopment.api;

import org.json.JSONException;
import org.json.JSONObject;
import org.neo4j.driver.Record;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBProfile;
import underdevelopment.db.DBUserInfo;


public class ProfileHandler {
    public static JsonRequestHandler updateUserPassword() {
        return (JSONObject jsonObj) -> {

            String username, password, oldPassword;
            String acs;
            // Get input
            try {
                username = jsonObj.getString("username");
                password = jsonObj.getString("newPassword");
                oldPassword = jsonObj.getString("oldPassword");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            
            String response;
            // Check if the username exists
            if ( ! DBUserInfo.checkUsernameExists(username) ) {
          	  try {
                  response = new JSONObject()
                      .put("Error", "Username doesn't exist")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }

            // Check if the old passwodr they entered is correct
            boolean correctPassword = DBProfile.checkPassword(username, oldPassword);
            if(! correctPassword) {
            	try {
            		System.out.println("incorrect password");
					response = new JSONObject()
					        .put("Error:", "Incorrect password")
					        .toString();
	                return new JsonHttpReponse(Status.CONFLICT, response);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
	                return new JsonHttpReponse(Status.SERVERERROR);
				}
            }
    		System.out.println("incorrect password2");

            // Run DB command
            try {
                DBProfile.updateUserPassword(username, password);
                response = new JSONObject()
                        .put("Response:", "Password changed")
                        .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
    
    public static JsonRequestHandler updateUserContact() {
        return (JSONObject jsonObj) -> {
            System.out.println("updating contact info");

            String username, email, phoneNumber;
            String acs;

            // Get input
            try {
                username = jsonObj.getString("username");
                email = jsonObj.getString("email");
                phoneNumber = jsonObj.getString("phoneNumber");

            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            String response;
            // Check if the username exists
            if ( ! DBUserInfo.checkUsernameExists(username) ) {
          	  try {
                  response = new JSONObject()
                      .put("Error", "Username doesn't exist")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }
            // Run DB command
            try {
                DBProfile.updateUserContact(username, email, phoneNumber);
                response = new JSONObject()
                        .put("Response:", "Contact Info changed")
                        .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler updateUserInfo() {
        return (JSONObject jsonObj) -> {

            String username, firstname, lastname, status, email, dob, about;
            String acs;

            // Get input
            try {
                username = jsonObj.getString("username");
                firstname = jsonObj.getString("firstname");
                lastname = jsonObj.getString("lastname");
                status = jsonObj.getString("status");
                email = jsonObj.getString("email");
                dob = jsonObj.getString("dob");
                about = jsonObj.getString("about");
                acs = jsonObj.getString("acs");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run DB command
            try {
                DBProfile.updateUserInfo(username, firstname, lastname, status, email, about, dob, acs);
                return new JsonHttpReponse(Status.OK);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

     /**
     * Returns the tier based on the ACS given.
     */
    public static String getTier(int acs){
        if (100 <= acs && acs <= 300){
            return "FANALYST";
        }else if (300 < acs && acs < 600){
            return "ANALYST";
        }else if (600 < acs && acs < 900){
            return "PRO ANALYST";
        }else if (900 < acs && acs <= 1100) {
            return "EXPERT ANALYST";
        }
        return "N/A";
    }

    public static JsonRequestHandler getUserInfo() {
        return (JSONObject jsonObj) -> {

            String username;
            // String response;

            // Get input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run DB command
            try {
                Record r = DBProfile.getUserInfo(username);
                if (r == null) {
                    return new JsonHttpReponse(Status.NOTFOUND);
                } 

                // Debugging
                System.out.println(r);
                // Map<String, Object> r = re.get("properties").asMap();

                System.out.println(r.get("username"));
                System.out.println("ACS: " + r.get("acs").asInt());
                
                // Set up response in a JSON format
                String usrname = r.get("username").asString();
                String firstname = r.get("firstname").asString();
                String lastname = r.get("lastname").asString();
                String status = r.get("status").asString();
                String email = r.get("email").asString();
                String phoneNumber = r.get("phoneNumber").asString();
                String dob = r.get("dob").asString();
                String about = r.get("about").asString();                

                int acs = r.get("acs").asInt();
                String tier = getTier(acs);

                

                JSONObject response = new JSONObject();
                response.put("username", usrname);
                response.put("firstname", firstname);
                response.put("lastname", lastname);
                response.put("status", status);
                response.put("email", email);
                response.put("phoneNumber", phoneNumber);
                response.put("dob", dob);
                response.put("about", about);
                response.put("tier", tier);
                response.put("acs", Integer.toString(acs));

                String string_response = response.toString();
                System.out.println(string_response);

                return new JsonHttpReponse(Status.OK, string_response);
                // return new JsonHttpReponse(Status.OK);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
            
        };
    }

   
}