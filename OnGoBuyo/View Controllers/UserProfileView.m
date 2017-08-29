//
//  UserProfileView.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/22/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "UserProfileView.h"
#import "ApiClasses.h"
#import "MBProgressHUD.h"
#import "ModelClass.h"
#import "ViewController.h"
#import "Reachability.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"

@interface UserProfileView ()
{
    ModelClass *model;
    BOOL selected;
    BOOL clickPassword;
     BOOL DownloadContinue;
    NSData *imageData;
}
@end

@implementation UserProfileView
@synthesize emailAddress,firstName,labelEmail,editIcon,lastName,labelFirstName,labelLastName,logoutBorder,profileImage,firstView,lastView,emailView,changePasswordView,scrollView,oldPwdView,nePwdView,confirmPwdView,saveBorder,cancelView,changePasswordButton,barView,oldPassword,nePassword,confirmPassword,labelConfirm,labelnewP,labeloldP;

- (void)viewDidLoad
{
   
     _indicator.hidden = true;
 //   _btnEditImage.userInteractionEnabled = false;
    [self.view TransformViewCont];
    [_topView TransformationView];
    [firstName TransformTextField];
    [labelFirstName TransformAlignLabel];
    [lastName TransformTextField];
    [labelLastName TransformAlignLabel];
    [emailAddress TransformTextField];
    [labelEmail TransformAlignLabel];
    [logoutBorder TransformButton];
    [oldPassword TransformTextField];
    [labeloldP TransformAlignLabel];
    [nePassword TransformTextField];
    [labelnewP TransformAlignLabel];
    [confirmPassword TransformTextField];
    [labelConfirm TransformAlignLabel];
    [saveBorder TransformButton];
    [changePasswordButton TransformButton];
    
    [super viewDidLoad];
    
    //change word
    labelLastName.hidden=YES;
    labelFirstName.hidden=YES;
    labelEmail.hidden=YES;
    [logoutBorder setTitle:AMLocalizedString(@"tLOGOUT", nil)  forState:UIControlStateNormal];
    [saveBorder setTitle:AMLocalizedString(@"tSave", nil) forState:UIControlStateNormal];
    [changePasswordButton setTitle:AMLocalizedString(@"tChangePassword", nil) forState:UIControlStateNormal];
    [labelnewP setText:AMLocalizedString(@"tNewPassword", nil)];
    [labeloldP setText:AMLocalizedString(@"tCurrentPassword", nil)];
    [labelConfirm setText:AMLocalizedString(@"tConfirmPassword", nil)];
    [labelFirstName setText:AMLocalizedString(@"tFirstName", nil)];
    [labelLastName setText:AMLocalizedString(@"tLastName", nil)];
    [labelEmail setText:AMLocalizedString(@"tEMailAddress", nil)];
    [firstName setPlaceholder:AMLocalizedString(@"tFirstName", nil)];
    [lastName setPlaceholder:AMLocalizedString(@"tLastName", nil)];
    [emailAddress setPlaceholder:AMLocalizedString(@"tEMailAddress", nil)];
    [nePassword setPlaceholder:AMLocalizedString(@"tNewPassword", nil)];
    [oldPassword setPlaceholder:AMLocalizedString(@"tCurrentPassword", nil)];
    [confirmPassword setPlaceholder:AMLocalizedString(@"tConfirmPassword", nil)];
    
    model=[ModelClass sharedManager];
    
    if(Is_IPhone4)
    {
        scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height+30);
    }
    else
    {
        scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height);
    }
    //border
    
    [self setBorder:firstView];
    [self setBorder:lastView];
    [self setBorder:emailView];
    [self setBorder:oldPwdView];
    [self setBorder:nePwdView];
    [self setBorder:confirmPwdView];
    
    //    saveBorder.layer.masksToBounds = YES;
    //    saveBorder.layer.cornerRadius = 4.0;
    //    saveBorder.layer.borderWidth = 1.0;
    //    saveBorder.layer.borderColor = [[UIColor clearColor] CGColor];
    //
    //    logoutBorder.layer.masksToBounds = YES;
    //    logoutBorder.layer.cornerRadius = 4.0;
    //    logoutBorder.layer.borderWidth = 1.0;
    //    logoutBorder.layer.borderColor = [[UIColor clearColor] CGColor];
    
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.cornerRadius =profileImage.frame.size.width/2;
    profileImage.layer.borderWidth = 1.0;
    profileImage.layer.borderColor = [[UIColor clearColor] CGColor];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SocialLogin"]==NO)
    {
        editIcon.hidden=NO;
    }
    else
    {
        editIcon.hidden=YES;
    }
    
    //API call
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self getHomePagedata];
        });
    });
    
    
    //    not in edit form
    _btnEditImage.userInteractionEnabled = NO;
    [firstName setUserInteractionEnabled:NO];
    [lastName setUserInteractionEnabled:NO];
    [emailAddress setUserInteractionEnabled:NO];
    
    selected=YES;
    
    labelConfirm.hidden=YES;
    labelnewP.hidden=YES;
    labeloldP.hidden=YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // change color
    [_topView setBackgroundColor:model.themeColor];
    [logoutBorder setBackgroundColor:model.blueClr];
    [saveBorder setBackgroundColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"UserProfileView"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Api Calls

-(void)getHomePagedata
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
        NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
        if ([str5 isEqualToString:@"(null)"])
        {
            str5=@"";
        }
        
        NSString *str=[[NSString alloc]initWithFormat:@"%@userInfo?salt=%@&cust_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,model.storeID,model.currencyID];
        
        //---------------- API----------------------
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_API_Response:)];
    }
}

