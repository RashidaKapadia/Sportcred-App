package underdevelopment.api;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.Status;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.db.DBPostComments;
import underdevelopment.db.DBPosts;
import underdevelopment.db.DBUserInfo;

public class PostHandler {

    /**
     * Getting posts for search bar
     * @return
     */
    public static JsonRequestHandler handleGetPostsForSearchBar() {
        return (JSONObject jsonObj) -> {
            String title;
            String response;

            // Get and validate input
            try {
                title = jsonObj.getString("title");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            ArrayList<Map<String, Object>> posts = DBPosts.getPostsGivenTitle(title);

            try {
                List<JSONObject> postsJSON = new ArrayList<JSONObject>();
                
                // Build the json array of posts
                Iterator<Map<String, Object>> it = posts.iterator();
                while (it.hasNext()) {
                    Map<String, Object> postNode = it.next();
                    postsJSON.add(new JSONObject().put("username", postNode.get("username").toString())
                            .put("content", postNode.get("content").toString())
                            .put("title", postNode.get("title").toString())
                            .put("profileName", postNode.get("profileName").toString())
                            .put("peopleAgree", postNode.get("peopleAgree"))
                            .put("peopleDisagree", postNode.get("peopleDisagree"))
                            .put("uniqueIdentifier", postNode.get("uniqueIdentifier").toString())
                            .put("timestamp", postNode.get("timestamp").toString())
                            .put("comments", DBPostComments.getComments(postNode.get("uniqueIdentifier").toString())));

                }
                // Create the json response
                response = new JSONObject().put("posts", postsJSON).toString();

                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler handleGetPosts() {
        return (JSONObject jsonObj) -> {

            System.out.println("Getting all posts");

            // Get and validate input

            // Get questions from the db
            ArrayList<Map<String, Object>> posts = DBPosts.getPosts();

            try {
                JSONArray postsJSON = new JSONArray();

                // Build the json array of posts
                Iterator<Map<String, Object>> it = posts.iterator();
                while (it.hasNext()) {
                    Map<String, Object> postNode = it.next();
                    postsJSON.put(new JSONObject().put("username", postNode.get("username").toString())
                            .put("acs", DBUserInfo.getUserACS(postNode.get("username").toString()))
                            .put("content", postNode.get("content").toString())
                            .put("title", postNode.get("title").toString())
                            .put("profileName", postNode.get("profileName").toString())
                            .put("peopleAgree", postNode.get("peopleAgree"))
                            .put("peopleDisagree", postNode.get("peopleDisagree"))
                            .put("uniqueIdentifier", postNode.get("uniqueIdentifier").toString())
                            .put("timestamp", postNode.get("timestamp").toString())
                            .put("comments", DBPostComments.getComments(postNode.get("uniqueIdentifier").toString())));

                }

                // Create the json response
                String response = new JSONObject().put("posts", postsJSON).toString();

                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler handlePostCreation() {
        return (JSONObject jsonObj) -> {

            System.out.println("Running the Post handler.");
            String username, content, title;

            String response;
            // Get and validate input

            try {
                username = jsonObj.getString("username");
                content = jsonObj.getString("content");
                title = jsonObj.getString("title");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            // get the numbe of posts for this username
            // String str = DBUserInfo.getPostCount(username);
            System.out.println("*");
            int count = DBUserInfo.getPostCount(username);
            // System.out.println(str);
            // int count = Integer.parseInt(DBUserInfo.getPostCount(username));
            System.out.println("**");
            System.out.println("postCount: " + count);
            if (count == -1) {
                try {
                    response = new JSONObject().put("Couldn't return  number of Posts !", count).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            // create Post
            String postId = DBPosts.createPost(username, content, title);
            if (postId == "") {
                try {
                    response = new JSONObject().put("Couldn't create the post!", "").toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            // add relationship of user to post
            boolean isAddedRelation = DBPosts.addRelationToPost(username, postId);
            if (!isAddedRelation) {
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
            if (!isUpdateCountTrue) {
                DBPosts.removeRelation(username, postId);
                DBPosts.deletePost(postId);
                try {
                    response = new JSONObject()
                            .put("Number of Posts did not update for some reason!", isUpdateCountTrue).toString();
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

    public static JsonRequestHandler handleDeletePost() {
        return (JSONObject jsonObj) -> {
            System.out.println("Running the Delete Post handler.");
            String postId, username;

            String response;
            // Get and validate input

            try {
                postId = jsonObj.getString("postId");
                username = jsonObj.getString("username");
                System.out.println("Got the required info");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            // System.out.println(username);
            // System.out.println(postId);
            int splitArray = postId.indexOf(".");
            // System.out.println(splitArray);
            String subString = postId.substring(0, splitArray);
            // System.out.println(subString);
            System.out.println(subString.equals(username));
            // for (String a : splitArray){
            // System.out.println(a);
            // }
            // System.out.println(splitArray);

            System.out.println("Going to check if username has its name in post id...");
            // user can delete pnly his own post
            if (!subString.equals(username)) {
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
            if (!isRelationRemoved) {
                try {
                    System.out.println("Something happened with the relation.");
                    response = new JSONObject().put("Couldn't delete the relation", isRelationRemoved).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            // delete the post
            boolean isPostDeleted = DBPosts.deletePost(postId);
            if (!isPostDeleted) {
                try {
                    System.out.println("Something happened during the deletion");
                    response = new JSONObject().put("Couldn't delete the post", isPostDeleted).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            boolean isUpdateCountTrue = DBUserInfo.updatePostCount(username, -1);
            if (!isUpdateCountTrue) {
                DBPosts.removeRelation(username, postId);
                DBPosts.deletePost(postId);
                try {
                    response = new JSONObject()
                            .put("Number of Posts did not update for some reason!", isUpdateCountTrue).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            // decrease the post count for the user
            /*
             * boolean isPostCountUpdated = DBUserInfo.updatePostCount(postId, -1);
             * System.out.println("Updated the count"); if(!isPostCountUpdated){ try {
             * System.out.println("Something happened during counting posts"); response =
             * new JSONObject().put("Couldn't update the number of posts !",
             * isPostCountUpdated).toString(); return new
             * JsonHttpReponse(Status.SERVERERROR, response); } catch (JSONException e) {
             * e.printStackTrace(); } }
             */
            try {
                // System.out.println("Something happened at the last stage");
                response = new JSONObject().put("Successfully deleted the post!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };

    }

    public static JsonRequestHandler handlePostAgreeDisAgree() {
        return (JSONObject jsonObj) -> {
            System.out.println("Running the Post Edit handler.");
            String postId, username;
            boolean agreed;

            String response;
            // Get and validate input

            try {
                postId = jsonObj.getString("postId");
                username = jsonObj.getString("username");
                agreed = jsonObj.getBoolean("agreed");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            int splitArray = postId.indexOf(".");
            String subString = postId.substring(0, splitArray);
          
            System.out.println(subString.equals(username));

           /*  if (subString.equals(username)) {
                try {
                    response = new JSONObject().put("You canot agree/disagree to  your own own post", false).toString();
                    return new JsonHttpReponse(Status.CONFLICT, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } */

            boolean isUpdated = DBPosts.likedOrDislikedPost(username, postId, agreed);
            if (!isUpdated) {
                try {
                    response = new JSONObject().put("Couldn't perform the logic for agreed/disliked post", isUpdated)
                            .toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
            try {
                response = new JSONObject().put("Successfully agreed/disagreed to the post!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };

    }

    public static JsonRequestHandler updatePost() {
        return (JSONObject jsonObj) -> {

            String postId, content, title, username;
            String response;
            // Get input
            try {
                username = jsonObj.getString("username"); 
                postId = jsonObj.getString("postId");
                content = jsonObj.getString("content");
                title = jsonObj.getString("title");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
             // verify credentials for the post
             int splitArray = postId.indexOf(".");
             //System.out.println(splitArray);
             String subString = postId.substring(0, splitArray); 
             //String subString1 = postId.substring(splitArray+1, postId.length());
             //System.out.println(subString1);
             //System.out.println(subString);
             System.out.println(subString.equals(username));
             if (!subString.equals(username)){
                 try {
                     System.out.println("The post does not belong to the current user");
                     response = new JSONObject().put("You can only edit your own own post", false).toString();
                     return new JsonHttpReponse(Status.CONFLICT, response);
                 } catch (JSONException e) {
                     e.printStackTrace();
                 } 
             }

            // Run DB command
            boolean isUpdated = DBPosts.editPost(postId, content, title);
            if(!isUpdated){
                try {
                    response = new JSONObject().put("Couldn't edit post", isUpdated).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            try {
                response = new JSONObject().put("Successfully updated the post!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                    e.printStackTrace();
                    return new JsonHttpReponse(Status.SERVERERROR);
            }

        };
    }

}