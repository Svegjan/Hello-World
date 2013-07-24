//
//  FTLFullFeedViewController.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/24/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
// MY milkshake brings all th boys t the yard

#import "FTLFullFeedViewController.h"
#import "SettingsViewController.h"
#import "WelcomeViewController.h"
#import "TwitterDetailViewController.h"
#import "TwitterCell.h"
#import "FacebookCell.h"
#import "LinkedInCell.h"
#import "TwitterSettings.h"
#import "LinkedInSettings.h"
#import "FacebookSettings.h"
#import "NSDate+NVTimeAgo.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FTLAppDelegate.h"
#import "SettingsViewController.h"
#import <Social/Social.h>
#import "FTLDetailViewController.h"
#import "OAuthLoginView.h"
#import "FacebookDetailViewController.h"
@interface FTLFullFeedViewController ()

@end

@implementation FTLFullFeedViewController
@synthesize detailViewController,detailViewControllerLinked,detailViewControllerTwitter,tweetAppURL,tweetURL;
@synthesize friendInfo,postInfo,mediaInfo,dictionaryLinks,arrayMedia,nameArray,picArray,pictureArray,descriptionArray,messageArray,typeArray,permalinkArray,sharedDescriptionArray,sharedHREFArray,captionArray,createdTimeArray,  activityIndicator;


@synthesize oAuthLoginView,feedURL,consumer,accessToken,picArrayLink,
urlArray,headLineArray,firstNameArray,lastNameArray,allArray,conArray,
updateTypeArray,companyNameArray,groupNameArray,groupUrlArray,timeArray,recArray,webUrlArray,postedLinkArray;
@synthesize color,color2;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
         _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    FTLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];  //DELEGATE OF FTLAPPDELEGATE
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"First"] )
    {
      //  [self getTimeLine];
    }
    
    else
    {
        
        WelcomeViewController *welcomeClass = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:welcomeClass animated:YES];
        
        
        
    }
    
    [super viewWillAppear:YES];
}

 
- (void)viewDidLoad
{
    [self.tabBarController.tabBar setHidden:NO];

    [self getTwitterFeed:^() { // Completion block
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Twitter feed fetched");
            [self.tableView reloadData];
        });
    }];
    
    [self getFacebookFeed:^() { // Completion block
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Facebook feed fetched");
            [self.tableView reloadData];
        });
    }];
    
    
     [self profileApi];
    
    tweetURL = [NSMutableArray array];
    tweetAppURL = [NSMutableArray array];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.leftBarButtonItem =refreshButton;
    
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settings:)];
    self.navigationItem.rightBarButtonItem = settings;
    
  
    [super viewDidLoad];
    
    
    color = [UIColor colorWithRed:0/255.0f
                                      green:172/255.0f
                                       blue:237/255.0f
                                      alpha:1.0f];
   self.navigationController.navigationBar.tintColor = color;
  //  self.tableView.backgroundColor = color;
    
    [self.tabBarController.tabBar setHidden:NO];
   
    
    headLineArray = [NSMutableArray array];
    firstNameArray = [NSMutableArray array];
    lastNameArray = [NSMutableArray array];
    picArrayLink = [NSMutableArray array];
    urlArray = [NSMutableArray array];
    allArray = [NSMutableArray array];
    conArray = [NSMutableArray array];
    updateTypeArray = [NSMutableArray array];
    companyNameArray = [NSMutableArray array];
    groupNameArray = [NSMutableArray array];
    groupUrlArray = [NSMutableArray array];
    timeArray = [NSMutableArray array];
    recArray = [NSMutableArray array];
    webUrlArray = [NSMutableArray array];
    postedLinkArray = [NSMutableArray array];
    
    
    
    /* timer = [NSTimer scheduledTimerWithTimeInterval:20.0   //NA KOLKU VREME RELOAD
     target:self
     selector:@selector(fetchData)
     userInfo:nil
     repeats:YES];*/
    
    
    
}


-(IBAction)refresh:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedInFull"] isEqualToString:@"YES"]
       || [[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedInFull"] isEqualToString:@"YES"]
       || [[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedInFull"] isEqualToString:@"YES"])
    {
        self.tableView.allowsSelection=NO;
       
        self.navigationItem.leftBarButtonItem.enabled=NO;
        
        [self getTwitterFeed:^() { // Completion block
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Higiena nuleva");
                [self.tableView reloadData];
            });
        }];
        
        [self getFacebookFeed:^() { // Completion block
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Higiena nuleva facebook");
                [self.tableView reloadData];
            });
        }];
     
        
            [self profileApi];
        
    }
    else
    { /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Facebook feed is either turned of or isn't initiated!" message:@"Please enable it in Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];*/
    
    }
    
}



-(IBAction)settings:(id)sender
{
    SettingsViewController *settingsClass = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:settingsClass animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

  
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}


