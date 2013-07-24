//
//  LinkedInDetailViewController.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/17/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedInDetailViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *linkedUrl;
 
@end
