//
//  TwitterCell.m
//  FTL-Gate
//
//  Created by Lion User on 19/06/2013.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "TwitterCell.h"

@implementation TwitterCell
@synthesize timeLabel,nameLabel,tweetLabel,profilePic;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
