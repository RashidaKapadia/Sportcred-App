package underdevelopment;

import java.io.IOException;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpServer;

import underdevelopment.api.LoginHandler;
import underdevelopment.api.utils.HttpRequestHandler;

public class App 
{
    static int PORT = 8080;
    public static void main(String[] args) throws IOException
    {
        // Config server to localhost and port
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", PORT), 0);

        server.createContext("/api/login", 
            new HttpRequestHandler("POST", LoginHandler.createSession(), false));
        server.createContext("/api/check-session", 
            new HttpRequestHandler("POST", LoginHandler.verifySession(), false));
        
        // Test routes
        server.createContext("/api/test/authorized-route", 
            new HttpRequestHandler("POST", LoginHandler.testAuthorizedRoute(), true));
        server.createContext("/api/test/non-authorized-route", 
            new HttpRequestHandler("POST", LoginHandler.testNonAuthorizedRoute(), false));

        // Start Server
        server.start();
        System.out.printf("Server started on port %d...\n", PORT);
    }
}
