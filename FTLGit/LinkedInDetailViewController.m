//
//  LinkedInDetailViewController.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/17/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "LinkedInDetailViewController.h"

@interface LinkedInDetailViewController ()

@end

@implementation LinkedInDetailViewController
@synthesize webView,linkedUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *myUrl = [NSURL URLWithString:linkedUrl];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    [webView loadRequest:myRequest];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
