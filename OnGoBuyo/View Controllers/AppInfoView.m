//
//  AppInfoView.m
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 2/12/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "AppInfoView.h"
#import "ApiClasses.h"
#import "MBProgressHUD.h"
#import "ModelClass.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UIWebView+transformWeb.h"

@interface AppInfoView ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray * arrResponse;
    float newPosition1;
    float newPosition2;
    int k;
    int variable;
    int x1,y1;
    ModelClass *model;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation AppInfoView
@synthesize topView,scrollview;


- (void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [topView TransformationView];
    [_webview TransformWebView];
    
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:rightSwipeGesture];
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    rightSwipeGesture.numberOfTouchesRequired =1;
    leftSwipeGesture.numberOfTouchesRequired =1;
    
    [self.webview.scrollView.panGestureRecognizer requireGestureRecognizerToFail:rightSwipeGesture];
    [self.webview.scrollView.panGestureRecognizer requireGestureRecognizerToFail:leftSwipeGesture];
    variable = 0;
    
    model=[ModelClass sharedManager];
    
    [scrollview setBackgroundColor:model.buttonColor];
    [topView setBackgroundColor:model.themeColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"AppInfoView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self AppInfo];
        });
    });
}


-(void)handleSwipeGesture:(UISwipeGestureRecognizer *)leftSwipe
{
    x1=0;
    
    if (leftSwipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipeGesture Left");
        if(k<0)
        {
            
        }
        else
        {
            if(k+1 < arrResponse.count)
            {
                float width = self.scrollview.frame.size.width;
                float height = self.scrollview.frame.size.height;
                newPosition1 = self.scrollview.contentOffset.x+145;
                CGRect toVisible = CGRectMake(newPosition1, 0, width, height);
                [self.scrollview scrollRectToVisible:toVisible animated:YES];
                NSString * str = [NSString stringWithFormat:@"%@",[[arrResponse objectAtIndex:++k]valueForKey:@"content"]];
                [(UIImageView *)[self.view viewWithTag:k+100-1]setHidden:YES];
                [(UIImageView *)[self.view viewWithTag:k+100]setHidden:NO];
                NSLog(@"arrResponse-----%@",str);
                NSString *stringToLoad = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:25px;'>%@",str];
                
    //  stringToLoad =  [stringToLoad stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                [self.webview loadHTMLString:stringToLoad baseURL:nil];
            }
        }
    }
    else
    {
        if(k<1)
        {
            
        }
        else
        {
            NSLog(@"k value-----%d",k);
            [(UIImageView *)[self.view viewWithTag:100]setHidden:YES];
            float width = self.scrollview.frame.size.width;
            float height = self.scrollview.frame.size.height;
            newPosition1 = self.scrollview.contentOffset.x-162;
            CGRect toVisible = CGRectMake(newPosition1, 0, width, height);
            [self.scrollview scrollRectToVisible:toVisible animated:YES];
            NSString * str = [NSString stringWithFormat:@"%@",[[arrResponse objectAtIndex:--k]valueForKey:@"content"]];
            [(UIImageView *)[self.view viewWithTag:k+100+1]setHidden:YES];
            [(UIImageView *)[self.view viewWithTag:k+100]setHidden:NO];
            NSLog(@"arrResponse-----%@",str);
           // NSString *stringToLoad = [NSString stringWithFormat:@"<html><center><font size=+3>%@</font></center></html>", str];
            NSString *stringToLoad = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:25px;'>%@",str];
            
     //  stringToLoad =  [stringToLoad stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            [self.webview loadHTMLString:stringToLoad baseURL:nil];
        }
        NSLog(@"swipeGesture Right");
    }
}

#pragma mark - Search Category Api

-(void)AppInfo
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"%@",AMLocalizedString(@"tNoInternet", nil));
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        
        //   ------API Call------
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        NSString *str=[NSString stringWithFormat:@"%@getStaticpages?salt=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,model.storeID,model.currencyID];
        [obj_apiClass SearchCategory:str withTarget:self withSelector:@selector(Get_API_Response:)];
    }
}

#pragma mark Api Response

