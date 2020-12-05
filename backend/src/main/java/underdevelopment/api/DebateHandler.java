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

    // /api/debate/get-group-responses-my-question
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

    private static JSONObject responseToJSONObject (Map<String, Object> response) throws JSONException {
        return new JSONObject()
            .put("username", response.get("username"))
            .put("response", response.get("debateAnalysis"))    
            .put("averageRating", (response.get("avgScore") != null) ? response.get("avgScore") : 0);
    }
    
    // /api/debate/get-previous-topic-result
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

            Record data = DBDebate.getResultMyPreviousQuestion(username);
            try {
                JSONObject json = new JSONObject()
                    .put("groupId", data.get("groupId").asInt())
                    .put("yours", responseToJSONObject(data.get("yours").asMap()))
                    .put("theirs", new JSONArray(data.get("theirs").asList(
                        (Function<Value, JSONObject>) (Value v) -> {
                            try {
                                return responseToJSONObject(v.asMap());
                            } catch (JSONException e) {
                                e.printStackTrace();
                                return null;
                            }
                        }
                    )))
                    .put("yourScore", data.get("yourScore", (int) 0))
                    .put("winner", data.get("winner", "n/a"));
                return new JsonHttpReponse(Status.OK, json.toString());
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    // /api/debate/get-group-responses
    public static JsonRequestHandler getResponsesOngoing() {
        return (JSONObject jsonObj) -> {
            int questionId;
            try {
                questionId = jsonObj.getInt("questionId");
                return makeGroupResponses(DBDebate.getResponsesOngoing(questionId));
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }
        };
    }

    // /api/debate/get-debate-group-responses-n-results
    public static JsonRequestHandler getResponsesFinished() {
        return (JSONObject jsonObj) -> {
            int questionId;
            // Get and validate input
            try {
                questionId = jsonObj.getInt("questionId");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            ArrayList<Record> data = DBDebate.getResponsesFinished(questionId);
            System.out.println(data);

            try {
                JSONArray groups = new JSONArray();
                for (Record record : data) {
                    groups.put(new JSONObject()
                        .put("groupId", record.get("groupId").asInt())
                        .put("responses", new JSONArray(
                            record.get("responses").asList(
                                (Function<Value, JSONObject>) (Value v) -> {
                                    try {
                                        return responseToJSONObject(v.asMap());
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                        return null;
                                    }
                                }
                            ))
                        )
                        .put("winner", record.get("winner", "Undetermined"))
                    );    
                }
                JSONObject json = new JSONObject().put("groups", groups);
                return new JsonHttpReponse(Status.OK, json.toString());
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

}