- (void)getTwitterFeed:(void (^)(void))completion {
    [tweetAppURL removeAllObjects];
    [tweetURL removeAllObjects];
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    @try
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedInFull"]) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedInFull"] isEqualToString:@"YES"]) {
            
            [account requestAccessToAccountsWithType:accountType
                                             options:nil completion:^(BOOL granted, NSError *error)
             {
                 if (granted == YES)
                 {
                     NSArray *arrayOfAccounts = [account
                                                 accountsWithAccountType:accountType];
                     
                     if ([arrayOfAccounts count] > 0)
                     {
                         ACAccount *twitterAccount = [arrayOfAccounts objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"TwitterAccountNumber" ]];
                         
                         NSURL *requestURL = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/home_timeline.json"];
                         
                         NSMutableDictionary *parameters =
                         [[NSMutableDictionary alloc] init];
                         [parameters setObject:@"35" forKey:@"count"];
                         [parameters setObject:@"true" forKey:@"include_entities"];
                         // [parameters setObject:@"true" forKey:@"include_rts"];
                         
                         SLRequest *postRequest = [SLRequest
                                                   requestForServiceType:SLServiceTypeTwitter
                                                   requestMethod:SLRequestMethodGET
                                                   URL:requestURL parameters:parameters];
                         
                         postRequest.account = twitterAccount;
                         
                         [postRequest performRequestWithHandler:
                          ^(NSData *responseData, NSHTTPURLResponse
                            *urlResponse, NSError *error)
                          {
                              self.dataSource = [NSJSONSerialization
                                                 JSONObjectWithData:responseData
                                                 options:NSJSONReadingMutableLeaves
                                                 error:&error];
                              
                              if (self.dataSource.count != 0) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      NSLog(@"Description %@",_dataSource);
                                      for(int i=0;i<[_dataSource count];i++)
                                      {
                                          NSMutableString *url = [NSMutableString stringWithFormat: @"https://www.twitter.com/%@/status/%@",[[[_dataSource objectAtIndex:i ]objectForKey:@"user"] valueForKey:@"screen_name"],[[_dataSource objectAtIndex:i ]objectForKey:@"id"]];
                                          NSLog(@"FEEEED %@",url);
                                          [tweetURL addObject:url];
                                          
                                          NSMutableString *urlApp = [NSMutableString stringWithFormat: @"twitter://user?screen_name=%@?status?id=%@",[[[_dataSource objectAtIndex:i ]objectForKey:@"user"] valueForKey:@"screen_name"],[[_dataSource objectAtIndex:i ]objectForKey:@"id"]];
                                          NSLog(@"FEEEED %@",urlApp);
                                          [tweetAppURL addObject:urlApp];
                                      }
                                      
                                      CGRect frame = CGRectMake (120, 120, 80, 80);
                                      activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: frame];
                                      activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                                      activityIndicator.color = [UIColor whiteColor];
                                      [activityIndicator startAnimating];
                                      activityIndicator.hidesWhenStopped=YES;
                                      [self.view addSubview:activityIndicator];
                                      
                               
                                         NSLog(@"We finished receiving the data");
                                 completion();

                                
                                  });
                                       
                              }
                          }];
                     }
                 } else {
                     // Handle failure to get account access TUKA KE NAPRAVAM ACTION SHEET DA GO VRATI NAZAD TI TEKNUVA
                 }  
                 
             }];
        }
        
        
        else  //AKO NE E FEED UKLUCEN!!
        {
            
            [self.tableView reloadData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Facebook feed is either turned of or isn't initiated!" message:@"Please enable it in Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
             }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
  
}

