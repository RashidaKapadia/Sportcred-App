import java.util.Date;

public class DBUserInfo {
    // Variables to store user data from the signup form
    String email = "";
    String username = "";
    String password1 = "";
    String phoneNumber = "";
    String favSport = "";
    String sportLevel = "";
    String sportToLearn = "";
    String favTeam = "";
    Date dob;
    int acs = 100; // ACS initial value is 100

    public DBUserInfo(String email, String username, String password, String phoneNumber, Strign favSport,
            String sportLevel, String sportToLearn, String favTeam, Date dob) {
        this.email = email;
        this.username = username;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.favSport = favSport;
        this.sportLevel = sportLevel;
        this.sportToLearn = sportToLearn;
        this.favTeam = favTeam;
        this.dob = dob;

        try (Session session = DBConnect.driver.session()) {
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

}