//
//  TwitterSettings.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/20/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "TwitterSettings.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Foundation/NSNotificationQueue.h>

#define ERROR_TITLE_MSG @"Whoa, there cowboy!"
#define ERROR_NO_ACCOUNTS @"You must add a Twitter account in Settings.app to use FTL Gate."
#define ERROR_PERM_ACCESS @"We weren't granted access to the user's accounts"
#define ERROR_NO_KEYS @"You need to add your Twitter app keys to Info.plist to use this demo.\nPlease see README.md for more info."
#define ERROR_OK @"OK"

@interface TwitterSettings ()
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) TWAPIManager *apiManager;
@property (nonatomic, strong) NSArray *accounts;
@end

@implementation TwitterSettings
@synthesize twitterImage,twitterSwitch,changeAccount,sheetAccount,sheetRefresh,timeLabel,changeRefreshTime;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       _accountStore = [[ACAccountStore alloc] init];
       _apiManager = [[TWAPIManager alloc] init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"TwitterRowSelected"])
    {
        
        NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"TwitterRowSelected"];
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
        timeLabel.text=@"30 minutes (Default)";
    }
  
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
      [self refreshTwitterAccounts];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterLoggedIn"] isEqualToString:@"YES"])
    {
        [twitterSwitch setOn:YES];
    }
    else
    {
        [twitterSwitch setOn:NO];
    }
    
    
    [super viewDidLoad];
    self.title=@"Twitter Settings";
    
    UIColor * color = [UIColor colorWithRed:0/255.0f
                                      green:172/255.0f
                                       blue:237/255.0f
                                      alpha:1.0f];
    self.view.backgroundColor = color;

//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTwitterAccounts) name:ACAccountStoreDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeAccountClick:(id)sender
{

    if (_accounts >0)
    {
    
        sheetAccount = [[UIActionSheet alloc] initWithTitle:@"Choose an Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (ACAccount *acct in _accounts) {
            [sheetAccount addButtonWithTitle:acct.username];
        }
        sheetAccount.tag=1;
        sheetAccount.cancelButtonIndex = [sheetAccount addButtonWithTitle:@"Cancel"];
        
        [sheetAccount showInView:self.tabBarController.view];
        
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts not available!"
                                                        message:@"Insert a Twitter account in your iPhones Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

-(IBAction)twitterSwitchChange:(id)sender
{
    if ([twitterSwitch isOn])
    { 
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"TwitterLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"TwitterLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
}


-(IBAction)changeTimeClick:(id)sender
{
    
    sheetRefresh = [[UIActionSheet alloc] initWithTitle:@"Select feed refresh rate"
                                        delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [sheetRefresh addButtonWithTitle:@"30 minutes"];
    [sheetRefresh addButtonWithTitle:@"45 minutes"];
    [sheetRefresh addButtonWithTitle:@"60 minutes"];
    [sheetRefresh addButtonWithTitle:@"90 minutes"];
    
    sheetRefresh.cancelButtonIndex = [sheetRefresh addButtonWithTitle:@"Cancel"];
    sheetRefresh.tag=2;
    
    [sheetRefresh showInView:self.tabBarController.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1) {
        
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            [_apiManager performReverseAuthForAccount:_accounts[buttonIndex] withHandler:^(NSData *responseData, NSError *error) {
                if (responseData) {
                    
                    NSInteger *number = buttonIndex;
                    
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"TwitterAccountNumber"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"Reverse Auth process returned: %@", responseStr);
                    
                    // NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                    //  NSString *lined = [parts componentsJoinedByString:@"\n"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"TwitterLoggedIn"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"TwitterLoggedInFull"];//????
                        [[NSUserDefaults standardUserDefaults] setInteger:1800.0 forKey:@"TwitterRefreshTime"];
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TwitterRowSelected"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                          timeLabel.text=@"30 minutes (Default)";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Feed has been initiated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show]; //message:lined
                        
                    });
                }
                else {
                    NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
                }
            }];
        }

 
    }
    else if (actionSheet.tag==2)
    {
            NSLog(@"ALOOOOO");
        
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            
            NSInteger number = buttonIndex;
        
            int num =0.0;
            
            NSLog(@"%i",number);
            
            
            if(buttonIndex ==0 )
            {
                num = 1800.0;
                timeLabel.text=@"30 minutes";
                
                [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"TwitterRefreshTime"];
                [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"TwitterRowSelected"];
            }
            else if (buttonIndex ==1)
            {
                num = 2700.0;
                [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"TwitterRefreshTime"];
                [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"TwitterRowSelected"];
                timeLabel.text=@"45 minutes";
            }
            else if (buttonIndex ==2)
            {
                num = 3600.0;
                [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"TwitterRefreshTime"];
                [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"TwitterRowSelected"];
                timeLabel.text=@"60 minutes";
            }
            else if (buttonIndex == 3)
            {
                num = 5400.0;
                [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"TwitterRefreshTime"];
                [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"TwitterRowSelected"];
                timeLabel.text=@"90 minutes";
            }
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
        }
    }
}







- (IBAction)logoutUser:(id)sender {
    
    
}


- (void)refreshTwitterAccounts
{
    NSLog(@"Refreshing Twitter Accounts \n");
    
    if (![TWAPIManager hasAppKeys]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_TITLE_MSG message:ERROR_NO_KEYS delegate:nil cancelButtonTitle:ERROR_OK otherButtonTitles:nil];
        [alert show];
    }
    else if (![TWAPIManager isLocalTwitterAccountAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_TITLE_MSG message:ERROR_NO_ACCOUNTS delegate:nil cancelButtonTitle:ERROR_OK otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self obtainAccessToAccountsWithBlock:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    //connectTwitterButton.enabled = YES;
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_TITLE_MSG message:ERROR_PERM_ACCESS delegate:nil cancelButtonTitle:ERROR_OK otherButtonTitles:nil];
                    [alert show];
                    NSLog(@"You were not granted access to the Twitter accounts.");
                }
            });
        }];
    }
}

- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL))block
{
    ACAccountType *twitterType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error) {
        if (granted) {
            self.accounts = [_accountStore accountsWithAccountType:twitterType];
        }
        
        block(granted);
    };
    
    //  This method changed in iOS6. If the new version isn't available, fall back to the original (which means that we're running on iOS5+).
    if ([_accountStore respondsToSelector:@selector(requestAccessToAccountsWithType:options:completion:)]) {
        [_accountStore requestAccessToAccountsWithType:twitterType options:nil completion:handler];
    }
    else {
        [_accountStore requestAccessToAccountsWithType:twitterType withCompletionHandler:handler];
    }
}




@end
