//
//  ViewController.m
//  PaymentGateway
//
//  Created by Suraj on 22/07/15.
//  Copyright (c) 2015 Suraj. All rights reserved.
//

#import "PayUUIPaymentUIWebViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "WebViewJavascriptBridge.h"
#import "PayUWebViewResponse.h"
#import "ApiClasses.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "ModelClass.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UIWebView+transformWeb.h"

@interface PayUUIPaymentUIWebViewController () <UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
    ModelClass *model;
}

@property WebViewJavascriptBridge* PayU;
@property(strong, nonatomic) PayUWebViewResponse *webViewResponse;

//@property (nonatomic, weak) IBOutlet UIWebView *webviewPaymentPage;

@end

@implementation PayUUIPaymentUIWebViewController
@synthesize Furl,Surl,baseUrl;

//#define Merchant_Key @"UR26c4"
//#define Salt @"xvq9Gbm4"
//#define Base_URL @"https://test.payu.in"
//#define Base_URL @"https://secure.payu.in/"

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    //change color
    
    [_topView setBackgroundColor:model.themeColor];
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"PayUUIPaymentView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
   
    
    // implement bridge only if you wish to write JS at your server side for surl/furl
    
    _PayU = [WebViewJavascriptBridge bridgeForWebView:self.paymentWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback)
             
             {
                 NSLog(@"ObjC received message from JS: %@", data);
                 
                 if(data)
                 {
                     NSString *str = [NSString stringWithFormat:@"%@",data];
                     
                     NSString *base64EncodedString = [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
                     
                     ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
                     
                     str=[NSString stringWithFormat:@"%@urlToJsonEncode?salt=%@&data=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,base64EncodedString,model.storeID,model.currencyID];
                     
                     [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(getencodedString_Response:)];
                     
                     [self addLoadingView];
                 }
             }];
}

- (void)viewDidLoad
{
    
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [_paymentWebView TransformWebView];
    
    
    [super viewDidLoad];
    
    model=[ModelClass sharedManager];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView setColor:[UIColor blackColor]];
    [self.view addSubview:activityIndicatorView];
    
    [self initPayment];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPayment
{
    NSLog(@"tnx1 id '%@'",_txnid1);
    //    NSString *key = Merchant_Key;
    NSLog(@"Transaction id:-%@",_txnid1);
    NSString *serviceprovider = @"payu_paisa";
    //   NSString *amount = @"1400";
    NSString *amount = [_amount stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *hashValue = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|||||||||||%@",_key,_txnid1,amount,_productInfo,_firstname,_email,_Salt];
    
    NSString *hash = [self createSHA512:hashValue];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_txnid1,_key,amount,_productInfo,_firstname,_email,_phone,Surl,Furl,hash,serviceprovider,nil] forKeys:[NSArray arrayWithObjects:@"txnid",@"key",@"amount",@"productinfo",@"firstname",@"email",@"phone",@"surl",@"furl",@"hash",@"service_provider", nil]];
    __block NSString *post = @"";
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([post isEqualToString:@""])
         {
             post = [NSString stringWithFormat:@"%@=%@",key,obj];
         }
         else
         {
             post = [NSString stringWithFormat:@"%@&%@=%@",post,key,obj];
         }
     }];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/_payment",baseUrl]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    [_paymentWebView loadRequest:request];
    [activityIndicatorView startAnimating];
    
}

-(NSString *)createSHA512:(NSString *)input
{
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    
    CC_SHA512(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        
        [output appendFormat:@"%02x", digest[i]];
        
    }
    
    return output;
    
    // return @"YUNOGENERATEHASHFROMSERVER";
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"WebView started loading");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
    NSURL *requestURL = [[_paymentWebView request]URL];
    NSLog(@"WebView finished loading with requestURL: %@",requestURL);
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicatorView stopAnimating];
    NSURL *requestURL = [[_paymentWebView request] URL];
    NSLog(@"WebView failed loading with requestURL: %@ with error: %@",requestURL ,[error localizedDescription]);
    
}

- (IBAction)backBtn_Action:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)model.totalCount] forKey:@"quote_count"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tYourtransactionhasbeencancelled", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - delegate methods for surl/furl callback depricated one

-(void)PayUSuccessResponse:(id)response
{
    NSLog(@"%@",response);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"paymentResponse" object:[NSMutableData dataWithData:response ]];
}

-(void)PayUFailureResponse:(id)response
{
    NSLog(@"%@",response);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"paymentResponse" object:[NSMutableData dataWithData:response ]];
}

-(void)getencodedString_Response:(NSDictionary *)response
{
    [self removeLoadingView];
    NSLog(@"response------%@",response);
    NSString *str1;// = [NSString stringWithFormat:@"%@",response];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        str1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(                               NULL,(CFStringRef)str1,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",         kCFStringEncodingUTF8 ));
    ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
    
    NSString * str=[NSString stringWithFormat:@"%@processPayu?salt=%@&payu_response=%@&order_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,encodedString,_txnid1,model.storeID,model.currencyID];
    
    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(PayUPaymentResponse:)];
    
    [self addLoadingView];
    
}

-(void)PayUPaymentResponse:(NSDictionary *)response
{
    [self removeLoadingView];
    NSLog(@"response-------%@",response);
    
    if([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        [self.delegate methodCall1:[[response valueForKey:@"response"] valueForKey:@"order_id"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tYourtransactionhasbeencancelled", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark ---Alert View Delegate---

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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
