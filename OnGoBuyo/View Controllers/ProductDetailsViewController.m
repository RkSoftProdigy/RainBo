//
//  ProductDetailsViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/10/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import "CollectionCell.h"
#import "ModelClass.h"
#import "ProductDetailsViewController.h"
#import "ZoomImageViewController.h"
#import "LoginViewController.h"
#import "AddToCartView.h"
#import "AppInfoView.h"
#import "AppDelegate.h"
#import "UserProfileView.h"
#import "MyOrdersViewController.h"
#import "ViewController.h"
#import "ReviewsViewViewController.h"
#import "GroupedCell.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "NotificationCenter.h"
#import "DownloadableView.h"
#import "WishListViewViewController.h"
#import "CustomView.h"
#import "ViewMoreViewController.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "LanguageSettingView.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"
#import "UIWebView+transformWeb.h"
#import "UIDatePicker+Transform.h"
#import "UITextView+transform.h"

@interface ProductDetailsViewController ()<UITextFieldDelegate>
{
    ModelClass *model;
    NSMutableArray *arrProductDetails;
    NSMutableArray *arrImages;
    NSMutableArray *arrRelatedProducts;
    NSMutableArray *arrOptionRequest;
    NSMutableArray *arrGrouped;
    NSMutableArray *arrSimpleOptions;
    NSMutableArray *arrCalculate;
    NSMutableArray *arrDownloadableLinks;
    NSMutableArray *arrBundle;
    NSMutableArray *arrCustom;
    NSMutableArray *arrCustomBundle;
    NSMutableArray *arrLinkOption;
    NSDictionary *arrCustomBanner;
    NSMutableDictionary *dictOptions;
    NSDictionary *dictDropDown;
    NSDictionary *dictRadio;
    NSDictionary *dictRadiobundle;
    //    NSDictionary *dictSelectView;
    float heightBundleView;
    NSString *strDate;
    NSString *strRadio;
    NSString *strRadioBundle;
    NSString *strField;
    NSString *strView;
    NSMutableArray *strDropDown;
    NSString *dateOptionid;
    NSMutableArray *strSelect;
    
    UIView *coverView;
    UIView *optionsView;
    UIView *selectView;
    
    ApiClasses *obj_apiClass;
    
    BOOL clicked;
    BOOL wistlistadded;
    BOOL web;
    BOOL BuyNow;
    float mn;
    int opt;
    int i;
    CGRect Framen;
    //    int call;
    NSMutableArray *strSelection;
    int strRadioSelect;
    UITapGestureRecognizer *tapGestureRecognizer;
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@end

@implementation ProductDetailsViewController
@synthesize strProdId,scrollView,pageControl,productBorder,productImages,productsOff,productsName,productsPrice,inStock,descriptionBorder,descriptions,specificationView,collectionViewRelated,relatedProducts,LoginNowBorder,popUpView,AddToCart,buyNow,guestUser,tableView1,delegate,buttonOnImage,selectionView,groupedView,tableGrouped,customOptions,dateTimeView,doneButton,LabelDateOrtime,pickerDate,linksView,bundleOptionView,wishlistButton,reviewButton,pinCode,deliveryOptionView,cODImg,shippingImg,shipLabel,codlabel,deliveryOrder;

static NSString * const kCellReuseIdentifier = @"customCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [indicator stopAnimating];
    indicator.hidden = YES;
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [productImages TransformImage];
    [inStock TransformAlignLeftLabel];
    [productsName TransformAlignLabel];
    [productsPrice TransformAlignLabel];
    [productsOff TransformAlignLabel];
    [_orderImage TransformButton];
    [_deliveryOptionLbl TransformAlignLabel];
    [pinCode TransformTextField];
    [_checkBtn TransformButton];
    [descriptionLbl TransformLabel];
    [_descriptionWEB TransformWebView];
    [_DeliveryDaysLabel TransformAlignLabel];
    [_optionImage TransformImage];
    [_deliveryImg TransformImage];
    [deliveryOrder TransformAlignLabel];
    [shippingImg TransformImage];
    [cODImg TransformImage];
    [shipLabel TransformAlignLabel];
    [codlabel TransformAlignLabel];
    [_DeliveryDaysLabel TransformAlignLabel];
    [_samedayDispatchLbl TransformAlignLabel];
    [_DeliveryDaysLabel TransformAlignLabel];
    [_samedayDispatchLbl TransformAlignLabel];
    [_deliveryImg TransformImage];
    [_customImg TransformImage];
    [additionalLbl TransformLabel];
    [reviewLbl TransformAlignLabel];
    [_reviewCountLabel TransformAlignLeftLabel];
    [_lblCount TransformLabel];
    [relatedLbl TransformAlignLabel];
    [AddToCart TransformButton];
    [buyNow TransformButton];
    [groupedLbl TransformLabel];
    [optionLbl2 TransformLabel];
    [optionLbl1 TransformLabel];
    [_itLooksLbl TransformAlignLabel];
    [guestUser TransformButton];
    [orLbl TransformLabel];
    [LoginNowBorder TransformButton];
    [linkLbl TransformLabel];
    
    //    call=0;
    //initialization
    delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    model=[ModelClass sharedManager];
    
    arrProductDetails=[[NSMutableArray alloc]init];
    arrRelatedProducts=[[NSMutableArray alloc]init];
    arrGrouped=[NSMutableArray new];
    arrImages=[[NSMutableArray alloc]init];
    arrSimpleOptions=[[NSMutableArray alloc]init];
    arrDownloadableLinks=[NSMutableArray new];
    arrCalculate=[NSMutableArray new];
    arrCustom=[NSMutableArray new];
    arrCustomBundle=[NSMutableArray new];
    arrBundle=[NSMutableArray new];
    arrLinkOption=[NSMutableArray new];
    strRadioBundle=[NSString new];
    strSelect=[NSMutableArray new];
    arrCustomBanner=[NSDictionary new];
    strDropDown=[NSMutableArray new];
    strSelection=[NSMutableArray new];
    obj_apiClass=[[ApiClasses alloc]init];
    i=0;
    
    
    //word change
    [AddToCart setTitle:AMLocalizedString(@"tADDTOCART", nil) forState:UIControlStateNormal];
    [buyNow setTitle:AMLocalizedString(@"tBUYNOW", nil) forState:UIControlStateNormal];
    [descriptionLbl setText:AMLocalizedString(@"tDescription", nil)];
    [additionalLbl setText:AMLocalizedString(@"tAdditionalInformation", nil)];
    [reviewLbl setText:AMLocalizedString(@"tReviews", nil)];
    [relatedLbl setText:AMLocalizedString(@"tRelatedProducts", nil)];
    [optionLbl1 setText:AMLocalizedString(@"tOptions", nil)];
    [optionLbl2 setText:AMLocalizedString(@"tOptions", nil)];
    [groupedLbl setText:AMLocalizedString(@"tGrouped", nil)];
    [_itLooksLbl setText:AMLocalizedString(@"tITLOOKSLIKEYOUARENOTLOGGEDIN", nil)];
    [guestUser setTitle:AMLocalizedString(@"tContinueAsaGuestUser", nil) forState:UIControlStateNormal];
    [orLbl setText:AMLocalizedString(@"tOR", nil)];
    [LoginNowBorder setTitle:AMLocalizedString(@"tLoginNow", nil) forState:UIControlStateNormal];
    [doneButton setTitle:AMLocalizedString(@"tDone", nil) forState:UIControlStateNormal];
    [linkLbl setText:AMLocalizedString(@"tLinksSamples", nil)];
    [_deliveryOptionLbl setText:AMLocalizedString(@"tDeliveryOptions", nil)];  //set scroll view
    [pinCode setPlaceholder:AMLocalizedString(@"tEnterPincode", nil)];
    [_checkBtn setTitle:AMLocalizedString(@"tCheck", nil) forState:UIControlStateNormal];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    
    if([pT intValue]==101 || [pT intValue]==1011)
    {
        wishlistButton.hidden=YES;
        reviewButton.enabled=NO;
    }
    else
    {
        wishlistButton.hidden=NO;
        reviewButton.enabled=YES;
    }
    
    if (Is_IPhone4)
    {
        [scrollView setFrame:CGRectMake(0, 55+7, 320,self.view.bounds.size.height-100-7)];
        [scrollView setContentSize:CGSizeMake(320, 700)];
    }
    else
    {
        [scrollView setFrame:CGRectMake(0, 55+7, 320,self.view.bounds.size.height-20-7)];
        [scrollView setContentSize:CGSizeMake(320, 700)];
    }
    [self.view addSubview:scrollView];
    
    //set borders
    [self setBorderImageView:productBorder];
    [self setBorderView:descriptionBorder];
    [self setBorderView:specificationView];
    [self setBorderView:deliveryOptionView];
    [self setBorderButton:LoginNowBorder];
    [self setBorderButton:_checkBtn];
    [self setBorderButton:AddToCart];
    [self setBorderButton:buyNow];
    [self setBorderView2:popUpView];
    
    //set border of badge number
    
    self.lblCount.layer.cornerRadius=self.lblCount.frame.size.width/2;
    self.lblCount.clipsToBounds=YES;
    
    
    //API call
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self getProductdata];
        });
    });
    
    
    //hidden labels
    _orderImage.hidden=YES;
    
    //related products
    [collectionViewRelated registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    collectionViewRelated.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(130, 170)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [collectionViewRelated setCollectionViewLayout:flowLayout];
    [collectionViewRelated setAllowsSelection:YES];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    
    [tapGestureRecognizer setDelegate:self];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    
    [scrollView addGestureRecognizer:tapGestureRecognizer];
    
    // Do any additional setup after loading the view from its nib.
    _descriptionWEB.scalesPageToFit = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    //color change
    
    [AddToCart setBackgroundColor:model.buttonColor];
    [_topView setBackgroundColor:model.themeColor];
    [productsPrice setTextColor:model.priceColor];
    [_reviewCountLabel setTextColor:model.buttonColor];
    [LoginNowBorder setBackgroundColor:model.greenClr];
   // [_itLooksLbl setTextColor:model.buttonColor];
    [_checkBtn setBackgroundColor:model.secondaryColor];
    [buyNow setBackgroundColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ProductDetailView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
    
    [self.tableView1 setHidden:YES];
    
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
    
  //  NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    NSArray *arrAdd;
    if([pT intValue]==101 || [pT intValue]==1011)
    {
        
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil), AMLocalizedString(@"tAppInfo",nil),AMLocalizedString(@"tLanguage",nil),AMLocalizedString(@"tLogout", nil), nil];
        
    }
    else
    {
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil),AMLocalizedString(@"tMyWishList", nil),AMLocalizedString(@"tMyDownloadables", nil),AMLocalizedString(@"tAppInfo", nil),AMLocalizedString(@"tNotifications", nil),AMLocalizedString(@"tLanguage",nil),AMLocalizedString(@"tLogout", nil) , nil];
        
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
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"loginaddtoCart"]==YES)
    {
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"loginaddtoCart"];
        [self addtoCart];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"loginAddWishlist"]==YES)
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"loginAddWishlist"];
        [self wishlistBtn_Action:wishlistButton];
        
    }
}

#pragma mark Api Calls

-(void)getProductdata
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
        
        //---------------- API----------------------
        
        //    obj_apiClass=[[ApiClasses alloc]init];
        NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
        if ([str5 isEqualToString:@"(null)"])
        {
            str5=@"";
        }
        NSString *str56=[NSString stringWithFormat:@"%@",model.visitorID];
        if ([str56 isEqualToString:@"<null>"])
        {
            str56=@"";
        }
        NSString *str=[NSString stringWithFormat:@"%@productDetail?salt=%@&prod_id=%@&visitor_id=%@&cust_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,str56,str5,model.storeID,model.currencyID];
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_API1_Response:)];
    }
}

#pragma mark Api Response

