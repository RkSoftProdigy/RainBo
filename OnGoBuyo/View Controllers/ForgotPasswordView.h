//
//  ForgotPasswordView.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/22/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordView : UIViewController

//change color outlets
@property (weak, nonatomic) IBOutlet UILabel *simplyLbl;
@property (weak, nonatomic) IBOutlet UILabel *lostLabel;
@property (weak, nonatomic) IBOutlet UIView *topView2;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *resetPassword;

//Methods

- (IBAction)ResetPassword:(id)sender;
- (IBAction)Back:(id)sender;

@end
