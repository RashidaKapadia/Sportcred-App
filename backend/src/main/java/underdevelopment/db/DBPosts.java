package underdevelopment.db;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import static org.neo4j.driver.Values.parameters;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBPosts {


    /***
     * create a post using following parameters
     */
    public static boolean createPost(String username, String content, String title, String profileName, int postsCount){
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
            return true;
        }
        catch(Exception e){
            e.printStackTrace();
            return false;

        }

    }

    public static void editPost(){

    }

    public static void deletePost(){

    }
    
}
