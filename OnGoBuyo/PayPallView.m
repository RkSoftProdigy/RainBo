//
//  PayPallView.m
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 3/16/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "PayPallView.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "ModelClass.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UIWebView+transformWeb.h"


@interface PayPallView ()
{
    NSString * userName;
    NSString * password;
    NSString * signature;
    int  sandbox;
    NSString * currencyCode;
    NSArray *arr;
    
    NSString * str22;
    ModelClass  * model;
    int u;
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation PayPallView

- (void)viewDidLoad
{
    u=0;
    [self addLoadingView];
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [_webview TransformWebView];
    
    
    [super viewDidLoad];
    model=[ModelClass sharedManager];
    
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            // Perform long running process
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                [self apiCall];
            });
        });
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_topView setBackgroundColor:model.themeColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"PayPallView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)apiCall
{
    
    NSURLRequest               *request;
    NSData                     *data;
    NSDictionary               *json;
    NSURLResponse              *respone;
    NSError                    *error;
    
    NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@getMethods?salt=%@&quote_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str1,model.storeID,model.currencyID];
    
    request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    data=[NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:&error];
    if(data)
    {
        json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if(json.count!=0)
        {
            
            [self removeLoadingView];
            NSLog(@"json value------%@",[json valueForKey:@"paypal_info"]);
            
            userName = [[json valueForKey:@"paypal_info"]valueForKey:@"username"];
            
            [[NSUserDefaults standardUserDefaults]setValue:userName forKey:@"userName"];
            
            password = [[json valueForKey:@"paypal_info"]valueForKey:@"password"];
            
            [[NSUserDefaults standardUserDefaults]setValue:password forKey:@"password"];
            
            signature = [[json valueForKey:@"paypal_info"]valueForKey:@"signature"];
            
            [[NSUserDefaults standardUserDefaults]setValue:signature forKey:@"signature"];
            
            currencyCode = [[json valueForKey:@"paypal_info"]valueForKey:@"currency_code"];
            
            sandbox = [[[json valueForKey:@"paypal_info"]valueForKey:@"sandbox"] intValue];
        }
    }
    
    NSString * total = [[NSUserDefaults standardUserDefaults]valueForKey:@"Subtotal"];
    
    NSString * str33 = [[total stringByReplacingOccurrencesOfString:model.currencySymbo withString:@""]stringByReplacingOccurrencesOfString:@"," withString:@"" ];
    
    NSDecimalNumber *amount1 =
    [NSDecimalNumber decimalNumberWithString:str33];
    NSString *str;
    if (sandbox == 0)
    {
     str=[NSString stringWithFormat:@"https://api-3t.paypal.com/nvp?USER=%@&PWD=%@&SIGNATURE=%@&METHOD=%@&VERSION=%@&PAYMENTREQUEST_0_PAYMENTACTION=%@&PAYMENTREQUEST_0_AMT=%@&PAYMENTREQUEST_0_CURRENCYCODE=%@&RETURNURL=%@&CANCELURL=%@",userName,password,signature,@"SetExpressCheckout",@"93",@"SALE",amount1,currencyCode,@"http://www.example.com/success.html",@"http://www.example.com/cancel.html"];
    }
    else
    {
    str=[NSString stringWithFormat:@"https://api-3t.sandbox.paypal.com/nvp?USER=%@&PWD=%@&SIGNATURE=%@&METHOD=%@&VERSION=%@&PAYMENTREQUEST_0_PAYMENTACTION=%@&PAYMENTREQUEST_0_AMT=%@&PAYMENTREQUEST_0_CURRENCYCODE=%@&RETURNURL=%@&CANCELURL=%@",userName,password,signature,@"SetExpressCheckout",@"93",@"SALE",amount1,currencyCode,@"http://www.example.com/success.html",@"http://www.example.com/cancel.html"];
    }
    
    NSURLRequest *request1;
    NSData         *data1;
    NSURLResponse  *respone1;
    NSError        *error1;
    
    request1=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:str] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    data1=[NSURLConnection sendSynchronousRequest:request1 returningResponse:&respone1 error:&error1];
    if(data1)
    {
        NSString *feedStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        arr = [feedStr componentsSeparatedByString:@"&"];
        NSLog(@"arr------%@",arr);
        NSLog(@"data------%@",[arr objectAtIndex:0]);
        
    }
    //&useraction=commit
    NSString * pay = [arr objectAtIndex:0];
    str22 = [pay stringByReplacingOccurrencesOfString:@"TOKEN=" withString:@""];
    
    
    NSString *decoded1 = [str22 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[NSUserDefaults standardUserDefaults]setValue:decoded1 forKey:@"TOKEN"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *str2;
    
    if (sandbox==0)
    {
        str2=[NSString stringWithFormat:@"https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=%@&useraction=commit",str22];
    }
    else
    {
    str2=[NSString stringWithFormat:@"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=%@&useraction=commit",str22];
    }
    NSString *decoded = [str2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest   *request2;
    NSData         *data2;
    NSURLResponse  *respone2;
    NSError        *error2;
    
    request2=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:decoded] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
    
    data2=[NSURLConnection sendSynchronousRequest:request2 returningResponse:&respone2 error:&error2];
    
    if(data2)
    {
        NSString *feedStr2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        
        NSLog(@"feedStr2---i---%@",feedStr2);
    }
    
    NSURL *url = [NSURL URLWithString:decoded];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //load the URL into the web view.
    [self.webview loadRequest:requestObj];
}

