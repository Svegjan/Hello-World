//
//  FacebookSettings.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/20/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "FacebookSettings.h"

@interface FacebookSettings ()

@end

@implementation FacebookSettings
@synthesize facebookSwitch,changeAccount,multimediaSwitch,timeLabel,sheet,changeTime,color;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"FacebookRowSelected"])
    {
        
        NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"FacebookRowSelected"];
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
        timeLabel.text=@"Not initiated.";
    }
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedIn"] isEqualToString:@"YES"])
    {
        [facebookSwitch setOn:YES];
    }
    else
    {
        [facebookSwitch setOn:NO];
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Multimedia"] isEqualToString:@"YES"])
    {
        [multimediaSwitch setOn:YES];
    }
    else
    {
        [multimediaSwitch setOn:NO];
    }

}


- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    
    FTLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    color = [UIColor colorWithRed:59/255.0f    //BOJA NA TABLEVIEW BACKGROUND I NA NAVIGATIONBAR
                            green:89/255.0f
                             blue:152/255.0f
                            alpha:1.0f];
    changeAccount.backgroundColor = color;
    changeTime.backgroundColor = color;
    self.view.backgroundColor=color;
    
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(IBAction)facebookSwitchChange:(id)sender
{  FTLAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
   
    if ([facebookSwitch isOn])
    {
      
        [appDelegate openSessionWithAllowLoginUI:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"FacebookLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    
    else
    {
        [appDelegate closeSession];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FacebookLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(IBAction)multimediaSwitchChange:(id)sender
{ 
    if ([multimediaSwitch isOn])
    {
        
      
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Multimedia"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Multimedia"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.changeAccount setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        [self.changeAccount setTitle:@"Login" forState:UIControlStateNormal];
    }
    
  
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
            
            [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"FacebookRefreshTime"];
            [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"FacebookRowSelected"];
        }
        else if (buttonIndex ==1)
        {
            num = 2700.0;
            [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"FacebookRefreshTime"];
            [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"FacebookRowSelected"];
            timeLabel.text=@"45 minutes";
        }
        else if (buttonIndex ==2)
        {
            num = 3600.0;
            [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"FacebookRefreshTime"];
            [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"FacebookRowSelected"];
            timeLabel.text=@"60 minutes";
        }
        else if (buttonIndex == 3)
        {
            num = 5400.0;
            [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"FacebookRefreshTime"];
            [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"FacebookRowSelected"];
            timeLabel.text=@"90 minutes";
        }
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    }
}





-(IBAction)LOGIN:(id)sender
{
FTLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
[appDelegate closeSession];
    
    // If the person is authenticated, log out when the button is clicked.
    // If the person is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The person has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
    
}



@end
