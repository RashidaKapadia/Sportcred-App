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
            String postId = DBPosts.createPost(username, content, title, profileName, count);
            if(postId == ""){
                try {
                    response = new JSONObject().put("Couldn't create the post!", "").toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } 
            // add relationship of user to post
            boolean isAddedRelation = DBPosts.addRelationToPost(username, postId);
            if(!isAddedRelation){
                try {
                    response = new JSONObject().put("Couldn't create the relation", isAddedRelation).toString();
                    // TODO: DELETE THE
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
                              // TODO : DELETE POST AND REMOVE RELATION AND ASK USER TO RETRY
                             return new JsonHttpReponse(Status.SERVERERROR, response);
                 } catch (JSONException e) {
                     e.printStackTrace();
                 }
             }
            try {
                response = new JSONObject().put("Successfully added relation btw user and post!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                    e.printStackTrace();
                    return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
}
