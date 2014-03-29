package com.zapposchallenge;

public class ZapposProduct {
	
	private String myStyleID, myProductURL;
	private float myOriginalPrice, myCurrentPrice;
	
	public ZapposProduct(String styleID, String productURL, float originalPrice, float currentPrice) {
		myStyleID = styleID;
		myProductURL = productURL;
		myOriginalPrice = originalPrice;
		myCurrentPrice = currentPrice;
	}

	public String getMyStyleID() {
		return myStyleID;
	}
	
	public String getMyProductURL() {
		return myProductURL;
	}

	public float getMyOriginalPrice() {
		return myOriginalPrice;
	}

	public float getMyCurrentPrice() {
		return myCurrentPrice;
	}
	
}
