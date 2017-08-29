//
//  OrderSummaryView.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/10/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "OrderSummaryView.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "UIImageView+WebCache.h"
#import "OrdersCell.h"
#import "Constants.h"
#import "ModelClass.h"
#import "Reachability.h"
#import "ViewController.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"



@interface OrderSummaryView ()
{
    NSDictionary *arrDescription;
    NSMutableArray *arrOrder;
    NSString *strAddress;
    ModelClass *model;
    __weak IBOutlet UILabel *orderSummaryLbl;
    __weak IBOutlet UILabel *deliveryaddressLbl;
    __weak IBOutlet UILabel *grandTotalLbl;
    __weak IBOutlet UILabel *statusLbl;
    __weak IBOutlet UILabel *orderIdLbl;
    __weak IBOutlet UILabel *totalItemsOrderedLbl;
}
@end

@implementation OrderSummaryView
@synthesize orderID,orderTable,borderCancelButton,scrollView,address,gTotal,status,orderid,borderAddress,borderGrandTotal,borderOrderId,borderStatus;

- (void)viewDidLoad
{
    //rtl views
    
    [self.view TransformViewCont];
    [_topView TransformationView];
    [orderSummaryLbl TransformLabel];
    [deliveryaddressLbl TransformAlignLabel];
    [grandTotalLbl TransformAlignLabel];
    [statusLbl TransformAlignLabel];
    [orderIdLbl TransformAlignLabel];
    [totalItemsOrderedLbl TransformAlignLabel];
    [orderid TransformAlignLabel];
    [address TransformAlignLabel];
    [status TransformAlignLabel];
    [gTotal TransformAlignLabel];
    [borderCancelButton TransformButton];
    
    [super viewDidLoad];
    
    model=[ModelClass sharedManager];
    
    
    //word change
    [orderSummaryLbl setText:AMLocalizedString(@"tOrderSummary", nil)];
    [borderCancelButton setTitle:AMLocalizedString(@"tCancelOrder", nil) forState:UIControlStateNormal];
    [deliveryaddressLbl setText:AMLocalizedString(@"tDeliveryAddress", nil)];
    [grandTotalLbl setText:AMLocalizedString(@"tGrandTotal", nil)];
    [statusLbl setText:AMLocalizedString(@"tStatus", nil)];
    [orderIdLbl setText:AMLocalizedString(@"tOrderID", nil)];
    [totalItemsOrderedLbl setText:AMLocalizedString(@"tTotalItemsOrdered", nil)];
    
    
    //scrollview
    [scrollView setFrame:CGRectMake(0, 90+7, 320,self.view.frame.size.height-95-7)];
    
    [self.view addSubview:scrollView];
    
    
    arrOrder=[NSMutableArray new];
    strAddress=[NSString new];
    
    //    borderCancelButton.layer.masksToBounds = YES;
    //    borderCancelButton.layer.cornerRadius = 4.0;
    //    borderCancelButton.layer.borderWidth = 1.0;
    //    borderCancelButton.layer.borderColor = [[UIColor clearColor] CGColor];
    
    // Do any additional setup after loading the view from its nib.
    
    //API call
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
            [self getOrderList];
        });
    });
    
    //    Shipping will not be done for this product.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // color change
    [_topView setBackgroundColor:model.themeColor];
    [borderCancelButton setBackgroundColor:model.buttonColor];
    [orderSummaryLbl setTextColor:[UIColor whiteColor]];
    [totalItemsOrderedLbl setTextColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"OrderSummaryView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Get user address

-(void)getOrderList
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
        NSString *str=[NSString stringWithFormat:@"%@orderInfo?salt=%@&order_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,orderID,model.storeID,model.currencyID];
        
        //---------------- API----------------------
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_API_Response:)];
    }
}

