//
//  FacebookSettings.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/20/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>

@interface FacebookSettings : UIViewController<UIActionSheetDelegate>
@property (nonatomic,strong)IBOutlet UISwitch *facebookSwitch;
@property (nonatomic,strong)IBOutlet UISwitch *multimediaSwitch;
@property(nonatomic,strong) IBOutlet UIActionSheet *sheet;
@property(nonatomic,strong) IBOutlet UIButton *changeTime;
@property(nonatomic,strong) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong) UIColor *color;
@property (nonatomic,strong) IBOutlet UIButton *changeAccount;


@property (nonatomic,strong) UIImageView *facebookImage;


-(IBAction)LOGIN:(id)sender;
@end
