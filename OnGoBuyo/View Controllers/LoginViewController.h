//
//  LoginViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/17/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>

@interface LoginViewController : UIViewController<GIDSignInUIDelegate,GIDSignInDelegate>
{
    NSString *firstname;
    NSString *lastname;
    NSString *email;
    NSString *password1;
    NSString *socialId1;
    NSString *socialId2;
    NSString *logintype;
    __weak IBOutlet UIButton *forgotPassword;
}

//change color outlets
@property (weak, nonatomic) IBOutlet UIView *topView1;
@property (weak, nonatomic) IBOutlet UIView *topview2;
@property (weak, nonatomic) IBOutlet UIButton *registerLbl;
@property (weak, nonatomic) IBOutlet UILabel *dontLabel;
@property (weak, nonatomic) IBOutlet UILabel *happylbl;
@property (weak, nonatomic) IBOutlet UILabel *pleaseLbl;

//previous string

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) NSString *strPage;
@property (strong, nonatomic) NSString *strOption;

@property (strong, nonatomic) IBOutlet GIDSignInButton *SignButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//TextFields
@property (strong, nonatomic) IBOutlet UITextField *Email;
@property (strong, nonatomic) IBOutlet UITextField *password;

//labels
@property (strong, nonatomic) IBOutlet UILabel *labelEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelPassword;

//borders
@property (weak, nonatomic) IBOutlet UIView *userBorder;
@property (weak, nonatomic) IBOutlet UIView *passwordBorder;
@property (weak, nonatomic) IBOutlet UIButton *loginBorder;

//Login Button
- (IBAction)Login:(id)sender;

//Register Button
- (IBAction)RegisterUser:(id)sender;

// Forgot Password
- (IBAction)ForgotPassword:(id)sender;

//Back Button
- (IBAction)backButton:(id)sender;

//FBLogin
- (IBAction)fbLoginBtn_Action:(id)sender;



@end
