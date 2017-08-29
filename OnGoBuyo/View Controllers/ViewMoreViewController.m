//
//  ViewMoreViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/9/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "ViewMoreViewController.h"
#import "ProductCollectionCellCollectionViewCell.h"
#import "ApiClasses.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ProductDetailsViewController.h"
#import "AddToCartView.h"
#import "AppDelegate.h"
#import "AppInfoView.h"
#import "UserProfileView.h"
#import "MyOrdersViewController.h"
#import "ViewController.h"
#import "ModelClass.h"
#import "Reachability.h"
#import "NotificationCenter.h"
#import "LoginViewController.h"
#import "DownloadableView.h"
#import "WishListViewViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "LanguageSettingView.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"

@interface ViewMoreViewController ()
{
    UIView *coverView;
    NSMutableArray *arrMoreProducts;
    //    NSString *currencyIcon;
    NSString *varMore;
    int i;
    int count;
    BOOL clicked;
    NSString *sortBy;
    ModelClass *model;
    
    // words change
    
    __weak IBOutlet UILabel *sortPopUp;
    __weak IBOutlet UILabel *aTozLbl;
    __weak IBOutlet UILabel *zToaLbl;
    __weak IBOutlet UILabel *btnLtoH;
    __weak IBOutlet UILabel *btnHtoL;
    
}
@end

@implementation ViewMoreViewController
@synthesize strPrevious,pageLabel,collectionView1,sortingView,tableView1,delegate,sortLbl;

static NSString * const kCellReuseIdentifier = @"customCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [pageLabel TransformAlignLabel];
    
    //words change
    
    [sortLbl setTitle:AMLocalizedString(@"tSortBy",nil) forState:UIControlStateNormal];
    [sortPopUp setText:AMLocalizedString(@"tSORTBY",nil)];
    [aTozLbl setText:AMLocalizedString(@"tAtoZ",nil)];
    [zToaLbl setText:AMLocalizedString(@"tZtoA",nil) ];
    [btnLtoH setText:AMLocalizedString(@"tPriceLowtoHigh",nil)];
    [btnHtoL setText:AMLocalizedString(@"tPriceHightoLow",nil)];
    
    
    delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    model=[ModelClass sharedManager];
    //initialise
    arrMoreProducts=[[NSMutableArray alloc]init];
    //    currencyIcon=[[NSString alloc]init];
    varMore=[[NSString alloc]init];
    i=0;
    count=0;
    sortBy=@"";
    
    pageLabel.text=_strName;
    
    //API Call
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self getProductData];
        });
    });
    
    //collection view
    
    [collectionView1 registerNib:[UINib nibWithNibName:@"ProductCollectionCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    collectionView1.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(145, 170)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [collectionView1 setCollectionViewLayout:flowLayout];
    [collectionView1 setAllowsSelection:YES];
    
    //Sorting View
    
    sortingView.hidden=YES;
    sortingView.frame=CGRectMake(30, 200, 250, 200);
    [self.view addSubview:sortingView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //color change
    [sortLbl setTitleColor:model.buttonColor forState:UIControlStateNormal];
    [_topView setBackgroundColor:model.themeColor];
    [pageLabel setTextColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ViewMoreView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
    
    
    [self.tableView1 setHidden:YES];
    
    self.lblCount.layer.cornerRadius=self.lblCount.frame.size.width/2;
    self.lblCount.clipsToBounds=YES;
    
    NSString * str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"quote_count"]];
    
    if(![str isEqualToString:@"(null)"])
    {
        if(![str isEqualToString:@"0"])
        {
            [self.lblCount setHidden:NO];
            self.lblCount.text = str;
        }
        else
        {
            [self.lblCount setHidden:YES];
            
        }
    }
    else
    {
        [self.lblCount setHidden:YES];
    }
    
    NSString *str1=[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"];
   // NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    NSArray *arrAdd;
    if(([pT intValue]==101) || ([pT intValue]==1011) )
    {
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil), AMLocalizedString(@"tAppInfo",nil),AMLocalizedString(@"tLanguage",nil),AMLocalizedString(@"tLogout", nil), nil];
    }
    else
    {
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil),AMLocalizedString(@"tMyWishList", nil),AMLocalizedString(@"tMyDownloadables", nil),AMLocalizedString(@"tAppInfo", nil),AMLocalizedString(@"tNotifications", nil),AMLocalizedString(@"tLanguage",nil),AMLocalizedString(@"tLogout", nil) , nil];
    }
    NSArray *arrAdd2=[NSArray arrayWithObjects:AMLocalizedString(@"tLogin",nil),AMLocalizedString(@"tAppInfo",nil),AMLocalizedString(@"tLanguage",nil), nil];
    
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Api Calls

