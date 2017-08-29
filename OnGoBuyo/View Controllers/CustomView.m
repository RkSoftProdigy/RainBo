//
//  CustomView.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/15/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "CustomView.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "ModelClass.h"
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UIWebView+transformWeb.h"

@interface CustomView ()
{
    ModelClass *model;
}
@end

@implementation CustomView
@synthesize customView,urlToDisplay,strPrev,topView;

- (void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [topView TransformationView];
    [customView TransformWebView];
    
    [super viewDidLoad];
    model=[ModelClass sharedManager];
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        if ([strPrev isEqualToString:@"custom"])
        {
            NSString *str=[NSString stringWithFormat:@"%@",urlToDisplay];
            NSURL *url =[NSURL URLWithString:str];
            [self addLoadingView];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [customView loadRequest:requestObj];
        }
        else if([strPrev isEqualToString:@"page"])
        {
            NSString * str = [NSString stringWithFormat:@"%@",urlToDisplay];
            NSLog(@"arrResponse-----%@",str);
            [self addLoadingView];
            [customView loadHTMLString:str baseURL:nil];
        }
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //color change
    
    [topView setBackgroundColor:model.themeColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"CustomView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webview delegate


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog(@"start");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeLoadingView];
    
    NSLog(@"finish");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error for WEBVIEW: %@",[error description]);
    [self removeLoadingView];
}


#pragma mark Loaders

- (void)addLoadingView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    NSLog(@"addLoadingView");
    
}

- (void)removeLoadingView
{
    NSLog(@"removeLoadingView");
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
}


- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}

#pragma mark Home Button method

- (IBAction)homeButton:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    
}


@end
