//
//  FTLFullFeedViewController.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/24/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "FacebookDetailViewController.h"
#import "TwitterDetailViewController.h"
#import "LinkedInDetailViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@class FTLDetailViewController;
@interface FTLFullFeedViewController : UITableViewController
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
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) FacebookDetailViewController *detailViewController;
@property (strong, nonatomic) TwitterDetailViewController *detailViewControllerTwitter;
@property (strong, nonatomic) LinkedInDetailViewController *detailViewControllerLinked;

@property (nonatomic,strong) NSMutableArray *tweetURL;
@property (nonatomic,strong) NSMutableArray *tweetAppURL;



@property (nonatomic,strong) NSMutableArray *friendInfo;  //OPSTI

@property (nonatomic,strong) NSMutableArray *postInfo;    /// OPSTI

@property (nonatomic,strong) NSMutableArray *mediaInfo;

@property (nonatomic,strong) NSMutableArray *nameArray;    //IME

@property (nonatomic,strong) NSMutableArray *pictureArray;

@property (nonatomic,strong) NSMutableArray *picArray;

@property (nonatomic,strong) NSMutableArray *messageArray;

@property (nonatomic,strong) NSMutableArray *typeArray;

@property (nonatomic,strong) NSMutableArray *descriptionArray;

@property (nonatomic,strong) NSMutableArray *permalinkArray;

@property (nonatomic,strong) NSMutableArray *createdTimeArray;

@property(nonatomic,strong) NSMutableArray *arrayMedia;
@property(nonatomic,strong) NSMutableArray *captionArray;

@property (nonatomic,strong) NSMutableArray *sharedDescriptionArray;
@property (nonatomic,strong) NSMutableArray *sharedHREFArray;




@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSMutableArray *picArrayLink;
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





@property(nonatomic,strong) NSMutableDictionary *dictionaryLinks;
@end
