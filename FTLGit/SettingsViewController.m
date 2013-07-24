//
//  SettingsViewController.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 5/27/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize facebookSwitch,twitterSwitch,multimediaSwitch,LinkedInSwitch,faceView,faceColor,twitterColor,twitterView,linkedInColor,linkedInView,scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, 600)];
}

- (void)viewDidLoad
{
    
    
    faceView.layer.cornerRadius = 8.0f;
    faceView.layer.masksToBounds = YES;
    
    twitterView.layer.cornerRadius = 8.0f;
    twitterView.layer.masksToBounds = YES;
    
    linkedInView.layer.cornerRadius = 8.0f;
    linkedInView.layer.masksToBounds = YES;
    
    faceColor = [UIColor colorWithRed:59/255.0f    //BOJA NA TABLEVIEW BACKGROUND I NA NAVIGATIONBAR
                                 green:89/255.0f
                                  blue:152/255.0f
                                 alpha:1.0f];
    faceView.backgroundColor=faceColor;
    
    twitterColor = [UIColor colorWithRed:0/255.0f
                                   green:172/255.0f
                                    blue:237/255.0f
                                   alpha:1.0f];
    twitterView.backgroundColor= twitterColor;
    
    linkedInColor= [UIColor colorWithRed:0/255.0f    //BOJA NA TABLEVIEW BACKGROUND I NA NAVIGATIONBAR
                                   green:123/255.0f
                                    blue:182/255.0f
                                   alpha:1.0f];
    linkedInView.backgroundColor=linkedInColor;
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInLoggedInFull"] isEqualToString:@"YES"])
    {
        [LinkedInSwitch setOn:YES];
    }
    else
    {
        [LinkedInSwitch setOn:NO];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedInFull"] isEqualToString:@"YES"])
    {
        [twitterSwitch setOn:YES];
    }
    else
    {
        [twitterSwitch setOn:NO];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookLoggedInFull"] isEqualToString:@"YES"])
    {
        [facebookSwitch setOn:YES];
    }
    else
    {
        [facebookSwitch setOn:NO];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"MultimediaFull"] isEqualToString:@"YES"])
    {
        [multimediaSwitch setOn:YES];
    }
    else
    {
        [multimediaSwitch setOn:NO];
    }
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)LinkedInSwitchChange:(id)sender
{
    
    if ([LinkedInSwitch isOn])
    {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LinkedInLoggedInFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LinkedInLoggedInFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(IBAction)twitterSwitchChange:(id)sender
{
    if ([twitterSwitch isOn])
    {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"TwitterLoggedInFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"TwitterLoggedInFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
}

-(IBAction)facebookSwitchChange:(id)sender
{  FTLAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    if ([facebookSwitch isOn])
    {
        
        [appDelegate openSessionWithAllowLoginUI:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"FacebookLoggedInFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    
    else
    {
        [appDelegate closeSession];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FacebookLoggedInFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


-(IBAction)multimediaSwitchChange:(id)sender
{
    if ([multimediaSwitch isOn])
    {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"MultimediaFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"MultimediaFull"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end
