//
//  TwitterCell.h
//  FTL-Gate
//
//  Created by Lion User on 19/06/2013.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UITextView *tweetLabel;
@property(nonatomic,strong) IBOutlet UIImageView *profilePic;
@end
