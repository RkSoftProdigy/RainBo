//
//  UserProfileView.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/22/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotPasswordView.h"
#import "ProductDetailsViewController.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import "CollectionCell.h"
#import "ModelClass.h"
#import "ProductDetailsViewController.h"
#import "ZoomImageViewController.h"
#import "LoginViewController.h"
#import "AddToCartView.h"
#import "AppInfoView.h"
#import "AppDelegate.h"
#import "UserProfileView.h"
#import "MyOrdersViewController.h"
#import "ViewController.h"
#import "ReviewsViewViewController.h"
#import "GroupedCell.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "NotificationCenter.h"
#import "DownloadableView.h"
#import "WishListViewViewController.h"
#import "CustomView.h"
#import "ViewMoreViewController.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "LanguageSettingView.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"
#import "UIWebView+transformWeb.h"
#import "UIDatePicker+Transform.h"
#import "UITextView+transform.h"

@interface UserProfileView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//change color outlets

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;



@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *editIcon;
@property (strong, nonatomic) IBOutlet UIButton *btnEditImage;


//Views

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *oldPwdView;
@property (weak, nonatomic) IBOutlet UIView *nePwdView;
@property (weak, nonatomic) IBOutlet UIView *confirmPwdView;

@property (strong, nonatomic) IBOutlet UIView *cancelView;
@property (strong, nonatomic) IBOutlet UIView *changePasswordView;

//textfields

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *emailAddress;
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *nePassword;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;

//labels

@property (weak, nonatomic) IBOutlet UILabel *labelFirstName;
@property (weak, nonatomic) IBOutlet UILabel *labelLastName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;

@property (strong, nonatomic) IBOutlet UILabel *labelnewP;
@property (strong, nonatomic) IBOutlet UILabel *labeloldP;

@property (strong, nonatomic) IBOutlet UILabel *labelConfirm;

//button outlets
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *saveBorder;
@property (weak, nonatomic) IBOutlet UIButton *logoutBorder;

- (IBAction)ForgotAction:(id)sender;

//Logout Button
- (IBAction)Logout:(id)sender;

//update button
- (IBAction)EditButton:(id)sender;


//change Password or cancel

- (IBAction)ChangePasswordCancel:(id)sender;

//Save Button

- (IBAction)saveButton:(id)sender;

//back button

- (IBAction)Back:(id)sender;
- (IBAction)EditImageAction:(id)sender;


@end
