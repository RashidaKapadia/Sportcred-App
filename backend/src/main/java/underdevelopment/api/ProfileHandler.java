package underdevelopment.api;

import java.io.OutputStream;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBProfile;


public class ProfileHandler {


    public static JsonRequestHandler updateUserInfo() {
        return (JSONObject jsonObj) -> {

            String username, status, email, dob, about, tier;
            int acs;

            // Get input
            try {
                username = jsonObj.getString("username");
                status = jsonObj.getString("status");
                email = jsonObj.getString("email");
                dob = jsonObj.getString("dob");
                about = jsonObj.getString("about");
                tier = jsonObj.getString("tier");
                acs = jsonObj.getInt("acs");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run DB command
            try {
                DBProfile.updateUserInfo(username, status, email, about, dob, acs, tier);
                return new JsonHttpReponse(Status.OK);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler getUserInfo() {
        return (JSONObject jsonObj) -> {

            String username;
            String response;

            // Get input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run DB command
            try {
                boolean success = DBProfile.getUserInfo(username);
                System.out.println(success);
                return new JsonHttpReponse(Status.OK);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
            
        };
    }
}