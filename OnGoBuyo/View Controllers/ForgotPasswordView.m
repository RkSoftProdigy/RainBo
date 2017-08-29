//
//  ForgotPasswordView.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/22/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "ForgotPasswordView.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "LoginViewController.h"
#import "ModelClass.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"
@interface ForgotPasswordView ()
{
    ModelClass *model;
}
@end

@implementation ForgotPasswordView
@synthesize email,emailView,labelEmail,resetPassword,topView,topView2,simplyLbl,lostLabel;

- (void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [topView TransformationView];
    [topView2 TransformationView];
    [lostLabel TransformLabel];
    [simplyLbl TransformLabel];
    [email TransformTextField];
    [labelEmail TransformAlignLabel];
    [resetPassword TransformButton];
    
    [super viewDidLoad];
    
    model=[ModelClass sharedManager];
    
    labelEmail.hidden=YES;
    
    //word change
    [lostLabel setText:AMLocalizedString(@"tLOSTYOURPASSWORD", nil) ];
    [simplyLbl setText:AMLocalizedString(@"tSimplytypeinyouremailtoreset", nil)];
    [labelEmail setText:AMLocalizedString(@"tEnterYourEmail", nil)];
    [email setPlaceholder:AMLocalizedString(@"tEnterYourEmail", nil)];
    [resetPassword setTitle:AMLocalizedString(@"tResetPassword", nil) forState:UIControlStateNormal];
    
    
    //border
    //    emailView.layer.masksToBounds = YES;
    //    emailView.layer.cornerRadius = 4.0;
    //    emailView.layer.borderWidth = 1.0;
    //    emailView.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:193.0/255.0] CGColor];
    
    //    resetPassword.layer.masksToBounds = YES;
    //    resetPassword.layer.cornerRadius = 4.0;
    //    resetPassword.layer.borderWidth = 1.0;
    //    resetPassword.layer.borderColor = [[UIColor clearColor] CGColor];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //change color
    [lostLabel setTextColor:model.priceColor];
    [simplyLbl setTextColor:model.priceColor];
    [topView2 setBackgroundColor:model.themeColor];
    [topView setBackgroundColor:model.themeColor];
    [resetPassword setBackgroundColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ForgotPasswordView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TextField Delegates


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==email)
    {
        textField.placeholder = nil;
       // labelEmail.hidden=NO;
        labelEmail.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelEmail duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length==0)
    {
        if (textField==email)
        {
            textField.placeholder = AMLocalizedString(@"tEnterYourEmail", nil) ;
            labelEmail.hidden=YES;
        }
    }
    else
    {
        if (textField==email)
        {
            labelEmail.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

#pragma mark Helper Methods

- (BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

#pragma mark Reset Password

- (IBAction)ResetPassword:(id)sender
{
    NSString *msg=@"0";
    
    if(([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefillthevalidemailaddress", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        msg=@"1";
    }
    else if(([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0)&& ![self validateEmailWithString:email.text]&& [msg isEqualToString:@"0"] )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tEmailformatisnotcorrect", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
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
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)  otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSLog(@"There IS internet connection");
            
            [self addLoadingView];
            
            ApiClasses *obj=[[ApiClasses alloc]init];
            
            NSString *str=[NSString stringWithFormat:@"%@resetPassword?salt=%@&email=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,email.text,model.storeID,model.currencyID];
            [obj ViewMore:str withTarget:self  withSelector:@selector(Get_ResetPassword_Response:)];
        }
    }
}

-(void) Get_ResetPassword_Response:(NSMutableDictionary*) responsedict
{
    [self removeLoadingView];
    NSLog(@"%@ ",responsedict);
    
    if([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[responsedict valueForKey:@"response"] delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil)  otherButtonTitles:nil];
        [alert show];
        alert.tag=55;
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)  otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==55)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


#pragma mark Back Button

- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
