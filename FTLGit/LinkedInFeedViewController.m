//
//  LinkedInFeedViewController.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/3/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "LinkedInFeedViewController.h"
#import "SelectNetworksViewController.h"
#import "OAuthLoginView.h"
#import "SettingsViewController.h"
#import "LinkedInDetailViewController.h"
#import "NSDate+NVTimeAgo.h"
#import "LinkedInCell.h"
#import "LinkedInSettings.h"



@interface LinkedInFeedViewController ()


@end

@implementation LinkedInFeedViewController
NSTimer *timer;
@synthesize oAuthLoginView,feedURL,consumer,accessToken,picArray,
urlArray,headLineArray,firstNameArray,lastNameArray,allArray,conArray,
updateTypeArray,companyNameArray,groupNameArray,groupUrlArray,timeArray,recArray,webUrlArray,postedLinkArray;
@synthesize color,color2;





-(IBAction)refresh:(id)sender
{
        [self profileApi];

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
     
    
    }
    return self;
}



- (void)viewDidLoad
{
     
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"RefreshTime"])
    {
        
        NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"RefreshTime"];
        NSLog(@"Refresh rate set to %i seconds.",num);
        timer = [NSTimer scheduledTimerWithTimeInterval:num
                                                 target:self
                                               selector:@selector(profileApi)
                                               userInfo:nil
                                                repeats:YES];
    }
    else{
    
        NSLog(@"Refresh rate not set, feed is not initiated.");
    }

    
    
    
     [self.tabBarController.tabBar setHidden:NO];
    
  [self profileApi];
    self.tableView.allowsSelection=NO;
    
    color2 = [UIColor colorWithRed:180/255.0f    //BOJA ZA CELL, ZAVISI KOJ E
                                      green:200/255.0f
                                       blue:249/255.0f
                                      alpha:1.0f];

    
    color = [UIColor colorWithRed:0/255.0f    //BOJA NA TABLEVIEW BACKGROUND I NA NAVIGATIONBAR
                            green:123/255.0f
                             blue:182/255.0f
                            alpha:1.0f];
        self.navigationController.navigationBar.tintColor = color;
    
    self.tableView.backgroundColor = color;
    
      
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];  //LEVOTO KOPCE
    self.navigationItem.leftBarButtonItem =refreshButton;
 
    
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settings:)];  //DESNOTO KOPCE
    self.navigationItem.rightBarButtonItem = settings;
    
    [super viewDidLoad];
   
    
    headLineArray = [NSMutableArray array];
    firstNameArray = [NSMutableArray array];
    lastNameArray = [NSMutableArray array];
    picArray = [NSMutableArray array];
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
 

}
  

-(IBAction)settings:(id)sender
{
    LinkedInSettings *settingsClass = [[LinkedInSettings alloc] initWithNibName:@"LinkedInSettings" bundle:nil];
    [self.navigationController pushViewController:settingsClass animated:YES];
}

-(void)profileApi
{
    
    @try {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedIn"])
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
        
      
  
    if(  [[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedIn"] isEqualToString:@"YES"])
    {
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *profile = [responseBody objectFromJSONString];
    
        NSLog(@"%@",profile);
        
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
            [picArray addObject:[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"person"] objectForKey:@"pictureUrl"]];
        }
        else if([[updateTypeArray objectAtIndex:i] isEqualToString:@"MSFC"])
        {
            [picArray addObject:[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"] objectForKey:@"companyPersonUpdate"] objectForKey:@"person"] valueForKey:@"pictureUrl"]];
        }
        else
        {[picArray addObject:@""];}
        
        
       
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
                
                
            }
            
            else
            {
                [webUrlArray addObject:[[[[[[[allArray objectAtIndex:i] objectForKey:@"updateContent"]
                                            objectForKey:@"person"] objectForKey:@"recommendationsGiven"]objectForKey:@"values"] objectAtIndex:0] objectForKey:@"webUrl"]];
                
                
    
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
               
            }
            
            
        
        }
        else
        {
            [postedLinkArray addObject:@""];
        }
        
    }

    
    [self.tableView reloadData];

      

    
   
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your LinkedIn feed is either turned of or isn't initiated!" message:@"Please enable it in Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
       
    }

    }
    @catch (NSException *exception) {
        NSLog(@"%@ nnoo",exception);
    }
    
}



