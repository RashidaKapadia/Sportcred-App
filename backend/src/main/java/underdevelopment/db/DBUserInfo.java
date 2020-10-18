public class DBUserInfo {

    String email = "";
    String username = "";
    String password1 = "";
    String phoneNumber = "";
    String favSport = "";
    String sportLevel = "";
    String sportToLearn = "";
    String favTeam = "";
    int age;
    int acs = 100;

    public DBUserInfo(String email, String username, String password, 
    String phoneNumber, Strign favSport, String sportLevel, String sportToLearn, String favTeam, 
    int age){
        this.email = email;
        this.username = username;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.favSport = favSport;
        this.sportLevel = sportLevel;
        this.sportToLearn = sportToLearn;
        this.favTeam = favTeam;
        this.age = age;
        
        try (Session session = DBConnect.driver.session()) {
            session.writeTransaction(
          tx -> tx.run("MERGE (a:user {username: $usr, password: $pwd, phoneNumber: $phoneNum, " + 
          "favouriteSport: $favSport, sportLevel: $sportLevel, sportToLearn: $sportToLearn, " +
          "favouriteTeam: $favTeam, age: $age, acs: $acs}",
              parameters("usr", this.username, "pwd", this.password, "phoneNum", this.phoneNumber, "favSport", this.favSport,
              "sportLevel", this.sportLevel, "sportToLearn", this.sportToLearn, "favTeam", this.favTeam, "age", this.age, "acs", this.acs)));
        session.close();
        }
    }


}