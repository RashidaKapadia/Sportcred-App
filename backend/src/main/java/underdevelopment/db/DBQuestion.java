package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

public class DBQuestion {
    // DB command for getting user status
    public static ArrayList<Map<String, Object>> getQuestions(String category, int limit) {
        try (Session session = Connect.driver.session()) {
            Result result = session.run("match (q:Question {category: $c}) return q, rand() as r order by r limit $l",
                                        parameters("c", category, "l", limit));

            ArrayList<Map<String, Object>> questions = new ArrayList<>();
            while (result.hasNext()) {
                questions.add(result.next().get("q").asMap());
            }
            return questions;
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    
    public static ArrayList<Map<String, Object>> getSpecificQuestions(int IDList[]) {
        ArrayList<Map<String, Object>> questions = new ArrayList<>();

    	 try (Session session = Connect.driver.session()){
         	try (Transaction tx = session.beginTransaction()) {
         		for(int i = 0; i < IDList.length; i++) {
         			
         			Result result = tx.run(String.format("match(n:Question {questionId:%d})  return n", IDList[i]));
     				while(result.hasNext()) {
     					Record rec = result.next();
     					Map<String, Object> curQuestion = rec.get("n").asMap();
     					HashMap question = new HashMap<String,Object>();
     					question.put("questionID", curQuestion.get("questionID"));
     					question.put("question", curQuestion.get("question"));
     					question.put("star", curQuestion.get("star"));
     					question.put("answer", curQuestion.get("answer"));
     					question.put("category", curQuestion.get("category"));
     					question.put("choices", new JSONArray(curQuestion.get("choices").toString()));
     					question.put("version", curQuestion.get("version"));

     					
     					questions.add(question);
     					//questions.add(rec.get("n").asMap());
     					// 
     				}
         		}
 				tx.close(); 
 				session.close();
 				//System.out.println(questions.toArray().toString());
 				System.out.println("returning questions");
         		return questions;
         	}catch(Exception e) {
         		e.printStackTrace();
    	  		return null;
         	}
         }catch(Exception e) {
	  		e.printStackTrace();
	  		return null;
         }
    }
}
