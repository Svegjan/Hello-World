//
//  TwitterFeedViewController.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 5/29/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SettingsViewController.h"
#import "TwitterSettings.h"
#import "TwitterDetailViewController.h"
#import "NSDate+Formatting.h"
#import "NSDate+NVTimeAgo.h"
#import "TwitterCell.h"
#import "WelcomeViewController.h"
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 52.0f


@interface TwitterFeedViewController ()
{
    NSTimer *timer;  //TIMER ZA RELOAADDDD
}



@end

@implementation TwitterFeedViewController
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize tweetURL,tweetAppURL,detailViewController,activityIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
     _accountStore = [[ACAccountStore alloc] init];
         [self setupStrings];
    
    }
    return self;
    
    
   
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (void)viewDidLoad
{
    [self addPullToRefreshHeader];
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"TwitterRefreshTime"])
    {
        
        NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"TwitterRefreshTime"];
        NSLog(@"Refresh rate set to %i seconds.",num);
        timer = [NSTimer scheduledTimerWithTimeInterval:num
                                                 target:self
                                               selector:@selector(getTimeLine)
                                               userInfo:nil
                                                repeats:YES];
    }
    else{
        
        NSLog(@"Refresh rate not set, feed is not initiated.");
    }

    
    
    
 [self.tabBarController.tabBar setHidden:NO];
    
    
    tweetURL = [NSMutableArray array];
    tweetAppURL = [NSMutableArray array];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.leftBarButtonItem =refreshButton;
    
      UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settings:)];
    self.navigationItem.rightBarButtonItem = settings;
    
    [super viewDidLoad];
  

    UIColor * color = [UIColor colorWithRed:0/255.0f
                                      green:172/255.0f
                                       blue:237/255.0f
                                      alpha:1.0f];
    self.navigationController.navigationBar.tintColor = color;
    self.tableView.backgroundColor = color;
    
   /* timer = [NSTimer scheduledTimerWithTimeInterval:20.0   //NA KOLKU VREME RELOAD
                                             target:self
                                           selector:@selector(fetchData)
                                           userInfo:nil
                                            repeats:YES];*/
    
    
   
  
}
-(IBAction)refresh:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedIn"] isEqualToString:@"YES"])
    {
  
    [self getTimeLine];
    }
    
    else
    {
        [self.tableView reloadData];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Twitter feed is either turned of or isn't initiated!"
                        message:@"Please enable it in Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
   
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"First"] )
    {
        // [self getTimeLine];
    }
    
    else
    {
        
        WelcomeViewController *welcomeClass = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:welcomeClass animated:YES];
        
        
        
    }

    [super viewWillAppear:YES];
}
-(IBAction)settings:(id)sender
{
    
    TwitterSettings *settingsClass = [[TwitterSettings alloc] initWithNibName:@"TwitterSettings" bundle:nil];

    [self.navigationController pushViewController:settingsClass animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_dataSource count];
}

- (void)getTimeLine {
    [tweetURL removeAllObjects];
    [tweetAppURL removeAllObjects];
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    @try
    {
     if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedIn"] isEqualToString:@"YES"]) {
    
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
                          
                              for(int i=0;i<[_dataSource count];i++)
                              {
                                  NSMutableString *url = [NSMutableString stringWithFormat: @"https://www.twitter.com/%@/status/%@",[[[_dataSource objectAtIndex:i ]objectForKey:@"user"] valueForKey:@"screen_name"],[[_dataSource objectAtIndex:i ]objectForKey:@"id"]];
                            
                                  [tweetURL addObject:url];
                                  
                                  NSMutableString *urlApp = [NSMutableString stringWithFormat: @"twitter://user?screen_name=%@?status?id=%@",[[[_dataSource objectAtIndex:i ]objectForKey:@"user"] valueForKey:@"screen_name"],[[_dataSource objectAtIndex:i ]objectForKey:@"id"]];
                                  NSLog(@"FEEEED %@",urlApp);
                                  [tweetAppURL addObject:urlApp];
                              }
                      ;
                              
                              
                              CGRect frame = CGRectMake (120, 120, 80, 80);
                              activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: frame];
                              activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                              activityIndicator.color = [UIColor whiteColor];
                              [activityIndicator startAnimating];
                              activityIndicator.hidesWhenStopped=YES;
                              [self.view addSubview:activityIndicator];
                              
                            
        
                              
                              [self.tableView reloadData];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Twitter feed is either turned of or isn't initiated!" message:@"Please enable it in Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [activityIndicator stopAnimating];
    [alert show];
}
    }
    
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
}


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
    
    static NSString *simpleTableIdentifier = @"TwitterCell";
    
    TwitterCell *cell = (TwitterCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TwitterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellSelectionStyleBlue;
    }
    

    NSDictionary *tweet = _dataSource[[indexPath row]];
    
    cell.tweetLabel.text = tweet[@"text"];
    
    NSMutableString *detailText = [NSMutableString stringWithFormat: @"%@ @%@ ",[tweet[@"user"] objectForKey:@"name"] , [tweet[@"user"] objectForKey:@"screen_name"]];
    cell.nameLabel.textColor = [UIColor blackColor];
 

    cell.nameLabel.text = detailText;
    
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                             [NSURL URLWithString:
                                              [tweet[@"user"] objectForKey:@"profile_image_url"]]]];
    
    cell.profilePic.image = image;
    
    NSString *ha = tweet[@"created_at"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *myDate = [[NSDate alloc]init];
    myDate=[df dateFromString: ha];

       
       // NSTimeInterval ti = [myDate timeIntervalSince1970];
        
        NSLog(@"%@ ",[myDate formattedAsTimeAgo]);
        
   
        cell.timeLabel.text=[myDate formattedAsTimeAgo];




    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        
        [activityIndicator stopAnimating];
    }
    
    return cell;
        
    }
    @catch (NSException *e) {
         NSLog(@"Exception: %@", e);
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailViewController =
    [[TwitterDetailViewController alloc] initWithNibName:@"TwitterDetailViewController"
                                                  bundle:nil];
    
    detailViewController.tweetUrl = [tweetURL objectAtIndex:indexPath.row];
    
    NSLog(@"CRACK GOT HEY CRAZY %i",indexPath.row);
    
    //[detailViewController.view addSubview:detailViewController.webView];

   /*   if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[tweetAppURL objectAtIndex:indexPath.row]]])
      {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[tweetAppURL objectAtIndex:indexPath.row]]];
      }
      else{*/
            
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
  
    //  }
    
}



///------------------------------PULL DOWN TO REFRESHHHHH
- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}


- (void)dealloc {
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [super dealloc];
}


@end