-(void)getProductData
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        
        NSString *strType=[[NSString alloc ]init];
        
        if ([self.categoryID isEqualToString:@""] || self.categoryID==nil)
        {
            strType=strPrevious;
        }
        else
            
        {
            strType = self.categoryID;
        }
        //   ------API Call------
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        i++;
        
        if ([varMore isEqualToString:@"1"]||i==1)
        {
            if ([self.apiType isEqualToString:@"SearchApi"])
            {
                NSString *str=[NSString stringWithFormat:@"%@productlist?salt=%@&cat_id=%@&page_id=%i&sort=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strType,i,sortBy,model.storeID,model.currencyID];
                varMore=@"0";
                [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_API_Response:)];
            }
            else
            {
                NSString *str=[NSString stringWithFormat:@"%@getmore?salt=%@&type=%@&page_no=%i&sort=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strType,i,sortBy,model.storeID,model.currencyID];
                varMore=@"0";
                [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_API_Response:)];
            }
        }
        else
        {
            [self removeLoadingView];
        }
    }
}

#pragma mark Api Response

-(void)Get_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    
    NSLog(@"%@",responseDict);
    if([[responseDict valueForKey:@"response"]isKindOfClass:[NSDictionary class]])
    {
        if ([[[responseDict valueForKey:@"response"]valueForKey:@"product"]count]!=0)
        {
            NSArray *arr=[[NSArray alloc]init];
            arr=[[responseDict valueForKey:@"response"]valueForKey:@"product"];
            if (i==1 && arrMoreProducts.count!=0)
            {
                [arrMoreProducts removeAllObjects];
            }
            [arrMoreProducts addObjectsFromArray:arr];
            
            
            //        currencyIcon=[[responseDict valueForKey:@"response"]valueForKey:@"currency_symbol"];
            varMore=[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"response"]valueForKey:@"more"]];
            if ([varMore isEqualToString:@"0"])
            {
                count=1;
            }
            [collectionView1 reloadData];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoitemsfound",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoitemsfound",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Collection View Datasource Methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [arrMoreProducts count];
    
}

