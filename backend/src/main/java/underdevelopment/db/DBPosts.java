package underdevelopment.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import static org.neo4j.driver.Values.parameters;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBPosts {


    /***
     * create a post using following parameters
     */
    public static String createPost(String username, String content, String title, String profileName, int postsCount){
        //
        System.out.println("creating post for user: " + username);
        String id = username.concat("."+ Integer.toString(postsCount+1));
        System.out.println("id:"+ id);

        //create a post node
        try(Session session = Connect.driver.session()){
            session.writeTransaction(tx->tx.run("MERGE (p: post{ uniqueIdentifier: $z,username: $x, content: $y, title: $u,"+
            "profileName: $a, peopleAgree: $b, peopleDisagree: $c, comments: $d})",
            parameters("z", id, "x", username,"y", content, "u", title,"a",
            profileName, "b", new HashSet<String>(), "c", new HashSet<String>(),"d", new ArrayList<String>())));// COMMENTS INITIALIAZATION NEEDS TO BE UPDATED
            session.close();
            return id;
        }
        catch(Exception e){
            e.printStackTrace();
            return "";

        }

    }

    public static void editPost(){

    }

    public static boolean deletePost(String postId){
        try (Session session = Connect.driver.session()){
			session.writeTransaction(tx -> tx.run(
                "MATCH (p:post {uniqueIdentifier: $x}) DELETE p", parameters("x", postId)));
			session.close();
			return true;
		}catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Map<String, Object> getPost(String id){
        try (Session session = Connect.driver.session()) {
            Result result = session.run("MATCH (p:post {uniqueIdentifier: $x}) RETURN p",
                                        parameters("x", id));
                                        Map<String, Object> postMap = new HashMap<>();
            if(result.hasNext()){
                postMap.put("username", result.next().get("username").asString());
                postMap.put("content", result.next().get("content").asString());
                postMap.put("title", result.next().get("title").asString());
                postMap.put("profileName", result.next().get("profileName").asString());
                postMap.put("peopleAgree", result.next().get("peopleAgree").asList());
                postMap.put("peopleDisagree", result.next().get("peopleDisagree").asList());
                postMap.put("comments", result.next().get("comments").asList());// UNSURE ABOUT THIS
                return postMap;
            }
            else{
                return postMap;
            }
        }catch(Exception e){
            e.printStackTrace();
            return null;

        }
    }
                            

    public static boolean addRelationToPost(String username, String postId){
        try (Session session = Connect.driver.session()){
			session.writeTransaction(tx -> tx.run(
                "MATCH (u:user {username: $x}), (p:post {uniqueIdentifier: $y})\n" +
                "MERGE (u)-[Posted]->(p)\n" ,parameters("x", username, "y", postId)));
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

    
}