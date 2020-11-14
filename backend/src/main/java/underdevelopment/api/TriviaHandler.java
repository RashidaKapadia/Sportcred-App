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
import underdevelopment.db.DBTrivia;
import underdevelopment.db.DBUserInfo;

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
    
    // Multiplayer stuff
    public static JsonRequestHandler resetTriviaCount() {
        return (JSONObject jsonObj) -> {

            System.out.println("resetting trivia count");
            String username;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Get questions from the db
            Boolean success = DBTrivia.resetTriviaCount(username);
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = new JSONObject()
                    .put("questions", questionsJSON)
                    .toString();

                return new JsonHttpReponse(Status.OK, null);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }   
    
    public static JsonRequestHandler subtractTriviaCount() {
        return (JSONObject jsonObj) -> {

            System.out.println("resetting trivia count");
            String username;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Get questions from the db
            Boolean success = DBTrivia.subtractTriviaCount(username);
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = new JSONObject()
                    .put("questions", questionsJSON)
                    .toString();

                return new JsonHttpReponse(Status.OK, null);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
    
    public static JsonRequestHandler getTriviaCount() {
        return (JSONObject jsonObj) -> {

            System.out.println("getting trivia count");
            String username;

            // Get and validate input
            try {
                username = jsonObj.getString("username");
                
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            // Get questions from the db
            int remainingPlays = DBTrivia.getTriviaCount(username);
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = new JSONObject()
                	.put("available", remainingPlays > 0)
                    .put("gamesLeft", remainingPlays)
                    .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }   
    
    //get-users-list
    public static JsonRequestHandler getUserList() {
        return (JSONObject jsonObj) -> {

            System.out.println("getting user list");
            String username;
            // Get questions from the db
            ArrayList<String>[] users = DBUserInfo.returnUsers();
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = new JSONObject()
                	.put("username", users[0])
                	.put("firstname", users[1])
                	.put("lastname", users[2])
                    .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (JSONException e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    } 
    
    public static JsonRequestHandler getQuesionsByID() {
        return (JSONObject jsonObj) -> {

            System.out.println("getting questions by ID");
            JSONArray choices;

            // Get and validate input
            try {
            	choices = jsonObj.getJSONArray("questionSequence");
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.BADREQUEST);
            }

            int[] arrayChoices=new int[choices.length()];
            for(int i=0; i<arrayChoices.length; i++) {
            	arrayChoices[i]=choices.optInt(i);
            }
            // Get questions from the db
            ArrayList<Map<String, Object>> questions = DBQuestion.getSpecificQuestions(arrayChoices);
            
            try {
                JSONArray questionsJSON = new JSONArray();

                // Build the json array of questions
                Iterator<Map<String, Object>> it = questions.iterator();
                while (it.hasNext()) {
                	System.out.println("hello there");
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
            }catch(Exception f) {
            	f.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }   
}
