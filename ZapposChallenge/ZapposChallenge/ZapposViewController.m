//
//  ZapposViewController.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "ZapposViewController.h"
#import "ZapposSelectionViewController.h"
#import "ZapposCustomTextField.h"
#import "SickTransition.h"
#import "OBShapedButton.h"
#import "ZapposCircleView.h"

#define TEXT_FIELD_SPACING 35.0f
#define TEXT_FIELD_WIDTH 200.0f
#define TEXT_FIELD_HEIGHT 30.0f
#define TEXT_FIELD_CORNER_RADIUS 5.0f
#define TEXT_FIELD_SHIFT 20.0f
#define BUTTON_WIDTH_HEIGHT 75.0f
#define BASE_URL_STRING @"http://zappostestjacob.appspot.com/zapposchallenge"

typedef enum {
    productID = 0,
    productName
}productParameter;

typedef enum {
    emailTextFieldType = 0,
    productTextFieldType
}textFieldType;

typedef enum {
    buttonTypeID = 0,
    buttonTypeName,
    buttonTypeRequest
}buttonType;

@interface ZapposViewController ()
<UITextFieldDelegate, UIViewControllerTransitioningDelegate, ZapposSelectionPageDelegate>
{
    ZapposCustomTextField *emailTextField;
    ZapposCustomTextField *productTextField;
    UIView *grayView;
    BOOL isShifted;
    BOOL isShifting;
    MBProgressHUD *progressHUD;
    NSArray *myZapposProducts;
    SickTransition *sickTransitionController;
    CGRect frameToSet;
    productParameter productParameterType;
    UISegmentedControl *segmentControl;
    OBShapedButton *IDButton;
    OBShapedButton *nameButton;
    OBShapedButton *requestZapposButton;
    CGRect IDButtonFrame;
    CGRect nameButtonFrame;
    CGRect requestButtonFrame;
}
@end

@implementation ZapposViewController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        myZapposProducts = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupViews];
    [self setupGestures];
}

