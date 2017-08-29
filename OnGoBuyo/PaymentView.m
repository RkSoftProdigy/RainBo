//
//  PaymentView.m
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 3/4/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "PaymentView.h"
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
#import "CCAVenueVC.h"

@interface PaymentView ()<UITableViewDataSource,UITableViewDelegate,orderDisplay,orderDisplay1>
{
    NSMutableArray * productArray;
    NSMutableArray * shippingArray;
    ModelClass     * model;
    BOOL             isSelected;
    NSString       * typePayment;
    int isVirtual;
}
@property (weak, nonatomic) IBOutlet UITableView *tblOrderSummary;
@property (weak, nonatomic) IBOutlet UITableView *tblShippingMethod;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnTag1;
@property (weak, nonatomic) IBOutlet UIButton *btnTag2;
@property (weak, nonatomic) IBOutlet UIButton *btnTag3;
@property (weak, nonatomic) IBOutlet UIButton *btnTag4;
@property (weak, nonatomic) IBOutlet UILabel *lblBillingName;
@property (weak, nonatomic) IBOutlet UILabel *lblBillingAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblBillingCountryCode;
@property (weak, nonatomic) IBOutlet UILabel *lblBillingPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingName;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingCountryCode;
@property (weak, nonatomic) IBOutlet UILabel *lblSippingPhone;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *coverAlertView;
@property (weak, nonatomic) IBOutlet UIButton *btnContinues;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;

@end

@implementation PaymentView

-(void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [orderReviewLbl TransformLabel];
    [_billingLbl TransformAlignLabel];
    [changeLbl TransformButton];
    [changeLbl2 TransformButton];
    [_shippingLbl TransformAlignLabel];
    [_lblBillingName TransformAlignLabel];
    [_lblShippingName TransformAlignLabel];
    [_lblBillingAddress TransformAlignLabel];
    [_lblShippingAddress TransformAlignLabel];
    [_lblBillingCountryCode TransformAlignLabel];
    [_lblShippingCountryCode TransformAlignLabel];
    [_lblBillingPhone TransformAlignLabel];
    [_lblSippingPhone TransformAlignLabel];
    [_orderLabl TransformAlignLabel];
    [_selectlabel TransformLabel];
    [_amountLbl TransformAlignLabel];
    [subtotalLbl TransformAlignLabel];
    [discountLbl TransformAlignLabel];
    [taxesLbl TransformAlignLabel];
    [deliveryLbl TransformAlignLabel];
    [orderTotalLBL TransformAlignLabel];
    [_lblSubtotal TransformAlignLeftLabel];
    [_lblTaxes TransformAlignLeftLabel];
    [_lblDiscount TransformAlignLeftLabel];
    [_lblDelivery TransformAlignLeftLabel];
    [_lblTotalOrder TransformAlignLeftLabel];
    [_shipmetLbl TransformAlignLabel];
    [paypalLbl TransformAlignLabel];
    [makePaymentLbl TransformAlignLabel];
    [codLbl TransformAlignLabel];
    [codLbl2 TransformAlignLabel];
    [checkLbl TransformAlignLabel];
    [paylbl TransformAlignLabel];
    [bankLbl TransformAlignLabel];
    [paypalImg1 TransformImage];
    [paypalImg2 TransformImage];
    [paypalImg3 TransformImage];
    [paypalImg4 TransformImage];
    [paypalImg5 TransformImage];
    [payumoneyImg1 TransformImage];
    [_btnPlaceNow TransformButton];
    [_btnCancel TransformButton];
    [_bankTransferInstruction TransformAlignLabel];
    [yourOrderId TransformLabel];
    [_thanksLbl TransformLabel];
    [yourOrderLbl TransformLabel];
    [receiveLbl TransformLabel];
    [_btnContinues TransformButton];
    [_lblOrderID TransformLabel];
    
    
    [super viewDidLoad];
    
    //change word
    
    [orderReviewLbl setText:AMLocalizedString(@"tOrderReview", nil)];
    [_btnCancel setTitle:AMLocalizedString(@"tCancel", nil) forState:UIControlStateNormal];
    [_btnPlaceNow setTitle:AMLocalizedString(@"tPLACENOW", nil) forState:UIControlStateNormal];
    [_billingLbl setText:AMLocalizedString(@"tBillingAddress", nil)];
    [_shippingLbl setText:AMLocalizedString(@"tShippingAddress", nil)];
    [changeLbl setTitle:AMLocalizedString(@"tChange", nil) forState:UIControlStateNormal];
    [changeLbl2 setTitle:AMLocalizedString(@"tChange", nil) forState:UIControlStateNormal];
    [_orderLabl setText:AMLocalizedString(@"tOrderSummary", nil)];
    [_shipmetLbl setText:AMLocalizedString(@"tSelectAShippingMethod", nil)];
    [_amountLbl setText:AMLocalizedString(@"tAmountDetails", nil)];
    [subtotalLbl setText:AMLocalizedString(@"tSUBTOTAL", nil)];
    [discountLbl setText:AMLocalizedString(@"tDISCOUNT", nil)];
    [taxesLbl setText:AMLocalizedString(@"tTAXES", nil)];
    [deliveryLbl setText:AMLocalizedString(@"tDELIVERYCHARGES", nil)];
    [orderTotalLBL setText:AMLocalizedString(@"tORDERTOTAL", nil)];
    [_selectlabel setText:AMLocalizedString(@"tSELECTAPAYMETHOD", nil)];
    [paypalLbl setText:AMLocalizedString(@"tPayPal", nil)];
    [makePaymentLbl setText:AMLocalizedString(@"tMakepaymentusingPayumoney", nil)];
    [codLbl setText:AMLocalizedString(@"tCashondelivery", nil)];
    [codLbl2 setText:AMLocalizedString(@"tCashondeliveryisavailableonlyforselectedlocations", nil)];
    [checkLbl setText:AMLocalizedString(@"tChequeMoneyOrder", nil)];
    [paylbl setText:AMLocalizedString(@"tPayorderusingchequemoneyorder", nil)];
    [bankLbl setText:AMLocalizedString(@"tBankTransferPayment", nil)];
    [freeLbl setText:AMLocalizedString(@"tFree", nil)];
    [noPaymentLbl setText:AMLocalizedString(@"tNoPaymentInformationRequired", nil)];
    [yourOrderLbl setText:AMLocalizedString(@"tYOURORDERHASBEENRECEIVED", nil)];
    [_thanksLbl setText:AMLocalizedString(@"tThanksForShoppingWithUs", nil)];
    [yourOrderId setText:AMLocalizedString(@"tYourorderIDis", nil)];
    [receiveLbl setText:AMLocalizedString(@"tYouwillrecieveanorderconfirmationemailwithdetailsofyourorder", nil)];
    [_btnContinues setTitle:AMLocalizedString(@"tCONTINUESHOPPING", nil) forState:UIControlStateNormal];
    [demoLbl setText:AMLocalizedString(@"tThisisademostoreAny", nil)];
    
    arrCheckBtn = [[NSMutableArray alloc]init];
    
    model=[ModelClass sharedManager];
    
    self.scrollview.frame = CGRectMake(0, 96+7, 320, 500-7);
    [self.scrollview setContentSize:CGSizeMake(320, 1410)];
    [self.view addSubview:self.scrollview];
    
    [self.view bringSubviewToFront:self.bottomView];
   
    [self.view bringSubviewToFront:self.btnCancel];
    
    [self.view bringSubviewToFront:self.btnPlaceNow];
    
      productArray = [NSMutableArray new];
    shippingArray = [NSMutableArray new];
    
    self.lblBillingName.text = self.billingName;
    self.lblBillingAddress.text = self.billingAddress;
    self.lblBillingCountryCode.text = self.billingCode;
    NSString * str = [NSString stringWithFormat:@"%@: %@",AMLocalizedString(@"tPh", nil),self.billingPhone];
    self.lblBillingPhone.text = str;
    
    self.lblShippingName.text = self.shippingName;
    self.lblShippingAddress.text = self.shippingAddress;
    self.lblShippingCountryCode.text = self.shippingCode;
    NSString * str1 = [NSString stringWithFormat:@"%@: %@",AMLocalizedString(@"tPh", nil),self.shippingPhone];
    self.lblSippingPhone.text = str1;
    
    isVirtual=3;
    _payPalView.hidden=YES;
    _payUMoney_vew.hidden=YES;
    _cashOnDeliveryView.hidden=YES;
    _chequeMoneyView.hidden=YES;
    _bankTransferView.hidden=YES;
    _freeView.hidden=YES;
}

