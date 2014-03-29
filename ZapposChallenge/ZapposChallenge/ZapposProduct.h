//
//  ZapposProduct.h
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZapposProduct : NSObject
{
    
}

#pragma mark - Init methods

- (id)initWithParameters:(NSDictionary *)parameters;

- (id)initWithProductName:(NSString *)name
               productURL:(NSString *)url
             andProductID:(NSString *)ID;

#pragma mark - Get methods

- (NSString *)getProductName;
- (NSString *)getProductURL;
- (NSString *)getProductID;

@end