- (void)setupViews
{
    [self.view setBackgroundColor:[ZapposUtilities zapposBackgroundColor]];
    /*--------------- Logo ---------------*/
    UIImageView *zapposImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Zappos"]];
    [zapposImage setBackgroundColor:[UIColor clearColor]];
    CGRect bigRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 170.0f);
    CGRect smallerRect = CGRectInset(bigRect, 30.0f, 10.0f);
    [zapposImage setFrame:smallerRect];
    [self.view addSubview:zapposImage];
    /*--------------- Text Field --------------- */
    emailTextField = [[ZapposCustomTextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - TEXT_FIELD_WIDTH/2, self.view.frame.size.height * 3/7, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    [emailTextField setPlaceholder:@"Enter your email"];
    [emailTextField setDelegate:self];
    [emailTextField setTag:emailTextFieldType];
    productTextField = [[ZapposCustomTextField alloc] initWithFrame:CGRectMake(emailTextField.frame.origin.x, emailTextField.frame.origin.y + TEXT_FIELD_SPACING, emailTextField.frame.size.width, TEXT_FIELD_HEIGHT)];
    [productTextField setPlaceholder:@"Enter Product ID or Name"];
    [productTextField setDelegate:self];
    [productTextField setTag:productTextFieldType];
    /*----------------- Buttons ------------------*/
    IDButton = [[OBShapedButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - (BUTTON_WIDTH_HEIGHT + 10.0f), productTextField.frame.origin.y + TEXT_FIELD_HEIGHT + 10.0f, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT)];
    IDButtonFrame = IDButton.frame;
    [IDButton setImage:[UIImage imageNamed:@"ID-button-pressed"]
              forState:UIControlStateNormal];
    [IDButton addTarget:self
                 action:@selector(didTouchDownOnButton:)
       forControlEvents:UIControlEventTouchDown];
    [IDButton addTarget:self
                 action:@selector(didTouchUpOnButton:)
       forControlEvents:UIControlEventTouchUpInside];
    [IDButton addTarget:self
                 action:@selector(didTouchUpOnButton:)
       forControlEvents:UIControlEventTouchUpOutside];
    [IDButton setAdjustsImageWhenHighlighted:NO];
    [IDButton setTag:buttonTypeID];
    [self.view addSubview:IDButton];
    nameButton = [[OBShapedButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 10.0f, IDButton.frame.origin.y, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT)];
    [nameButton setImage:[UIImage imageNamed:@"Name-button"]
                forState:UIControlStateNormal];
    [nameButton addTarget:self
                   action:@selector(didTouchDownOnButton:)
         forControlEvents:UIControlEventTouchDown];
    [nameButton addTarget:self
                   action:@selector(didTouchUpOnButton:)
         forControlEvents:UIControlEventTouchUpInside];
    [nameButton addTarget:self
                   action:@selector(didTouchUpOnButton:)
         forControlEvents:UIControlEventTouchUpOutside];
    [nameButton setTag:buttonTypeName];
    [nameButton setAdjustsImageWhenHighlighted:NO];
    nameButtonFrame = nameButton.frame;
    [self.view addSubview:nameButton];
    requestZapposButton = [[OBShapedButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - BUTTON_WIDTH_HEIGHT, IDButton.frame.origin.y + BUTTON_WIDTH_HEIGHT - 18.0f, BUTTON_WIDTH_HEIGHT * 2, BUTTON_WIDTH_HEIGHT * 2)];
    requestButtonFrame = requestZapposButton.frame;
    [requestZapposButton setImage:[UIImage imageNamed:@"Request-Button"]
                         forState:UIControlStateNormal];
    [requestZapposButton addTarget:self
                            action:@selector(didTouchDownOnButton:)
                  forControlEvents:UIControlEventTouchDown];
    [requestZapposButton addTarget:self
                            action:@selector(didTouchUpOnButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    [requestZapposButton addTarget:self
                            action:@selector(didTouchUpOnButton:)
                  forControlEvents:UIControlEventTouchUpOutside];
    [requestZapposButton setTag:buttonTypeRequest];
    [requestZapposButton setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:requestZapposButton];
    [IDButton setSelected:YES];
    /*
    segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"ID-button",@"Name-button"]];
    [segmentControl setTintColor:[UIColor clearColor]];
    [segmentControl setFrame:CGRectMake(self.view.frame.size.width/2 - 80.0f, productTextField.frame.origin.y + TEXT_FIELD_SPACING, 160.0f, TEXT_FIELD_HEIGHT)];
    [segmentControl addTarget:self
                       action:@selector(segmentControllerAction:)
             forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:productID];
     */
    productParameterType = productID;
    grayView = [[UIView alloc] initWithFrame:self.view.frame];
    [grayView setBackgroundColor:[UIColor blackColor]];
    [grayView setAlpha:0.0f];
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [progressHUD setDimBackground:YES];
    //[self.view addSubview:segmentControl];
    [self.view addSubview:grayView];
    [self.view addSubview:emailTextField];
    [self.view addSubview:productTextField];
    [self.view addSubview:progressHUD];
    isShifted = NO;
    isShifting = NO;
    frameToSet = CGRectInset(self.view.frame, INSET_X, INSET_Y);
    sickTransitionController = [[SickTransition alloc] initWithToViewFrame:frameToSet];
}

- (void)setupGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self shiftTextViewsDown];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self shiftTextViewsUp];
    switch (textField.tag) {
        case emailTextFieldType:
        {
            [UIView animateWithDuration:0.3f animations:^{
                [emailTextField setAlpha:1.0f];
                [productTextField setAlpha:0.3f];
            }];
        }
            break;
        case productTextFieldType:
        {
            [UIView animateWithDuration:0.3f animations:^{
                [emailTextField setAlpha:0.3f];
                [productTextField setAlpha:1.0f];
            }];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        [textField setAlpha:0.3f];
    }];
}

