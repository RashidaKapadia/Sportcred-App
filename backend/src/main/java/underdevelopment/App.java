package underdevelopment;

import java.io.IOException;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpServer;

import underdevelopment.api.ACSHandler;
import underdevelopment.api.LoginHandler;
import underdevelopment.api.ProfileHandler;
import underdevelopment.api.SignUpHandler;
import underdevelopment.api.TriviaHandler;
import underdevelopment.api.utils.HttpRequestHandler;


import underdevelopment.db.Connect;
import underdevelopment.db.DBMockdata;

//Kill the process
//>> kill <pid>
public class App 
{
    static final int API_PORT = 8080;
    public static void main(String[] args) throws IOException
    {
        // Dev settings
        String dbUsername = "neo4j";
        String dbPassword = "1234";
        
        // Connect to the database
        Connect.connectDB(dbUsername, dbPassword);

        // Check the database connection
        System.out.print("Checking database connection ... ");
        if (Connect.checkConnection()) {
            System.out.println("success, connected to: " + dbUsername);
        } else {
            System.out.println("FAILED to connect to: " + dbUsername);
            System.exit(1);
        }
        
        // Check the mockdata
        DBMockdata.checkAndUpdate();

        // Start the server
        startAPIServer();
        System.out.printf("Server started on port %d ...\n", API_PORT);
    }

    public static void startAPIServer() throws IOException {

        // Config server to localhost and port
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", API_PORT), 0);

        // Should be set to true for deployed app
        boolean authorized = false;
 
        server.createContext("/api/login", 
            new HttpRequestHandler("POST", LoginHandler.createSession(), false));
        server.createContext("/api/check-session", 
            new HttpRequestHandler("POST", LoginHandler.verifySession(), false));

        // Profile APIs
        server.createContext("/api/updateUserPassword",
                new HttpRequestHandler("POST", ProfileHandler.updateUserPassword(), false));
        server.createContext("/api/updateUserEmail",
                new HttpRequestHandler("POST", ProfileHandler.updateUserEmail(), false));
        server.createContext("/api/updateUserInfo",
            new HttpRequestHandler("POST", ProfileHandler.updateUserInfo(), authorized));
        server.createContext("/api/getUserInfo",
            new HttpRequestHandler("POST", ProfileHandler.getUserInfo(), authorized));
        
        // Sign Up API
        server.createContext("/api/signup", 
                new HttpRequestHandler("POST", SignUpHandler.handleSignUp(), false));
              
        // ACS API (mostly for testing)
        server.createContext("/api/editACS", 
                new HttpRequestHandler("POST", ACSHandler.handleACS(), authorized));
        server.createContext("/api/getACS", 
                new HttpRequestHandler("POST", ACSHandler.getACS(), authorized));

        // Trivia route
        server.createContext("/api/trivia/get-questions", 
                new HttpRequestHandler("POST", TriviaHandler.generateQuestions(), authorized));

        // Test routes
        server.createContext("/api/test/authorized-route", 
            new HttpRequestHandler("POST", LoginHandler.testAuthorizedRoute(), authorized)
                .addHandler("GET", LoginHandler.testGet(), true));
        server.createContext("/api/test/non-authorized-route", 
            new HttpRequestHandler("POST", LoginHandler.testNonAuthorizedRoute(), false)
                .addHandler("GET", LoginHandler.testGet(), false));

        // Start Server
        server.start();
    }

}
