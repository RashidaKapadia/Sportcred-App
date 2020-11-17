package underdevelopment.api;

import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBPostComments;
import underdevelopment.db.DBPosts;
import underdevelopment.db.DBUserInfo;

public class PostCommentsHandler {

    public static JsonRequestHandler handleCreateComment() {
        return (JSONObject jsonObj) -> {

            System.out.println("Running the Comment Creation handler.");
            String postId, username, content;

            String response;
            // Get and validate input

            try {
                postId = jsonObj.getString("postId");
                username = jsonObj.getString("username");
                content = jsonObj.getString("content");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // create comment and get its id
            String commentId = DBPostComments.createComment(username, content);

            // Check that the comment was created
            if (commentId == "") {
                try {
                    response = new JSONObject().put("Couldn't add the comment!", commentId).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            // Add relationship between post and comment
            boolean relationAdded = DBPostComments.addPosttoCommentRelationship(postId, commentId);

            // Verify that the relationship has been added
            if (!relationAdded) {
                // Delete comment if the relationship could not be created between the post and the comment
                DBPostComments.deleteComment(commentId);
                try {
                    response = new JSONObject()
                            .put("Couldn't create the relation between post and comment", relationAdded).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            try {
                response = new JSONObject()
                        .put("Successfully created comment and added relation between post and comment!", jsonObj)
                        .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler handleDeleteComment() {
        return (JSONObject jsonObj) -> {
            System.out.println("Running the Delete Comment handler.");
            String commentId, username;

            String response;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                commentId = jsonObj.getString("commentId");
                System.out.println("Got the required info");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Check that the given user is the one that created the comment
            boolean isCommentor = verifyCommentor(commentId, username);
            
            // user can only delete their comment
            if (!isCommentor) {
                System.out.println("Something happened while checking strings");
                try {
                    System.out.println("This commment does not belong to the current user");
                    response = new JSONObject().put("You can only delete your own comment", false).toString();
                    return new JsonHttpReponse(Status.CONFLICT, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            // delete the comment and relationship between it and its post
            boolean commentDeleted = DBPostComments.deleteComment(commentId);
            if (!commentDeleted) {
                try {
                    System.out.println("Something happened during the deletion");
                    response = new JSONObject().put("Couldn't delete the comment", commentDeleted).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            try {
                response = new JSONObject().put("Successfully deleted the comment!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };

    }

    public static JsonRequestHandler handleEditComment() {
        return (JSONObject jsonObj) -> {

            System.out.println("Running the Edit Comment handler.");
            String newData, username, commentId;

            String response;
            // Get and validate input

            try {
                commentId = jsonObj.getString("commentId");
                username = jsonObj.getString("username");
                newData = jsonObj.getString("newData");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // verify credentials for the post
            boolean isCommentor = verifyCommentor(commentId, username);

            if (!isCommentor) {
                try {
                    System.out.println("The comment does not belong to the current user");
                    response = new JSONObject().put("You can only edit your own own comment", false).toString();
                    return new JsonHttpReponse(Status.CONFLICT, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

           
            boolean isUpdated = DBPostComments.editComment(commentId, newData);

            if (!isUpdated) {
                try {
                    response = new JSONObject().put("Couldn't edit comment", isUpdated).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }               
               
            try {
                response = new JSONObject().put("Successfully updated the comment!", jsonObj).toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler handleGetComments() {
        return (JSONObject jsonObj) -> {

            System.out.println("Running the Get Comments handler.");
            String postId;

            String response;

            // Get and validate input
            try {
                postId = jsonObj.getString("postId");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

           
            List<Map<String,Object>> allComments = DBPostComments.getComments(postId);

            if (allComments.isEmpty()) {
                try {
                    response = new JSONObject().put("No comments for given post or couldn't get comments", allComments).toString();
                    return new JsonHttpReponse(Status.SERVERERROR, response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }               
            
            // Return the response with list of all comments
            return new JsonHttpReponse(Status.OK, allComments.toString());
            
        };
    }

    private static boolean verifyCommentor(String commentId, String username) {
        // verify credentials for the post
        int splitArray = commentId.indexOf(".");
        String subString = commentId.substring(0, splitArray);

        System.out.println(subString.equals(username));

        return subString.equals(username);
    }
}