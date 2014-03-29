//
//  ZapposSelectionViewController.h
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZapposSelectionPageDelegate <NSObject>

@required

- (void)selectedProductID:(NSString *)ID;

@end

@interface ZapposSelectionViewController : UIViewController
{
    
}

@property (nonatomic, assign) id <ZapposSelectionPageDelegate> myDelegate;

- (id)initWithZapposProducts:(NSArray *)products andFrame:(CGRect)frame;
- (void)hideProgressHUD;

@end
