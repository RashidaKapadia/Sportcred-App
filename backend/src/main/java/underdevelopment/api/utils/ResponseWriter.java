package underdevelopment.api.utils;

import java.io.OutputStream;
import com.sun.net.httpserver.HttpExchange;

public class ResponseWriter {
    
    public static boolean writeReponse (HttpExchange r, int status, String response) {
        try {
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

    public static boolean sendStatus (HttpExchange r, int status){
        try {
            r.sendResponseHeaders(status, -1);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
