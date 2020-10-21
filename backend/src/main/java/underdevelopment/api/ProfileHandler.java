package underdevelopment.api;

import java.io.OutputStream;

import org.json.JSONException;
import org.json.JSONObject;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBProfile;


public class ProfileHandler {


    public static JsonRequestHandler updateUserInfo() {
        return (JSONObject jsonObj) -> {

            String username, status, email, dob, about;
            String acs;

            // Get input
            try {
                username = jsonObj.getString("username");
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
                DBProfile.updateUserInfo(username, status, email, about, dob, acs);
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
                System.out.println(r.get("username").asString());
                System.out.println("ACS: " + r.get("acs"));
                
                // Set up response in a JSON format
                String usrname = r.get("username").asString();
                String status = r.get("status").asString();
                String email = r.get("email").asString();
                String dob = r.get("dob").asString();
                String about = r.get("about").asString();                

                int acs = r.get("acs").asInt();
                String tier = getTier(acs);

                

                JSONObject response = new JSONObject();
                response.put("username", usrname);
                response.put("status", status);
                response.put("email", email);
                response.put("dob", dob);
                response.put("about", about);
                response.put("tier", tier);
                response.put("acs", Integer.toString(acs));

                String string_response = response.toString();

                return new JsonHttpReponse(Status.OK, string_response);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
            
        };
    }

   
}