-(void)Get_API1_Response:(NSDictionary*)responseDict
{
    //    if (call==1)
    //    {
    //        [self removeLoadingView];
    //        NSLog(@"%@",responseDict);
    //        if ([[[responseDict valueForKey:@"response"] valueForKey:@"in_stock"]intValue]==1)
    //        {
    //            inStock.textColor=[UIColor colorWithRed:133.0/255.0 green:183.0/255.0 blue:78.0/255.0 alpha:1.0];
    //            inStock.text=tInStock;
    //
    //        }
    //        else
    //        {
    //            inStock.textColor=[UIColor redColor];
    //            inStock.text=tOutofStock;
    //            if([[[responseDict valueForKey:@"response"] valueForKey:@"type_id"]isEqualToString:@"grouped"])
    //            {
    //                arrGrouped=[[responseDict valueForKey:@"response"] valueForKey:@"associated"];
    //                [tableGrouped reloadData];
    //            }
    //        }
    //    }
    //    else
    //    {
    opt=1;
    [self removeLoadingView];
    
    NSLog(@"%@",responseDict);
    if (![[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"fail"])
    {
        arrProductDetails=[responseDict valueForKey:@"response"];
        
        if (arrProductDetails!=0)
        {
            if ([[arrProductDetails valueForKey:@"wishlist_item_id"]isEqual:[NSNull null]] || [[arrProductDetails valueForKey:@"wishlist_item_id"]isEqualToString:@""])
            {
                [wishlistButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
                
            }
            else
            {
                [wishlistButton setImage:[UIImage imageNamed:@"ChildHeart.png"] forState:UIControlStateNormal];
                _wishListProductId=[arrProductDetails valueForKey:@"wishlist_item_id"];
            }
            
            if ([[[responseDict valueForKey:@"response"]valueForKey:@"images"]count]!=0)
            {
                arrImages=[[responseDict valueForKey:@"response"]valueForKey:@"images"];
            }
            if (arrImages.count!=0)
            {
                model.arrImages=arrImages;
            }
            if(arrImages.count==1 || arrImages.count==0)
            {
                pageControl.hidden = true;
            }
            pageControl.numberOfPages=arrImages.count;
            
            if (arrImages.count!=0)
            {
                if ([[[arrImages objectAtIndex:0] valueForKey:@"url"]isEqualToString:@""])
                {
                    [buttonOnImage setEnabled:NO];
                }
                else
                {
                    [buttonOnImage setEnabled:YES];
                }
                [indicator startAnimating];
                indicator.hidden = NO;
                productImages.image = [UIImage imageNamed:@"place_holder.png"];
                
                [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:0] valueForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"place_holder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image)
                    {
                        [indicator stopAnimating];
                        indicator.hidden = YES;
                    }
                    NSLog(@"Downloaded");
                }];
//                [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:0] valueForKey:@"url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    if(image)
//                    {
//                        [indicator stopAnimating];
//                        indicator.hidden = YES;
//                    }
//                    NSLog(@"Downloaded");
//                }];

               // [productImages sd_setImageWithURL:[[arrImages objectAtIndex:0] valueForKey:@"url"]placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
                
                
            }
            pageControl.currentPage=0;
            
            //labels value
            
            productsName.text=[arrProductDetails valueForKey:@"name"];
            
            NSLog(@"%f > %f",[[[arrProductDetails valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue],[[[arrProductDetails valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue]);
            if ([[[arrProductDetails valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue]>[[[arrProductDetails valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
            {
                NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
                
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",model.currencySymbo,[arrProductDetails valueForKey:@"price"]] attributes:attributes];
                
                productsOff.attributedText=attrText;
                productsOff.hidden=NO;
            }
            else
            {
                productsOff.hidden=YES;
            }
            if (![[arrProductDetails valueForKey:@"final_disc"]isEqualToString:@"0"])
            {
                _orderImage.hidden=NO;
                [_orderImage setTitle:[NSString stringWithFormat:@"%d%@%@",[[arrProductDetails valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff", nil)] forState:UIControlStateNormal];
            }
            else
            {
                _orderImage.hidden=YES;
            }
            
            
            productsPrice.text=[NSString stringWithFormat:@"%@%@",model.currencySymbo,[arrProductDetails valueForKey:@"final_price"]];
            
            if ([[arrProductDetails valueForKey:@"in_stock"]intValue]==1)
            {
                inStock.textColor=[UIColor colorWithRed:133.0/255.0 green:183.0/255.0 blue:78.0/255.0 alpha:1.0];
                inStock.text=AMLocalizedString(@"tInStock", nil);
            }
            else
            {
                inStock.textColor=[UIColor redColor];
                inStock.text=AMLocalizedString(@"tOutofStock", nil);
            }
            
            Framen=productBorder.frame;
            
            //check type of product
            
            if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"simple"])
            {
                if ([[arrProductDetails valueForKey:@"options"]count]!=0)
                {
                    Framen= [self CustomOptionsView:Framen];//custom options view
                    //                UIView *frame2=customOptions;
                    //                [self setViews:frame2.frame];//rest views
                }
                else
                {
                    //                [self setViews:frame1];
                }
            }
            //virtual products
            
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"virtual"])
            {
                if ([[arrProductDetails valueForKey:@"options"]count]!=0)
                {
                    Framen= [self CustomOptionsView:Framen];//custom options view
                    //custom options view
                    //                UIView *frame2=customOptions;
                    //                [self setViews:frame2.frame];//rest views
                }
                else
                {
                    //                [self setViews:frame1];
                }
            }
            //downloadable products
            
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"downloadable"])
            {
                
                if ([[arrProductDetails valueForKey:@"options"]count]!=0)
                {
                    Framen= [self CustomOptionsView:Framen];//custom options view
                    
                    //                [self CustomOptionsView:frame1];//custom options view
                    //                frame2=customOptions.frame;
                }
                //            else
                //            {
                ////                frame2=frame1;
                //            }
                
                if ([[arrProductDetails valueForKey:@"downloadable_options"]count]!=0)
                {
                    arrDownloadableLinks=[arrProductDetails valueForKey:@"downloadable_options"];
                    
                    linksView.frame=CGRectMake(20, Framen.origin.y+Framen.size.height+20, Framen.size.width,30);
                    [self setBorderView:linksView];
                    [scrollView addSubview:linksView];
                    
                    Framen =linksView.frame;
                    if ([arrDownloadableLinks valueForKey:@"samples"]!=nil)
                    {
                        if ([[[arrDownloadableLinks valueForKey:@"samples"] valueForKey:@"rows"]count]!=0)
                        {
                            NSArray *arrSample=[[arrDownloadableLinks valueForKey:@"samples"] valueForKey:@"rows"];
                            
                            UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,Framen.size.height, Framen.size.width-20,40+arrSample.count*35)];
                            [linksView addSubview:checkView];
                            
                            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
                            [title setText:[NSString stringWithFormat:@"%@ :",[[arrDownloadableLinks valueForKey:@"samples"] valueForKey:@"title"]]];
                            [title setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
                            [title TransformAlignLabel];
                            [title setFont:[UIFont systemFontOfSize:14.0]];
                            [checkView addSubview:title];
                            
                            int y=title.frame.origin.y+title.frame.size.height;
                            
                            for (int r=0; r<arrSample.count; r++)
                            {
                                UILabel *title2=[[UILabel alloc]initWithFrame:CGRectMake(4, y, 200, 30)];
                                [title2 setText:[[arrSample objectAtIndex:r]valueForKey:@"title"]];
                                [title2 setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
                                [title2 setFont:[UIFont systemFontOfSize:14.0]];
                                [title2 TransformAlignLabel];
                                [checkView addSubview:title2];
                                y=y+35;
                            }
                            linksView.frame=CGRectMake(Framen.origin.x, Framen.origin.y, Framen.size.width, checkView.frame.size.height+Framen.size.height);
                        }
                    }
                    Framen=linksView.frame;
                    
                    if ([arrDownloadableLinks valueForKey:@"links"]!=nil)
                    {
                        if ([[[arrDownloadableLinks valueForKey:@"links"] valueForKey:@"rows"]count]!=0)
                        {
                            NSArray *arrLinks=[[arrDownloadableLinks valueForKey:@"links"] valueForKey:@"rows"];
                            
                            UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,Framen.size.height, Framen.size.width-20 ,arrLinks.count*35+40)];
                            [linksView addSubview:checkView];
                            
                            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
                            [title setText:[[arrDownloadableLinks valueForKey:@"links"] valueForKey:@"title"]];
                            [title setTextColor:model.secondaryColor];
                            [title setFont:[UIFont boldSystemFontOfSize:14.0]];
                            [title TransformAlignLabel];
                            [checkView addSubview:title];
                            
                            int y=title.frame.origin.y+title.frame.size.height;
                            
                            UIView *viewColored=[[UIView alloc]initWithFrame:CGRectMake(0, y+5, checkView.frame.size.width, arrLinks.count*35)];
                            [viewColored setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:244.0/255.0 alpha:1.0]];
                            
                            [checkView addSubview:viewColored];
                            
                            y=5;
                            for (int m=0; m<arrLinks.count; m++)
                            {
                                UIButton *checkBox=[[UIButton alloc]initWithFrame:CGRectMake(5, y, 20, 20)];
                                [checkBox setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                                [checkBox addTarget:self action:@selector(CheckButtonDownloadable:) forControlEvents:UIControlEventTouchUpInside];
                                checkBox.tag=[[[arrLinks objectAtIndex:m]valueForKey:@"id"]intValue];
                                [checkBox TransformButton];
                                [viewColored addSubview:checkBox];
                                
                                UILabel *titleField=[[UILabel alloc]initWithFrame:CGRectMake(35, y-5, 170, 30)];
                                [titleField setText:[NSString stringWithFormat:@"%@ + %@",[[arrLinks objectAtIndex:m]valueForKey:@"title"],[[arrLinks objectAtIndex:m]valueForKey:@"link_price"]]];
                                [titleField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
                                [titleField setFont:[UIFont boldSystemFontOfSize:14.0]];
                                [titleField TransformAlignLabel];
                                [viewColored addSubview:titleField];
                                y=y+35;
                            }
                            linksView.frame=CGRectMake(Framen.origin.x, Framen.origin.y, Framen.size.width, checkView.frame.size.height+Framen.size.height+10);
                        }
                    }
                    Framen=linksView.frame;
                    //                [self setViews:linksView.frame];
                }
                
                //            else
                //            {
                //                [self setViews:frame1];
                //            }
            }
            //        Grouped Products
            
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"grouped"])
            {
                if ([[arrProductDetails valueForKey:@"associated"]count]!=0)
                {
                    NSLog(@"%@",[arrProductDetails valueForKey:@"associated"]);
                    arrGrouped=[arrProductDetails valueForKey:@"associated"];
                    groupedView.frame=CGRectMake(20, Framen.origin.y+Framen.size.height+20, Framen.size.width, arrGrouped.count*66+42);
                    [self setBorderView:groupedView];
                    [scrollView addSubview:groupedView];
                    [tableGrouped reloadData];
                    //                [self setViews:groupedView.frame];
                    Framen=groupedView.frame;            }
                //            else
                //            {
                //                [self setViews:frame1];
                //            }
            }
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"configurable"])
            {
                //            CGRect frame2;
                if([[arrProductDetails valueForKey:@"options"]count]!=0)
                {
                    Framen= [self CustomOptionsView:Framen];//custom options view
                    //                frame2 =customOptions.frame;
                }
                if ([[[arrProductDetails valueForKey:@"config_attributes"]valueForKey:@"attributes"]count]!=0)
                {
                    dictOptions=[NSMutableDictionary new];
                    dictOptions = [[arrProductDetails valueForKey:@"config_attributes"]valueForKey:@"attributes"];
                    
                    NSLog(@"%@",dictOptions);
                    
                    // Option 1 for selection
                    NSString *str=[NSString stringWithFormat:@"%d",opt];
                    
                    if ([dictOptions valueForKey:str]!=nil)
                    {
                        optionsView =[[UIView alloc]initWithFrame:CGRectMake(20, Framen.origin.y+Framen.size.height+20, Framen.size.width, 79)];
                        [self setBorderView:optionsView];
                        [scrollView addSubview:optionsView];
                        
                        UIImageView *leftLine=[[UIImageView alloc]initWithFrame:CGRectMake(8, 20, 70, 1)];
                        [leftLine setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]];
                        [optionsView addSubview:leftLine];
                        
                        UIImageView *rightLine=[[UIImageView alloc]initWithFrame:CGRectMake(optionsView.frame.size.width-78, 20, 70, 1)];
                        [rightLine setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]];
                        [optionsView addSubview:rightLine];
                        
                        UILabel *labelOption=[[UILabel alloc]initWithFrame:CGRectMake(84, 10, 112, 21)];
                        [labelOption setText:AMLocalizedString(@"tOptions", nil)];
                        labelOption.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
                        [labelOption setFont:[UIFont boldSystemFontOfSize:13.0]];
                        labelOption.textAlignment=NSTextAlignmentCenter;
                        [labelOption TransformLabel];
                        [optionsView addSubview:labelOption];
                        
                        UILabel *labelButton1=[[UILabel alloc]initWithFrame:CGRectMake(12, 40, 257, 30)];
                        [labelButton1 setText:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"tSelect", nil),[[dictOptions valueForKey:str]valueForKey:@"label"]]];
                        labelButton1.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
                        [labelButton1 setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
                        [self setBorderLabelGray:labelButton1];
                        [labelButton1 setFont:[UIFont systemFontOfSize:13.0]];
                        labelButton1.tag=opt;
                        labelButton1.textAlignment=NSTextAlignmentCenter;
                        [labelButton1 TransformLabel];
                        [optionsView addSubview:labelButton1];
                        
                        UIImageView *downArrow=[[UIImageView alloc]initWithFrame:CGRectMake(245, 50, 16, 12)];
                        [downArrow setImage:[UIImage imageNamed:@"down_icon.png"]];
                        downArrow.tag=opt;
                        [optionsView addSubview:downArrow];
                        
                        UIButton *buttonOption1=[[UIButton alloc]initWithFrame:CGRectMake(12, 40, 257, 30)];
                        [buttonOption1 addTarget:self action:@selector(OptionButtons:) forControlEvents:UIControlEventTouchUpInside];
                        buttonOption1.tag=opt;
                        
                        [optionsView addSubview:buttonOption1];
                    }
                    int y=1;
                    
                    while ([dictOptions valueForKey:[NSString stringWithFormat:@"%d",y]]!=nil)
                    {
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%d",y]];
                        y=y+1;
                    }
                    
                    arrOptionRequest=[[NSMutableArray alloc]init];
                    for (int u=0; u< dictOptions.count; u++)
                    {
                        [arrOptionRequest addObject:@"0"];
                    }
                    Framen=optionsView.frame;
                    //                [self setViews:optionsView.frame];
                }
                else
                {
                    //                [self setViews:frame1];
                }
            }
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"bundle"])
            {
                //            CGRect frame2;
                if([[arrProductDetails valueForKey:@"options"]count]!=0)
                {
                    Framen
                    = [self CustomOptionsView:Framen];//custom options view
                    //                frame2 =customOptions.frame;
                }
                //            else
                //            {
                //                frame2 =frame1;
                //
                //            }
                if ([[arrProductDetails valueForKey:@"bundle_options"]count]!=0)
                {
                    NSLog(@"%@",[arrProductDetails valueForKey:@"bundle_options"]);
                    
                    arrBundle=[arrProductDetails valueForKey:@"bundle_options"];
                    
                    bundleOptionView.frame=CGRectMake(20, Framen.origin.y+Framen.size.height+20, Framen.size.width,30);
                    [self setBorderView:bundleOptionView];
                    [scrollView addSubview:bundleOptionView];
                    Framen=bundleOptionView.frame;
                    for (int j=0; j<arrBundle.count; j++)
                    {
                        if ([[[arrBundle objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"select"])
                        {
                            Framen=[self SelectView:Framen dict:[arrBundle objectAtIndex:j]indexNo:j];
                        }
                        else if ([[[arrBundle objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"radio"])
                        {
                            Framen=[self RadioButtonBundle:Framen dict:[arrBundle objectAtIndex:j]];
                        }
                        else if ([[[arrBundle objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"checkbox"])
                        {
                            Framen=[self CheckboxViewBundle:Framen dict:[arrBundle objectAtIndex:j]];
                        }
                    }
                    
                    
                    //                [self setViews:frame2];
                }
                //            else
                //            {
                //                [self setViews:frame1];
                //            }
            }
            //        else
            //        {
            //            frame1=frame1;
            ////            [self setViews:frame1];
            //        }
            //
            //description view
            //        [self setDeliveryView:deliveryOptionView.frame];
            deliveryOptionView.frame=CGRectMake(deliveryOptionView.frame.origin.x, Framen.origin.y+Framen.size.height+20, deliveryOptionView.frame.size.width,66);
            NSString *str=[NSString stringWithFormat:@"%@",[arrProductDetails valueForKey:@"description"] ];
            NSString *htmlString =
            [NSString stringWithFormat:@"<font face='System' size='10'>%@", str];
            [_descriptionWEB loadHTMLString:htmlString baseURL:nil];
            
        }
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    
}



#pragma mark ---Create Views Methods---

-(CGRect)CustomOptionsView:(CGRect)frame1
{
    NSLog(@"%@",[arrProductDetails valueForKey:@"options"]);
    arrSimpleOptions=[arrProductDetails valueForKey:@"options"];
    
    customOptions.frame=CGRectMake(20, frame1.origin.y+frame1.size.height+20, frame1.size.width,30);
    [self setBorderView:customOptions];
    [scrollView addSubview:customOptions];
    
    UIView *frame2=customOptions;
    for (int j=0; j<arrSimpleOptions.count; j++)
    {
        if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"checkbox"])
        {
            frame2=[self CheckboxView:frame2.frame dict:[arrSimpleOptions objectAtIndex:j]];
        }
        else if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"field"])
        {
            frame2=[self TextfieldView:frame2.frame dict:[arrSimpleOptions objectAtIndex:j]];
        }
        else if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"date_time"])
        {
            frame2=[self DateTimeView:frame2.frame dict:[arrSimpleOptions objectAtIndex:j]];
        }
        else if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"multiple"])
        {
            frame2=[self MultipleView:frame2.frame dict:[arrSimpleOptions objectAtIndex:j]];
        }
        else if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"radio"])
        {
            frame2=[self RadioButtonView:frame2.frame dict:[arrSimpleOptions objectAtIndex:j]];
        }
        else if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"area"])
        {
            frame2=[self TextView:frame2.frame dict:[arrSimpleOptions objectAtIndex:j]];
        }
        else if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"drop_down"])
        {
            frame2=[self DropDownView:frame2.frame dict:[arrSimpleOptions objectAtIndex:j] indexNo:j];
        }
    }
    return frame2.frame;
    
}

