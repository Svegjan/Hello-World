//
//  LinkedInFeedViewController.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/3/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "NSDate+NVTimeAgo.h"

@interface LinkedInFeedViewController : UITableViewController
{
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
    UILabel *myLabel;
    LOAToken *requestToken;
    LOAToken *accessToken;
    LOAConsumer *consumer;
}
@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSMutableArray *picArray;
@property (nonatomic,strong) NSMutableArray *headLineArray;
@property (nonatomic,strong) NSMutableArray *urlArray;
@property (nonatomic,strong) NSMutableArray *firstNameArray;
@property (nonatomic,strong) NSMutableArray *lastNameArray;
@property (nonatomic,strong) NSMutableArray *allArray;
@property (nonatomic,strong) NSMutableArray *conArray;
@property (nonatomic,strong) NSMutableArray *updateTypeArray;
@property (nonatomic,strong) NSMutableArray *companyNameArray;
@property (nonatomic,strong) NSMutableArray *groupUrlArray;
@property (nonatomic,strong) NSMutableArray *groupNameArray;
@property (nonatomic,strong) NSMutableArray *recArray;
@property (nonatomic,strong) NSMutableArray *webUrlArray;
@property (nonatomic,strong) NSMutableArray *postedLinkArray;

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) UIColor *color2;





@property (nonatomic,strong) NSString *feedURL;

@property (nonatomic,strong) OAuthLoginView *oAuthLoginView;

@property(nonatomic, retain) LOAToken *requestToken;
@property(nonatomic, retain) LOAToken *accessToken;
@property(nonatomic, retain) NSDictionary *profile;
@property(nonatomic, retain) LOAConsumer *consumer;

- (void)initLinkedInApi;

@end
