//
//  PayUUIPaymentUIWebViewController.h
//  SeamlessTestApp
//
//  Created by Umang Arya on 07/10/15.
//  Copyright © 2015 PayU. All rights reserved.


#import <UIKit/UIKit.h>
//#import "PayPallView.h"
@protocol orderDisplay1 <NSObject>

-(void)methodCall1:(NSString *)str;

@end


@interface PayUUIPaymentUIWebViewController : UIViewController<UIWebViewDelegate>


@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *paymentWebView;

@property (weak, nonatomic) IBOutlet UIView *topView;


@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *txnid1;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *productInfo;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *Salt;
@property (strong, nonatomic) NSString *phone;

@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *Surl;
@property (strong, nonatomic) NSString *Furl;

@property (strong,nonatomic) id <orderDisplay1> delegate;



- (IBAction)backBtn_Action:(id)sender;

@end
