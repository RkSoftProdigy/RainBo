//
//  BillingAndShippingView.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/1/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingAndShippingView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //word change
    
    __weak IBOutlet UILabel *shippingLbl;
    __weak IBOutlet UILabel *billingLbl;
}
//change color

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry2;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITableView *countryTable;


@property (strong, nonatomic) IBOutlet UIView *billingView;

//borders

@property (weak, nonatomic) IBOutlet UIView *borderCountry;
@property (weak, nonatomic) IBOutlet UIView *borderFirstname;
@property (weak, nonatomic) IBOutlet UIView *borderLastName;
@property (weak, nonatomic) IBOutlet UIView *borderAddress1;
@property (weak, nonatomic) IBOutlet UIView *borderAddress2;
@property (weak, nonatomic) IBOutlet UIView *borderTown;
@property (weak, nonatomic) IBOutlet UIView *borderState;
@property (weak, nonatomic) IBOutlet UIView *borderPostCode;
@property (weak, nonatomic) IBOutlet UIView *borderPhone;
@property (weak, nonatomic) IBOutlet UIView *borderEmail;
@property (strong, nonatomic) IBOutlet UIView *shiftView;

@property (weak, nonatomic) IBOutlet UIButton *borderSelect;

// shippig view

@property (strong, nonatomic) IBOutlet UIView *shoppingView;

//borders

@property (weak, nonatomic) IBOutlet UIView *borderCountrySh;
@property (weak, nonatomic) IBOutlet UIView *borderFirstnameSh;
@property (weak, nonatomic) IBOutlet UIView *borderLastNameSh;
@property (weak, nonatomic) IBOutlet UIView *borderAddress1Sh;
@property (weak, nonatomic) IBOutlet UIView *borderAddress2Sh;
@property (weak, nonatomic) IBOutlet UIView *borderTownSh;
@property (weak, nonatomic) IBOutlet UIView *borderStateSh;
@property (weak, nonatomic) IBOutlet UIView *borderPostCodeSh;
@property (weak, nonatomic) IBOutlet UIView *borderPhoneSh;
@property (weak, nonatomic) IBOutlet UIView *borderEmailSh;
@property (strong, nonatomic) IBOutlet UIView *shiftViewSh;

@property (weak, nonatomic) IBOutlet UIButton *borderSelectSh;




//label

@property (weak, nonatomic) IBOutlet UILabel *labelCountry;
@property (weak, nonatomic) IBOutlet UILabel *labelFirstname;
@property (weak, nonatomic) IBOutlet UILabel *labelLastName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress1;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress2;
@property (weak, nonatomic) IBOutlet UILabel *labelTown;
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UILabel *labelPostCode;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;

//shipping view

@property (weak, nonatomic) IBOutlet UIView *shippingHead;
@property (weak, nonatomic) IBOutlet UILabel *labelSameAddress;

@property (weak, nonatomic) IBOutlet UILabel *labelCountrySh;
@property (weak, nonatomic) IBOutlet UILabel *labelFirstnameSh;
@property (weak, nonatomic) IBOutlet UILabel *labelLastNameSh;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress1Sh;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress2Sh;
@property (weak, nonatomic) IBOutlet UILabel *labelTownSh;
@property (weak, nonatomic) IBOutlet UILabel *labelStateSh;
@property (weak, nonatomic) IBOutlet UILabel *labelPostCodeSh;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneSh;
@property (weak, nonatomic) IBOutlet UILabel *labelEmailSh;

//textFields

@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *address1;
@property (weak, nonatomic) IBOutlet UITextField *address2;
@property (weak, nonatomic) IBOutlet UITextField *town;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *postCode;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;

//shipping view

@property (weak, nonatomic) IBOutlet UITextField *countrySh;
@property (weak, nonatomic) IBOutlet UITextField *firstnameSh;
@property (weak, nonatomic) IBOutlet UITextField *lastNameSh;
@property (weak, nonatomic) IBOutlet UITextField *address1Sh;
@property (weak, nonatomic) IBOutlet UITextField *address2Sh;
@property (weak, nonatomic) IBOutlet UITextField *townSh;
@property (weak, nonatomic) IBOutlet UITextField *stateSh;
@property (weak, nonatomic) IBOutlet UITextField *postCodeSh;
@property (weak, nonatomic) IBOutlet UITextField *phoneSh;
@property (weak, nonatomic) IBOutlet UITextField *emailSh;

@property (weak, nonatomic) IBOutlet UIButton *checkbutton;

//button
@property (weak, nonatomic) IBOutlet UIButton *placeOrderBorder;
@property (strong, nonatomic) IBOutlet UIButton *buttonState;
@property (strong, nonatomic) IBOutlet UIButton *buttonStateSh;

@end
