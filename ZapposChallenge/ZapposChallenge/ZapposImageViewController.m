//
//  ZapposImageViewController.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "ZapposImageViewController.h"

@interface ZapposImageViewController ()
{
    UIImage *zapposImage;
    CGRect frameToSet;
    UIImageView *imageView;
}

@end

@implementation ZapposImageViewController

- (id)initWithImage:(UIImage *)image andFrame:(CGRect)frame
{
    self = [self init];
    if (self) {
        zapposImage = image;
        frameToSet = frame;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view.layer setCornerRadius:7.0f];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fadeIn];
}

- (void)setupViews
{
    [self.view setFrame:frameToSet];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageView = [[UIImageView alloc] initWithImage:zapposImage];
    [imageView setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView.layer setMasksToBounds:YES];
    [imageView setClipsToBounds:YES];
    [imageView.layer setCornerRadius:7.0f];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imageView];
    [imageView setAlpha:0.0f];
    [ZapposUtilities addShadowEffectsToLayer:self.view.layer];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)fadeIn
{
    [UIView animateWithDuration:0.5f animations:^{
        [imageView setAlpha:1.0f];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Recognizers

- (void)didTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
