//
//  BillingAndShippingView.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/1/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "BillingAndShippingView.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "ModelClass.h"
#import "CountryCell.h"
#import "PaymentView.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"
#import "IQKeyboardManager.h"

@interface BillingAndShippingView ()
{
    BOOL clicked;
    BOOL selected;
    BOOL selectedSh;
    ModelClass *model;
    
    ApiClasses *obj_apiClass;
    NSDictionary *dictPlist;
    
    NSMutableArray *arrcountry_id;
    NSMutableArray *arrIso2_code;
    NSMutableArray *arrIso3_code;
    NSMutableArray *arrName;
    UIView *coverView;
    
    NSString *selectedValue;
    NSString *selectedRegion;
    NSString *countryIDBilling;
    NSString *countryIDShipping;
    NSString *stateIDBilling;
    NSString *stateIDShipping;
    
    long selectCountry1;
    long selectCountry2;
    long selectCountry3;
    long selectCountry4;
    
    BOOL firstCountry;
    BOOL firstCountrySh;
    BOOL firstRegion;
    BOOL firstRegionSh;
    BOOL oneCountry;
    NSMutableDictionary *Address;
}
@end

@implementation BillingAndShippingView
@synthesize billingView,borderAddress1,borderAddress1Sh,borderAddress2,borderAddress2Sh,borderCountry,borderCountrySh,borderEmail,borderEmailSh,borderFirstname,borderFirstnameSh,borderLastName,borderLastNameSh,borderPhone,borderPhoneSh,borderPostCode,borderPostCodeSh,borderSelect,borderSelectSh,borderState,borderStateSh,borderTown,borderTownSh,scrollView;

- (void)viewDidLoad
{
    Address = [[NSMutableDictionary alloc]init];
    Address = [[NSUserDefaults standardUserDefaults]objectForKey:@"Temp_Address"];
    NSLog(@"%@",Address);
   // [[NSUserDefaults standardUserDefaults]setObject:Address forKey:@"Temp_Address"];
    
    [[IQKeyboardManager sharedManager] setEnable:true];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:false];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20.0];
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [billingLbl TransformLabel];
    [_country TransformTextField];
    [_countrySh TransformTextField];
    [_firstname TransformTextField];
    [_firstnameSh TransformTextField];
    [_lastName TransformTextField];
    [_lastNameSh TransformTextField];
    [_address1 TransformTextField];
    [_address1Sh TransformTextField];
    [_address2 TransformTextField];
    [_address2Sh TransformTextField];
    [_town TransformTextField];
    [_townSh TransformTextField];
    [_state TransformTextField];
    [_stateSh TransformTextField];
    [_postCode TransformTextField];
    [_postCodeSh TransformTextField];
    [_phone TransformTextField];
    [_phoneSh TransformTextField];
    [_email TransformTextField];
    [_emailSh TransformTextField];
    [shippingLbl TransformLabel];
    [_labelSameAddress TransformAlignLabel];
    [_labelCountry TransformAlignLabel];
    [_labelCountrySh TransformAlignLabel];
    [_labelFirstname TransformAlignLabel];
    [_labelFirstnameSh TransformAlignLabel];
    [_labelLastName TransformAlignLabel];
    [_labelLastNameSh TransformAlignLabel];
    [_labelAddress1 TransformAlignLabel];
    [_labelAddress1Sh TransformAlignLabel];
    [_labelAddress2 TransformAlignLabel];
    [_labelAddress2Sh TransformAlignLabel];
    [_labelTown TransformAlignLabel];
    [_labelTownSh TransformAlignLabel];
    [_labelState TransformAlignLabel];
    [_labelStateSh TransformAlignLabel];
    [_labelPostCode TransformAlignLabel];
    [_labelPostCodeSh TransformAlignLabel];
    [_labelPhone TransformAlignLabel];
    [_labelPhoneSh TransformAlignLabel];
    [_labelEmail TransformAlignLabel];
    [_labelEmailSh TransformAlignLabel];
    [_placeOrderBorder TransformButton];
    [_checkbutton TransformButton];
    
    [super viewDidLoad];
    obj_apiClass= [[ApiClasses alloc]init];
    
    //word change
    
    [billingLbl setText:AMLocalizedString(@"tBillingDetails", nil)];
    [shippingLbl setText:AMLocalizedString(@"tShippingDetails", nil)];
    [_labelSameAddress setText:AMLocalizedString(@"tSameasMyBillingAddress", nil)];
    [_country setPlaceholder:AMLocalizedString(@"tSelectCountry", nil)];
    [_countrySh setPlaceholder:AMLocalizedString(@"tSelectCountry", nil)];
    [_firstname setPlaceholder:AMLocalizedString(@"tFirstName", nil)];
    [_firstnameSh setPlaceholder:AMLocalizedString(@"tFirstName", nil)];
    [_lastName setPlaceholder:AMLocalizedString(@"tLastName", nil)];
    [_lastNameSh setPlaceholder:AMLocalizedString(@"tLastName", nil)];
    [_address1 setPlaceholder:AMLocalizedString(@"tAddressLine1", nil)];
    [_address1Sh setPlaceholder:AMLocalizedString(@"tAddressLine1", nil)];
    [_address2 setPlaceholder:AMLocalizedString(@"tAddressLine2", nil)];
    [_address2Sh setPlaceholder:AMLocalizedString(@"tAddressLine2", nil)];
    [_town setPlaceholder:AMLocalizedString(@"tTownCity", nil)];
    [_townSh setPlaceholder:AMLocalizedString(@"tTownCity", nil)];
    [_state setPlaceholder:AMLocalizedString(@"tStateRegion", nil)];
    [_stateSh setPlaceholder:AMLocalizedString(@"tStateRegion", nil)];
    [_postCode setPlaceholder:AMLocalizedString(@"tPostcodeZip", nil)];
    [_postCodeSh setPlaceholder:AMLocalizedString(@"tPostcodeZip", nil)];
    [_phone setPlaceholder:AMLocalizedString(@"tPhone", nil)];
    [_phoneSh setPlaceholder:AMLocalizedString(@"tPhone", nil)];
    [_email setPlaceholder:AMLocalizedString(@"tEMailAddress", nil)];
    [_emailSh setPlaceholder:AMLocalizedString(@"tEMailAddress", nil)];
    
    [_labelCountry setText:AMLocalizedString(@"tSelectCountry", nil)];
    [_labelCountrySh setText:AMLocalizedString(@"tSelectCountry", nil)];
    [_labelFirstname setText:AMLocalizedString(@"tFirstName", nil)];
    [_labelFirstnameSh setText:AMLocalizedString(@"tFirstName", nil)];
    [_labelLastName setText:AMLocalizedString(@"tLastName", nil)];
    [_labelLastNameSh setText:AMLocalizedString(@"tLastName", nil)];
    [_labelAddress1 setText:AMLocalizedString(@"tAddressLine1", nil)];
    [_labelAddress1Sh setText:AMLocalizedString(@"tAddressLine1", nil)];
    [_labelAddress2 setText:AMLocalizedString(@"tAddressLine2", nil)];
    [_labelAddress2Sh setText:AMLocalizedString(@"tAddressLine2", nil)];
    [_labelTown setText:AMLocalizedString(@"tTownCity", nil)];
    [_labelTownSh setText:AMLocalizedString(@"tTownCity", nil)];
    [_labelState setText:AMLocalizedString(@"tStateRegion", nil)];
    [_labelStateSh setText:AMLocalizedString(@"tStateRegion", nil)];
    [_labelPostCode setText:AMLocalizedString(@"tPostcodeZip", nil)];
    [_labelPostCodeSh setText:AMLocalizedString(@"tPostcodeZip", nil)];
    [_labelPhone setText:AMLocalizedString(@"tPhone", nil)];
    [_labelPhoneSh setText:AMLocalizedString(@"tPhone", nil)];
    [_labelEmail setText:AMLocalizedString(@"tEMailAddress", nil)];
    [_labelEmailSh setText:AMLocalizedString(@"tEMailAddress", nil)];
    
    [_placeOrderBorder setTitle:AMLocalizedString(@"tPlaceOrder", nil) forState:UIControlStateNormal];
    
    //scrollview
    [scrollView setFrame:CGRectMake(0, 55+7, 320,800-7)];
    //    [scrollView setContentSize:CGSizeMake(320,960)];
    [self.view addSubview:scrollView];
    
    [self setBorder:borderCountry];
    [self setBorder:borderCountrySh];
    [self setBorder:borderFirstname];
    [self setBorder:borderFirstnameSh];
    [self setBorder:borderLastName];
    [self setBorder:borderLastNameSh];
    [self setBorder:borderAddress1];
    [self setBorder:borderAddress1Sh];
    [self setBorder:borderAddress2];
    [self setBorder:borderAddress2Sh];
    [self setBorder:borderTown];
    [self setBorder:borderTownSh];
    [self setBorder:borderState];
    [self setBorder:borderStateSh];
    [self setBorder:borderPostCode];
    [self setBorder:borderPostCodeSh];
    [self setBorder:borderPhone];
    [self setBorder:borderPhoneSh];
    [self setBorder:borderEmail];
    [self setBorder:borderEmailSh];
    
    [self setButtonBorder:borderSelect];
    [self setButtonBorder:borderSelectSh];
    [self setButtonBorder:self.placeOrderBorder];
    [self setButtonBorder:self.checkbutton];
    // Do any additional setup after loading the view from its nib.
    
    //hidden views
    [self.shoppingView setHidden:YES];
    borderStateSh.hidden=YES;
    self.borderState.hidden=YES;
    [self setFrames:0];
    
    model=[ModelClass sharedManager];
    selectedValue=[[NSString alloc]init];
    selectedRegion=[[NSString alloc]init];
    countryIDBilling=[[NSString alloc]init];
    countryIDShipping=[[NSString alloc]init];
    stateIDBilling=[[NSString alloc]init];
    stateIDShipping=[[NSString alloc]init];
    
    //    //label hidden
    //    self.labelCountry.hidden=NO;
    //    _country.text=@"India";
    //    countryIDBilling=@"IN";
    //
    //    self.labelCountrySh.hidden=NO;
    //    _countrySh.text=@"India";
    //    countryIDShipping=@"IN";
    self.labelCountry.hidden=YES;
    self.labelCountrySh.hidden=YES;
    self.labelFirstname.hidden=YES;
    self.labelFirstnameSh.hidden=YES;
    self.labelLastName.hidden=YES;
    self.labelLastNameSh.hidden=YES;
    self.labelAddress1.hidden=YES;
    self.labelAddress1Sh.hidden=YES;
    self.labelAddress2.hidden=YES;
    self.labelAddress2Sh.hidden=YES;
    self.labelTown.hidden=YES;
    self.labelTownSh.hidden=YES;
    self.labelState.hidden=YES;
    self.labelStateSh.hidden=YES;
    self.labelEmailSh.hidden=YES;
    self.labelEmail.hidden=YES;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Pincode"]!=nil)
    {
       // self.labelPostCode.hidden=NO;
        _postCode.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Pincode"];
       // self.labelPostCodeSh.hidden=NO;
        _postCodeSh.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Pincode"];
    }
    else
    {
        self.labelPostCode.hidden=YES;
        self.labelPostCodeSh.hidden=YES;
    }
    
    self.labelPhone.hidden=YES;
    self.labelPhoneSh.hidden=YES;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES)
    {
        //self.labelEmail.hidden=NO;
       // self.labelEmailSh.hidden=NO;
        self.email.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
        self.emailSh.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
    }
    else
    {
        self.labelEmail.hidden=YES;
        self.labelEmailSh.hidden=YES;
    }
    
    //done button on number keypad
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithTitle:tNext style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)]];
    [numberToolbar sizeToFit];
   // self.phone.inputAccessoryView = numberToolbar;
   // self.phoneSh.inputAccessoryView = numberToolbar;
   // self.postCode.inputAccessoryView = numberToolbar;
   // self.postCodeSh.inputAccessoryView = numberToolbar;
    
    
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        [self alertViewMethod:AMLocalizedString(@"tNoInternet", nil)];
        
    }
    else
    {
        NSLog(@"There IS internet connection"); //API call
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            // Perform long running process
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self addLoadingView];
                [self getCountryList];
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"login"])
                {
                    [self getUserAddress];
                }
            });
        });
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //change color
    
    [_placeOrderBorder setBackgroundColor:model.buttonColor];
    [_btnCountry setBackgroundColor:model.blueClr];
    [_btnCountry2 setBackgroundColor:model.blueClr];
    [_topView setBackgroundColor:model.themeColor];
    [billingLbl setTextColor:[UIColor whiteColor]];
    [shippingLbl setTextColor:[UIColor whiteColor]];
    
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"BillingAndShippingView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    }
   }
