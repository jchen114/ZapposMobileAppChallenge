//
//  AwesomeTransition.h
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/16/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AnimationTypePresent,
    AnimationTypeDismiss
}AnimationType;

@interface AwesomeTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType animationType;

@end
