//
//  LinkedInSettings.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/20/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "OAuthLoginView.h"
#import "LOAConsumer.h"
#import "LOAMutableURLRequest.h"
#import "LOADataFetcher.h"
#import "LOATokenManager.h"


@interface LinkedInSettings : UIViewController<UIActionSheetDelegate>

@property(nonatomic,strong) IBOutlet UISwitch *switchFeed;
@property (nonatomic,strong) IBOutlet UIButton *changeAccount;
@property (nonatomic,strong) IBOutlet UIButton *changeTime;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UIView *feedView,*refreshView;

@property(nonatomic,strong) UIActionSheet *sheet;

@property(nonatomic,strong) IBOutlet UIScrollView *scroll;

@property(nonatomic,strong) NSMutableArray *arrayTime;

-(IBAction)changeAccountClick:(id)sender;
-(IBAction)changeTimeClick:(id)sender;
@property(nonatomic,strong)OAuthLoginView *oAuthLoginView;
@property(nonatomic,strong) UIColor *color;
@end
 //COMO ESTAS SENOR? COMO COMO COMO