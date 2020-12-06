package underdevelopment.db;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import static org.neo4j.driver.Values.parameters;

import org.json.JSONArray;
import org.json.JSONObject;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Value;

public class DBPostComments {

    /***
     * create a comment using following parameters
     */
    public static String createComment(String username, String content) {
        //
        System.out.println("creating comment for user: " + username);
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        String commentId = username.concat("." + timestamp);
        String userFullName = DBUserInfo.getUserFullName(username);
        System.out.println("comment id:" + commentId);

        // create a comment node
        try (Session session = Connect.driver.session()) {
            // timestamp converted to dateTime object in neo4j
            session.writeTransaction(tx -> tx.run(
                    "MERGE (c: comment{timestamp: datetime(), id: $z, profileName: $p, username: $x, content: $y}) return c",
                    parameters("z", commentId, "x", username, "y", content, "p", userFullName)));
            session.close();

            return commentId;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static boolean addPosttoCommentRelationship(String postId, String commentId) {
        System.out.println("adding relationship between the post " + postId + " and the comment " + commentId);

        // add relationship between post and comment
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                    "MATCH (p: post{uniqueIdentifier: $x}), (c:comment{id:$y}) " 
                    + "MERGE (p)-[r:hasComment]->(c) return r",
                    parameters("x", postId, "y", commentId)));
            session.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean editComment(String commentId, String newContent) {
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                    "MATCH (c:comment{id: $c}) SET c.content = $y",
                    parameters("c", commentId, "y", newContent)));
            session.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteComment(String commentId) {
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(
                    tx -> tx.run("MATCH (p:post)-[r:hasComment]->(c:comment{id: $x}) "
                            + "DELETE r,c return p", parameters( "x", commentId)));
            session.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean checkCommentExists(String commentId){
        try (Session session = Connect.driver.session()) {
            Result result = session.run("MATCH (c:comment {id: $x}) RETURN c", parameters("x", commentId));

            if (result.hasNext()){
                System.out.println(result.toString());
                System.out.println(result.single());

                return true;
            } 

            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static Map<String, Object> getComment(String commentId) {
        try (Session session = Connect.driver.session()) {
            Result result = session.run("MATCH (c:comment {id: $x}) RETURN c", parameters("x", commentId));

            Map<String, Object> commentMap = new HashMap<>();
            if (result.hasNext()) {
                Record data = result.next();

                commentMap.put("timestamp", data.get("timestamp").asString());
                commentMap.put("username", data.get("username").asString());
                commentMap.put("content", data.get("content").asString());
                commentMap.put("profileName", data.get("profileName").asString());

                return commentMap;
            } else {
                return commentMap;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;

        }
    }

    public static int getNumberOfComments(String postId){
        int numComments = 0;

        try (Session session = Connect.driver.session()) {            
            Result result = session.run("MATCH (p:post{uniqueIdentifier: $x})-[:hasComment]->(c) " 
            + "RETURN count(c) as numOfComments", parameters("x", postId));

            // Get number of comments for this post
            if (result.hasNext()) {
                Record data = result.next();

                numComments = data.get("numOfComments").asInt();
            } 
            // Return number of comments
            return numComments;
            
        } catch (Exception e) {
            e.printStackTrace();
            return numComments;
        }
    }

    public static List<JSONObject> getComments(String postId){
        List<JSONObject> allComments = new ArrayList<JSONObject>();

        try (Session session = Connect.driver.session()) {
            // Initialize list to store all the comments
            System.out.println("in getComments method: Running query!");
            // Run query to get all comments for the post with the given id, ordered by their timestamp
            Result result = session.run("MATCH (p:post{uniqueIdentifier: $x})-[:hasComment]->(c:comment) " 
            + "RETURN c ORDER BY c.timestamp DESC", parameters("x", postId));

            System.out.println("FINISHED RUNNING QUERY!");
            System.out.println(result.hasNext());

            // Loop through each comment in the result and add that comment to the list
            while (result.hasNext()) {
                Value comment = result.next().get("c");
                JSONObject commentJson = new JSONObject();

                // Add the data for this comment in the commentMap
                commentJson.put("id", comment.get("id").asString());
                commentJson.put("timestamp", comment.get("timestamp").asObject().toString());
                commentJson.put("username", comment.get("username").asString());
                commentJson.put("acs", DBUserInfo.getUserACS(comment.get("username").asString()));
                commentJson.put("content", comment.get("content").asString());
                commentJson.put("profileName", comment.get("profileName").asString());

                // Add it to the list of all comments
                allComments.add(commentJson);
            } 
            return allComments;
            
        } catch (Exception e) {
            e.printStackTrace();
            return allComments;

        }
    }
}