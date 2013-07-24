//
//  LinkedInCell.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/19/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedInCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *profilePic;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *headlineLabel;
@property (nonatomic,strong) IBOutlet UILabel *descriptionLabel;

@end