- (void)getFacebookFeed:(void (^)(void))completion {

    self.tableView.allowsSelection=NO;
    
    nameArray = [NSMutableArray array];
    picArray = [NSMutableArray array];
    pictureArray = [NSMutableArray array];
    messageArray = [NSMutableArray array];
    descriptionArray = [NSMutableArray array];
    sharedDescriptionArray = [NSMutableArray array];
    sharedHREFArray = [NSMutableArray array];
    typeArray = [NSMutableArray array];
    
    permalinkArray = [NSMutableArray array];
    captionArray = [NSMutableArray array];
    createdTimeArray = [NSMutableArray array];
    
    postInfo = [NSMutableArray array];
    friendInfo = [NSMutableArray array];
    mediaInfo = [NSMutableArray array];
    arrayMedia = [NSMutableArray array];
    dictionaryLinks = [NSMutableDictionary alloc];
    NSString *query;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MultimediaFull"])
        
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"MultimediaFull"] isEqualToString:@"YES"]) {
            query =
            @"{"
            @"'friends':'SELECT post_id,actor_id,type,target_id,message,created_time,attachment,permalink,description FROM stream WHERE source_id IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND created_time > 1 AND is_hidden = 0 AND type IN (8,46,60,80,285,373,65) ORDER BY created_time DESC LIMIT 30',"
            
            @"'friendinfo':'SELECT uid, name, pic_square,pic_big FROM user WHERE uid IN (SELECT actor_id FROM #friends)',"
            
            @"}";
        }
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Multimedia"] isEqualToString:@"NO"])
        {
            
            
            query =
            @"{"
            @"'friends':'SELECT post_id,actor_id,type,target_id,message,created_time,attachment,permalink,description FROM stream WHERE source_id IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND created_time > 1 AND is_hidden = 0 AND type IN (8,46,285,373,65) ORDER BY created_time DESC LIMIT 30',"
            
            @"'friendinfo':'SELECT uid, name, pic_square,pic_big FROM user WHERE uid IN (SELECT actor_id FROM #friends)',"
            
            @"}";
        }
        
    }
    else
    {
        query =
        @"{"
        @"'friends':'SELECT post_id,actor_id,type,target_id,message,created_time,attachment,permalink,description FROM stream WHERE source_id IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND created_time > 1 AND is_hidden = 0 AND type IN (8,46,60,80,285,373,65) ORDER BY created_time DESC LIMIT 30',"
        
        @"'friendinfo':'SELECT uid, name, pic_square,pic_big FROM user WHERE uid IN (SELECT actor_id FROM #friends)',"
        
        @"}";
    }
    
    
    // Set up the query parameter
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    // Make the API request that uses FQL
    
    
    if (FBSession.activeSession.isOpen) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedInFull"]) {
              if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedInFull"] isEqualToString:@"YES"]) {
            [FBRequestConnection startWithGraphPath:@"/fql"
                                         parameters:queryParam
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                                      if (error) {
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                      } else {
                                          
                                          friendInfo =
                                          (NSMutableArray *) [[[result objectForKey:@"data"]
                                                               objectAtIndex:1]
                                                              objectForKey:@"fql_result_set"];
                                          
                                          postInfo =
                                          (NSMutableArray *) [[[result objectForKey:@"data"]
                                                               objectAtIndex:0]
                                                              objectForKey:@"fql_result_set"];
                                          
                                          
                                          
                                          for (int i = 0; i<[postInfo count]; i++) {
                                              for (int j = 0; j<[friendInfo count]; j++) {
                                                  NSString *tempFriends = [NSString stringWithFormat:@"%@",[[friendInfo objectAtIndex:j]valueForKey:@"uid"]];
                                                  NSString *tempPosts = [NSString stringWithFormat:@"%@",[[postInfo objectAtIndex:i]valueForKey:@"actor_id"]];
                                                  
                                                  
                                                  if ([tempFriends isEqualToString:tempPosts]) {
                                                      
                                                      if([[[postInfo objectAtIndex:i] objectForKey:@"attachment"] valueForKey:@"caption"])
                                                      {[captionArray addObject:[[[postInfo objectAtIndex:i] objectForKey:@"attachment"] valueForKey:@"caption" ]];
                                                      }
                                                      else
                                                      {[captionArray addObject:@""];}  //OPIS NA KAKO POST SE SLUCIL, POSTED a LInk etc
                                                      
                                                      
                                                      if([[postInfo objectAtIndex:i] valueForKey:@"created_time"])
                                                      {[createdTimeArray addObject:[[postInfo objectAtIndex:i] valueForKey:@"created_time"]];}
                                                      else
                                                      {[createdTimeArray addObject:@""];}
                                                      
                                                      
                                                      if([[postInfo objectAtIndex:i] valueForKey:@"description"] == (id)[NSNull null])
                                                      {[descriptionArray addObject:@""];}
                                                      else
                                                      {[descriptionArray addObject:[[postInfo objectAtIndex:i] valueForKey:@"description"]];}  //OPIS NA KAKO POST SE SLUCIL, POSTED a LInk etc
                                                      
                                                      if([[postInfo objectAtIndex:i] valueForKey:@"permalink"] == nil)
                                                      {[permalinkArray  addObject:@""];}
                                                      else
                                                      {[permalinkArray addObject:[[postInfo objectAtIndex:i] valueForKey:@"permalink"]];} //LINK od toa sto bilo postanato (fbLink)
                                                      
                                                      
                                                      if([[[postInfo objectAtIndex:i] objectForKey:@"attachment"] objectForKey:@"media"])
                                                      {
                                                          if([[[postInfo objectAtIndex:i] objectForKey:@"attachment"] objectForKey:@"description"] != nil)
                                                          {
                                                              [sharedDescriptionArray addObject:[[[postInfo objectAtIndex:i] objectForKey:@"attachment"] objectForKey:@"description"]];
                                                          }
                                                          [sharedHREFArray addObject:[[[[postInfo objectAtIndex:i] objectForKey:@"attachment"] objectForKey:@"media"] valueForKey:@"href"]];
                                                      }
                                                      
                                                      else
                                                      {
                                                          
                                                          [sharedDescriptionArray addObject:@""];
                                                          [sharedHREFArray addObject:@""];
                                                      }
                                                      
                                                      
                                                      
                                                      if([[postInfo objectAtIndex:i] valueForKey:@"type"]==nil)   //TIP NA POST,
                                                      {[typeArray addObject:@""];}
                                                      else{[typeArray addObject:[[postInfo objectAtIndex:i] valueForKey:@"type"]];}
                                                      
                                                      if([[postInfo objectAtIndex:i] valueForKey:@"message"]==nil) // STATUS NA POSTOT PISAN
                                                      {[messageArray addObject:@""];}
                                                      else{[messageArray addObject:[[postInfo objectAtIndex:i] valueForKey:@"message"]];}
                                                      
                                                      
                                                      if([[friendInfo objectAtIndex:j]valueForKey:@"pic_square"]==nil)   //MALA SLIKA ZA TABLEVIEW
                                                      {[picArray  addObject:@""];}
                                                      else
                                                      {[picArray addObject:[[friendInfo objectAtIndex:j]valueForKey:@"pic_square"]];}
                                                      
                                                      if([[friendInfo objectAtIndex:j]valueForKey:@"name"]==nil)  //IME NA TOJ STO GO NAPRAVIL POSTOT
                                                      {[nameArray  addObject:@""];}
                                                      else
                                                      {[nameArray addObject:[[friendInfo objectAtIndex:j]valueForKey:@"name"]];}
                                                      
                                                      
                                                      if([[friendInfo objectAtIndex:j]valueForKey:@"pic_big"]==nil)   //PROFILE SLIKA POGOLEMA ZA VO DETAILVIEW
                                                      {[pictureArray  addObject:@""];}
                                                      else
                                                      {[pictureArray addObject:[[friendInfo objectAtIndex:j]valueForKey:@"pic_big"]];}
                                                      
                                                      
                                                  }
                                                  
                                              }
                                              
                                          }
                                          
                                          
                                      }
                                      
                                      NSLog(@"We finished receiving the data");
                                      completion();
                                
                                      
                                      
                                  }];
            
            
            
        }
        }
    }
    
    else
    {
        [self.tableView reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Facebook feed is either turned of or isn't initiated!" message:@"Please enable it in Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        self.navigationItem.leftBarButtonItem.enabled=YES;
        [activityIndicator stopAnimating];
        self.tableView.allowsSelection=YES;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if(indexPath.row == 1)
    {
           @try {
               
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedInFull"])
        {
            NSLog(@"PRVO NIVO");
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedInFull"] isEqualToString:@"YES"])
        {
            
               NSLog(@"VTORO NIVO");
            
    if(_dataSource.count == 0) // no feeds yet
    { 
        NSLog(@"The count in the table is 0");
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"Updating...";
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setAlpha:0.5];
        cell.userInteractionEnabled = NO;
        return cell;
        }
    }
        
            else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedInFull"] isEqualToString:@"NO"])
            {
                NSLog(@"The count in the table is 0");
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.textLabel.text = @"The feed is not initiated or turned on!";
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setAlpha:0.5];
                cell.userInteractionEnabled = NO;
                return cell;
            }
        
        
   
 
 
        
        static NSString *simpleTableIdentifierTW = @"TwitterCell";
        
        TwitterCell *cellTW = (TwitterCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierTW];
        if (cellTW == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TwitterCell" owner:self options:nil];
            cellTW = [nib objectAtIndex:0];
            cellTW.accessoryType = UITableViewCellSelectionStyleBlue;
        }
        
        
        
        NSDictionary *tweet = _dataSource[[indexPath section]];
        
        cellTW.tweetLabel.text = tweet[@"text"];
        
        NSMutableString *detailText = [NSMutableString stringWithFormat: @"%@ @%@ ",[tweet[@"user"] objectForKey:@"name"] , [tweet[@"user"] objectForKey:@"screen_name"]];
        cellTW.nameLabel.textColor = [UIColor blackColor];
        
        
        
        cellTW.nameLabel.text = detailText;
        
        
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:
                                                  [tweet[@"user"] objectForKey:@"profile_image_url"]]]];
        
        cellTW.profilePic.image = image;
        
        
        
        NSString *ha = tweet[@"created_at"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *myDate = [[NSDate alloc]init];
        myDate=[df dateFromString: ha];
        
        
        // NSTimeInterval ti = [myDate timeIntervalSince1970];
        
        NSLog(@"%@ ",[myDate formattedAsTimeAgo]);
        
        
        cellTW.timeLabel.text=[myDate formattedAsTimeAgo];
        cellTW.timeLabel.textColor=color;
        
        if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
            
            [activityIndicator stopAnimating];
            self.tableView.allowsSelection=YES;
            
            self.navigationItem.leftBarButtonItem.enabled=YES;
        }
        
        return cellTW;
        
    }

        else
        {
            NSLog(@"The count in the table is 0");
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"The feed is not initiated or turned on!";
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setAlpha:0.5];
            cell.userInteractionEnabled = NO;
            return cell;
        }
    
           }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
    }
        
    }
    
    
    else if (indexPath.row == 2)
    {
        
        @try {
            
       
       if([[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedInFull"])
       {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedInFull"] isEqualToString:@"YES"])
        {
            
            
            if(allArray.count == 0) { // no feeds yet
                NSLog(@"The count in the table is 0");
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.textLabel.text = @"Updating...";
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setAlpha:0.5];
                cell.userInteractionEnabled = NO;
                return cell;
            }
            
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedInFull"] isEqualToString:@"NO"])
        {
            NSLog(@"The count in the table is 0");
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"The feed is not initiated or turned on!";
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setAlpha:0.5];
            cell.userInteractionEnabled = NO;
            return cell;
        }
        
    
        
        
    static NSString *simpleTableIdentifierLI = @"LinkedInCell";
    
    LinkedInCell *cellLI = (LinkedInCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierLI];
    if (cellLI == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LinkedInCell" owner:self options:nil];
        cellLI = [nib objectAtIndex:0];
        cellLI.accessoryType = UITableViewCellSelectionStyleBlue;
    }
  
    double timestampval =  [[timeArray objectAtIndex:indexPath.section] doubleValue]/1000;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    cellLI.timeLabel.text = [updatetimestamp formattedAsTimeAgo];
    cellLI.timeLabel.textColor=color;
    
    cellLI.nameLabel.text = [NSMutableString stringWithFormat: @"%@ %@",[firstNameArray objectAtIndex:indexPath.section], [lastNameArray objectAtIndex:indexPath.section]];
    cellLI.headlineLabel.text = [headLineArray objectAtIndex:indexPath.section];
    
    
    if([[picArrayLink objectAtIndex:indexPath.section] isEqualToString:@""])
    {
        UIImage *image = [UIImage imageNamed:@"notAvailable.jpg"];
        cellLI.profilePic.image=image;
        
    }
    else
    {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:
                                                  [picArrayLink objectAtIndex:indexPath.section]]]];
       cellLI.profilePic.image=image;
        
    }

    
    if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"CONN"])
    {
        
        cellLI.descriptionLabel.text = @"New connection...";
    }
    
   else  if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"NCON"])
    {
        
       cellLI.detailTextLabel.text = @"You have added a new connection...";
        
        cellLI.backgroundColor = color2;
        
    }
    
   else  if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"PROF"])
    {
        
        cellLI.descriptionLabel.text = @"User has updated his/her profile..";
    }
    
  else   if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"MSFC"])
    {
        
       cellLI.descriptionLabel.text = [NSMutableString stringWithFormat: @"Is now following %@",[companyNameArray objectAtIndex:indexPath.row]];
    }
    
   else  if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"SHAR"])
    {
        
        cellLI.descriptionLabel.text = @"Shared an update...";
    }
  else   if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"PICU"])
    {
        
        cellLI.descriptionLabel.text = @"Changed the profile picture...";
    }
    
   else  if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"JGRP"])
    {
        
        cellLI.descriptionLabel.text = [NSMutableString stringWithFormat: @"Joined Group %@",[groupNameArray objectAtIndex:indexPath.row]];
    }
    
   else  if ([[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"PREC"] || [[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"SVPR"])
    {
        
        cellLI.descriptionLabel.text = [recArray objectAtIndex:indexPath.section];
        
    }
    
  else   if ([[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"APPM"] || [[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"APPS"])
    {
        
        cellLI.descriptionLabel.text = @"Activity in an application..";
        
    }
    
   else  if ([[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"PRFX"])
    {
        
        cellLI.descriptionLabel.text = @"Extended profile information...";
        
    }
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        self.tableView.allowsSelection=YES;
        
        self.navigationItem.leftBarButtonItem.enabled=YES;
        cellLI.userInteractionEnabled=YES;
        
        
    }
        if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
            self.tableView.allowsSelection=YES;
            [activityIndicator stopAnimating];
            self.navigationItem.leftBarButtonItem.enabled=YES;
            cellLI.userInteractionEnabled=YES;
            
            
        }
    return cellLI;
           
        }
        
        else
        {
            NSLog(@"The count in the table is 0");
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"The feed is not initiated or turned on!";
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setAlpha:0.5];
            cell.userInteractionEnabled = NO;
            return cell;
            NSLog(@"AA");
        }
            
            
        }
        
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
            
        }
        
       
       
}
    
    
    
    else if (indexPath.row == 0)
    {
    
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedInFull"])
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedInFull"] isEqualToString:@"YES"])
            {
            if(postInfo.count == 0) { // no feeds yet
                NSLog(@"The count in the table is 0");
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.textLabel.text = @"Updating...";
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setAlpha:0.5];
                cell.userInteractionEnabled = NO;
                return cell;
            }
            }
            
        
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedInFull"] isEqualToString:@"NO"])
        {
            NSLog(@"The count in the table is 0");
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"The feed is not initiated or turned off!";
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setAlpha:0.5];
            cell.userInteractionEnabled = NO;
            return cell;
        }
        
        
        
    
    static NSString *simpleTableIdentifierFA = @"FacebookCell";
    
    FacebookCell *cellFA = (FacebookCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierFA];
    if (cellFA == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FacebookCell" owner:self options:nil];
        cellFA = [nib objectAtIndex:0];
        cellFA.accessoryType = UITableViewCellSelectionStyleBlue;
    }
    cellFA.nameLabel.text = [nameArray objectAtIndex:indexPath.section];
    
    NSInteger theType = [[typeArray objectAtIndex:indexPath.section]integerValue];
    
    
    
    
    double timestampval =  [[createdTimeArray objectAtIndex:indexPath.section] doubleValue];
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    cellFA.timeLabel.text =[updatetimestamp formattedAsTimeAgo];
    cellFA.timeLabel.textColor=color;
    
    
    
    NSLog(@"time %@", createdTimeArray);
    
    switch (theType) {
        case 8:
            cellFA.detailLabel.text = @"Added a new friend!";   //NEW FRIEND ADDED
            break;
            
        case 46:
            cellFA.detailLabel.text = [messageArray objectAtIndex:indexPath.section];   //STATUS UPDATE
            break;
            
            
        case 60:
            cellFA.detailLabel.text = @"Changed the profile photo!";    //CHANGED HIS PROFILE PHOTO
            break;
            
        case 373:
            cellFA.detailLabel.text = @"Changed the cover photo!";    //CHANGED HIS COVER PHOTO
            break;
            
        case 65:
            if ([[descriptionArray objectAtIndex:indexPath.section] isEqualToString:@""]) {
                cellFA.detailLabel.text = [sharedDescriptionArray objectAtIndex:indexPath.section];
            }
            else
                cellFA.detailLabel.text =[descriptionArray objectAtIndex:indexPath.section];     //WSA TAGGED
            break;
            
        case 285:
            cellFA.detailLabel.text = [captionArray objectAtIndex:indexPath.section];    //CHANGED HIS COVER PHOTO
            break;
            
        case 80:
            
            if ([[descriptionArray objectAtIndex:indexPath.section] isEqualToString:@""]) {
                cellFA.detailLabel.text = [sharedDescriptionArray objectAtIndex:indexPath.section];
            }
            else
                cellFA.detailLabel.text =[descriptionArray objectAtIndex:indexPath.section];     //Shared a LINK,PHOTO,VIDEO
            break;
            
            
        default:
            break;
    }
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                             [NSURL URLWithString:
                                              [picArray objectAtIndex:indexPath.section]]]];
    cellFA.profilePic.image = image;
      
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        self.tableView.allowsSelection=YES;
        [activityIndicator stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled=YES;
        cellFA.userInteractionEnabled=YES;
        
        
    }
    
  return cellFA;
    }
    


