//
//  LinkedInSettings.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/20/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "LinkedInSettings.h"
#import "OAuthLoginView.h"
#import <QuartzCore/QuartzCore.h>

@interface LinkedInSettings ()

@end

@implementation LinkedInSettings
@synthesize changeAccount,switchFeed,oAuthLoginView,color,arrayTime,changeTime,sheet,timeLabel,feedView,refreshView,scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedIn"] isEqualToString:@"YES"])
    {
        [switchFeed setOn:YES];
    }
    else
    {
        [switchFeed setOn:NO];
    }
    
    
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"RowSelected"])
    {
        
        NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"RowSelected"];
        NSLog(@" THATS WHAT I SAY %i",num);
        
        if(num ==0 )
        {timeLabel.text=@"30 minutes";}
        else if (num ==1)
        {timeLabel.text=@"45 minutes";}
        else if (num ==2)
        {timeLabel.text=@"60 minutes";}
        else if (num ==3)
        {timeLabel.text=@"90 minutes";}
    }
    
    else
    {
        timeLabel.text=@"Not initiated";
    }
    
    
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, 600)];
}


- (void)viewDidLoad
{

    
    [super viewDidLoad];
    
    color = [UIColor colorWithRed:0/255.0f    //BOJA NA TABLEVIEW BACKGROUND I NA NAVIGATIONBAR
                            green:123/255.0f
                             blue:182/255.0f
                            alpha:1.0f];
    
    refreshView.layer.cornerRadius = 8.0f;
    refreshView.layer.masksToBounds = YES;
    refreshView.backgroundColor=color;
    
    feedView.layer.cornerRadius = 8.0f;
    feedView.layer.masksToBounds = YES;
    feedView.backgroundColor=color;
    
    self.navigationController.navigationBar.tintColor = color;
    //self.view.backgroundColor=color;
    
}




-(IBAction)changeTimeClick:(id)sender
{
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"Select feed refresh rate"
                                        delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

        [sheet addButtonWithTitle:@"30 minutes"];
       [sheet addButtonWithTitle:@"45 minutes"];
       [sheet addButtonWithTitle:@"60 minutes"];
       [sheet addButtonWithTitle:@"90 minutes"];
    
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];

    [sheet showInView:self.tabBarController.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != sheet.cancelButtonIndex) {
                       
        NSInteger number = buttonIndex;
        
        int num =0.0;
        
        NSLog(@"%i",number);
        
        
        if(buttonIndex ==0 )
        {
            num = 1800.0;
            timeLabel.text=@"30 minutes";
            
            [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"RefreshTime"];
              [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"RowSelected"];
        }
        else if (buttonIndex ==1)
        {
            num = 2700.0;
            [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"RefreshTime"];
              [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"RowSelected"];
              timeLabel.text=@"45 minutes";
        }
        else if (buttonIndex ==2)
        {
            num = 3600.0;
            [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"RefreshTime"];
              [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"RowSelected"];
              timeLabel.text=@"60 minutes";
        }
        else if (buttonIndex == 3)
        {
                num = 5400.0;
                [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"RefreshTime"];
              [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"RowSelected"];
              timeLabel.text=@"90 minutes";
        }
        
   
        [[NSUserDefaults standardUserDefaults] synchronize];
        

       
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



-(IBAction)LinkedInSwitchChange:(id)sender
{ 
    
    if ([switchFeed isOn])
    {
       
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LinkedInLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    else
    {
  
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LinkedInLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


-(IBAction)changeAccountClick:(id)sender
{
    
    
oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:@"OAuthLoginView" bundle:nil];
//[oAuthLoginView retain];

// register to be told when the login is finished
    
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewDidFinish:) name:@"loginViewDidFinish" object:oAuthLoginView];
[self.navigationController presentViewController:oAuthLoginView animated:YES completion:nil];
    
    
    
}

-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //[self profileApi];
    
	
}


@end
