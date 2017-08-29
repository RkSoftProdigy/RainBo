//
//  CCAVenueVC.h
//  Ongobuyo
//
//  Created by Rakesh on 7/31/17.
//  Copyright © 2017 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTool.h"
#import "ApiClasses.h"
#import "PaymentCell.h"
#import "UIImageView+WebCache.h"
#import "ModelClass.h"
#import "MBProgressHUD.h"
#import "PaymentShippingCell.h"
#import "ModelClass.h"
#import "PayPallView.h"
#import "AddToCartView.h"
#import "Reachability.h"
#import "ViewController.h"
#import "PayUUIPaymentUIWebViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"


@interface CCAVenueVC : UIViewController <UIWebViewDelegate>
{
    ModelClass   * model;

}
@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
@property (strong, nonatomic) NSString *accessCode;
@property (strong, nonatomic) NSString *merchantId;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSString *redirectUrl;
@property (strong, nonatomic) NSString *cancelUrl;
@property (strong, nonatomic) NSString *rsaKeyUrl;
@property (strong, nonatomic) NSString *rsaKey;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *coverAlertView;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;
- (IBAction)backBtn_Action:(id)sender;
- (IBAction)homeButton:(id)sender;

@end