#pragma mark Api Response

-(void)Get_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    
    if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        if (![[[responseDict valueForKey:@"response"]valueForKey:@"firstname"]isEqual:[NSNull null]])
        {
            firstName.text=  [[[responseDict valueForKey:@"response"]valueForKey:@"firstname"]capitalizedString];
        }
        if (![[[responseDict valueForKey:@"response"]valueForKey:@"lastname"]isEqual:[NSNull null]])
        {
            lastName.text=[[[responseDict valueForKey:@"response"]valueForKey:@"lastname"]capitalizedString];
        }
        if (![[[responseDict valueForKey:@"response"]valueForKey:@"lastname"]isEqual:[NSNull null]])
        {
            lastName.text=[[[responseDict valueForKey:@"response"]valueForKey:@"lastname"]capitalizedString];
        }
         if (![[[responseDict valueForKey:@"response"]valueForKey:@"profile_img_url"]isEqual:[NSNull null]])
        {
             DownloadContinue = YES;
            profileImage.image  =  [UIImage imageNamed:@"user_img.png"];
            _indicator.hidden = false;
            [_indicator startAnimating];
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[responseDict valueForKey:@"response"]valueForKey:@"profile_img_url"]]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // WARNING: is the cell still using the same data by this point??
                    if(DownloadContinue == YES)
                    {
                    profileImage.image = [UIImage imageWithData: data];
                    [_indicator stopAnimating];
                    _indicator.hidden = true;
                    }
                    else
                    {
                        [_indicator stopAnimating];
                        _indicator.hidden = true;
                    }
                   
                });
                //[data release];
            });
    //    [profileImage sd_setImageWithURL:[NSURL URLWithString:[[responseDict valueForKey:@"response"]valueForKey:@"profile_img_url"]] placeholderImage:[UIImage imageNamed:@"user_img.png"]];
        
        }
         else
         {
             profileImage.image  =  [UIImage imageNamed:@"user_img.png"];
         
         }
        
        emailAddress.text=[[responseDict valueForKey:@"response"]valueForKey:@"email"];
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        labelLastName.hidden=YES;
        labelFirstName.hidden=YES;
        labelEmail.hidden=YES;
        
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


#pragma mark TextField Delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==firstName)
    {
        textField.placeholder = nil;
        //labelFirstName.hidden=NO;
        [labelFirstName setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0 alpha:1.0]];
        
        [UIView transitionWithView:self.labelFirstName duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==lastName)
    {
        textField.placeholder = nil;
        //labelLastName.hidden=NO;
        [labelLastName setTextColor:[UIColor colorWithRed:103.0/255.0 green:176.0/255.0 blue:214.0/255.0 alpha:1.0]];
        [UIView transitionWithView:self.labelLastName duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==oldPassword)
    {
        textField.placeholder = nil;
       // labeloldP.hidden=NO;
        
        [UIView transitionWithView:self.labeloldP duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==nePassword)
    {
        textField.placeholder = nil;
       // labelnewP.hidden=NO;
        
        [UIView transitionWithView:self.labelnewP duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL
                        completion:NULL];
    }
    else if (textField==confirmPassword)
    {
        textField.placeholder = nil;
        //labelConfirm.hidden=NO;
        
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
        else if (textField==oldPassword)
        {
            textField.placeholder = AMLocalizedString(@"tCurrentPassword", nil);
            labeloldP.hidden=YES;
        }
        else if (textField==nePassword)
        {
            textField.placeholder = AMLocalizedString(@"tNewPassword", nil);
            labelnewP.hidden=YES;
        }
        else if (textField==confirmPassword)
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
        else if (textField==oldPassword)
        {
            labeloldP.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==nePassword)
        {
            labelnewP.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        else if (textField==confirmPassword)
        {
            labelConfirm.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==firstName)
    {
        [lastName becomeFirstResponder];
    }
    else if(textField==lastName)
    {
        [lastName resignFirstResponder];
    }
    else if(textField==oldPassword)
    {
        [nePassword becomeFirstResponder];
    }
    else if(textField==nePassword)
    {
        [confirmPassword becomeFirstResponder];
    }
    else
    {
        [confirmPassword resignFirstResponder];
    }
    
    return YES;
}

#pragma mark Logout Button

- (IBAction)Logout:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tAreyousureyouwanttologout", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tNO", nil) otherButtonTitles:AMLocalizedString(@"tYES", nil), nil];
    alert.tag=43;
    
    [alert show];
    
}

