package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.util.ArrayList;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;
import org.neo4j.driver.Value;

public class DBUserInfo {

  /**
   * Given the different fields, create a user node with those fields and values
   * in the DB.
   * 
   * @param email
   * @param username
   * @param password
   * @param phoneNumber
   * @param favSport
   * @param sportLevel
   * @param sportToLearn
   * @param favTeam
   * @param dob
   */
  public static boolean addUser(String firstname, String lastname, String email, String username, String password,
      String phoneNumber, String favSport, String sportLevel, String sportToLearn, String favTeam, String dob) {
    // set the values for the instance variables
    System.out.println("adding the user: " + username);

    // Create a user node in DB for the user with the provided data
    try (Session session = Connect.driver.session()) {
      session.writeTransaction(tx -> tx.run(String.format(
        "MERGE (a:user {firstname: \"%s\", lastname: \"%s\", email: \"%s\", username: \"%s\", password: \"%s\", "
        + "phoneNumber: \"%s\", favSport: \"%s\", sportLevel: \"%s\", sportToLearn: \"%s\","
        + "favTeam: \"%s\", dob: \"%s\", acs: %d, about: \"%s\", status: \"%s\", numberOfPosts: %d, triviaMultiPlays: 5})",
    firstname, lastname, email, username, password, phoneNumber, favSport, sportLevel, sportToLearn, favTeam, dob,
    100, "N/A","Hungry for basketball", 0)));
      // System.out.println("finished adding the user");
      session.close();
      return true;
    } catch (Exception e) {
      return false;
    }

  }

  public static String getUserFullName(String username){
    String fullName = "";
    // Run query to check if a user with given username already exists
    try (Session session = Connect.driver.session()) {
      try (Transaction tx = session.beginTransaction()) {
        Result names = tx.run("MATCH (u:user {username: $x}) RETURN u.firstname as first, u.lastname as last", parameters("x", username));

        // If any results have been returned, it means user exists already
        if (names.hasNext()) {
          Record data = names.single();

           fullName = data.get("first").asString() + ", " + data.get("last").asString();
        }
      }
    }

    // Return false if user with given username does not exist
    return fullName;
  }
  /**
   * Return true if and only if a user with the given username already exists
   * 
   * @param username
   * @return bool
   */
  public static Boolean checkUsernameExists(String username) {
    // Run query to check if a user with given username already exists
    try (Session session = Connect.driver.session()) {
      try (Transaction tx = session.beginTransaction()) {
        Result node_bool = tx.run("MATCH (u:user {username: $x}) RETURN u", parameters("x", username));

        // If any results have been returned, it means user exists already
        if (node_bool.hasNext()) {
          return true;
        }
      }
    }

    // Return false if user with given username does not exist
    return false;

  }

  /**
   * Return true if and only if a user with the given email already exists
   * 
   * @param email
   * @return bool
   */
  public static Boolean checkEmailExists(String email) {
    // Run query to check if a user with given email already exists
    try (Session session = Connect.driver.session()) {
      try (Transaction tx = session.beginTransaction()) {
        Result node_bool = tx.run("MATCH (u:user {email: $x}) RETURN u", parameters("x", email));

        // If any results have been returned, it means user exists already
        if (node_bool.hasNext()) {
          return true;
        }
      }
    }

    // Return false if user with given username does not exist
    return false;

  }
  
  
  // Returns an array of arraylists of uers
  public static ArrayList<String>[] returnUsers( ) {
	  ArrayList<String> users[] = new ArrayList[3];
	  users[0] = new ArrayList<String>();
	  users[1] = new ArrayList<String>();
	  users[2] = new ArrayList<String>();

	 try (Session session = Connect.driver.session()){
        	try (Transaction tx = session.beginTransaction()) {
        		int plays;
    	        System.out.println("getting trivia Count");
				Result result = tx.run("match(n:user) return n.username as username, n.lastname as lastname, n.firstname as firstname");
				while(result.hasNext()) {
					Record rec = result.next();
					//System.out.println(rec.get("username"));
					//System.out.println(rec.get("lastname"));
					//System.out.println(rec.get("firstname"));

					users[0].add(rec.get("username").asString());
					users[1].add(rec.get("lastname").asString());
					users[2].add(rec.get("firstname").asString());
				}
				tx.close();
				session.close();
        	}catch(Exception e) {
        		e.printStackTrace();
        	}
        }catch(Exception e) {
 		e.printStackTrace();
 	}
        return users;
  }

  /**
   * Return the count of posts for this user
   * 
   * @param username
   * @return int
   */
  public static int getPostCount(String username) {
    try (Session session = Connect.driver.session()) {
      try (Transaction tx = session.beginTransaction()) {
        Result node = tx.run("MATCH (u:user {username: $x}) RETURN u.numberOfPosts as count", parameters("x", username));
        System.out.println("returns node");
        Record data = node.single();
        //int postCount =  Integer.parseInt((data.get("count").asString()));
        int postCount =  data.get("count").asInt();
        return postCount;
      }
        // If any results have been returned, it means user exists already
      catch(Exception e){
        e.printStackTrace();
        return -1;
      }
    }
    catch(Exception e){
      e.printStackTrace();
      return -1;
    }
  }

   /**
   * Return the count of posts for this user
   * 
   * @param username
   * @return boolean
   */
  public static boolean updatePostCount(String username, int num) {
    System.out.println(num);
    try(Session session = Connect.driver.session()){
      session.writeTransaction(tx->tx.run("MATCH (u: user{username: $x}) SET u.numberOfPosts = $y + toInteger(u.numberOfPosts) ",
      parameters("x", username, "y", num)));
      session.close();
      return true;
    }
    catch(Exception e){
      e.printStackTrace();
      return false;
    }

  }

}