//
//  LanguageSettingView.m
//  Ongobuyo
//
//  Created by navjot_sharma on 7/7/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import "LanguageSettingView.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "Reachability.h"
#import <Google/Analytics.h>
#import "ModelClass.h"
#import "Constants.h"
#import "LocalizationSystem.h"
#import "LanguageCell.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"
#import "AppDelegate.h"
@interface LanguageSettingView ()
{
    ModelClass *model;
    NSMutableArray *arrLanguage;
    NSMutableArray *arrCurrency;
    AppDelegate *delegate;
    NSString *strLang;
    NSString *selectedLangId;
    NSString *selectedLangCode;
    NSString *selectedCurrCode;
    NSString *selectedCurrID;
}

@end

@implementation LanguageSettingView

- (void)viewDidLoad
{
    model=[ModelClass sharedManager];
    [self.view TransformViewCont];
    [_topView TransformationView];
    [_languageSettingLbl TransformLabel];
    [_applyBtn TransformButton];
    [super viewDidLoad];
    
    
    arrLanguage=[NSMutableArray new];
    [_languageSettingLbl setText:AMLocalizedString(@"tLanguageSettings", nil)];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_topView setBackgroundColor:model.themeColor];
    [_languageSettingLbl setTextColor:[UIColor whiteColor]];
    
    //API call
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        dispatch_async(dispatch_get_main_queue(), ^{
            // -------------------------- Reachability --------------------//
            
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                NSLog(tNoInternet);
                [self alertViewM:AMLocalizedString(@"tNoInternet", nil)];
            }
            else
            {
                NSLog(@"There IS internet connection");
                // Update the UI
                [self addLoadingView];
                [self getStoreList];
                
            }
        });
    });
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---Store List Api---

-(void)getStoreList
{
    NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
    if ([str5 isEqualToString:@"(null)"])
    {
        str5=@"";
    }
    NSString *str=[NSString stringWithFormat:@"%@getStoreList?salt=%@",baseURL1,model.salt];
    
    //---------------- API----------------------
    
    ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
    
    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_Response:)];
    
}

-(void)Get_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"response"]isKindOfClass:[NSDictionary class]])
    {
        selectedLangId=[[NSUserDefaults standardUserDefaults]valueForKey:@"langId"];
        
        if (selectedLangId == nil)
        {
            selectedLangId=[[responseDict valueForKey:@"response"]valueForKey:@"default_store_id"];
        }
        
        model.storeID=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"storeID"]];
        
        if ([model.storeID isEqualToString:@"(null)"])
        {
            model.storeID=[NSString stringWithFormat:@"%@",@""];
        }
        NSArray *arr=[[responseDict valueForKey:@"response"]valueForKey:@"stores"];
        
        [arrLanguage removeAllObjects];
        
        for (int i=0; i<arr.count; i++)
        {
            if ([[[arr objectAtIndex:i]valueForKey:@"is_active"]intValue]==1)
            {
                [arrLanguage addObject:[arr objectAtIndex:i]];
            }
        }
        
        if (arrLanguage.count!=0)
        {
            [_tableLanguage reloadData];
        }
        selectedCurrCode=model.currencySymbo;
        arrCurrency=[[responseDict valueForKey:@"response"] valueForKey:@"currency"];
        if (arrCurrency.count!=0)
        {
            [_tableCurrency reloadData];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:tOopsSomethingwentwrong delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil];
        [alert show];
        
    }
    
}


