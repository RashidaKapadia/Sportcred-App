package underdevelopment.api;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.neo4j.driver.Record;

import underdevelopment.api.utils.JsonHttpReponse;
import underdevelopment.api.utils.JsonRequestHandler;
import underdevelopment.api.utils.Status;
import underdevelopment.db.DBNotifications;
import underdevelopment.db.DBUserInfo;


public class NotificationHandler {
	
	public static JsonRequestHandler getNotifications() {
        return (JSONObject jsonObj) -> {
            System.out.println("getting notifications");
            String username;

            // Get input
            try {
                username = jsonObj.getString("username");
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            
            String response;
            // Check if the username exists
            if ( ! DBUserInfo.checkUsernameExists(username) ) {
          	  try {
                  response = new JSONObject()
                      .put("Error", "Username doesn't exist")
                      .toString();
                  	return new JsonHttpReponse(Status.CONFLICT, response);
              } catch (JSONException e) {
                  e.printStackTrace();
                  return new JsonHttpReponse(Status.SERVERERROR);
              }
            }
            /*
             * 		retVal.add(ID);
		    		retVal.add(type);
		    		retVal.add(category);
		    		retVal.add(title);
		    		retVal.add(infoID);
		    		retVal.add(read);
             */
            // Run DB command            
            try {
            	ArrayList<ArrayList<String>> notificationList = DBNotifications.getNotification(username );
            	for(int i = 0; i < notificationList.size(); i++) {
            		for (int j = 0; j < notificationList.get(i).size(); j++) {
            			System.out.println(notificationList.get(i).get(j));
            		}
            	}
            	response = "[";
                JSONObject jsonResponse  = new JSONObject();
                for(int i = 0; i < notificationList.get(0).size(); i++) {
                    String oneResponse = new JSONObject()
                        .put("notificationId", notificationList.get(0).get(i))
		    			.put("type", notificationList.get(1).get(i))
		    			.put("category",  notificationList.get(2).get(i))
		    			.put("title",  notificationList.get(3).get(i))
		    			.put("infoID", notificationList.get(4).get(i))
		    			.put("read", notificationList.get(5).get(i))
		    			.toString();
		    		response += oneResponse + ',';
                }
                if(response.length() > 1) {
                	response = response.substring(0, response.length() - 1);
                }
                response += ']';
            	//response = new JSONObject()
                //        .put("Response:", "Contact Info changed")
                //        .toString();
                return new JsonHttpReponse(Status.OK, response);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }

    public static JsonRequestHandler markRead() {
        return (JSONObject jsonObj) -> {
        	JSONArray arr = new JSONArray();
        	int IDs[];
            // Get input
            try {
                arr = jsonObj.getJSONArray("notifications");
                IDs = new  int[arr.length()];
                for(int i = 0; i < arr.length(); i++) {
                	IDs[i] = arr.getInt(i);
                }
            } catch (Exception e) {
                return new JsonHttpReponse(Status.BADREQUEST);
            }
            String response;

            // Run DB command            
            try {
            	DBNotifications.markRead(IDs);
            	
                return new JsonHttpReponse(Status.OK, null);
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }


    public static JsonRequestHandler deleteNot() {
        return (JSONObject jsonObj) -> {
        	 JSONArray IDs;

             // Get and validate input
             try {
            	 IDs = jsonObj.getJSONArray("notifications");
             } catch (Exception e) {
                 e.printStackTrace();
                 return new JsonHttpReponse(Status.BADREQUEST);
             }

             int[] arrayIDs=new int[IDs.length()];
             for(int i=0; i<arrayIDs.length; i++) {
            	 arrayIDs[i]=IDs.optInt(i);
             }
            String response;
            // Run DB command            
            try {
            	int success = DBNotifications.deleteNotification(arrayIDs);
            	if(success == 1) {
                    return new JsonHttpReponse(Status.OK, null);
            	}else {
                    return new JsonHttpReponse(Status.BADREQUEST);
            	}
            } catch (Exception e) {
                e.printStackTrace();
                return new JsonHttpReponse(Status.SERVERERROR);
            }
        };
    }
   
}