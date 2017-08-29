//
//  NotificationCenter.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/29/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "NotificationCenter.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ModelClass.h"
#import "ApiClasses.h"
#import "NotificationCell.h"
#import "CustomView.h"
#import "ViewMoreViewController.h"
#import "ProductDetailsViewController.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"


@interface NotificationCenter ()<UITableViewDelegate,UITableViewDataSource>
{
    ModelClass *model;
    NSMutableArray *arrNotifications;
    
    //__weak IBOutlet UILabel *recentNotiFiLbl;
}
@end

@implementation NotificationCenter
@synthesize tableNotification,labelNoItem,topView;

- (void)viewDidLoad
{
    //rtl views
    
    [self.view TransformViewCont];
    [topView TransformationView];
    //[recentNotiFiLbl TransformLabel];
    [labelNoItem TransformLabel];
    
    
    [super viewDidLoad];
    
    
    //word change
   // [recentNotiFiLbl setText:AMLocalizedString(@"tRecentNotifications", nil) ];
    [labelNoItem setText:AMLocalizedString(@"tNoNotificationtoshow", nil) ];
    
    
    model=[ModelClass sharedManager];
    arrNotifications=[NSMutableArray new];
    
    [self clearBadge];
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self getNotifications];
        });
    });
    
    // Do any additional setup after loading the view from its nib.
}
-(void)clearBadge
{
    NSString *str=[NSString stringWithFormat:@"%@resetBadgeCount?salt=%@&deviceId=%@&badge=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,[[NSUserDefaults standardUserDefaults]valueForKey:@"devicet"],@"0",model.storeID,model.currencyID];
    
    //---------------- API----------------------
    ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_resetBadgeCount_API_Response:)];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark Api Response

-(void)Get_resetBadgeCount_API_Response:(NSDictionary*)responseDict
{
    NSLog(@"%@",responseDict);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //change color
    
    [topView setBackgroundColor:model.themeColor];
    //[recentNotiFiLbl setTextColor:[UIColor whiteColor]];
    [labelNoItem setTextColor:[UIColor whiteColor]];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"NotificationCenter"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Search Category Api

-(void)getNotifications
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil)  delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        
        [self addLoadingView];
        
        //   ------API Call------
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        NSString *str=[NSString stringWithFormat:@"%@getCustomerNotifications?salt=%@&email=%@",baseURL1,model.salt,[[NSUserDefaults standardUserDefaults]valueForKey:@"email"],model.storeID,model.currencyID];
        [obj_apiClass SearchCategory:str withTarget:self withSelector:@selector(Get_Notifications_Response:)];
    }
}

#pragma mark Api Response

-(void)Get_Notifications_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[[responseDict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    
    else if ([[[responseDict valueForKey:@"response"]valueForKey:@"items"]count]!=0)
    {
        tableNotification.hidden=NO;
        labelNoItem.hidden=YES;
        arrNotifications=[[responseDict valueForKey:@"response"] valueForKey:@"items"];
        [tableNotification reloadData];
    }
    else
    {
        tableNotification.hidden=YES;
        labelNoItem.hidden=NO;
    }
}

#pragma mark - TableView Delegate And DataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrNotifications.count!=0 && arrNotifications.count>=10)
    {
        return 10;
    }
    else if(arrNotifications.count!=0 && arrNotifications.count<10)
    {
        return arrNotifications.count;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *labelText = [[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"msg"];
    float height =[self heightForText:labelText];
    return height+60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    NotificationCell *cell = (NotificationCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    [cell.createdAt TransformAlignLabel];
    [cell.msgLabel TransformAlignLabel];
    
    
    if (arrNotifications.count!=0)
    {
        cell.createdAt.text=[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"created_at"];
        cell.msgLabel.text=[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"msg"];
    }
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView.frame=CGRectZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_type"]isEqual:[NSNull null]])
    {
        if([[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_type"]isEqualToString:@"page"])
        {
            CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
            [self.navigationController pushViewController:objViewController animated:YES];
            objViewController.urlToDisplay=[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_value"];
            objViewController.strPrev=@"page";
            objViewController = nil;
        }
        else if([[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_type"]isEqualToString:@"custom"])
        {
            CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
            [self.navigationController pushViewController:objViewController animated:YES];
            objViewController.urlToDisplay=[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_value"];
            objViewController.strPrev=@"custom";
            objViewController = nil;
        }
        else if([[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_type"]isEqualToString:@"category"])
        {
            ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
            objViewController.strName=@"Products";
            objViewController.categoryID=[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_value"];
            objViewController.apiType = @"SearchApi";
            [self.navigationController pushViewController:objViewController animated:YES];
            objViewController = nil;
        }
        else if([[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_type"]isEqualToString:@"product"])
        {
            ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
            NSString *str=[NSString stringWithFormat:@"%@",[[arrNotifications objectAtIndex:indexPath.row]valueForKey:@"item_value"]];
            
            NSRange range = [str rangeOfString:@"#"];
            NSString *newString = [str substringToIndex:range.location];
            NSLog(@"%@",newString);
            
            objViewController.strProdId=newString;
            [self.navigationController pushViewController:objViewController animated:YES];
            
            objViewController = nil;
        }
    }
}

#pragma mark ---Helper Methods---

- (CGFloat)heightForText:(NSString *)bodyText
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSParagraphStyleAttributeName: style};
    CGRect rect = [bodyText boundingRectWithSize:CGSizeMake(244, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    return rect.size.height;
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

#pragma mark ---Back Button method---

- (IBAction)Back:(id)sender
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
