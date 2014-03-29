//
//  ZapposUtilities.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "ZapposUtilities.h"
#import "ZapposProduct.h"

#define MAX_COLOR 256.0f

// R4, G74, B126, R0, G114, B188

@implementation ZapposUtilities

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL)IsStringNumeric:(NSString *)checkString
{
    NSScanner *scanner = [NSScanner scannerWithString:checkString];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    return isNumeric;
}

+ (void)GetResponseForPostForURL:(NSString *)url
                       withParams:(NSDictionary *)params
                        withBlock:(void(^)(BOOL, NSArray *))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self getResponseStatus:responseObject]) {
                  NSArray *productsArray = [self parseJsonForZapposProducts:responseObject];
                  completionBlock(YES, productsArray);
              } else {
                  completionBlock(NO, [NSArray array]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
              completionBlock(NO, nil);
          }];
}

+ (void)downloadImageInBackgroundFromURL:(NSString *)photoURL
                               withBlock:(void (^)(BOOL, UIImage *))completionBlock
{
    NSURL *url = [NSURL URLWithString:photoURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = (UIImage *)responseObject;
        completionBlock(YES, image);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, nil);
    }];
    [requestOperation start];
}

#pragma mark - Helper Methods

+ (UIColor *)zapposBackgroundColor
{
    UIColor *zapposColor = [UIColor colorWithRed:4.0f/MAX_COLOR
                                           green:74.0f/MAX_COLOR
                                            blue:126.0f/MAX_COLOR
                                           alpha:1.0f];
    return zapposColor;
}

+ (UIColor *)lighterBlueColor
{
    UIColor *color = [UIColor colorWithRed:0.0f/MAX_COLOR
                                     green:114.0f/MAX_COLOR
                                      blue:188.0f/MAX_COLOR
                                     alpha:1.0f];
    return color;
}

+ (void)addShadowEffectsToLayer:(CALayer *)layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0, 8.0);
    layer.shadowOpacity = 0.5;
    layer.shadowRadius = 10.0;
    layer.cornerRadius = 3.0;
}

+ (BOOL)getResponseStatus:(id)responseObject
{
    NSDictionary *jsonObject = responseObject;
    NSString *responseResult = [jsonObject objectForKey:@"response"];
    if ([responseResult isEqualToString:@"true"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray *)parseJsonForZapposProducts:(id)responseObject
{
    NSDictionary *jsonObject = responseObject;
    NSArray *productsArray = [jsonObject objectForKey:@"products"];
    NSMutableArray *zapposProducts = [NSMutableArray array];
    if ([productsArray isKindOfClass:[NSArray class]]){
        for (NSDictionary *product in productsArray) {
            ZapposProduct *zapposProduct = [[ZapposProduct alloc] initWithParameters:product];
            [zapposProducts addObject:zapposProduct];
        }
    }
    return zapposProducts;
}

+ (BOOL)checkResult:(id)responseObject
{
    NSDictionary *response = responseObject;
    NSString *responseString = [response objectForKey:@"response"];
    if ([responseString isEqualToString:@"true"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
