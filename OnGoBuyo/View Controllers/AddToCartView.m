//
//  AddToCartView.m
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 2/16/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "AddToCartView.h"
#import "AddToCartCell.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import "ModelClass.h"
#import "AppInfoView.h"
#import "AppDelegate.h"
#import "UserProfileView.h"
#import "BillingAndShippingView.h"
#import "MyOrdersViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "Reachability.h"
#import "NotificationCenter.h"
#import "LoginViewController.h"
#import "DownloadableView.h"
#import "WishListViewViewController.h"
#import <Google/Analytics.h>
#import "LanguageSettingView.h"
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"
#import "ProductDetailsViewController.h"

@interface AddToCartView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * productArray;
    ModelClass     * model;
    NSString       * itemID;
    NSString       * productID;
    BOOL clicked;
    UIView *coverView1;
    int isVirtual;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton    *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton    *btnConfirm;
@property (weak, nonatomic) IBOutlet UILabel     *lblSubtotal;
@property (weak, nonatomic) IBOutlet UILabel     *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel     *lblTaxes;
@property (weak, nonatomic) IBOutlet UILabel     *lblDelivery;
@property (weak, nonatomic) IBOutlet UILabel     *lblTotalOrder;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UITextField *tftCoupon;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation AddToCartView
@synthesize tableView1,delegate;

