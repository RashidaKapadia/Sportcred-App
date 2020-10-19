package underdevelopment.db;

import java.util.Date;
import org.neo4j.driver.Driver;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.GraphDatabase;

public class DBUserInfo {
    // Variables to store user data from the signup form
    String email = "";
    String username = "";
    String password = "";
    String phoneNumber = "";
    String favSport = "";
    String sportLevel = "";
    String sportToLearn = "";
    String favTeam = "";
    Date dob;
    int acs = 100; // ACS initial value is 100

    public DBUserInfo(String email, String username, String password, String phoneNumber, Strign favSport,
            String sportLevel, String sportToLearn, String favTeam, Date dob) {
        // set the values for the instance variables
        this.email = email;
        this.username = username;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.favSport = favSport;
        this.sportLevel = sportLevel;
        this.sportToLearn = sportToLearn;
        this.favTeam = favTeam;
        this.dob = dob;

        // Create a user node in DB for the user with the provided data
        try (Session session = Connect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                    "MERGE (a:user {username: $usr, password: $pwd, phoneNumber: $phoneNum, "
                            + "favouriteSport: $favSport, sportLevel: $sportLevel, sportToLearn: $sportToLearn, "
                            + "favouriteTeam: $favTeam, dateOfBirth: $dob, acs: $acs}",
                    parameters("usr", this.username, "pwd", this.password, "phoneNum", this.phoneNumber, "favSport",
                            this.favSport, "sportLevel", this.sportLevel, "sportToLearn", this.sportToLearn, "favTeam",
                            this.favTeam, "dob", this.dob, "acs", this.acs)));
            session.close();
        }
    }

    /**
     * Return the username
     * @return username
     */
    public String getUsername() {
        return this.username;
    }

    /**
     * Return email
     * @return email
     */
    public String getEmail(){
        return this.email;
    }

    /**
     * Return sport level
     * @return sport level
     */
    public String getSportLevel(){
        return this.sportLevel;
    }

    /**
     * Return password
     * @return password
     */
    public String getPassword() {
        return this.password;
    }

    /**
     * Return phone number
     * @return phone number
     */
    public String getPhoneNumber() {
        return this.phoneNumber;
    }

    /**
     * Return favourite sport
     * @return favourite sport
     */
    public String getFavouriteSport() {
        return this.getFavouriteSport;
    }

    /**
     * Return sport to learn
     * @return sport to learn
     */
    public String getSportToLearn() {
        return this.favSport;
    }

    /**
     * Return favourite team
     * @return favourite team
     */
    public String getFavouriteTeam() {
        return this.favTeam;
    }

    /**
     * Return the date of birth
     * @return dob
     */
    public Date getDateOfBirth() {
        return this.dob;
    }

    /**
     * Return ACS
     * @return ACS
     */
    public int getACS(){
        return this.acs;
    }

    /**
     * Set the username to the new value
     * @param value
     */
    public void setUsername(String value) {
         this.username = value;
    }

    /**
     * Set the email to the new value
     * @param email
     */
    public void setEmail(String value){
         this.email = value;
    }

    public void setSportLevel(String value){
        this.sportLevel = value;
    }

    /**
     * Set the password to the new value
     * @param value
     */
    public void setPassword(String value) {
        this.password = value;
    }

    /**
     * Set the phone number to the new value
     * @param value
     */
    public void setPhoneNumber(String value) {
         this.phoneNumber = value;
    }

    /**
     * Set the favourite sport to the new value
     * @param value
     */
    public void setFavouriteSport(String value) {
         this.getFavouriteSport = value;
    }

    /**
     * Set the sport to learn to the new value
     * @param value
     */
    public void setSportToLearn(String value) {
         this.favSport = value;
    }

    /**
     * Set the favourite team to the new value
     * @param value
     */
    public void setFavouriteTeam(String value) {
        this.favTeam = value;
    }

    /**
     * Set the date of birth to the new value
     * @param value
     */
    public void setDateOfBirth(Date value) {
        this.dob = value;
    }

    /**
     * Set the acs to the new value
     * @param value
     */
    public void setACS(int value){
        this.acs = value;
    }
    

}
