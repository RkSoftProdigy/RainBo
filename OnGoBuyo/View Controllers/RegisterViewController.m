//
//  RegisterViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/18/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "ModelClass.h"
#import "Constants.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"


@interface RegisterViewController ()
{
    ModelClass *model;
}
@end

@implementation RegisterViewController

@synthesize firstNameBorder,lastNameBorder,emailBorder,passwordBorder,confirmBorder,firstName,lastName,email,password,confirmPassword,labelConfirm,labelEmail,labelFirstName,labelLastName,labelPassword,registerBorder,topView2,topView1,loginLbl,alreadyLabel;

- (void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [topView1 TransformationView];
    [topView2 TransformationView];
    [readyLbl TransformLabel];
    [fillYourLbl TransformLabel];
    [firstName TransformTextField];
    [lastName TransformTextField];
    [email TransformTextField];
    [password TransformTextField];
    [confirmPassword TransformTextField];
    [labelFirstName TransformAlignLabel];
    [labelLastName TransformAlignLabel];
    [labelEmail TransformAlignLabel];
    [labelPassword TransformAlignLabel];
    [labelConfirm TransformAlignLabel];
    [registerBorder TransformButton];
    [alreadyLabel TransformAlignLabel];
    [loginLbl TransformButton];
    [signNewsLBl TransformAlignLabel];
    [_signButton TransformButton];
    [super viewDidLoad];
    
    //word Change
    [readyLbl setText:AMLocalizedString(@"tREADYTOGETSTARTED", nil) ];
    [fillYourLbl setText:AMLocalizedString(@"tFillyourdetailsbelowtoregister", nil)];
    [firstName setPlaceholder:AMLocalizedString(@"tFirstName", nil)];
    [lastName setPlaceholder:AMLocalizedString(@"tLastName", nil)];
    [email setPlaceholder:AMLocalizedString(@"tEMailAddress", nil)];
    [password setPlaceholder:AMLocalizedString(@"tPassword", nil)];
    [confirmPassword setPlaceholder:AMLocalizedString(@"tConfirmPassword", nil)];
    [signNewsLBl setText:AMLocalizedString(@"tSignUpforNewsletter", nil)];
    [registerBorder setTitle:AMLocalizedString(@"tRegister", nil) forState:UIControlStateNormal];
    [labelEmail setText:AMLocalizedString(@"tEMailAddress", nil)];
    [labelConfirm setText:AMLocalizedString(@"tConfirmPassword", nil)];
    [labelFirstName setText:AMLocalizedString(@"tFirstName", nil)];
    [labelLastName setText:AMLocalizedString(@"tLastName", nil)];
    [labelPassword setText:AMLocalizedString(@"tPassword", nil)];
    [alreadyLabel setText:AMLocalizedString(@"tAlreadyaMember", nil)];
    [loginLbl setTitle:AMLocalizedString(@"tLoginhere", nil) forState:UIControlStateNormal];
    
    
    model=[ModelClass sharedManager];
    
    if (Is_IPhone4)
    {
        [self.scrollView setContentSize:CGSizeMake(320, self.scrollView.frame.size.height+55)];
    }
    
    [self setBorder:firstNameBorder];
    [self setBorder:lastNameBorder];
    [self setBorder:emailBorder];
    [self setBorder:passwordBorder];
    [self setBorder:confirmBorder];
    
    //    registerBorder.layer.masksToBounds = YES;
    //    registerBorder.layer.cornerRadius = 4.0;
    //    registerBorder.layer.borderWidth = 1.0;
    //    registerBorder.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //hidden
    labelConfirm.hidden=YES;
    labelEmail.hidden=YES;
    labelFirstName.hidden=YES;
    labelPassword.hidden=YES;
    labelLastName.hidden=YES;
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //change color
    
    [topView1 setBackgroundColor:model.themeColor];
    [topView2 setBackgroundColor:model.themeColor];
    [alreadyLabel setTextColor:model.saffronClr];
    [loginLbl setTitleColor:model.greenClr forState:UIControlStateNormal];
    [registerBorder setBackgroundColor:model.blueClr];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"RegisterView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TextField delegate

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if(textField == firstName)
//    {
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
//        if([firstName.text length] - range.length + firstName.text.length < 50)
//            return [string isEqualToString:filtered];
//        else
//            return NO;
//
//    }
//    else if(textField == lastName)
//    {
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
//        if([lastName.text length] - range.length < 50)
//            return [string isEqualToString:filtered];
//        else
//            return NO;
//
//    }
//    if(textField == email)
//    {
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_.@"] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
//        if([email.text length] - range.length + email.text.length < 50)
//            return [string isEqualToString:filtered];
//        else
//            return NO;
//
//    }
//    if(textField == password)
//    {
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
//        if([password.text length] - range.length + password.text.length < 50)
//            return [string isEqualToString:filtered];
//        else
//            return NO;
//    }
//    if(textField == confirmPassword)
//    {
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
//        if([confirmPassword.text length] - range.length + confirmPassword.text.length < 50)
//            return [string isEqualToString:filtered];
//        else
//            return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.firstName)
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
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==firstName)
    {
        textField.placeholder = nil;
       // labelFirstName.hidden=NO;
        labelFirstName.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelFirstName duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==lastName)
    {
        textField.placeholder = nil;
       // labelLastName.hidden=NO;
        labelLastName.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelLastName duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==email)
    {
        textField.placeholder = nil;
       // labelEmail.hidden=NO;
        labelEmail.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelEmail duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==password)
    {
        textField.placeholder = nil;
       // labelPassword.hidden=NO;
        labelPassword.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelPassword duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else
    {
        textField.placeholder = nil;
      //  labelConfirm.hidden=NO;
        labelConfirm.textColor=[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0  alpha:1.0];
        [UIView transitionWithView:self.labelConfirm duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length==0)
    {
        if (textField==firstName)
        {
            textField.placeholder = AMLocalizedString(@"tFirstName", nil);
            labelFirstName.hidden=YES;
        }
        else if (textField==lastName)
        {
            textField.placeholder = AMLocalizedString(@"tLastName", nil);
            labelLastName.hidden=YES;
        }
        else if (textField==email)
        {
            textField.placeholder = AMLocalizedString(@"tEMailAddress", nil);
            labelEmail.hidden=YES;
        }
        else if (textField==password)
        {
            textField.placeholder = AMLocalizedString(@"tPassword", nil);
            labelPassword.hidden=YES;
        }
        else
        {
            textField.placeholder = AMLocalizedString(@"tConfirmPassword", nil);
            labelConfirm.hidden=YES;
        }
    }
    else
    {
        if (textField==firstName)
        {
            labelFirstName.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==lastName)
        {
            labelLastName.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==email)
        {
            labelEmail.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==password)
        {
            labelPassword.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else
        {
            labelConfirm.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==firstName)
    {
        [lastName becomeFirstResponder];
    }
    else if (textField==lastName)
    {
        [email becomeFirstResponder];
    }
    else if (textField==email)
    {
        [password becomeFirstResponder];
    }
    else if(textField==password)
    {
        [confirmPassword becomeFirstResponder];
    }
    else
    {
        [confirmPassword resignFirstResponder];
    }
    return YES;
}

#pragma mark Helper Methods

-(BOOL)isPasswordMatch:(NSString *)pwd withConfirmPwd:(NSString *)cnfPwd
{
    
    if([pwd length]>0 && [cnfPwd length]>0)
    {
        if([pwd isEqualToString:cnfPwd]){
            NSLog(@"Hurray! Password matches ");
            return TRUE;
        }
        else
        {
            NSLog(@"Oops! Password does not matches");
            return FALSE;
        }
    }
    else
    {
        NSLog(@"Password field can not be empty ");
        return FALSE;
    }
    return FALSE;
}

- (BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

#pragma mark BackButton

- (IBAction)BackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark Login Here

- (IBAction)LoginHere:(id)sender
{
    LoginViewController *objViewcontroller=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:objViewcontroller animated:YES];
    objViewcontroller=nil;
    
}

#pragma mark Register Button

- (IBAction)Register:(id)sender
{
    NSString *msg=@"0";
    
    if ((([[firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) || ([[lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) || ([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) || ([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) || ([[confirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)) && [msg isEqualToString:@"0"] )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefillalldetails", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        msg=@"1";
        
    }
    //    else if(([[firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the first name field." delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil];
    //        [alert show];
    //        msg=@"1";
    //    }
    //    else if(([[lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the last name field." delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil];
    //        [alert show];
    //        msg=@"1";
    //    }
    //    else if(([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the valid email address field." delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil];
    //        [alert show];
    //        msg=@"1";
    //    }
    //    else if(([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0)&& ![self validateEmailWithString:email.text]&& [msg isEqualToString:@"0"] )
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email format is not correct." delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil];
    //        [alert show];
    //        msg=@"1";
    //    }
    //    else if(([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the password field." delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil];
    //        [alert show];
    //        msg=@"1";
    //    }
    //    else if(([[confirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the confirm password field." delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil];
    //        [alert show];
    //        msg=@"1";
    //    }
    else if((![self validateEmail:email.text]) && [msg isEqualToString:@"0"] )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefillthevalidemailaddress", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        msg=@"1";
    }
    else if(([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<6 ) && [msg isEqualToString:@"0"] )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPasswordshouldbeatleast6characters", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        msg=@"1";
    }
    else if (([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ([[confirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ![self isPasswordMatch:password.text withConfirmPwd:confirmPassword.text] && [msg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPassworddoesntmatch", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
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
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSLog(@"There IS internet connection");
            
            [self addLoadingView];
            
            ApiClasses *obj=[[ApiClasses alloc]init];
            
            NSString *str=[NSString stringWithFormat:@"%@registration?salt=%@&email=%@&password=%@&firstname=%@&lastname=%@&device_type=Iphone&device_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,email.text,password.text,firstName.text,lastName.text,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],model.storeID,model.currencyID];
            [obj ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Get_Register_Response:)];
        }
    }
}


-(void) Get_Register_Response:(NSMutableDictionary*) responsedict
{
    [self removeLoadingView];
    NSLog(@"%@ ",responsedict);
    
    if ([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"success"])
    {
        model.custId=[[responsedict valueForKey:@"response"]valueForKey:@"cust_id"] ;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText" ]isEqualToString:@"fail"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[responsedict valueForKey:@"response"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
        
    }
}


#pragma mark ---SignUp NewsLetter---

- (IBAction)SignUpNewsLetter:(UIButton*)sender
{
    UIImage *img1=[UIImage imageNamed:@"uncheck.png"];
    UIImage *img2=sender.imageView.image;
    NSData *imgdata1 = UIImagePNGRepresentation(img1);
    NSData *imgdata2 = UIImagePNGRepresentation(img2);
    
    if ([imgdata1 isEqualToData:imgdata2])
    {
        NSLog(@"Same Image");
        [(UIButton*)[self.scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"blue_tick.png"] forState:UIControlStateNormal];
    }
    else
    {
        [(UIButton*)[self.scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        
    }
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
#pragma mark Email Validation

-(BOOL)validateEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    }
    else
        return YES;
}

@end
