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

            String username, status, email, dob, about, tier;
            String acs;

            // Get input
            try {
                username = jsonObj.getString("username");
                status = jsonObj.getString("status");
                email = jsonObj.getString("email");
                dob = jsonObj.getString("dob");
                about = jsonObj.getString("about");
                tier = jsonObj.getString("tier");
                acs = jsonObj.getString("acs");
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
            // String response;

            // Get input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Run DB command
            try {
                Result node_result = DBProfile.getUserInfo(username);
                if (node_result.hasNext() == false) {
                    return new JsonHttpReponse(Status.NOTFOUND);
                } 
                Record r = node_result.next();
                // Set up response in a JSON format
                String usrname = r.get("username").asString();
                String status = r.get("status").asString();
                String email = r.get("email").asString();
                String dob = r.get("dob").asString();
                String about = r.get("about").asString();
                String tier = r.get("tier").asString();
                int acs = r.get("acs").asInt();

                JSONObject response = new JSONObject();
                response.put("username", usrname);
                response.put("status", status);
                response.put("email", email);
                response.put("dob", dob);
                response.put("about", about);
                response.put("tier", tier);
                response.put("acs", acs);

                String string_respone = response.toString();

                return new JsonHttpReponse(Status.OK, string_respone);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
            
        };
    }
}