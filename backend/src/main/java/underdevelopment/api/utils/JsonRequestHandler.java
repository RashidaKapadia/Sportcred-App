package underdevelopment.api.utils;

import org.json.JSONObject;

public interface JsonRequestHandler {
    public abstract JsonHttpReponse handle (JSONObject json);
}