- (IBAction)CustomBannerButton:(id)sender
{
    if ([arrCustomBanner isKindOfClass:[NSDictionary class]])
    {
        if([[arrCustomBanner valueForKey:@"link_type"] isEqualToString:@"category"])
        {
            if ([[arrCustomBanner valueForKey:@"has_link"] intValue]==1)
            {
                ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
                objViewController.strName=@"Products";
                objViewController.apiType = @"SearchApi";
                objViewController.categoryID=[arrCustomBanner valueForKey:@"link_val"];
                
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
        else if ([[arrCustomBanner valueForKey:@"link_type"] isEqualToString:@"product"])
        {
            if ([[arrCustomBanner valueForKey:@"has_link"] intValue]==1)
            {
                ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
                NSString *str=[NSString stringWithFormat:@"%@",[arrCustomBanner valueForKey:@"link_val"]];
                
                NSRange range = [str rangeOfString:@"#"];
                NSString *newString = [str substringToIndex:range.location];
                NSLog(@"%@",newString);
                
                objViewController.strProdId=newString;
                [self.navigationController pushViewController:objViewController animated:YES];
                
                objViewController = nil;
            }
        }
        else if ([[arrCustomBanner valueForKey:@"link_type"] isEqualToString:@"custom"])
        {
            if ([[arrCustomBanner valueForKey:@"has_link"] intValue]==1)
            {
                CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
                
                objViewController.urlToDisplay=[arrCustomBanner valueForKey:@"link_val"];
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
        else if ([[arrCustomBanner valueForKey:@"link_type"] isEqualToString:@"page"])
        {
            if ([[arrCustomBanner valueForKey:@"has_link"] intValue]==1)
            {
                CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
                objViewController.urlToDisplay=[arrCustomBanner valueForKey:@"link_val"];
                objViewController.strPrev=@"page";
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
    }
}
-(void)setDeliveryView: (CGRect)frame1
{
    deliveryOptionView.frame=CGRectMake(frame1.origin.x, Framen.origin.y+Framen.size.height+20, frame1.size.width,0);
    deliveryOptionView.hidden=YES;
    [scrollView addSubview:deliveryOptionView];
    
    [self setDescriptionView:deliveryOptionView.frame];
}

-(void)setDescriptionView: (CGRect)frame1
{
    //second section
    
    //    NSString *str=[NSString stringWithFormat:@"%@",[arrProductDetails valueForKey:@"description"] ];
    //    NSString *htmlString =
    //    [NSString stringWithFormat:@"<font face='System' size='10'>%@", str];
    //        [_descriptionWEB loadHTMLString:htmlString baseURL:nil];
    //    [descriptions setText:str];
    //        [descriptions setTextAlignment:NSTextAlignmentLeft];
    //    UIFont *textFont = [UIFont systemFontOfSize:10.0];
    //    CGSize constraintSize = CGSizeMake(160.0f, MAXFLOAT);
    //    CGRect textRect = [str boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont}context:nil];
    //delivery Options
    
    
    
    CGFloat heightComment = _descriptionWEB.frame.size.height;
    
    //    [descriptions setUserInteractionEnabled:NO];
    //    [descriptions setContentSize:CGSizeMake(descriptions.frame.size.width, heightComment)];
    _descriptionWEB.frame =CGRectMake(_descriptionWEB.frame.origin.x, _descriptionWEB.frame.origin.y, _descriptionWEB.frame.size.width, heightComment);
    //    descriptions.frame = CGRectMake(descriptions.frame.origin.x, descriptions.frame.origin.y, descriptions.frame.size.width, heightComment);
    descriptionBorder.frame=CGRectMake(frame1.origin.x, frame1.origin.y+frame1.size.height, descriptionBorder.frame.size.width, _descriptionWEB.frame.size.height+40);
    [scrollView addSubview:descriptionBorder];
    frame1=descriptionBorder.frame;
    
    if (![[arrProductDetails valueForKey:@"custom_banner"]isEqual:[NSNull null]])
    {
        arrCustomBanner=[arrProductDetails valueForKey:@"custom_banner"];
        if (![[arrCustomBanner valueForKey:@"img"]isEqualToString:@""] && ![[arrCustomBanner valueForKey:@"img"]isEqual:[NSNull null]])
        {
            NSURL *imageurl=[NSURL URLWithString:[arrCustomBanner valueForKey:@"img"]];
            [_customImg setImageURL:imageurl];
            _customBannerView.hidden=NO;
            _customBannerView.frame=CGRectMake(frame1.origin.x, frame1.origin.y+frame1.size.height+20, frame1.size.width, _customImg.frame.size.height);
            [scrollView addSubview:_customBannerView];
            
            //        frame1 =_customBannerView.frame;
            
            if (Is_IPhone4)
            {
                [scrollView setContentSize:CGSizeMake(320,frame1.size.height+50)];
            }
            else
            {
                [scrollView setContentSize:CGSizeMake(320,frame1.size.height+10)];
            }
            [self setViews:_customBannerView.frame];
        }
        
        else
        {
            _customBannerView.hidden=YES;
        }
        
        
    }
    else
    {
        [self setViews:descriptionBorder.frame];
    }
    
}

-(void)setViews:(CGRect)frame1
{
    //specifications
    
    NSArray *arrSpecification = [arrProductDetails valueForKey:@"specification"];
    
    if (arrSpecification.count==0)
    {
        specificationView.hidden=YES;
    }
    else
    {
        specificationView.hidden=NO;
        
        NSLog(@"%lu",(unsigned long)arrSpecification.count);
        int y=35;
        
        for (int s = 0;s<arrSpecification.count; s++)
        {
            UILabel *labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, y, 100, 21)];
            [labelTitle setText:[NSString stringWithFormat:@"%@",[[arrSpecification objectAtIndex:s]valueForKey:@"label"]]];
            [labelTitle setFont:[UIFont systemFontOfSize:12.0]];
            labelTitle.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            [labelTitle setTextAlignment:NSTextAlignmentRight];
            labelTitle.numberOfLines=2;
            [labelTitle TransformAlignLabel];
            [self LabelBreak2:labelTitle];
            [specificationView addSubview:labelTitle];
            
            UILabel *labelDescription=[[UILabel alloc]initWithFrame:CGRectMake(160, y, 100, 21)];
            [labelDescription setText:[NSString stringWithFormat:@"%@",[self stringByStrippingHTML:[[arrSpecification objectAtIndex:s]valueForKey:@"value"]]]];
            [labelDescription setFont:[UIFont systemFontOfSize:12.0]];
            labelDescription.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            [labelDescription setTextAlignment:NSTextAlignmentLeft];
            labelDescription.numberOfLines=2;
            [labelDescription TransformAlignLabel];
            [self LabelBreak2:labelDescription];
            [specificationView addSubview:labelDescription];
            if (labelDescription.frame.size.height>labelTitle.frame.size.height)
            {
                y=y+labelDescription.frame.size.height+3;
                if ([[[arrProductDetails valueForKey:@"config_attributes"]valueForKey:@"attributes"]count]!=0)
                {
                    specificationView.frame=CGRectMake(specificationView.frame.origin.x,frame1.origin.y+frame1.size.height+20, specificationView.frame.size.width, y);
                }
                else
                {
                    specificationView.frame=CGRectMake(specificationView.frame.origin.x, frame1.origin.y+frame1.size.height+20, specificationView.frame.size.width, y);
                }
            }
            else
            {
                y=y+labelTitle.frame.size.height+3;
                if ([[[arrProductDetails valueForKey:@"config_attributes"]valueForKey:@"attributes"]count]!=0)
                {
                    specificationView.frame=CGRectMake(specificationView.frame.origin.x, frame1.origin.y+frame1.size.height+20, specificationView.frame.size.width, y);
                }
                else
                {
                    specificationView.frame=CGRectMake(specificationView.frame.origin.x, frame1.origin.y+frame1.size.height+20, specificationView.frame.size.width, y);
                }
            }
            
        }
        if ([[[arrProductDetails valueForKey:@"config_attributes"]valueForKey:@"attributes"]count]!=0)
        {
            
            [scrollView setContentSize:CGSizeMake(320, specificationView.frame.origin.y+specificationView.frame.size.height+50+arrSpecification.count*21)];
        }
        else
        {
            [scrollView setContentSize:CGSizeMake(320, specificationView.frame.origin.y+specificationView.frame.size.height+50+arrSpecification.count*21)];
        }
    }
    
    //reviews
    
    if (arrSpecification.count==0)
    {
        self.reviewsView.frame=CGRectMake(20, frame1.origin.y+frame1.size.height+20, self.reviewsView.frame.size.width, self.reviewsView.frame.size.height);
        [scrollView setContentSize:CGSizeMake(320,self.reviewsView.frame.origin.y+ self.reviewsView.frame.size.height+50)];
    }
    else
    {
        self.reviewsView.frame=CGRectMake(20, specificationView.frame.origin.y+specificationView.frame.size.height+20, self.reviewsView.frame.size.width, self.reviewsView.frame.size.height);
        [scrollView setContentSize:CGSizeMake(320,self.reviewsView.frame.origin.y+ self.reviewsView.frame.size.height+50)];
    }
    self.reviewCountLabel.text=[NSString stringWithFormat:@"%i", [[arrProductDetails valueForKey:@"review_count"]intValue]];
    //    self.reviewsView.layer.cornerRadius=4.0;
    //    self.reviewsView.layer.borderWidth=1;
    //    self.reviewsView.layer.borderColor=[[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]CGColor];
    
    //related products
    
    arrRelatedProducts=[arrProductDetails valueForKey:@"related"];
    
    if(arrRelatedProducts.count!=0)
    {
        relatedProducts.frame=CGRectMake(20,self.reviewsView.frame.origin.y +self.reviewsView.frame.size.height+10, relatedProducts.frame.size.width, relatedProducts.frame.size.height);
        [scrollView setContentSize:CGSizeMake(320, relatedProducts.frame.origin.y+relatedProducts.frame.size.height)];
        [scrollView addSubview:relatedProducts];
        [collectionViewRelated reloadData];
    }
    else
    {
        relatedProducts.hidden=YES;
        [scrollView setContentSize:CGSizeMake(320, self.reviewsView.frame.origin.y+self.reviewsView.frame.size.height)];
        [scrollView addSubview:relatedProducts];
        [collectionViewRelated reloadData];
    }
    //    if (scrollView.contentSize.height+55<self.view.frame.size.height)
    //    {
    ////        [scrollView setScrollEnabled:NO];
    //        NSLog(@"scroll.height%f=self.view.height%f",scrollView.contentSize.height+55,self.view.frame.size.height);
    //    }
    //    else
    //    {
    //        NSLog(@"scroll.height%f=self.view.height%f",scrollView.contentSize.height+55,self.view.frame.size.height);
    //    }
}

#pragma mark ---Bundle View Methods---

-(CGRect)SelectView:(CGRect)frame1  dict:(NSDictionary*)dict indexNo:(int)v
{
    //    dictSelectView=dict;
    if ([[dict valueForKey:@"selections"]count]!=0)
    {
        UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,100)];
        [bundleOptionView addSubview:checkView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        [title setText:[dict valueForKey:@"title"]];
        [title setTextColor:model.secondaryColor];
        [title setFont:[UIFont boldSystemFontOfSize:14.0]];
        [checkView addSubview:title];
        [title TransformAlignLabel];
        int y=title.frame.origin.y+title.frame.size.height+5;
        
        UILabel *labelSelect=[[UILabel alloc]initWithFrame:CGRectMake(5, y, checkView.frame.size.width-10, 30)];
        [labelSelect setText:AMLocalizedString(@"tSelect", nil)];
        [labelSelect setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [labelSelect setFont:[UIFont systemFontOfSize:15.0]];
        [labelSelect setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        [labelSelect setTextAlignment:NSTextAlignmentCenter];
        labelSelect.tag=[[[arrBundle objectAtIndex:v] valueForKey:@"option_id"]intValue]+999;
        [self setBorderLabelGray:labelSelect];
        [labelSelect TransformLabel];
        [checkView addSubview:labelSelect];
        
        UIImageView *downArrow=[[UIImageView alloc]initWithFrame:CGRectMake(240, y+10, 10, 10)];
        [downArrow setImage:[UIImage imageNamed:@"down_arrow.png"]];
        [checkView addSubview:downArrow];
        
        UIButton *buttonOption1=[[UIButton alloc]initWithFrame:CGRectMake(5, y, checkView.frame.size.width-10, 30)];
        [buttonOption1 addTarget:self action:@selector(SelectButton:) forControlEvents:UIControlEventTouchUpInside];
        buttonOption1.tag=checkView.frame.origin.y+y;
        buttonOption1.accessibilityLabel=[NSString stringWithFormat:@"%d",v];
        [checkView addSubview:buttonOption1];
        
        UILabel *lblQuantity=[[UILabel alloc]initWithFrame:CGRectMake(5, y+40, 30, 21)];
        [lblQuantity setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        [lblQuantity setText:AMLocalizedString(@"tQty", nil)];
        [lblQuantity setFont:[UIFont systemFontOfSize:14.0]];
        [lblQuantity TransformLabel];
        [checkView addSubview:lblQuantity];
        
        UIView *viewQuantity=[[UIView alloc]initWithFrame:CGRectMake(40, y+40, 32, 21)];
        [viewQuantity setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]];
        [self setBorderView2:viewQuantity];
        [checkView addSubview:viewQuantity];
        
        UITextField *fieldQuantity=[[UITextField alloc]initWithFrame:CGRectMake(42, y+40, 30, 21)];
        [fieldQuantity setFont:[UIFont systemFontOfSize:12.0]];
        [fieldQuantity setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        [fieldQuantity setTag:[[[arrBundle objectAtIndex:v] valueForKey:@"option_id"]intValue]];
        [fieldQuantity setAccessibilityHint:[NSString stringWithFormat: @"%d",v]];
        [fieldQuantity addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        fieldQuantity.delegate=self;
        fieldQuantity.keyboardType = UIKeyboardTypeNumberPad;
        [fieldQuantity TransformTextField];
        [checkView addSubview:fieldQuantity];
        
        bundleOptionView.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, checkView.frame.size.height+frame1.size.height+10);
    }
    return bundleOptionView.frame;
}

-(CGRect)RadioButtonBundle:(CGRect)frame1  dict:(NSDictionary*)dict
{
    dictRadiobundle=dict;
    if ([[dict valueForKey:@"selections"]count]!=0)
    {
        NSArray *arrAdditional=[dict valueForKey:@"selections"];
        
        UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,arrAdditional.count*35+62)];
        [bundleOptionView addSubview:checkView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        [title setText:[dict valueForKey:@"title"]];
        [title setTextColor:model.secondaryColor];
        [title setFont:[UIFont boldSystemFontOfSize:14.0]];
        [title TransformAlignLabel];
        [checkView addSubview:title];
        
        int y=title.frame.origin.y+title.frame.size.height;
        
        UIView *viewColored=[[UIView alloc]initWithFrame:CGRectMake(0, y+5, checkView.frame.size.width, arrAdditional.count*35)];
        [viewColored setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [checkView addSubview:viewColored];
        
        y=5;
        
        for (int m=0; m<arrAdditional.count; m++)
        {
            UIButton *checkBox=[[UIButton alloc]initWithFrame:CGRectMake(5, y, 20, 20)];
            [checkBox setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(radioButtonBundle:) forControlEvents:UIControlEventTouchUpInside];
            checkBox.accessibilityLabel = [dict valueForKey:@"option_id"];
            checkBox.tag=[[[arrAdditional objectAtIndex:m]valueForKey:@"selection_id"]intValue];
            [checkBox TransformButton];
            [viewColored addSubview:checkBox];
            
            UILabel *titleField=[[UILabel alloc]initWithFrame:CGRectMake(35, y-5, 240, 30)];
            [titleField setText:[NSString stringWithFormat:@"%@ + %.2f",[[arrAdditional objectAtIndex:m]valueForKey:@"name"],[[[arrAdditional objectAtIndex:m]valueForKey:@"special_price"]floatValue]]];
            [titleField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [titleField setFont:[UIFont systemFontOfSize:13.0]];
            [titleField TransformAlignLabel];
            [viewColored addSubview:titleField];
            y=y+35;
        }
        
        UILabel *lblQuantity=[[UILabel alloc]initWithFrame:CGRectMake(5, y+40, 30, 21)];
        [lblQuantity setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        [lblQuantity setText:AMLocalizedString(@"tQty", nil) ];
        [lblQuantity setFont:[UIFont systemFontOfSize:14.0]];
        [lblQuantity TransformAlignLabel];
        [checkView addSubview:lblQuantity];
        
        UIView *viewQuantity=[[UIView alloc]initWithFrame:CGRectMake(40, y+40, 32, 21)];
        [viewQuantity setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]];
        [self setBorderView2:viewQuantity];
        [checkView addSubview:viewQuantity];
        
        UITextField *fieldQuantity=[[UITextField alloc]initWithFrame:CGRectMake(42, y+40, 30, 21)];
        [fieldQuantity setFont:[UIFont systemFontOfSize:12.0]];
        [fieldQuantity setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        [fieldQuantity setTag:[[dict valueForKey:@"option_id"]intValue]];
        [fieldQuantity addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        fieldQuantity.keyboardType = UIKeyboardTypeNumberPad;
        fieldQuantity.delegate=self;
        [fieldQuantity TransformTextField];
        [checkView addSubview:fieldQuantity];
        
        bundleOptionView.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, checkView.frame.size.height+frame1.size.height+10);
    }
    return bundleOptionView.frame;
}

-(CGRect)CheckboxViewBundle:(CGRect)frame1  dict:(NSDictionary*)dict
{
    if ([[dict valueForKey:@"selections"]count]!=0)
    {
        NSArray *arrAdditional=[dict valueForKey:@"selections"];
        UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,arrAdditional.count*35+40)];
        [bundleOptionView addSubview:checkView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        [title setText:[dict valueForKey:@"title"]];
        [title setTextColor:model.secondaryColor];
        [title setFont:[UIFont boldSystemFontOfSize:14.0]];
        [title TransformAlignLabel];
        [checkView addSubview:title];
        
        int y=title.frame.origin.y+title.frame.size.height;
        
        UIView *viewColored=[[UIView alloc]initWithFrame:CGRectMake(0, y+5, checkView.frame.size.width, arrAdditional.count*35)];
        [viewColored setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [checkView addSubview:viewColored];
        
        y=5;
        
        for (int m=0; m<arrAdditional.count; m++)
        {
            UIButton *checkBox=[[UIButton alloc]initWithFrame:CGRectMake(5, y, 20, 20)];
            [checkBox setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(CheckButtonBundle:) forControlEvents:UIControlEventTouchUpInside];
            checkBox.accessibilityLabel = [dict valueForKey:@"option_id"];
            checkBox.tag=[[[arrAdditional objectAtIndex:m]valueForKey:@"selection_id"]intValue];
            [checkBox TransformButton];
            [viewColored addSubview:checkBox];
            
            UILabel *titleField=[[UILabel alloc]initWithFrame:CGRectMake(35, y-5, 240, 30)];
            [titleField setText:[[NSString stringWithFormat:@"%@ + %.2f",[[arrAdditional objectAtIndex:m]valueForKey:@"name"],[[[arrAdditional objectAtIndex:m]valueForKey:@"price"]floatValue]]stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
            [titleField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [titleField TransformAlignLabel];
            [titleField setFont:[UIFont systemFontOfSize:13.0]];
            [viewColored addSubview:titleField];
            y=y+35;
        }
        
        bundleOptionView.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, checkView.frame.size.height+frame1.size.height+10);
    }
    return bundleOptionView.frame;
}

#pragma mark ---Bundle Action Methods---

-(void)SelectButton:(UIButton*)sender
{
    [tapGestureRecognizer setCancelsTouchesInView:YES];
    NSLog(@"%ld",(long)sender.tag);
    if ([[[arrBundle objectAtIndex:[sender.accessibilityLabel intValue]] valueForKey:@"selections"]count]!=0)
    {
        NSArray *arrAdditional=[[arrBundle objectAtIndex:[sender.accessibilityLabel intValue]] valueForKey:@"selections"];
        
        selectView=[[UIView alloc]initWithFrame:CGRectMake(16,sender.tag+2, bundleOptionView.frame.size.width-42 ,34+arrAdditional.count*35)];
        [selectView setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]];
        [bundleOptionView addSubview:selectView];
        
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 190, 30)];
        [title setText:AMLocalizedString(@"tSelect", nil)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        [title setFont:[UIFont systemFontOfSize:14.0]];
        [title TransformAlignLabel];
        [selectView addSubview:title];
        
        int y=title.frame.origin.y+title.frame.size.height+5;
        
        for (int m=0; m<arrAdditional.count; m++)
        {
            UILabel *titleField=[[UILabel alloc]initWithFrame:CGRectMake(5, y-5, 240, 30)];
            [titleField setText:[[NSString stringWithFormat:@"%@ + %@",[[arrAdditional objectAtIndex:m]valueForKey:@"name"],[[arrAdditional objectAtIndex:m]valueForKey:@"price"]]stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
            [titleField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [titleField setFont:[UIFont systemFontOfSize:12.0]];
            [titleField TransformAlignLabel];
            [selectView addSubview:titleField];
            
            UIButton *buttonTitle=[[UIButton alloc]initWithFrame:CGRectMake(5, y-5, 240, 30)];
            buttonTitle.accessibilityLabel=[[arrBundle objectAtIndex:[sender.accessibilityLabel intValue]] valueForKey:@"option_id"];
            buttonTitle.tag=[[[arrAdditional objectAtIndex:m]valueForKey:@"selection_id"]intValue];
            [buttonTitle setAccessibilityHint:sender.accessibilityLabel];
            [buttonTitle addTarget:self action:@selector(SelectOptionBundle:) forControlEvents:UIControlEventTouchUpInside];
            [buttonTitle TransformButton];
            [selectView addSubview:buttonTitle];
            
            y=y+35;
        }
        float r=bundleOptionView.frame.origin.y+selectView.frame.origin.y+selectView.frame.size.height;
        float s= bundleOptionView.frame.origin.y+bundleOptionView.frame.size.height;
        
        if (r > s)
        {
            heightBundleView=bundleOptionView.frame.size.height;
            bundleOptionView.frame=CGRectMake(bundleOptionView.frame.origin.x, bundleOptionView.frame.origin.y, bundleOptionView.frame.size.width, r-bundleOptionView.frame.origin.y);
            Framen=bundleOptionView.frame;
            [self setDeliveryView:deliveryOptionView.frame];
        }
        
    }
}

-(void)radioButtonBundle:(UIButton*)sender
{
    NSLog(@"Option_id----%@",sender.accessibilityLabel);
    NSLog(@"Product_type_id----%ld",(long)sender.tag);
    
    if ([[dictRadiobundle valueForKey:@"selections"]count]!=0)
    {
        NSArray *arrAdditional=[dictRadiobundle valueForKey:@"selections"];
        for (int g=0; g<arrAdditional.count; g++)
        {
            if ([[[arrAdditional objectAtIndex:g]valueForKey:@"selection_id"]intValue]==sender.tag)
            {
                [(UIButton*)[scrollView viewWithTag:[[[arrAdditional objectAtIndex:g]valueForKey:@"selection_id"]intValue]]setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
                [(UITextField*)[self.view viewWithTag:[sender.accessibilityLabel intValue]]setText:[NSString stringWithFormat:@"%@",[[arrAdditional objectAtIndex:g]valueForKey:@"selection_qty"]]];
                
                //                to calculate product price
                
                for (int c=0; c<arrCalculate.count; c++)
                {
                    NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                    if ([[str objectAtIndex:0]isEqualToString:@"radioBundle"])
                    {
                        [arrCalculate removeObjectAtIndex:c];
                    }
                }
                [arrCalculate addObject:[NSString stringWithFormat:@"radioBundle,%ld,%f",(long)sender.tag,[[[arrAdditional objectAtIndex:g]valueForKey:@"special_price"]floatValue]*[[(UITextField*)[self.view viewWithTag:[sender.accessibilityLabel intValue]]text]floatValue]]];
                
                strRadioBundle=[NSString stringWithFormat:@"bundle_option[%@]=%@",[[arrAdditional objectAtIndex:g]valueForKey:@"option_id"],[[arrAdditional objectAtIndex:g]valueForKey:@"selection_id"]];
            }
            else
            {
                [(UIButton*)[scrollView viewWithTag:[[[arrAdditional objectAtIndex:g]valueForKey:@"selection_id"]intValue]]setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
            }
        }
    }
    strRadioSelect=(int)sender.tag;
    
    [self calculatePrice];
    
    NSLog(@"%@",strRadioBundle);
    //    btn_radio-selected.png
    //    btn_radio.png
}

-(void)CheckButtonBundle:(UIButton*)sender
{
    NSLog(@"Option_id----%@",sender.accessibilityLabel);
    NSLog(@"Product_type_id----%ld",(long)sender.tag);
    UIImage *img1=[UIImage imageNamed:@"uncheck.png"];
    UIImage *img2=sender.imageView.image;
    NSData *imgdata1 = UIImagePNGRepresentation(img1);
    NSData *imgdata2 = UIImagePNGRepresentation(img2);
    
    if ([imgdata1 isEqualToData:imgdata2])
    {
        NSLog(@"Same Image");
        [(UIButton*)[scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"blue_tick.png"] forState:UIControlStateNormal];
        if (![arrCustomBundle containsObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]])
        {
            [arrCustomBundle addObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]];
            for (int j=0; j<arrBundle.count; j++)
            {
                if ([[[arrBundle objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"checkbox"])
                {
                    if ([[arrBundle objectAtIndex:j]count]!=0)
                    {
                        NSArray *arrAdditional=[[arrBundle objectAtIndex:j] valueForKey:@"selections"];
                        for (int c=0; c<arrAdditional.count; c++)
                        {
                            if ([[[arrAdditional objectAtIndex:c]valueForKey:@"selection_id"]intValue]==sender.tag)
                            {
                                [arrCalculate addObject:[NSString stringWithFormat:@"checkBundle,%ld,%f",(long)sender.tag,[[[arrAdditional objectAtIndex:c]valueForKey:@"price"]floatValue]]];
                            }
                        }
                    }
                }
            }
        }
    }
    else
    {
        NSLog(@"No Same ");
        [(UIButton*)[scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        if ([arrCustomBundle containsObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]])
        {
            [arrCustomBundle removeObjectAtIndex:[arrCustomBundle indexOfObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]]];
            for (int c=0; c<arrCalculate.count; c++)
            {
                NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                if ([[str objectAtIndex:0]isEqualToString:@"checkBundle"]&& [[str objectAtIndex:1]intValue]==sender.tag)
                {
                    [arrCalculate removeObjectAtIndex:c];
                }
            }
        }
    }
    [self calculatePrice];
    
    NSLog(@"%@",arrCustomBundle);
    //    checked.png
    //    uncheck.png
}

#pragma mark ---Bundle Popup Action Methods---

-(void)SelectOptionBundle:(UIButton*)sender
{
    NSLog(@"Option_id----%@",sender.accessibilityLabel);
    NSLog(@"Product_type_id----%ld",(long)sender.tag);
    NSArray *arr=[[arrBundle objectAtIndex:[sender.accessibilityHint intValue]]valueForKey:@"selections"];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    for (int j=0; j<arr.count; j++)
    {
        if ([[[arr objectAtIndex:j]valueForKey:@"selection_id"]intValue]==sender.tag)
        {
            [(UITextField*)[self.view viewWithTag:[sender.accessibilityLabel intValue]]setText:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:j]valueForKey:@"selection_qty"]]];
            [(UILabel*)[self.view viewWithTag:[sender.accessibilityLabel intValue]+999]setText:[[NSString stringWithFormat:@"%@",[[arr objectAtIndex:j]valueForKey:@"name"]]stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
            for (int c=0; c<arrCalculate.count; c++)
            {
                NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                if ([[str objectAtIndex:0]isEqualToString:@"selectBundle"] && [[str objectAtIndex:1]isEqualToString:sender.accessibilityLabel])
                {
                    [strSelect removeObjectAtIndex:c];
                    [arrCalculate removeObjectAtIndex:c];
                }
            }
            [arrCalculate addObject:[NSString stringWithFormat:@"selectBundle,%@,%f",sender.accessibilityLabel,[[[arr objectAtIndex:j]valueForKey:@"price"]floatValue]*[[(UITextField*)[self.view viewWithTag:[sender.accessibilityLabel intValue]]text]floatValue]]];
            NSString *str=[NSString stringWithFormat:@"bundle_option[%@]=%ld",sender.accessibilityLabel,(long)sender.tag];
            
            [strSelect addObject:str];
            
        }
    }
    
    [self calculatePrice];
    if (heightBundleView!=0)
    {
        
        bundleOptionView.frame=CGRectMake(bundleOptionView.frame.origin.x, bundleOptionView.frame.origin.y, bundleOptionView.frame.size.width, heightBundleView);
        Framen=bundleOptionView.frame;
        [self setDeliveryView:deliveryOptionView.frame];
        heightBundleView=0;
    }
    NSString *strTag=[NSString stringWithFormat:@"%@",sender.accessibilityLabel];
    for (int n=0; n<strSelection.count; n++)
    {
        NSArray *arrSelect= [[strSelection objectAtIndex:n]componentsSeparatedByString:@","];
        if ([[arrSelect objectAtIndex:1]isEqualToString:strTag])
        {
            [strSelection removeObjectAtIndex:n];
        }
    }
    
    [strSelection addObject:[NSString stringWithFormat:@"%ld,%@",(long)sender.tag,sender.accessibilityLabel]];
    
    [selectView removeFromSuperview];
}


#pragma mark ---Custom Views Method---

-(UIView*)CheckboxView:(CGRect)frame1  dict:(NSDictionary*)dict
{
    if ([[dict valueForKey:@"additional_fields"]count]!=0)
    {
        NSArray *arrAdditional=[dict valueForKey:@"additional_fields"];
        UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,arrAdditional.count*35+40)];
        [customOptions addSubview:checkView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        [title setText:[dict valueForKey:@"title"]];
        [title setTextColor:model.secondaryColor];
        [title setFont:[UIFont boldSystemFontOfSize:14.0]];
        [title TransformAlignLabel];
        [checkView addSubview:title];
        
        int y=title.frame.origin.y+title.frame.size.height;
        
        UIView *viewColored=[[UIView alloc]initWithFrame:CGRectMake(0, y+5, checkView.frame.size.width, arrAdditional.count*35)];
        [viewColored setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [checkView addSubview:viewColored];
        
        y=5;
        
        for (int m=0; m<arrAdditional.count; m++)
        {
            UIButton *checkBox=[[UIButton alloc]initWithFrame:CGRectMake(5, y, 20, 20)];
            [checkBox setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(CheckButton:) forControlEvents:UIControlEventTouchUpInside];
            checkBox.accessibilityLabel = [dict valueForKey:@"option_id"];
            checkBox.tag=[[[arrAdditional objectAtIndex:m]valueForKey:@"option_type_id"]intValue];
            [checkBox TransformButton];
            
            [viewColored addSubview:checkBox];
            
            UILabel *titleField=[[UILabel alloc]initWithFrame:CGRectMake(35, y-5, 100, 30)];
            [titleField setText:[NSString stringWithFormat:@"%@ + %@",[[arrAdditional objectAtIndex:m]valueForKey:@"title"],[[arrAdditional objectAtIndex:m]valueForKey:@"price"]]];
            [titleField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [titleField setFont:[UIFont boldSystemFontOfSize:14.0]];
            [viewColored addSubview:titleField];
            [titleField TransformAlignLabel];
            
            y=y+35;
        }
        
        customOptions.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, checkView.frame.size.height+frame1.size.height+10);
    }
    return customOptions;
}

-(UIView*)TextfieldView:(CGRect)frame1  dict:(NSDictionary*)dict
{
    strField=[dict valueForKey:@"option_id"];
    UIView *textfieldView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,75)];
    
    [customOptions addSubview:textfieldView];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [title setText:[NSString stringWithFormat:@"%@ + %@",[dict valueForKey:@"title"],[dict valueForKey:@"price"]]];
    [title setTextColor:model.secondaryColor];
    [title setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self LabelBreak2forOptions:title];
    [title TransformAlignLabel];
    [textfieldView addSubview:title];
    
    int y=title.frame.origin.y+title.frame.size.height+2;
    
    UIView *textFieldBorder=[[UIView alloc]initWithFrame:CGRectMake(0, y, textfieldView.frame.size.width, 40)];
    [self setBorderView:textFieldBorder];
    [textfieldView addSubview:textFieldBorder];
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0, y, textfieldView.frame.size.width, 40)];
    [textField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    textField.backgroundColor=[UIColor whiteColor];
    [textField setFont:[UIFont systemFontOfSize:14.0]];
    textField.tag=[strField intValue];
    textField.delegate=self;
    [textField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    [textField TransformTextField];
    
    [textfieldView addSubview:textField];
    customOptions.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, textfieldView.frame.size.height+frame1.size.height+10);
    
    return customOptions;
}

-(UIView*)DateTimeView:(CGRect)frame1  dict:(NSDictionary*)dict
{
    UIView *dateTimeView1=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,80)];
    [customOptions addSubview:dateTimeView1];
    
    dateOptionid=[dict valueForKey:@"option_id"];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [title setText:[dict valueForKey:@"title"]];
    [title setTextColor:model.secondaryColor];
    [title setFont:[UIFont boldSystemFontOfSize:14.0]];
    [title TransformAlignLabel];
    [dateTimeView1 addSubview:title];
    
    int y=title.frame.origin.y+title.frame.size.height;
    
    UIView *textFieldBorder=[[UIView alloc]initWithFrame:CGRectMake(0, y, dateTimeView1.frame.size.width, 40)];
    
    [self setBorderView:textFieldBorder];
    [dateTimeView1 addSubview:textFieldBorder];
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0, y, dateTimeView1.frame.size.width, 40)];
    [textField setTextColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]];
    [textField setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]];
    [textField setPlaceholder:AMLocalizedString(@"tSelectDateTime", nil)];
    [textField setFont:[UIFont systemFontOfSize:14.0]];
    [textField setTag:[dateOptionid intValue]];
    [textField TransformTextField];
    [dateTimeView1 addSubview:textField];
    
    UIButton *buttonDateTime=[[UIButton alloc]initWithFrame:CGRectMake(0, y, dateTimeView1.frame.size.width, 40)];
    [buttonDateTime addTarget:self action:@selector(DateTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    [dateTimeView1 addSubview:buttonDateTime];
    
    customOptions.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, dateTimeView1.frame.size.height+frame1.size.height+10);
    
    return customOptions;
}

-(UIView*)MultipleView:(CGRect)frame1  dict:(NSDictionary*)dict
{
    if ([[dict valueForKey:@"additional_fields"]count]!=0)
    {
        NSArray *arrAdditional=[dict valueForKey:@"additional_fields"];
        UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,arrAdditional.count*35+40)];
        [customOptions addSubview:checkView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        [title setText:[dict valueForKey:@"title"]];
        [title setTextColor:model.secondaryColor];
        [title setFont:[UIFont boldSystemFontOfSize:14.0]];
        [title TransformAlignLabel];
        [checkView addSubview:title];
        
        int y=title.frame.origin.y+title.frame.size.height+5;
        
        UIView *viewColored=[[UIView alloc]initWithFrame:CGRectMake(0, y+5, checkView.frame.size.width, arrAdditional.count*35)];
        [viewColored setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [checkView addSubview:viewColored];
        
        y=5;
        
        for (int m=0; m<arrAdditional.count; m++)
        {
            UIButton *checkBox=[[UIButton alloc]initWithFrame:CGRectMake(5, y, 20, 20)];
            [checkBox setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(CheckButton:) forControlEvents:UIControlEventTouchUpInside];
            checkBox.accessibilityLabel = [dict valueForKey:@"option_id"];
            checkBox.tag=[[[arrAdditional objectAtIndex:m]valueForKey:@"option_type_id"]intValue];
            [checkBox TransformButton];
            [viewColored addSubview:checkBox];
            
            UILabel *titleField=[[UILabel alloc]initWithFrame:CGRectMake(35, y-5, 200, 30)];
            [titleField setText:[NSString stringWithFormat:@"%@ + %@",[[arrAdditional objectAtIndex:m]valueForKey:@"title"],[[arrAdditional objectAtIndex:m]valueForKey:@"price"]]];
            [titleField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [titleField setFont:[UIFont boldSystemFontOfSize:14.0]];
            [titleField TransformAlignLabel];
            [viewColored addSubview:titleField];
            y=y+35;
        }
        
        customOptions.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, checkView.frame.size.height+frame1.size.height+10);
    }
    return customOptions;
}

-(UIView*)RadioButtonView:(CGRect)frame1  dict:(NSDictionary*)dict
{
    dictRadio=dict;
    if ([[dict valueForKey:@"additional_fields"]count]!=0)
    {
        NSArray *arrAdditional=[dict valueForKey:@"additional_fields"];
        UIView *checkView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,arrAdditional.count*35+40)];
        [customOptions addSubview:checkView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        [title setText:[dict valueForKey:@"title"]];
        [title setTextColor:model.secondaryColor];
        [title setFont:[UIFont boldSystemFontOfSize:14.0]];
        [title TransformAlignLabel];
        [checkView addSubview:title];
        
        int y=title.frame.origin.y+title.frame.size.height;
        
        UIView *viewColored=[[UIView alloc]initWithFrame:CGRectMake(0, y+5, checkView.frame.size.width, arrAdditional.count*35)];
        [viewColored setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [checkView addSubview:viewColored];
        
        y=5;
        
        for (int m=0; m<arrAdditional.count; m++)
        {
            UIButton *checkBox=[[UIButton alloc]initWithFrame:CGRectMake(5, y, 20, 20)];
            [checkBox setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(radioButton:) forControlEvents:UIControlEventTouchUpInside];
            checkBox.accessibilityLabel = [dict valueForKey:@"option_id"];
            checkBox.tag=[[[arrAdditional objectAtIndex:m]valueForKey:@"option_type_id"]intValue]+99;
            
            [viewColored addSubview:checkBox];
            
            UILabel *titleField=[[UILabel alloc]initWithFrame:CGRectMake(35, y-5, 200, 30)];
            [titleField setText:[NSString stringWithFormat:@"%@ + %@",[[arrAdditional objectAtIndex:m]valueForKey:@"title"],[[arrAdditional objectAtIndex:m]valueForKey:@"price"]]];
            [titleField setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [titleField setFont:[UIFont boldSystemFontOfSize:14.0]];
            [titleField TransformAlignLabel];
            [viewColored addSubview:titleField];
            y=y+35;
        }
        
        customOptions.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, checkView.frame.size.height+frame1.size.height+10);
    }
    return customOptions;
}

-(UIView*)TextView:(CGRect)frame1  dict:(NSDictionary*)dict
{
    strView=[dict valueForKey:@"option_id"];
    
    UIView *textfieldView=[[UIView alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,100)];
    [customOptions addSubview:textfieldView];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [title setText:[NSString stringWithFormat:@"%@ + %@",[dict valueForKey:@"title"],[dict valueForKey:@"price"]]];
    [title setTextColor:model.secondaryColor];
    [title setFont:[UIFont boldSystemFontOfSize:14.0]];
    [title TransformAlignLabel];
    [textfieldView addSubview:title];
    
    int y=title.frame.origin.y+title.frame.size.height;
    
    UIView *textFieldBorder=[[UIView alloc]initWithFrame:CGRectMake(0, y, textfieldView.frame.size.width, 60)];
    [self setBorderView:textFieldBorder];
    [textfieldView addSubview:textFieldBorder];
    
    UITextView *textView1=[[UITextView alloc]initWithFrame:CGRectMake(4, y+2, textfieldView.frame.size.width-8, 56)];
    [textView1 setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [textView1 setFont:[UIFont systemFontOfSize:14.0]];
    textView1.delegate=self;
    textView1.tag=[strView intValue];
    [textView1 TransformTextView];
    [textfieldView addSubview:textView1];
    
    customOptions.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, textfieldView.frame.size.height+frame1.size.height+10);
    
    return customOptions;
}

-(UIView*)DropDownView:(CGRect)frame1  dict:(NSDictionary*)dict indexNo:(int)v
{
    //    dictDropDown=dict;[arrSimpleOptions objectAtIndex:j]
    
    UILabel *labelButton1=[[UILabel alloc]initWithFrame:CGRectMake(10,frame1.size.height, frame1.size.width-20 ,30)];
    [labelButton1 setText:[NSString stringWithFormat:@"%@",[dict valueForKey:@"title"]]];
    labelButton1.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    [labelButton1 setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    [self setBorderLabelGray:labelButton1];
    [labelButton1 setFont:[UIFont systemFontOfSize:13.0]];
    labelButton1.textAlignment=NSTextAlignmentCenter;
    labelButton1.tag=[[dict valueForKey:@"option_id"]intValue]+666;
    [labelButton1 TransformLabel];
    [customOptions addSubview:labelButton1];
    
    UIImageView *downArrow=[[UIImageView alloc]initWithFrame:CGRectMake(245, frame1.size.height+10, 16, 12)];
    [downArrow setImage:[UIImage imageNamed:@"down_icon.png"]];
    [customOptions addSubview:downArrow];
    
    UIButton *buttonOption1=[[UIButton alloc]initWithFrame:CGRectMake(12, frame1.size.height, 257, 30)];
    [buttonOption1 addTarget:self action:@selector(DropDown:) forControlEvents:UIControlEventTouchUpInside];
    buttonOption1.tag=v;
    [customOptions addSubview:buttonOption1];
    
    customOptions.frame=CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, buttonOption1.frame.size.height+frame1.size.height+10);
    return customOptions;
}

#pragma mark ---Custom Options Methods---

-(void)CheckButton:(UIButton*)sender
{
    NSLog(@"Option_id----%@",sender.accessibilityLabel);
    NSLog(@"Product_type_id----%ld",(long)sender.tag);
    UIImage *img1=[UIImage imageNamed:@"uncheck.png"];
    UIImage *img2=sender.imageView.image;
    NSData *imgdata1 = UIImagePNGRepresentation(img1);
    NSData *imgdata2 = UIImagePNGRepresentation(img2);
    
    if ([imgdata1 isEqualToData:imgdata2])
    {
        NSLog(@"Same Image");
        [(UIButton*)[scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"blue_tick.png"] forState:UIControlStateNormal];
        if (![arrCustom containsObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]])
        {
            [arrCustom addObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]];
            //            set price
            for (int j=0; j<arrSimpleOptions.count; j++)
            {
                if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"checkbox"])
                {
                    if ([[arrSimpleOptions objectAtIndex:j]count]!=0)
                    {
                        NSArray *arrAdditional=[[arrSimpleOptions objectAtIndex:j] valueForKey:@"additional_fields"];
                        for (int c=0; c<arrAdditional.count; c++)
                        {
                            if ([[[arrAdditional objectAtIndex:c]valueForKey:@"option_type_id"]intValue]==sender.tag)
                            {
                                [arrCalculate addObject:[NSString stringWithFormat:@"check,%ld,%f",(long)sender.tag,[[[arrAdditional objectAtIndex:c]valueForKey:@"price"]floatValue]]];
                            }
                        }
                    }
                }
                else if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"multiple"])
                {
                    if ([[arrSimpleOptions objectAtIndex:j]count]!=0)
                    {
                        NSArray *arrAdditional=[[arrSimpleOptions objectAtIndex:j] valueForKey:@"additional_fields"];
                        for (int c=0; c<arrAdditional.count; c++)
                        {
                            if ([[[arrAdditional objectAtIndex:c]valueForKey:@"option_type_id"]intValue]==sender.tag)
                            {
                                [arrCalculate addObject:[NSString stringWithFormat:@"multiple,%ld,%f",(long)sender.tag,[[[arrAdditional objectAtIndex:c]valueForKey:@"price"]floatValue]]];
                            }
                        }
                    }
                }
            }
        }
    }
    else
    {
        NSLog(@"No Same ");
        [(UIButton*)[scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        if ([arrCustom containsObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]])
        {
            [arrCustom removeObjectAtIndex:[arrCustom indexOfObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]]];
            
            for (int c=0; c<arrCalculate.count; c++)
            {
                NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                if ([[str objectAtIndex:0]isEqualToString:@"check"]&& [[str objectAtIndex:1]intValue]==sender.tag)
                {
                    [arrCalculate removeObjectAtIndex:c];
                }
                else if ([[str objectAtIndex:0]isEqualToString:@"multiple"]&& [[str objectAtIndex:1]intValue]==sender.tag)
                {
                    [arrCalculate removeObjectAtIndex:c];
                }
                
            }
        }
    }
    
    [self calculatePrice];
    
    NSLog(@"%@",arrCustom);
    //    blue_tick.png
    //    uncheck.png
}

