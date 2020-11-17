
package underdevelopment.api;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBQuestion;

public class TriviaHandler {

    // Default question limit
    private static final int LIMIT = 10;

    public static JsonRequestHandler generateQuestions() {
        return (JSONObject jsonObj) -> {

            System.out.println("Generating questions");
            String category;

            // Get and validate input
            try {
                category = jsonObj.getString("category");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Get questions from the db
            ArrayList<Map<String, Object>> questions = DBQuestion.getQuestions(category, LIMIT);
            
            try {
                JSONArray questionsJSON = new JSONArray();

                // Build the json array of questions
                Iterator<Map<String, Object>> it = questions.iterator();
                while (it.hasNext()) {
                    Map<String, Object> question = it.next();
                    questionsJSON
                        .put(new JSONObject()
                            .put("questionId", question.get("questionId").toString())
                            .put("question", question.get("question").toString())
                            .put("answer", question.get("answer").toString())
                            .put("choices", new JSONArray(question.get("choices").toString()))
                        );
                }

                // Create the json response
                String response = new JSONObject()
                    .put("questions", questionsJSON)
                    .toString();

                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }   
}
