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
import underdevelopment.db.DBNotifications;
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
    

   
    
    //get-users-list
    public static JsonRequestHandler getUserList() {
        return (JSONObject jsonObj) -> {

            System.out.println("getting user list");

            // Get questions from the db
            ArrayList<String>[] users = DBUserInfo.returnUsers();
            
            try {
                JSONArray questionsJSON = new JSONArray();
                // Build the json array of questions
                // Create the json response
                String response = "[";
                for(int i = 0; i < users[0].size(); i++) {
                	String oneResponse = new JSONObject()
                        	.put("username", users[0].get(i))
                        	.put("firstname", users[1].get(i))
                        	.put("lastname", users[2].get(i))
                            .toString();
                    response += oneResponse + ',';
                	
                }
                if(response.length() > 1) {
                	response = response.substring(0, response.length() - 1);
                }
                response += ']';
             
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
    
    
    // Multiplayer trivia stuff
    public static JsonRequestHandler startMultiTrivia() {
        return (JSONObject jsonObj) -> {

	        System.out.println("starting multiplayer trivia");
	        String username, oppUsername;
	
	        // Get and validate input
	        try {
	        	username = jsonObj.getString("username");
	        	oppUsername = jsonObj.getString("oppUsername");
	        } catch (Exception e) {
	            e.printStackTrace();
	            return new JsonHttpReponse(Status.BADREQUEST);
	        }
	        // Get questions from the db and make sure query was run properly
	       int gameID = DBTrivia.startMultiplayerTrivia(username, oppUsername);
	       
	       if(gameID == -1) {
	    	   System.out.println("error with the query");
	    	   return new JsonHttpReponse(Status.SERVERERROR);
	       }
	       
	       
	        try {
	            JSONArray questionsJSON = new JSONArray();
	            // Build the json array of questions
	            // Create the json response
	            String response =new JSONObject().put("gameID", gameID).toString();

	            return new JsonHttpReponse(Status.OK, response);
	        } catch (JSONException e) {
	            e.printStackTrace();
	            return new JsonHttpReponse(Status.SERVERERROR);
	        }
	    };
    } 
    
    // Multiplayer trivia stuff
    public static JsonRequestHandler endMultiTrivia() {
        return (JSONObject jsonObj) -> {

	        System.out.println("ending multiplayer trivia");
	        String username;
	        int gameID;
	        JSONArray answers;
	        int gameScore;
	
	        // Get and validate input
	        try {
	        	username = jsonObj.getString("username");
	        	gameID = jsonObj.getInt("gameID");
	        	answers = jsonObj.getJSONArray("answers");
	        	gameScore = jsonObj.getInt("gameScore");
	        } catch (Exception e) {
	            e.printStackTrace();
	            return new JsonHttpReponse(Status.BADREQUEST);
	        }
	        String[] arrayAnswers=new String[answers.length()];
            for(int i=0; i<arrayAnswers.length; i++) {
            	arrayAnswers[i]=answers.optString(i);
            }
	        
	        // Get questions from the db and make sure query was run properly
            int success = DBTrivia.endMultiplayerTrivia(username, gameID, arrayAnswers, gameScore);
 	       if(success == -1) {
	    	   System.out.println("error with the query");
	    	   return new JsonHttpReponse(Status.SERVERERROR);
	       }else {
		        return new JsonHttpReponse(Status.OK, null);
	       }
	      
	    };
    } 
    
    public static JsonRequestHandler getMultiTrivia() {
        return (JSONObject jsonObj) -> {

	        System.out.println("getting multiplayer trivia");
	        String username;
	        int gameID;
	
	        // Get and validate input
	        try {
	        	username = jsonObj.getString("username");
	        	gameID = jsonObj.getInt("gameID");
	        } catch (Exception e) {
	            e.printStackTrace();
	            return new JsonHttpReponse(Status.BADREQUEST);
	        }	        
	        // Get questions from the db and make sure query was run properly
	        ArrayList<Map<String, String>> results = DBTrivia.getMultiplayerTrivia(gameID, username);
 	       if(results == null) {
	    	   System.out.println("error with the query");
	    	   return new JsonHttpReponse(Status.SERVERERROR);
	       }else {
	    	   JSONArray resultsJSON = new JSONArray();
			resultsJSON.put(
						new JSONObject(results.get(0)
								)).put(new JSONObject(results.get(1)));
			String response = resultsJSON.toString();
			
			  	return new JsonHttpReponse(Status.OK, response);
	       }
	      
	    };
    } 
    
    public static JsonRequestHandler joinMultiTrivia() {
        return (JSONObject jsonObj) -> {

	        System.out.println("getting multiplayer trivia");
	        int gameID;
	
	        // Get and validate input
	        try {
	        	gameID = jsonObj.getInt("gameID");
	        } catch (Exception e) {
	            e.printStackTrace();
	            return new JsonHttpReponse(Status.BADREQUEST);
	        }	        
	        // Get questions from the db and make sure query was run properly
	        ArrayList<Map<String, Object>> questions = DBTrivia.joinMultiplayerTrivia(gameID);
            
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