-(void)viewDidDisappear:(BOOL)animated
{
 [[IQKeyboardManager sharedManager] setEnable:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----DoneWithNumberPad-----

-(void)doneWithNumberPad:(UITextField*)txtfld
{
    [self.view endEditing:YES];
    //    [self textFieldShouldReturn:nil];
    
}

#pragma mark Set Frames
-(void)setFrames:(int)x
{
    self.shippingHead.frame=CGRectMake(8, 452+x, 300, 34);
    self.checkbutton.frame=CGRectMake(17, 505+x, 20, 20);
    self.labelSameAddress.frame=CGRectMake(51, 504+x, 234, 21);
    self.shoppingView.frame=CGRectMake(10, 540+x, 300, 438);
    if (x==0)
    {
        self.shiftView.frame=CGRectMake(0, 292+x, 300, 86);
        self.shiftViewSh.frame=CGRectMake(0, 292+x, 300, 86);
        self.placeOrderBorder.frame = CGRectMake(86, 540, 124, 34);
        [scrollView setContentSize:CGSizeMake(320,960)];
    }
    else
    {
        self.shiftView.frame=CGRectMake(0, 292+10+x, 300, 86);
        if (clicked==NO)
        {
            if (selected==YES && selectedSh==NO)
            {
                self.shiftViewSh.frame=CGRectMake(0, 292, 300, 86);
                self.placeOrderBorder.frame = CGRectMake(86, 502+x+x, 124, 34);
                [scrollView setContentSize:CGSizeMake(320,960+x)];
                
            }
            else if (selected==YES)
            {
                self.shiftViewSh.frame=CGRectMake(0, 292+10+x, 300, 86);
                self.placeOrderBorder.frame = CGRectMake(86, 502+x+x, 124, 34);
                [scrollView setContentSize:CGSizeMake(320,960+x)];
            }
            else
            {
                self.shiftViewSh.frame=CGRectMake(0, 292+10+x, 300, 86);
                self.placeOrderBorder.frame = CGRectMake(86, 502+x, 124, 34);
                [scrollView setContentSize:CGSizeMake(320,922+x)];
            }
        }
        else
        {
            if (selectedSh==YES)
            {
                [scrollView setContentSize:CGSizeMake(320,1400+x)];
                self.placeOrderBorder.frame = CGRectMake(86, 1020, 124, 34);
            }
            else
            {
                [scrollView setContentSize:CGSizeMake(320,1370+x)];
                self.placeOrderBorder.frame = CGRectMake(86, 930+x, 124, 34);
            }
        }
    }
}

-(void)setFramesSh
{
    if (selected==YES)
    {
        self.shiftViewSh.frame=CGRectMake(0, 340, 300, 86);
        self.placeOrderBorder.frame = CGRectMake(86, 1020, 124, 34);
        [scrollView setContentSize:CGSizeMake(320,1450)];
    }
    else
    {
        self.shiftViewSh.frame=CGRectMake(0, 340, 300, 86);
        self.placeOrderBorder.frame = CGRectMake(86, 988, 124, 34);
        [scrollView setContentSize:CGSizeMake(320,1410)];
    }
    
}

#pragma mark Get user address

-(void)getUserAddress
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        [self alertViewMethod:AMLocalizedString(@"tNoInternet", nil)];
    }
    else
    {
        NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
        if ([str5 isEqualToString:@"(null)"])
        {
            str5=@"";
        }
        NSLog(@"There IS internet connection");
        NSString *str=[NSString stringWithFormat:@"%@getuserAddress?salt=%@&cust_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,model.storeID,model.currencyID];
        
        //---------------- API----------------------
        
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_API11_Response:)];
    }
    
}

