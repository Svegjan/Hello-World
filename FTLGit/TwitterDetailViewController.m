//
//  TwitterDetailViewController.m
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/11/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "TwitterDetailViewController.h"

@interface TwitterDetailViewController ()

@end

@implementation TwitterDetailViewController
@synthesize webView,tweetUrl,activityIndicator;

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
    
    NSURL *myUrl = [NSURL URLWithString:tweetUrl];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    [webView loadRequest:myRequest];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  
    [activityIndicator startAnimating];
   }

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
  
}
@end
