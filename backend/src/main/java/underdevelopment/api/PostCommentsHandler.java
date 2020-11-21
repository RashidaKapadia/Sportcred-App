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
                response = "Couldn't add the comment!";
                return new JsonHttpReponse(Status.SERVERERROR, response);
            }
            // Add relationship between post and comment
            boolean relationAdded = DBPostComments.addPosttoCommentRelationship(postId, commentId);

            // Verify that the relationship has been added
            if (!relationAdded) {
                // Delete comment if the relationship could not be created between the post and
                // the comment
                DBPostComments.deleteComment(commentId);

                response = "Couldn't create the relation between post and comment";
                return new JsonHttpReponse(Status.SERVERERROR, response);
            }

            // If this part is reached -> comment successfully created and linked with post
            response = "Successfully created comment and added relation between post and comment!";
            return new JsonHttpReponse(Status.OK, response);
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
                System.out.println(username);
                System.out.println(commentId);
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Check that the comment with the given id exists
            if (!DBPostComments.checkCommentExists(commentId)) {
                response = "Comment with given ID does not exist";

                return new JsonHttpReponse(Status.CONFLICT, response);
            }

            // Check that the given user is the one that created the comment
            if (!verifyCommentor(commentId, username)) {
                response = "You can only delete your own comment";
                return new JsonHttpReponse(Status.CONFLICT, response);
            }

            // delete the comment and relationship between it and its post
            boolean commentDeleted = DBPostComments.deleteComment(commentId);
            if (!commentDeleted) {
                response = "Couldn't delete the comment";

                return new JsonHttpReponse(Status.SERVERERROR, response);
            }

            // If this line is reached -> comment was deleted
            response = "Successfully deleted the comment!";
            return new JsonHttpReponse(Status.OK, response);
        };

    }

    public static JsonRequestHandler handleEditComment() {
        return (JSONObject jsonObj) -> {
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

             // Check that the comment with the given id exists
             if (!DBPostComments.checkCommentExists(commentId)) {
                response = "Comment with given ID does not exist";

                return new JsonHttpReponse(Status.CONFLICT, response);
            }
            
            // verify credentials for the comment
            if (!verifyCommentor(commentId, username)) {
                response = "You can only edit your own own comment";
                return new JsonHttpReponse(Status.CONFLICT, response);
            }

            boolean isUpdated = DBPostComments.editComment(commentId, newData);

            // Check that the comment has been updated or not
            if (!isUpdated) {
                response = "Couldn't edit comment";
                return new JsonHttpReponse(Status.SERVERERROR, response);

            }

            // If this part is reached -> comment successfully updated
            response = "Successfully updated the comment!";
            return new JsonHttpReponse(Status.OK, response);

        };
    }

    public static JsonRequestHandler handleGetComments() {
        return (JSONObject jsonObj) -> {
            String postId;
            // Get and validate input
            try {
                postId = jsonObj.getString("postId");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Get the comments for the given post - [] if no comments exist for this post
            List<JSONObject> allComments = DBPostComments.getComments(postId);

            // Return the response with list of all comments
            return new JsonHttpReponse(Status.OK, allComments.toString());
        };
    }

    private static boolean verifyCommentor(String commentId, String username) {
        // verify credentials for the post
        int splitArray = commentId.indexOf(".");
        String subString = commentId.substring(0, splitArray);
        System.out.println("********");
        System.out.println(username);
        System.out.println(subString);
        System.out.println(subString.equals(username));

        return subString.equals(username);
    }
}