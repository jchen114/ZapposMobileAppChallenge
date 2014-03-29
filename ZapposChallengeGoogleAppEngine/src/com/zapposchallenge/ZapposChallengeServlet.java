package com.zapposchallenge;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
	
@SuppressWarnings("serial")
public class ZapposChallengeServlet extends HttpServlet {
	
	private static String apiKey = "b05dcd698e5ca2eab4a0cd1eee4117e7db2a10c4"; // Change API Key if throttled
	private static final Logger log = Logger.getLogger(DatastoreUtilitiesServlet.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		//super.doPost(req, resp);
		resp.setContentType("application/json");
		String email = req.getParameter("email");
		String productID = req.getParameter("productID");
		if(productID == null) {
			String productName = req.getParameter("productName");
			String urlRequest = generateRequestString(productName, false);
			//resp.getWriter().println(urlRequest);
			URL url = new URL(urlRequest);
			BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
			StringBuilder jSONFile = new StringBuilder();
			String line;
			while ((line = reader.readLine()) != null) {
		        // ...
				jSONFile.append(line);
		    }
		    reader.close();
		    JsonElement jelement = new JsonParser().parse(jSONFile.toString());
		    JsonObject  jobject = jelement.getAsJsonObject();
		    JsonArray results = jobject.getAsJsonArray("results");
		    if (results.size() > 0) {
		    	// There may be several products that have that product name
		    	HashMap<String, HashMap<String, String>> differentProducts =  new HashMap<String, HashMap<String, String>>();
		    	for (int i = 0; i < results.size(); i ++) {
		    		String pName = results.get(i).getAsJsonObject().get("productName").toString().replace("\"", "");
		    		HashMap<String, String> productElements = new HashMap<String, String>();
		    		String pID = results.get(i).getAsJsonObject().get("productId").toString().replace("\"", "");
		    		String pURL = results.get(i).getAsJsonObject().get("thumbnailImageUrl").toString().replace("\"", "");
		    		productElements.put("productID", pID);
		    		productElements.put("imageURL", pURL);
		    		differentProducts.put(pName, productElements);
		    	}
		    	if (differentProducts.size() > 1) {
		    		// There are different product Names!!!
		    		JsonArray products = new JsonArray();
		    		for (String eachProductName : differentProducts.keySet()) {
						String pID = differentProducts.get(eachProductName).get("productID");
						String pName = eachProductName;
						String pURL = differentProducts.get(eachProductName).get("imageURL");
						JsonObject object = new JsonObject();
						object.addProperty("productName", pName);
						object.addProperty("productID", pID);
						object.addProperty("imageURL", pURL);
						products.add(object);
					}
		    		JsonObject objectToSend = new JsonObject();
		    		objectToSend.addProperty("response", "true");
		    		objectToSend.add("products", products);
		    		resp.getWriter().println(objectToSend.toString());
		    		return;
		    	} else {
		    		// There is only one product name, so just get the productID
		    		HashMap<String, String> firstProduct = differentProducts.get(differentProducts.keySet().toArray()[0]);
		    		productID = firstProduct.get("productID");
		    		// Add the entry
		    		Key zapposService = KeyFactory.createKey("requests", "1");
					Entity request = new Entity("request", zapposService);
					request.setProperty("email", email);
					request.setProperty("productID", productID);
					DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
					datastore.put(request);
					JsonArray emptyArray = new JsonArray();
					JsonObject objectToSend = new JsonObject();
					objectToSend.addProperty("response", "true");
					objectToSend.add("products", emptyArray);
					resp.getWriter().println(objectToSend.toString());
		    	}
		    } else {
		    	JsonObject object = new JsonObject();
		    	object.addProperty("response", "false");
		    	object.add("products", new JsonArray());
		    	resp.getWriter().println(object.toString());
		    	return;
		    }
		} else {
			String urlRequest = generateRequestString(productID, true);
			URL url = new URL(urlRequest);
			BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
			StringBuilder jSONFile = new StringBuilder();
			String line;
			while ((line = reader.readLine()) != null) {
		        // ...
				jSONFile.append(line);
		    }
		    reader.close();
		    JsonElement jelement = new JsonParser().parse(jSONFile.toString());
		    JsonObject  jobject = jelement.getAsJsonObject();
		    String resultsCount = jobject.get("statusCode").toString().replace("\"", "");
		    Integer results = Integer.parseInt(resultsCount);
		    if (results == 404) {
		    	// No such results exist
		    	JsonObject objectToSend = new JsonObject();
				objectToSend.addProperty("response", "false");
				objectToSend.add("products", new JsonArray());
				resp.getWriter().println(objectToSend.toString());
		    } else {
		    	// Add the entry
				Key zapposService = KeyFactory.createKey("requests", "1");
				Entity request = new Entity("request", zapposService);
				request.setProperty("email", email);
				request.setProperty("productID", productID);
				DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
				datastore.put(request);
				JsonArray emptyArray = new JsonArray();
				JsonObject objectToSend = new JsonObject();
				objectToSend.addProperty("response", "true");
				objectToSend.add("products", emptyArray);
				resp.getWriter().println(objectToSend.toString());
				log.info("Adding Entry");
		    }
		}
	}
	
	private static String generateRequestString(String product, boolean isID) throws UnsupportedEncodingException {
		String urlRequest = new String();
		if (isID) {
			urlRequest = "http://api.zappos.com/Product/"+product+"?includes=["+URLEncoder.encode("\"", "utf-8") + "styles" + URLEncoder.encode("\"", "utf-8") + "]&key=" + apiKey;
		} else {
			urlRequest = "http://api.zappos.com/Search?term="+ URLEncoder.encode(product, "utf-8")+"&key=" + apiKey;
		}
		return urlRequest;
	}
}
