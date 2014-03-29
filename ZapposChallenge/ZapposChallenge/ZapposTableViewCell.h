//
//  ZapposTableViewCell.h
//  ZapposChallenge
//
//  Created by Jacob Chen on 2/15/14.
//  Copyright (c) 2014 Jacob Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
@protocol ZapposTableCellDelegate <NSObject>

@required

- (void)cellWasTappedWithProductURL:(NSString *)url;

@end
*/

@interface ZapposTableViewCell : UITableViewCell
{
    
}

//@property (nonatomic, assign) id <ZapposTableCellDelegate> myDelegate;

- (void)setProductNameText:(NSString *)name;

@end