else
{
    NSLog(@"The count in the table is 0");
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"The feed is not initiated or turned on!";
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setAlpha:0.5];
    cell.userInteractionEnabled = NO;
    return cell;
    NSLog(@"AA");
}



}
}

-(void)profileApi
{
    
    @try {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedInFull"])
        {
    NSString *responseBody = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    
    
        self.accessToken = [[LOAToken alloc] initWithHTTPResponseBody:responseBody];
        
        NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?count=20&type=SHAR&type=PICT&type=RECU&type=CONN&type=PRFU&type=JGRP&type=APPS&type=PRFX"];
        //
        apikey = @"1pcaz8sogwo3";
        secretkey = @"ueRVtDY13GqXq7C3";
        
        self.consumer = [[LOAConsumer alloc] initWithKey:apikey
                                                  secret:secretkey
                                                   realm:@"http://api.linkedin.com/"];
        
        
        LOAMutableURLRequest *request =
        [[LOAMutableURLRequest alloc] initWithURL:url
                                         consumer:self.consumer
                                            token:self.accessToken
                                         callback:nil
                                signatureProvider:nil];
        
        [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
        
        LOADataFetcher *fetcher = [[LOADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(profileApiCallResult:didFinish:)
                      didFailSelector:@selector(profileApiCallResult:didFail:)];
        
    
    
        }
        else{
            NSLog(@"ERORRR");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
    
    
}

- (void)profileApiCallResult:(LOAServiceTicket *)ticket didFinish:(NSData *)data
{
    
    @try {
        
        
        if(  [[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedInFull"] isEqualToString:@"YES"])
        {
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *profile = [responseBody objectFromJSONString];
            
            NSString *firstNameStr = [profile objectForKey:@"firstName"];
            NSString *lastNameStr = [profile objectForKey:@"lastName"];
            
            if(firstNameStr!= nil || lastNameStr!= nil) {
                
                NSString *name = [NSString stringWithFormat:@"%@ %@",firstNameStr,lastNameStr];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:name forKey:@"Register"];
                [defaults synchronize];
                
            }
            allArray = [profile objectForKey:@"values"];
            
            for(int i=0; i<allArray.count; i++)
            {
                
                if([[allArray objectAtIndex:i]valueForKey:@"timestamp"])
                {
                    [timeArray addObject:[[allArray objectAtIndex:i]valueForKey:@"timestamp"]];    //?VREME
                }
                else{
                    [timeArray addObject:@""];
                }
                
                
                [updateTypeArray addObject:[[allArray objectAtIndex:i] valueForKey:@"updateType"]];
                
                if(![[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"firstName"] isEqualToString:@"private"])    // ZIMAM FIRST NAME
                {[firstNameArray addObject:[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"firstName"]];}
                else if([[updateTypeArray objectAtIndex:i] isEqualToString:@"MSFC"])
                {
                    [firstNameArray addObject:[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"companyPersonUpdate"] objectForKey:@"person"] valueForKey:@"firstName"]];
                }
                else
                { [firstNameArray addObject:@""];}
                
                
                if(![[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"lastName"] isEqualToString:@"private"])   //ZIMAM LAST NAME
                    [lastNameArray addObject:[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"lastName"]];
                else if([[updateTypeArray objectAtIndex:i] isEqualToString:@"MSFC"])
                {
                    [lastNameArray addObject:[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"companyPersonUpdate"] objectForKey:@"person"] valueForKey:@"lastName"]];
                }
                else{ [lastNameArray addObject:@""];}
                
                if(![[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"headlinename"] isEqualToString:@"private"])   //ZIMAM HEADLINE
                    [headLineArray addObject:[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"headline"]];
                else if([[updateTypeArray objectAtIndex:i] isEqualToString:@"MSFC"])
                {
                    [headLineArray addObject:[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"companyPersonUpdate"] objectForKey:@"person"] valueForKey:@"headline"]];
                }
                else{ [headLineArray addObject:@""];}
                
                
                if ([[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"pictureUrl"]) {    //SLIKA URL PROFILE
                    [picArrayLink addObject:[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"pictureUrl"]];
                }
                else if([[updateTypeArray objectAtIndex:i] isEqualToString:@"MSFC"])
                {
                    [picArray addObject:[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"companyPersonUpdate"] objectForKey:@"person"] valueForKey:@"pictureUrl"]];
                }
                else
                {[picArrayLink addObject:@""];}
                
                
                
                if([[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"])  // URL ZA USER PROFILE
                {
                    if([[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"siteStandardProfileRequest"])
                    {
                        [urlArray addObject:[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"]
                                              valueForKey:@"siteStandardProfileRequest"]valueForKey:@"url"]];
                        
                    }
                    
                }
                
                else if([[updateTypeArray objectAtIndex:i] isEqualToString:@"MSFC"])
                {
                    
                    [urlArray addObject:[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"companyPersonUpdate"] objectForKey:@"person"] valueForKey:@"siteStandardProfileRequest"] valueForKey:@"url"] ];
                    
                }
                
                else
                {
                    [urlArray addObject:@""];
                    //[recArray addObject:@""];
                    
                }
                
                
                
                if([[updateTypeArray objectAtIndex:i]isEqualToString:@"PREC"] || [[updateTypeArray objectAtIndex:i]isEqualToString:@"SVPR"])
                {
                    
                    if ([[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                          objectForKey:@"person"] objectForKey:@"recommendationsReceived"]) {
                        
                        [webUrlArray addObject:[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                    objectForKey:@"person"] objectForKey:@"recommendationsReceived"]objectForKey:@"values"] objectAtIndex:0] objectForKey:@"webUrl"] ];
                        [recArray addObject:@"Received recommendation from.."];
                        
                        NSLog(@"EYES OPEN %@",[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                   objectForKey:@"person"] objectForKey:@"recommendationsReceived"]objectForKey:@"values"] objectAtIndex:0] objectForKey:@"webUrl"] );
                    }
                    
                    else
                    {
                        [webUrlArray addObject:[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                    objectForKey:@"person"] objectForKey:@"recommendationsGiven"]objectForKey:@"values"] objectAtIndex:0] objectForKey:@"webUrl"]];
                        
                        
                        
                        NSLog(@"EYES CLOSED %@",[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                     objectForKey:@"person"] objectForKey:@"recommendationsGiven"]objectForKey:@"values"] objectAtIndex:0] objectForKey:@"webUrl"]);
                        [recArray addObject:@"Gave a recommendation to.."];
                    }
                    
                }
                else
                {
                    
                    [recArray addObject:@""];
                    [webUrlArray addObject:@""];
                }
                
                
                
                
                if ([[updateTypeArray objectAtIndex:i] isEqualToString:@"CONN"])   /// KAKOV VID NA UPDATE
                {
                    if([[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                         objectForKey:@"person"] objectForKey:@"connections"])
                        
                    {
                        
                        if([[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                               objectForKey:@"person"]objectForKey:@"connections"]
                             objectForKey:@"values"] objectAtIndex:0 ])
                        {
                            
                            if([[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                    objectForKey:@"person"]objectForKey:@"connections"]
                                  objectForKey:@"values"] objectAtIndex:0] objectForKey:@"siteStandardProfileRequest"])
                                
                                
                            {
                                NSString *every =[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                      objectForKey:@"person"]objectForKey:@"connections"]
                                                    objectForKey:@"values"] objectAtIndex:0] objectForKey:@"siteStandardProfileRequest"];
                                
                                if([every isEqual:@"private"])
                                { [conArray addObject:@"http://www.linkedin.com"];}  // ako e private me prakja samo na linkedin
                                else{
                                    [conArray addObject:[[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                              objectForKey:@"person"]objectForKey:@"connections"]
                                                            objectForKey:@"values"] objectAtIndex:0 ]objectForKey:@"siteStandardProfileRequest"] valueForKey:@"url"]];
                                    
                                }
                                
                                
                                
                            }
                        }
                    }
                    
                    else
                    {[conArray addObject:@""];}
                    
                }
                
                else
                {[conArray addObject:@""];}
                
                
                if ([[updateTypeArray objectAtIndex:i] isEqualToString:@"JGRP"])   /// VLEGLE VO GRUPa, KOE IME I URL OD GRUPATA
                {
                    
                    [groupUrlArray addObject:[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                  objectForKey:@"person"] objectForKey:@"memberGroups"] objectForKey:@"values"]
                                               valueForKey:@"siteGroupRequest"]
                                              valueForKey:@"url"]];
                    
                    [groupNameArray addObject:[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                  objectForKey:@"person"] objectForKey:@"memberGroups"] objectForKey:@"values"] valueForKey:@"name"]];
                    
                }
                else
                {[groupUrlArray addObject:@""];
                    [groupNameArray addObject:@""];
                }
                
                
                if([[updateTypeArray objectAtIndex:i] isEqualToString:@"MSFC"])
                {
                    [companyNameArray addObject:[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"company"] valueForKey:@"name"]];
                }
                else
                {
                    [companyNameArray addObject:@""];
                    
                }
                
                
                if([[updateTypeArray objectAtIndex:i] isEqualToString:@"SHAR"] && [[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                                                   objectForKey:@"person"])
                {
                    if([[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                           objectForKey:@"person"] objectForKey:@"currentShare"]
                         objectForKey:@"content"] objectForKey:@"eyebrowUrl"])
                    {
                        
                        
                        
                        [postedLinkArray addObject:[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                                       objectForKey:@"person"] objectForKey:@"currentShare"]
                                                     objectForKey:@"content"] objectForKey:@"eyebrowUrl"]];
                        NSLog(@"%@",[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                        objectForKey:@"person"] objectForKey:@"currentShare"]
                                      objectForKey:@"content"] objectForKey:@"eyebrowUrl"]);
                    }
                    
                    
                    
                }
                else
                {
                    [postedLinkArray addObject:@""];
                }
                
            }
            
            
            [self.tableView reloadData];
            
            
            
            
            NSLog(@"But I didnt shoot the deputy %@",profile);
        }
        else
        {
            [self.tableView reloadData];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}