-(void)Get_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[[responseDict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
    {
        [self alertViewMethod:AMLocalizedString(@"tOopsSomethingwentwrong", nil)];
        
    }
    
    else  if ([[responseDict valueForKey:@"response"]count]!=0)
    {
        arrDescription=[responseDict valueForKey:@"response"];
        if ([[arrDescription valueForKey:@"shipping_description"]isEqual:[NSNull null]])
        {
            address.text=AMLocalizedString(@"tShippingwillnotbedoneforthisproduct", nil);
            [self LabelBreak2:address];
        }
        else
        {
            NSDictionary *dict=[arrDescription valueForKey:@"shipping_address"];
            
            strAddress=[NSString stringWithFormat:@"%@ %@\n%@,%@,%@\n%@",[dict valueForKey:@"firstname"],[dict valueForKey:@"lastname"],[dict valueForKey:@"street"],[dict valueForKey:@"city"],[dict valueForKey:@"state"],[dict valueForKey:@"telephone"]];
            if (strAddress==nil)
            {
                NSLog(@"%@",strAddress);
            }
            address.text=strAddress;
            [self LabelBreak2:address];
            
            NSLog(@"%@ %f",strAddress,address.frame.size.height);
        }
        [self setBorder:borderStatus];
        [self setBorder:borderOrderId];
        [self setBorder:borderAddress];
        [self setBorder:borderGrandTotal];
        
        // set frames
        
        borderAddress.frame=CGRectMake(20, 8, 280, address.frame.size.height+8);
        borderGrandTotal.frame=CGRectMake(20, borderAddress.frame.size.height+borderAddress.frame.origin.y+8,280 , 35);
        borderStatus.frame=CGRectMake(20, borderGrandTotal.frame.size.height+borderGrandTotal.frame.origin.y+8, 280, 35);
        borderOrderId.frame=CGRectMake(20, borderStatus.frame.size.height+borderStatus.frame.origin.y+8, 280, 35);
        self.totalView.frame=CGRectMake(self.totalView.frame.origin.x, borderOrderId.frame.size.height+borderOrderId.frame.origin.y+8, self.totalView.frame.size.width,self.totalView.frame.size.height);
        
        // set labels
        
        gTotal.text=[arrDescription valueForKey:@"grand_total"];
        status.text=[arrDescription valueForKey:@"status"];
        NSString *strcheck=[arrDescription valueForKey:@"status"];
        if ([strcheck isEqualToString:@"canceled"] || [strcheck isEqualToString:@"complete"] || [strcheck isEqualToString:@"On Hold"] || [strcheck isEqualToString:@"processing"])
        {
            borderCancelButton.hidden=YES;
        }
        else
        {
            borderCancelButton.hidden=NO;
            
        }
        orderid.text=[arrDescription valueForKey:@"order_id"];
        
        arrOrder=[[responseDict valueForKey:@"response"]valueForKey:@"items"];
        self.orderTable.frame=CGRectMake(self.orderTable.frame.origin.x, self.totalView.frame.size.height+self.totalView.frame.origin.y+15, self.orderTable.frame.size.width,arrOrder.count*138);
        
        scrollView.contentSize=CGSizeMake(320,280+arrOrder.count*138+borderGrandTotal.frame.origin.y-95);
        [orderTable reloadData];
    }
}

#pragma mark ---Helper Methods---

-(void)LabelBreak2:(UILabel*)label
{
    NSLog(@"%lu",(unsigned long)label.text.length);
    label.numberOfLines = label.text.length/10;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [label.text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:12.0f]}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(label.numberOfLines*12));
    CGRect newFrame = label.frame;
    newFrame.size.height = adjustedSize.height;
    label.frame = newFrame;
}



-(void)alertViewMethod:(NSString*)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark Set Borders

-(void)setBorder:(UIView*)str
{
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius = 4.0;
    //    str.layer.borderWidth = 2.0;
    //    str.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:193.0/255.0] CGColor];
}

#pragma mark - TableView Delegate And DataSources


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrOrder.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrdersCell";
    OrdersCell *cell = (OrdersCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    //rtl
    [cell.orderID TransformAlignLabel];
    [cell.createdID TransformAlignLabel];
    [cell.name TransformAlignLabel];
    [cell.quantity TransformAlignLabel];
    [cell.price TransformAlignLeftLabel];
    [cell.productImage TransformImage];
    [cell.status TransformAlignLabel];
    
    cell.createdID.text=[arrDescription valueForKey:@"created"];
    cell.orderID.text=[arrDescription valueForKey:@"order_id"];
    [cell.orderID setTextColor:model.priceColor];
    
    cell.name.text=[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"name"];
    cell.quantity.text=[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"qty"];
    cell.status.text=[arrDescription valueForKey:@"status"];
    cell.price.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
    [cell.productImage sd_setImageWithURL:[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"img_url"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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

#pragma mark Back Button

- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Cancel order Method

- (IBAction)cancelOrder:(id)sender
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        [self alertViewMethod:AMLocalizedString(@"tShippingwillnotbedoneforthisproduct", nil)];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        NSString *str=[NSString stringWithFormat:@"%@cancleOrder?salt=%@&order_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,orderID,model.storeID,model.currencyID];
        
        //---------------- API----------------------
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cancelOrder_Response:)];
    }
}

-(void)Get_cancelOrder_Response:(NSDictionary*)responseDict {
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"success"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"cancelOrder"];
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        [self alertViewMethod:AMLocalizedString(@"tOopsSomethingwentwrong", nil)];
        
    }
    else
    {
        //[self alertViewMethod:[responseDict valueForKey:@"response"]];
        [self alertViewMethod:@"Unable to delete order. Please try again later."];
        
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