#pragma mark - Did recieve Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Webview delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start");
    if (u!=0)
    {
        [self addLoadingView];
    }
    else
    {
        u=1;
        [self removeLoadingView];
        [self addLoadingView];
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeLoadingView];
    NSLog(@"finish");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeLoadingView];
    NSLog(@"Error for WEBVIEW: %@",[error description]);
    
}


#pragma mark - Back Button Action

- (IBAction)backBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    // NSURL *URL = [request URL];
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlParts = [urlString componentsSeparatedByString:@"?"];
    NSString *methodName1 = [urlParts objectAtIndex:0];
    
    if ([methodName1 isEqualToString:@"http://www.example.com/success.html"])
    {
        NSArray *urlParts1 = [urlString componentsSeparatedByString:@"&"];
        NSString *methodName2 = [urlParts1 objectAtIndex:1];
        NSLog(@"urlString--------%@",methodName2);
        
        NSString * str = [methodName2 stringByReplacingOccurrencesOfString:@"PayerID=" withString:@""];
        [[NSUserDefaults standardUserDefaults]setValue:str forKey:@"PayerID"];
        
        NSLog(@"urlString--------%@",str);
        
        [self performSelector:@selector(GetExpressCheckoutDetails) withObject:nil afterDelay:0.01];
        return NO;
    }
    return YES;
}

