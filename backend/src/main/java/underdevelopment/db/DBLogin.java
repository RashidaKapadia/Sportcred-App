package underdevelopment.db;


import static org.neo4j.driver.Values.parameters;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;

public class DBLogin{
    
    //private static Driver driver;
    
    //constructor
    /*public DBLogin(){
        driver = Connect.getDriver(); 
    }
    */
    // verify the user credentials
    public boolean verifyUser(String username, String password){
         try (Session session = Connect.driver.session()) {
        	 Result result = session.run("MATCH (u:User) WHERE u.username = $x AND u.password = $y RETURN p IS NOT NULL",
             parameters("x",  username, "y", password));
        		if (result.hasNext()) {
        			//System.out.println("This user is registered");      
        			return false; 
        		}
        	return false; 
        }
        catch (Exception e) {
            //e.printStackTrace();
            return false;// server error probably
        }
}

}