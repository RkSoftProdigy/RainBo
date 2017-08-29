//
//  RegisterViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/18/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    
    __weak IBOutlet UILabel *signNewsLBl;
    __weak IBOutlet UILabel *readyLbl;
    __weak IBOutlet UILabel *fillYourLbl;
}

//change color outlets
@property (weak, nonatomic) IBOutlet UIView *topView1;
@property (weak, nonatomic) IBOutlet UIView *topView2;
@property (weak, nonatomic) IBOutlet UILabel *alreadyLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginLbl;
@property (weak, nonatomic) IBOutlet UIButton *signButton;




@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//Views
@property (weak, nonatomic) IBOutlet UIView *firstNameBorder;
@property (weak, nonatomic) IBOutlet UIView *lastNameBorder;
@property (weak, nonatomic) IBOutlet UIView *emailBorder;
@property (weak, nonatomic) IBOutlet UIView *passwordBorder;
@property (weak, nonatomic) IBOutlet UIView *confirmBorder;

@property (strong, nonatomic) IBOutlet UIButton *registerBorder;

//TextFields
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

//labels
@property (weak, nonatomic) IBOutlet UILabel *labelFirstName;
@property (weak, nonatomic) IBOutlet UILabel *labelLastName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelConfirm;

//register
- (IBAction)Register:(id)sender;
- (IBAction)SignUpNewsLetter:(id)sender;



//Login Here

- (IBAction)LoginHere:(id)sender;

//Back Button

- (IBAction)BackButton:(id)sender;


@end