- (void)viewDidLoad
{
    [self.view TransformViewCont];
    [_topView TransformationView];
    [cartdetailLbl TransformLabel];
    [subtotalLbl TransformAlignLabel];
    [_lblSubtotal TransformAlignLeftLabel];
    [discountLbl TransformAlignLabel];
    [taxesLbl TransformAlignLabel];
    [deliveryChargeLbl TransformAlignLabel];
    [_lblTaxes TransformAlignLeftLabel];
    [_lblDelivery TransformAlignLeftLabel];
    [_lblDiscount TransformAlignLeftLabel];
    [orderTotalLbl TransformAlignLabel];
    [_lblTotalOrder TransformAlignLeftLabel];
    [haveACouponLbl TransformAlignButton];
    [removecouponLbl TransformAlignButton];
    [_btnCancel TransformButton];
    [_btnConfirm TransformButton];
    [_ifLbl TransformLabel];
    [continueAsGuestLbl TransformButton];
    [_loginNowBorder TransformButton];
    [orLbl TransformLabel];
    [couponCodeLbl TransformLabel];
    [enterCouponLbl TransformLabel];
    [_applyBtn TransformButton];
    [_tftCoupon TransformTextField];
    [_completeIcon TransformImage];
    
    [super viewDidLoad];
    
    
    //word change
    [cartdetailLbl setText:AMLocalizedString(@"tCartdetails", nil)];
    [subtotalLbl setText:AMLocalizedString(@"tSUBTOTAL", nil)];
    [discountLbl setText:AMLocalizedString(@"tDISCOUNT", nil)];
    [taxesLbl setText:AMLocalizedString(@"tTAXES", nil)];
    [deliveryChargeLbl setText:AMLocalizedString(@"tDELIVERYCHARGES", nil)];
    [orderTotalLbl setText:AMLocalizedString(@"tORDERTOTAL", nil)];
    [haveACouponLbl setTitle:AMLocalizedString(@"tHaveaCoupon", nil) forState:UIControlStateNormal];
    [removecouponLbl setTitle:AMLocalizedString(@"tRemoveCoupon", nil) forState:UIControlStateNormal];
    [_btnCancel setTitle:AMLocalizedString(@"tCANCEL", nil) forState:UIControlStateNormal];
    [_btnConfirm setTitle:AMLocalizedString(@"tCONFIRM", nil) forState:UIControlStateNormal];
    [enterCouponLbl setText:AMLocalizedString(@"tEnteryourcouponcodehere", nil)];
    [couponCodeLbl setText:AMLocalizedString(@"tCouponCode", nil)];
    [_applyBtn setTitle:AMLocalizedString(@"tAPPLY", nil) forState:UIControlStateNormal];
    [_ifLbl setText:AMLocalizedString(@"tITLOOKSLIKEYOUARENOTLOGGEDIN", nil)];
    [continueAsGuestLbl setTitle:AMLocalizedString(@"tContinueAsaGuestUser", nil) forState:UIControlStateNormal];
    [_loginNowBorder setTitle:AMLocalizedString(@"tLoginNow", nil) forState:UIControlStateNormal];
    [orLbl setText:AMLocalizedString(@"tOR", nil)];
    
    //    _loginNowBorder.layer.cornerRadius=4.0;
    //    _loginNowBorder.layer.masksToBounds=YES;
    //    _loginNowBorder.layer.borderWidth=1.0;
    //    _loginNowBorder.layer.borderColor=[[UIColor clearColor] CGColor];
    
    delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    model=[ModelClass sharedManager];
    productArray = [NSMutableArray new];
    
    [self.completeIcon setHidden:YES];
    [self.removeCoupon setHidden:YES];
    [self.separator setHidden:YES];
    isVirtual=3;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView1 setHidden:YES];
    //change color
    
    [_topView setBackgroundColor:model.themeColor];
    [_btnCancel setBackgroundColor:model.buttonColor];
    [_loginNowBorder setBackgroundColor:model.greenClr];
   // [_ifLbl setTextColor:model.priceColor];
    [_applyBtn setBackgroundColor:model.secondaryColor];
    [enterCouponLbl setBackgroundColor:model.saffronClr];
    [cartdetailLbl setTextColor:[UIColor whiteColor]];
    [_lblTotalOrder setTextColor:model.saffronClr];
    [haveACouponLbl setTitleColor:model.saffronClr forState:UIControlStateNormal];
    [_btnConfirm setBackgroundColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"AddToCartView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
    
    NSString *str1=[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"];
    //NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    NSArray *arrAdd;
    if(([pT intValue]==101) || ([pT intValue]==1011) )
    {
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil), AMLocalizedString(@"tAppInfo",nil),AMLocalizedString(@"tLanguage",nil),AMLocalizedString(@"tLogout", nil), nil];
    }
    else
    {
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil),AMLocalizedString(@"tMyWishList", nil),AMLocalizedString(@"tMyDownloadables", nil),AMLocalizedString(@"tAppInfo", nil),AMLocalizedString(@"tNotifications", nil),AMLocalizedString(@"tLanguage", nil),AMLocalizedString(@"tLogout", nil), nil];
    }
    NSArray *arrAdd2=[NSArray arrayWithObjects:AMLocalizedString(@"tLogin", nil),AMLocalizedString(@"tAppInfo", nil),AMLocalizedString(@"tLanguage",nil), nil];
    
    if (str1.length!=0)
    {
        if (delegate.arrOptions.count!=0)
        {
            [delegate.arrOptions removeAllObjects];
        }
        [delegate.arrOptions addObjectsFromArray:arrAdd];
        [tableView1 reloadData];
    }
    else
    {
        if (delegate.arrOptions.count!=0)
        {
            [delegate.arrOptions removeAllObjects];
        }
        [delegate.arrOptions addObjectsFromArray:arrAdd2];
    }
    
    [self cartDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Add cart Api response

-(void)cartDetail
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
        
        //        self.btnCancel.layer.cornerRadius = 4;
        //        self.btnCancel.clipsToBounds = YES;
        
        //        self.btnConfirm.layer.cornerRadius = 4;
        //        self.btnConfirm.clipsToBounds = YES;
        
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
    if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"success"])
    {
        if ([[responseDict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"%@-----",responseDict);
            
            
            NSArray * arr = [[responseDict valueForKey:@"response"]valueForKey:@"products"];
            
            if(arr.count>0)
            {
                if(productArray.count>0)
                {
                    [productArray removeAllObjects];
                }
                [productArray addObjectsFromArray:arr];
                model.totalCount = arr.count;
                
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"response"]valueForKey:@"quote_count"]] forKey:@"quote_count"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tblView reloadData];
            }
            else
            {
                if(productArray.count>0)
                {
                    [productArray removeAllObjects];
                }
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",0] forKey:@"quote_count"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tblView reloadData];
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tYourCartIsEmpty", nil) message:nil delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
                [alert show];
                
                alert.tag = 1112;
            }
            isVirtual=[[[responseDict valueForKey:@"response"]valueForKey:@"is_virtual"]intValue];
            
            self.lblSubtotal.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"subtotal"]];
            
            self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"discount"]];
            
            self.lblTaxes.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"tax"]];
            
            self.lblDelivery.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"ship_cost"]];
            
            
            self.lblTotalOrder.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"grandtotal"]];
            
            if (![[[responseDict valueForKey:@"response"]valueForKey:@"coupon_applied"]isEqual:[NSNull null]])
            {
                [self.buttonCoupon setTitle:AMLocalizedString(@"tCouponApplied", nil) forState:UIControlStateNormal];
                [self.completeIcon setHidden:NO];
                [self.removeCoupon setHidden:NO];
                [self.separator setHidden:NO];
            }
        }
    }
    else
    {
        if ([[responseDict valueForKey:@"response"] rangeOfString:@"Cart is de-activated"].location != NSNotFound )
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
            
            [[NSUserDefaults standardUserDefaults]setValue:0 forKey:@"quote_count"];
        }
        else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"Server Down" ])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


