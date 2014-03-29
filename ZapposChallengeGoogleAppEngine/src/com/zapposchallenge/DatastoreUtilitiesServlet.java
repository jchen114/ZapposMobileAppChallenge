package com.zapposchallenge;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@SuppressWarnings("serial")
public class DatastoreUtilitiesServlet extends HttpServlet {

	private static final Logger log = Logger.getLogger(DatastoreUtilitiesServlet.class.getName());
	private static final String apiKey = "b05dcd698e5ca2eab4a0cd1eee4117e7db2a10c4"; // Change API Key if Throttled
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		log.info("running");
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key zapposService = KeyFactory.createKey("requests", "1");
		Query query = new Query("request", zapposService);
		List <Entity> requests = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
		if (requests.isEmpty()) {
			resp.getWriter().println("empty");
			return;
		} else {
			for (Entity request : requests) {
				String email = request.getProperty("email").toString();
				String productID = request.getProperty("productID").toString().replace("\"", "");
				//String urlRequest = "http://api.zappos.com/Product/" + productID + "?include=[\"styles\"]&key=" + apiKey;
				String urlRequest = "http://api.zappos.com/Product/"+productID+"?includes=["+URLEncoder.encode("\"", "utf-8") + "styles" + URLEncoder.encode("\"", "utf-8") + "]&key=" + apiKey;
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
			    //resp.getWriter().println(jSONFile.toString());
			    JsonElement jelement = new JsonParser().parse(jSONFile.toString());
			    JsonObject  jobject = jelement.getAsJsonObject();
			    JsonArray stylesArray = jobject.getAsJsonArray("product").get(0).getAsJsonObject().getAsJsonArray("styles");
			    String productName = jobject.getAsJsonArray("product").get(0).getAsJsonObject().get("productName").toString();
			    productID = jobject.getAsJsonArray("product").get(0).getAsJsonObject().get("productId").toString();
			    ArrayList<ZapposProduct> zapposProductsOnSale = new ArrayList<ZapposProduct>();
			    for (int objectIndex = 0; objectIndex < stylesArray.size(); objectIndex ++) {
			    	JsonObject style = stylesArray.get(objectIndex).getAsJsonObject();
			    	float originalPrice = Float.parseFloat(style.get("originalPrice").toString().replace("$", "").replace("\"", ""));
			    	float currentPrice = Float.parseFloat(style.get("price").toString().replace("$", "").replace("\"", ""));
			    	//resp.getWriter().println("styleID = " + style.get("styleId").toString());
			    	//resp.getWriter().println("original Price = " + Float.toString(originalPrice));
			    	//resp.getWriter().println("price = " + Float.toString(currentPrice));
			    	if (currentPrice <= originalPrice * .8) {
			    		ZapposProduct product = new ZapposProduct(
			    				style.get("styleId").toString(),
			    				style.get("productUrl").toString(),
			    				originalPrice, 
			    				currentPrice);
			    		zapposProductsOnSale.add(product);
			    	}
			    }
			    // Email user if list is nonempty
			    if (!zapposProductsOnSale.isEmpty()) {
			    	datastore.delete(request.getKey());
				    Properties props = new Properties();
				    Session session = Session.getDefaultInstance(props, null);
				    StringBuilder msgBody = new StringBuilder();
				    msgBody.append("Product name = " + productName + "\n");
				    msgBody.append("Product ID = " + productID +"\n\n");
				    for (ZapposProduct product : zapposProductsOnSale) {
				    	msgBody.append("styleID = " + product.getMyStyleID());
				    	msgBody.append("\toriginal price = $" + product.getMyOriginalPrice());
				    	msgBody.append("\tcurrent price = $" + product.getMyCurrentPrice());
				    	Integer percentOff = 100 - Math.round((product.getMyCurrentPrice() / product.getMyOriginalPrice()*100));
				    	log.info("percentOff is " + percentOff);
				    	msgBody.append("\tdiscount = " + percentOff.toString() + "%");
				    	msgBody.append("\tproduct URL = " + product.getMyProductURL()+"\n\n");
				    }
				    resp.getWriter().println(msgBody.toString());
				    
				    try {
				        Message msg = new MimeMessage(session);
				        msg.setFrom(new InternetAddress("chen.jacob92@gmail.com", "Jacob Chen"));
				        msg.addRecipient(Message.RecipientType.TO,
				         new InternetAddress(email, "Interested Client"));
				        msg.setSubject("Your Zappos Products on sale!");
				        msg.setText(msgBody.toString());
				        Transport.send(msg);
				        
				    } catch (AddressException e) {
				        // ...
				    	resp.getWriter().println(e.toString());
				    } catch (MessagingException e) {
				        // ...
				    	resp.getWriter().println(e.toString());
				    }
			    }
			}
		}
	}
}
