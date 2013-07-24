//
//  FacebookFeedViewController.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 5/31/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookDetailViewController.h"
@class FacebookDetailViewController;
@interface FacebookFeedViewController : UITableViewController
{

    UIColor * color;
}
@property (nonatomic,strong) NSMutableArray *friendInfo;  //OPSTI

@property(nonatomic,strong) UIActivityIndicatorView *activityIndicator;

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










@property(nonatomic,strong) NSMutableDictionary *dictionaryLinks;



@property (strong, nonatomic) FacebookDetailViewController *detailViewController;

@end
