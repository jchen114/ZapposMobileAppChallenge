//
//  ZapposSelectionViewController.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

typedef enum {
    buttonTypeCancel = 0,
    buttonTypeDone
}buttonType;

#import "ZapposSelectionViewController.h"
#import "ZapposTableViewCell.h"
#import "ZapposProduct.h"
#import "ZapposImageViewController.h"
#import "MBProgressHUD.h"
#import "OBShapedButton.h"
#import "AwesomeTransition.h"
#import "ZapposCircleView.h"

#define BUTTON_WIDTH_HEIGHT 45.0f

@interface ZapposSelectionViewController ()
<UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>
{
    NSMutableArray *zapposProducts;
    NSArray *tempProducts;
    UITableView *zapposTable;
    CGRect frameToSet;
    MBProgressHUD *progressHUD;
    AwesomeTransition *awesomeTransition;
    NSString *selectedProductID;
    NSInteger currentIndexToAdd;
    NSMutableArray *indexPaths;
    OBShapedButton *doneButton;
    OBShapedButton *canceledButton;
    UIImageView *fillDoneView;
    UIImageView *fillCancelView;
    CGRect canceledButtonFrame;
    CGRect doneButtonFrame;
}

@end

@implementation ZapposSelectionViewController

- (id)initWithZapposProducts:(NSArray *)products andFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        zapposProducts = [NSMutableArray array];
        tempProducts = products;
        frameToSet = frame;
        awesomeTransition = [[AwesomeTransition alloc] init];
        currentIndexToAdd = 0;
        indexPaths = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:frameToSet];
    [self.view.layer setCornerRadius:7.0f];
    [self.view setBackgroundColor:[ZapposUtilities lighterBlueColor]];
    [self setupButtons];
    [self setupTableView];
}

- (void)hideProgressHUD
{
    [progressHUD hide:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self prepareTableView];
}

- (void)setupButtons
{
    doneButton = [[OBShapedButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60.0f, 5.0f, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT)];
    doneButtonFrame = doneButton.frame;
    fillDoneView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, doneButton.frame.size.width, doneButton.frame.size.height)];
    [fillDoneView setImage:[UIImage imageNamed:@"Check-button"]];
    [doneButton addSubview:fillDoneView];
    [doneButton setAdjustsImageWhenHighlighted:NO];
    [doneButton addTarget:self
                   action:@selector(didTouchDownOnButton:)
         forControlEvents:UIControlEventTouchDown];
    [doneButton addTarget:self
                   action:@selector(didTouchUpOnButton:)
         forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [doneButton setTag:buttonTypeDone];
    canceledButton = [[OBShapedButton alloc] initWithFrame:CGRectMake(10.0f, 5.0f, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT)];
    canceledButtonFrame = canceledButton.frame;
    fillCancelView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, canceledButtonFrame.size.width, canceledButtonFrame.size.height)];
    [fillCancelView setImage:[UIImage imageNamed:@"cancel-button"]];
    [canceledButton addSubview:fillCancelView];
    [canceledButton setAdjustsImageWhenHighlighted:NO];
    [canceledButton addTarget:self
                       action:@selector(didTouchDownOnButton:)
             forControlEvents:UIControlEventTouchDown];
    [canceledButton addTarget:self
                       action:@selector(didTouchUpOnButton:)
             forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [canceledButton setTag:buttonTypeCancel];
    [self.view addSubview:doneButton];
    [self.view addSubview:canceledButton];
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [progressHUD setDimBackground:YES];
    [self.view addSubview:progressHUD];
}

