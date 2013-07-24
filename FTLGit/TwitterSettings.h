//
//  TwitterSettings.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/20/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterSettings : UIViewController<UIActionSheetDelegate>

@property (nonatomic,strong) IBOutlet UISwitch *twitterSwitch;
@property (nonatomic,strong) UIImageView *twitterImage;
@property (nonatomic,strong) IBOutlet UIButton *changeAccount;
@property (nonatomic,strong) IBOutlet UIButton *changeRefreshTime;
@property(nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) UIActionSheet *sheetAccount, *sheetRefresh;
-(IBAction)changeAccountClick:(id)sender;


@end
