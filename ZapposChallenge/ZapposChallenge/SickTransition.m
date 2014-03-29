//
//  SickTransition.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "SickTransition.h"

@implementation SickTransition
{
    UIView *grayView;
    CGRect frameToSet;
}

- (id)initWithToViewFrame:(CGRect)frame
{
    self = [self init];
    if (self) {
        frameToSet = frame;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    switch (self.animationType) {
        case AnimationTypePresent:
        {
            UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
            CGRect subRect = frameToSet;
            [toView setFrame:CGRectMake(INSET_X, containerView.frame.size.height, subRect.size.width, subRect.size.height)];
            //NSLog(@"toView frame is (x,y,w.h) = (%f,%f,%f,%f)",toView.frame.origin.x, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            grayView = [[UIView alloc] initWithFrame:containerView.frame];
            [grayView setBackgroundColor:[UIColor blackColor]];
            [grayView setAlpha:0.0f];
            [containerView addSubview:grayView];
            [containerView addSubview:toView];
            [toView setAlpha:0.0f];
            [toView.layer setCornerRadius:7.0f];
            [UIView animateWithDuration:0.5f animations:^{
                [grayView setAlpha:0.6f];
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                          delay:0.0f
                         usingSpringWithDamping:0.63f
                          initialSpringVelocity:0.3f
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         [toView setFrame:CGRectMake(INSET_X, INSET_Y, toView.frame.size.width, toView.frame.size.height)];
                                         [toView setAlpha:1.0f];
                                     } completion:^(BOOL finished) {
                                         [transitionContext completeTransition:YES];
                                     }];
                }
            }];
        }
            break;
        case AnimationTypeDismiss:
        {
            UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, M_PI, 1.0f, 0.0f, 0.0f);
            //[modalView.layer setAnchorPoint:CGPointMake(0.5f, 1.0f)];
            [self setAnchorPoint:CGPointMake(0.5f, 1.0f) forView:modalView];
            [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:kNilOptions animations:^{
                [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
                    [modalView.layer setTransform:transform];
                }];
                [UIView addKeyframeWithRelativeStartTime:0.4f relativeDuration:0.6f animations:^{
                    CGAffineTransform shift = CGAffineTransformMakeTranslation(0.0f, 700.0f);
                    [modalView setTransform:shift];
                    [grayView setAlpha:0.0f];
                    [modalView setAlpha:0.0f];
                }];
            } completion:^(BOOL finished) {
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
    return 1.2f;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

@end