- (void)shiftTextViewsUp
{
    if (!isShifted && !isShifting) {
        isShifting = YES;
        [UIView animateWithDuration:0.5f
                              delay:0.0f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.3f
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [emailTextField setFrame:CGRectMake(emailTextField.frame.origin.x, emailTextField.frame.origin.y - TEXT_FIELD_SHIFT, emailTextField.frame.size.width, emailTextField.frame.size.height)];
            [productTextField setFrame:CGRectMake(productTextField.frame.origin.x, productTextField.frame.origin.y - TEXT_FIELD_SHIFT, productTextField.frame.size.width, productTextField.frame.size.height)];
            [grayView setAlpha:0.6f];
        } completion:^(BOOL finished) {
            isShifted = YES;
            isShifting = NO;
        }];
    }
}

- (void)shiftTextViewsDown
{
    if (isShifted && !isShifting) {
        isShifting = YES;
        [emailTextField resignFirstResponder];
        [productTextField resignFirstResponder];
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [emailTextField setAlpha:1.0f];
            [emailTextField setFrame:CGRectMake(emailTextField.frame.origin.x, emailTextField.frame.origin.y + TEXT_FIELD_SHIFT, emailTextField.frame.size.width, emailTextField.frame.size.height)];
            [productTextField setAlpha:1.0f];
            [productTextField setFrame:CGRectMake(productTextField.frame.origin.x, productTextField.frame.origin.y + TEXT_FIELD_SHIFT, productTextField.frame.size.width, productTextField.frame.size.height)];
            [grayView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            isShifted = NO;
            isShifting = NO;
        }];
    }
}

#pragma mark - Button methods