-(void)Get_API11_Response:(NSDictionary*)responseDict
{
    NSLog(@"%@",responseDict);
    
    [self removeLoadingView];
    if ([[responseDict valueForKey:@"response"]isKindOfClass:[NSDictionary class]])
    {
        
        if ([[responseDict valueForKey:@"response"]count]!=0)
        {
            if ([[[responseDict valueForKey:@"response"]valueForKey:@"billing"]count]!=0)
            {
                
                NSDictionary *arrayBilling=[[[responseDict valueForKey:@"response"]valueForKey:@"billing"]objectAtIndex:0];
                
//                self.labelCountry.hidden=NO;
//                self.labelCountrySh.hidden=NO;
//                self.labelFirstname.hidden=NO;
//                self.labelFirstnameSh.hidden=NO;
//                self.labelLastName.hidden=NO;
//                self.labelLastNameSh.hidden=NO;
//                self.labelAddress1.hidden=NO;
//                self.labelAddress1Sh.hidden=NO;
//                self.labelAddress2.hidden=NO;
//                self.labelAddress2Sh.hidden=NO;
//                self.labelTown.hidden=NO;
//                self.labelTownSh.hidden=NO;
//                self.labelState.hidden=NO;
//                self.labelStateSh.hidden=NO;
//                self.labelPostCode.hidden=NO;
//                self.labelPostCodeSh.hidden=NO;
//                self.labelPhone.hidden=NO;
//                self.labelPhoneSh.hidden=NO;
//                self.labelEmailSh.hidden=NO;
                
                if ([[[responseDict valueForKey:@"response"] valueForKey:@"ship_to_same"]intValue]==1)
                {
                    
                    self.country.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    countryIDBilling=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    [[NSUserDefaults standardUserDefaults]setValue:countryIDBilling forKey:@"selectCountry1"];
                    firstCountry=YES;
                    self.firstname.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"firstname"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.lastName.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"lastname"]] stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.address1.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"street"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.address2.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"region"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.state.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"region_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.town.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"city"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.postCode.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"postcode"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.phone.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"telephone"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    
                    
                    // shipping view
                    
                    self.countrySh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    countryIDShipping=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    [[NSUserDefaults standardUserDefaults]setValue:countryIDShipping forKey:@"selectCountry2"];
                    firstCountrySh=YES;
                    self.firstnameSh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"firstname"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.lastNameSh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"lastname"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.address1Sh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"street"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.address2Sh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"region"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.stateSh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"region_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.townSh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"city"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.postCodeSh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"postcode"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.phoneSh.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"telephone"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    
                }
                else
                {
                    self.country.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    countryIDBilling=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    [[NSUserDefaults standardUserDefaults]setValue:countryIDBilling forKey:@"selectCountry1"];
                    firstCountry=YES;
                    self.firstname.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"firstname"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.lastName.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"lastname"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.address1.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"street"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.address2.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"region"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.state.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"region_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.town.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"city"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.postCode.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"postcode"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    self.phone.text=[[[NSString stringWithFormat:@"%@",[arrayBilling valueForKey:@"telephone"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                    //                self.email.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
                    
                    // shipping view
                    
                    if([[[responseDict valueForKey:@"response"]valueForKey:@"shipping"]count]!=0)
                    {
                        NSArray *arrayShipping=[[[responseDict valueForKey:@"response"]valueForKey:@"shipping"]objectAtIndex:0];
                        self.countrySh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        countryIDShipping=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"country_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        [[NSUserDefaults standardUserDefaults]setValue:countryIDShipping forKey:@"selectCountry2"];
                        firstCountrySh=YES;
                        self.firstnameSh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"firstname"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        self.lastNameSh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"lastname"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        self.address1Sh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"street"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        self.address2Sh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"region"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        self.stateSh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"region_id"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        self.townSh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"city"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        self.postCodeSh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"postcode"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        self.phoneSh.text=[[[NSString stringWithFormat:@"%@",[arrayShipping valueForKey:@"telephone"]]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
                        
                        //                self.emailSh.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
                    }
                }
            }
            else
            {
                if(Address != nil)
                {
                     // NSString *str=[NSString stringWithFormat:@"%@setQuoteAddress?salt=%@&quote_id=%@&use_for_shipping=0&firstname=%@&lastname=%@&street=%@&city=%@&region=%@&zip=%@&country_id=%@&phone=%@&fax=&email=%@&s_firstname=%@&s_lastname=%@&s_street=%@&s_city=%@&s_region=%@&s_zip=%@&s_country_id=%@&s_phone=%@&s_fax=&s_email=%@&cstore=%@&ccurrency=%@"
                    
                    self.country.text=[Address valueForKey:@"country_id"];
                    countryIDBilling=[Address valueForKey:@"country_id_value"];                    self.firstname.text=[Address valueForKey:@"firstname"];
                    self.lastName.text=[Address valueForKey:@"lastname"];
                    self.address1.text=[Address valueForKey:@"address1"];
                    self.address2.text=[Address valueForKey:@"address2"];
                    self.state.text=[Address valueForKey:@"region"];
                    stateIDBilling = [Address valueForKey:@"region_value"];
                    self.town.text=[Address valueForKey:@"city"];
                    self.postCode.text=[Address valueForKey:@"zip"];
                    self.phone.text=[Address valueForKey:@"phone"];
                    
                    
                    // shipping view
                    
                    self.countrySh.text=[Address valueForKey:@"s_country_id"];
                    countryIDShipping=[Address valueForKey:@"s_country_id_value"];                    self.firstnameSh.text=[Address valueForKey:@"s_firstname"];
                    self.lastNameSh.text=[Address valueForKey:@"s_lastname"];
                    self.address1Sh.text=[Address valueForKey:@"s_address1"];
                    self.address2Sh.text=[Address valueForKey:@"s_address2"];
                    self.stateSh.text=[Address valueForKey:@"s_region"];
                                     stateIDShipping = [Address valueForKey:@"s_region_value"];
                    self.townSh.text=[Address valueForKey:@"s_city"];
                    self.postCodeSh.text=[Address valueForKey:@"s_zip"];
                    self.phoneSh.text=[Address valueForKey:@"s_phone"];
                    

                    
                
                    NSLog(@"Success");
                }
                else
                {
                 NSLog(@"Failure");
                }
            
            
            
            }
        }
    }
    else   if ([[responseDict valueForKey:@"response"]isKindOfClass:[NSArray class]])
    {
        NSLog(@"%@",responseDict);
        NSError *error;
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory=[paths objectAtIndex:0];
        NSString *path=[documentDirectory stringByAppendingPathComponent:@"country.plist"];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path])
        {
            NSString *bundle=[[NSBundle mainBundle]pathForResource:@"country" ofType:@"plist"];
            [fileManager copyItemAtPath:bundle toPath:path error:&error];
        }
        
        if ([[responseDict valueForKey:@"response"]count ]!=0)
        {
            NSArray *arr=[responseDict valueForKey:@"response"];
            
            NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            NSArray *sortedArray = [arr sortedArrayUsingDescriptors:sortDescriptors];
            NSLog(@"%@",sortedArray);
            
            
            arrName=[[NSMutableArray alloc]init];
            arrIso3_code=[[NSMutableArray alloc]init];
            arrIso2_code=[[NSMutableArray alloc]init];
            arrcountry_id=[[NSMutableArray alloc]init];
            
            for (int i=0; i<arr.count; i++)
            {
                [arrcountry_id addObject:[[sortedArray objectAtIndex:i]valueForKey:@"country_id"]];
                [arrIso2_code addObject:[[sortedArray objectAtIndex:i]valueForKey:@"iso2_code"]];
                [arrIso3_code addObject:[[sortedArray objectAtIndex:i]valueForKey:@"iso3_code"]];
                [arrName addObject:[[sortedArray objectAtIndex:i]valueForKey:@"name"]];
            }
            
            
            if (arrcountry_id.count!=0 && arrIso2_code.count!=0 && arrIso3_code.count!=0 && arrName.count!=0)
            {
                NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects: arrcountry_id, arrIso2_code, arrIso3_code,arrName, nil] forKeys:[NSArray arrayWithObjects: @"Country_id", @"Iso2_code",@"Iso3_code",@"Name", nil]];
                
                NSString *error = nil;
                NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
                
                if(plistData)
                {
                    [plistData writeToFile:path atomically:YES];
                    NSLog(@"Data saved sucessfully");
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [paths objectAtIndex:0];
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"country.plist"];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
                    {
                        plistPath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"plist"];
                    }
                    
                    
                    dictPlist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
                    NSLog(@"%@",dictPlist);
                    
                    if ([[dictPlist objectForKey:@"Name"]count]==1)
                    {
                        oneCountry=YES;
                       // self.labelCountry.hidden=NO;
                        selectCountry1=0;
                        firstCountry=YES;
                        [borderState setHidden:NO];
                        selected=YES;
                        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectCountry1]forKey:@"selectCountry1"];
                        [coverView setHidden:YES];
                        [self setFrames:38];
                        self.country.text=[[dictPlist objectForKey:@"Name"]objectAtIndex:0];
                        countryIDBilling=[[dictPlist objectForKey:@"Iso2_code"] objectAtIndex:0];
                        [self.countryTable reloadData];
                        selectedValue=@"1";
                        NSString *str=[NSString stringWithFormat:@"%@getRegion?salt=%@&iso2_code=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[dictPlist objectForKey:@"Iso2_code"] objectAtIndex:0],model.storeID,model.currencyID];
                        
                        //---------------- API----------------------
                        
                        
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Region_API_Response:)];
                        
                        
                    }
                    
                    NSLog(@"%@",path);
                    [arrName removeAllObjects];
                    [arrcountry_id removeAllObjects];
                    [arrIso2_code removeAllObjects];
                    [arrIso3_code removeAllObjects];
                    
                }
                else
                {
                    NSLog(@"Data not saved");
                }
                
            }
            
        }
        
    }
    
}

