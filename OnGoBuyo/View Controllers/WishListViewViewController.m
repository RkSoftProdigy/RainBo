//
//  WishListViewViewController.m
//  OnGoBuyo
//
//  Created by Jatiender on 4/7/16.
//  Copyright © 2016 navjot_sharma. All ridghts reserved.
//

#import "WishListViewViewController.h"
#import "wishlistCellTableViewCell.h"
#import "ApiClasses.h"
#import "ModelClass.h"
#import "MBProgressHUD.h"
#import "ProductDetailsViewController.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"

@interface WishListViewViewController ()
{
    ModelClass *model;
}

@end

@implementation WishListViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [_wishListLbl TransformLabel];
    [_noItemLbl TransformLabel];
    
    
    
    
    //change words
    [_wishListLbl setText:AMLocalizedString(@"tWishlist", nil) ];
    [_noItemLbl setText:AMLocalizedString(@"tNoItemtoView", nil)];
    
    
    
    model=[ModelClass sharedManager];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //change color
    
    [_topView setBackgroundColor:model.themeColor];
    [_wishListLbl setTextColor:[UIColor whiteColor]];
    [_noItemLbl setTextColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"WishlistView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
   
    
    
    //API call
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        //[self addLoadingView];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self getWishlistitems];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getWishlistitems
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil, nil];
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
        
        NSString *str=[NSString stringWithFormat:@"%@getWishlistItems?salt=%@&cust_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,model.storeID,model.currencyID];
        
        //---------------- API----------------------
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(getWishList_Response:)];
    }
}

