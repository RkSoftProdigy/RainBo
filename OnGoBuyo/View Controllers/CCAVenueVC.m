//
//  CCAVenueVC.m
//  Ongobuyo
//
//  Created by Rakesh on 7/31/17.
//  Copyright © 2017 navjot_sharma. All rights reserved.
//

#import "CCAVenueVC.h"

@interface CCAVenueVC ()

@end

@implementation CCAVenueVC

@synthesize rsaKeyUrl;@synthesize accessCode;@synthesize merchantId;@synthesize orderId;
@synthesize amount;@synthesize currency;@synthesize redirectUrl;@synthesize cancelUrl;

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
    
    self.viewWeb.delegate = self;
     model=[ModelClass sharedManager];
    [_topView TransformationView];
    [_topView setBackgroundColor:model.themeColor];
    model.totalCount = 0;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)model.totalCount] forKey:@"quote_count"];
   [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
    
    
//    //Getting RSA Key
//    NSString *rsaKeyDataStr = [NSString stringWithFormat:@"access_code=%@&order_id=%@",accessCode,orderId];
//    NSData *requestData = [NSData dataWithBytes: [rsaKeyDataStr UTF8String] length: [rsaKeyDataStr length]];
//    NSMutableURLRequest *rsaRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: rsaKeyUrl]];
//    [rsaRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
//    [rsaRequest setHTTPMethod: @"POST"];
//    [rsaRequest setHTTPBody: requestData];
//    NSData *rsaKeyData = [NSURLConnection sendSynchronousRequest: rsaRequest returningResponse: nil error: nil];
//    NSString *rsaKey = [[NSString alloc] initWithData:rsaKeyData encoding:NSASCIIStringEncoding];
//    rsaKey = [rsaKey stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    rsaKey = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----\n",rsaKey];
//    NSLog(@"%@",rsaKey);
    
    //Encrypting Card Details
//    NSString *myRequestString = [NSString stringWithFormat:@"amount=%@&currency=%@",amount,currency];
//    CCTool *ccTool = [[CCTool alloc] init];
//    NSString *encVal = [ccTool encryptRSA:myRequestString key:_rsaKey];
//    encVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                                   (CFStringRef)encVal,
//                                                                                   NULL,
//                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                                   kCFStringEncodingUTF8 ));
    
    [self GetEncrptDataStr];
    
    //Preparing for a webview call
   // https://test.ccavenue.com
   
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
        [self removeLoadingView];
        [self addLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
     [self removeLoadingView];
    NSString *string = webView.request.URL.absoluteString;
     NSString *html1 = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    NSLog(@"%@",html1);
    
    if([string containsString:@"http://rainbo.in/index.php/checkout/cart/"])
    {
        // [self coverMethod];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Your payment process has been cancelled!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[ViewController class]])
                {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    else if([string containsString:@"https://rainbo.in/index.php/checkout/onepage/success"])
    {
        [self coverMethod];
   
     }
    else
    {
        if ([string rangeOfString:@"/ccavResponseHandler.jsp"].location != NSNotFound) {
            NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
            
            NSString *transStatus = @"Not Known";
            
            if (([html rangeOfString:@"Aborted"].location != NSNotFound) ||
                ([html rangeOfString:@"Cancel"].location != NSNotFound)) {
                transStatus = @"Transaction Cancelled";
            }else if (([html rangeOfString:@"Success"].location != NSNotFound)) {
                transStatus = @"Transaction Successful";
            }else if (([html rangeOfString:@"Fail"].location != NSNotFound)) {
                transStatus = @"Transaction Failed";
            }
            
            // CCResultViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CCResultViewController"];
            //   controller.transStatus = transStatus;
            
            //   controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            // [self presentViewController:controller animated:YES completion:nil];
        }
    
    
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
{
     NSString *string1 = webView.request.URL.absoluteString;
    NSString *string2 = request.URL.absoluteString;
    NSLog(@"1111111%@",string1);
    NSLog(@"2222222%@",string2);
    
    return true;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(void)GetEncrptDataStr
{

    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
      ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
       // getCcAvenueDetails/?order_id=100000009&salt=e4192b13e858a0714efc208ef6c238f8
       NSString * str=[NSString stringWithFormat:@"%@getCcAvenueDetails?salt=%@&order_id=%@",baseURL1,model.salt,orderId];
        
      //  m_callBackSelector=tempSelector;
      //  m_callBackTarget=tempTarget;
        
        NSURL *strConnection =[[NSURL alloc]init];
        strConnection=[NSURL URLWithString:str];
        
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:strConnection cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        
        strConnection = nil;
        
        [theRequest setHTTPMethod:@"POST"];
        
        NSLog(@"request made --%@",theRequest);
        
      //  if(strConnection)
       // {
            strConnection = nil;
       // }
       // strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
        
          [_viewWeb loadRequest:theRequest];
        
      //  [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(GetEncrptResponse:)];
    }
    
}
-(void)GetEncrptResponse:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    NSString *encVal = [[responseDict valueForKey:@"response"] valueForKey:@"encRequest"];
    if ([[responseDict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
    {
      // NSString *urlAsString = [NSString stringWithFormat:@"https://secure.ccavenue.com/transaction/initTrans"];
        NSString *urlAsString = [NSString stringWithFormat:@"https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction"];
       // NSString *encryptedStr = [NSString stringWithFormat:@"merchant_id=%@&order_id=%@&redirect_url=%@&cancel_url=%@&enc_val=%@&access_code=%@",merchantId,orderId,redirectUrl,cancelUrl,encVal,accessCode];
     //   NSString *encryptedStr = [NSString stringWithFormat:@"encRequest=%@&access_code=%@",@"9264532da22c5697e3fc304dd68bf6cd28bb45ef53ad10b471eb3e8f3a360e96850d74db4b05e04d58151388d7b11f467e4ecbd1c4e6dc53580234640df63f55796903219a37ed2613eacd23e37287f422da948bac0428597427b0bab1cbacdf7fd5a81586c88a9b08b2458968e01f27cdfddda189dff910464fbd96fdfc3047f2e7540f025c9f164a9ee8a9f03b90a4081f06caa9210225042bbfdead5395b966fc7501b2f4ba25d4cf82b6233ea5943c248d52b2f81724948bf5e34849c97550f45c34eff54c7ba8ddd714342807ec98e20492411a53d980e4c480acece8a5a8bcfeda4ece99f0fc59f6e1aab2dbc1eec2a4605c714a8cc60439f50937a25927199eebc765a047ec9b8b787ff961aefa4e3e0eb4169a20d90dc4428374a51c2c32efda57d9efbfc6f03eb62e9f57cd3b211d69ea44a37e24c66effb5ad2d9616fe24d29ef8d38314fcfd85cc08d953c34741a8df9dda818996ad177bedd87968c8975652815411dfa5bf77a82082798a932112a9177526a9ca7d7809e6ccc105cebc2dc59a18cb9c21fb5ebf56f136cf80f9b60bf327a1fe1217f5244a80bfd2f8fe81c0e4d6e9b4dc7d1498677a7ac5c5a8edea890d1f6260ef19b9438f17fe9027252b1502bdbb647825efb1d7ce9e749026e408abbda1ea5f6cf6ed644eceddeb24104e765941526f0590266ecd61305cc44af83192534cc41ed6d14084c4cd4c0625ab388c584be30512379b3603416472573f219d76e39f694ddc253ebf91600c8fa118a108b8595db9648fa6614b3349ed92602fc6051ad1e858c1d162ab7c1ba7a1ec0be5732d463026ae55f9475486634c8e87420f4e11fda3458b6834ad2d617896fc5039167ce0858f60d2b3a94fbb75f792605bde51d17739ae286bb5e2e258935083b2009f9b3f3a79",@"AVJK71EG85AW93KJWA"];
        
         NSString *encryptedStr = [NSString stringWithFormat:@"encRequest=%@&access_code=%@",encVal,accessCode];
        
        NSData *myRequestData = [NSData dataWithBytes: [encryptedStr UTF8String] length: [encryptedStr length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlAsString]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setValue:urlAsString forHTTPHeaderField:@"Referer"];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: myRequestData];
        [_viewWeb loadRequest:request];
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
#pragma mark - Back Button Action

- (IBAction)backBtn_Action:(id)sender
{
//    model.totalCount = 0;
//    
//    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)model.totalCount] forKey:@"quote_count"];
//    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}
#pragma mark Home Button method

- (IBAction)homeButton:(id)sender
{
//    model.totalCount = 0;
//    
//    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)model.totalCount] forKey:@"quote_count"];
//    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}
#pragma mark - continue Button Action

- (IBAction)continueBtn_Action:(id)sender
{
    
    //  rate app functionality
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberofTimePurchase=[defaults integerForKey:@"numberofTimePurchase"];
    
    
    if ([defaults boolForKey:@"FirstPurchase"]==NO)
    {
        numberofTimePurchase = 1;
        [defaults setBool:YES forKey:@"purchased"];
        [defaults setInteger:numberofTimePurchase forKey:@"numberofTimePurchase"];
        
        [defaults setBool:YES forKey:@"FirstPurchase"];
    }
    
    else if (numberofTimePurchase < 5)
    {
        numberofTimePurchase = numberofTimePurchase + 1;
        [defaults setInteger:numberofTimePurchase forKey:@"numberofTimePurchase"];
        
        if (numberofTimePurchase == 5)
        {
            numberofTimePurchase = 0;
            [defaults setBool:YES forKey:@"purchased"];
        }
    }
    
    [self.coverView removeFromSuperview];
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

-(void)coverMethod {
    self.coverView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    
    self.lblOrderID.text = orderId;
    
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [self.view addSubview:self.coverView];
    
    model.totalCount = 0;
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)model.totalCount] forKey:@"quote_count"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
    
    [self.view bringSubviewToFront:self.coverView];
}



@end