- (ProductCollectionCellCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCollectionCellCollectionViewCell *cell = (ProductCollectionCellCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
            cell.borderImage.layer.cornerRadius=4;
            cell.borderImage.layer.borderWidth=1;
            cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [cell.inStock TransformAlignLeftLabel];
    [cell.productImage TransformImage];
    [cell.productPrice TransformAlignLeftLabel];
    [cell.productName TransformAlignLabel];
    [cell.productOff TransformAlignLabel];
    [cell.orderImage TransformButton];
    
    if ([[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"in_stock"]intValue]==1)
    {
        cell.inStock.textColor=[UIColor colorWithRed:133.0/255.0 green:183.0/255.0 blue:78.0/255.0 alpha:1.0];
        cell.inStock.text=AMLocalizedString(@"tInStock",nil);
        
    }
    else
    {
        cell.inStock.textColor=[UIColor redColor];
        cell.inStock.text=AMLocalizedString(@"tOutofStock",nil);
        
    }
    cell.imageLine.backgroundColor=model.buttonColor;
    
    [cell.productImage sd_setImageWithURL:[NSURL URLWithString:[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    
    if (![[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
    {
        cell.orderImage.hidden=NO;
        [cell.orderImage setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        
    }
    else
    {
        cell.orderImage.hidden=YES;
    }
    
    cell.productName.text=[NSString stringWithFormat:@"%@",[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""] ];
    
    if ([[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"type_id"] isEqualToString:@"grouped"]||[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"type_id"] isEqualToString:@"bundle"])
    {
        cell.productOff.hidden=YES;
        [cell.productPrice setTextColor:model.priceColor];
        cell.productPrice.text=[NSString stringWithFormat:@"%@",[self stringByStrippingHTML:[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"price_html"]stringByReplacingOccurrencesOfString:@"\n" withString:@""]]];
    }
    else
    {
        if ([[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
            
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            
            cell.productOff.hidden=NO;
        }
        else
        {
            cell.productOff.hidden=YES;
        }
        
        [cell.productPrice setTextColor:model.priceColor];
        cell.productPrice.text=[NSString stringWithFormat:@"%@%@",model.currencySymbo,[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
    }
    float result= [[[arrMoreProducts objectAtIndex:indexPath.row ] valueForKey:@"rating"]floatValue]/100*5;
    
    if (result==0.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==0.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==1.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==1.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==2.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==2.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==3.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==3.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==4.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==4.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-half.png"];
    }
    else if (result==5.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-filled.png"];
    }
    return cell;
    
}

#pragma mark- Collection View Delegate

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
    
    objViewController.strProdId=[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    
    [self.navigationController pushViewController:objViewController animated:YES];
    
    objViewController = nil;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = collectionView1.contentOffset.y + collectionView1.frame.size.height;
    if (bottomEdge >= collectionView1.contentSize.height)
    {
        if ([varMore isEqualToString:@"1"])
        {
            [self getProductData];
        }
        else
        {
            if (count==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNomoreitemsinthelist",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
                [alert show];
                count=0;
            }
        }
        
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

#pragma mark Back Button

- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}

#pragma mark SortBy Button

- (IBAction)SortBy:(id)sender
{
    sortingView.hidden=NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    coverView = [[UIView alloc] initWithFrame:screenRect];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:coverView];
    [coverView addSubview:sortingView];
}

- (IBAction)Sorting:(id)sender
{
    //    NSArray *resultArray;
    UIButton *button=(UIButton*)sender;
    //    NSSortDescriptor* sortOrder;
    
    if (arrMoreProducts.count>0)
    {
        if(button.tag==21)
        {
            //        sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"name" ascending: YES];
            sortBy=@"name_asc";
            i=0;
            [(UIImageView*)[self.view viewWithTag:31]setImage:[UIImage imageNamed:@"btn_radio-selected.png"]];
            [(UIImageView*)[self.view viewWithTag:32]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:33]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:34]setImage:[UIImage imageNamed:@"btn_radio.png"]];
        }
        else if(button.tag==22)
        {
            //        sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"name" ascending: NO];
            sortBy=@"name_desc";
            i=0;
            [(UIImageView*)[self.view viewWithTag:31]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:32]setImage:[UIImage imageNamed:@"btn_radio-selected.png"]];
            [(UIImageView*)[self.view viewWithTag:33]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:34]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            
        }
        else if(button.tag==23)
        {
            //        sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"final_price" ascending: YES];
            sortBy=@"price_asc";
            i=0;
            [(UIImageView*)[self.view viewWithTag:31]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:32]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:33]setImage:[UIImage imageNamed:@"btn_radio-selected.png"]];
            [(UIImageView*)[self.view viewWithTag:34]setImage:[UIImage imageNamed:@"btn_radio.png"]];
        }
        else
        {
            //        sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"final_price" ascending: NO];
            sortBy=@"price_desc";
            i=0;
            [(UIImageView*)[self.view viewWithTag:31]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:32]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:33]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [(UIImageView*)[self.view viewWithTag:34]setImage:[UIImage imageNamed:@"btn_radio-selected.png"]];
        }
        
        //        resultArray  = [arrMoreProducts sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
        
        //        NSLog(@"%@",resultArray);
        //        if (arrMoreProducts.count>0)
        //        {
        //            [arrMoreProducts removeAllObjects];
        //        }
        //
        //        [arrMoreProducts addObjectsFromArray:resultArray];
        [self getProductData];
        
        [collectionView1 setContentOffset:CGPointZero animated:YES];
        [collectionView1 reloadData];
    }
    sortingView.hidden=YES;
    [coverView removeFromSuperview];
}

#pragma mark - CartDetail Button

- (IBAction)cartDetailBtn_Action:(id)sender
{
    NSString * str =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"quote_count"]];
    
    if(![str isEqualToString:@"0"] && ![str isEqualToString:@"(null)"])
    {
        AddToCartView * obj = [[AddToCartView alloc]initWithNibName:@"AddToCartView" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tYourCartIsEmpty",nil) message:nil delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil, nil];
        [alert show];
        
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


#pragma mark Table View Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [delegate.arrOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.frame=CGRectMake(5, 2, 120, 22);
    
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    [cell.textLabel TransformAlignLabel];
    cell.textLabel.text=[delegate.arrOptions objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    clicked=NO;
    
    if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tAppInfo",nil)])
    {
        AppInfoView * obj = [[AppInfoView alloc]initWithNibName:@"AppInfoView" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tProfile",nil)])
    {
        UserProfileView * obj = [[UserProfileView alloc]initWithNibName:@"UserProfileView" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
        
    }
    else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tMyOrders",nil)])
    {
        MyOrdersViewController * obj = [[MyOrdersViewController alloc]initWithNibName:@"MyOrdersViewController" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
        
    }
    else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tNotifications",nil)])
    {
        NotificationCenter * obj = [[NotificationCenter alloc]initWithNibName:@"NotificationCenter" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tLanguage", nil)])
    {
        LanguageSettingView * obj = [[LanguageSettingView alloc]initWithNibName:@"LanguageSettingView" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    
    else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tLogin",nil)])
    {
        LoginViewController * obj = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        obj.strPage=@"ViewMore";
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tMyWishList",nil)])
    {
        WishListViewViewController * obj = [[WishListViewViewController alloc]initWithNibName:@"WishListViewViewController" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if ([[delegate.arrOptions objectAtIndex:indexPath.row] isEqualToString:AMLocalizedString(@"tMyDownloadables",nil)])
    {
        DownloadableView * obj = [[DownloadableView alloc]initWithNibName:@"DownloadableView" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    
    else
    {
        model.custId=[NSString stringWithFormat:@""];
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


#pragma mark touch event method

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [coverView setHidden:YES];
    [self.tableView1 setHidden:YES];
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


#pragma mark --Helper Method--

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str;
}

@end