#pragma mark - Order Summary Api

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self removeLoadingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // change color
    
    [_btnCancel setBackgroundColor:model.buttonColor];
    [_topView setBackgroundColor:model.themeColor];
    [_billingLbl setTextColor:model.priceColor];
    [_shippingLbl setTextColor:model.priceColor];
    [_orderLabl setTextColor:model.priceColor];
    [_shipmetLbl setTextColor:model.priceColor];
    [_amountLbl setTextColor:model.priceColor];
    
    [_btnContinues setBackgroundColor:model.buttonColor];
    [_thanksLbl setTextColor:model.priceColor];
    [_lblOrderID setTextColor:model.priceColor];
    [orderReviewLbl setTextColor:[UIColor whiteColor]];
    [_lblTotalOrder setTextColor:model.secondaryColor];
    
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"PaymentView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
 
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
          dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self cartDetail];
            
        });
    });
    
}

-(void)cartDetail
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
        
        [self addLoadingView];
        ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
        
        NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        
        NSString* str;
        
        if(str1.length!=0)
        {
            str=[NSString stringWithFormat:@"%@cartDetail?salt=%@&quote_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str1,model.storeID,model.currencyID];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
        }
        else
        {
            [self removeLoadingView];
        }
    }
}

-(void)Get_cart_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    NSArray * arr ;
    if ([[responseDict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
    {
        arr = [[responseDict valueForKey:@"response"]valueForKey:@"products"];
        
        if(arr.count>0)
        {
            if(productArray.count>0)
            {
                [productArray removeAllObjects];
            }
            [productArray addObjectsFromArray:arr];
            
            [self.tblOrderSummary reloadData];
            
            self.tblOrderSummary.frame = CGRectMake(self.tblOrderSummary.frame.origin.x, self.tblOrderSummary.frame.origin.y, self.tblOrderSummary.frame.size.width, self.tblOrderSummary.contentSize.height);
            
            float ftbl = self.tblOrderSummary.frame.origin.y + self.tblOrderSummary.contentSize.height + 12;
            
            self.orderSummeryView.frame = CGRectMake(10, 398, 300, ftbl);
            
            self.shippingMethodView.frame = CGRectMake(10, self.orderSummeryView.frame.origin.y+self.orderSummeryView.frame.size.height+20, 300, 168);
            
            self.amountDetailView.frame = CGRectMake(10, self.shippingMethodView.frame.origin.y+self.shippingMethodView.frame.size.height+20, 300, 192);
            
            self.payMehodView.frame = CGRectMake(10, self.amountDetailView.frame.origin.y+self.amountDetailView.frame.size.height+20, 300, 250);
            
            self.scrollview.contentSize=CGSizeMake(320, self.payMehodView.frame.size.height+self.payMehodView.frame.origin.y+90);
            isVirtual=[[[responseDict valueForKey:@"response"]valueForKey:@"is_virtual"]intValue];
            [[NSUserDefaults standardUserDefaults]setValue:[[responseDict valueForKey:@"response"]valueForKey:@"subtotal"] forKey:@"Subtotal"];
            [self.tblOrderSummary setScrollEnabled:NO];
            
        }
        else
        {
            if(productArray.count>0)
            {
                [productArray removeAllObjects];
            }
            [self.tblOrderSummary reloadData];
        }
        
        self.lblSubtotal.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"subtotal"]];
        
        self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"discount"]];
        
        self.lblTaxes.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"tax"]];
        
        self.lblDelivery.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"ship_cost"]];
        
        self.lblTotalOrder.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"grandtotal"]];
        
        [self shippingMethod];
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    
}


