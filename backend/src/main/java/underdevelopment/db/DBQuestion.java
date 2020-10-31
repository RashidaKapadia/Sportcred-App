package underdevelopment.db;

import static org.neo4j.driver.Values.parameters;

import java.util.ArrayList;
import java.util.Map;

import org.neo4j.driver.Result;
import org.neo4j.driver.Session;

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
}
