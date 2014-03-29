//
//  ZapposUtilities.h
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZapposUtilities : NSObject

+ (BOOL)NSStringIsValidEmail:(NSString *)checkString;
+ (BOOL)IsStringNumeric:(NSString *)checkString;
+ (void)GetResponseForPostForURL:(NSString *)url
                       withParams:(NSDictionary *)params
                        withBlock:(void(^)(BOOL success, NSArray *zapposProducts))completionBlock;
+ (void)downloadImageInBackgroundFromURL:(NSString *)photoURL
                               withBlock:(void(^)(BOOL success, UIImage *image))completionBlock;

#pragma mark - Helper Methods

+ (UIColor *)zapposBackgroundColor;
+ (UIColor *)lighterBlueColor;
+ (void)addShadowEffectsToLayer:(CALayer *)layer;

@end
