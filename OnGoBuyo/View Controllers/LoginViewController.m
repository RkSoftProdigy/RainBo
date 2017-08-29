//
//  LoginViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/17/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "LoginViewController.h"
#import "ApiClasses.h"
#import "MBProgressHUD.h"
#import "RegisterViewController.h"
#import "ForgotPasswordView.h"
#import "ModelClass.h"
#import "ProductDetailsViewController.h"
#import "AddToCartView.h"
#import "Reachability.h"
#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "Constants.h"
#import "ViewMoreViewController.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"


@interface LoginViewController ()
{
    ModelClass *model;
}
@end

@implementation LoginViewController
@synthesize loginBorder,userBorder,passwordBorder,scrollView,Email,password,labelEmail,labelPassword,strPage,strOption,loginButton,SignButton;

- (void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView1 TransformationView];
    [_topview2 TransformationView];
    [_happylbl TransformLabel];
    [_pleaseLbl TransformLabel];
    [Email TransformTextField];
    [password TransformTextField];
    [loginBorder TransformButton];
    [forgotPassword TransformButton];
    [labelEmail TransformAlignLabel];
    [labelPassword TransformAlignLabel];
    [_dontLabel TransformAlignLabel];
    [_registerLbl TransformAlignButton];
    [SignButton TransformViewCont];
    [forgotPassword TransformButton];
    [loginButton TransformButton];
    
    [super viewDidLoad];
    
    
    model=[ModelClass sharedManager];
    
    //word change
    [_happylbl setText:AMLocalizedString(@"tHAPPYTOHAVEYOUHERE", nil) ];
    [_pleaseLbl setText:AMLocalizedString(@"tPleaseloginbelowwithyourdetails", nil)];
    [labelEmail setText:AMLocalizedString(@"tEMailAddress", nil) ];
    [labelPassword setText:AMLocalizedString(@"tPassword", nil)];
    [Email setPlaceholder:AMLocalizedString(@"tEMailAddress", nil)];
    [password setPlaceholder:AMLocalizedString(@"tPassword", nil)];
    [loginBorder setTitle:AMLocalizedString(@"tLogin", nil) forState:UIControlStateNormal];
    [forgotPassword setTitle:AMLocalizedString(@"tForgotPassword", nil) forState:UIControlStateNormal];
    [_registerLbl setTitle:AMLocalizedString(@"tRegisterwithus", nil) forState:UIControlStateNormal];
    [_dontLabel setText:AMLocalizedString(@"tDontHaveAccountyet", nil)];
    
    // Google code
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    // Google login code
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    // [START_EXCLUDE silent]
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveToggleAuthUINotification:)
     name:@"ToggleAuthUINotification"
     object:nil];
    
    [self toggleAuthUI];
    
    //scroll view
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    
    if(([pT intValue]==101) || ([pT intValue]==1011) )
    {
        [loginButton setHidden:YES];
        [SignButton setHidden:YES];
        [_registerLbl setFrame:CGRectMake(_registerLbl.frame.origin.x, loginButton.frame.origin.y-4, _registerLbl.frame.size.width, _registerLbl.frame.size.height)];
        [_dontLabel setFrame:CGRectMake(_dontLabel.frame.origin.x, loginButton.frame.origin.y, _dontLabel.frame.size.width, _dontLabel.frame.size.height)];
        [scrollView setContentSize:CGSizeMake(320, 450)];
    }
    else
    {
        [loginButton setHidden:NO];
        [SignButton setHidden:NO];
        [scrollView setContentSize:CGSizeMake(320, 500)];
    }
    
    if (scrollView.contentSize.height+55>self.view.frame.size.height)
    {
        [scrollView setScrollEnabled:YES];
    }
    else
    {
        [scrollView setScrollEnabled:NO];
    }
    //borders
    //    loginBorder.layer.masksToBounds = YES;
    //    loginBorder.layer.cornerRadius = 4.0;
    //    loginBorder.layer.borderWidth = 1.0;
    //    loginBorder.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //    userBorder.layer.masksToBounds = YES;
    //    userBorder.layer.cornerRadius = 4.0;
    //    userBorder.layer.borderWidth = 1.0;
    //    userBorder.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:193.0/255.0] CGColor];
    
    //    passwordBorder.layer.masksToBounds = YES;
    //    passwordBorder.layer.cornerRadius = 4.0;
    //    passwordBorder.layer.borderWidth = 1.0;
    //    passwordBorder.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:193.0/255.0] CGColor];
    
    //Hidden contents
    labelPassword.hidden=YES;
    labelEmail.hidden=YES;
    
    // Do any additional setup after loading the view from its nib.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //change Color
    [_topView1 setBackgroundColor:model.themeColor];
    [_topview2 setBackgroundColor:model.themeColor];
    [_registerLbl setTitleColor:model.priceColor forState:UIControlStateNormal];
    [_dontLabel setTextColor:model.priceColor];
    [_happylbl setTextColor:model.priceColor];
    [_pleaseLbl setTextColor:model.priceColor];
    [loginBorder setBackgroundColor:model.buttonColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"LoginView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Login button

- (IBAction)Login:(id)sender
{
    NSString *msg=@"0";
    if ((([[Email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) || ([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)) && [msg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefillalldetails", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
        [alert show];
        msg=@"1";
    }
    else if(([[Email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0)&& ![self validateEmailWithString:Email.text]&& [msg isEqualToString:@"0"] )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tEmailformatisnotcorrect", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil)  otherButtonTitles:nil];
        [alert show];
        msg=@"1";
    }
    else
    {
        
        // -------------------------- Reachability --------------------//
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            NSLog(tNoInternet);
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSLog(@"There IS internet connection");
            [self addLoadingView];
            ApiClasses *obj=[[ApiClasses alloc]init];
            NSString *str=[NSString stringWithFormat:@"%@login?salt=%@&email=%@&password=%@&device_type=Iphone&device_id=%@&social_id=&cstore=%@&ccurrency=%@",baseURL1,model.salt,Email.text,password.text,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],model.storeID,model.currencyID];
            [obj ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Get_login_Response:)];
        }
    }
}

-(void) Get_login_Response:(NSMutableDictionary*) responsedict
{
    [self removeLoadingView];
    NSLog(@"%@",responsedict);
    
    if ([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        model.custId=[[responsedict valueForKey:@"response"]valueForKey:@"cust_id"];
        if ([logintype isEqualToString:@"fb"]||[logintype isEqualToString:@"gmail"])
        {
            [[NSUserDefaults standardUserDefaults]setValue:email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SocialLogin"];
            [[NSUserDefaults standardUserDefaults]setValue:email forKey:@"email"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:Email.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setValue:Email.text forKey:@"email"];
        }
        [[NSUserDefaults standardUserDefaults]setValue:model.custId forKey:@"Cust_id"];
        [[NSUserDefaults standardUserDefaults]setValue:model.custId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"onlyOnce"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"login"];
        if([strOption isEqualToString:@"cart"])
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"loginaddtoCart"];
        }
        else if([strOption isEqualToString:@"wishlist"])
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"loginAddWishlist"];
        }
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([strPage isEqualToString:@"Confirmbutton"])
            {
                if ([controller isKindOfClass:[AddToCartView class]])
                {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
                
            }
            else if ([strPage isEqualToString:@"Home"])
            {
                if ([controller isKindOfClass:[ViewController class]])
                {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
            else if ([strPage isEqualToString:@"ViewMore"])
            {
                if ([controller isKindOfClass:[ViewMoreViewController class]])
                {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
            else
            {
                if ([controller isKindOfClass:[ProductDetailsViewController class]])
                {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }
    }
    else if ([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText" ]isEqualToString:@"fail"])
    {
        if([[responsedict valueForKey:@"response"]isKindOfClass:[NSDictionary class]])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[[responsedict valueForKey:@"response"]valueForKey:@"response_msg"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[responsedict valueForKey:@"response"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
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


#pragma mark TextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==Email)
    {
        textField.placeholder = nil;
        //labelEmail.hidden=NO;
        labelEmail.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelEmail duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else
    {
        textField.placeholder = nil;
        //labelPassword.hidden=NO;
        labelPassword.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelPassword duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length==0)
    {
        if (textField==Email)
        {
            textField.placeholder = AMLocalizedString(@"tEMailAddress", nil);
            labelEmail.hidden=YES;
        }
        else
        {
            textField.placeholder = AMLocalizedString(@"tPassword", nil);
            labelPassword.hidden=YES;
        }
    }
    else
    {
        if (textField==Email)
        {
            
            labelEmail.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else
        {
            labelPassword.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==Email)
    {
        [password becomeFirstResponder];
    }
    else
    {
        [password resignFirstResponder];
    }
    
    return YES;
}


#pragma mark Back Button Method

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Register User

- (IBAction)RegisterUser:(id)sender
{
    RegisterViewController *objViewController=[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:objViewController animated:YES];
    objViewController=nil;
}

#pragma mark ForgotPassword

- (IBAction)ForgotPassword:(id)sender
{
    ForgotPasswordView *objViewController=[[ForgotPasswordView alloc]initWithNibName:@"ForgotPasswordView" bundle:nil];
    [self.navigationController pushViewController:objViewController animated:YES];
    objViewController=nil;
}


#pragma mark Helper Methods

- (BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}




#pragma mark ---FB login---

- (IBAction)fbLoginBtn_Action:(id)sender
{
    //[self addLoadingView];
    
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
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        [login
         logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Process error--%@",error);
             }
             else if (result.isCancelled)
             {
                 NSLog(@"Cancelled");
             }
             else
             {
                 NSLog(@"Logged in");
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     if ([FBSDKAccessToken currentAccessToken])
                     {
                         [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday ,location ,friends ,hometown , friendlists"}]
                          startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                          {
                              if (!error)
                              {
                                  NSLog(@"Name is ::%@",result[@"name"]);
                                  NSLog(@"Email id is ::%@",result[@"email"]);
                                  NSLog(@"FirstName is :: %@",result[@"first_name"]);
                                  NSLog(@"LastName is :: %@",result[@"last_name"]);
                                  
                                  firstname = result[@"first_name"];
                                  lastname = result[@"last_name"];
                                  email = result[@"email"];
                                  
                                  NSString *strSocialId=[NSString stringWithFormat:@"fb_%@",email];
                                  NSString *strSocialId1=[NSString stringWithFormat:@"gmail_%@",email];
                                  socialId1=[self md5:[self md5:strSocialId]];
                                  socialId2=[self md5:[self md5:strSocialId1]];
                                  
                                  ApiClasses *obj=[[ApiClasses alloc]init];
                                  logintype = @"fb";
                                  NSString *str1=[NSString stringWithFormat:@"%@registration?salt=%@&login_type=%@&email=%@&password=%@&firstname=%@&lastname=%@&fb_social_id=%@&gmail_social_id=%@&device_type=Iphone&device_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,logintype,email,@"",firstname,lastname,socialId1,socialId2,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],model.storeID,model.currencyID];
                                  
                                  [self addLoadingView];
                                  
                                  [obj ViewMore:[str1 stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Get_Register_Response1:)];
                                  
                              }
                          }];
                     }
                 }
             }
         }];
    }
}


#pragma mark ---GoogleSignIn---

//  Google Sign Methods
// [START toggle_auth]
- (void)toggleAuthUI
{
    [[GIDSignIn sharedInstance] signOut];
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil)
    {
        //        // Not signed in
        //        [self statusText].text = @"Google Sign in\niOS Demo";
        //        self.signInButton.hidden = NO;
        //        self.signOutButton.hidden = YES;
        //        self.disconnectButton.hidden = YES;
    } else
    {
        // Signed in
        //        self.signInButton.hidden = YES;
        //        self.signOutButton.hidden = NO;
        //        self.disconnectButton.hidden = NO;
    }
}
// [END toggle_auth]

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
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
        // Perform any operations on signed in user here.
        //    socialId1 = user.userID;                  // For client-side use only!
        //    NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fName = user.profile.givenName;
        NSString *lName = user.profile.familyName;
        NSLog(@"%@ %@ ",user.profile.familyName,user.profile.givenName);
        email = user.profile.email;
        //NSString *password1 = @"";
        
        //    model.custId = socialId1;
        if (email!=nil)
        {
            NSString *strSocialId=[NSString stringWithFormat:@"fb_%@",email];
            socialId1=[self md5:[self md5:strSocialId]];
            NSString *strSocialId1=[NSString stringWithFormat:@"gmail_%@",email];
            socialId2=[self md5:[self md5:strSocialId1]];
            ApiClasses *obj=[[ApiClasses alloc]init];
            
            logintype = @"gmail";
            
            NSString *str1=[NSString stringWithFormat:@"%@registration?salt=%@&login_type=%@&email=%@&password=%@&firstname=%@&lastname=%@&fb_social_id=%@&gmail_social_id=%@&device_type=Iphone&device_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,logintype,email,@"",fName,lName,socialId1,socialId2,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],model.storeID,model.currencyID];
            [obj ViewMore:[str1 stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Get_Register_Response1:)];
            
            [self addLoadingView];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tLoginUnsuccessfull", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"ToggleAuthUINotification"
     object:nil];
}

- (void) receiveToggleAuthUINotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"])
    {
        [self toggleAuthUI];
        //self.statusText.text = [notification userInfo][@"statusText"];
    }
}

-(void)Get_Register_Response1:(NSMutableDictionary*) responsedict
{
    [self removeLoadingView];
    NSLog(@"%@ ",responsedict);
    
    if ([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"success"])
    {
        model.custId=[[responsedict valueForKey:@"response"]valueForKey:@"cust_id"];
        
        ApiClasses *obj=[[ApiClasses alloc]init];
        if ([logintype isEqualToString:@"gmail"])
        {
            socialId1=[NSString stringWithFormat:@"%@",socialId2];
        }
        
        NSString *str=[NSString stringWithFormat:@"%@login?salt=%@&login_type=%@&email=%@&password=%@&social_id=%@&device_type=Iphone&device_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,logintype,email,@"",socialId1,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],model.storeID,model.currencyID];
        
        [self addLoadingView];
        
        [obj ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Get_login_Response:)];
        
        // [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText" ]isEqualToString:@"fail"])
    {
        if ([logintype isEqualToString:@"gmail"])
        {
            socialId1=[NSString stringWithFormat:@"%@",socialId2];
        }
        
        ApiClasses *obj=[[ApiClasses alloc]init];
        NSString *str=[NSString stringWithFormat:@"%@login?salt=%@&login_type=%@&email=%@&password=%@&social_id=%@&device_type=Iphone&device_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,logintype,email,@"",socialId1,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],model.storeID,model.currencyID];
        [self addLoadingView];
        [obj ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Get_login_Response:)];
        
        
    }
    else if ([[[responsedict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText" ] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
        
    }
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
