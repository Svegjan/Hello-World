//
//  LinkedInCell.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/19/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "LinkedInCell.h"

@implementation LinkedInCell
@synthesize profilePic,nameLabel,timeLabel,descriptionLabel,headlineLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