#pragma mark Get country list

-(void)getCountryList
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        [self alertViewMethod:AMLocalizedString(@"tNoInternet", nil)];
    }
    else
    {
        NSLog(@"There IS internet connection");
        NSString *str=[NSString stringWithFormat:@"%@getCountry?salt=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,model.storeID,model.currencyID];
        
        //---------------- API----------------------
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_CountryList_API_Response:)];
    }
}

-(void)Get_CountryList_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    
    NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"response"]isKindOfClass:[NSArray class]])
    {
        NSError *error;
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory=[paths objectAtIndex:0];
        NSString *path=[documentDirectory stringByAppendingPathComponent:@"country.plist"];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path])
        {
            NSString *bundle=[[NSBundle mainBundle]pathForResource:@"country" ofType:@"plist"];
            [fileManager copyItemAtPath:bundle toPath:path error:&error];
        }
        
        if ([[responseDict valueForKey:@"response"]count ]!=0)
        {
            NSArray *arr=[responseDict valueForKey:@"response"];
            
            NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            NSArray *sortedArray = [arr sortedArrayUsingDescriptors:sortDescriptors];
            NSLog(@"%@",sortedArray);
            
            
            arrName=[[NSMutableArray alloc]init];
            arrIso3_code=[[NSMutableArray alloc]init];
            arrIso2_code=[[NSMutableArray alloc]init];
            arrcountry_id=[[NSMutableArray alloc]init];
            
            for (int i=0; i<arr.count; i++)
            {
                [arrcountry_id addObject:[[sortedArray objectAtIndex:i]valueForKey:@"country_id"]];
                [arrIso2_code addObject:[[sortedArray objectAtIndex:i]valueForKey:@"iso2_code"]];
                [arrIso3_code addObject:[[sortedArray objectAtIndex:i]valueForKey:@"iso3_code"]];
                [arrName addObject:[[sortedArray objectAtIndex:i]valueForKey:@"name"]];
            }
            
            
            if (arrcountry_id.count!=0 && arrIso2_code.count!=0 && arrIso3_code.count!=0 && arrName.count!=0)
            {
                NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects: arrcountry_id, arrIso2_code, arrIso3_code,arrName, nil] forKeys:[NSArray arrayWithObjects: @"Country_id", @"Iso2_code",@"Iso3_code",@"Name", nil]];
                
                NSString *error = nil;
                NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
                
                if(plistData)
                {
                    [plistData writeToFile:path atomically:YES];
                    NSLog(@"Data saved sucessfully");
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [paths objectAtIndex:0];
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"country.plist"];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
                    {
                        plistPath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"plist"];
                    }
                    
                    
                    dictPlist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
                    NSLog(@"%@",dictPlist);
                    
                    if ([[dictPlist objectForKey:@"Name"]count]==1)
                    {
                        oneCountry=YES;
                       // self.labelCountry.hidden=NO;
                        selectCountry1=0;
                        firstCountry=YES;
                        [borderState setHidden:NO];
                        selected=YES;
                        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectCountry1]forKey:@"selectCountry1"];
                        [coverView setHidden:YES];
                        [self setFrames:38];
                        self.country.text=[[dictPlist objectForKey:@"Name"]objectAtIndex:0];
                        countryIDBilling=[[dictPlist objectForKey:@"Iso2_code"] objectAtIndex:0];
                        [self.countryTable reloadData];
                        selectedValue=@"1";
                        NSString *str=[NSString stringWithFormat:@"%@getRegion?salt=%@&iso2_code=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[dictPlist objectForKey:@"Iso2_code"] objectAtIndex:0],model.storeID,model.currencyID];
                        
                        //---------------- API----------------------
                        
                        
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Region_API_Response:)];
                        
                        
                    }
                    
                    NSLog(@"%@",path);
                    [arrName removeAllObjects];
                    [arrcountry_id removeAllObjects];
                    [arrIso2_code removeAllObjects];
                    [arrIso3_code removeAllObjects];
                    
                }
                else
                {
                    NSLog(@"Data not saved");
                }
                
            }
            
        }
    }
}

#pragma mark Set Borders

-(void)setBorder:(UIView*)str
{
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius = 4.0;
    //    str.layer.borderWidth = 1.0;
    //    str.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:193.0/255.0] CGColor];
}

-(void)setButtonBorder:(UIView*)str
{
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius = 4.0;
    //    str.layer.borderWidth = 1.0;
    //    str.layer.borderColor = [[UIColor clearColor] CGColor];
}

#pragma mark Billing and shipping methods

