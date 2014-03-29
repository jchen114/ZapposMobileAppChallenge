//
//  ZapposCustomTextField.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/19/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "ZapposCustomTextField.h"

#define TEXT_FIELD_CORNER_RADIUS 5.0f

@implementation ZapposCustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.layer setCornerRadius:TEXT_FIELD_CORNER_RADIUS];
    [self setBackgroundColor:[ZapposUtilities lighterBlueColor]];
    [self setTextColor:[UIColor whiteColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