-(void)CheckButtonDownloadable:(UIButton*)sender
{
    NSLog(@"Option_id----%@",sender.accessibilityLabel);
    NSLog(@"Product_type_id----%ld",(long)sender.tag);
    UIImage *img1=[UIImage imageNamed:@"uncheck.png"];
    UIImage *img2=sender.imageView.image;
    NSData *imgdata1 = UIImagePNGRepresentation(img1);
    NSData *imgdata2 = UIImagePNGRepresentation(img2);
    
    if ([imgdata1 isEqualToData:imgdata2])
    {
        NSLog(@"Same Image");
        [(UIButton*)[scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"blue_tick.png"] forState:UIControlStateNormal];
        if (![arrLinkOption containsObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]])
        {
            [arrLinkOption addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            
            //            set price
            
            NSArray *arrAdditional=[[arrDownloadableLinks valueForKey:@"links"] valueForKey:@"rows"];
            
            for (int c=0; c<arrAdditional.count; c++)
            {
                if ([[[arrAdditional objectAtIndex:c]valueForKey:@"id"]intValue]==sender.tag)
                {
                    [arrCalculate addObject:[NSString stringWithFormat:@"checkdown,%ld,%f",(long)sender.tag,[[[arrAdditional objectAtIndex:c]valueForKey:@"link_price"]floatValue]]];
                }
            }
        }
    }
    else
    {
        NSLog(@"No Same ");
        [(UIButton*)[scrollView viewWithTag:sender.tag]setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        if ([arrLinkOption containsObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]])
        {
            [arrLinkOption removeObjectAtIndex:[arrLinkOption indexOfObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]]];
            
            for (int c=0; c<arrCalculate.count; c++)
            {
                NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                if ([[str objectAtIndex:0]isEqualToString:@"checkdown"]&& [[str objectAtIndex:1]intValue]==sender.tag)
                {
                    [arrCalculate removeObjectAtIndex:c];
                }
            }
            
        }
    }
    [self calculatePrice];
    NSLog(@"%@",arrLinkOption);
    //    checked.png
    //    uncheck.png
}


