package underdevelopment.api;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.function.Function;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.neo4j.driver.Record;
import org.neo4j.driver.Value;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBDebate;

public class DebateHandler {

    private static String questionsToJson(ArrayList<Map<String, Object>> questions) throws JSONException {

        JSONArray questionsJSON = new JSONArray();

        // Build the json array of questions
        Iterator<Map<String, Object>> it = questions.iterator();
        while (it.hasNext()) {
            Map<String, Object> question = it.next();
            questionsJSON
                .put(new JSONObject()
                    .put("questionId", question.get("id"))
                    .put("question", question.get("question"))
                    .put("tier", question.get("tier"))
                );
        }

        // Create the json response
        return new JSONObject().put("questions", questionsJSON).toString();
    }

    private static JsonHttpReponse makeQuestionResponse(ArrayList<Map<String, Object>> questions) {
        try {
            return new JsonHttpReponse(Status.OK, questionsToJson(questions));
        } catch (JSONException e) {
            e.printStackTrace();
            return new JsonHttpReponse(Status.SERVERERROR);
        }
    }

    // /api/debate/get-ongoing-questions 
    public static JsonRequestHandler getOngoingQuesions() {
        return (JSONObject jsonObj) -> {
            return makeQuestionResponse(DBDebate.getOngoingQuesions());
        };
    }

    // /api/debate/get-finished-questions
    public static JsonRequestHandler getFinishedQuesions() {
        return (JSONObject jsonObj) -> {
            return makeQuestionResponse(DBDebate.getFinishedQuesions());
        };
    }

    private static String groupResponsesToJson(ArrayList<Record> reponseGroups) throws JSONException {
        
        JSONArray groups = new JSONArray();

        // Make array of groups
        for (Record record : reponseGroups) {
            // System.out.println("Next: " + record.toString());

            // Make array of responses for the group
            JSONArray responses = new JSONArray();
            for (Map<String,Object> response : record.get("responses").asList(
                (Function <Value, Map<String, Object>>) (Value v) -> {return v.asMap();}
            )){
                responses.put(new JSONObject()
                    .put("responseId",  response.get("responseId"))
                    .put("response",    response.get("response"))
                );
            }

            // Make groups of responses
            groups.put(new JSONObject()
                .put("groupId", record.get("groupId").asString())
                .put("responses", responses)
            );
        }

        // Makes json of question and responses by group
        return new JSONObject().put("groups", groups).toString();
    }

    private static JsonHttpReponse makeGroupResponses(ArrayList<Record> reponseGroups) {
        try {
            return new JsonHttpReponse(Status.OK, groupResponsesToJson(reponseGroups));
        } catch (JSONException e) {
            e.printStackTrace();
            return new JsonHttpReponse(Status.SERVERERROR);
        }
    }

    // TODO: /api/debate/get-group-responses-my-question
    public static JsonRequestHandler getResponsesMyQuestion() {

        return (JSONObject jsonObj) -> {
            String username;
            try {
                username = jsonObj.getString("username");
                return makeGroupResponses(DBDebate.getResponsesMyQuestion(username));
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }
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