-(void)getWishList_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    
    NSDictionary *response = [responseDict valueForKey:@"response"];
    NSDictionary *returnCode = [responseDict valueForKey:@"returnCode"];
    
    NSString *resultText = [returnCode valueForKey:@"resultText"];
    
    if ([resultText isEqualToString:@"fail"])
    {
        [_wishListNoItemFound setHidden:NO];
    }
    else if ([resultText isEqualToString:@"success"])
    {
        
        wishlist_items = [response valueForKey:@"wishlist_items"];
        if (wishlist_items.count == 0)
        {
            [_wishListNoItemFound setHidden:NO];
            [_wishlist_tblvew setHidden:YES];
            
        }
        else
        {
            [_wishlist_tblvew setHidden:NO];
            
            [_wishlist_tblvew reloadData];
        }
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark - TableView Delegate And DataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (wishlist_items.count!=0)
    {
        return wishlist_items.count;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"wishlistCellTableViewCell";
    wishlistCellTableViewCell  *cell = (wishlistCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    NSString *added_at = [wishlist_items objectAtIndex:indexPath.row][@"added_at"];
    NSString *product_name = [wishlist_items objectAtIndex:indexPath.row][@"product_name"];
    NSString *price = [wishlist_items objectAtIndex:indexPath.row][@"price"];
    NSURL *product_image = [wishlist_items objectAtIndex:indexPath.row][@"product_image"];
    quantity = [wishlist_items objectAtIndex:indexPath.row][@"qty"];
    NSString *name = [wishlist_items objectAtIndex:indexPath.row][@"name"];
    wishlist_item_id = [wishlist_items objectAtIndex:indexPath.row][@"wishlist_item_id"];
    productId = [wishlist_items objectAtIndex:indexPath.row][@"product_id"];
    productType = [wishlist_items objectAtIndex:indexPath.row][@"product_type"];
    
    //rtl
    
    [cell.created_at_lbl TransformAlignLabel];
    [cell.product_name_lbl TransformAlignLabel];
    [cell.product_image TransformImage];
    [cell.quantity_lbl TransformAlignLabel];
    [cell.name_lbl TransformAlignLabel];
    [cell.price_lbl TransformAlignLeftLabel];
    [cell.remove_Btn TransformButton];
    [cell.addToCart TransformButton];
    
    
    cell.created_at_lbl.text = added_at;
    cell.product_name_lbl.textColor=model.priceColor;
    
    cell.product_name_lbl.text = product_name;
    cell.price_lbl.text = price;
    cell.quantity_lbl.text = quantity;
    cell.name_lbl.text = name;
    
    [cell.product_image sd_setImageWithURL:product_image placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    
    [cell.addToCart addTarget:self action:@selector(addtocart_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.remove_Btn addTarget:self action:@selector(remove_btnaction:) forControlEvents:UIControlEventTouchUpInside];
    cell.addToCart.tag =[productId intValue];
    cell.addToCart.accessibilityLabel=[NSString stringWithFormat:@"%@,%@", wishlist_item_id,productType];
    cell.remove_Btn.tag = [productId intValue];
    cell.remove_Btn.accessibilityLabel=wishlist_item_id;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str1 = [[wishlist_items objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    ProductDetailsViewController *detail=[[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
    detail.strProdId=str1;
    
    [self.navigationController pushViewController:detail animated:YES];
    detail=nil;
    
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


-(void)addtocart_clicked:(UIButton*)sender
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(tNoInternet);
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        
        
        NSArray *arr=[[sender accessibilityLabel] componentsSeparatedByString:@","];
        productId=[NSString stringWithFormat:@"%ld",(long)[sender tag]];
        wishlist_item_id=[arr objectAtIndex:0];
        productType=[arr objectAtIndex:1];
        if ([productType isEqualToString:@"simple"])
        {
            [self addLoadingView];
            NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
            if ([str5 isEqualToString:@"(null)"])
            {
                str5=@"";
            }
            
            NSString *str=[NSString stringWithFormat:@"%@addWItemToCart?salt=%@&cust_id=%@&item_id=%@&qty=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,[sender accessibilityLabel],quantity,model.storeID,model.currencyID];
            
            //---------------- API----------------------
            
            ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(addToCartResponse:)];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasespecifytheproductoption", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)remove_btnaction:(UIButton*)sender {
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        
        
        [self addLoadingView];
        NSArray *arr=[[sender accessibilityLabel] componentsSeparatedByString:@","];
        wishlist_item_id=[arr objectAtIndex:0];
        
        NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
        if ([str5 isEqualToString:@"(null)"])
        {
            str5=@"";
        }
        
        NSString *str=[NSString stringWithFormat:@"%@removeWishListItem?salt=%@&cust_id=%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,wishlist_item_id,model.storeID,model.currencyID];
        
        //---------------- API----------------------
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(getRemoveItemFromWishListResponse:)];
    }
}


-(void)addToCartResponse:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    NSDictionary *responsedict = [responseDict valueForKey:@"response"];
    NSDictionary *returnCode = [responseDict valueForKey:@"returnCode"];
    
    NSString *resultText = [returnCode valueForKey:@"resultText"];
    
    if ([resultText isEqualToString:@"fail"])
    {
        if ([[responsedict valueForKey:@"canAddToCart"]intValue]==0)
        {
            if ([[responsedict valueForKey:@"hasRequiredOpt"]intValue]==0 )
            {
                //NSString *msg = [responsedict valueForKey:@"msg"];
                NSString *msg = @"Item has been added to your wishlist";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSString *msg = [responsedict valueForKey:@"msg"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            NSString *msg = [responsedict valueForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles: nil];
            [alert show];
        }
        
        [self removeLoadingView];
    }
    else if ([resultText isEqualToString:@"success"])
    {
        NSString *msg = [responsedict valueForKey:@"msg"];
        [self getWishlistitems];
        [_wishlist_tblvew reloadData];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil, nil];
        [alert show];
        if([[[responseDict valueForKey:@"response"]valueForKey:@"quote_id"]length]!=0)
        {
            
            [[NSUserDefaults standardUserDefaults]setValue:[[responseDict valueForKey:@"response"]valueForKey:@"quote_id"] forKey:@"quote_id"];
        }
        
        if([[responseDict valueForKey:@"response"]valueForKey:@"quote_count"]!=0)
        {
            
            [[NSUserDefaults standardUserDefaults]setValue:[[responseDict valueForKey:@"response"]valueForKey:@"quote_count"] forKey:@"quote_count"];
        }
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

-(void)getRemoveItemFromWishListResponse:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSString *response = [responseDict valueForKey:@"response"];
    NSDictionary *returnCode = [responseDict valueForKey:@"returnCode"];
    NSString *resultText = [returnCode valueForKey:@"resultText"];
    
    if ([resultText isEqualToString:@"fail"])
    {
        NSString *msg = [returnCode valueForKey:@"msg"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil];
        [alert show];
    }
    else if ([resultText isEqualToString:@"success"])
    {
        [self getWishlistitems];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:response delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark alertView delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        ProductDetailsViewController *objViewcontroller=[[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil];
        
        objViewcontroller.wishlistItem = @"yes";
        objViewcontroller.wishListProductId=wishlist_item_id;
        objViewcontroller.strProdId = productId;
        [self.navigationController pushViewController:objViewcontroller animated:YES];
    }
}

#pragma mark Back Button method

- (IBAction)backBtn_Action:(id)sender
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