-(void)DateTimePicker:(UIButton*)sender// Date view only
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, (self.view.frame.size.height)-20)];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    dateTimeView.frame=CGRectMake(self.scrollView.frame.origin.x+20, 180, self.scrollView.frame.size.width-40,dateTimeView.frame.size.height);
    [pickerDate setDatePickerMode:UIDatePickerModeDate];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EE, d LLLL yyyy"];
    NSString *displayDate= [dateFormatter stringFromDate:pickerDate.date];
    [LabelDateOrtime setText:[NSString stringWithFormat:@"%@",displayDate]];
    [LabelDateOrtime TransformAlignLabel];
    [pickerDate TransformPicker];
    [doneButton TransformButton];
    [self setBorderView2:dateTimeView];
    [self.view addSubview:coverView];
    [coverView addSubview:dateTimeView];
}

//Done picker button

- (IBAction)DoneButton:(UIButton*)sender
{
    if (sender.tag==88)
    {
        NSString *str=[NSString stringWithFormat:@"%@",pickerDate.date];
        NSLog(@"%@",str);
        [coverView removeFromSuperview];
        doneButton.tag=89;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, (self.view.frame.size.height)-20)];
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        dateTimeView.frame=CGRectMake(self.scrollView.frame.origin.x+20, 180, self.scrollView.frame.size.width-40,dateTimeView.frame.size.height);
        [pickerDate setDatePickerMode:UIDatePickerModeTime];
        [LabelDateOrtime setText:AMLocalizedString(@"tSetTime", nil)];
        [self setBorderView2:dateTimeView];
        [self.view addSubview:coverView];
        [coverView addSubview:dateTimeView];
        pickerDate.tag=77;
    }
    else
    {
        NSDate *myDate = pickerDate.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"d-MM-yyyy"];
        NSString *strAppend =[NSString stringWithFormat:@"%@ : %@ ",AMLocalizedString(@"tDate", nil), [dateFormat stringFromDate:myDate]];
        [dateFormat setDateFormat:@"hh:mm aa"];
        strAppend=[strAppend stringByAppendingString:[NSString stringWithFormat:@"%@ : %@ ",AMLocalizedString(@"tTime", nil),[dateFormat stringFromDate:myDate]]];
        NSLog(@"%@",strAppend);
        [(UITextField*)[scrollView viewWithTag:[dateOptionid intValue]]setText:strAppend];
        strDate=[[NSString alloc]init];
        [dateFormat setDateFormat:@"yyyy"];
        strDate=[strDate stringByAppendingString:[NSString stringWithFormat:@"options[%@][year]=%@&",dateOptionid,[dateFormat stringFromDate:myDate]]];
        [dateFormat setDateFormat:@"MM"];
        strDate=[strDate stringByAppendingString:[NSString stringWithFormat:@"options[%@][month]=%@&",dateOptionid,[dateFormat stringFromDate:myDate]]];
        [dateFormat setDateFormat:@"d"];
        strDate=[strDate stringByAppendingString:[NSString stringWithFormat:@"options[%@][day]=%@&",dateOptionid,[dateFormat stringFromDate:myDate]]];
        [dateFormat setDateFormat:@"hh"];
        strDate=[strDate stringByAppendingString:[NSString stringWithFormat:@"options[%@][hour]=%@&",dateOptionid,[dateFormat stringFromDate:myDate]]];
        [dateFormat setDateFormat:@"mm"];
        strDate=[strDate stringByAppendingString:[NSString stringWithFormat:@"options[%@][minute]=%@&",dateOptionid,[dateFormat stringFromDate:myDate]]];
        [dateFormat setDateFormat:@"aa"];
        strDate= [strDate stringByAppendingString:[NSString stringWithFormat:@"options[%@][day_part]=%@",dateOptionid,[dateFormat stringFromDate:myDate]]];
        NSLog(@"%@",strDate);
        
        [coverView removeFromSuperview];
        doneButton.tag=88;
        pickerDate.tag=76;
    }
    
}

- (IBAction)pickerSelect:(UIDatePicker*)sender
{
    if (sender.tag==77)
    {
        NSLog(@"--------Setting time-------");
    }
    else
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"EE, d LLLL yyyy"];
        NSString *displayDate= [dateFormatter stringFromDate:pickerDate.date];
        [LabelDateOrtime setText:[NSString stringWithFormat:@"%@",displayDate]];
    }
}


-(void)radioButton:(UIButton*)sender
{
    NSLog(@"Option_id----%@",sender.accessibilityLabel);
    NSLog(@"Product_type_id----%ld",(long)sender.tag);
    long h=sender.tag-99;
    if ([[dictRadio valueForKey:@"additional_fields"]count]!=0)
    {
        NSArray *arrAdditional=[dictRadio valueForKey:@"additional_fields"];
        for (int g=0; g<arrAdditional.count; g++)
        {
            if ([[[arrAdditional objectAtIndex:g]valueForKey:@"option_type_id"]intValue]==h)
            {
                [(UIButton*)[scrollView viewWithTag:[[[arrAdditional objectAtIndex:g]valueForKey:@"option_type_id"]intValue]+99] setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
                strRadio=[NSString stringWithFormat:@"options[%@]=%@",[[arrAdditional objectAtIndex:g]valueForKey:@"option_id"],[[arrAdditional objectAtIndex:g]valueForKey:@"option_type_id"]];
                
                //                to calculate product price
                
                for (int c=0; c<arrCalculate.count; c++)
                {
                    NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                    if ([[str objectAtIndex:0]isEqualToString:@"radio"])
                    {
                        [arrCalculate removeObjectAtIndex:c];
                    }
                }
                [arrCalculate addObject:[NSString stringWithFormat:@"radio,%ld,%f",(long)sender.tag,[[[arrAdditional objectAtIndex:g]valueForKey:@"price"]floatValue]]];
                
            }
            else
            {
                [(UIButton*)[scrollView viewWithTag:[[[arrAdditional objectAtIndex:g]valueForKey:@"option_type_id"]intValue]+99]setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
            }
        }
    }
    [self calculatePrice];
    NSLog(@"%@",strRadio);
    //    btn_radio-selected.png
    //    btn_radio.png
}

-(void)DropDown:(UIButton*)sender
{
    if ([[[arrSimpleOptions objectAtIndex:sender.tag] valueForKey:@"additional_fields"]count]!=0)
    {
        NSArray *arrAdditional=[[arrSimpleOptions objectAtIndex:sender.tag] valueForKey:@"additional_fields"];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, (self.view.frame.size.height)-20)];
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        selectionView.frame=CGRectMake(self.scrollView.frame.origin.x+40, 240, 240, 50+arrAdditional.count*30);
        
        for (UIView*  view in selectionView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:[UILabel class]])
            {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:[UIImageView class]])
            {
                [view removeFromSuperview];
            }
        }
        
        UILabel *selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(1, 1, 238, 37)];
        selectLabel.textAlignment=NSTextAlignmentCenter;
        selectLabel.text=AMLocalizedString(@"tSelect", nil);
        [selectLabel setFont:[UIFont systemFontOfSize:17.0]];
        [selectLabel setTextColor:[UIColor whiteColor]];
        [selectLabel setBackgroundColor:model.secondaryColor];
        [selectLabel TransformLabel];
        [selectionView addSubview:selectLabel];
        
        [self setBorderView2:selectionView];
        [self setBorderLabel:selectLabel];
        [self.view addSubview:coverView];
        [coverView addSubview:selectionView];
        
        int y=50;
        for (int o=0; o<arrAdditional.count;o++)
        {
            UIImageView *radioImage=[[UIImageView alloc]initWithFrame:CGRectMake(8, y, 20, 20)];
            [radioImage setImage:[UIImage imageNamed:@"btn_radio.png"]];
            radioImage.tag=[[[arrAdditional objectAtIndex:o]valueForKey:@"option_type_id"]intValue];
            [selectionView addSubview:radioImage];
            
            UILabel *options=[[UILabel alloc]initWithFrame:CGRectMake(36, y, 191, 21)];
            [options setFont:[UIFont systemFontOfSize:13.0]];
            [options setTextColor:model.secondaryColor];
            [options setText:[NSString stringWithFormat:@"%@ + %@",[[arrAdditional objectAtIndex:o]valueForKey:@"title"],[[arrAdditional objectAtIndex:o]valueForKey:@"price"]]];
            [options TransformAlignLabel];
            [selectionView addSubview:options];
            
            UIButton *radioButton=[[UIButton alloc]initWithFrame:CGRectMake(8, y, 230, 20)];
            [radioButton addTarget:self action:@selector(SelectedDropDown:) forControlEvents:UIControlEventTouchUpInside];
            radioButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)sender.tag ];
            radioButton.accessibilityLabel = [[arrSimpleOptions objectAtIndex:sender.tag] valueForKey:@"option_id"];
            radioButton.tag=[[[arrAdditional objectAtIndex:o]valueForKey:@"option_type_id"]intValue];
            [selectionView addSubview:radioButton];
            y=y+30;
        }
    }
}
#pragma mark ---PopUp Method---

