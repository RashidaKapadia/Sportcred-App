package underdevelopment.api.utils;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import com.sun.net.httpserver.HttpExchange;

public class HttpResponseWriter {
    
    public static boolean writeReponse (HttpExchange r, int status, String response) {
        
        if (response == null) {
            return sendStatus (r, status);
        }
        
        try {
            List<String> a;
            
            a = new ArrayList<String>();
            a.add("text/plain; charset=utf-8");
            r.getResponseHeaders().put("Content-Type", a);

            a = new ArrayList<String>();
            a.add("*");
            r.getResponseHeaders().put("Access-Control-Allow-Origin", a);

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
            r.sendResponseHeaders(status, -1);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