#pragma mark - Shipping Method Api

-(void)shippingMethod
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        
        ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
        
        NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        
        NSString* str;
        
        if(str1.length!=0)
        {
            // str=[NSString stringWithFormat:@"%@getMethods?quote_id=%@",str1];
            str=[NSString stringWithFormat:@"%@getMethods?salt=%@&quote_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str1,model.storeID,model.currencyID];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_shipping_Response:)];
        }
        else
        {
            [self removeLoadingView];
        }
    }
}


-(void)Get_shipping_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    NSArray * arr = [[responseDict valueForKey:@"response"]valueForKey:@"ship_method"];
    CCAVenueDic = [[NSDictionary alloc]init];
    CCAVenueDic = [responseDict valueForKey:@"ccavenue_info"];
    keysalt = [responseDict valueForKey:@"payu_info"];
    
    if(arr.count>0)
    {
        
        [shippingArray addObjectsFromArray:arr];
        [self.tblShippingMethod reloadData];
        
        self.tblOrderSummary.frame = CGRectMake(self.tblOrderSummary.frame.origin.x, self.tblOrderSummary.frame.origin.y, self.tblOrderSummary.frame.size.width, self.tblOrderSummary.contentSize.height);
        
        float ftbl = self.tblOrderSummary.frame.origin.y + self.tblOrderSummary.contentSize.height + 12;
        
        self.orderSummeryView.frame = CGRectMake(10, 398, 300, ftbl);
        
        self.tblShippingMethod.frame = CGRectMake(self.tblShippingMethod.frame.origin.x, self.tblShippingMethod.frame.origin.y, self.tblShippingMethod.frame.size.width, self.tblShippingMethod.contentSize.height);
        
        float ftbl1 = self.tblShippingMethod.frame.origin.y + self.tblShippingMethod.contentSize.height + 6;
        
        self.shippingMethodView.frame = CGRectMake(10, self.orderSummeryView.frame.origin.y+self.orderSummeryView.frame.size.height+20, 300, ftbl1);
        
        self.amountDetailView.frame = CGRectMake(10, self.shippingMethodView.frame.origin.y+self.shippingMethodView.frame.size.height+20, 300, 192);
        
        self.payMehodView.frame = CGRectMake(10, self.amountDetailView.frame.origin.y+self.amountDetailView.frame.size.height+20, 300, 250);
        
        self.scrollview.contentSize=CGSizeMake(320, self.payMehodView.frame.size.height+self.payMehodView.frame.origin.y+80);
        
        [self.tblShippingMethod setScrollEnabled:NO];
    }
    else
    {
        isSelected=YES;
        
    }
    
    NSArray *arrPayment=[[responseDict valueForKey:@"response"]valueForKey:@"payment"];
    NSLog(@"%@",arrPayment);
    
    if(![arrPayment isKindOfClass:[NSNull class]])
    {
        NSArray *arr=[NSArray arrayWithObjects:@"paypal_express",@"payucheckout_shared",@"ccavenuepay",@"cashondelivery",@"checkmo",@"banktransfer",@"free", nil];
        int y=47;
        for (int c=0; c<arr.count; c++)
        {
            for (int i=0; i<arrPayment.count; i++)
            {
                if ([[[arrPayment objectAtIndex:i]valueForKey:@"code"]isEqualToString:[arr objectAtIndex:c]])
                {
                    switch (c)
                    {
                        case 0:
                            _payPalView.hidden=NO;
                            _payPalView.frame=CGRectMake(0, y, _payMehodView.frame.size.width, _payPalView.frame.size.height);
                            y=y+_payPalView.frame.size.height;
                            self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, y+3);
                            [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                            
                            break;
                        case 1:
                            _payUMoney_vew.hidden=NO;
                            _payUMoney_vew.frame=CGRectMake(0, y, _payMehodView.frame.size.width, _payUMoney_vew.frame.size.height);
                            y=y+_payUMoney_vew.frame.size.height;
                            self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, y+3);
                            [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                            break;
                        case 2:
                            CCAVenueView.hidden=NO;
                            CCAVenueView.frame=CGRectMake(0, y, _payMehodView.frame.size.width, CCAVenueView.frame.size.height);
                            y=y+CCAVenueView.frame.size.height;
                            self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, y+3);
                            [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                            break;
                        case 3:
                            _cashOnDeliveryView.hidden=NO;
                            _cashOnDeliveryView.frame=CGRectMake(0, y, _payMehodView.frame.size.width, _cashOnDeliveryView.frame.size.height);
                            y=y+_cashOnDeliveryView.frame.size.height;
                            self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, y+3);
                            [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                            break;
                        case 4:
                            _chequeMoneyView.hidden=NO;
                            _chequeMoneyView.frame=CGRectMake(0, y, _payMehodView.frame.size.width, _chequeMoneyView.frame.size.height);
                            y=y+_chequeMoneyView.frame.size.height;
                            self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, y+3);
                            [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                            break;
                        case 5:
                            _bankTransferView.hidden=NO;
                            _bankTransferInstruction.text=[[arrPayment objectAtIndex:i]valueForKey:@"instructions"];
                            _bankTransferInstruction.frame=CGRectMake(_bankTransferInstruction.frame.origin.x,_bankTransferInstruction.frame.origin.y, _bankTransferInstruction.frame.size.width, [self heightForText:[[arrPayment objectAtIndex:i]valueForKey:@"instructions"]]);
                            _bankTransferView.frame=CGRectMake(0, y, _payMehodView.frame.size.width, 33+[self heightForText:[[arrPayment objectAtIndex:i]valueForKey:@"instructions"]]);
                            y=y+_bankTransferView.frame.size.height;
                            self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, y+3);
                            [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                            break;
                        case 6:
                            _freeView.hidden=NO;
                            _freeView.frame=CGRectMake(0, y, _payMehodView.frame.size.width, _freeView.frame.size.height);
                            y=y+_freeView.frame.size.height;
                            self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, y+3);
                            [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                            break;
                            
                    }
                }
            }
        }
    }
    else
    {
        self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.payMehodView.frame.origin.y, self.payMehodView.frame.size.width, 50);
        [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
    }
}


