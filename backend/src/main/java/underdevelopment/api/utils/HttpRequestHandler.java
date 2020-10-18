package underdevelopment.api.utils;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import org.json.JSONObject;

import underdevelopment.Utils;

import java.io.IOException;
import java.util.HashMap;

/*
    This is a high level HttpHandler that manages multiple handlers for different 
    request types, calls them accordingly, and enforces authentication if needed
*/
public class HttpRequestHandler implements HttpHandler {

    private class HandlerSpecs {
        private JsonRequestHandler handler;
        private boolean authenticate;
    
        HandlerSpecs(JsonRequestHandler handler, boolean authenticate) {
            this.handler = handler;
            this.authenticate = authenticate;
        }
    
        public boolean isAuthenticate() {
            return authenticate;
        }
    
        public JsonRequestHandler getHandler() {
            return handler;
        }
    }

    HashMap<String, HandlerSpecs> requestHandlers;

    /**
     * Creates a requestHandler that handles multiple request types,
     * a minimum of one request type must be given
     * 
     * @param requestType the request type GET | POST | PUT | UPDATE | DELETE | ...
     * @param handler the corresponding handler to be called when the request is made
     * @param authenticate determines whether this route will impose token authentication
     */
    public HttpRequestHandler(String requestType, JsonRequestHandler handler, boolean authenticate) {
        requestHandlers = new HashMap<String, HandlerSpecs>();
        requestHandlers.put(requestType, new HandlerSpecs(handler, authenticate));
    }

    /**
     * Add/updates a request type
     * 
     * @param requestType the request type GET | POST | PUT | UPDATE | DELETE | ...
     * @param handler the corresponding handler to be called when the reques is made
     */
    public HttpRequestHandler addHandler (String requestType, JsonRequestHandler handler, boolean authenticate) {
        requestHandlers.put(requestType, new HandlerSpecs(handler, authenticate));
        return this;
    }

    @Override
	final public void handle(HttpExchange r) throws IOException {

        String requestType = r.getRequestMethod();
        JsonRequestHandler handler = requestHandlers.get(requestType).getHandler();
        JSONObject jsonObj;

        // Read the json body
        try {
            jsonObj = new JSONObject(Utils.convert(r.getRequestBody()));
        } catch (Exception e) {
            HttpResponseWriter.sendStatus(r, Status.BADREQUEST);
            e.printStackTrace();
            return;
        }

        // Check the session token if authentication is required
        if (requestHandlers.get(requestType).isAuthenticate()) {
            String sessionToken = "";
            try {
                sessionToken = jsonObj.getString("token");
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (!JWTSessionManager.validateToken(sessionToken)) {
                    HttpResponseWriter.sendStatus(r, Status.FORBIDDEN);
                    return;
                }
            }
        }

        // Call the endpoint's handler
        if (handler != null) {
            JsonHttpReponse response = handler.handle(jsonObj);
            HttpResponseWriter.writeReponse(r, response.getStatus(), response.getJsonString());
        } else {
            HttpResponseWriter.sendStatus(r, Status.NOT_IMPLEMENTED);
        }
    }
}
