package underdevelopment.api;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class LoginHandler {
    public static HttpHandler createSession() {
        return (HttpExchange r) -> {
            System.out.println("TODO login user");
        };
    }

    public static HttpHandler validateLogin() {
        return (HttpExchange r) -> {
            System.out.println("TODO validate login");
        };
    }

    public static HttpHandler verifySession() {
        return (HttpExchange r) -> {
            System.out.println("TODO verify session");
        };
    }
}