- (void)profileApiCallResult:(LOAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
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
    return [allArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedIn"])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedIn"] isEqualToString:@"YES"])
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
        



   static NSString *simpleTableIdentifier = @"LinkedInCell";

    LinkedInCell *cell = (LinkedInCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LinkedInCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
          cell.accessoryType = UITableViewCellSelectionStyleBlue;
    }
 
    double timestampval =  [[timeArray objectAtIndex:indexPath.row] doubleValue]/1000;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    cell.timeLabel.text = [updatetimestamp formattedAsTimeAgo];
    cell.timeLabel.textColor=color;
        
    cell.nameLabel.text = [NSMutableString stringWithFormat: @"%@ %@",[firstNameArray objectAtIndex:indexPath.row], [lastNameArray objectAtIndex:indexPath.row]];
    cell.headlineLabel.text = [headLineArray objectAtIndex:indexPath.row];
    
    
    if([[picArray objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        UIImage *image = [UIImage imageNamed:@"notAvailable.jpg"];
        cell.profilePic.image=image;
        
    }
    
    else
    {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:
                                                  [picArray objectAtIndex:indexPath.row]]]];
        cell.profilePic.image=image;
        
    }
   
      
    //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
      

    
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"CONN"])
    {
      
        cell.descriptionLabel.text = @"New connection...";
    }
  
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"NCON"])
    {
       
        cell.detailTextLabel.text = @"You have added a new connection...";
      
        cell.backgroundColor = color2;
        
    }
    
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"PROF"])
    {
      
        cell.descriptionLabel.text = @"User has updated his/her profile..";
    }
    
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"MSFC"])
    {
        
        cell.descriptionLabel.text = [NSMutableString stringWithFormat: @"Is now following %@",[companyNameArray objectAtIndex:indexPath.row]];
    }
    
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"SHAR"])
    {
       
        cell.descriptionLabel.text = @"Shared an update...";
    }
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"PICU"])
    {
        
        cell.descriptionLabel.text = @"Changed the profile picture...";
    }
    
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"JGRP"])
    {
        
        cell.descriptionLabel.text = [NSMutableString stringWithFormat: @"Joined Group %@",[groupNameArray objectAtIndex:indexPath.row]];
    }
    
    if ([[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"PREC"] || [[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"SVPR"])
    {
        
        cell.descriptionLabel.text = [recArray objectAtIndex:indexPath.row];
        
    }
    
    if ([[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"APPM"] || [[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"APPS"])
    {
        
        cell.descriptionLabel.text = @"Activity in an application..";
        
    }
    
    if ([[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"PRFX"])
    {
        
        cell.descriptionLabel.text = @"Extended profile information...";
        
    }
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        self.tableView.allowsSelection=YES;
      
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
    
     LinkedInDetailViewController *detailViewController = [[LinkedInDetailViewController alloc] initWithNibName:@"LinkedInDetailViewController" bundle:nil];
    
    if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"PROF"]
        || [[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"STAT"] ||
        [[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"MSFC"] || [[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"PRFX"] )
    {
       detailViewController.linkedUrl= [urlArray objectAtIndex:indexPath.row];
    }
     else if ([[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"PREC"] || [[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"SVPR"])
    {
        
        detailViewController.linkedUrl= [webUrlArray objectAtIndex:indexPath.row];
        
    }
    
     else if ([[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"APPM"] || [[updateTypeArray objectAtIndex:indexPath.row]isEqualToString:@"APPS"])
    {
        
      detailViewController.linkedUrl= [urlArray objectAtIndex:indexPath.row];
        
    }
    
     else  if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"JGRP"])
     {
         
         detailViewController.linkedUrl = [[groupUrlArray objectAtIndex:indexPath.row] objectAtIndex:0];
     }
    
    else if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"CONN"])
    {
        detailViewController.linkedUrl = [conArray objectAtIndex:indexPath.row];
    }
    
    else if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"NCON"])
    {
        detailViewController.linkedUrl = [urlArray objectAtIndex:indexPath.row];
    }
    
    else if ([[updateTypeArray objectAtIndex:indexPath.row] isEqualToString:@"SHAR"])
    {
        detailViewController.linkedUrl = [postedLinkArray objectAtIndex:indexPath.row];
    }
    
 
    
 
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}

@end