- (void)profileApiCallResult:(LOAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if(indexPath.row==1)
     {
         if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[tweetAppURL objectAtIndex:indexPath.section]]])
         {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[tweetAppURL objectAtIndex:indexPath.section]]];
         }
         else{
             
             detailViewControllerTwitter =
             [[TwitterDetailViewController alloc] initWithNibName:@"TwitterDetailViewController"
                                                           bundle:nil];
             
             detailViewControllerTwitter.tweetUrl = [tweetURL objectAtIndex:indexPath.section];
             //[detailViewController.view addSubview:detailViewController.webView];
             
             
             
             [self.navigationController pushViewController:detailViewControllerTwitter animated:YES];
             
             
         }
         

     }
    
   else if(indexPath.row==0){  detailViewController =
    [[FacebookDetailViewController alloc] initWithNibName:@"FacebookDetailViewController"
                                                   bundle:nil];
    
    NSInteger theType = [[typeArray objectAtIndex:indexPath.section]integerValue];
    
    switch (theType) {
        case 8: {
            if([[permalinkArray objectAtIndex:indexPath.section] isEqualToString:@""] || NULL)
            {
                detailViewController.videoLink = @"https://www.facebook.com";
                
                [detailViewController.view addSubview:detailViewController.webView];
                
            }
            else
            {
                
                detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.section];
                
                [detailViewController.view addSubview:detailViewController.webView];
            }
            
            break;
        }
            
        case 46:
        {
            
            
            detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.section];
            [detailViewController.view addSubview:detailViewController.webView];
            
            
            break;
        }
        case 60:
        {
            
            
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.section] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];
            
            
            break;
        }
            
        case 373:
        {
            
            
            detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.section];
            [detailViewController.view addSubview:detailViewController.webView];
            
            
            
            break;
            
        }
            
        case 80:
        {
            detailViewController.comment = [sharedDescriptionArray objectAtIndex:indexPath.section]; //ova sakam da e
            
            
            if([[permalinkArray objectAtIndex:indexPath.row] isEqualToString:@""] || NULL)
            {
                detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.section] objectAtIndex:0];
                
                [detailViewController.view addSubview:detailViewController.webView];
                
            }
            else
            {
                
                detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.section];
                
                [detailViewController.view addSubview:detailViewController.webView];
            }
            
            
            break;
            
        }
            
        case 285:
            
        {
            
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.section] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];    //CHECKED IN
            break;
        }
            
        case 347:
            
        {
            
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.section] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];    //CHECKED IN
            break;
        }
            
            
            
        case 65:  //WAS TAGGED IN
            
        {
            
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.section] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];    //
            break;
        }
            
        default:
            break;
    }
    
    
    
    [self.navigationController pushViewController:detailViewController animated:YES];
        
    }
    
    else if (indexPath.row==2)
    {
        
       detailViewControllerLinked = [[LinkedInDetailViewController alloc] initWithNibName:@"LinkedInDetailViewController" bundle:nil];
        
        if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"PROF"]
            || [[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"STAT"] ||
            [[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"MSFC"] || [[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"PRFX"] )
        {
            detailViewControllerLinked.linkedUrl= [urlArray objectAtIndex:indexPath.section];
        }
        else if ([[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"PREC"] || [[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"SVPR"])
        {
            
           detailViewControllerLinked.linkedUrl= [webUrlArray objectAtIndex:indexPath.section];
            
        }
        
        else if ([[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"APPM"] || [[updateTypeArray objectAtIndex:indexPath.section]isEqualToString:@"APPS"])
        {
            
            detailViewControllerLinked.linkedUrl= [urlArray objectAtIndex:indexPath.section];
            
        }
        
        else  if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"JGRP"])
        {
            
           detailViewControllerLinked.linkedUrl = [[groupUrlArray objectAtIndex:indexPath.section] objectAtIndex:0];
        }
        
        else if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"CONN"])
        {
            detailViewControllerLinked.linkedUrl = [conArray objectAtIndex:indexPath.section];
        }
        
        else if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"NCON"])
        {
           detailViewControllerLinked.linkedUrl = [urlArray objectAtIndex:indexPath.section];
        }
        
        else if ([[updateTypeArray objectAtIndex:indexPath.section] isEqualToString:@"SHAR"])
        {
           detailViewControllerLinked.linkedUrl = [postedLinkArray objectAtIndex:indexPath.section];
        }
        
        
        
        
        [self.navigationController pushViewController:detailViewControllerLinked animated:YES];
    }
}

@end
