package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

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
  public static boolean addUser(String firstname, String lastname, String email, String username, String password, String phoneNumber, String favSport,
      String sportLevel, String sportToLearn, String favTeam, String dob) {
    // set the values for the instance variables
    System.out.println("adding the user: " + username);

    // Create a user node in DB for the user with the provided data
    try (Session session = Connect.driver.session()) {
      session.writeTransaction(tx -> tx.run(String.format(
          "MERGE (a:user {firstname: \"%s\", lastname: \"%s\", email: \"%s\", username: \"%s\", password: \"%s\", " +
          "phoneNumber: \"%s\", favSport: \"%s\", sportLevel: \"%s\", sportToLearn: \"%s\"," +
          "favTeam: \"%s\", dob: \"%s\", acs: %d, about: \"%s\", status: \"%s\"})",
          firstname, lastname, email, username, password, phoneNumber, favSport, sportLevel, sportToLearn, favTeam, dob, 200, "N/A",
          "Hungry for basketball")));
      // System.out.println("finished adding the user");
      session.close();
      return true;
    } catch (Exception e) {
      return false;
    }

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
}