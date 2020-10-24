package underdevelopment.api.utils;

public class JsonHttpReponse {

    private String jsonString;
    private int status;

    public JsonHttpReponse(int status) {
        this.status = status;
    }

    public JsonHttpReponse(int status, String jsonString) {
        this.status = status;
        this.jsonString = jsonString;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getJsonString() {
        return jsonString;
    }

    public void setJsonString(String jsonString) {
        this.jsonString = jsonString;
    }
    
}
