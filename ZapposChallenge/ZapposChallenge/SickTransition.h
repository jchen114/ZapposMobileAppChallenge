//
//  SickTransition.h
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define INSET_X 30.0f
#define INSET_Y 50.0f

typedef enum {
    AnimationTypePresent,
    AnimationTypeDismiss
}AnimationType;

@interface SickTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType animationType;

- (id)initWithToViewFrame:(CGRect)frame;

@end