- (void)setupTableView
{
    CGRect subRect = CGRectMake(0.0f, BUTTON_WIDTH_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - BUTTON_WIDTH_HEIGHT);
    zapposTable = [[UITableView alloc] initWithFrame:subRect style:UITableViewStyleGrouped];
    [zapposTable registerClass:[ZapposTableViewCell class] forCellReuseIdentifier:@"cell"];
    [zapposTable setDelegate:self];
    [zapposTable setDataSource:self];
    [zapposTable setAllowsSelection:YES];
    [zapposTable setUserInteractionEnabled:YES];
    [zapposTable setClipsToBounds:YES];
    [zapposTable setBackgroundColor:[UIColor clearColor]];
    [zapposTable setBackgroundView:nil];
    [zapposTable setSeparatorInset:UIEdgeInsetsZero];
    //[self prepareTableView];
    [zapposTable.layer setMasksToBounds:YES];
    [self.view addSubview:zapposTable];
    [self.view sendSubviewToBack:zapposTable];
    [ZapposUtilities addShadowEffectsToLayer:self.view.layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource methods

- (void)prepareTableView
{
    if (currentIndexToAdd < tempProducts.count) {
        [zapposProducts addObject:[tempProducts objectAtIndex:currentIndexToAdd]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndexToAdd inSection:0];
        [zapposTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        currentIndexToAdd ++;
        [zapposTable setAllowsSelection:YES];
        [self performSelector:@selector(prepareTableView) withObject:nil afterDelay:0.13f];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the Transform
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation(M_PI/4, 0.1f, 0.0f, 0.0f);
    //rotation.m34 = 1.0/900;
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0.4f;
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
    switch (indexPath.row % 2) {
        case 0:
        {
            [cell setBackgroundColor:[ZapposUtilities zapposBackgroundColor]];
        }
            break;
        case 1:
        {
            [cell setBackgroundColor:[ZapposUtilities lighterBlueColor]];
        }
        default:
            break;
    }
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    [UIView animateKeyframesWithDuration:1.2f
                                   delay:0.0f
                                 options:0
                              animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.40f animations:^{
            cell.layer.transform = CATransform3DIdentity;
            [cell setAlpha:1.0f];
        }];
        CATransform3D overRotation;
        overRotation = CATransform3DMakeRotation(-M_PI/4, 1.0f, 0.0f, 0.0f);
        [UIView addKeyframeWithRelativeStartTime:0.40f relativeDuration:0.2 animations:^{
            
            cell.layer.transform = overRotation;
        }];
        CATransform3D rotateBack;
        rotateBack = CATransform3DMakeRotation(M_PI*1/5, 1.0f, 0.0f, 0.0f);
        [UIView addKeyframeWithRelativeStartTime:0.70f relativeDuration:0.15f animations:^{
            cell.layer.transform = rotateBack;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.9 relativeDuration:0.10 animations:^{
            cell.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(3.0f, 0.0f, zapposTable.frame.size.width-3.0f, 22.0f)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"Zappos Products"];
    [headerView addSubview:label];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return zapposProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZapposTableViewCell *cell = (ZapposTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZapposProduct *product = [zapposProducts objectAtIndex:indexPath.row];
    [cell setProductNameText:[product getProductName]];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row at %d was selected", (int)indexPath.row);
    ZapposProduct *product = [zapposProducts objectAtIndex:indexPath.row];
    NSString *photoURL = [product getProductURL];
    [progressHUD show:YES];
    [ZapposUtilities downloadImageInBackgroundFromURL:photoURL
                                            withBlock:^(BOOL success, UIImage *image) {
                                                [progressHUD hide:YES];
                                                if (success) {
                                                    ZapposImageViewController *imagePage = [[ZapposImageViewController alloc] initWithImage:image andFrame:self.view.frame];
                                                    [imagePage setTransitioningDelegate:self];
                                                    [imagePage setModalPresentationStyle:UIModalPresentationCustom];
                                                    [self presentViewController:imagePage animated:YES completion:nil];
                                                } else {
                                                    NSLog(@"Failed");
                                                }
    }];
    selectedProductID = [product getProductID];
}

#pragma mark - Button methods

- (void)didTouchDownOnButton:(id)sender
{
    OBShapedButton *button = (OBShapedButton *)sender;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.05f
          initialSpringVelocity:0.3f
                        options:0
                     animations:^{
                         switch (button.tag) {
                             case buttonTypeCancel:
                             {
                                 [fillCancelView setFrame:CGRectInset(fillCancelView.frame, 10.0f, 10.0f)];
                             }
                                 break;
                             case buttonTypeDone:
                             {
                                 [fillDoneView setFrame:CGRectInset(fillDoneView.frame, 10.0f, 10.0f)];
                             }
                             default:
                                 break;
                         }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didTouchUpOnButton:(id)sender
{
    OBShapedButton *button = (OBShapedButton *)sender;
    switch (button.tag) {
        case buttonTypeCancel:
        {
            [self canceledButtonWasPressed:sender];
        }
            break;
        case buttonTypeDone:
        {
            [self doneButtonWasPressed:sender];
        }
        default:
            break;
    }
}

- (void)doneButtonWasPressed:(id)sender
{
    //OBShapedButton *button = (OBShapedButton *)sender;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.05f initialSpringVelocity:0.3f options:0 animations:^{
        [fillDoneView setFrame:CGRectMake(0.0f, 0.0f, doneButtonFrame.size.width, doneButtonFrame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    [self animateCircleScale:doneButton.frame];
    if (selectedProductID && [[self myDelegate] respondsToSelector:@selector(selectedProductID:)]) {
        [[self myDelegate] selectedProductID:selectedProductID];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Please select One!"
                              message:@"No product was selected"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)canceledButtonWasPressed:(id)sender
{
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.05f initialSpringVelocity:0.3f options:0 animations:^{
        [fillCancelView setFrame:CGRectMake(0.0f, 0.0f, canceledButtonFrame.size.width, canceledButtonFrame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    [self animateCircleScale:canceledButton.frame];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)animateCircleScale:(CGRect)frame
{
    ZapposCircleView *circleView = [[ZapposCircleView alloc] initWithFrame:frame];
    [self.view addSubview:circleView];
    [self.view sendSubviewToBack:circleView];
    [UIView animateWithDuration:0.4f animations:^{
        [circleView setTransform:CGAffineTransformMakeScale(3.5f, 3.5f)];
        [circleView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            [circleView removeFromSuperview];
        }
    }];
}

#pragma mark - Transitioning Delegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    [awesomeTransition setAnimationType:AnimationTypePresent];
    return awesomeTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    [awesomeTransition setAnimationType:AnimationTypeDismiss];
    return awesomeTransition;
}

@end
