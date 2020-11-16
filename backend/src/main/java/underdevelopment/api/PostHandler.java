package underdevelopment.api;

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
            //String str = DBUserInfo.getPostCount(username);
            System.out.println("*");
            int count = DBUserInfo.getPostCount(username);
            //System.out.println(str);
            //int count = Integer.parseInt(DBUserInfo.getPostCount(username));
            System.out.println("**");
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
            String postId = DBPosts.createPost(username, content, title, profileName);
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
                DBPosts.deletePost(postId);
                try {
                    response = new JSONObject().put("Couldn't create the relation", isAddedRelation).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } 
            // update the number of posts in user node for the user with "username"
             boolean isUpdateCountTrue = DBUserInfo.updatePostCount(username, 1);
             if(!isUpdateCountTrue){
                DBPosts.removeRelation(username, postId);
                DBPosts.deletePost(postId);
                try {
                    response = new JSONObject().put("Number of Posts did not update for some reason!", isUpdateCountTrue ).toString();
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
    
    public static JsonRequestHandler handleDeletePost(){
        return (JSONObject jsonObj) -> {
            System.out.println("Running the Delete Post handler.");
            String postId, username; 

            String response;
            // Get and validate input

            try {
                postId = jsonObj.getString("uniqueIdentifier");
                username = jsonObj.getString("username");
                System.out.println("Got the required info");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            //System.out.println(username);
            //System.out.println(postId);
            int splitArray = postId.indexOf(".");
            //System.out.println(splitArray);
            String subString = postId.substring(0, 4);
            //System.out.println(subString);
            System.out.println(subString.equals(username));
            //for (String a : splitArray){
              //  System.out.println(a);
            //}
            //System.out.println(splitArray);

            System.out.println("Going to check if username has its name in post id...");
            // user can delete pnly his own post
            if (!subString.equals(username)){
                System.out.println("Something happened while checking strings");
                try {
                    System.out.println("The post does not belong to the current user");
                    response = new JSONObject().put("You can only delete your own post", false).toString();
                    return new JsonHttpReponse(Status.CONFLICT, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                } 
            }
            // remove teh relation btw post and user node
            System.out.println("Going to remove the relation");
            boolean isRelationRemoved = DBPosts.removeRelation(subString, postId);
            System.out.println("Removed the relation");
            if(!isRelationRemoved){
                try {
                    System.out.println("Somwthing happened with the relation.");
                    response = new JSONObject().put("Couldn't delete the relation", isRelationRemoved).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } 
            //delete the post
            boolean isPostDeleted = DBPosts.deletePost(postId);
            if(!isPostDeleted){
                try {
                    System.out.println("Something happened during the deletion");
                    response = new JSONObject().put("Couldn't delete the post", isPostDeleted).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } 
            // decrease the post count for the user
            /*boolean isPostCountUpdated = DBUserInfo.updatePostCount(postId, -1);
            System.out.println("Updated the count");
            if(!isPostCountUpdated){
                try {
                    System.out.println("Something happened during counting posts");
                    response = new JSONObject().put("Couldn't update the number of posts !", isPostCountUpdated).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }*/
            try {
                //System.out.println("Something happened at the last stage");
                response = new JSONObject().put("Successfully deleted the post!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                    e.printStackTrace();
                    return new JsonHttpReponse(Status.SERVERERROR);
            }
        };


    }

    public static JsonRequestHandler handleEditCreation() {
        return (JSONObject jsonObj) -> {
            
        }

    }    

}