- (void)didTouchDownOnButton:(id)sender
{
    OBShapedButton *button = (OBShapedButton *)sender;
    CGRect smallerFrame;
    if ([button isSelected]) {
        return;
    } else {
        switch (button.tag) {
            case buttonTypeID:
            {
                [button setImage:[UIImage imageNamed:@"ID-button-pressed"]
                        forState:UIControlStateNormal];
                [nameButton setImage:[UIImage imageNamed:@"Name-button"] forState:UIControlStateNormal];
                [requestZapposButton setImage:[UIImage imageNamed:@"Request-Button"] forState:UIControlStateNormal];
                smallerFrame = CGRectInset(button.frame, 10.0f, 10.0f);
            }
                break;
            case buttonTypeName:
            {
                [button setImage:[UIImage imageNamed:@"Name-button-pressed"]
                        forState:UIControlStateNormal];
                [IDButton setImage:[UIImage imageNamed:@"ID-button"] forState:UIControlStateNormal];
                [requestZapposButton setImage:[UIImage imageNamed:@"Request-Button"] forState:UIControlStateNormal];
                smallerFrame = CGRectInset(button.frame, 10.0f, 10.0f);
            }
                break;
            case buttonTypeRequest:
            {
                smallerFrame = CGRectInset(button.frame, 25.0f, 25.0f);
                [button setImage:[UIImage imageNamed:@"Request-Button-pressed"]
                        forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.2f delay:0.0f usingSpringWithDamping:0.05f initialSpringVelocity:0.3f options:0 animations:^{
            [button setFrame:smallerFrame];
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }
}

- (void)didTouchUpOnButton:(id)sender
{
    OBShapedButton *button = (OBShapedButton *)sender;
    CGRect normalFrame;
    switch (button.tag) {
        case buttonTypeID:
        {
            normalFrame = IDButtonFrame;
            productParameterType = productID;
            [nameButton setSelected:NO];
            [requestZapposButton setSelected:NO];
        }
            break;
        case buttonTypeName:
        {
            normalFrame = nameButtonFrame;
            productParameterType = productName;
            [IDButton setSelected:NO];
            [requestZapposButton setSelected:NO];
        }
            break;
        case buttonTypeRequest:
        {
            normalFrame = requestButtonFrame;
            [button setImage:[UIImage imageNamed:@"Request-Button"] forState:UIControlStateNormal];
            [self didPressRequestButton:sender];
        }
            break;
        default:
            break;
    }

    [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:0.05f initialSpringVelocity:0.3f options:0 animations:^{
        [button setFrame:normalFrame];
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    ZapposCircleView *circleView = [[ZapposCircleView alloc] initWithFrame:normalFrame];
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

#pragma mark - UISegmentedControl methods

- (void)segmentControllerAction:(id)sender
{
    segmentControl = (UISegmentedControl *)sender;
    switch (segmentControl.selectedSegmentIndex) {
        case productID:
        {
            productParameterType = productID;
        }
            break;
        case productName:
        {
            productParameterType = productName;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Gesture Methods

- (void)didTapView:(id)sender
{
    [self shiftTextViewsDown];
}

- (void)didPressRequestButton:(id)sender
{
    if ([ZapposUtilities NSStringIsValidEmail:emailTextField.text]) {
        NSString *productFieldText = [productTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (productFieldText.length > 0) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"email":emailTextField.text}];
            switch (productParameterType) {
                case productID:
                {
                    BOOL isNumeric = [ZapposUtilities IsStringNumeric:productFieldText];
                    if (isNumeric) {
                        [params setObject:productFieldText forKey:@"productID"];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Not valid ID"
                                              message:@"Sorry input a valid ID"
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                }
                    break;
                case productName:
                {
                    [params setObject:productFieldText forKey:@"productName"];
                }
                    break;
                default:
                    break;
            }
            [progressHUD show:YES];
            [ZapposUtilities GetResponseForPostForURL:BASE_URL_STRING
                                           withParams:params
                                            withBlock:^(BOOL success, NSArray *zapposProducts) {
                if (success) {
                    [progressHUD hide:YES];
                    if (zapposProducts.count > 0) {
                        ZapposSelectionViewController *selectionPage = [[ZapposSelectionViewController alloc] initWithZapposProducts:zapposProducts andFrame:frameToSet];
                        [selectionPage setMyDelegate:self];
                        [selectionPage setTransitioningDelegate:self];
                        [selectionPage setModalPresentationStyle:UIModalPresentationCustom];
                        [self presentViewController:selectionPage animated:YES completion:nil];
                    } else {
                        // Request has been made
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Request accepted!"
                                              message:@"Your product is being watched"
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                        [alert show];
                    }
                } else {
                    [progressHUD hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Product not found"
                                          message:@"Sorry no such product exists"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];
        } else {
            UIAlertView *productAlert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                                   message:@"Please enter a name or ID"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [productAlert show];
            return;
        }
    } else {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                             message:@"Please enter a valid email"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        [emailAlert show];
        return;
    }
}

#pragma mark - ZapposSelectionPageDelegate Methods

- (void)selectedProductID:(NSString *)ID
{
    [productTextField setText:ID];
    [IDButton setSelected:YES];
    [IDButton setImage:[UIImage imageNamed:@"ID-button-pressed"]
              forState:UIControlStateNormal];
    [nameButton setImage:[UIImage imageNamed:@"Name-button"]
                forState:UIControlStateNormal];
    [requestZapposButton setSelected:NO];
    [requestZapposButton setImage:[UIImage imageNamed:@"Request-Button"]
                         forState:UIControlStateNormal];
    //[segmentControl setSelectedSegmentIndex:productID];
    productParameterType = productID;
}

#pragma mark - Transition Delegate (Modal)

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    [sickTransitionController setAnimationType:AnimationTypePresent];
    return sickTransitionController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    [sickTransitionController setAnimationType:AnimationTypeDismiss];
    return sickTransitionController;
}

@end
