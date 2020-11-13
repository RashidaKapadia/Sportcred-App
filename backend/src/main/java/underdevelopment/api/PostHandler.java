package underdevelopment.api;

//import java.io.OutputStream;
//import java.text.ParseException;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBPosts;
import underdevelopment.db.DBUserInfo;

public class PostHandler {

    public static JsonRequestHandler handlePostCreation() {
        return (JSONObject jsonObj) -> {

        	System.out.println("Running the Post handler.");
            String username, content, title, profileName; 

            String response;
            // Get and validate input

            try {
                username = jsonObj.getString("username");
                content = jsonObj.getString("content");
                title = jsonObj.getString("title");
                profileName = jsonObj.getString("profileName");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            // get the numbe of posts for this username
            int count = DBUserInfo.getPostCount(username);
                System.out.println("postCount: "+ count);
            if(count == -1){
                try {
                    response = new JSONObject().put("Couldn't return  number of Posts !", count).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            // create Post
            boolean isPostCreated = DBPosts.createPost(username, content, title, profileName, count);
            if(!isPostCreated){
                try {
                    response = new JSONObject().put("Couldn't create the post!", isPostCreated).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } 
            // update the number of posts in user node for the user with "username"
            boolean isUpdateCountTrue = DBUserInfo.updatePostCount(username);
            if(!isUpdateCountTrue){
                try {
                    response = new JSONObject()
                            .put("Number of Posts did not update for some reason!", isUpdateCountTrue).toString();
                            return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // add relationship of user to post
            try {
                response = new JSONObject().put("Post successfully created!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                    e.printStackTrace();
                    return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
}