#pragma mark ---Alert view Delegate Methods---

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==43)
    {
        if (buttonIndex==1)
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SocialLogin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"quote_id"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"quote_count"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"login"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectCountry1"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectCountry2"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectCountry3"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectCountry4"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Cust_id"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"onlyOnce"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginaddtoCart"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Subtotal"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cancelOrder"];
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[ViewController class]])
                {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
            
        }
        
    }
}

#pragma mark Back Button

- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)EditImageAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please Select Your Option"delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",nil];
    
    [actionSheet showInView:self.view];

}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    NSLog(@"From didDismissWithButtonIndex - Selected Option: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    NSString*image=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"]) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Device Camera Is Not Working" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        else{
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
    }
    
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Gallery"]){
        
        
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        [pickerView setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [self presentViewController:pickerView animated:YES completion:nil];
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   // UIImage* orginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    [_indicator stopAnimating];
    _indicator.hidden = true;
    UIImage *cameraImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    profileImage.image = cameraImage;
    
        imageData = UIImagePNGRepresentation(cameraImage);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark Edit Button

- (IBAction)EditButton:(id)sender
{
    if (selected==YES)
    {
        _btnEditImage.userInteractionEnabled = YES;
        [firstName setUserInteractionEnabled:YES];
        
        [lastName setUserInteractionEnabled:YES];
        
        changePasswordView.frame=CGRectMake(0, emailView.frame.origin.y+50, self.view.frame.size.width, 140);
        [scrollView addSubview:changePasswordView];
        changePasswordView.hidden=NO;
        
        saveBorder.frame=CGRectMake(saveBorder.frame.origin.x, cancelView.frame.origin.y+10, saveBorder.frame.size.width, saveBorder.frame.size.height);
        cancelView.hidden=YES;
        selected=NO;
    }
    else
    {
        _btnEditImage.userInteractionEnabled = NO;
        [firstName setUserInteractionEnabled:NO];
        [labelFirstName setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [lastName setUserInteractionEnabled:NO];
        [labelFirstName setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        changePasswordView.hidden=YES;
        selected=YES;
        clickPassword=NO;
        [changePasswordButton setTitle:AMLocalizedString(@"tChangePassword", nil) forState:UIControlStateNormal];
        changePasswordButton.tag=61;
    }
}

#pragma mark ChangePassword/Cancel Method

- (IBAction)ChangePasswordCancel:(id)sender
{
    UIButton *button=(UIButton*)sender;
    if (button.tag==61)
    {
        changePasswordView.frame=CGRectMake(0, emailView.frame.origin.y+50, self.view.frame.size.width, 300);
        
        if(Is_IPhone4)
        {
            scrollView.contentSize=CGSizeMake(320, changePasswordView.frame.origin.y+changePasswordView.frame.size.height);
        }
        else
        {
            scrollView.contentSize=CGSizeMake(320, changePasswordView.frame.origin.y+changePasswordView.frame.size.height);
        }
        saveBorder.frame=CGRectMake(saveBorder.frame.origin.x, 240, saveBorder.frame.size.width, saveBorder.frame.size.height);
        cancelView.hidden=NO;
        [changePasswordButton setTitle:AMLocalizedString(@"tCancel", nil) forState:UIControlStateNormal];
        clickPassword=YES;
        changePasswordButton.tag=62;
        
    }
    else
    {
        changePasswordView.frame=CGRectMake(0, emailView.frame.origin.y+50, self.view.frame.size.width, 120);
        if(Is_IPhone4)
        {
            scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height+30-62);
        }
        else
        {
            scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height-62);
        }

        
        saveBorder.frame=CGRectMake(saveBorder.frame.origin.x, cancelView.frame.origin.y+10, saveBorder.frame.size.width, saveBorder.frame.size.height);
        cancelView.hidden=YES;
        [changePasswordButton setTitle:AMLocalizedString(@"tChangePassword", nil) forState:UIControlStateNormal];
        clickPassword=NO;
        changePasswordButton.tag=61;
    }
    
}

#pragma mark Save Button method

- (IBAction)saveButton:(id)sender
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
        
        NSString *msg=@"0";
        
        if(([[firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefillthefirstname", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else if(([[lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefillthelastname", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else if(([[oldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] && clickPassword==YES)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefilltheCurrentPassword", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else if(([[nePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] && clickPassword==YES )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefilltheNewPassword", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else if(([[confirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"] && clickPassword==YES)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasefilltheConfirmPassword", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else if(([[oldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ([[oldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<6) && [msg isEqualToString:@"0"] && clickPassword==YES )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPasswordshouldbeatleast6characters", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else if(([[nePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ([[nePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<6) && [msg isEqualToString:@"0"] && clickPassword==YES )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPasswordshouldbeatleast6characters", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else if(([[confirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ([[nePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<6) && [msg isEqualToString:@"0"] && clickPassword==YES)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPasswordshouldbeatleast6characters", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        
        else if (([[nePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ([[confirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) && ![self isPasswordMatch:nePassword.text withConfirmPwd:confirmPassword.text] && [msg isEqualToString:@"0"] && clickPassword==YES)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPassworddoesntmatch", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            msg=@"1";
        }
        else
        {
            [self addLoadingView];
            
            ApiClasses *obj=[[ApiClasses alloc]init];
            NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
            if ([str5 isEqualToString:@"(null)"])
            {
                str5=@"";
            }
            
            NSString *str=[NSString stringWithFormat:@"%@updateUserInfo?salt=%@&cust_id=%@&firstname=%@&lastname=%@&current_pass=%@&password=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,firstName.text,lastName.text,oldPassword.text,confirmPassword.text,model.storeID,model.currencyID]
            ;
            
            if(imageData.length>0)
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:model.salt forKey:@"salt"];
                 [dic setObject:str5 forKey:@"cust_id"];
                [dic setObject:firstName.text forKey:@"firstname"];
                 [dic setObject:lastName.text forKey:@"lastname"];
                [dic setObject:oldPassword.text forKey:@"current_pass"];
                [dic setObject:confirmPassword.text forKey:@"password"];
                 [dic setObject:model.storeID forKey:@"cstore"];
                 [dic setObject:model.currencyID forKey:@"ccurrency"];
                
                
                NSString *UrlStr = [NSString stringWithFormat:@"%@%@",baseURL1,@"updateUserInfo"];
                [obj UploadImage:UrlStr Data:imageData parameters:dic withTarget:self withSelector:@selector(Get_SaveProfile_Response:)];
            }
            else
            {
                 [obj ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self  withSelector:@selector(Get_SaveProfile_Response:)];
                
            }
           
        }
    }
}


-(void) Get_SaveProfile_Response:(NSMutableDictionary*) responsedict
{
    [self removeLoadingView];
    NSLog(@"%@ ",responsedict);
    if (![[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"success"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[responsedict valueForKey:@"response"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        
    }
    else if([[[responsedict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        oldPassword.text=@"";
        nePassword.text=@"";
        confirmPassword.text=@"";
        if(clickPassword == YES)
        {
        changePasswordView.frame=CGRectMake(0, emailView.frame.origin.y+50, self.view.frame.size.width, 120);
        saveBorder.frame=CGRectMake(saveBorder.frame.origin.x, cancelView.frame.origin.y+10, saveBorder.frame.size.width, saveBorder.frame.size.height);
        cancelView.hidden=YES;
        [changePasswordButton setTitle:AMLocalizedString(@"tChangePassword", nil) forState:UIControlStateNormal];
        clickPassword=NO;
        changePasswordButton.tag=61;
        if(Is_IPhone4)
        {
            scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height+30-62);
        }
        else
        {
            scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height-62);
        }

        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPasswordChangeSuccess", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tProfileUpadteSuccess", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
        
    }
}


#pragma mark password match

-(BOOL)isPasswordMatch:(NSString *)pwd withConfirmPwd:(NSString *)cnfPwd
{
    if([pwd isEqualToString:cnfPwd])
    {
        NSLog(@"Hurray! Password matches ");
        return TRUE;
    }
    else
    {
        NSLog(@"Oops! Password does not matches");
        return FALSE;
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

- (IBAction)ForgotAction:(id)sender
{
    ForgotPasswordView *objViewController=[[ForgotPasswordView alloc]initWithNibName:@"ForgotPasswordView" bundle:nil];
    [self.navigationController pushViewController:objViewController animated:YES];
    objViewController=nil;
}
@end