- (CGFloat)heightForText:(NSString *)bodyText
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSParagraphStyleAttributeName: style};
    CGRect rect = [bodyText boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    return rect.size.height;
}


#pragma mark - TableView Delegate And DataSources

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblOrderSummary)
    {
        return 85;
    }
    else
    {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tblOrderSummary)
    {
        return [productArray count];
    }
    else
    {
        return [shippingArray count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblOrderSummary)
    {
        static NSString *CellIdentifier = @"PaymentCell";
        PaymentCell *cell = (PaymentCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        [cell.imgName TransformImage];
        [cell.productName TransformAlignLabel];
        [cell.QuantityLbl TransformAlignLabel];
        [cell.quantityNumber TransformAlignLabel];
        [cell.priceLbl TransformAlignLabel];
        [cell.price TransformAlignLabel];
        
        
        [cell.imgName sd_setImageWithURL:[NSURL URLWithString:[[productArray objectAtIndex:indexPath.row]valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"place_holder.png"]] ;
        
        cell.imgName.layer.cornerRadius = cell.imgName.frame.size.width/2;
        cell.imgName.clipsToBounds = YES;
        
        //    cell.imgBack.layer.cornerRadius = 4;
        //    cell.imgBack.clipsToBounds = YES;
        
        cell.productName.text = [NSString stringWithFormat:@"%@",[[productArray objectAtIndex:indexPath.row]valueForKey:@"name"]];
        
        NSString * str = [NSString stringWithFormat:@"%@ %@",model.currencySymbo ,[[productArray objectAtIndex:indexPath.row]valueForKey:@"price"]];
        
        cell.price.text = str;
        
        cell.quantityNumber.text = [NSString stringWithFormat:@"%@",[[[productArray objectAtIndex:indexPath.row]valueForKey:@"qty"]stringValue]];
        [cell.QuantityLbl setText:AMLocalizedString(@"tQuantity", nil)];
        [cell.priceLbl setText:AMLocalizedString(@"tPrice", nil)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"PaymentShippingCell";
        PaymentShippingCell *cell = (PaymentShippingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        [cell.lblPrice TransformAlignLeftLabel];
        [cell.lblCode TransformAlignLabel];
        
        
        NSString * str = [NSString stringWithFormat:@"%@ %@",model.currencySymbo ,[[shippingArray objectAtIndex:indexPath.row]valueForKey:@"price"]];
        cell.lblPrice.text = str;
        cell.lblCode.text = [NSString stringWithFormat:@"%@",[[shippingArray objectAtIndex:indexPath.row]valueForKey:@"method_title"] ];
        
        [cell.btnradio addTarget:self action:@selector(radioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [arrCheckBtn addObject:cell.btnradio];
        
        cell.btnradio.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


#pragma mark - Radio Button Action

-(void)radioBtnAction:(UIButton *)sender
{
     [self assignShippingMethod:[[shippingArray objectAtIndex:[sender tag]]valueForKey:@"code"]];
    
    for (int k=0; k<arrCheckBtn.count; k++)
    {
        UIButton *btn = [arrCheckBtn objectAtIndex:k];
        if (btn.tag == [sender tag]) {
            [btn setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
            isSelected = YES;
            
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
            
        }
    }
}

-(void)assignShippingMethod:(NSString *)shippingMethod
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        
        ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
        
        NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        
        NSString* str;
        
        if(str1.length!=0)
        {
            str=[NSString stringWithFormat:@"%@assignShiptoQuote?salt=%@&quote_id=%@&ship_method=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str1,shippingMethod,model.storeID,model.currencyID];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_assignShiptoQuote_Response:)];
        }
        else
        {
            [self removeLoadingView];
        }
    }
}




-(void)Get_assignShiptoQuote_Response:(NSDictionary *)response
{
    [self removeLoadingView];
    if([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else if([[[response valueForKey:@"returnCode"]valueForKey:@"result"]integerValue]==1)
    {
        [self setAmountView:[response valueForKey:@"response"]];
        if([[[response valueForKey:@"response"]valueForKey:@"tax"]length]!=0)
        {
            self.lblTaxes.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[response valueForKey:@"response"]valueForKey:@"tax"]];
        }
        
        if([[[response valueForKey:@"response"]valueForKey:@"discount"]
            isKindOfClass:[NSDictionary class]])
        {
            self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[[response valueForKey:@"response"]valueForKey:@"discount"] valueForKey:@"value"]];
        }
        
        self.lblDelivery.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[[response valueForKey:@"response"]valueForKey:@"ship_charge"] valueForKey:@"value"]];
        
        self.lblTotalOrder.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[[response valueForKey:@"response"]valueForKey:@"grandtotal"]valueForKey:@"value"]];
        
//        NSString * str = [[[[response valueForKey:@"response"]valueForKey:@"grandtotal"] valueForKey:@"value"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
//        float value1 = [str floatValue];
//        
//        float value2 = [[[[response valueForKey:@"response"]valueForKey:@"ship_charge"] valueForKey:@"value"]floatValue];
        
        self.lblSubtotal.text = [NSString stringWithFormat:@"%@ %.2f",model.currencySymbo,[[[[response valueForKey:@"response"]valueForKey:@"subtotal"] valueForKey:@"value"]floatValue]];
        
        [[NSUserDefaults standardUserDefaults]setValue:self.lblTotalOrder.text forKey:@"Subtotal"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    NSLog(@"response------%@",response);
}


-(void)Get_assignPaymenttoQuote_Response:(NSDictionary *)response
{
    [self removeLoadingView];
    if([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else if([[[response valueForKey:@"returnCode"]valueForKey:@"result"]integerValue]==1)
    {
        [self setAmountView:[response valueForKey:@"response"]];
        if([[[response valueForKey:@"response"]valueForKey:@"tax"]length]!=0)
        {
            self.lblTaxes.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[response valueForKey:@"response"]valueForKey:@"tax"]];
        }
        
        if([[[response valueForKey:@"response"]valueForKey:@"discount"]
            isKindOfClass:[NSDictionary class]])
        {
            self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[[response valueForKey:@"response"]valueForKey:@"discount"] valueForKey:@"value"]];
        }
        
        self.lblDelivery.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[[response valueForKey:@"response"]valueForKey:@"ship_charge"] valueForKey:@"value"]];
        
        self.lblTotalOrder.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[[response valueForKey:@"response"]valueForKey:@"grandtotal"]valueForKey:@"value"]];
        
        //        NSString * str = [[[[response valueForKey:@"response"]valueForKey:@"grandtotal"] valueForKey:@"value"] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        //        float value1 = [str floatValue];
        //
        //        float value2 = [[[[response valueForKey:@"response"]valueForKey:@"ship_charge"] valueForKey:@"value"]floatValue];
        
        self.lblSubtotal.text = [NSString stringWithFormat:@"%@ %.2f",model.currencySymbo,[[[[response valueForKey:@"response"]valueForKey:@"subtotal"] valueForKey:@"value"]floatValue]];
        
        [[NSUserDefaults standardUserDefaults]setValue:self.lblTotalOrder.text forKey:@"Subtotal"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    NSLog(@"response------%@",response);
}