-(void)SelectedDropDown:(UIButton*)sender
{
    NSLog(@"Option_id----%@",sender.accessibilityLabel);
    NSLog(@"Product_type_id----%ld",(long)sender.tag);
    int vb=[sender.accessibilityHint intValue];
    if ([[[arrSimpleOptions objectAtIndex:vb] valueForKey:@"additional_fields"]count]!=0)
    {
        NSArray *arrAdditional=[[arrSimpleOptions objectAtIndex:vb] valueForKey:@"additional_fields"];
        for (int g=0; g<arrAdditional.count; g++)
        {
            if ([[[arrAdditional objectAtIndex:g]valueForKey:@"option_type_id"]intValue]==sender.tag)
            {
                NSLog(@"%d---%@---%@",[sender.accessibilityLabel intValue]+666,[[arrSimpleOptions objectAtIndex:vb] valueForKey:@"title"],[[[arrAdditional objectAtIndex:g]valueForKey:@"title"]uppercaseString]);
                [(UILabel*)[self.view viewWithTag:[sender.accessibilityLabel intValue]+666]setText:[NSString stringWithFormat:@"%@ : %@",[[arrSimpleOptions objectAtIndex:vb] valueForKey:@"title"],[[[arrAdditional objectAtIndex:g]valueForKey:@"title"]uppercaseString]]];
                
                [(UIImageView*)[selectionView viewWithTag:[[[arrAdditional objectAtIndex:g]valueForKey:@"option_type_id"]intValue]]setImage:[UIImage imageNamed:@"btn_radio-selected.png"]];
                
                //create array for different dropdowns
                
                for (int h=0; h<strDropDown.count; h++)
                {
                    NSArray *arr9=[[strDropDown objectAtIndex:h]componentsSeparatedByString:@","];
                    
                    if ([[arr9 objectAtIndex:0]isEqualToString:sender.accessibilityLabel])
                    {
                        [strDropDown removeObjectAtIndex:h];
                    }
                }
                
                [strDropDown addObject:[NSString stringWithFormat:@"%@,%ld",sender.accessibilityLabel,(long)sender.tag]];
                
                //                to calculate product price
                
                for (int c=0; c<arrCalculate.count; c++)
                {
                    NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                    if ([[str objectAtIndex:0]isEqualToString:@"drop"] && [[str objectAtIndex:1] intValue]==[sender.accessibilityLabel intValue] )
                    {
                        [arrCalculate removeObjectAtIndex:c];
                    }
                }
                [arrCalculate addObject:[NSString stringWithFormat:@"drop,%@,%f",sender.accessibilityLabel,[[[arrAdditional objectAtIndex:g]valueForKey:@"price"]floatValue]]];
                
            }
            else
            {
                [(UIImageView*)[selectionView viewWithTag:[[[arrAdditional objectAtIndex:g]valueForKey:@"option_type_id"]intValue]]setImage:[UIImage imageNamed:@"btn_radio.png"]];
            }
        }
    }
    [self calculatePrice];
    NSLog(@"%@",strDropDown);
    
    [coverView removeFromSuperview];
    
}

#pragma mark ---Options methods---

-(void)OptionButtons:(UIButton*)sender
{
    NSString *str=[NSString stringWithFormat:@"%ld",(long)[sender tag]];
    NSLog(@"%@",[[dictOptions valueForKey:str]valueForKey:@"options"]);
    NSMutableArray * arrSubCategory=[[NSMutableArray alloc]init];
    
    if ([[[dictOptions valueForKey:str]valueForKey:@"options"]count]!=0)
    {
        NSArray * arr = [[dictOptions valueForKey:str]valueForKey:@"options"];
        NSLog(@"%@",arr);
        NSString *str4=[NSString stringWithFormat:@"%ld",(long)[sender tag]-1];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:str4]count]!=0)
        {
            NSDictionary *arr2=[[NSUserDefaults standardUserDefaults]valueForKey:@"1"];
            for (int m=0; m<[[arr2 valueForKey:@"products"]count]; m++)
            {
                for (int n=0; n<arr.count; n++)
                {
                    if ([[[arr objectAtIndex:n]valueForKey:@"products"]containsObject:[[arr2 valueForKey:@"products"]objectAtIndex:m]])
                    {
                        NSLog(@"%@",[[arr objectAtIndex:n]valueForKey:@"products"]);
                        [arrSubCategory addObject:[arr objectAtIndex:n]];
                        NSLog(@"%@",arrSubCategory);
                    }
                }
            }
        }
        else
        {
            arrSubCategory=[[dictOptions valueForKey:str]valueForKey:@"options"];
        }
        
        for (UIView*  view in selectionView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:[UILabel class]])
            {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:[UIImageView class]])
            {
                [view removeFromSuperview];
            }
        }
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, (self.view.frame.size.height)-20)];
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        selectionView.frame=CGRectMake(self.scrollView.frame.origin.x+40, 240, 240, 50+arrSubCategory.count*30);
        
        UILabel *selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(1, 1, 238, 37)];
        selectLabel.textAlignment=NSTextAlignmentCenter;
        selectLabel.text=AMLocalizedString(@"tSelect", nil);
        [selectLabel setFont:[UIFont systemFontOfSize:17.0]];
        [selectLabel setTextColor:[UIColor whiteColor]];
        [selectLabel setBackgroundColor:model.secondaryColor];
        [selectLabel TransformLabel];
        [selectionView addSubview:selectLabel];
        
        [self setBorderView2:selectionView];
        [self setBorderLabel:selectLabel];
        [self.view addSubview:coverView];
        [coverView addSubview:selectionView];
        
        int y=50;
        for (int o=0; o<arrSubCategory.count;o++)
        {
            UIImageView *radioImage=[[UIImageView alloc]initWithFrame:CGRectMake(8, y, 20, 20)];
            [radioImage setImage:[UIImage imageNamed:@"btn_radio.png"]];
            [selectionView addSubview:radioImage];
            
            UILabel *options=[[UILabel alloc]initWithFrame:CGRectMake(36, y, 191, 21)];
            [options setFont:[UIFont systemFontOfSize:13.0]];
            [options setTextColor:model.secondaryColor];
            [options setText:[[arrSubCategory objectAtIndex:o]valueForKey:@"label"]];
            [options TransformAlignLabel];
            [selectionView addSubview:options];
            
            UIButton *radioButton=[[UIButton alloc]initWithFrame:CGRectMake(8, y, 240, 20)];
            [radioButton addTarget:self action:@selector(SelectedOptions:) forControlEvents:UIControlEventTouchUpInside];
            radioButton.tag=[[[arrSubCategory objectAtIndex:o]valueForKey:@"id"]intValue];
            [selectionView addSubview:radioButton];
            y=y+30;
        }
        opt=(int)[sender tag];
        
    }
}

#pragma mark ---Selected Option Method---

-(void)SelectedOptions:(UIButton*)sender
{
    NSString *str1=[NSString stringWithFormat:@"%d",opt];
    if ([[[dictOptions valueForKey:str1]valueForKey:@"options"]count]!=0)
    {
        NSArray *arrOptions=[[dictOptions valueForKey:str1]valueForKey:@"options"];
        for (int r=0; r<arrOptions.count; r++)
        {
            if ([[[arrOptions objectAtIndex:r]valueForKey:@"id"]intValue]==[sender tag])
            {
                [(UILabel*)[self.view viewWithTag:opt]setText:[NSString stringWithFormat:@"%@: %@",[[dictOptions valueForKey:str1]valueForKey:@"label"],[[arrOptions objectAtIndex:r]valueForKey:@"label"]]];
                NSDictionary *arrdict=[arrOptions objectAtIndex:r];
                
                NSString *sa=[NSString stringWithFormat:@"super_attribute[%@]=%@",[[dictOptions valueForKey:str1]valueForKey:@"id"],[arrdict valueForKey:@"id"]];
                
                [arrOptionRequest replaceObjectAtIndex:opt-1 withObject:sa ];
                
                NSLog(@"%@ %@",sa,arrOptionRequest);
                
                [[NSUserDefaults standardUserDefaults]setValue:arrdict forKey:str1];
            }
        }
    }
    NSLog(@"%ld",(long)[sender tag]);
    [coverView removeFromSuperview];
    opt=opt+1;
    NSString *str=[NSString stringWithFormat:@"%d",opt];
    if ([dictOptions valueForKey:str]!=nil)
    {
        for (UIView*  view in optionsView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                if (view.tag>=opt)
                {
                    [view removeFromSuperview];
                }
                
            }
            if ([view isKindOfClass:[UILabel class]])
            {
                if (view.tag>=opt)
                {
                    [view removeFromSuperview];
                }
            }
            if ([view isKindOfClass:[UIImageView class]])
            {
                if (view.tag>=opt)
                {
                    [view removeFromSuperview];
                }
            }
        }
        float h=opt*40+40;
        
        UILabel *labelButton1=[[UILabel alloc]initWithFrame:CGRectMake(12, h-40, 257, 30)];
        [labelButton1 setText:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"tSelect", nil) ,[[dictOptions valueForKey:str]valueForKey:@"label"]]];
        labelButton1.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        [labelButton1 setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [self setBorderLabelGray:labelButton1];
        [labelButton1 setFont:[UIFont systemFontOfSize:13.0]];
        labelButton1.tag=opt;
        labelButton1.textAlignment=NSTextAlignmentCenter;
        [labelButton1 TransformLabel];
        [optionsView addSubview:labelButton1];
        
        UIImageView *downArrow=[[UIImageView alloc]initWithFrame:CGRectMake(245, h-30, 16, 12)];
        downArrow.tag=opt;
        [downArrow setImage:[UIImage imageNamed:@"down_icon.png"]];
        [optionsView addSubview:downArrow];
        
        UIButton *buttonOption1=[[UIButton alloc]initWithFrame:CGRectMake(12, h-40, 257, 30)];
        [buttonOption1 addTarget:self action:@selector(OptionButtons:) forControlEvents:UIControlEventTouchUpInside];
        buttonOption1.tag=opt;
        
        optionsView .frame=CGRectMake(20, optionsView.frame.origin.y, optionsView.frame.size.width, opt*40+40);
        [optionsView addSubview:buttonOption1];
        Framen=optionsView.frame;
        
        [self setDeliveryView:deliveryOptionView.frame];
    }
    else
    {
        opt=opt-1;
    }
    
}

#pragma mark ---Calculate Price Method---

-(void)calculatePrice
{
    float r=0.0;
    
    for (int b=0; b<arrCalculate.count; b++)
    {
        NSArray *str=[[arrCalculate objectAtIndex:b]componentsSeparatedByString:@","];
        
        r=[[str objectAtIndex:2]floatValue]+r;
    }
    NSString *strprice=[NSString stringWithFormat:@"%@",[arrProductDetails valueForKey:@"final_price"]];
    strprice=[strprice stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSLog(@"%4f",[strprice floatValue]);
    r=[strprice floatValue]+r;
    productsPrice.text=[NSString stringWithFormat:@"%.2f",r];
}

#pragma mark ---Swipe Gesture---

- (IBAction)imagePreview:(id)sender
{
    if(arrImages.count>0)
    {
    ZoomImageViewController *objViewController = [[ZoomImageViewController alloc]initWithNibName:@"ZoomImageViewController" bundle:nil];
    [self.navigationController pushViewController:objViewController animated:YES];
    
    objViewController = nil;
    }
}

- (IBAction)handleRight:(id)sender
{
    long p=pageControl.currentPage;
    if (p>0)
    {
        indicator.hidden = NO;
        [indicator startAnimating];
        productImages.image = [UIImage imageNamed:@"place_holder.png"];
        [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:p-1] valueForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"place_holder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
            {
                [indicator stopAnimating];
                indicator.hidden = YES;
            }
            NSLog(@"Downloaded");
        }];
//        [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:p-1] valueForKey:@"url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if(image)
//            {
//              [indicator stopAnimating];
//             indicator.hidden = YES;
//            }
//           NSLog(@"Downloaded");
//       }];
       // [productImages sd_setImageWithURL:[[arrImages objectAtIndex:p-1] valueForKey:@"url"]placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        pageControl.currentPage=p-1;
        
    }
}

- (IBAction)handleLeft:(id)sender
{
    long p=pageControl.currentPage;
    if (p<arrImages.count-1)
    {
        [indicator startAnimating];
        indicator.hidden = NO;
        productImages.image = [UIImage imageNamed:@"place_holder.png"];
        [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:p+1] valueForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"place_holder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
            {
                [indicator stopAnimating];
                indicator.hidden = YES;
            }
            
            NSLog(@"Downloaded");
        }];
//                [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:p+1] valueForKey:@"url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    if(image)
//                    {
//                        [indicator stopAnimating];
//                        indicator.hidden = YES;
//                    }
//
//            NSLog(@"Downloaded");
//        }];

       // [productImages sd_setImageWithURL:[[arrImages objectAtIndex:p+1] valueForKey:@"url"]placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        pageControl.currentPage=p+1;
        
    }
}

- (IBAction)pageControl:(id)sender
{
    if (i<arrImages.count)
    {
        [indicator startAnimating];
        indicator.hidden = NO;
        productImages.image = [UIImage imageNamed:@"place_holder.png"];
        [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:i] valueForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"place_holder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
            {
                [indicator stopAnimating];
                indicator.hidden = YES;
            }
            NSLog(@"Downloaded");
        }];
//        [productImages sd_setImageWithURL:[NSURL URLWithString:[[arrImages objectAtIndex:i] valueForKey:@"url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if(image)
//            {
//                [indicator stopAnimating];
//                indicator.hidden = YES;
//            }
//            NSLog(@"Downloaded");
//        }];

       // [productImages sd_setImageWithURL:[[arrImages objectAtIndex:i] valueForKey:@"url"]placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        pageControl.currentPage=i;
        i++;
        if (i==arrImages.count)
        {
            i=0;
        }
    }
}

#pragma mark- Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrRelatedProducts count];
}

