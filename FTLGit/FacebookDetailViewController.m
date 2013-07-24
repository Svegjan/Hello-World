//
//  FacebookDetailViewController.m
//  FTL-Gate
//
//  Created by Lion User on 02/06/2013.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import "FacebookDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FacebookDetailViewController ()


@end

@implementation FacebookDetailViewController
@synthesize detailDescriptionLabel,post,comment,videoLink,webView,backGroundImage,activityIndicator;


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
   
   NSURL *myUrl = [NSURL URLWithString:videoLink];
   NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
   [webView loadRequest:myRequest];

    
   // UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageURL]]];
 
    self.post.text = self.comment;


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