#pragma mark- Helper Methods
-(void)setAmountView:(NSDictionary *)dict
{
    NSArray *arr = [NSArray arrayWithObjects:@"subtotal",@"discount",@"taxes",@"ship_charge",@"grandtotal",nil];
    subtotalLbl.hidden=YES;
    _lblSubtotal.hidden=YES;
    discountLbl.hidden=YES;
    _lblDiscount.hidden=YES;
    taxesLbl.hidden=YES;
    _lblTaxes.hidden=YES;
    deliveryLbl.hidden=YES;
    _lblDelivery.hidden=YES;
    orderTotalLBL.hidden=YES;
    _lblTotalOrder.hidden=YES;
    int y = 3;
    for (int i = 0; i<arr.count; i++)
    {
        for (NSString *params in dict)
        {
            if ([params isEqualToString:[arr objectAtIndex:i]])
            {
                switch (i)
                {
                    case 0:
                        subtotalLbl.hidden=NO;
                        _lblSubtotal.hidden=NO;
                        subtotalLbl.frame=CGRectMake(subtotalLbl.frame.origin.x, y, subtotalLbl.frame.size.width, subtotalLbl.frame.size.height);
                        _lblSubtotal.frame=CGRectMake(_lblSubtotal.frame.origin.x, y, _lblSubtotal.frame.size.width, _lblSubtotal.frame.size.height);
                        y=y+subtotalLbl.frame.size.height;
                        _amountDetailSubView.frame=CGRectMake(self.amountDetailSubView.frame.origin.x, self.amountDetailSubView.frame.origin.y, self.amountDetailSubView.frame.size.width, y+3);
                        _amountDetailView.frame=CGRectMake(self.amountDetailView.frame.origin.x, self.amountDetailView.frame.origin.y, self.amountDetailView.frame.size.width, _amountDetailSubView.frame.size.height+self.amountDetailSubView.frame.origin.y+10);
                        _amountDetailView.autoresizingMask = UIViewAutoresizingNone;

                        _payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.amountDetailView.frame.origin.y+self.amountDetailView.frame.size.height+10, self.payMehodView.frame.size.width, self.payMehodView.frame.size.height);
                        _payMehodView.autoresizingMask = UIViewAutoresizingNone;
                         [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                        break;
                    case 1:
                        discountLbl.hidden=NO;
                        _lblDiscount.hidden=NO;
                        discountLbl.frame=CGRectMake(discountLbl.frame.origin.x, y, discountLbl.frame.size.width, discountLbl.frame.size.height);
                        discountLbl.autoresizingMask = UIViewAutoresizingNone;
                        
                        _lblDiscount.frame=CGRectMake(_lblDiscount.frame.origin.x, y, _lblDiscount.frame.size.width, _lblDiscount.frame.size.height);
                        _lblDiscount.autoresizingMask = UIViewAutoresizingNone;
                        y=y+discountLbl.frame.size.height;
                        _amountDetailSubView.frame=CGRectMake(self.amountDetailSubView.frame.origin.x, self.amountDetailSubView.frame.origin.y, self.amountDetailSubView.frame.size.width, y+3);
                        _amountDetailView.frame=CGRectMake(self.amountDetailView.frame.origin.x, self.amountDetailView.frame.origin.y, self.amountDetailView.frame.size.width, _amountDetailSubView.frame.size.height+self.amountDetailSubView.frame.origin.y+10);
                        _amountDetailView.autoresizingMask = UIViewAutoresizingNone;

                        _payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.amountDetailView.frame.origin.y+self.amountDetailView.frame.size.height+y, self.payMehodView.frame.size.width, self.payMehodView.frame.size.height);
                        _payMehodView.autoresizingMask = UIViewAutoresizingNone;
                         [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                        break;
                    case 2:
                        taxesLbl.hidden=NO;
                        _lblTaxes.hidden=NO;
                        taxesLbl.frame=CGRectMake(taxesLbl.frame.origin.x, y, taxesLbl.frame.size.width, taxesLbl.frame.size.height);
                        _lblTaxes.frame=CGRectMake(_lblTaxes.frame.origin.x, y, _lblTaxes.frame.size.width, _lblTaxes.frame.size.height);
                        taxesLbl.autoresizingMask = UIViewAutoresizingNone;
                        _lblTaxes.autoresizingMask = UIViewAutoresizingNone;

                        y=y+taxesLbl.frame.size.height;
                        self.amountDetailSubView.frame=CGRectMake(self.amountDetailSubView.frame.origin.x, self.amountDetailSubView.frame.origin.y, self.amountDetailSubView.frame.size.width, y+3);
                        self.amountDetailView.frame=CGRectMake(self.amountDetailView.frame.origin.x, self.amountDetailView.frame.origin.y, self.amountDetailView.frame.size.width, _amountDetailSubView.frame.size.height+self.amountDetailSubView.frame.origin.y+10);
                        _amountDetailView.autoresizingMask = UIViewAutoresizingNone;

                        self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.amountDetailView.frame.origin.y+self.amountDetailView.frame.size.height+10, self.payMehodView.frame.size.width, self.payMehodView.frame.size.height);
                        _payMehodView.autoresizingMask = UIViewAutoresizingNone;
                         [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                        break;
                    case 3:
                        deliveryLbl.hidden=NO;
                        _lblDelivery.hidden=NO;
                        deliveryLbl.frame=CGRectMake(deliveryLbl.frame.origin.x, y, deliveryLbl.frame.size.width, deliveryLbl.frame.size.height);
                        _lblDelivery.frame=CGRectMake(_lblDelivery.frame.origin.x, y, _lblDelivery.frame.size.width, _lblDelivery.frame.size.height);
                        deliveryLbl.autoresizingMask = UIViewAutoresizingNone;
                        _lblDelivery.autoresizingMask = UIViewAutoresizingNone;
                        
                        y=y+deliveryLbl.frame.size.height;
                        self.amountDetailSubView.frame=CGRectMake(self.amountDetailSubView.frame.origin.x, self.amountDetailSubView.frame.origin.y, self.amountDetailSubView.frame.size.width, y+3);
                        self.amountDetailView.frame=CGRectMake(self.amountDetailView.frame.origin.x, self.amountDetailView.frame.origin.y, self.amountDetailView.frame.size.width, _amountDetailSubView.frame.size.height+self.amountDetailSubView.frame.origin.y+10);
                        _amountDetailView.autoresizingMask = UIViewAutoresizingNone;

                        self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.amountDetailView.frame.origin.y+self.amountDetailView.frame.size.height+10, self.payMehodView.frame.size.width, self.payMehodView.frame.size.height);
                        _payMehodView.autoresizingMask = UIViewAutoresizingNone;
                         [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                        break;
                    case 4:
                        orderTotalLBL.hidden=NO;
                        _lblTotalOrder.hidden=NO;
                        orderTotalLBL.frame=CGRectMake(orderTotalLBL.frame.origin.x, y, orderTotalLBL.frame.size.width, orderTotalLBL.frame.size.height);
                        _lblTotalOrder.frame=CGRectMake(_lblTotalOrder.frame.origin.x, y, _lblTotalOrder.frame.size.width, _lblTotalOrder.frame.size.height);
                        orderTotalLBL.autoresizingMask = UIViewAutoresizingNone;
                        _lblTotalOrder.autoresizingMask = UIViewAutoresizingNone;
                        y=y+orderTotalLBL.frame.size.height;
                        _amountDetailSubView.frame=CGRectMake(self.amountDetailSubView.frame.origin.x, self.amountDetailSubView.frame.origin.y, self.amountDetailSubView.frame.size.width, y+3);
                        _amountDetailView.frame=CGRectMake(self.amountDetailView.frame.origin.x, self.amountDetailView.frame.origin.y, self.amountDetailView.frame.size.width, _amountDetailSubView.frame.size.height+self.amountDetailSubView.frame.origin.y+10);
                        _amountDetailView.autoresizingMask = UIViewAutoresizingNone;
                        self.payMehodView.frame=CGRectMake(self.payMehodView.frame.origin.x, self.amountDetailView.frame.origin.y+self.amountDetailView.frame.size.height+10, self.payMehodView.frame.size.width, self.payMehodView.frame.size.height);
                        _payMehodView.autoresizingMask = UIViewAutoresizingNone;
                         [_scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, _payMehodView.frame.origin.y+_payMehodView.frame.size.height+100)];
                        break;
                }
            }
        }
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


#pragma mark - Memory Method

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Back Button Action

- (IBAction)backBtn_Action:(id)sender
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

#pragma mark - payment Button Action

- (IBAction)paymentSelectMethod_Action:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    
    if(btn.tag == 1)
    {
        typePayment = @"paypal_express";
        
        [self.btnTag1 setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
        
        [self.btnTag2 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag3 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag4 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag5 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag6 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
         [btnTag7 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
    }
    else if(btn.tag == 2)
    {
        typePayment = @"payucheckout_shared";
        
        
        [self.btnTag2 setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
        
        [self.btnTag1 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag3 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag4 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag5 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag6 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        [btnTag7 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
    }
    else if(btn.tag == 7)
    {
        typePayment = @"ccavenuepay";
        
        
        [self.btnTag2 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag1 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag3 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag4 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag5 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag6 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        [btnTag7 setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
    }
    else if(btn.tag == 3)
    {
        typePayment = @"cashondelivery";
        
        [self.btnTag3 setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
        
        [self.btnTag1 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag2 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag4 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag5 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag6 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
         [btnTag7 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
    }
    
    else if(btn.tag == 4)
    {
        typePayment = @"checkmo";
        
        [self.btnTag4 setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
        
        [self.btnTag1 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag2 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag3 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag5 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag6 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
         [btnTag7 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
    }
    else if(btn.tag == 5)
    {
        typePayment = @"banktransfer";
        
        [self.btnTag5 setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
        
        [self.btnTag1 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag2 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag3 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag4 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag6 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
         [btnTag7 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
    }
    else if(btn.tag == 6)
    {
        typePayment = @"free";
        
        [self.btnTag6 setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
        
        [self.btnTag1 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag2 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag3 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag4 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
        
        [self.btnTag5 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
         [btnTag7 setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
    }
    
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        
        ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
        
        NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        
        NSString* str;
        
        if(str1.length!=0)
        {
            str=[NSString stringWithFormat:@"%@assignPaymentToQuote?salt=%@&quote_id=%@&pay_method=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str1,typePayment,model.storeID,model.currencyID];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_assignPaymenttoQuote_Response:)];
        }
        else
        {
            [self removeLoadingView];
        }
    }

    
    
}

#pragma mark - Change Button Action

- (IBAction)changeBtn_Action:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Payment api

-(void)PaymentTypeApi:(NSString *)PaymentMethod
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
        
        [self addLoadingView];
        
        ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
        
        NSString * quote_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        
        NSString * device_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"];
        
        NSString * email;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES)
        {
            email = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
        }
        else
        {
            email = [[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
        }
        
        NSString* str;
        
        if([typePayment isEqualToString:@"paypal_express"])
        {
            PayPallView * obj = [[PayPallView alloc]initWithNibName:@"PayPallView" bundle:nil];
            obj.delegate = self;
            [self.navigationController pushViewController:obj animated:YES];
        }
        else
        {
            if(quote_id.length!=0)
            {
                NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
                if ([str5 isEqualToString:@"(null)"])
                {
                    str5=@"";
                }
                if(device_id.length!=0)
                {
                    str=[NSString stringWithFormat:@"%@placeOrder?salt=%@&quote_id=%@&device_type=%@&device_id=%@&pay_method=%@&cust_id=%@&email=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,quote_id,@"Iphone",device_id,PaymentMethod,str5,email,model.storeID,model.currencyID];
                }
                else
                {
                    str=[NSString stringWithFormat:@"%@placeOrder?salt=%@&quote_id=%@&device_type=%@&device_id=%@&pay_method=%@&cust_id=%@&email=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,quote_id,@"Iphone",@"3f3e9c4864f073e974a65dd97b1879c647d81e1976f2f270083274e80a4dae3c",PaymentMethod,str5,email,model.storeID,model.currencyID];
                    
                }
            }
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Payment_Response:)];
        }
    }
}
-(void)Get_Payment_Response:(NSDictionary *)response
{
    [self removeLoadingView];
    NSLog(@"response-------%@",response);
    
    if([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        NSString *orderId = [response valueForKey:@"response"];
        if ([typePayment isEqualToString:@"payucheckout_shared"])
        {
            PayUUIPaymentUIWebViewController * obj = [[PayUUIPaymentUIWebViewController alloc]initWithNibName:@"PayUUIPaymentUIWebViewController" bundle:nil];
            obj.amount = [[_lblTotalOrder.text stringByReplacingOccurrencesOfString:model.currencySymbo withString:@""]stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            _billingName=[_billingName stringByReplacingOccurrencesOfString:@" " withString:@""];
            obj.productInfo = @"Softprodigy_product";
            obj.firstname = _billingName;
            obj.email = _email;
            obj.phone = _billingPhone;
            obj.txnid1 = orderId;
            obj.key = [keysalt valueForKey:@"key"];
            obj.Salt = [keysalt valueForKey:@"salt"];
            obj.Surl=[keysalt valueForKey:@"success_url"];
            obj.Furl=[keysalt valueForKey:@"failure_url"];
            if ([[keysalt valueForKey:@"sandbox"]intValue]==0)
            {
                obj.baseUrl=@"https://secure.payu.in";
            }
            else
            {
                obj.baseUrl=@"https://test.payu.in";
            }
            obj.delegate=self;
            [self.navigationController pushViewController:obj animated:YES];
            
        }
        else if ([typePayment isEqualToString:@"ccavenuepay"])
        {
            
//            CCAVenueVC * obj = [[CCAVenueVC alloc]initWithNibName:@"CCAVenueVC" bundle:nil];
//            obj.amount = [[_lblTotalOrder.text stringByReplacingOccurrencesOfString:model.currencySymbo withString:@""]stringByReplacingOccurrencesOfString:@"," withString:@""];
//            
//       
//            [self.navigationController pushViewController:obj animated:YES];
            CCAVenueVC* controller = [[CCAVenueVC alloc]initWithNibName:@"CCAVenueVC" bundle:nil];
            
            controller.accessCode = [CCAVenueDic valueForKey:@"accesscode"];
            controller.merchantId = [CCAVenueDic valueForKey:@"merchantid"];
            controller.amount = [[_lblTotalOrder.text stringByReplacingOccurrencesOfString:model.currencySymbo withString:@""]stringByReplacingOccurrencesOfString:@"," withString:@""];
            controller.currency = model.currencySymbo;
            controller.orderId = [response valueForKey:@"response"];
            controller.redirectUrl = [CCAVenueDic valueForKey:@"success_url"];
            controller.cancelUrl = [CCAVenueDic valueForKey:@"failure_url"];
            controller.rsaKey = [CCAVenueDic valueForKey:@"encrkey"];
            
            //controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController pushViewController:controller animated:YES];


        }
        else
        {
            [self coverMethod:[response valueForKey:@"response"]];
            NSLog(@"response------Check---%@",response);
        }
        
    }
    else if ([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"fail"])
    {
        
        NSString *str = [response valueForKey:@"response"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
}


-(void)coverMethod:(NSString *)str
{
    self.coverView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    
    self.lblOrderID.text = str;
    
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [self.view addSubview:self.coverView];
    
    model.totalCount = 0;
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)model.totalCount] forKey:@"quote_count"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
    
    [self.view bringSubviewToFront:self.coverView];
}



#pragma mark - Cancel And PayNow Button Action

- (IBAction)cancelAndPlaceNowBtnAction:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        //cancelbutton
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        _btnPlaceNow.enabled=NO;
        // -------------------------- Reachability --------------------//
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            NSLog(tNoInternet);
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            _btnPlaceNow.enabled=YES;
            
            [alert show];
        }
        else
        {
            NSLog(@"There IS internet connection");
            NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
            
            NSString* str;
            
            if(str1.length!=0)
            {
                str=[NSString stringWithFormat:@"%@confirmCart?salt=%@&quote_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str1,model.storeID,model.currencyID];
                ApiClasses *obj_apiClass=[[ApiClasses alloc]init];
                [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Confirm_Response:)];
            }
            else
            {
                [self removeLoadingView];
                _btnPlaceNow.enabled=YES;
            }
        }
    }
}


#pragma mark Confirm Response

-(void)Get_Confirm_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    _btnPlaceNow.enabled=YES;
    
    if (![[[responseDict valueForKey:@"response"] valueForKey:@"isSalable"]isEqual:[NSNull null]])
    {
        if ([[[responseDict valueForKey:@"response"]valueForKey:@"isSalable"]intValue]==1)
        {
            if (isVirtual==0 && shippingArray.count==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:AMLocalizedString(@"tYourordercannotbecompleted", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil ];
                [alert show];
            }
            else if(isVirtual==0)
            {
                if(isSelected == YES && typePayment.length!=0)
                {
                    [self PaymentTypeApi:typePayment];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:AMLocalizedString(@"tPleaseselectshippingandpaymentmethods", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil ];
                    [alert show];
                }
                
            }
            else
            {
                if (typePayment.length!=0)
                {
                    [self PaymentTypeApi:typePayment];
                }
            }
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleaseremoveproductswhichareoutofstock", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            alert.tag=99;
        }
    }
}

#pragma mark alertView delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==99)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[AddToCartView class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }
}


#pragma mark - Custom Delegate Method

-(void)methodCall:(NSString *)str
{
    [self coverMethod:str];
}
-(void)methodCall1:(NSString *)str
{
    [self coverMethod:str];
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
