//
//  AppDelegate.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/8/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "OrderSummaryView.h"
#import "MyOrdersViewController.h"
#import "ModelClass.h"
#import "HelpViewController.h"
#import "CustomView.h"
#import "ProductDetailsViewController.h"
#import "ViewMoreViewController.h"
#import "NotificationCenter.h"
#import "ApiClasses.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "UIColor+fromHex.h"
#import "LocalizationSystem.h"

@interface AppDelegate ()
{
    ModelClass *model;
    NSDictionary *pushmsg ;
    NSDictionary *pushmsg1;
    NSDictionary *userInfo;
}
@end

@implementation AppDelegate
@synthesize nav,arrOptions;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[IQKeyboardManager sharedManager] setEnable:false];
   
    application.applicationIconBadgeNumber = 0;
    
      self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstEnter"]==NO)
    {
        
        HelpViewController * obj1 = [[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil];
        self.nav = [[UINavigationController alloc]initWithRootViewController:obj1];
    }
    else
    {
        
        ViewController  * obj1 = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
        self.nav = [[UINavigationController alloc]initWithRootViewController:obj1];
    }
    self.window.rootViewController = self.nav;
    
        [self.nav.navigationBar setHidden:YES];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // status bar style
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    // initialization
    
    arrOptions=[[NSMutableArray alloc]init];
    model=[ModelClass sharedManager];
    model.pkgType=[[NSUserDefaults standardUserDefaults]valueForKey:@"package"];
    model.salt=@"e4192b13e858a0714efc208ef6c238f8";
    model.storeID=[[NSUserDefaults standardUserDefaults]valueForKey:@"storeID"];
    NSString *strStore=[NSString stringWithFormat:@"%@",model.storeID];
    if ([strStore isEqualToString:@"(null)"])
    {
        model.storeID=@"";
    }
strStore=[NSString stringWithFormat:@"%@",model.currencyID];
    if ([strStore isEqualToString:@"(null)"])
    {
        model.currencyID=@"";
    }
    
    model.themeColor=topBarColor;
    model.buttonColor=ButtonColor;
    model.saffronClr = saffronColor;
    model.greenClr = GreenColor;
     model.blueClr = BlueColor;

    model.priceColor=PriceColor;
    model.secondaryColor=[UIColor colorWithRed:234.0/255.0 green:103.0/255.0 blue:74.0/255.0 alpha:1.0];
    
    
    NSString *str=[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"];
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    NSArray *arrAdd;

    if(([pT intValue]==101) || ([pT intValue]==1011))
    {
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil), AMLocalizedString(@"tAppInfo",nil),AMLocalizedString(@"tLanguage",nil),AMLocalizedString(@"tLogout", nil), nil];    }
    else
    {
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile",nil),AMLocalizedString(@"tMyOrders",nil),AMLocalizedString(@"tMyWishList",nil),AMLocalizedString(@"tMyDownloadables",nil),AMLocalizedString(@"tAppInfo",nil),AMLocalizedString(@"tNotifications",nil),AMLocalizedString(@"tLanguage",nil),AMLocalizedString(@"tLogout",nil), nil];
    }
    NSArray *arrAdd2=[NSArray arrayWithObjects:AMLocalizedString(@"tLogin",nil),AMLocalizedString(@"tAppInfo",nil),AMLocalizedString(@"tLanguage",nil), nil];
    
[self performSelectorOnMainThread:@selector(getColor) withObject:self waitUntilDone:YES];
    
