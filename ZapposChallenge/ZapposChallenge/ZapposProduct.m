//
//  ZapposProduct.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "ZapposProduct.h"

@implementation ZapposProduct
{
    NSString *productName;
    NSString *productURL;
    NSString *productID;
}

- (id)initWithParameters:(NSDictionary *)parameters
{
    self = [self init];
    if (self) {
        productName = parameters[@"productName"];
        productID = parameters[@"productID"];
        productURL = parameters[@"imageURL"];
    }
    return self;
}

- (id)initWithProductName:(NSString *)name
               productURL:(NSString *)url
             andProductID:(NSString *)ID
{
    self = [self init];
    if (self) {
        productName = name;
        productURL = url;
        productID = ID;
    }
    return self;
}

- (NSString *)getProductName
{
    return productName;
}

- (NSString *)getProductURL
{
    return productURL;
}

- (NSString *)getProductID
{
    return productID;
}

@end
