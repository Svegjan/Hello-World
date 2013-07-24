//
//  FacebookCell.h
//  FTL-Gate
//
//  Created by Lion User on 19/06/2013.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UIImageView *profilePic;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *detailLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@end


