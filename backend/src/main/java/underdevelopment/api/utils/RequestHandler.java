package underdevelopment.api.utils;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.IOException;
import java.util.HashMap;

/*
    This is a high level HttpHandler that manages multiple handlers for different 
    request types and calls them accordingly
*/
public class RequestHandler implements HttpHandler {

    HashMap<String, HttpHandler> requestHandlers;

    /**
     * Creates a requestHandler that handles multiple request types,
     * a minimum of one request type must be given
     * 
     * @param requestType the request type GET | POST | PUT | UPDATE | DELETE | ...
     * @param handler the corresponding handler to be called when the reques is made
     */
    public RequestHandler(String requestType, HttpHandler handler) {
        requestHandlers = new HashMap<String, HttpHandler>();
        requestHandlers.put(requestType, handler);
    }

    /**
     * Add/updates a request type
     * 
     * @param requestType the request type GET | POST | PUT | UPDATE | DELETE | ...
     * @param handler the corresponding handler to be called when the reques is made
     */
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
