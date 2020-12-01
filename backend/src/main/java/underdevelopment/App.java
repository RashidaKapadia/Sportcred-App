package underdevelopment;

import java.io.IOException;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpServer;

import underdevelopment.api.ACSHandler;
import underdevelopment.api.DailyCountHandler;
import underdevelopment.api.DailyDebateQuestion;
import underdevelopment.api.DailyServerHandler;
import underdevelopment.api.DebateGroups;
import underdevelopment.api.DebateHandler;
import underdevelopment.api.LoginHandler;
import underdevelopment.api.PostCommentsHandler;
import underdevelopment.api.PostHandler;
import underdevelopment.api.NotificationHandler;
import underdevelopment.api.ParticipationHandler;
import underdevelopment.api.ProfileHandler;
import underdevelopment.api.SignUpHandler;
import underdevelopment.api.TriviaHandler;
import underdevelopment.api.VoteResponseHandler;
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
                new HttpRequestHandler("POST", ProfileHandler.updateUserPassword(), authorized));
        server.createContext("/api/updateUserContact",
                new HttpRequestHandler("POST", ProfileHandler.updateUserContact(), authorized));
        
        server.createContext("/api/updateUserInfo",
            new HttpRequestHandler("POST", ProfileHandler.updateUserInfo(), authorized));
        server.createContext("/api/getUserInfo",
            new HttpRequestHandler("POST", ProfileHandler.getUserInfo(), authorized));
        
        // Sign Up API
        server.createContext("/api/signup", 
                new HttpRequestHandler("POST", SignUpHandler.handleSignUp(), false));

        // Users
        server.createContext("/api/get-users-list", 
                new HttpRequestHandler("POST", TriviaHandler.getUserList(), authorized));

        // ACS API (mostly for testing)
        server.createContext("/api/editACS", 
                new HttpRequestHandler("POST", ACSHandler.handleACS(), authorized));
        server.createContext("/api/getACS", 
                new HttpRequestHandler("POST", ACSHandler.getACS(), authorized));

        // Trivia route
        server.createContext("/api/trivia/get-questions", 
                new HttpRequestHandler("POST", TriviaHandler.generateQuestions(), authorized));
        server.createContext("/api/trivia/get-specific-questions", 
                new HttpRequestHandler("POST", TriviaHandler.getQuesionsByID(), authorized));
        server.createContext("/api/trivia/start-multiplayer-game", 
                new HttpRequestHandler("POST", TriviaHandler.startMultiTrivia(), authorized));
        server.createContext("/api/trivia/end-multiplayer-game", 
                new HttpRequestHandler("POST", TriviaHandler.endMultiTrivia(), authorized));
        server.createContext("/api/trivia/multiplayer-result", 
                new HttpRequestHandler("POST", TriviaHandler.getMultiTrivia(), authorized));
        server.createContext("/api/trivia/join-multiplayer-game", 
                new HttpRequestHandler("POST", TriviaHandler.joinMultiTrivia(), authorized));
        
        
        
        // Count resetting
        server.createContext("/api/reset-count", 
                new HttpRequestHandler("POST", DailyCountHandler.resetCount(), authorized));
        server.createContext("/api/subtract-count", 
                new HttpRequestHandler("POST", DailyCountHandler.subtractCount(), authorized));
        server.createContext("/api/has-daily-play", 
                new HttpRequestHandler("POST", DailyCountHandler.getCount(), authorized));
        
        // Notification routes
        server.createContext("/api/notifications/get",
                new HttpRequestHandler("POST", NotificationHandler.getNotifications(), authorized));
        server.createContext("/api/notifications/mark-read",
                new HttpRequestHandler("POST", NotificationHandler.markRead(), authorized));
        server.createContext("/api/notifications/delete",
                new HttpRequestHandler("POST", NotificationHandler.deleteNot(), authorized));
        
        // Test routes
        server.createContext("/api/test/authorized-route", 
            new HttpRequestHandler("POST", LoginHandler.testAuthorizedRoute(), authorized)
                .addHandler("GET", LoginHandler.testGet(), true));
        server.createContext("/api/test/non-authorized-route", 
            new HttpRequestHandler("POST", LoginHandler.testNonAuthorizedRoute(), false)
                .addHandler("GET", LoginHandler.testGet(), false));
                        
        // Post API test
        server.createContext("/api/addPost", 
                new HttpRequestHandler("POST", PostHandler.handlePostCreation(), false));
        // Delete Post API test
        server.createContext("/api/deletePost", 
                new HttpRequestHandler("DELETE", PostHandler.handleDeletePost(), authorized));
        
        server.createContext("/api/editPost", 
                new HttpRequestHandler("POST", PostHandler.updatePost(), authorized));

        server.createContext("/api/agreedOrDisagreedPost", 
                new HttpRequestHandler("POST", PostHandler.handlePostAgreeDisAgree(), authorized));

        server.createContext("/api/getPosts", 
                new HttpRequestHandler("POST", PostHandler.handleGetPosts(), authorized));

        // Create Comment API
        server.createContext("/api/addComment", 
                new HttpRequestHandler("POST", PostCommentsHandler.handleCreateComment(), authorized));
        // Delete Comment API 
        server.createContext("/api/deleteComment", 
                new HttpRequestHandler("POST", PostCommentsHandler.handleDeleteComment(), authorized));
        
        server.createContext("/api/editComment", 
                new HttpRequestHandler("POST", PostCommentsHandler.handleEditComment(), authorized));

        server.createContext("/api/getComments", 
                new HttpRequestHandler("POST", PostCommentsHandler.handleGetComments(), authorized));
                
        // Search Bar API to get posts given title
        server.createContext("/api/getPostsForSearch", 
                new HttpRequestHandler("POST", PostHandler.handleGetPostsForSearchBar(), authorized));
        
        
        
        // Debate
        server.createContext("/api/debate/get-daily-question", 
        new HttpRequestHandler("POST", DailyDebateQuestion.handleGetDailyDebateQuestion(), authorized));

        server.createContext("/api/debate/add-response", 
        new HttpRequestHandler("POST", DailyDebateQuestion.handleAddResponseToDailyDebateQuestion(), authorized));

        server.createContext("/api/debate/get-daily-question-response", 
        new HttpRequestHandler("POST", DailyDebateQuestion.handleGetResponseToDailyDebateQuestion(), authorized));

        server.createContext("/api/debate/create-groups", 
        new HttpRequestHandler("POST", DebateGroups.createDebateGroups(), authorized));

        server.createContext("/api/debate/get-ongoing-questions", 
        new HttpRequestHandler("POST", DebateHandler.getOngoingQuesions(), authorized));

        server.createContext("/api/debate/get-finished-questions", 
        new HttpRequestHandler("POST", DebateHandler.getFinishedQuesions(), authorized));

        server.createContext("/api/debate/get-group-responses-my-question", 
        new HttpRequestHandler("POST", DebateHandler.getResponsesMyQuestion(), authorized));

        server.createContext("/api/debate/get-previous-topic-result", 
        new HttpRequestHandler("POST", DebateHandler.getResultMyPreviousQuestion(), authorized));

        server.createContext("/api/debate/get-group-responses", 
        new HttpRequestHandler("POST", DebateHandler.getResponsesOngoing(), authorized));

        server.createContext("/api/debate/get-debate-group-responses-n-results", 
        new HttpRequestHandler("POST", DebateHandler.getResponsesFinished(), authorized));

        // voting for debate
        server.createContext("/api/debate/vote-response", 
                new HttpRequestHandler("POST", VoteResponseHandler.voteResponse(), authorized));
        
        // notification for new debate question (for testing)
        server.createContext("/api/debate/send-daily-questions", 
        		new HttpRequestHandler("POST", DailyServerHandler.sendDailyNotification(), authorized));        
        // Start Server
        server.start();
    }

}
