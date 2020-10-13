package underdevelopment.api.utils;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.IOException;
import java.util.HashMap;

public class RequestHandler implements HttpHandler {

    HashMap<String, HttpHandler> requestHandlers;

    public RequestHandler(String requestType, HttpHandler handler) {
        requestHandlers = new HashMap<String, HttpHandler>();
        requestHandlers.put(requestType, handler);
    }

    public RequestHandler addHandler (String requestType, HttpHandler handler) {
        requestHandlers.put(requestType, handler);
        return this;
    }

    @Override
	final public void handle(HttpExchange exchange) throws IOException {
        String requestType = exchange.getRequestMethod();
        HttpHandler handler = requestHandlers.get(requestType);
        if (handler != null) {
            handler.handle(exchange);
        }
	}
}
