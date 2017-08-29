//
//  MyOrdersViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/9/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "MyOrderCell.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "ModelClass.h"
#import "UIImageView+WebCache.h"
#import "OrderSummaryView.h"
#import "ViewController.h"
#import "Constants.h"
#import "Reachability.h"
#import "ProductDetailsViewController.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"

@interface MyOrdersViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrOrder;
    NSMutableArray *arrProducts;
    ModelClass *model;
    BOOL viewMore;
    int v;
    
}
@end

@implementation MyOrdersViewController

- (void)viewDidLoad
{
    //rtl views
    
    [self.view TransformViewCont];
    [_topView TransformationView];
    
    
    [super viewDidLoad];
    arrOrder=[[NSMutableArray alloc]init];
    arrProducts=[[NSMutableArray alloc]init];
    model=[ModelClass sharedManager];
    v=0;
    
    // -------------------------- Reachability --------------------//
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //color change
    
    [_topView setBackgroundColor:model.themeColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"MyOrdersViewController"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"cancelOrder"]==YES)
    {
        [self getOrderList];
        [self.orderTable reloadData];
    }
    
    //API call
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
            [self getOrderList];
        });
    });
}


- (void)didReceiveMemoryWarning {
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
        
        if (viewMore==YES||v==0)
        {
            [self addLoadingView];
            v++;
            NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
            if ([str5 isEqualToString:@"(null)"])
            {
                str5=@"";
            }
            NSString *str=[NSString stringWithFormat:@"%@orderList?salt=%@&uid=%@&page_no=%i&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,v,model.storeID,model.currencyID];
            
            //---------------- API----------------------
            
            ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_API_Response:)];
        }
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
    
    else if ([[[responseDict valueForKey:@"response"]valueForKey:@"order"]count]!=0)
    {
        if ([[[responseDict valueForKey:@"response"]valueForKey:@"more"]intValue ]==1)
        {
            viewMore=YES;
            [arrOrder addObjectsFromArray:[[responseDict objectForKey:@"response"]valueForKey:@"order"]];
            [self.orderTable reloadData];
        }
        else
        {
            viewMore=NO;
            
            [arrOrder addObjectsFromArray:[[responseDict objectForKey:@"response"]valueForKey:@"order"]];
            [self.orderTable reloadData];
        }
    }
    else
    {
        [self alertViewMethod:AMLocalizedString(@"tNoordersfound", nil)];
        
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

#pragma mark - TableView Delegate And DataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrOrder.count!=0 && viewMore==YES)
    {
        return arrOrder.count+1;
    }
    else
    {
        return arrOrder.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrOrder.count!=0 && indexPath.row<arrOrder.count)
    {
        arrProducts=[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"products"];
        return 53+arrProducts.count*70+20;
    }
    else if(indexPath.row==arrOrder.count)
    {
        return 50;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyOrderCell";
    MyOrderCell *cell = (MyOrderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        if (arrOrder.count!=0 && indexPath.row<arrOrder.count)
        {
            
            arrProducts=[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"products"];
            
            if (arrProducts.count!=0)
            {
                int y=56;
                
                cell.contentView.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
                
                for (int i=0; i<arrProducts.count; i++)
                {
                    [self removeLoadingView];
                    UIView *productview=[[UIView alloc]initWithFrame:CGRectMake(5, y, 290, 60)];
                    //            productview.layer.masksToBounds = YES;
                    //            productview.layer.cornerRadius = 4.0;
                    //            productview.layer.borderWidth = 1.0;
                    //            productview.layer.borderColor = [[UIColor clearColor] CGColor];
                    productview.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
                    [cell addSubview:productview];
                    
                    UIImageView *imageProduct=[[UIImageView alloc]initWithFrame:CGRectMake(14, 4, 52, 52)];
                    [imageProduct sd_setImageWithURL:[[arrProducts objectAtIndex:i]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]] ;
                    [imageProduct setContentMode:UIViewContentModeScaleAspectFit];
                    imageProduct.layer.cornerRadius=imageProduct.frame.size.width/2;
                    imageProduct.layer.borderColor=[[UIColor clearColor]CGColor];
                    [imageProduct TransformImage];
                    [productview addSubview:imageProduct];
                    
                    UILabel *nameProduct=[[UILabel alloc]initWithFrame:CGRectMake(81, 6, 149, 21)];
                    nameProduct.text=[NSString stringWithFormat:@"%@",[[arrProducts objectAtIndex:i]valueForKey:@"name"]];
                    [nameProduct setFont:[UIFont systemFontOfSize:12.0]];
                    [nameProduct setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
                    [nameProduct TransformAlignLabel];
                    [productview addSubview:nameProduct];
                    
                    UILabel *statusProduct=[[UILabel alloc]initWithFrame:CGRectMake(81, 34, 149, 21)];
                    statusProduct.text=[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"status"];
                    [statusProduct setFont:[UIFont systemFontOfSize:12.0]];
                    [statusProduct setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
                    [statusProduct TransformAlignLabel];
                    [productview addSubview:statusProduct];
                    
                    UILabel *priceProduct=[[UILabel alloc]initWithFrame:CGRectMake(238, 18, 52, 21)];
                    priceProduct.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProducts objectAtIndex:i]valueForKey:@"price"]];
                    [priceProduct setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
                    [priceProduct setFont:[UIFont systemFontOfSize:12.0]];
                    [priceProduct TransformAlignLeftLabel];
                    [productview addSubview:priceProduct];
                    
                    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(5, y, 290, 60)];
                    [btn addTarget:self action:@selector(btnProductDetail:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTag:i];
                    [btn setAccessibilityLabel:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                    
                    [cell addSubview:btn];
                    
                    y=y+70;
                }
                UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0,y, 300, 20)];
                separator.backgroundColor=[UIColor whiteColor];
                [cell addSubview:separator];
            }
        }
    }
    if (arrOrder.count!=0 && indexPath.row<arrOrder.count)
    {
        //        cell.buttonViewOrder.layer.masksToBounds = YES;
        //        cell.buttonViewOrder.layer.cornerRadius = 4.0;
        //        cell.buttonViewOrder.layer.borderWidth = 1.0;
        //        cell.buttonViewOrder.layer.borderColor = [[UIColor clearColor] CGColor];
        [cell.buttonViewOrder setBackgroundColor:model.buttonColor];
        [cell.buttonViewOrder setTitle:AMLocalizedString(@"tViewOrder", nil) forState:UIControlStateNormal];
        [cell.buttonViewOrder addTarget:self action:@selector(ViewOrder:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonViewOrder.tag=indexPath.row;
        
        //rtl
        [cell.buttonViewOrder TransformButton];
        [cell.order_id TransformAlignLabel];
        [cell.created_at TransformAlignLabel];
        
        cell.order_id.textColor=model.priceColor;
        cell.order_id.text=[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"order_id"];
        cell.created_at.text=[[arrOrder objectAtIndex:indexPath.row]valueForKey:@"created_at"];
    }
    if (indexPath.row==arrOrder.count && viewMore==YES)
    {
        UIButton *buttonView=[[UIButton alloc]initWithFrame:CGRectMake(0, 8, 300, 35)];
        [buttonView setBackgroundColor:[UIColor lightGrayColor]];
        [buttonView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonView setTitle:AMLocalizedString(@"tViewMore", nil) forState:UIControlStateNormal];
        [buttonView addTarget:self action:@selector(ViewMore:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:buttonView];
        cell.order_id.hidden=YES;
        cell.created_at.hidden=YES;
        cell.buttonViewOrder.hidden=YES;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.orderTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    return cell;
}

#pragma mark ---Navigate to product detail---

-(void)btnProductDetail:(UIButton *)sender
{
    NSArray *arr=[[arrOrder objectAtIndex:[sender.accessibilityLabel intValue]]valueForKey:@"products"];
    NSString * str1 = [[arr objectAtIndex:[sender tag]]valueForKey:@"id"];
    ProductDetailsViewController *detail=[[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
    detail.strProdId=str1;
    
    [self.navigationController pushViewController:detail animated:YES];
    detail=nil;
    
}



#pragma mark View order method

- (void)ViewOrder:(UIButton*)sender
{
    OrderSummaryView *obj=[[OrderSummaryView alloc]initWithNibName:@"OrderSummaryView" bundle:nil];
    obj.orderID=[[arrOrder objectAtIndex:[sender tag]]valueForKey:@"order_id"];
    [self.navigationController pushViewController:obj animated:YES];
    
}

#pragma mark View More method

- (void)ViewMore:(id)sender
{
    if(viewMore==YES)
    {
        [self getOrderList];
    }
}

#pragma mark Back button method

- (IBAction)Back:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"cancelOrder"]==YES)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[ViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"cancelOrder"];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark ---Helper Methods---

-(void)alertViewMethod:(NSString*)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
    [alert show];
    
}

@end
