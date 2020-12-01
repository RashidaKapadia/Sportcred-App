package underdevelopment.db;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;

import static org.neo4j.driver.Values.parameters;

public class DBDebateGroups {

    /**
     * Create debate groups for yesterday's responses to each tier's daily question
     * @return
     */
    public static boolean createDebateGroups() {
        try {
            Session session = Connect.driver.session();
            Transaction tx = session.beginTransaction();
            // List of tiers
            List<String> tiers = new ArrayList<>(Arrays.asList("FANALYST", "ANALYST", "PRO ANALYST", "EXPERT ANALYST"));

            // Get the responses to yesterday's question for each tier and create debate groups
            for (String tier : tiers){
                List<Integer> ids = getResponseIds(tier);

                System.out.println(ids);

                // Create debate groups if there were responses for the current tier
                if (ids != null)
                    createTierGroups(tier, ids, tx);
                }

            tx.commit();
            tx.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Return the ids of the response nodes for yesterday's question of given tier
     * @param tier
     * @return
     */
    private static List<Integer> getResponseIds(String tier) {
        // Get yesterday's date
        String date = LocalDate.now().minusDays(1).toString();

        try (Session session = Connect.driver.session()) {
            // Query to get ids of the responses to yesterday's question for given tier
            Result result = session.run(
                    "MATCH (q:DebateQuestion {tier: $t, date: $d})-[:hasResponse]->(r:DebateResponse) RETURN ID(r) as id",
                    parameters("t", tier, "d", date));
            if (result.hasNext()) {
               List<Integer> ids = new ArrayList<>();

                while (result.hasNext()){
                    Record r = result.next();

                    ids.add(r.get("id").asInt());
                    System.out.println(r);

                }
                return ids;
            } else
                return null;
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
            return null;
        }
    }

    /**
     * Create debate groups for the given tier and responses with given ids
     * @param tier
     * @param ids
     * @param tx
     */
    private static void createTierGroups(String tier, List<Integer> ids, Transaction tx) {
        // Yesterday's date
        String date = LocalDate.now().minusDays(1).toString();

        // Read questions and insert into the db
        for (int i = 0; i < ids.size(); i += 3) {
            int j = 0;

            while (j < 3 && (i + j < ids.size())) {
                int id = ids.get(i + j);

                // If its the first response to add to a group, create a new group and add the necesary relationships
                if (j == 0) {
                    tx.run("MATCH (q:DebateQuestion {tier: $t, date: $d}), " + "(r:DebateResponse) WHERE ID(r) = $i "
                            + "MERGE (q)-[:hasGroup]->(g:DebateGroup {id: $h})-[:hasResponse]->(r)",
                            parameters("i", id, "t", tier, "d", date, "h",
                                    date + "-" + tier + "-" + i));
                // For the next responses, add them to the debate group created above
                } else {
                    tx.run("MATCH (g:DebateGroup {id: $h}), (r:DebateResponse) WHERE ID(r) = $i "
                            + "MERGE (g)-[:hasResponse]->(r)",
                            parameters("i", id, "h", date + "-" + tier + "-" + i));
                }

                j++;
            }

        }

    }
}