#pragma mark Table View Delegate & Datasource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableLanguage)
    {
        return [arrLanguage count];
    }
    else
    {
        return [arrCurrency count];
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, -5, tableView.frame.size.width, 40)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    NSString *string;
    if (tableView==_tableLanguage)
    {
        string =AMLocalizedString(@"tSelectLanguage", nil);
    }
    else
    {
        string =AMLocalizedString(@"tSelectCurrency", nil);
    }
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:string];
    [label setTextColor:model.priceColor];
    [label TransformAlignLabel];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableLanguage)
    {
        static NSString *CellIdentifier = @"LanguageCell";
        LanguageCell *cell = (LanguageCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *str=[NSString stringWithFormat:@"%@",[[arrLanguage objectAtIndex:indexPath.row]valueForKey:@"store_id"]];
        
        if ([selectedLangId isEqualToString:str])
        {
            [cell.imgSelected setImage:[UIImage imageNamed:@"btn_radio-selected.png"]];
        }
        else
        {
            [cell.imgSelected setImage:[UIImage imageNamed:@"btn_radio.png"]];
        }
        cell.lbllanguage.text=[[arrLanguage objectAtIndex:indexPath.row]valueForKey:@"name"];
        
        [cell.lbllanguage TransformAlignLabel];
        [cell.imgSelected TransformImage];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"LanguageCell";
        LanguageCell *cell = (LanguageCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *str=[NSString stringWithFormat:@"%@",[[arrCurrency objectAtIndex:indexPath.row]valueForKey:@"symbol"]];
        NSLog(@"%@",model.currencySymbo);
        
        if ([selectedCurrCode isEqualToString:str])
        {
            [cell.imgSelected setImage:[UIImage imageNamed:@"btn_radio-selected.png"]];
        }
        else
        {
            [cell.imgSelected setImage:[UIImage imageNamed:@"btn_radio.png"]];
        }
        cell.lbllanguage.text=[NSString stringWithFormat:@"%@(%@)",[[arrCurrency objectAtIndex:indexPath.row]valueForKey:@"label"],[[arrCurrency objectAtIndex:indexPath.row]valueForKey:@"symbol"]];
        
        [cell.lbllanguage TransformAlignLabel];
        [cell.imgSelected TransformImage];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableLanguage)
    {
        if ([[[arrLanguage objectAtIndex:indexPath.row]valueForKey:@"code"]isEqualToString:@"english1"])
        {
            strLang=@"en";
        }
        else if([[[arrLanguage objectAtIndex:indexPath.row]valueForKey:@"code"]isEqualToString:@"portugues"])
        {
            strLang=@"pt";
        }
        else if([[[arrLanguage objectAtIndex:indexPath.row]valueForKey:@"code"]isEqualToString:@"german"])
        {
            strLang=@"de";
        }
        
        selectedLangId=[[arrLanguage objectAtIndex:indexPath.row]valueForKey:@"store_id"];
        selectedLangCode=[[arrLanguage objectAtIndex:indexPath.row]valueForKey:@"code"];
        
        [_tableLanguage reloadData];
    }
    else
    {
        selectedCurrCode=[[arrCurrency objectAtIndex:indexPath.row]valueForKey:@"symbol"];
        selectedCurrID=[[arrCurrency objectAtIndex:indexPath.row]valueForKey:@"code"];
        [_tableCurrency reloadData];
    }
}

#pragma mark ---Apply Button Method---

- (IBAction)ApplyButton:(id)sender
{
    if (selectedLangCode!=nil && selectedLangId!=nil && strLang!=nil)
    {
        model.storeID=selectedLangCode;
        [[NSUserDefaults standardUserDefaults] setValue:model.storeID forKey:@"storeID"];
        [[NSUserDefaults standardUserDefaults]setValue:selectedLangId forKey:@"langId"];
        [[NSUserDefaults standardUserDefaults]setValue:strLang forKey:@"selectedLanguage"];
    }
    if (selectedCurrCode!=nil)
    {
        model.currencySymbo=selectedCurrCode;
        [[NSUserDefaults standardUserDefaults] setValue:model.currencySymbo forKey:@"currencySymbo"];
        model.currencyID=selectedCurrID;
        [[NSUserDefaults standardUserDefaults] setValue:model.currencyID forKey:@"currencyId"];
        
    }
    //launch app again
    delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    ViewController  * obj1 = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    delegate.nav = [[UINavigationController alloc]initWithRootViewController:obj1];
    delegate.window.rootViewController = delegate.nav;
    [delegate.nav.navigationBar setHidden:YES];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    delegate.window.backgroundColor = [UIColor whiteColor];
    [delegate.window makeKeyAndVisible];
    //[self.navigationController pushViewController:obj1 animated:YES];
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

#pragma mark ---Helper Methods---

-(void)alertViewM:(NSString*)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
    [alert show];
}


#pragma mark ---Back Button Method---


- (IBAction)back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
