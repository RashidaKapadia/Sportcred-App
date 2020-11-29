package underdevelopment.db;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import static org.neo4j.driver.Values.parameters;


public class DBDebateDailyQuestion {

     
    public static Map<String, String> getDailyDebateQuestion(String tier){

        System.out.println(LocalDate.now().toString());

        try (Session session = Connect.driver.session()) {
            // NEED TO UPDATE DATE TO LOCAL DATE AFTER DEC 1
            Result result = session.run("MATCH (q:DebateQuestion {tier: $t, date: $d} ) RETURN q",
                                        parameters("t", tier, "d", "2020-12-01"));
            
            if (result.hasNext()){
                Record r = result.single();

                Map<String, String> question = new HashMap<>();
                question.put("question", r.get("q").get("question").asString());

                return question;
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }
}