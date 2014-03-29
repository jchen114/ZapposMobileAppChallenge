//
//  AwesomeTransition.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/16/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "AwesomeTransition.h"
#import "ZapposSelectionViewController.h"

@implementation AwesomeTransition
{
    UIView *whiteView;
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        whiteView = [[UIView alloc] init];
    }
    return self;
}

#pragma mark - Animation Transitions

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIGraphicsEndImageContext();
    switch (self.animationType) {
        case AnimationTypePresent:
        {
            UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
            UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
            [toView.layer setCornerRadius:7.0f];
            [containerView addSubview:fromView];
            //[containerView insertSubview:toView belowSubview:fromView];
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI, 0.0f, 1.0f, 0.0f);
            [containerView insertSubview:toView belowSubview:fromView];
            [toView setAlpha:0.0f];
            [toView setFrame:fromView.frame];
            [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0f
                                 options:kNilOptions
                              animations:^{
                [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.6f animations:^{
                    [fromView.layer setTransform:transform];
                    NSArray *subViews = fromView.subviews;
                    for (UIView *views in subViews) {
                        [views setAlpha:0.0f];
                    }
                }];
                [containerView addSubview:toView];
                [UIView addKeyframeWithRelativeStartTime:0.65f relativeDuration:0.35f animations:^{
                    [toView setAlpha:1.0f];
                }];
            } completion:^(BOOL finished) {
                [fromView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
            
        }
            break;
        case AnimationTypeDismiss:
        {
            ZapposSelectionViewController *toViewController = (ZapposSelectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIView *toView = toViewController.view;
            UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
            [fromView.layer setCornerRadius:7.0f];
            [containerView addSubview:fromView];
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, -M_PI, 0.0f, 1.0f, 0.0f);
            [toView setFrame:fromView.frame];
            [toView setAlpha:0.0f];
            [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0f
                                         options:kNilOptions
                                      animations:^{
                                          [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.6f animations:^{
                                              [fromView.layer setTransform:transform];
                                              NSArray *subViews = fromView.subviews;
                                              for (UIView *views in subViews) {
                                                  [views setAlpha:0.0f];
                                              }
                                          }];
                                          [containerView addSubview:toView];
                                          [UIView addKeyframeWithRelativeStartTime:0.65f relativeDuration:0.35f animations:^{
                                              NSArray *subViews = toView.subviews;
                                              [toView setAlpha:1.0f];
                                              for (UIView *views in subViews) {
                                                  [views setAlpha:1.0f];
                                              }
                                              [toViewController hideProgressHUD];
                                          }];
                                      } completion:^(BOOL finished) {
                                          [fromView removeFromSuperview];
                                          [transitionContext completeTransition:YES];
                                      }];
        }
            break;
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

@end
