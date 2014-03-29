//
//  ZapposTableViewCell.m
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import "ZapposTableViewCell.h"
#import "ZapposCustomTextField.h"

@implementation ZapposTableViewCell
{
    UILabel *productLabel;
    NSString *productURL;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        productLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        [productLabel setBackgroundColor:[UIColor clearColor]];
        [productLabel setTextColor:[UIColor whiteColor]];
        [productLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:productLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProductNameText:(NSString *)name
{
    productLabel.text = name;
}

- (void)setProductURL:(NSString *)url
{
    productURL = url;
}

#pragma mark - Gesture methods

- (void)didGetTapped:(id)sender
{
    NSLog(@"I got tapped");
    /*if ([[self myDelegate] respondsToSelector:@selector(cellWasTappedWithProductURL:)]) {
        [[self myDelegate] cellWasTappedWithProductURL:productURL];
    }*/
}

@end