//    baseURLsendNotify
    
    // to remove pop gesture from navigation bar
    
    if ([self.nav respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.nav.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (str.length!=0)
    {
        [arrOptions addObjectsFromArray:arrAdd];
    }
    else
    {
        [arrOptions addObjectsFromArray:arrAdd2];
    }
    
      [self sendPushRequest];
    
       // Override point for customization after application launch.
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)getColor
{
    NSString *str1=[NSString stringWithFormat:@"%@getColorScheme?salt=%@&cstore=%@&ccurrency=%@",baseURL1,@"e4192b13e858a0714efc208ef6c238f8",model.storeID,model.currencyID];
//     68c578debdcdbec8d13076c450d06922
    //----------------API----------------------
    
    ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
    [obj_apiClass ViewMore:[str1 stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_resetBadgeCount1_API_Response:)];
}


-(void)sendPushRequest
{
    // registering for push notifications
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // For iOS 8
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    else
    {
        // For iOS < 8
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    //}
}

#pragma mark -
#pragma mark Push Notification Delegate Methods

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    //  const void *devTokenBytes = [devToken bytes];
    
    NSString *str=[[[[devToken description]
                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"DEVICE token= %@",str);
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",str] forKey:@"devicet"];
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo1
{
  
    userInfo=userInfo1;
    NSLog(@"%@",userInfo);

    if([userInfo count]>0)
    {
        if ([userInfo isKindOfClass:[NSDictionary class]])
        {
           pushmsg =[userInfo objectForKey:@"aps"];
           pushmsg1 =[userInfo objectForKey:@"acme2"];
               if([[pushmsg1 valueForKey:@"item_type"]isEqualToString:@"page"])
                {
                    if (application.applicationState==UIApplicationStateActive)
                    {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tNotification",nil) message:[pushmsg valueForKey:@"alert"] delegate:self cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
                    alert.tag=73;
                    [alert show];
                    }
                    else
                    {
                        NotificationCenter * obj = [[NotificationCenter alloc]initWithNibName:@"NotificationCenter" bundle:nil];
                        [nav pushViewController:obj animated:YES];
                        obj=nil;
                    }
                    
                }
                else if([[pushmsg1 valueForKey:@"item_type"]isEqualToString:@"custom"])
                {
                    if (application.applicationState==UIApplicationStateActive)
                    {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tNotification",nil) message:[pushmsg valueForKey:@"alert"] delegate:self cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
                    alert.tag=74;
                    [alert show];
                    }
                    else
                    {
                        CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
                        objViewController.urlToDisplay=[pushmsg1 valueForKey:@"item_value"];
                        objViewController.strPrev=@"custom";
                        [nav pushViewController:objViewController animated:YES];
                        objViewController = nil;
                    }
                  }
                else if([[pushmsg1 valueForKey:@"item_type"]isEqualToString:@"category"])
                {
                    if (application.applicationState==UIApplicationStateActive)
                    {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tNotification",nil) message:[pushmsg valueForKey:@"alert"] delegate:self cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
                    alert.tag=75;
                    [alert show];
                    }
                    else
                    {
                    ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
                    objViewController.strName=@"Products";
                    objViewController.categoryID=[pushmsg1 valueForKey:@"item_value"];
                     objViewController.apiType = @"SearchApi";
                    [nav pushViewController:objViewController animated:YES];
                    objViewController = nil;
                }}
                else if([[pushmsg1 valueForKey:@"item_type"]isEqualToString:@"product"])
                {
                    if (application.applicationState==UIApplicationStateActive)
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tNotification",nil) message:[pushmsg valueForKey:@"alert"] delegate:self cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
                        alert.tag=76;
                        [alert show];
                    }
                    else
                    {
                    ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
                    NSString *str=[NSString stringWithFormat:@"%@",[pushmsg1 valueForKey:@"item_value"]];
                                        
                    objViewController.strProdId=str;
                    [nav pushViewController:objViewController animated:YES];
                    
                    objViewController = nil;
                    }
                }
            else
            {
                if(([[NSUserDefaults standardUserDefaults]boolForKey:@"cancelOrder"]==YES) && (application.applicationState==UIApplicationStateActive))
                {
                   [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"cancelOrder"];
                    MyOrdersViewController *obj=[[MyOrdersViewController alloc]initWithNibName:@"MyOrdersViewController" bundle:nil];
                     [nav pushViewController:obj animated:YES];
                }
                else
                {
                    if (application.applicationState==UIApplicationStateActive)
                    {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tNotification",nil) message:[pushmsg valueForKey:@"alert"] delegate:self cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
                    alert.tag=72;
                    [alert show];
                    }
                    else
                    {
                        if (![[[userInfo valueForKey:@"acme2"]valueForKey:@"order-id"]isEqualToString:@""])
                        {
                            OrderSummaryView *obj=[[OrderSummaryView alloc]initWithNibName:@"OrderSummaryView" bundle:nil];
                            obj.orderID=[[userInfo valueForKey:@"acme2"]valueForKey:@"order-id"];
                            [nav pushViewController:obj animated:YES];
                        }
                    
                    }
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag==72)
    {
        NSString *str=[NSString stringWithFormat:@"%@resetBadgeCount?salt=%@&deviceId=%@&badge=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],@"0",model.storeID,model.currencyID];
     
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_resetBadgeCount1_API_Response:)];

        if (![[[userInfo valueForKey:@"acme2"]valueForKey:@"order-id"]isEqualToString:@""])
        {
            OrderSummaryView *obj=[[OrderSummaryView alloc]initWithNibName:@"OrderSummaryView" bundle:nil];
            obj.orderID=[[userInfo valueForKey:@"acme2"]valueForKey:@"order-id"];
            [nav pushViewController:obj animated:YES];
        }
    }
    else
        if (alertView.tag==73)
    {
        NotificationCenter * obj = [[NotificationCenter alloc]initWithNibName:@"NotificationCenter" bundle:nil];
        [nav pushViewController:obj animated:YES];
        obj=nil;
    }
    else if (alertView.tag==74)
    {
        CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
        objViewController.urlToDisplay=[pushmsg1 valueForKey:@"item_value"];
        objViewController.strPrev=@"custom";
        [nav pushViewController:objViewController animated:YES];
        objViewController = nil;
    }
    else if (alertView.tag==75)
    {
        ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
        objViewController.strName=@"Products";
        objViewController.categoryID=[pushmsg1 valueForKey:@"item_value"];
        objViewController.apiType = @"SearchApi";
        [nav pushViewController:objViewController animated:YES];
        objViewController = nil;
    }
    else if (alertView.tag==76)
    {
        ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
        NSString *str=[NSString stringWithFormat:@"%@",[pushmsg1 valueForKey:@"item_value"]];
        
        objViewController.strProdId=str;
        [nav pushViewController:objViewController animated:YES];
        
        objViewController = nil;
    }
   
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    if ([[GIDSignIn sharedInstance] handleURL:url
                            sourceApplication:sourceApplication
                                   annotation:annotation])
    {
        return YES;
    }
    else if ( [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation])
    {
        return YES;
    }
    
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    application.applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSString *str=[NSString stringWithFormat:@"%@resetBadgeCount?salt=%@&deviceId=%@&badge=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],@"0",model.storeID,model.currencyID];
        
        //---------------- API----------------------
    
        [FBSDKAppEvents activateApp];
     application.applicationIconBadgeNumber = 0;
    ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_resetBadgeCount1_API_Response:)];
   
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark Api Response

-(void)Get_resetBadgeCount1_API_Response:(NSDictionary*)responseDict
{
    if ([[responseDict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"hello %@",responseDict);

        NSDictionary *strResponse=[responseDict valueForKey:@"response"];
        if ([[strResponse valueForKey:@"theme_color"]isEqualToString:@""])
        {
            model.themeColor=topBarColor;
            model.buttonColor=ButtonColor;
            model.saffronClr = saffronColor;
            model.greenClr = GreenColor;
            model.blueClr = BlueColor;
            model.priceColor=PriceColor;
            model.secondaryColor=[UIColor colorWithRed:234.0/255.0 green:103.0/255.0 blue:74.0/255.0 alpha:1.0];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"TestNotification"
             object:self];
 
        }
        else
        {
            model.themeColor=[UIColor colorwithHexString:[NSString stringWithFormat:@"%@",[strResponse valueForKey:@"theme_color"]] alpha:1.0];
            model.buttonColor=[UIColor colorwithHexString:[NSString stringWithFormat:@"%@",[strResponse valueForKey:@"button_color"]] alpha:1.0];
            model.priceColor=[UIColor colorwithHexString:[NSString stringWithFormat:@"%@",[strResponse valueForKey:@"price_color"]] alpha:1.0];
            model.secondaryColor=[UIColor colorwithHexString:[NSString stringWithFormat:@"%@",[strResponse valueForKey:@"sec_button_color"]] alpha:1.0];
            model.saffronClr = saffronColor;
            model.greenClr = GreenColor;
             model.blueClr = BlueColor;


            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"TestNotification"
             object:self];

        }
    }
    else if(responseDict ==nil || [[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"fail"])
    {
        NSLog(@"%@",responseDict);
        model.themeColor=topBarColor;
        model.buttonColor=ButtonColor;
        model.saffronClr = saffronColor;
        model.greenClr = GreenColor;
         model.blueClr = BlueColor;


        model.priceColor=PriceColor;
        model.secondaryColor=[UIColor colorWithRed:234.0/255.0 green:103.0/255.0 blue:74.0/255.0 alpha:1.0];
        [[NSNotificationCenter defaultCenter]
    postNotificationName:@"TestNotification"
    object:self];

    }
    else
    {
        NSLog(@"%@",responseDict);
    }
}


- (void)applicationWillTerminate:(UIApplication *)application
{}

@end