#pragma mark - TableView Delegate And DataSources



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tableView1)
    {
        return [delegate.arrOptions count];
    }
    else
    {
        return [productArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableView1)
    {
        return 35.0;
    }
    else
    {
        if(![[[productArray objectAtIndex:indexPath.row]valueForKey:@"options"]isEqualToString:@""])
        {
            NSString *labelText = [self stringByStrippingHTML:[[productArray objectAtIndex:indexPath.row]valueForKey:@"options"]];
            float height =[self heightForText:labelText];
            return height+140;
        }
        else
        {
            NSString *labelText = [self stringByStrippingHTML:[[productArray objectAtIndex:indexPath.row]valueForKey:@"options"]];
            float height =[self heightForText:labelText];
            return height+120;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableView1)
    {
        NSString *cellIdentifier=@"Cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.frame=CGRectMake(5, 2, 120, 22);
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.text=[delegate.arrOptions objectAtIndex:indexPath.row];
        [cell.textLabel TransformAlignLabel];
        
        cell.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"AddToCartCell";
        AddToCartCell *cell = (AddToCartCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        
        [cell.imgSide sd_setImageWithURL:[[productArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        [cell.imgSide TransformImage];
        [cell.lblProduct TransformAlignLabel];
        [cell.lblQty TransformOnlyTextField];
        [cell.tftQuantity TransformOnlyTextField];
        [cell.lblprize TransformAlignLeftLabel];
        [cell.btnWrite TransformButton];
        [cell.btnDelete TransformButton];
        [cell.btnWrite TransformButton];
        [cell.labelOptions TransformAlignLabel];
        [cell.outOfStock TransformAlignLabel];
        
        
        cell.imgSide.layer.cornerRadius = cell.imgSide.frame.size.width/2;
        cell.imgSide.clipsToBounds = YES;
        
        cell.lblProduct.text = [[[productArray objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        cell.lblProduct.textColor=model.saffronClr;
        
        cell.lblQty.text=AMLocalizedString(@"tQty", nil);
        //        cell.lblQty.layer.cornerRadius = 4;
        //        cell.lblQty.clipsToBounds = YES;
        
        NSString * str = [NSString stringWithFormat:@"%@ %@",model.currencySymbo ,[[productArray objectAtIndex:indexPath.row]valueForKey:@"price"]];
        
        cell.lblprize.text = str;
        
        cell.tftQuantity.text =[[[productArray objectAtIndex:indexPath.row]valueForKey:@"qty"]stringValue];
        
        [cell.tftQuantity setUserInteractionEnabled:NO];
        //        cell.tftQuantity.layer.cornerRadius = 4;
        //        cell.tftQuantity.clipsToBounds = YES;
        cell.tftQuantity.tag = indexPath.row+111;
        
        //        cell.imgBackground.layer.cornerRadius = 8;
        //        cell.imgBackground.clipsToBounds = YES;
        
        [cell.btnDelete addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag = indexPath.row;
        
        [cell.btnWrite addTarget:self action:@selector(writeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnWrite.tag = indexPath.row;
        cell.outOfStock.text=AMLocalizedString(@"tOutofStock", nil);
        
        if ([[[productArray objectAtIndex:indexPath.row]valueForKey:@"isSalable"]intValue]==1)
        {
            cell.outOfStock.hidden=YES;
        }
        else
        {
            cell.outOfStock.hidden=NO;
        }
        if (![[[productArray objectAtIndex:indexPath.row]valueForKey:@"options"]isEqualToString:@""])
        {
            cell.labelOptions.hidden=NO;
            cell.labelOptions.text=[self stringByStrippingHTML:[[[productArray objectAtIndex:indexPath.row]valueForKey:@"options"]stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"]];
        }
        else
        {
            cell.labelOptions.hidden=YES;
        }
        [cell.btnProduct addTarget:self action:@selector(btnProductDetail:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnProduct.tag = indexPath.row;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableView1)
    {
        clicked=NO;
        if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tAppInfo", nil)])
        {
            AppInfoView * obj = [[AppInfoView alloc]initWithNibName:@"AppInfoView" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tProfile", nil)])
        {
            UserProfileView * obj = [[UserProfileView alloc]initWithNibName:@"UserProfileView" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tMyOrders", nil)])
        {
            MyOrdersViewController * obj = [[MyOrdersViewController alloc]initWithNibName:@"MyOrdersViewController" bundle:nil];
            self.tableView1.hidden=YES;
            
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tNotifications", nil)])
        {
            NotificationCenter * obj = [[NotificationCenter alloc]initWithNibName:@"NotificationCenter" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tLanguage", nil)])
        {
            LanguageSettingView * obj = [[LanguageSettingView alloc]initWithNibName:@"LanguageSettingView" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tLogin", nil)])
        {
            LoginViewController * obj = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tMyWishList", nil)])
        {
            WishListViewViewController * obj = [[WishListViewViewController alloc]initWithNibName:@"WishListViewViewController" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tMyDownloadables", nil)])
        {
            DownloadableView * obj = [[DownloadableView alloc]initWithNibName:@"DownloadableView" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SocialLogin"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginAddWishlist"];
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
            
            model.custId=[NSString stringWithFormat:@""];
            
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[ViewController class]])
                {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }
        [tableView1 removeFromSuperview];
    }
}


#pragma mark - Delete item Button

-(void)deleteBtnAction:(UIButton *)sender
{
    itemID = [[productArray objectAtIndex:[sender tag]]valueForKey:@"item_id"];
    
    productID = [[productArray objectAtIndex:[sender tag]]valueForKey:@"prod_Id"];
    
    //NSString * str1  = [[productArray objectAtIndex:[sender tag]]valueForKey:@"name"];
    
    //NSString * str  = [NSString stringWithFormat:@"%@ %@ %@",AMLocalizedString(@"tYouritem", nil),[str1 uppercaseString],AMLocalizedString(@"twillbedeletedConfirmtocontinue", nil)];
    NSString * str = @"Product will be deleted";
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tConfirmDelete", nil) message:str delegate:self cancelButtonTitle:AMLocalizedString(@"tYES", nil) otherButtonTitles:AMLocalizedString(@"tNO", nil), nil];
    [alert show];
    alert.tag = 1111;
}


#pragma mark - Alert View Delegate Method

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    
    if (buttonIndex == 0 && alertView.tag ==1111)
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
            NSString * str2 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
            
            NSString* str3;
            
            if(str2.length!=0)
            {
                str3=[NSString stringWithFormat:@"%@deletefromcart?salt=%@&quote_id=%@&item_id=%@&prod_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str2,itemID,productID,model.storeID,model.currencyID];
                
                [obj_apiClass ViewMore:[str3 stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Delete_Response:)];
            }
            else
            {
                [self removeLoadingView];
            }
        }
    }
    else if(buttonIndex == 0 && alertView.tag ==1112)
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
    else if(alertView.tag==97 || alertView.tag==98 || alertView.tag==96)
    {
        [self cartDetail];
    }
}


#pragma mark ---Navigate to product detail---

-(void)btnProductDetail:(UIButton *)sender
{
    NSString * str1 = [[productArray objectAtIndex:[sender tag]]valueForKey:@"prod_Id"];
    ProductDetailsViewController *detail=[[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
    detail.strProdId=str1;
    
    [self.navigationController pushViewController:detail animated:YES];
    detail=nil;
    
}


#pragma mark - Update Quenty Button Action

-(void)writeBtnAction:(UIButton *)sender
{
    UIImage * image = [UIImage imageNamed:@"edit_iconcart.png"];
    
    NSData *data1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *data2 = UIImagePNGRepresentation(image);
    
    NSLog(@"sender image------%@",sender.imageView.image);
    
    if([data1 isEqual:data2])
    {
        [sender setImage:[UIImage imageNamed:@"tick_icon.png"] forState:UIControlStateNormal];
        
        [(UITextField *)[self.view viewWithTag:[sender tag]+111]setUserInteractionEnabled:YES];
        
        [(UITextField *)[self.view viewWithTag:[sender tag]+111]becomeFirstResponder];
    }
    else
    {
        
        [sender setImage:[UIImage imageNamed:@"edit_iconcart.png"] forState:UIControlStateNormal];
        
        [(UITextField *)[self.view viewWithTag:[sender tag]+111]setUserInteractionEnabled:NO];
        
        [(UITextField *)[self.view viewWithTag:[sender tag]+111]resignFirstResponder];
        
        NSString * str1 = [[[productArray objectAtIndex:[sender tag]]valueForKey:@"qty"]stringValue];
        
        NSString * str =  [(UITextField *)[self.view viewWithTag:[sender tag]+111]text];
        
        // Update Api Method
        
        if(![str isEqualToString:str1])
        {
            [self UpdateCart:[[productArray objectAtIndex:[sender tag]]valueForKey:@"prod_Id"] item:[[productArray objectAtIndex:[sender tag]]valueForKey:@"item_id"] Quty:str];
        }
    }
    
}

// Update Api

-(void)UpdateCart:(NSString *)productID1 item:(NSString *)itemID1 Quty:(NSString *)qty
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
        NSString * str2 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        
        NSString* str3;
        
        if(str2.length!=0)
        {
            str3=[NSString stringWithFormat:@"%@updateCart?salt=%@&quote_id=%@&item_id=%@&prod_id=%@&qty=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str2,itemID1,productID1,qty,model.storeID,model.currencyID];
            
            [obj_apiClass ViewMore:[str3 stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Write_Response:)];
        }
        else
        {
            [self removeLoadingView];
        }
    }
}


// Update Button Response

-(void)Get_Write_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    
    if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[responseDict valueForKey:@"response"] message:nil delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
        alert.tag=97;
    }
    else  if ([[[responseDict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle: [responseDict valueForKey:@"response"]message:nil delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
        alert.tag=98;
    }
}

#pragma mark Delete Button Response

-(void)Get_Delete_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"response------%@",responseDict);
    [self cartDetail];
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

#pragma mark - Touch Begun Event

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [coverView1 removeFromSuperview];
    [tableView1 setHidden:YES];
    if(self.tftCoupon.text.length==0)
    {
        [self.coverView removeFromSuperview];
    }
}


#pragma mark - Back Button Action

- (IBAction)backBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Cancel Button Action

- (IBAction)cancelBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Coupon Button Action

- (IBAction)couponBtn_Action:(UIButton*)sender
{
    //    self.couponView.layer.cornerRadius = 4;
    //    self.couponView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    self.couponView.layer.borderWidth = 1.0f;
    //    self.couponView.clipsToBounds = YES;
    
    //    self.backView.layer.cornerRadius = 4;
    //    self.backView.clipsToBounds = YES;
    
    //    self.applyBtn.layer.cornerRadius = 4;
    //    self.applyBtn.clipsToBounds = YES;
    if (sender.tag==888)
    {
        self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        self.coverView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height-20);
        
        [self.tftCoupon becomeFirstResponder];
        self.tftCoupon.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.view addSubview:self.coverView];
    }
    
}

#pragma mark - Coupon Apply Button Action

- (IBAction)applyBtn_Action:(id)sender
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
        if([[self.tftCoupon.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleaseentercouponcode", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            [self addLoadingView];
            
            [self.tftCoupon resignFirstResponder];
            [self.coverView removeFromSuperview];
            
            // Apply Coupon Api
            
            ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
            NSString * str2 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
            
            NSString* str3;
            
            if(str2.length!=0)
            {
                NSString *unreserved = @"*-._";
                NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                                  alphanumericCharacterSet];
                [allowed addCharactersInString:unreserved];
                
                [allowed addCharactersInString:@" "];
                
                NSString *encoded = [self.tftCoupon.text stringByAddingPercentEncodingWithAllowedCharacters:allowed];
                
                encoded = [encoded stringByReplacingOccurrencesOfString:@" "
                                                             withString:@"+"];
                NSLog(@"%@",encoded);
                str3=[NSString stringWithFormat:@"%@addCoupon?salt=%@&quote_id=%@&coupon_code=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str2,encoded,model.storeID,model.currencyID];
                
                [obj_apiClass ViewMore:[str3 stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Apply_Coupon_Response:)];
            }
            else
            {
                [self removeLoadingView];
            }
        }
    }
}


-(void)Apply_Coupon_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    if ([[responseDict valueForKey:@"response"]isKindOfClass:[NSDictionary class]])
    {
        if ([[[responseDict valueForKey:@"response"]valueForKey:@"applied"]intValue]==1)
        {
            
            [self.buttonCoupon setTitle:AMLocalizedString(@"tCouponApplied", nil) forState:UIControlStateNormal];
            [self.buttonCoupon setTag:889];
            [self.completeIcon setHidden:NO];
            [self.removeCoupon setHidden:NO];
            [self.separator setHidden:NO];
        }
        
        
        self.lblSubtotal.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"subtotal"]];
        
        self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"discount"]];
        
        self.lblTaxes.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"tax"]];
        
        self.lblTotalOrder.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"grandtotal"]];
        
    }
    else
    {
        if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[responseDict valueForKey:@"response"] message:nil delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        else  if ([[[responseDict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
        
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[responseDict valueForKey:@"response"] message:nil delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


#pragma mark - Text Field Delegate Method

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.tftCoupon)
    {
        return YES;
    }
    else
    {
        if([textField.text length] - range.length + textField.text.length < 4)
            return YES;
        else
            return NO;
    }
}


#pragma mark - App Info Button Action

- (IBAction)appInfoBtn_Action:(id)sender
{
    if (clicked==NO)
    {
        tableView1.hidden=NO;
        [tableView1 setFrame:CGRectMake(140, 28, 170,delegate.arrOptions.count*35)];
        //        tableView1.layer.masksToBounds = YES;
        //        tableView1.layer.cornerRadius = 4.0;
        //        tableView1.layer.borderWidth = 1.0;
        //        tableView1.layer.borderColor=[[UIColor clearColor]CGColor];
        [self.view addSubview:tableView1];
        clicked=YES;
    }
    else
    {
        tableView1.hidden=YES;
        clicked=NO;
    }
}

#pragma mark ---Confirm Button method---

- (IBAction)confirmButton:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES)
    { // -------------------------- Reachability --------------------//
        
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
            }
        }
    }
    else
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        coverView1 = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, (self.view.frame.size.height)-20)];
        coverView1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.loginOrGuestView.frame=CGRectMake(self.view.frame.origin.x+11, 180, self.view.frame.size.width-22, 150);
        [self.view addSubview:coverView1];
        [coverView1 addSubview:self.loginOrGuestView];
    }
}

-(void)Get_Confirm_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    if (![[[responseDict valueForKey:@"response"]valueForKey:@"isSalable"]isEqual:[NSNull null]])
    {
        if ([[[responseDict valueForKey:@"response"]valueForKey:@"isSalable"]intValue]==1)
        {
            BillingAndShippingView *objViewcontroller=[[BillingAndShippingView alloc] initWithNibName:@"BillingAndShippingView" bundle:nil];
            [self.navigationController pushViewController:objViewcontroller animated:YES];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleaseremoveproductswhichareoutofstock", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            alert.tag=96;
        }
    }
}


#pragma mark ---LoginOrGuestButton---

- (IBAction)LoginOrGuestButton:(id)sender
{
    UIButton *button=(UIButton*)sender;
    if (button.tag==51)//guest user
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
            [coverView1 removeFromSuperview];
            
            [self addLoadingView];
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
            }
        }
    }
    else//login user
    {
        [coverView1 removeFromSuperview];
        LoginViewController *obj=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        obj.strPage=@"Confirmbutton";
        [self.navigationController pushViewController:obj animated:YES];
        
    }
}

#pragma mark ---Remove Coupon---

- (IBAction)removeCoupon:(id)sender
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
        ApiClasses *obj_apiClass=[[ApiClasses alloc]init];
        
        NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
        NSString* str;
        
        if(str1.length!=0)
        {
            str=[NSString stringWithFormat:@"%@remCoupon?salt=%@&quote_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str1,model.storeID,model.currencyID];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_RemoveCoupon_Response:)];
        }
        else
        {
            [self removeLoadingView];
        }
    }
}

-(void)Get_RemoveCoupon_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"response"]isKindOfClass:[NSDictionary class]])
    {
        if ([[[responseDict valueForKey:@"response"]valueForKey:@"removed"] intValue]==1)
        {
            
            [self.buttonCoupon setTitle:AMLocalizedString(@"tHaveaCoupon", nil) forState:UIControlStateNormal];
            [_buttonCoupon setTag:888];
            [self.completeIcon setHidden:YES];
            [self.removeCoupon setHidden:YES];
            [self.separator setHidden:YES];
        }
        self.lblSubtotal.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"subtotal"]];
        
        self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"discount"]];
        
        self.lblTaxes.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"tax"]];
        
        self.lblTotalOrder.text = [NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[responseDict valueForKey:@"response"]valueForKey:@"grandtotal"]];
    }
    else if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"fail"])
    {
        if ([[[responseDict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[responseDict valueForKey:@"response"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
        
    }
    
}

#pragma mark ---Helper Methods---

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    
    return str;
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11.0], NSParagraphStyleAttributeName: style};
    CGRect rect = [bodyText boundingRectWithSize:CGSizeMake(127, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    return rect.size.height;
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