- (CollectionCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    //rtl
    [cell.productImage TransformImage];
    [cell.productOff TransformLabel];
    [cell.productName TransformLabel];
    [cell.productPrice TransformLabel];
    [cell.orderImg TransformButton];
    
    
    [cell.productImage sd_setImageWithURL:[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"img"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    
    //        cell.borderImage.layer.cornerRadius=4;
    //        cell.borderImage.layer.borderWidth=1;
    //        cell.borderImage.layer.borderColor = [[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0] CGColor];
    if (![[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
    {
        cell.orderImg.hidden=NO;
        [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff", nil)] forState:UIControlStateNormal];
        
    }
    else
    {
        cell.orderImg.hidden=YES;
    }
    
    cell.productName.text=[[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if ([[[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
    {
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",model.currencySymbo,[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
        
        cell.productOff.attributedText=attrText;
        
        cell.productOff.hidden=NO;
    }
    else
    {
        cell.productOff.hidden=YES;
    }
    cell.productPrice.textColor=model.greenClr;
    cell.productPrice.text=[NSString stringWithFormat:@"%@%@",model.currencySymbo,[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
    return cell;
    
}

#pragma mark- Collection View Delegate

-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
    
    objViewController.strProdId=[[arrRelatedProducts objectAtIndex:indexPath.row]valueForKey:@"id"];
    [self.navigationController pushViewController:objViewController animated:YES];
    
    objViewController = nil;
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

#pragma mark ---Helper methods---

//-(float)webviewHeight : (UIWebView*)web1
//{
//[[NSURLCache sharedURLCache] removeAllCachedResponses];
//
//CGRect frame = web1.frame;
//frame.size.height = 1;
//web1.frame = frame;
//
//CGSize fittingSize = [web1 sizeThatFits:CGSizeZero];
//frame.size = fittingSize;
//web1.frame = frame;
//
//    NSLog(@"%f",_descriptionWEB.scrollView.contentSize.height);
//
//       return web1.scrollView.contentSize.height;
//
//}


-(void)LabelBreak2:(UILabel*)label
{
    CGSize labelSize = [label.text sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]
                              constrainedToSize:CGSizeMake(100,30)
                                  lineBreakMode:NSLineBreakByWordWrapping];
    if(ISPHONE5)
    {
        label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, 100, labelSize.height+5);
    }
    else
    {
        label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, 100, labelSize.height+5);
    }
    
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
}

-(void)LabelBreak2forOptions:(UILabel*)label
{
    CGSize labelSize = [label.text sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]
                              constrainedToSize:CGSizeMake(200,descriptionBorder.frame.size.width-20)
                                  lineBreakMode:NSLineBreakByWordWrapping];
    if(ISPHONE5)
    {
        label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, descriptionBorder.frame.size.width-20, labelSize.height+5);
    }
    else
    {
        label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, descriptionBorder.frame.size.width-20, labelSize.height+5);
    }
    
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
}

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}

-(void)setBorderButton:(UIButton*)str
{
    
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius=4;
    //    str.layer.borderWidth=1;
    //    str.layer.borderColor = [[UIColor clearColor] CGColor];
}

-(void)setBorderLabel:(UILabel*)str
{
    
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius=4;
    //    str.layer.borderWidth=1;
    //    str.layer.borderColor = [[UIColor clearColor] CGColor];
}

-(void)setBorderLabelGray:(UILabel*)str
{
    str.backgroundColor=[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius=4;
    //    str.layer.borderWidth=1;
    //    str.layer.borderColor = [[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0] CGColor];
}

-(void)setBorderImageView:(UIImageView*)str
{
    str.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //    str.layer.cornerRadius=4;
    //    str.layer.borderWidth=1;
    //    str.layer.borderColor = [[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0] CGColor];
}

-(void)setBorderView:(UIView*)str
{
    str.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius=4;
    //    str.layer.borderWidth=1;
    //    str.layer.borderColor = [[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0] CGColor];
}

-(void)setBorderView2:(UIView*)str
{
    
    //    str.layer.masksToBounds = YES;
    //    str.layer.cornerRadius=4;
    //    str.layer.borderWidth=1;
    //    str.layer.borderColor = [[UIColor clearColor] CGColor];
}

#pragma mark Back button

- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark GuestUser/LoginNow button

- (IBAction)UsersAction:(id)sender
{
    UIButton *button=(UIButton*)sender;
    if (button.tag==51)//Guest user
    {
        [scrollView setScrollEnabled:YES];
        [coverView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"onlyOnce"];
        [self addtoCart];
    }
    else//login user
    {
        [scrollView setScrollEnabled:YES];
        LoginViewController *objViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:objViewController animated:YES];
        objViewController.strOption=@"cart";
        objViewController = nil;
        [coverView removeFromSuperview];
    }
}

#pragma mark Add cart Api response

-(void)addtoCart
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
        if (arrProductDetails.count!=0)
        {
            [self addLoadingView];
            
            //    ApiClasses * obj_apiClass= [[ApiClasses alloc]init];
            
            NSString * str1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"quote_id"];
            NSString *str;
            NSString *strLinks;
            NSString *strParam;
            if(str1.length==0)
            {
                str1=@"";
            }
            if ([[arrProductDetails valueForKey:@"options"]count]!=0)
            {
                strParam=[[NSString alloc]init];
                for (int p=0; p<arrCustom.count; p++)
                {
                    NSString *str=[arrCustom objectAtIndex:p];
                    NSArray *arr=[str componentsSeparatedByString:@","];
                    strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@"options[%@][]=%@",[arr objectAtIndex:0],[arr objectAtIndex:1]]];
                    if (p<arrCustom.count-1)
                    {
                        strParam=[strParam stringByAppendingString:@"&"];
                    }
                }
                if ( strDate!=nil)
                {
                    strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@"&%@",strDate]];
                }
                if ( strRadio!=nil)
                {
                    strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@"&%@",strRadio]];
                }
                if (strField!=nil)
                {
                    strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@"&options[%@]=%@",strField,[[(UITextField*)[scrollView viewWithTag:[strField intValue]]text]stringByReplacingOccurrencesOfString:@" " withString:@""]]];
                }
                if(strView!=nil)
                {
                    strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@"&options[%@]=%@",strView,[[(UITextField*)[scrollView viewWithTag:[strView intValue]]text]stringByReplacingOccurrencesOfString:@" " withString:@""]]];
                }
                for (int p=0; p<strDropDown.count; p++)
                {
                    if (p<strDropDown.count)
                    {
                        strParam=[strParam stringByAppendingString:@"&"];
                    }
                    NSString *str=[strDropDown objectAtIndex:p];
                    NSArray *arr=[str componentsSeparatedByString:@","];
                    strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@"options[%@]=%@",[arr objectAtIndex:0],[arr objectAtIndex:1]]];
                }
                
                NSLog(@"%@",strParam);
            }
            NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
            if ([str5 isEqualToString:@"(null)"])
            {
                str5=@"";
            }
            if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"grouped"])
            {
                NSString *strConcat=[[NSString alloc]init];
                
                for (int y=0; y<arrGrouped.count; y++)
                {
                    strConcat=[strConcat stringByAppendingString:[NSString stringWithFormat:@"super_group[%@]=%@",[[arrGrouped objectAtIndex:y]valueForKey:@"id"],[(UITextField*)[scrollView viewWithTag:y+66]text]]];
                    if (y<arrGrouped.count-1)
                    {
                        strConcat=[strConcat stringByAppendingString:@"&"];
                    }
                }
                if ([_wishlistItem isEqualToString:@"yes"])
                {
                    str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strConcat,_wishListProductId,model.storeID,model.currencyID];
                    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                }
                else
                {
                    str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strConcat,model.storeID,model.currencyID];
                    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                }
            }
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"configurable"])
            {
                NSString *strConcat=[[NSString alloc]init];
                
                for (int y=0; y<arrOptionRequest.count; y++)
                {
                    strConcat=[strConcat stringByAppendingString:[arrOptionRequest objectAtIndex:y]];
                    if (y<arrOptionRequest.count-1)
                    {
                        strConcat=[strConcat stringByAppendingString:@"&"];
                    }
                }
                
                if (strParam !=nil)
                {
                    strConcat=[strConcat stringByAppendingString:@"&"];
                    strConcat=[strConcat stringByAppendingString:strParam];
                }
                
                if ([_wishlistItem isEqualToString:@"yes"])
                {
                    str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strConcat,_wishListProductId,model.storeID,model.currencyID];
                    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                }
                else
                {
                    str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strConcat,model.storeID,model.currencyID];
                    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                }
            }
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"downloadable"])
            {
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES)
                {
                    strLinks=[[NSString alloc]init];
                    for (int p=0; p<arrLinkOption.count; p++)
                    {
                        strLinks=[strLinks stringByAppendingString:[NSString stringWithFormat:@"links[]=%@",[arrLinkOption objectAtIndex:p]]];
                        if (p<arrLinkOption.count-1)
                        {
                            strLinks=[strLinks stringByAppendingString:@"&"];
                            
                        }
                    }
                    if (strParam!=nil)
                    {
                        strLinks=[strLinks stringByAppendingString:@"&"];
                        strLinks=[strLinks stringByAppendingString:strParam];
                    }
                    NSLog(@"%@",strLinks);
                    
                    if ([_wishlistItem isEqualToString:@"yes"])
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strLinks,_wishListProductId,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                    else
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strLinks,model.storeID,model.currencyID];
                    }
                    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                }
                else
                {
                    [self removeLoadingView];
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleaseLogintoavailthisproduct", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
                    alert.tag=98;
                    [alert show];
                }
            }
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"virtual"])
            {
                if (strParam!=nil)
                {
                    if ([_wishlistItem isEqualToString:@"yes"])
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strParam,_wishListProductId,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                    else
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strParam,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                }
                else
                {
                    if ([_wishlistItem isEqualToString:@"yes"])
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,_wishListProductId,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                    else
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                }
            }
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"bundle"])
            {
                NSString *strbundle=[NSString new];
                for (int p=0; p<arrCustomBundle.count; p++)
                {
                    NSString *str=[arrCustomBundle objectAtIndex:p];
                    NSArray *arr=[str componentsSeparatedByString:@","];
                    strbundle=[strbundle stringByAppendingString:[NSString stringWithFormat:@"bundle_option[%@][]=%@",[arr objectAtIndex:0],[arr objectAtIndex:1]]];
                    if (p<arrCustomBundle.count-1)
                    {
                        strbundle=[strbundle stringByAppendingString:@"&"];
                        
                    }
                }
                if (![strRadioBundle isEqualToString:@""] && strRadioBundle!=nil)
                {
                    strbundle=[strbundle stringByAppendingString:[NSString stringWithFormat:@"&%@",strRadioBundle]];
                }
                for (int u=0; u<strSelect.count; u++)
                {
                    if (![[strSelect objectAtIndex:u] isEqualToString:@""] && strSelect!=nil)
                    {
                        strbundle=[strbundle stringByAppendingString:[NSString stringWithFormat:@"&%@",[strSelect objectAtIndex:u]]];
                    }
                }
                for (int j=0; j<arrBundle.count; j++)
                {
                    if ([[[arrBundle objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"select"])
                    {
                        if ([arrBundle objectAtIndex:j]!=nil)
                        {
                            NSString *strQty1=[(UITextField*)[scrollView viewWithTag:[[[arrBundle objectAtIndex:j] valueForKey:@"option_id"] intValue]]text];
                            if (strQty1!=0)
                            {
                                strbundle=[strbundle stringByAppendingString:[NSString stringWithFormat:@"&bundle_option_qty[%@]=%@",[[arrBundle objectAtIndex:j] valueForKey:@"option_id"],strQty1]];
                            }
                            
                        }
                        
                    }
                }
                if (dictRadiobundle!=nil)
                {
                    NSString *strQty2=[(UITextField*)[scrollView viewWithTag:[[dictRadiobundle valueForKey:@"option_id"] intValue]]text];
                    if (strQty2!=0)
                    {
                        strbundle=[strbundle stringByAppendingString:[NSString stringWithFormat:@"&bundle_option_qty[%@]=%@",[dictRadiobundle valueForKey:@"option_id"],strQty2]];
                    }
                }
                
                if (strParam!=nil)
                {
                    strbundle=[strbundle stringByAppendingString:@"&"];
                    strbundle=[strbundle stringByAppendingString:strParam];
                }
                if ([_wishlistItem isEqualToString:@"yes"])
                {
                    str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strbundle,_wishListProductId,model.storeID,model.currencyID];
                    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                }
                else
                {
                    str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strbundle,model.storeID,model.currencyID];
                    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                }
            }
            else if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"simple"])
            {
                if (strParam!=nil)
                {
                    if ([_wishlistItem isEqualToString:@"yes"])
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,strParam,_wishListProductId,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                    else
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[[arrProductDetails valueForKey:@"sku"]stringByReplacingOccurrencesOfString:@" " withString:@""],str1,str5,strParam,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                }
                else
                {
                    if ([_wishlistItem isEqualToString:@"yes"])
                    {
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&wishlist_item_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,_wishListProductId,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                    else
                    {
                        
                        str=[NSString stringWithFormat:@"%@addtocart?salt=%@&prod_id=%@&qty=1&sku=%@&quote_id=%@&cust_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,[arrProductDetails valueForKey:@"sku"],str1,str5,model.storeID,model.currencyID];
                        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_cart_Response:)];
                    }
                }
            }
        }
    }
}

-(void)Get_cart_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@-----",responseDict);
    if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[[responseDict valueForKey:@"response"] valueForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
        if ([responseDict isKindOfClass:[NSDictionary class]])
        {
            if([[[responseDict valueForKey:@"response"]valueForKey:@"quote_id"]length]!=0)
            {
                
                [[NSUserDefaults standardUserDefaults]setValue:[[responseDict valueForKey:@"response"]valueForKey:@"quote_id"] forKey:@"quote_id"];
            }
            
            if([[responseDict valueForKey:@"response"]valueForKey:@"quote_count"]!=0)
            {
                [self.lblCount setHidden:NO];
                [[NSUserDefaults standardUserDefaults]setValue:[[responseDict valueForKey:@"response"]valueForKey:@"quote_count"] forKey:@"quote_count"];
                
                self.lblCount.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"quote_count"]];
            }
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
        if (BuyNow==YES)
        {
            AddToCartView *cartView=[[AddToCartView alloc]initWithNibName:@"AddToCartView" bundle:nil];
            [self.navigationController pushViewController:cartView animated:YES];
        }
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([[responseDict valueForKey:@"response"] rangeOfString:@"Cart is de-activated"].location != NSNotFound)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[responseDict valueForKey:@"response"] message:nil delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
            [alert show];
            
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"quote_id"];
            
            [[NSUserDefaults standardUserDefaults]setValue:0 forKey:@"quote_count"];
        }
        else if(([[responseDict valueForKey:@"response"] rangeOfString:@"specify"].location != NSNotFound)||([[responseDict valueForKey:@"response"] rangeOfString:@"out of stock"].location != NSNotFound))
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[responseDict valueForKey:@"response"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            //                call=1;
            //                [self getProductdata];
            [alert show];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[responseDict valueForKey:@"response"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark - AddToCart/BuyNow button

- (IBAction)AddToCartBuyNow:(id)sender
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
        NSLog(@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"onlyOnce"]);
        
        UIButton *button=(UIButton*)sender;
        if ([[arrProductDetails valueForKey:@"in_stock"]intValue]==1)
        {
            if (button.tag==41)
            {
                if([[NSUserDefaults standardUserDefaults]integerForKey:@"onlyOnce"] == 0)
                {
                    CGRect screenRect = [[UIScreen mainScreen] bounds];
                    coverView = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, (self.view.frame.size.height)-20)];
                    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                    
                    popUpView.frame=CGRectMake(self.scrollView.frame.origin.x+11, 180, self.view.frame.size.width-22, 150);
                    
                    [self.view addSubview:coverView];
                    [coverView addSubview:popUpView];
                    [scrollView setContentOffset:CGPointZero animated:YES];
                    [scrollView setScrollEnabled:NO];
                    BuyNow=NO;
                    
                }
                else
                {
                    BuyNow=NO;
                    
                    [self addtoCart];
                }
            }
            else
            {
                if([[NSUserDefaults standardUserDefaults]integerForKey:@"onlyOnce"] == 0)
                {
                    CGRect screenRect = [[UIScreen mainScreen] bounds];
                    coverView =[[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, (self.view.frame.size.height)-20)];
                    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                    popUpView.frame=CGRectMake(self.scrollView.frame.origin.x+11, 180, self.view.frame.size.width-22, 150);
                    [self.view addSubview:coverView];
                    [coverView addSubview:popUpView];
                    [scrollView setScrollEnabled:NO];
                    [scrollView setContentOffset:CGPointZero animated:YES];
                    
                    BuyNow=YES;
                }
                else
                {
                    BuyNow=YES;
                    [self addtoCart];
                }
            }
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tProductisoutofstock", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
            
        }
    }
}


#pragma mark - CartDetail Button

