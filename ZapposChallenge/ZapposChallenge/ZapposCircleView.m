//
//  ZapposCircleView.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/20/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "ZapposCircleView.h"

@implementation ZapposCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGRect subRectangle = CGRectInset(rect, 1.0f, 1.0f);
    
    CGContextAddEllipseInRect(context, subRectangle);
    
    CGContextStrokePath(context);
}


@end
