//
//  SettingsViewController.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 5/27/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController : UIViewController

{
   
    UISwitch *facebookSwitch, *twitterSwitch, *multimediaSwitch;
    
}


@property(nonatomic,strong) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic,strong) IBOutlet UISwitch *twitterSwitch;
@property (nonatomic,strong)IBOutlet UISwitch *LinkedInSwitch;
@property (nonatomic,strong) IBOutlet UIView *faceView;
@property(nonatomic,strong) UIColor *faceColor;

@property (nonatomic,strong) IBOutlet UIView *twitterView;
@property(nonatomic,strong) UIColor *twitterColor;

@property (nonatomic,strong) IBOutlet UIView *linkedInView;
@property(nonatomic,strong) UIColor *linkedInColor;

@property(nonatomic,strong) IBOutlet UIScrollView *scroll;
 
@property (nonatomic,strong)IBOutlet UISwitch *multimediaSwitch;



-(IBAction)facebookSwitchChange:(id)sender;

-(IBAction)twitterSwitchChange:(id)sender;

-(IBAction)LinkedInSwitchChange:(id)sender;

@end
