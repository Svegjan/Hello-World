//
//  FacebookFeedViewController.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 5/31/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "FacebookFeedViewController.h"
#import "FTLDetailViewController.h"
#import "FacebookDetailViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FTLAppDelegate.h"
#import "SettingsViewController.h"
#import <Social/Social.h>
#import "NSDate+NVTimeAgo.h"
#import "FacebookCell.h"
#import "FacebookSettings.h"

@interface FacebookFeedViewController (){
  
    NSString *href;
    NSTimer *timer;
}
@end    

@implementation FacebookFeedViewController

@synthesize friendInfo,postInfo,detailViewController,mediaInfo,dictionaryLinks,arrayMedia,nameArray,picArray,pictureArray,descriptionArray,messageArray,typeArray,permalinkArray,sharedDescriptionArray,sharedHREFArray,captionArray,createdTimeArray,  activityIndicator;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    FTLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];  //DELEGATE OF FTLAPPDELEGATE
    [appDelegate openSessionWithAllowLoginUI:NO];
 
    [super viewWillAppear:YES];
}
- (void)viewDidLoad

{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"FacebookRefreshTime"])
    {
        
        NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"FacebookRefreshTime"];
        NSLog(@"Refresh rate set to %i seconds.",num);
        
        timer = [NSTimer scheduledTimerWithTimeInterval:num   //NA KOLKU VREME RELOAD
                                                 target:self
                                               selector:@selector(refresh:)
                                               userInfo:nil
                                                repeats:YES];
    }
    else{
        
        NSLog(@"Refresh rate not set, feed is not initiated.");
    }

    
    
    
    
    
    
          [self fetchData];

     [self.tabBarController.tabBar setHidden:NO];
    
    CGRect frame = CGRectMake (120, 120, 80, 80);
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: frame];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color = [UIColor whiteColor];
    
    activityIndicator.hidesWhenStopped=YES;
    [self.view addSubview:activityIndicator];
    
   
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];  //LEVOTO KOPCE
    self.navigationItem.leftBarButtonItem =refreshButton;
  
    
UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settings:)];  //DESNOTO KOPCE
    self.navigationItem.rightBarButtonItem = settings;
    
    color = [UIColor colorWithRed:59/255.0f    //BOJA NA TABLEVIEW BACKGROUND I NA NAVIGATIONBAR
                                      green:89/255.0f
                                       blue:152/255.0f
                                      alpha:1.0f];
    self.navigationController.navigationBar.tintColor = color;
    self.tableView.backgroundColor = color;
     
     [super viewDidLoad];

    
    
    


}

-(IBAction)refresh:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedIn"] isEqualToString:@"YES"])
       {
    self.tableView.allowsSelection=NO;
    CGRect frame = CGRectMake (120, 120, 80, 80);
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: frame];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color = [UIColor whiteColor];
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped=YES;
    [self.view addSubview:activityIndicator];
    self.navigationItem.leftBarButtonItem.enabled=NO;
    [self fetchData];

       }
       else
       { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Facebook feed is either turned of or isn't initiated!" message:@"Please enable it in Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];}
    
}
-(IBAction)settings:(id)sender
{
    FacebookSettings *settingsClass = [[FacebookSettings alloc] initWithNibName:@"FacebookSettings" bundle:nil];
    [self.navigationController pushViewController:settingsClass animated:YES];
}