-(void)GetExpressCheckoutDetails
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        NSArray *  arr1;
        NSURLRequest   *request2;
        NSData         *data2;
        NSURLResponse  *respone2;
        NSError        *error2;
        NSString *str2;
        if (sandbox==0)
        {
         str2=[NSString stringWithFormat:@"https://api-3t.paypal.com/nvp?USER=%@&PWD=%@&SIGNATURE=%@&METHOD=%@&VERSION=%@&TOKEN=%@&PAYERID=%@&PAYMENTREQUEST_0_PAYMENTACTION=%@&PAYMENTREQUEST_0_AMT=%@&PAYMENTREQUEST_0_CURRENCYCODE=%@",userName,password,signature,@"DoExpressCheckoutPayment",@"93",[[NSUserDefaults standardUserDefaults]valueForKey:@"TOKEN"],[[NSUserDefaults standardUserDefaults]valueForKey:@"PayerID"],@"SALE",@"5",currencyCode];
        }
        else
        {
           str2=[NSString stringWithFormat:@"https://api-3t.sandbox.paypal.com/nvp?USER=%@&PWD=%@&SIGNATURE=%@&METHOD=%@&VERSION=%@&TOKEN=%@&PAYERID=%@&PAYMENTREQUEST_0_PAYMENTACTION=%@&PAYMENTREQUEST_0_AMT=%@&PAYMENTREQUEST_0_CURRENCYCODE=%@",userName,password,signature,@"DoExpressCheckoutPayment",@"93",[[NSUserDefaults standardUserDefaults]valueForKey:@"TOKEN"],[[NSUserDefaults standardUserDefaults]valueForKey:@"PayerID"],@"SALE",@"5",currencyCode];
        }
        
        
        NSString *decoded = [str2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        request2=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:decoded] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
        
        data2=[NSURLConnection sendSynchronousRequest:request2 returningResponse:&respone2 error:&error2];
        
        if(data2)
        {
            NSString *feedStr2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
            
            NSString *decoded = [feedStr2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            arr1 = [decoded componentsSeparatedByString:@"&"];
            
            NSLog(@"feedStr2------%@",arr1);
            
        }
        
        NSString * str1 = [[arr1 objectAtIndex:3] stringByReplacingOccurrencesOfString:@"CORRELATIONID=" withString:@""];
        
        NSString * str3 = [[arr1 objectAtIndex:17] stringByReplacingOccurrencesOfString:@"PAYMENTINFO_0_PAYMENTSTATUS=" withString:@""];
        
        
        NSString * str4 = [[arr1 objectAtIndex:9] stringByReplacingOccurrencesOfString:@"PAYMENTINFO_0_TRANSACTIONID=" withString:@""];
        
        
        NSString * str5 = [[arr1 objectAtIndex:20] stringByReplacingOccurrencesOfString:@"PAYMENTINFO_0_PROTECTIONELIGIBILITY=" withString:@""];
        
        NSString * str6 = [[arr1 objectAtIndex:18] stringByReplacingOccurrencesOfString:@"PAYMENTINFO_0_PENDINGREASON=" withString:@""];
        
        
        NSLog(@"str-----%@",str1);
        
        
        ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
        
        NSString * quote_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        
        
        NSString* str;
        //paypal_express
        
        NSString * email;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES)
        {
            email = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
        }
        else
        {
            email = [[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
        }
        
        NSString * total = [[NSUserDefaults standardUserDefaults]valueForKey:@"Subtotal"];
        
        NSString * str33 = [total stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        NSDecimalNumber *amount1 = [NSDecimalNumber decimalNumberWithString:str33];
        
        
        NSString * device_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"];
        
        if(quote_id.length!=0)
        {
            NSString *str9=[NSString stringWithFormat:@"%@",model.custId];
            if ([str9 isEqualToString:@"(null)"])
            {
                str9=@"";
            }
            if(device_id.length!=0)
            {
                str=[NSString stringWithFormat:@"%@placeOrder?salt=%@&quote_id=%@&device_type=%@&device_id=%@&pay_method=%@&cust_id=%@&email=%@&paypal_payer_id=%@&paypal_express_checkout_token=%@&paypal_correlation_id=%@&paypal_payment_status=%@&paypal_transactionId=%@&paypal_protection_eligibility=%@&paypal_pending_reason=%@&token=%@&paypal_address_status=Confirmed&paypal_payer_status=verified&paypal_txn_amt=%@paypal_payer_email=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,quote_id,@"Iphone",device_id,@"paypal_express",str9,email,[[NSUserDefaults standardUserDefaults]valueForKey:@"PayerID"],[[NSUserDefaults standardUserDefaults]valueForKey:@"TOKEN"],str1,str3,str4,str5,str6,str22,amount1,@"",model.storeID,model.currencyID];
            }
            else
            {
                
                str=[NSString stringWithFormat:@"%@placeOrder?salt=%@&quote_id=%@&device_type=%@&device_id=%@&pay_method=%@&cust_id=%@&email=%@&paypal_payer_id=%@&paypal_express_checkout_token=%@&paypal_correlation_id=%@&paypal_payment_status=%@&paypal_transactionId=%@&paypal_protection_eligibility=%@&paypal_pending_reason=%@&token=%@&paypal_address_status=Confirmed&paypal_payer_status=verified&paypal_txn_amt=%@&paypal_payer_email=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,quote_id,@"Iphone",@"3f3e9c4864f073e974a65dd97b1879c647d81e1976f2f270083274e80a4dae3c",@"paypal_express",str9,email,[[NSUserDefaults standardUserDefaults]valueForKey:@"PayerID"],[[NSUserDefaults standardUserDefaults]valueForKey:@"TOKEN"],str1,str3,str4,str5,str6,str22,amount1,@"",model.storeID,model.currencyID];
                
            }
            
        }
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Payment_Response:)];
    }
}

//feedStr2------(
//               "TOKEN=EC-84T46650T9144031F",
//               "SUCCESSPAGEREDIRECTREQUESTED=false",
//               "TIMESTAMP=2016-03-16T09:11:53Z",
//               "CORRELATIONID=da1130bfd12f3",
//               "ACK=Success",
//               "VERSION=93",
//               "BUILD=18316154",
//               "INSURANCEOPTIONSELECTED=false",
//               "SHIPPINGOPTIONISDEFAULT=false",
//               "PAYMENTINFO_0_TRANSACTIONID=95M25205K23525607",
//               "PAYMENTINFO_0_TRANSACTIONTYPE=expresscheckout",
//               "PAYMENTINFO_0_PAYMENTTYPE=instant",
//               "PAYMENTINFO_0_ORDERTIME=2016-03-16T09:11:52Z",
//               "PAYMENTINFO_0_AMT=5.00",
//               "PAYMENTINFO_0_FEEAMT=0.45",
//               "PAYMENTINFO_0_TAXAMT=0.00",
//               "PAYMENTINFO_0_CURRENCYCODE=USD",
//               "PAYMENTINFO_0_PAYMENTSTATUS=Completed",
//               "PAYMENTINFO_0_PENDINGREASON=None",
//               "PAYMENTINFO_0_REASONCODE=None",
//               "PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible",
//               "PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible,UnauthorizedPaymentEligible",
//               "PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=4FR9AW7T5PHYW",
//               "PAYMENTINFO_0_ERRORCODE=0",
//               "PAYMENTINFO_0_ACK=Success"
//               )



-(void)Get_Payment_Response:(NSDictionary *)response
{
    if([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        [self.delegate methodCall:[response valueForKey:@"response"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tOopsSomethingwentwrong", nil) message:nil delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
        
    }
    NSLog(@"response-------%@",response);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