- (IBAction)sameAsAddressButton:(id)sender
{
    if (clicked==NO)
    {
        if(selected==NO)
        {
            
            [self.shoppingView setHidden:NO];
            [scrollView setContentSize:CGSizeMake(320,1380)];
            self.placeOrderBorder.frame = CGRectMake(86, 940, 124, 34);
            clicked=YES;
            [self.checkbutton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        }
        else if (selectedSh==YES)
        {
            [self.shoppingView setHidden:NO];
            [scrollView setContentSize:CGSizeMake(320,1450)];
            self.placeOrderBorder.frame = CGRectMake(86, 1020, 124, 34);
            clicked=YES;
            [self.checkbutton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        }
        else
        {
            if (oneCountry==YES)
            {
                [borderStateSh setHidden:NO];
                [self setFramesSh];
                firstCountrySh=YES;
             //   self.labelCountrySh.hidden=NO;
                selectCountry2=0;
                
                selectedSh=YES;
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectCountry2]forKey:@"selectCountry2"];
                [self.countryTable reloadData];
                [coverView setHidden:YES];
                self.countrySh.text=[[dictPlist objectForKey:@"Name"]objectAtIndex:0];
                countryIDShipping=[[dictPlist objectForKey:@"Iso2_code"] objectAtIndex:0];
                selectedValue=@"2";
                NSString *str=[NSString stringWithFormat:@"%@getRegion?salt=%@&iso2_code=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[dictPlist objectForKey:@"Iso2_code"]objectAtIndex:0],model.storeID,model.currencyID];
                
                //---------------- API----------------------
                
                
                
                [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Region_API_Response:)];
                self.placeOrderBorder.frame = CGRectMake(86, 1020, 124, 34);
                [scrollView setContentSize:CGSizeMake(320,1450)];
                
            }
            else
            {
                self.placeOrderBorder.frame = CGRectMake(86, 978, 124, 34);
                [scrollView setContentSize:CGSizeMake(320,1400)];
            }
            [self.shoppingView setHidden:NO];
            
            
            clicked=YES;
            [self.checkbutton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if(selected==NO)
        {
            [scrollView setContentSize:CGSizeMake(320,960)];
            [self.shoppingView setHidden:YES];
            self.placeOrderBorder.frame = CGRectMake(86, 540, 124, 34);        clicked=NO;
            [self.checkbutton setImage:[UIImage imageNamed:@"blue_tick.png"] forState:UIControlStateNormal];
        }
        else
        {
            [scrollView setContentSize:CGSizeMake(320,1000)];
            [self.shoppingView setHidden:YES];
            self.placeOrderBorder.frame = CGRectMake(86, 578, 124, 34);        clicked=NO;
            [self.checkbutton setImage:[UIImage imageNamed:@"blue_tick.png"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark TextField delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.firstname)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(textField == self.firstnameSh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(textField == self.lastName)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(textField == self.lastNameSh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(textField == self.address1)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789/# ,ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(textField == self.address1Sh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789/# ,ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(textField == self.address2)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789/# ,ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if(textField == self.address2Sh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789/# ,ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if(textField == self.town)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if(textField == self.townSh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if(textField == self.state)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if(textField == self.stateSh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(textField == self.postCode)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(textField.text.length>5 && ![string  isEqual: @""])
        {
            return false;
        }
        return [string isEqualToString:filtered];
        return [string isEqualToString:filtered];
    }
    else if(textField == self.postCodeSh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(textField.text.length>5 && ![string  isEqual: @""])
        {
            return false;
        }
        return [string isEqualToString:filtered];
    }
    else if(textField == self.phone)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(textField.text.length>12 && ![string  isEqual: @""])
        {
            return false;
        }
        return [string isEqualToString:filtered];
    }
    else if(textField == self.phoneSh)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    if(textField.text.length>12 && ![string  isEqual: @""])
    {
        return false;
    }
        
        return [string isEqualToString:filtered];
    }
    else
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self.scrollView setScrollEnabled:NO];
    //    CGPoint pt;
    //    CGRect rc = [textField bounds];
    //    rc = [textField convertRect:rc toView:scrollView];
    //    pt = rc.origin;
    //    pt.x = 0;
    //    pt.y -= 60;
    //    [scrollView setContentOffset:pt animated:YES];
    //
    if (textField==self.country)
    {
        textField.placeholder = nil;
       // self.labelCountry.hidden=NO;
        [self.labelCountry setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelCountry duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.countrySh)
    {
        textField.placeholder = nil;
      //  self.labelCountrySh.hidden=NO;
        [self.labelCountrySh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelCountrySh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.firstname)
    {
        textField.placeholder = nil;
      //  self.labelFirstname.hidden=NO;
        [self.labelFirstname setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelFirstname duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.firstnameSh)
    {
        textField.placeholder = nil;
       // self.labelFirstnameSh.hidden=NO;
        [self.labelFirstnameSh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelFirstnameSh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    
    else if (textField==self.lastName)
    {
        textField.placeholder = nil;
       // self.labelLastName.hidden=NO;
        [self.labelLastName setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelLastName duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    
    else if (textField==self.lastNameSh)
    {
        textField.placeholder = nil;
      //  self.labelLastNameSh.hidden=NO;
        [self.labelLastNameSh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelLastNameSh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.address1)
    {
        textField.placeholder = nil;
      //  self.labelAddress1.hidden=NO;
        [self.labelAddress1 setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelAddress1 duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    
    else if (textField==self.address1Sh)
    {
        textField.placeholder = nil;
      //  self.labelAddress1Sh.hidden=NO;
        [self.labelAddress1Sh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelAddress1Sh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    
    else if (textField==self.address2)
    {
        textField.placeholder = nil;
       // self.labelAddress2.hidden=NO;
        [self.labelAddress2 setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelAddress2 duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.address2Sh)
    {
        textField.placeholder = nil;
      //  self.labelAddress2Sh.hidden=NO;
        [self.labelAddress2Sh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelAddress2Sh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.town)
    {
        textField.placeholder = nil;
      //  self.labelTown.hidden=NO;
        [self.labelTown setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelTown duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.townSh)
    {
        textField.placeholder = nil;
      //  self.labelTownSh.hidden=NO;
        [self.labelTownSh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelTownSh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.postCode)
    {
       // [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20.0];
        textField.placeholder = nil;
      //  self.labelPostCode.hidden=NO;
        [self.labelPostCode setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelPostCode duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.postCodeSh)
    {
       // [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20.0];
        textField.placeholder = nil;
     //   self.labelPostCodeSh.hidden=NO;
        [self.labelPostCodeSh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelPostCodeSh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    
    else if (textField==self.state)
    {
        textField.placeholder = nil;
      //  self.labelState.hidden=NO;
        [self.labelState setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelState duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.stateSh)
    {
        textField.placeholder = nil;
     //   self.labelStateSh.hidden=NO;
        [self.labelStateSh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelStateSh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.phone)
    {
        //[[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20.0];
        textField.placeholder = nil;
      //  self.labelPhone.hidden=NO;
        [self.labelPhone setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelPhone duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.phoneSh)
    {
        // [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20.0];
        textField.placeholder = nil;
       // self.labelPhoneSh.hidden=NO;
        [self.labelPhoneSh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelPhoneSh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==self.email)
    {
        textField.placeholder = nil;
       // self.labelEmail.hidden=NO;
        [self.labelEmail setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelEmail duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else
    {
        textField.placeholder = nil;
       // self.labelEmailSh.hidden=NO;
        [self.labelEmailSh setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0]];
        [UIView transitionWithView:self.labelEmailSh duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     [self.scrollView setScrollEnabled:YES];
    if (textField.text.length==0)
    {
        if (textField==self.country)
        {
            textField.placeholder = AMLocalizedString(@"tSelectCountry", nil);
            self.labelCountry.hidden=YES;
        }
        else if (textField==self.countrySh)
        {
            textField.placeholder =AMLocalizedString(@"tSelectCountry", nil) ;
            self.labelCountrySh.hidden=YES;
        }
        else if (textField==self.firstname)
        {
            textField.placeholder = AMLocalizedString(@"tFirstName", nil);
            self.labelFirstname.hidden=YES;
        }
        else if (textField==self.firstnameSh)
        {
            textField.placeholder =AMLocalizedString(@"tFirstName", nil) ;
            self.labelFirstnameSh.hidden=YES;
        }
        else if (textField==self.lastName)
        {
            textField.placeholder = AMLocalizedString(@"tLastName", nil);
            self.labelLastName.hidden=YES;
        }
        else if (textField==self.lastNameSh)
        {
            textField.placeholder = AMLocalizedString(@"tLastName", nil);
            self.labelLastNameSh.hidden=YES;
        }
        else if (textField==self.address1)
        {
            textField.placeholder = AMLocalizedString(@"tAddressLine1", nil);
            self.labelAddress1.hidden=YES;
        }
        else if (textField==self.address1Sh)
        {
            textField.placeholder = AMLocalizedString(@"tAddressLine1", nil);
            self.labelAddress1Sh.hidden=YES;
        }
        else if (textField==self.address2)
        {
            textField.placeholder = AMLocalizedString(@"tAddressLine2", nil);
            self.labelAddress2.hidden=YES;
        }
        else if (textField==self.address2Sh)
        {
            textField.placeholder = AMLocalizedString(@"tAddressLine2", nil);
            self.labelAddress2Sh.hidden=YES;
        }
        else if (textField==self.town)
        {
            textField.placeholder = AMLocalizedString(@"tTownCity", nil);
            self.labelTown.hidden=YES;
        }
        else if (textField==self.townSh)
        {
            textField.placeholder = AMLocalizedString(@"tTownCity", nil);
            self.labelTownSh.hidden=YES;
        }
        else if (textField==self.state)
        {
            textField.placeholder = AMLocalizedString(@"tStateRegion", nil);
            self.labelState.hidden=YES;
        }
        else if (textField==self.stateSh)
        {
            textField.placeholder = AMLocalizedString(@"tStateRegion", nil);
            self.labelStateSh.hidden=YES;
        }
        else if (textField==self.postCode)
        {
            // [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10.0];
            textField.placeholder = AMLocalizedString(@"tPostcodeZip", nil);
            self.labelPostCode.hidden=YES;
            [self.phone becomeFirstResponder];
        }
        else if (textField==self.postCodeSh)
        {
            // [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10.0];
            textField.placeholder = AMLocalizedString(@"tPostcodeZip", nil);
            self.labelPostCodeSh.hidden=YES;
            [self.phoneSh becomeFirstResponder];
        }
        
        else if (textField==self.phone)
        {
            // [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10.0];
            textField.placeholder = AMLocalizedString(@"tPhone", nil);
            self.labelPhone.hidden=YES;
            [self.email becomeFirstResponder];
        }
        else if (textField==self.phoneSh)
        {
           //  [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10.0];
            textField.placeholder = AMLocalizedString(@"tPhone", nil);
            self.labelPhoneSh.hidden=YES;
            [self.emailSh becomeFirstResponder];
        }
        
        else if (textField==self.email)
        {
            textField.placeholder = AMLocalizedString(@"tEMailAddress", nil);
            self.labelEmail.hidden=YES;
        }
        else
        {
            textField.placeholder = AMLocalizedString(@"tEMailAddress", nil);
            self.labelEmailSh.hidden=YES;
        }
    }
    else
    {
        if (textField==self.country)
        {
            self.labelCountry.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.countrySh)
        {
            self.labelCountrySh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.firstname)
        {
            self.labelFirstname.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.firstnameSh)
        {
            self.labelFirstnameSh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.lastName)
        {
            self.labelLastName.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.lastNameSh)
        {
            self.labelLastNameSh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.address1)
        {
            self.labelAddress1.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.address1Sh)
        {
            self.labelAddress1Sh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.address2)
        {
            self.labelAddress2.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.address2Sh)
        {
            self.labelAddress2Sh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.town)
        {
            self.labelTown.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.townSh)
        {
            self.labelTownSh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.state)
        {
            self.labelState.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.stateSh)
        {
            self.labelStateSh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==self.postCode)
        {
            self.labelPostCode.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            [self.phone becomeFirstResponder];
        }
        else if (textField==self.postCodeSh)
        {
            self.labelPostCodeSh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            [self.phoneSh becomeFirstResponder];
        }
        else if (textField==self.phone)
        {
            self.labelPhone.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            [self.email becomeFirstResponder];
        }
        else if (textField==self.phoneSh)
        {
            self.labelPhoneSh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            [self.emailSh becomeFirstResponder];
        }
        else if (textField==self.email)
        {
            self.labelEmail.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else
        {
            self.labelEmailSh.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.firstname)
    {
        [self.lastName becomeFirstResponder];
    }
    else if(textField==self.lastName)
    {
        [self.address1 becomeFirstResponder];
    }
    else if(textField==self.address1)
    {
        [self.address2 becomeFirstResponder];
    }
    else if(textField==self.address2)
    {
        [self.town becomeFirstResponder];
    }
    else if(textField==self.town)
    {
        if (selected==YES)
        {
            [self.state becomeFirstResponder];
        }
        else
        {
            [self.postCode becomeFirstResponder];
        }
    }
    else if(textField==self.state)
    {
        [self.postCode becomeFirstResponder];
    }
    else if(textField==self.postCode)
    {
        [self.phone becomeFirstResponder];
    }
    else if(textField==self.phone)
    {
        [self.email becomeFirstResponder];
    }
    else if(textField==self.email)
    {
        [self.email resignFirstResponder];
    }
    else if (textField==self.firstnameSh)
    {
        [self.lastNameSh becomeFirstResponder];
    }
    else if(textField==self.lastNameSh)
    {
        [self.lastName resignFirstResponder];
        [self.address1Sh becomeFirstResponder];
    }
    else if(textField==self.address1Sh)
    {
         [self.address1Sh resignFirstResponder];
        [self.address2Sh becomeFirstResponder];
    }
    else if(textField==self.address2Sh)
    {
        [self.address2Sh resignFirstResponder];
        [self.townSh becomeFirstResponder];
    }
    else if(textField==self.townSh)
    {
        [self.townSh resignFirstResponder];

        if (selectedSh==YES)
        {
            [self.stateSh becomeFirstResponder];
        }
        else
        {
            [self.postCodeSh becomeFirstResponder];
        }
    }
    else if(textField==self.stateSh)
    {
        [self.postCodeSh becomeFirstResponder];
    }
    else if(textField==self.postCodeSh)
    {
        [self.phoneSh becomeFirstResponder];
    }
    else if(textField==self.phoneSh)
    {
        [self.emailSh becomeFirstResponder];
    }
    else if(textField==self.emailSh)
    {
        [self.emailSh resignFirstResponder];
    }
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


#pragma mark Select country method

- (IBAction)selectCountry:(id)sender
{
    UIButton *button=(UIButton*)sender;
    
    if (button.tag==61)
    {
        selectedValue=@"1";
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"country.plist"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            plistPath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"plist"];
        }
        
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        arrName=[dict objectForKey:@"Name"];
        arrIso2_code=[dict objectForKey:@"Iso2_code"];
        
        for (int i=0; i<arrIso2_code.count; i++)
        {
            if ([[arrIso2_code objectAtIndex:i]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectCountry1"]])
            {
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",i] forKey:@"selectCountry1"];
            }
        }
        if (arrName.count!=0)
        {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            coverView = [[UIView alloc] initWithFrame:screenRect];
            coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            
            self.countryTable.frame=CGRectMake(40, 20, self.view.frame.size.width-80, self.view.frame.size.height-40);
            [self.view addSubview:coverView];
            [coverView addSubview:self.countryTable];
            [self.view endEditing:YES];
            [self.scrollView setScrollEnabled:NO];
            [self.countryTable reloadData];
        }
    }
    else
    {
        selectedValue=@"2";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"country.plist"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            plistPath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"plist"];
        }
        
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        arrName=[dict objectForKey:@"Name"];
        arrIso2_code=[dict objectForKey:@"Iso2_code"];
        for (int i=0; i<arrIso2_code.count; i++)
        {
            if ([[arrIso2_code objectAtIndex:i]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectCountry2"]])
            {
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",i] forKey:@"selectCountry2"];
            }
        }
        if (arrName.count!=0)
        {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            coverView = [[UIView alloc] initWithFrame:screenRect];
            coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            
            self.countryTable.frame=CGRectMake(40, 20, self.view.frame.size.width-80, self.view.frame.size.height-40);
            [self.view addSubview:coverView];
            [coverView addSubview:self.countryTable];
            [self.view endEditing:YES];
            [self.scrollView setScrollEnabled:NO];
            [self.countryTable reloadData];
        }
    }
}

#pragma mark Table View Delegate & Datasource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrName count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, -5, tableView.frame.size.width, 40)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    NSString *string;
    if ([selectedValue isEqualToString:@"1"]||[selectedValue isEqualToString:@"2"])
    {
        string =AMLocalizedString(@"tSelectCountry", nil);
    }
    else if ([selectedRegion isEqualToString:@"1"]||[selectedRegion isEqualToString:@"2"])
    {
        string =AMLocalizedString(@"tSelectRegion", nil);
    }
    [label setText:string];
    [label TransformAlignLabel];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    CountryCell *cell = (CountryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    if ([selectedValue isEqualToString:@"1"])
    {
        if (firstCountry==NO)
        {
            cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
            
        }
        else
        {
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectCountry1"]);
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectCountry1"]floatValue ]==indexPath.row)
            {
                NSLog(@"%ld",selectCountry1);
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio-selected.png"];
            }
            else
            {
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
            }
        }
    }
    else if ([selectedValue isEqualToString:@"2"])
    {
        if (firstCountrySh==NO)
        {
            cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
            
        }
        else
        {
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectCountry2"]floatValue ]==indexPath.row)
            {
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio-selected.png"];
            }
            else
            {
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
            }
        }
    }
    else if ([selectedRegion isEqualToString:@"1"])
    {
        if (firstRegion==NO)
        {
            cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
            ;
        }
        else
        {
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectCountry3"]floatValue ]==indexPath.row)
            {
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio-selected.png"];
            }
            else
            {
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
            }
        }
    }
    else if ([selectedRegion isEqualToString:@"2"])
    {
        if (firstRegionSh==NO)
        {
            cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
        }
        else
        {
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectCountry4"]floatValue ]==indexPath.row)
            {
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio-selected.png"];
            }
            else
            {
                cell.radioButton.image=[UIImage imageNamed:@"btn_radio.png"];
            }
        }
    }
    cell.name.text=[arrName objectAtIndex:indexPath.row];
    [cell.name TransformAlignLabel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectedValue isEqualToString:@"1"])
    {
        // -------------------------- Reachability --------------------//
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            NSLog(tNoInternet);
            
            [self alertViewMethod:AMLocalizedString(@"tNoInternet", nil)];
        }
        else
        {
            NSLog(@"There IS internet connection");
            [self addLoadingView];
            [self.scrollView setScrollEnabled:YES];
            [self.countryTable removeFromSuperview];
          //  self.labelCountry.hidden=NO;
            selectCountry1=indexPath.row;
            firstCountry=YES;
            [borderState setHidden:NO];
            selected=YES;
            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectCountry1]forKey:@"selectCountry1"];
            [coverView setHidden:YES];
            [self setFrames:38];
            self.country.text=[arrName objectAtIndex:indexPath.row ];
            countryIDBilling=[arrIso2_code objectAtIndex:indexPath.row];
            [self.countryTable reloadData];
            NSString *str=[NSString stringWithFormat:@"%@getRegion?salt=%@&iso2_code=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[arrIso2_code objectAtIndex:indexPath.row],model.storeID,model.currencyID];
            
            //---------------- API----------------------
            
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Region_API_Response:)];
            
        }
    }
    else if ([selectedValue isEqualToString:@"2"])
    {
        // -------------------------- Reachability --------------------//
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            [self alertViewMethod:AMLocalizedString(@"tNoInternet", nil)];
        }
        else
        {
            NSLog(@"There IS internet connection");
            [self addLoadingView];
            [self.scrollView setScrollEnabled:YES];
            [self.countryTable removeFromSuperview];
            [borderStateSh setHidden:NO];
            [self setFramesSh];
            firstCountrySh=YES;
           // self.labelCountrySh.hidden=NO;
            selectCountry2=indexPath.row;
            
            selectedSh=YES;
            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectCountry2]forKey:@"selectCountry2"];
            [self.countryTable reloadData];
            [coverView setHidden:YES];
            self.countrySh.text=[arrName objectAtIndex:indexPath.row ];
            countryIDShipping=[arrIso2_code objectAtIndex:indexPath.row];
            NSString *str=[NSString stringWithFormat:@"%@getRegion?salt=%@&iso2_code=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[arrIso2_code objectAtIndex:indexPath.row],model.storeID,model.currencyID];
            
            //---------------- API----------------------
            
            
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Region_API_Response:)];
        }
    }
    else if([selectedRegion isEqualToString:@"1"])
    {
        self.state.text=[arrName objectAtIndex:indexPath.row];
       // self.labelState.hidden=NO;
        selectCountry3=indexPath.row;
        firstRegion=YES;
        stateIDBilling=[arrIso2_code objectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectCountry3]forKey:@"selectCountry3"];
        
        [self.countryTable reloadData];
        [self.scrollView setScrollEnabled:YES];
        [self.countryTable removeFromSuperview];
        [coverView setHidden:YES];
    }
    else
    {
        self.stateSh.text=[arrName objectAtIndex:indexPath.row];
       // self.labelStateSh.hidden=NO;
        selectCountry4=indexPath.row;
        firstRegionSh=YES;
        
        stateIDShipping=[arrIso2_code objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectCountry4]forKey:@"selectCountry4"];
        [self.countryTable reloadData];
        [self.scrollView setScrollEnabled:YES];
        [self.countryTable removeFromSuperview];
        [coverView setHidden:YES];
    }
}

#pragma mark Region API Response

-(void)Get_Region_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    if ([[responseDict valueForKey:@"response"]isKindOfClass:[NSArray class]]) {
        NSLog(@"%@",responseDict);
        if ([[responseDict valueForKey:@"response"]count]!=0)
        {
            NSError *error;
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory=[paths objectAtIndex:0];
            NSString *path=[documentDirectory stringByAppendingPathComponent:@"region.plist"];
            
            NSFileManager *fileManager=[NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:path])
            {
                NSString *bundle=[[NSBundle mainBundle]pathForResource:@"region" ofType:@"plist"];
                [fileManager copyItemAtPath:bundle toPath:path error:&error];
            }
            if ([[responseDict valueForKey:@"response"]count ]!=0)
            {
                NSArray *arr=[responseDict valueForKey:@"response"];
                
                NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
                NSArray *sortedArray = [arr sortedArrayUsingDescriptors:sortDescriptors];
                NSLog(@"%@",sortedArray);
                
                arrcountry_id=[[NSMutableArray alloc]init];
                arrIso2_code=[[NSMutableArray alloc]init];
                arrName=[[NSMutableArray alloc]init];
                
                for (int i=0; i<arr.count; i++)
                {
                    [arrcountry_id addObject:[[sortedArray objectAtIndex:i]valueForKey:@"region_id"]];
                    [arrIso2_code addObject:[[sortedArray objectAtIndex:i]valueForKey:@"code"]];
                    [arrName addObject:[[sortedArray objectAtIndex:i]valueForKey:@"name"]];
                }
                
                if (arrcountry_id.count!=0 && arrIso2_code.count!=0 && arrName.count !=0)
                {
                    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects: arrcountry_id, arrIso2_code,arrName, nil] forKeys:[NSArray arrayWithObjects: @"region_id", @"code",@"name", nil]];
                    
                    NSString *error = nil;
                    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
                    
                    if(plistData)
                    {
                        [plistData writeToFile:path atomically:YES];
                        NSLog(@"Data saved sucessfully");
                        NSLog(@"%@",path);
                        [arrName removeAllObjects];
                        [arrcountry_id removeAllObjects];
                        [arrIso2_code removeAllObjects];
                    }
                    else
                    {
                        NSLog(@"Data not saved");
                    }
                }
                
                arrName=[[responseDict valueForKey:@"response"] valueForKey:@"name"];
                arrIso2_code=[[responseDict valueForKey:@"response"] valueForKey:@"code"];
                
                if ([selectedValue isEqualToString:@"1"])
                {
                    [self.borderState addSubview:self.buttonState];
                    selectedValue=@"";
                    selectedRegion=@"";
                    
                }
                else if ([selectedValue isEqualToString:@"2"])
                {
                    [self.borderStateSh addSubview:self.buttonStateSh];
                    selectedValue=@"";
                    selectedRegion=@"";
                }
            }
        }
        else
        {
            if ([selectedValue isEqualToString:@"1"])
            {
                selectedRegion=@"1";
                [self.buttonState removeFromSuperview];
                [self.state setText:@""];
                selectedValue=@"";
                stateIDBilling=@"";
            }
            else if([selectedValue isEqualToString:@"2"])
            {
                selectedRegion=@"2";
                [self.buttonStateSh removeFromSuperview];
                [self.stateSh setText:@""];
                selectedValue=@"";
                stateIDShipping=@"";
                
            }
        }
        
    }
}

#pragma mark textfield action method

-(IBAction)textField1Active:(id)sender
{
    UIButton *button=(UIButton*)sender;
    
    if (arrName.count!=0)
    {
        if (button.tag==71)
        {
            selectedRegion=@"1";
        }
        else
        {
            selectedRegion=@"2";
        }
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        coverView = [[UIView alloc] initWithFrame:screenRect];
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.countryTable.frame=CGRectMake(40, 20, self.view.frame.size.width-80, self.view.frame.size.height-40);
        [self.view addSubview:coverView];
        [coverView addSubview:self.countryTable];
        
        [self.scrollView setScrollEnabled:NO];
        [self.countryTable reloadData];
    }
}

#pragma mark Place Order Button

- (IBAction)placeOrder:(id)sender
{
    NSString *msg=@"0";
    
    if(([[self.country.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod:AMLocalizedString(@"tPleaseselecttheCountrynamefield", nil)];
        
        msg=@"1";
    }
    else if(([[self.firstname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod:AMLocalizedString(@"tPleasefilltheFirstnamefield", nil)];
        
        msg=@"1";
    }
    else if(([[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPleasefilltheLastnamefield", nil)];
        msg=@"1";
    }
    else if(([[self.address1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPleasefilltheAddressfield", nil)];
        msg=@"1";
    }
    else if(([[self.state.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPleasefilltheStatefield", nil)];
        
        msg=@"1";
    }
    else if(([[self.town.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPleasefilltheTown", nil)];
        msg=@"1";
    }
    else if(([[self.postCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPleasefillthePostCodefield", nil)];
        
        msg=@"1";
    }
    else if(([[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPleasefillthePhonefield", nil)];
        msg=@"1";
    }
   
    else if(([[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<10) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPhonenumbershouldhave10to12digits", nil)];
        
        msg=@"1";
    }
    
    else if(([[self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tPleasefilltheEmailfield", nil)];
        
        msg=@"1";
    }
    else if(([[self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0)&& ![self validateEmailWithString:self.email.text]&& [msg isEqualToString:@"0"] )
    {
        [self alertViewMethod: AMLocalizedString(@"tEmailformatisnotcorrect", nil)];
        
        msg=@"1";
    }
    else
    {
        if (clicked==NO)
        {
            [self addLoadingView];
            
            [self performSelector:@selector(setbillingAPI) withObject:self afterDelay:2.0];
            
        }
        else
        {
            if(([[self.countrySh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleaseselecttheCountrynamefield", nil)];
                
                msg=@"1";
            }
            else if(([[self.firstnameSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefilltheFirstnamefield", nil)];
                
                msg=@"1";
            }
            else if(([[self.lastNameSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefilltheLastnamefield", nil)];
                msg=@"1";
            }
            else if(([[self.address1Sh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefilltheAddressfield", nil)];
                
                msg=@"1";
            }
            else if(([[self.stateSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefilltheStatefield", nil)];
                
                msg=@"1";
            }
            else if(([[self.townSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefilltheTown", nil)];
                msg=@"1";
            }
            else if(([[self.postCodeSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefillthePostCodefield", nil)];
                msg=@"1";
            }
            else if(([[self.phoneSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefillthePhonefield", nil)];
                
                msg=@"1";
            }
            else if(([[self.phoneSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<10) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPhonenumbershouldhave10to12digits", nil)];
                
                msg=@"1";
            }
            else if(([[self.emailSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tPleasefilltheEmailfield", nil)];
                msg=@"1";
            }
            else if(([[self.emailSh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0)&& ![self validateEmailWithString:self.emailSh.text]&& [msg isEqualToString:@"0"] )
            {
                [self alertViewMethod: AMLocalizedString(@"tEmailformatisnotcorrect", nil)];
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
                    [self alertViewMethod: AMLocalizedString(@"tNoInternet", nil)];
                    
                }
                else
                {
                    NSLog(@"There IS internet connection");
                    [self addLoadingView];
                    
                    ApiClasses *obj=[[ApiClasses alloc]init];
                    if ([stateIDBilling isEqualToString:@""])
                    {
                        stateIDBilling=self.state.text;
                    }
                    if ([stateIDShipping isEqualToString:@""])
                    {
                        stateIDShipping=[self.stateSh.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                    
                    NSString *concat =self.address1.text;
                    concat = [concat stringByAppendingString:self.address2.text];
                    NSString *newString = [concat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    
                    NSString *concatSh =self.address1Sh.text;
                    concatSh = [concatSh stringByAppendingString:self.address2Sh.text];
                    NSString *newStringSh = [concatSh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    Address = [[NSMutableDictionary alloc]init];
                    
                    [Address setObject:[self.firstname.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"firstname"];
                     [Address setObject:[self.lastName.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"lastname"];
                    [Address setObject:[self.address1.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"address1"];
                    [Address setObject:[self.address2.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"address2"];
                     [Address setObject:[self.town.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"city"];
                     [Address setObject:stateIDBilling forKey:@"region_value"];
                     [Address setObject:self.state.text forKey:@"region"];
                    [Address setObject:self.postCode.text forKey:@"zip"];
                     [Address setObject:countryIDBilling forKey:@"country_id_value"];
                    [Address setObject:self.country.text
                                forKey:@"country_id"];
                     [Address setObject:self.phone.text forKey:@"phone"];
                     [Address setObject:self.email.text forKey:@"email"];
                     //[Address setObject:[self.firstnameSh.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"email"];
                     [Address setObject:[self.firstnameSh.text stringByReplacingOccurrencesOfString:@" " withString:@""]  forKey:@"s_firstname"];
                     [Address setObject:[self.lastNameSh.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"s_lastname"];
                    [Address setObject:[self.address1Sh.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"s_address1"];
                    [Address setObject:[self.address2Sh.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"s_address2"];
                     [Address setObject:[newStringSh stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"s_street"];
                     [Address setObject:[self.townSh.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"s_city"];
                     [Address setObject:stateIDShipping forKey:@"s_region_value"];
                    [Address setObject:self.stateSh.text forKey:@"s_region"];

                     [Address setObject:self.postCodeSh.text forKey:@"s_zip"];
                     [Address setObject:self.countrySh.text forKey:@"s_country_id"];
                    [Address setObject:countryIDShipping forKey:@"s_country_id_value"];
                     [Address setObject:self.phoneSh.text forKey:@"s_phone"];
                     //[Address setObject: forKey:@"s_fax"];
                     [Address setObject:self.emailSh.text forKey:@"s_email"];
                     NSLog(@"%@",Address);
                    [[NSUserDefaults standardUserDefaults]setObject:Address forKey:@"Temp_Address"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    NSString *str=[NSString stringWithFormat:@"%@setQuoteAddress?salt=%@&quote_id=%@&use_for_shipping=0&firstname=%@&lastname=%@&street=%@&city=%@&region=%@&zip=%@&country_id=%@&phone=%@&fax=&email=%@&s_firstname=%@&s_lastname=%@&s_street=%@&s_city=%@&s_region=%@&s_zip=%@&s_country_id=%@&s_phone=%@&s_fax=&s_email=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"],[self.firstname.text stringByReplacingOccurrencesOfString:@" " withString:@""],[self.lastName.text stringByReplacingOccurrencesOfString:@" " withString:@""],[newString stringByReplacingOccurrencesOfString:@" " withString:@""],[self.town.text stringByReplacingOccurrencesOfString:@" " withString:@""],stateIDBilling,self.postCode.text,countryIDBilling,self.phone.text,self.email.text,[self.firstnameSh.text stringByReplacingOccurrencesOfString:@" " withString:@""],[self.lastNameSh.text stringByReplacingOccurrencesOfString:@" " withString:@""],[newStringSh stringByReplacingOccurrencesOfString:@" " withString:@""],[self.townSh.text stringByReplacingOccurrencesOfString:@" " withString:@""],stateIDShipping,self.postCodeSh.text,countryIDShipping,self.phoneSh.text,self.emailSh.text,model.storeID,model.currencyID];
                    [obj ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Set_QuoteAddress_Response:)];
                }
            }
        }
    }
}

-(void)setbillingAPI
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        [self alertViewMethod: AMLocalizedString(@"tNoInternet", nil)];
    }
    else
    {
        NSLog(@"There IS internet connection");
        ApiClasses *obj=[[ApiClasses alloc]init];
        if ([stateIDBilling isEqualToString:@""])
        {
            stateIDBilling=[self.state.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        NSString *concat =self.address1.text;
        concat = [concat stringByAppendingString:self.address2.text];
        NSString *newString=[concat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        Address = [[NSMutableDictionary alloc]init];
        
        [Address setObject:[self.firstname.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"firstname"];
        [Address setObject:[self.lastName.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"lastname"];
        [Address setObject:[self.address1.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"address1"];
          [Address setObject:[self.address2.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"address2"];
        [Address setObject:[self.town.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"city"];
        [Address setObject:stateIDBilling forKey:@"region_value"];
        [Address setObject:self.state.text forKey:@"region"];
        [Address setObject:self.postCode.text forKey:@"zip"];
        [Address setObject:countryIDBilling forKey:@"country_id_value"];
        [Address setObject:self.country.text
                    forKey:@"country_id"];
        [Address setObject:self.phone.text forKey:@"phone"];
        [Address setObject:self.email.text forKey:@"email"];
        //[Address setObject:[self.firstnameSh.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"email"];
        [Address setObject:@"" forKey:@"s_firstname"];
        [Address setObject:@"" forKey:@"s_lastname"];
        [Address setObject:@"" forKey:@"s_street"];
        [Address setObject:@"" forKey:@"s_city"];
        [Address setObject:@"" forKey:@"s_region_value"];
        [Address setObject:@"" forKey:@"s_region"];
        
        [Address setObject:@"" forKey:@"s_zip"];
        [Address setObject:@"" forKey:@"s_country_id_value"];
        [Address setObject:@"" forKey:@"s_country_id"];
        [Address setObject:@"" forKey:@"s_phone"];
        //[Address setObject: forKey:@"s_fax"];
        [Address setObject:@"" forKey:@"s_email"];
        NSLog(@"%@",Address);
        [[NSUserDefaults standardUserDefaults]setObject:Address forKey:@"Temp_Address"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSString *str=[NSString stringWithFormat:@"%@setQuoteAddress?salt=%@&quote_id=%@&use_for_shipping=1&firstname=%@&lastname=%@&street=%@&city=%@&region=%@&zip=%@&country_id=%@&phone=%@&fax=&email=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"],[self.firstname.text stringByReplacingOccurrencesOfString:@" " withString:@""],[self.lastName.text stringByReplacingOccurrencesOfString:@" " withString:@""],[newString stringByReplacingOccurrencesOfString:@" " withString:@""],[self.town.text stringByReplacingOccurrencesOfString:@" " withString:@""],stateIDBilling,self.postCode.text,countryIDBilling,self.phone.text,self.email.text,model.storeID,model.currencyID];
        [obj ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Set_QuoteAddress_Response:)];
    }
}

-(void)Set_QuoteAddress_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    
    if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        PaymentView * obj = [[PaymentView alloc]initWithNibName:@"PaymentView" bundle:nil];
        
        if (clicked==NO)
        {
            NSString * str = [NSString stringWithFormat:@"%@ %@",self.firstname.text,self.lastName.text];
            NSString * address = [NSString stringWithFormat:@"%@, %@, %@, %@",self.address1.text,self.town.text,self.address2.text,self.postCode.text];
            
            obj.billingName = str;
            obj.billingAddress = address;
            obj.billingPhone = self.phone.text;
            obj.billingCode = countryIDBilling;
            
            obj.shippingName = str;
            obj.shippingAddress = address;
            obj.shippingPhone = self.phone.text;
            obj.shippingCode = countryIDBilling;
            obj.email = _email.text;
            
            [[NSUserDefaults standardUserDefaults]setValue:self.email.text forKey:@"email"];
            
            [self.navigationController pushViewController:obj animated:YES];
        }
        else
        {
            NSString * str = [NSString stringWithFormat:@"%@ %@",self.firstname.text,self.lastName.text];
            NSString * address = [NSString stringWithFormat:@"%@, %@, %@, %@",self.address1.text,self.town.text,self.address2.text,self.postCode.text];
            
            obj.billingName = str;
            obj.billingAddress = address;
            obj.billingPhone = self.phone.text;
            obj.billingCode = countryIDBilling;
            
            NSString * str1 = [NSString stringWithFormat:@"%@ %@",self.firstnameSh.text,self.lastNameSh.text];
            NSString * address1 = [NSString stringWithFormat:@"%@, %@, %@, %@",self.address1Sh.text,self.townSh.text,self.address2Sh.text,self.postCodeSh.text];
            
            obj.shippingName = str1;
            obj.shippingAddress = address1;
            obj.shippingPhone = self.phoneSh.text;
            obj.shippingCode = countryIDShipping;
            
            [[NSUserDefaults standardUserDefaults]setValue:self.email.text forKey:@"email"];
            
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        [self alertViewMethod: AMLocalizedString(@"tOopsSomethingwentwrong", nil)];
        
    }
    else
    {
        [self alertViewMethod: [responseDict valueForKey:@"response"]];
        
    }
    NSLog(@"%@",responseDict);
}

#pragma mark Back Button

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Helper Methods

- (BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

-(void)alertViewMethod:(NSString*)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
    [alert show];
    
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
