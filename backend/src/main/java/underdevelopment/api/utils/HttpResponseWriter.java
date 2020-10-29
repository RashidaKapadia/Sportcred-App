package underdevelopment.api.utils;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import com.sun.net.httpserver.HttpExchange;

import org.neo4j.driver.internal.spi.ResponseHandler;

public class HttpResponseWriter {
    
    public static boolean writeResponseHeaders (HttpExchange r) {
        try {

            // TODO: refactor this
            List<String> a;
            a = new ArrayList<String>();
            a.add("text/plain; charset=utf-8");
            r.getResponseHeaders().put("Content-Type", a);

            if (r.getRequestHeaders().containsKey("Origin")) {
                a = new ArrayList<String>();
                a.add(r.getRequestHeaders().get("Origin").get(0));
                r.getResponseHeaders().put("Access-Control-Allow-Origin", a);
            }

            a = new ArrayList<String>();
            a.add("access-control-allow-origin");
            r.getResponseHeaders().put("Access-Control-Allow-Headers", a);            

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean writeReponse (HttpExchange r, int status, String response) {
        
        if (response == null) {
            return sendStatus (r, status);
        }
        
        try {
            writeResponseHeaders(r);
            r.sendResponseHeaders(status, response.length());
            OutputStream os = r.getResponseBody();
            os.write(response.getBytes());
            os.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendStatus (HttpExchange r, int status) {
        try {
            writeResponseHeaders(r);
            r.sendResponseHeaders(status, -1);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
