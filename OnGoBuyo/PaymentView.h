//
//  PaymentView.h
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 3/4/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentView : UIViewController
{
    NSMutableArray *arrCheckBtn;
    NSString *productInfo;
    NSString *transactionId;
    NSDictionary *keysalt;
    NSDictionary *CCAVenueDic;
    
    IBOutlet UIView *CCAVenueView;
    IBOutlet UIButton *btnTag7;
    __weak IBOutlet UILabel *orderReviewLbl;
    __weak IBOutlet UIButton *changeLbl;
    __weak IBOutlet UIButton *changeLbl2;
    
    __weak IBOutlet UILabel *noPaymentLbl;
    __weak IBOutlet UILabel *freeLbl;
    __weak IBOutlet UILabel *bankLbl;
    __weak IBOutlet UILabel *paylbl;
    __weak IBOutlet UILabel *checkLbl;
    __weak IBOutlet UILabel *codLbl2;
    __weak IBOutlet UILabel *codLbl;
    __weak IBOutlet UILabel *makePaymentLbl;
    __weak IBOutlet UILabel *paypalLbl;
    __strong IBOutlet UILabel *orderTotalLBL;
    __strong IBOutlet UILabel *deliveryLbl;
    __strong IBOutlet UILabel *taxesLbl;
    __strong IBOutlet UILabel *discountLbl;
    __strong IBOutlet UILabel *subtotalLbl;
    __weak IBOutlet UILabel *yourOrderLbl;
    __weak IBOutlet UILabel *yourOrderId;
    __weak IBOutlet UILabel *receiveLbl;
    __weak IBOutlet UILabel *demoLbl;
    __weak IBOutlet UIImageView *paypalImg1;
    __weak IBOutlet UIImageView *paypalImg2;
    __weak IBOutlet UIImageView *paypalImg3;
    __weak IBOutlet UIImageView *paypalImg4;
    __weak IBOutlet UIImageView *paypalImg5;
    
    __weak IBOutlet UIImageView *payumoneyImg1;
}
//change color outlets

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *billingLbl;
@property (weak, nonatomic) IBOutlet UILabel *shippingLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderLabl;
@property (weak, nonatomic) IBOutlet UILabel *shipmetLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *selectlabel;
@property (weak, nonatomic) IBOutlet UILabel *thanksLbl;

@property (strong, nonatomic) NSString *strCover;

@property (weak, nonatomic) IBOutlet UIView *billingAddressView;
@property (weak, nonatomic) IBOutlet UIView *shippingAddressView;
@property (weak, nonatomic) IBOutlet UIView *orderSummeryView;
@property (weak, nonatomic) IBOutlet UIView *shippingMethodView;
@property (strong, nonatomic) IBOutlet UIView *amountDetailView;
@property (strong, nonatomic) IBOutlet UIView *payMehodView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnPlaceNow;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtotal;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxes;
@property (strong, nonatomic) IBOutlet UILabel *lblDelivery;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalOrder;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) NSString *grandtotal;
@property (strong, nonatomic) IBOutlet UIView *amountDetailSubView;

//Billing
@property (strong,nonatomic)NSString * billingName;
@property (strong,nonatomic)NSString * billingAddress;
@property (strong,nonatomic)NSString * billingCode;
@property (strong,nonatomic)NSString * billingPhone;
@property (strong,nonatomic)NSString * email;

//shipping
@property (strong,nonatomic)NSString * shippingName;
@property (strong,nonatomic)NSString * shippingAddress;
@property (strong,nonatomic)NSString * shippingCode;
@property (strong,nonatomic)NSString * shippingPhone;

//payment methods

@property (strong, nonatomic) IBOutlet UIView *payPalView;
@property (strong, nonatomic) IBOutlet UIView *cashOnDeliveryView;
@property (strong, nonatomic) IBOutlet UIView *chequeMoneyView;
@property (strong, nonatomic) IBOutlet UIView *payUMoney_vew;
@property (weak, nonatomic) IBOutlet UIButton *btnTag5;
@property (weak, nonatomic) IBOutlet UIButton *btnTag6;
@property (weak, nonatomic) IBOutlet UIView *freeView;
@property (weak, nonatomic) IBOutlet UIView *bankTransferView;
@property (weak, nonatomic) IBOutlet UILabel *bankTransferInstruction;


-(void)methodCall:(NSString *)str;
-(void)methodCall1:(NSString *)str;

@end
