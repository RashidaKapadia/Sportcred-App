package underdevelopment.db;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import static org.neo4j.driver.Values.parameters;

import org.json.JSONObject;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;
import org.neo4j.driver.Value;

public class DBPosts {


    public static ArrayList<Map<String, Object>> getPosts() {
        try (Session session = Connect.driver.session()) {
            Result result = session.run("MATCH (p:post ) RETURN p ORDER By p.timestamp DESC",
                                        parameters());

            ArrayList<Map<String, Object>> posts = new ArrayList<>();
            while (result.hasNext()) {
                posts.add(result.next().get("p").asMap());
            }
            return posts;
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    


    /***
     * create a post using following parameters
     */
    public static String createPost(String username, String content, String title){
        //
        System.out.println("creating post for user: " + username);
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        //String id = username.concat("."+ Integer.toString(postsCount+1));
        String id = username.concat("."+ timestamp);        
        String profileName = DBUserInfo.getUserFullName(username);

        System.out.println("id:"+ id);

        //create a post node
        try(Session session = Connect.driver.session()){
            session.writeTransaction(tx->tx.run("MERGE (p: post{ uniqueIdentifier: $z,username: $x, content: $y, title: $u,"+
            "profileName: $a, peopleAgree: $b, peopleDisagree: $c, timestamp: datetime()})",
            parameters("z", id, "x", username,"y", content, "u", title,"a",
            profileName, "b", new HashSet<Object>(), "c", new HashSet<Object>())));// COMMENTS INITIALIAZATION NEEDS TO BE UPDATED
            session.close();
            return id;
        }
        catch(Exception e){
            e.printStackTrace();
            return "";

        }

    }

    public static boolean editPost(String postId, String content, String title){
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (p:post) WHERE p.uniqueIdentifier = $id SET p.content = $content, p.title = $title",
                parameters("id", postId, "content", content, "title",title)));

           session.close();
           return true;
    }
       catch (Exception e){
      // FOR DEBUG
            e.printStackTrace();
            return false;
       }
    }

    public static boolean editPostTitle(String postId, String newData){
        System.out.println("Was here!:");
        try (Session session = Connect.driver.session()){
            try (Transaction tx = session.beginTransaction()){
                tx.run("MATCH (p: post {uniqueIdentifier: $x}) SET p.title = $y",
                parameters("x", postId, "y", newData));
                //tx.run(String.format( "MATCH (p:post) WHERE p.uniqueIdentifier = '%s' SET p.title = '%s'", postId, newData)); 
                tx.commit();
                tx.close();
                session.close();
                return true;   
            }
		}catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    public static boolean editPostContent(String postId, String newData){
        try (Session session = Connect.driver.session()){
			session.writeTransaction(tx->tx.run("MATCH (p: post{uniqueIdentifier: $x}) SET p.content = $y",
      parameters("x", postId, "y", newData)));
			session.close();
			return true;
		}catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    public static boolean deletePost(String postId){
        try (Session session = Connect.driver.session()){
			session.writeTransaction(tx -> tx.run(
                "MATCH (p:post {uniqueIdentifier: $x}) DETACH DELETE p", parameters("x", postId)));
			session.close();
			return true;
		}catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
                            

    public static boolean addRelationToPost(String username, String postId){
        try (Session session = Connect.driver.session()){
			session.writeTransaction(tx -> tx.run(
                "MATCH (u:user {username: $x}), (p:post {uniqueIdentifier: $y})\n" +
                "MERGE (u)-[r:Posted]->(p)\n" ,parameters("x", username, "y", postId)));
			session.close();
			return true;
		}catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean removeRelation(String username, String postId){
        try (Session session = Connect.driver.session()){
			session.writeTransaction(tx -> tx.run(
                "MATCH (u:user {username: $x}) -[r:Posted] ->(p:post {uniqueIdentifier: $y})\n" +
                "Delete r", parameters("x", username, "y", postId)));
			session.close();
			return true;
		}catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    public static boolean likedOrDislikedPost(String username, String postId, boolean agreed){
        try (Session session = Connect.driver.session()){
            try (Transaction tx = session.beginTransaction()) {
                // obtain the list of people who agreed to the post
                Result agreeSetResult = tx.run("Match (p:post {uniqueIdentifier: $x}) RETURN p.peopleAgree as agreeSet", parameters("x", postId));
                List<Object> agreeList = agreeSetResult.single().get("agreeSet").asList();
                Set<Object> agreeSet = new HashSet<Object>(agreeList);
                // obtain the list of people who disagreed to the post
                Result disagreeSetResult = tx.run("Match (p:post {uniqueIdentifier: $x}) RETURN p.peopleDisagree as disagreeSet", parameters("x", postId));
                List<Object> disagreeList = disagreeSetResult.next().get("disagreeSet").asList();
                Set<Object> disagreeSet = new HashSet<Object>(disagreeList);

               // if the user agreed to the post, perform the following logic
                if(agreed){
                    // Check if this user already agreed to this post, if so remove them from agree list
                    if (agreeSet.contains(username)){
                        agreeSet.remove(username);
                    }else{
                        // If user did not agree already, add their name to the agreed list
                        agreeSet.add(username);
                    }
                     //  and update through query
                     tx.run("MERGE (p: post {uniqueIdentifier: $x}) SET p.peopleAgree = $y",
                     parameters("x", postId, "y", agreeSet));
                     
                    // user can either agree or diagree,
                    //so if user has disagreed to the post before, remove his name from the disagreed list
                    if(disagreeSet.contains(username)){
                        System.out.println("yes disagree list contains :" + username);
                        disagreeSet.remove(username);
                        tx.run("MERGE (p: post {uniqueIdentifier: $x}) SET p.peopleDisagree = $y",
                        parameters("x", postId, "y", disagreeSet));

                    }
                   
                    tx.commit();
                    tx.close();
                }
                //if the user disagreed to the post, perform the following logic
                else{
                    // If the user disagreed already, remove them from disagree list
                    if (disagreeSet.contains(username)){
                        disagreeSet.remove(username);
                    }else{
                        // If user did not disagree already, add them to the disagreed list
                        disagreeSet.add(username);
                    }

                     // update through query
                     tx.run("MERGE (p: post {uniqueIdentifier: $x}) SET p.peopleDisagree = $y",
                     parameters("x", postId, "y", disagreeSet));

                    // user can either agree or diagree,
                    //so if user has agreed to the post before, remove his name from the agreed list
                    if(agreeSet.contains(username)){
                        System.out.println("yes agree list contains :" + username);
                        //agreeList.remove("username");
                        agreeSet.remove(username);
                        tx.run("MERGE (p: post {uniqueIdentifier: $x}) SET p.peopleAgree = $y",
                        parameters("x", postId, "y", agreeSet));
                    }

                    tx.commit();
                    tx.close();
                }
            }
			session.close();
			return true;
		}catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int getNumberOfLikes(String postId){
        int numLikes = 0;

        try (Session session = Connect.driver.session()) {            
            Result result = session.run("MATCH (p:post{uniqueIdentifier: $x})" 
            + "RETURN p.peopleAgree as peopleAgree", parameters("x", postId));
            // Get number of comments for this post
            if (result.hasNext()) {
                List<Object> agreeList = result.single().get("peopleAgree").asList();
                Set<Object> agreeSet = new HashSet<Object>(agreeList);
                return agreeSet.size();
            }
            return numLikes;          
        } catch (Exception e) {
            e.printStackTrace();
            return numLikes;
        }
    }
    
    public static int getNumberOfDisLikes(String postId){
        int numDislikes = 0;

        try (Session session = Connect.driver.session()) {            
            Result result = session.run("MATCH (p:post{uniqueIdentifier: $x})" 
            + "RETURN p.peopleDisagree as peopleDisagree", parameters("x", postId));
            // Get number of comments for this post
            if (result.hasNext()) {
                List<Object> agreeList = result.single().get("peopleDisagree").asList();
                Set<Object> agreeSet = new HashSet<Object>(agreeList);
                return agreeSet.size();
            }
            return numDislikes;          
        } catch (Exception e) {
            e.printStackTrace();
            return numDislikes;
        }
    }
    
    public static ArrayList<Map<String, Object>> getPostsGivenTitle(String title){
        // Initialize list to store all the posts
        ArrayList<Map<String, Object>> posts = new ArrayList<>();

        try (Session session = Connect.driver.session()) {
            System.out.println("in getPosts by Title method: Running query!");
            // Run query to get all posts with given title ordered by their timestamp
            Result result = session.run("MATCH (p:post) WHERE toLower(p.title) CONTAINS toLower($x) " 
            + "RETURN p ORDER BY p.timestamp DESC", parameters("x", title));

            System.out.println("FINISHED RUNNING QUERY!");
            System.out.println(result.hasNext());

            
            while (result.hasNext()) {
                posts.add(result.next().get("p").asMap());
            }

            return posts;
        } catch (Exception e) {
            e.printStackTrace();
            return posts;

        }
    }
}