- (IBAction)cartDetailBtn_Action:(id)sender
{
    NSString * str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"quote_count"]];
    
    if(![str isEqualToString:@"0"] && ![str isEqualToString:@"(null)"])
    {
        AddToCartView * obj = [[AddToCartView alloc]initWithNibName:@"AddToCartView" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tYourCartIsEmpty", nil) message:nil delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
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
    if (tableView==tableGrouped)
    {
        return [arrGrouped count];
    }
    else
    {
        return [delegate.arrOptions count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableGrouped)
    {
        static NSString *CellIdentifier = @"GroupedCell";
        GroupedCell *cell = (GroupedCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        [cell.groupedName TransformAlignLabel];
        [cell.groupedImage TransformImage];
        [cell.groupedPrice TransformAlignLabel];
        [cell.groupedDiscount TransformAlignLabel];
        [cell.groupedQuantity TransformAlignLabel];
        [cell.tftGroupedQty TransformTextField];
        
        cell.groupedName.text=[[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [cell.groupedImage sd_setImageWithURL:[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"img"]placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        if ([[[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue]<[[[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
            
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.groupedDiscount.attributedText=attrText;
            cell.groupedDiscount.hidden=NO;
            
            cell.groupedPrice.text=[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"final_price"];
        }
        else
        {
            cell.groupedDiscount.hidden=YES;
            cell.groupedPrice.text=[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"final_price"];
        }
        if ([[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"is_in_stock"]intValue]==1)
        {
            cell.tftGroupedQty.hidden=NO;
            cell.textFieldBorder.hidden=NO;
            cell.groupedQuantity.hidden=NO;
            
            //            cell.textFieldBorder.layer.cornerRadius=4.0;
            //            cell.textFieldBorder.layer.borderWidth=1.0;
            //            cell.textFieldBorder.layer.borderColor=[[UIColor clearColor]CGColor];
            //            cell.textFieldBorder.layer.masksToBounds=YES;
            
            cell.tftGroupedQty.tag=indexPath.row+66;
            [cell.tftGroupedQty addTarget:self
                                   action:@selector(textFieldDidChange:)
                         forControlEvents:UIControlEventEditingChanged];
            cell.tftGroupedQty.text=[[arrGrouped objectAtIndex:indexPath.row]valueForKey:@"qty"];
            cell.tftGroupedQty.delegate=self;
            cell.groupedQuantity.text=AMLocalizedString(@"tQty", nil);
        }
        else
        {
            cell.tftGroupedQty.hidden=YES;
            cell.textFieldBorder.hidden=YES;
            cell.groupedQuantity.text=AMLocalizedString(@"tOutofStock", nil);
            [cell.groupedQuantity setTextColor:[UIColor redColor]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableGrouped)
    {
        return 66.0;
    }
    else
    {
        return 35.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableGrouped)
    {}
    else
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
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginAddWishlist"];        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"quote_id"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"quote_count"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"login"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cancelOrder"];
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

#pragma mark ---TextField Delegate Method---

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"grouped"])
    {
        if([textField.text length] - range.length + textField.text.length < 4)
            return YES;
        else
            return NO;
    }
    else if(textField==pinCode)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else
        return YES;
}

-(void)textFieldDidChange :(UITextField *)textField
{
    if ([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"grouped"])
    {
        NSLog( @"text changed: %@  and previous : %@", textField.text,productsPrice.text);
        mn=0.0;
        for (int m=0; m<arrGrouped.count; m++)
        {
            mn=mn+[[[[arrGrouped objectAtIndex:m]valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue] * [[(UITextField*)[self.view viewWithTag:m+66] text]floatValue];
        }
        productsPrice.text=[NSString stringWithFormat:@"%.2f",mn];
    }
    else if([[arrProductDetails valueForKey:@"type_id"]isEqualToString:@"bundle"])
    {
        NSLog( @"text changed: %@  and previous : %@, tag=%ld", textField.text,productsPrice.text,(long)textField.tag);
        
        if ([[[arrBundle objectAtIndex:[textField.accessibilityHint intValue]]valueForKey:@"option_id"]intValue]==textField.tag)
        {
            NSArray *arr=[[arrBundle objectAtIndex:[textField.accessibilityHint intValue]] valueForKey:@"selections"];
            NSString *strSel;
            NSString *strTag=[NSString stringWithFormat:@"%ld",(long)textField.tag];
            for (int n=0; n<strSelection.count; n++)
            {
                NSArray *arrSelect= [[strSelection objectAtIndex:n]componentsSeparatedByString:@","];
                if ([[arrSelect objectAtIndex:1]isEqualToString:strTag])
                {
                    strSel=[arrSelect objectAtIndex:0];
                }
            }
            
            for (int j=0; j<arr.count; j++)
            {
                if ([[[arr objectAtIndex:j]valueForKey:@"selection_id"]intValue]==[strSel intValue])
                {
                    NSLog(@"%d",[strSel intValue]);
                    for (int c=0; c<arrCalculate.count; c++)
                    {
                        NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                        if ([[str objectAtIndex:0]isEqualToString:@"selectBundle"] && [[str objectAtIndex:1]isEqualToString:strTag])
                        {
                            
                            [arrCalculate removeObjectAtIndex:c];
                        }
                    }
                    [arrCalculate addObject:[NSString stringWithFormat:@"selectBundle,%@,%f",strTag,[[[arr objectAtIndex:j]valueForKey:@"price"]floatValue]*[[(UITextField*)[self.view viewWithTag:textField.tag]text]floatValue]]];
                    
                    
                }
            }
            [self calculatePrice];
        }
        else if ([[dictRadiobundle valueForKey:@"option_id"]intValue]==textField.tag)
        {
            NSArray *arr=[dictRadiobundle valueForKey:@"selections"];
            
            for (int j=0; j<arr.count; j++)
            {
                if ([[[arr objectAtIndex:j]valueForKey:@"selection_id"]intValue]==strRadioSelect)
                {
                    
                    //                to calculate product price
                    
                    for (int c=0; c<arrCalculate.count; c++)
                    {
                        NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                        if ([[str objectAtIndex:0]isEqualToString:@"radioBundle"])
                        {
                            [arrCalculate removeObjectAtIndex:c];
                        }
                    }
                    [arrCalculate addObject:[NSString stringWithFormat:@"radioBundle,%ld,%f",(long)textField.tag,[[[[arr objectAtIndex:j]valueForKey:@"special_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue]*[[(UITextField*)[self.view viewWithTag:textField.tag]text]floatValue]]];
                    
                }
            }
            [self calculatePrice];
            
        }
    }
    if ([[arrProductDetails valueForKey:@"options"]count]!=0)
    {
        if (textField.tag==[strField intValue])
        {
            if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0)
            {
                for (int j=0; j<arrSimpleOptions.count; j++)
                {
                    if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"field"])
                    {
                        if ([[arrSimpleOptions objectAtIndex:j]count]!=0)
                        {
                            NSDictionary *arrAdditional=[arrSimpleOptions objectAtIndex:j];
                            for (int c=0; c<arrCalculate.count; c++)
                            {
                                NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                                if ([[str objectAtIndex:0]isEqualToString:@"field"])
                                {
                                    [arrCalculate removeObjectAtIndex:c];
                                }
                            }
                            
                            if ([[arrAdditional valueForKey:@"option_id"]intValue]==textField.tag)
                            {
                                [arrCalculate addObject:[NSString stringWithFormat:@"field,%ld,%f",(long)textField.tag,[[[arrAdditional valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue]]];
                            }
                        }
                    }
                }
                [self calculatePrice];
            }
            else
            {
                for (int c=0; c<arrCalculate.count; c++)
                {
                    NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                    if ([[str objectAtIndex:0]isEqualToString:@"field"]&& [[str objectAtIndex:1]intValue]==textField.tag)
                    {
                        [arrCalculate removeObjectAtIndex:c];
                    }
                }
                [self calculatePrice];
            }
        }
        
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ---TextView delegate Methods---

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.tag==[strView intValue])
    {
        if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0)
        {
            for (int j=0; j<arrSimpleOptions.count; j++)
            {
                if ([[[arrSimpleOptions objectAtIndex:j]valueForKey:@"type"]isEqualToString:@"area"])
                {
                    if ([[arrSimpleOptions objectAtIndex:j]count]!=0)
                    {
                        NSDictionary *arrAdditional=[arrSimpleOptions objectAtIndex:j];
                        for (int c=0; c<arrCalculate.count; c++)
                        {
                            NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                            if ([[str objectAtIndex:0]isEqualToString:@"area"])
                            {
                                [arrCalculate removeObjectAtIndex:c];
                            }
                        }
                        
                        if ([[arrAdditional valueForKey:@"option_id"]intValue]==textView.tag)
                        {
                            [arrCalculate addObject:[NSString stringWithFormat:@"area,%ld,%f",(long)textView.tag,[[[arrAdditional valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue]]];
                        }
                    }
                }
            }
            [self calculatePrice];
        }
        else
        {
            for (int c=0; c<arrCalculate.count; c++)
            {
                NSArray *str=[[arrCalculate objectAtIndex:c]componentsSeparatedByString:@","];
                if ([[str objectAtIndex:0]isEqualToString:@"area"]&& [[str objectAtIndex:1]intValue]==textView.tag)
                {
                    [arrCalculate removeObjectAtIndex:c];
                }
            }
            [self calculatePrice];
        }
    }
}

#pragma mark - Webview delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (web==NO)
    {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        CGRect frame = webView.frame;
        frame.size.height = 1;
        webView.frame = frame;
        
        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        webView.frame = frame;
        
        NSLog(@"%f",webView.scrollView.contentSize.height);
        _descriptionWEB.frame=CGRectMake(_descriptionWEB.frame.origin.x, _descriptionWEB.frame.origin.y, _descriptionWEB.frame.size.width, webView.scrollView.contentSize.height);
        web=YES;
        
        [self setDeliveryView:deliveryOptionView.frame];
        
        NSLog(@"finish");
        
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeLoadingView];
    NSLog(@"Error for WEBVIEW: %@",[error description]);
    
}




#pragma mark ---Touch event method---

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [coverView removeFromSuperview];
    [tableView1 setHidden:YES];
    [scrollView setScrollEnabled:YES];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [selectView removeFromSuperview];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [selectView removeFromSuperview];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
}

#pragma mark Review Button Method

- (IBAction)reviewViewButton:(id)sender
{
    ReviewsViewViewController *reviewView=[[ReviewsViewViewController alloc]initWithNibName:@"ReviewsViewViewController" bundle:nil];
    reviewView.strProdId=strProdId;
    [self.navigationController pushViewController:reviewView animated:YES];
}

#pragma mark ---Wishlist Button---

- (IBAction)wishlistBtn_Action:(UIButton*)sender
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES)
    {
        UIImage *img1=[UIImage imageNamed:@"heart.png"];
        UIImage *img2=sender.imageView.image;
        NSData *imgdata1 = UIImagePNGRepresentation(img1);
        NSData *imgdata2 = UIImagePNGRepresentation(img2);
        NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
        if ([str5 isEqualToString:@"(null)"])
        {
            str5=@"";
        }
        
        if ([imgdata1 isEqualToData:imgdata2])
        {
            [wishlistButton setImage:[UIImage imageNamed:@"ChildHeart.png"] forState:UIControlStateNormal];
            [self addLoadingView];
            NSString *str=[NSString stringWithFormat:@"%@addProductToWishList?salt=%@&prod_id=%@&cust_id=%@&qty=1&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,str5,model.storeID,model.currencyID];
            
            //----------------API----------------------
            
            //            ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(AddWishlist_response:)];
            
            wistlistadded = YES;
        }
        else
        {
            [wishlistButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
            
            [self addLoadingView];
            
            NSString *str=[NSString stringWithFormat:@"%@removeWishListItem?salt=%@&wishlist_item_id=%@&cust_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,_wishListProductId,str5,model.storeID,model.currencyID];
            
            //---------------- API----------------------
            
            //            ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(removeItemFromWishList:)];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tConfirmlogin", nil) message:AMLocalizedString(@"tPleaseLogintoaddremoveproducttowishlistConfirmtocontinue", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        alert.tag=99;
        [alert show];
    }
}

-(void)AddWishlist_response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    NSString *response = [responseDict valueForKey:@"response"];
    
    if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"success"])
    {
        _wishListProductId =[NSString stringWithFormat:@"%@", [responseDict valueForKey:@"wishlist_item_id"]];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Item has been added to your wishlist." delegate:nil cancelButtonTitle:tOK otherButtonTitles: nil];
        [alert show];
    }
    else  if ([[[responseDict valueForKey:@"returncode"]valueForKey:@"resultText"] isEqualToString:@"Server Down"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:response delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)removeItemFromWishList:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    NSString *response = [responseDict valueForKey:@"response"];
    
    if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:response delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:response delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
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

#pragma mark ---AlertView Delegate---

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==98)
    {
        LoginViewController *objViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        objViewController.strOption=@"cart";
        [self.navigationController pushViewController:objViewController animated:YES];
        objViewController = nil;
    }
    else if(alertView.tag==99)
    {
        LoginViewController *objViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        objViewController.strOption=@"wishlist";
        [self.navigationController pushViewController:objViewController animated:YES];
        objViewController = nil;
    }
}

#pragma mark Share method

- (IBAction)shareMethod:(id)sender
{
    NSString *message1 = AMLocalizedString(@"tSharingURL", nil) ;
    NSString *message2= [NSString stringWithFormat:@"%@",[arrProductDetails valueForKey:@"product_url"]];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:@[message1,message2] applicationActivities:nil];
    avc.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self presentViewController:avc animated:YES completion:nil];
    }
}

#pragma mark ---Pincode check---

- (IBAction)checkPincode:(id)sender
{
    //    [scrollView setScrollEnabled:YES];
    
    if ([[pinCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleaseenterPincode", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        [self addLoadingView];
        
        NSString *str=[[NSString stringWithFormat:@"http://www.fastdeel.com/minimart/deliveryopt/check?pincode=%@&cstore=%@&ccurrency=%@",pinCode.text,model.storeID,model.currencyID]stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"<<<<<<FastDeel Url used here>>>>>>>");
        //----------------API----------------------
        
        //            ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_CheckPincode_Response:)];
    }
}

-(void)Get_CheckPincode_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if([[responseDict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
    {
        if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
        {
            
            NSDictionary *response =[responseDict valueForKey:@"response"];
            
            NSString *isShip=[response valueForKey:@"isship"];
            NSString *isCod=[response valueForKey:@"iscod"];
            
            if ([isShip isEqualToString:@"0"] && [isCod isEqualToString:@"0"])
            {
                deliveryOptionView.frame=CGRectMake(deliveryOptionView.frame.origin.x, deliveryOptionView.frame.origin.y, deliveryOptionView.frame.size.width,128);
                [_optionImage setImage:[UIImage imageNamed:@"i6_loc.png"]];
                
                [deliveryOrder setText:[NSString stringWithFormat:@"%@: %@",AMLocalizedString(@"tDeliveryoptionfor", nil) ,[response valueForKey:@"qpostcode"]]];
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[response valueForKey:@"qpostcode"]] forKey:@"Pincode"];
                
                shippingImg.image=[UIImage imageNamed:@"cross_btn.png"];
                [shipLabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"shipmsgfalse"]]];
                cODImg.image=[UIImage imageNamed:@"cross_btn.png"];
                [codlabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"codmsgfalse"]]];
                [_DeliveryDaysLabel setHidden:YES];
                [_samedayDispatchLbl setHidden:YES];
                [_deliveryImg setHidden:YES];
                [self setDeliveryView:deliveryOptionView.frame];
                
            }
            else if([isShip isEqualToString:@"0"] && [isCod isEqualToString:@"1"])
            {
                deliveryOptionView.frame=CGRectMake(deliveryOptionView.frame.origin.x, deliveryOptionView.frame.origin.y, deliveryOptionView.frame.size.width,128);
                [_optionImage setImage:[UIImage imageNamed:@"i6_loc.png"]];
                
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[response valueForKey:@"qpostcode"]] forKey:@"Pincode"];
                [deliveryOrder setText:[NSString stringWithFormat:@"%@: %@",AMLocalizedString(@"tDeliveryoptionfor", nil),[response valueForKey:@"qpostcode"]]];
                shippingImg.image=[UIImage imageNamed:@"cross_btn.png"];
                cODImg.image=[UIImage imageNamed:@"tick_btn.png"];
                [shipLabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"shipmsgfalse"]]];
                [codlabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"codmsgtrue"]]];
                [_DeliveryDaysLabel setHidden:YES];
                [_samedayDispatchLbl setHidden:YES];
                [_deliveryImg setHidden:YES];
                [self setDeliveryView:deliveryOptionView.frame];
            }
            else if([isShip isEqualToString:@"1"] && [isCod isEqualToString:@"0"])
            {
                deliveryOptionView.frame=CGRectMake(deliveryOptionView.frame.origin.x, deliveryOptionView.frame.origin.y, deliveryOptionView.frame.size.width,166);
                [_optionImage setImage:[UIImage imageNamed:@"i6_loc.png"]];
                [_deliveryImg setImage:[UIImage imageNamed:@"tick_btn@2x.png"]];
                [deliveryOrder setText:[NSString stringWithFormat:@"%@: %@",AMLocalizedString(@"tDeliveryoptionfor", nil),[response valueForKey:@"qpostcode"]]];
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[response valueForKey:@"qpostcode"]] forKey:@"Pincode"];
                shippingImg.image=[UIImage imageNamed:@"tick_btn.png"];
                cODImg.image=[UIImage imageNamed:@"cross_btn.png"];
                [shipLabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"shipmsgtrue"]]];
                [codlabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"codmsgfalse"]]];
                [_DeliveryDaysLabel setText:[NSString stringWithFormat:@"%@ %@ %@",AMLocalizedString(@"tDeliveryWithin", nil),[response valueForKey:@"deltime"],AMLocalizedString(@"tdays", nil)]];
                [_samedayDispatchLbl setText:AMLocalizedString(@"tSameDayDispatch", nil)];
                [_DeliveryDaysLabel setHidden:NO];
                [_samedayDispatchLbl setHidden:NO];
                [_deliveryImg setHidden:NO];
                
                [self setDeliveryView:deliveryOptionView.frame];
            }
            else if([isShip isEqualToString:@"1"] && [isCod isEqualToString:@"1"])
            {
                deliveryOptionView.frame=CGRectMake(deliveryOptionView.frame.origin.x, deliveryOptionView.frame.origin.y, deliveryOptionView.frame.size.width,166);
                [_optionImage setImage:[UIImage imageNamed:@"i6_loc.png"]];
                [_deliveryImg setImage:[UIImage imageNamed:@"tick_btn@2x.png"]];
                [deliveryOrder setText:[NSString stringWithFormat:@"%@: %@",AMLocalizedString(@"tDeliveryoptionfor", nil),[response valueForKey:@"qpostcode"]]];
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[response valueForKey:@"qpostcode"]] forKey:@"Pincode"];
                shippingImg.image=[UIImage imageNamed:@"tick_btn.png"];
                cODImg.image=[UIImage imageNamed:@"tick_btn.png"];
                [shipLabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"shipmsgtrue"]]];
                [codlabel setText:[NSString stringWithFormat:@"%@",[response valueForKey:@"codmsgtrue"]]];
                [_DeliveryDaysLabel setText:[NSString stringWithFormat:@"%@ %@ %@",AMLocalizedString(@"tDeliveryWithin", nil),[response valueForKey:@"deltime"],AMLocalizedString(@"tdays", nil)]];
                [_samedayDispatchLbl setText:AMLocalizedString(@"tSameDayDispatch", nil)];
                [_DeliveryDaysLabel setHidden:NO];
                [_samedayDispatchLbl setHidden:NO];
                [_deliveryImg setHidden:NO];
                [self setDeliveryView:deliveryOptionView.frame];
            }
            else
            {
                deliveryOptionView.frame=CGRectMake(deliveryOptionView.frame.origin.x, deliveryOptionView.frame.origin.y, deliveryOptionView.frame.size.width,66);
                [_optionImage setImage:[UIImage imageNamed:@""]];
                [_deliveryImg setImage:[UIImage imageNamed:@""]];
                [deliveryOrder setText:@""];
                shippingImg.image=[UIImage imageNamed:@""];
                cODImg.image=[UIImage imageNamed:@""];
                [shipLabel setText:@""];
                [codlabel setText:@""];
                [_DeliveryDaysLabel setText:@""];
                [_samedayDispatchLbl setText:@""];
                
                [self setDeliveryView:deliveryOptionView.frame];
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleaseenterPincode", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
                [alert show];
            }
            
            //        if (scrollView.contentSize.height+55<self.view.frame.size.height)
            //        {
            //            [scrollView setScrollEnabled:NO];
            //            NSLog(@"scroll.height%f=self.view.height%f",scrollView.contentSize.height+55,self.view.frame.size.height);
            //        }
            //        else
            //        {
            //            NSLog(@"scroll.height%f=self.view.height%f",scrollView.contentSize.height+55,self.view.frame.size.height);
            //        }
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
    }
    
}


@end