-(void)Get_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[[responseDict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)  otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        arrResponse = [responseDict valueForKey:@"response"];
        
        if(arrResponse.count>0)
        {    NSString * str;
            int x = 0;
            
            for (int i =0; i<[arrResponse count]; i++)
            {
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
                
                str  = [[arrResponse objectAtIndex:i]valueForKey:@"title"];
                
                NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:11]};
                
                CGSize fontSize = [str sizeWithAttributes:attr];
                
                CGRect currentFrame = btn.frame;
                
              //  CGRect buttonFrame = CGRectMake(x, currentFrame.origin.y, fontSize.width + 85.0, fontSize.height + 12.0);
                 CGRect buttonFrame = CGRectMake(x, currentFrame.origin.y, self.view.frame.size.width/2, fontSize.height + 20.0);
                
                [btn setFrame:buttonFrame];
                
                [btn setTitle:str forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = i;
                [btn TransformButton];
                [btn addTarget:self action:@selector(urlAction:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView * img=[[UIImageView alloc]init];
                if (str.length >25)
                {
                     [img setFrame:CGRectMake(x,35,(self.view.frame.size.width/2),5)];
                   // [img setFrame:CGRectMake(x+6,35,(self.view.frame.size.width/2)-13,5)];
                    
                     //  [img setFrame:CGRectMake(x+6,32,fontSize.width+72,5)];
                }
                else
                {
                    [img setFrame:CGRectMake(x,35,(self.view.frame.size.width/2),5)];
                    //[img setFrame:CGRectMake(x+12,35,(self.view.frame.size.width/2)-30,5)];
                      // [img setFrame:CGRectMake(x+12,32,fontSize.width+55,5)];
                }
                img.backgroundColor = [UIColor whiteColor];
                img.tag = i+100;
                [img TransformImage];
                [img setHidden:YES];
                x = x + (self.view.frame.size.width/2);
              //  x = x + (self.view.frame.size.width/2)-10;
                  // x = x + fontSize.width + 70.0;
                [self.scrollview addSubview:img];
                [self.scrollview addSubview:btn];
                
            }
            self.scrollview.contentSize = CGSizeMake(arrResponse.count*168, 40);
        
        [self.scrollview setShowsHorizontalScrollIndicator:NO];
        [self.scrollview setShowsVerticalScrollIndicator:NO];
        
        [(UIImageView *)[self.view viewWithTag:100]setHidden:NO];
        
        NSString * str1 = [NSString stringWithFormat:@"%@",[[arrResponse objectAtIndex:0]valueForKey:@"content"]];
        
        NSLog(@"arrResponse-----%@",str1);
            NSString *stringToLoad = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:25px;'>%@",str1];
            
         // stringToLoad =  [stringToLoad stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            [self.webview loadHTMLString:stringToLoad baseURL:nil];
        }
        else
        {
            
        }
    }
}

-(void)urlAction:(UIButton *)sender
{
    NSLog(@"sender Tag----%ld",(long)sender.tag);
    
    k = (int)[sender tag];
    
    y1 = (int)[sender tag];
    
    if([sender tag] == y1)
    {
        if(y1>=x1)
        {
            [(UIImageView *)[self.view viewWithTag:[sender tag]+100-1]setHidden:YES];
            [(UIImageView *)[self.view viewWithTag:[sender tag]+100]setHidden:NO];
            float width = self.scrollview.frame.size.width;
            float height = self.scrollview.frame.size.height;
            float newPosition;
            if(sender.titleLabel.text.length>20)
            {
                if(x1==0 && [sender tag] == 2)
                {
                    [(UIImageView *)[self.view viewWithTag:103]setHidden:YES];
                    newPosition = self.scrollview.contentOffset.x+250;
                }
                else
                {
                    newPosition = self.scrollview.contentOffset.x+145;
                }
            }
            else
            {
                newPosition = self.scrollview.contentOffset.x+145;
            }
            
            CGRect toVisible = CGRectMake(newPosition, 0, width, height);
           /// [self.scrollview scrollRectToVisible:toVisible animated:YES];
        }
        else
        {
            [(UIImageView *)[self.view viewWithTag:100]setHidden:YES];
            [(UIImageView *)[self.view viewWithTag:[sender tag]+100+1]setHidden:YES];
            [(UIImageView *)[self.view viewWithTag:[sender tag]+101-1]setHidden:NO];
            float width = self.scrollview.frame.size.width;
            float height = self.scrollview.frame.size.height;
            float newPosition;
            if(sender.titleLabel.text.length>20)
            {
                if(x1==3 && [sender tag] == 2)
                {
                    [(UIImageView *)[self.view viewWithTag:103]setHidden:YES];
                    newPosition = self.scrollview.contentOffset.x-162;
                }
                else
                {
                    newPosition = self.scrollview.contentOffset.x-162;
                }
            }
            else
            {
                newPosition = self.scrollview.contentOffset.x-162;
            }
            
            NSLog(@"scrollview.contentOffset: %f",self.scrollview.contentOffset.x);
            
            CGRect toVisible = CGRectMake(newPosition, 0, width, height);
            //[self.scrollview scrollRectToVisible:toVisible animated:YES];
        }
        x1 = y1;
    }
    NSString * str = [NSString stringWithFormat:@"%@",[[arrResponse objectAtIndex:[sender tag]]valueForKey:@"content"]];
    NSLog(@"arrResponse-----%@",str);
    NSString *stringToLoad = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:25px;'>%@",str];
    
   // stringToLoad =  [stringToLoad stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    [self.webview loadHTMLString:stringToLoad baseURL:nil];
}

#pragma mark - Webview delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //    [self addLoadingView];
    NSLog(@"start");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [self removeLoadingView];
    NSLog(@"finish");
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error for WEBVIEW: %@",[error description]);
    [self removeLoadingView];
}

#pragma mark - Loaders

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

- (IBAction)backBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
