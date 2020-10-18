import java.lang.reflect.Parameter;

public class DBProfile{

    String username = "";
    String email = "";
    String phoneNumber = "";
    String about = "";
    String status = "";
    Date dob;
    int acs = 100;

    // DB command for upadting user status
    public DBUserStatus(String username, String status){
        this.username = username;
        this.status = status;
        
        try (Session session = DBConnect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) SET a.status = $status RETURN a",
                parameters("username",this.username, "status", this.status)));
            
            session.close();
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }

    // DB command for upadting user acs
    public DBUserACS(String username, String acs){
        this.username = username;
        this.acs = acs;
        
        try (Session session = DBConnect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) SET a.acs = $acs RETURN a",
                parameters("username",this.username, "acs", this.acs)));
            
            session.close();
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }

    // DB command for upadting user date of birth
    public DBUserDOB(String username, Date dob){
        this.username = username;
        this.dob = dob;
        
        try (Session session = DBConnect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) SET a.dob = $dob RETURN a",
                parameters("username",this.username, "dob", this.dob)));
            
            session.close();
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }

    // DB command for upadting user's about section
    public DBUserAbout(String username, String about){
        this.username = username;
        this.about = about;
        
        try (Session session = DBConnect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) SET a.about = $about RETURN a",
                parameters("username",this.username, "about", this.about)));
            
            session.close();
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }

    // DB command for upadting user's phone number
    public DBUserPhoneNumber(String username, String phoneNumber){
        this.username = username;
        this.phoneNumber = phoneNumber;
        
        try (Session session = DBConnect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) SET a.phoneNumber = $phoneNumber RETURN a",
                parameters("username",this.username, "phoneNumber", this.phoneNumber)));
            
            session.close();
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }

    // DB command for upadting user's email
    public DBUserEmail(String username, String email){
        this.username = username;
        this.email = email;
        
        try (Session session = DBConnect.driver.session()) {
            session.writeTransaction(tx -> tx.run(
                "MATCH (a:user {username: $username}) SET a.email = $email RETURN a",
                parameters("username",this.username, "email", this.email)));
            
            session.close();
        }
        catch (Exception e){
            // FOR DEBUG
            e.printStackTrace();
        }
    }
}