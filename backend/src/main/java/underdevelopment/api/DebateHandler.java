package underdevelopment.api;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;

public class DebateHandler {

    // TODO: /api/debate/get-ongoing-questions 
    public static JsonRequestHandler getOngoingQuesions() {
        return (JSONObject jsonObj) -> {
            return new JsonHttpReponse(Status.OK);
        };
    }

    // TODO: /api/debate/get-finished-questions
    public static JsonRequestHandler getFinishedQuesions() {
        return (JSONObject jsonObj) -> {
            return new JsonHttpReponse(Status.OK);
        };
    }

    // TODO: /api/debate/get-group-responses-my-question
    public static JsonRequestHandler getResponsesMyQuestion() {

        return (JSONObject jsonObj) -> {
            String username;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            return new JsonHttpReponse(Status.OK);
        };
    }
    
    // TODO: /api/debate/get-previous-topic-result
    public static JsonRequestHandler getResultMyPreviousQuestion() {
        return (JSONObject jsonObj) -> {
            
            String username;
            // Get and validate input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            return new JsonHttpReponse(Status.OK);
        };
    }

    // TODO: /api/debate/get-group-responses
    public static JsonRequestHandler getResponsesOngoing() {
        return (JSONObject jsonObj) -> {

            String questionId;

            // Get and validate input
            try {
                questionId = jsonObj.getString("questionId");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Get questions from the db
            // ArrayList<Map<String, Object>> questions = DBQuestion.getQuestions(questionId, LIMIT);
            
            try {
                JSONArray questionsJSON = new JSONArray();

                // Build the json array of questions
                // Iterator<Map<String, Object>> it = questions.iterator();
                // while (it.hasNext()) {
                    // Map<String, Object> question = it.next();
                    // questionsJSON
                    //     .put(new JSONObject()
                    //         .put("questionId", question.get("questionId").toString())
                    //         .put("question", question.get("question").toString())
                    //         .put("answer", question.get("answer").toString())
                    //         .put("choices", new JSONArray(question.get("choices").toString()))
                    //     );
                // }

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

    // TODO: /api/debate/get-debate-group-responses-n-results
    public static JsonRequestHandler getResponsesFinished() {
        return (JSONObject jsonObj) -> {
            String questionId;
            // Get and validate input
            try {
                questionId = jsonObj.getString("questionId");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            return new JsonHttpReponse(Status.OK);
        };
    }

}
