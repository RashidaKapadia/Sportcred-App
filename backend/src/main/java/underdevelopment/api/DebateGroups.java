package underdevelopment.api;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBDebateGroups;

public class DebateGroups {

    public static JsonRequestHandler createDebateGroups() {
        return (JSONObject jsonObj) -> {
            String response;

            // Create the debate groups
            boolean groupsCreated = DBDebateGroups.createDebateGroups();

            System.out.println(groupsCreated);

            // Check if the groups were created properly
            if (!groupsCreated) {
                try {
                    response = new JSONObject().put("message", "Could not create the groups!").toString();
                    return new JsonHttpReponse(Status.NOTFOUND, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // Create the json response - indicate that the groups were created successfully
            return new JsonHttpReponse(Status.OK);

        };
    }

}