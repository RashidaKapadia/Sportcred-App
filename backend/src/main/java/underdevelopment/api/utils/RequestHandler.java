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

    private class HandlerSpecs {
        private HttpHandler handler;
        private boolean authenticate;
    
        HandlerSpecs(HttpHandler handler, boolean authenticate) {
            this.handler = handler;
            this.authenticate = authenticate;
        }
    
        public boolean isAuthenticate() {
            return authenticate;
        }
    
        public HttpHandler getHandler() {
            return handler;
        }
    }

    HashMap<String, HandlerSpecs> requestHandlers;

    /**
     * Creates a requestHandler that handles multiple request types,
     * a minimum of one request type must be given
     * 
     * @param requestType the request type GET | POST | PUT | UPDATE | DELETE | ...
     * @param handler the corresponding handler to be called when the reques is made
     * @param authenticate determines whether this route will impose token authentication
     */
    public RequestHandler(String requestType, HttpHandler handler, boolean authenticate) {
        requestHandlers = new HashMap<String, HandlerSpecs>();
        requestHandlers.put(requestType, new HandlerSpecs(handler, authenticate));
    }

    /**
     * Add/updates a request type
     * 
     * @param requestType the request type GET | POST | PUT | UPDATE | DELETE | ...
     * @param handler the corresponding handler to be called when the reques is made
     */
    public RequestHandler addHandler (String requestType, HttpHandler handler, boolean authenticate) {
        requestHandlers.put(requestType, new HandlerSpecs(handler, authenticate));
        return this;
    }

    @Override
	final public void handle(HttpExchange exchange) throws IOException {
        String requestType = exchange.getRequestMethod();
        HttpHandler handler = requestHandlers.get(requestType).getHandler();
        if (handler != null) {
            handler.handle(exchange);
        }
    }
}