-(void)fetchData
{
   
    FTLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];  //DELEGATE OF FTLAPPDELEGATE
    [appDelegate openSessionWithAllowLoginUI:NO];
    
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
    
     if([[NSUserDefaults standardUserDefaults] objectForKey:@"Multimedia"])
         
         {
             if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Multimedia"] isEqualToString:@"YES"]) {
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
        
         if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedIn"] isEqualToString:@"YES"]) {
             
             
            
            
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
                                     [self.tableView reloadData];
 
      
                          }];
          
       
    
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [picArray count];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedIn"])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedIn"] isEqualToString:@"YES"])
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
        
        
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedIn"] isEqualToString:@"NO"])
        {
            NSLog(@"The count in the table is 0");
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"The feed is not initiated or turned on!";
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setAlpha:0.5];
            cell.userInteractionEnabled = NO;
            return cell;
        }
    
    static NSString *simpleTableIdentifier = @"FacebookCell";
    
    FacebookCell *cell = (FacebookCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FacebookCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellSelectionStyleBlue;
    }
    cell.nameLabel.text = [nameArray objectAtIndex:indexPath.row];
    
    NSInteger theType = [[typeArray objectAtIndex:indexPath.row]integerValue];
    
 
  
    
    double timestampval =  [[createdTimeArray objectAtIndex:indexPath.row] doubleValue];
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    cell.timeLabel.text =[updatetimestamp formattedAsTimeAgo];
    cell.timeLabel.textColor=color;
    
    
    
    NSLog(@"time %@", createdTimeArray);
       
    switch (theType) {
        case 8:
            cell.detailLabel.text = @"Added a new friend!";   //NEW FRIEND ADDED
            break;
            
        case 46:
            cell.detailLabel.text = [messageArray objectAtIndex:indexPath.row];   //STATUS UPDATE
            break;
            
            
        case 60: 
            cell.detailLabel.text = @"Changed the profile photo!";    //CHANGED HIS PROFILE PHOTO
            break;
      
        case 373:
            cell.detailLabel.text = @"Changed the cover photo!";    //CHANGED HIS COVER PHOTO
            break;
            
        case 65:
            if ([[descriptionArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
                cell.detailLabel.text = [sharedDescriptionArray objectAtIndex:indexPath.row];
            }
            else
                cell.detailLabel.text =[descriptionArray objectAtIndex:indexPath.row];     //WSA TAGGED
            break;
            
        case 285:
            cell.detailLabel.text = [captionArray objectAtIndex:indexPath.row];    //CHANGED HIS COVER PHOTO
            break;
        
        case 80:
            
            if ([[descriptionArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
                cell.detailLabel.text = [sharedDescriptionArray objectAtIndex:indexPath.row];
            }
            else
            cell.detailLabel.text =[descriptionArray objectAtIndex:indexPath.row];     //Shared a LINK,PHOTO,VIDEO
            break;
      
     
        default:
            break;
    }
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                             [NSURL URLWithString:
                                              [picArray objectAtIndex:indexPath.row]]]];
    cell.profilePic.image = image;
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        self.tableView.allowsSelection=YES;
        [activityIndicator stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled=YES;
        cell.userInteractionEnabled=YES;
  
       
    }
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    detailViewController =
    [[FacebookDetailViewController alloc] initWithNibName:@"FacebookDetailViewController"
                                          bundle:nil];

       NSInteger theType = [[typeArray objectAtIndex:indexPath.row]integerValue];
    
    switch (theType) {
        case 8: {
                        if([[permalinkArray objectAtIndex:indexPath.row] isEqualToString:@""] || NULL)
                        {
                            detailViewController.videoLink = @"https://www.facebook.com";
                            
                            [detailViewController.view addSubview:detailViewController.webView];
         
                        }
            else
            {
       
                detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.row];
                
                [detailViewController.view addSubview:detailViewController.webView];
            }

            break;
        }
            
        case 46:
        {
            
            
            detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.row];
            [detailViewController.view addSubview:detailViewController.webView];
          
            
            break;
        }
            case 60:
        {
       
            
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.row] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];
         
            
            break;
        }
            
        case 373:
        {
   
            
            detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.row];
            [detailViewController.view addSubview:detailViewController.webView];
            
        
        
                break;
            
        }
            
        case 80:
        {
            detailViewController.comment = [sharedDescriptionArray objectAtIndex:indexPath.row]; //ova sakam da e
            
           
            if([[permalinkArray objectAtIndex:indexPath.row] isEqualToString:@""] || NULL)
            {
                detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.row] objectAtIndex:0];
                
                [detailViewController.view addSubview:detailViewController.webView];
                
            }
            else
            {
                
                detailViewController.videoLink = [permalinkArray objectAtIndex:indexPath.row];
                
                [detailViewController.view addSubview:detailViewController.webView];
            }
      
            
            break;
            
        }
            
        case 285:

        {
            
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.row] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];    //CHECKED IN
            break;
        }
            
        case 347:
            
        {
            
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.row] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];    //CHECKED IN
            break;
        }
            
            
            
        case 65:  //WAS TAGGED IN
            
        {
  
            detailViewController.videoLink = [[sharedHREFArray objectAtIndex:indexPath.row] objectAtIndex:0];
            [detailViewController.view addSubview:detailViewController.webView];    //
            break;
        }
            
        default:
            break;
    }
   

   
    [self.navigationController pushViewController:detailViewController animated:YES];

     
}

@end
