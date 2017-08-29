//
//  ViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/8/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.


#import "ViewController.h"
#import "ApiClasses.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CollectionCell.h"
#import "ViewMoreViewController.h"
#import "ProductDetailsViewController.h"
#import "SearchViewController.h"
#import "ModelClass.h"
#import "AppInfoView.h"
#import "CustomView.h"
#import "AppDelegate.h"
#import "UserProfileView.h"
#import "AddToCartView.h"
#import "TableCollaspe.h"
#import "TableMain.h"
#import "Constants.h"
#import "MyOrdersViewController.h"
#import "Utility.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "NotificationCenter.h"
#import "WishListViewViewController.h"
#import "DownloadableView.h"
#import <Google/Analytics.h>
#import "UIColor+fromHex.h"
#import "LocalizationSystem.h"
#import "LanguageSettingView.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"

// <color name="colorPrimary">#293041</color>rgb(41,48,65)
//<color name="colorPrimaryDark">#384056</color>RGB 56, 64, 86
//<color name="productlist_type">#ea674a</color>RGB	234	103	74(orange)
//<color name="app_price_color">#909090</color>(144,144,144).
//<color name="app_textcolor">#666666</color>RGB 102, 102, 102
//<color name="green">#85b74e</color>RGB 133,183,78
//main screen heading (NewArrival)<color name="app_textcolor_heading">#384056</color>RGB (56,64,86)
//Related products title<color name="mainscreen_text_color">#444444</color>RGB values of 68,68,68
//<color name="blue_color"> #67B0D6</color>RGB 103	176	214
//<color name="bright_orange"> #eb802f </color>RGB (254,248,244)

@interface ViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *arrProductNew;
    NSMutableArray *arrProductMostSell;
    NSMutableArray *arrProductFeatured;
    NSMutableArray *arrProductSlider;
    NSMutableArray *arrProductForth;
    NSMutableArray *arrProductFifth;
    NSMutableArray *arrProductSixth;
    NSMutableArray *arrProductSeventh;
    NSMutableArray *arrProductEighth;
    NSMutableArray *arrProductNinth;
    NSMutableArray *arrProductTenth;
    NSMutableArray *arrProductEleventh;
    NSMutableArray *arrProducRecentlyViewed;
    NSMutableArray *arrImageBanner;
    NSMutableArray *arrCustomBanner;
    NSMutableArray *arr;
    NSMutableArray * arr3;
     NSTimer *timer;
    
    NSString *currencyIcon;
    ModelClass * model;
    int i;
    int count;
    BOOL menuOpen;
    CGRect frame;
    NSMutableArray * arr1;
    NSMutableArray * arr2;
    int countArray;
    BOOL clicked;
    int indexSection;
    int indexSection1;
    int indexSection2;
    BOOL check;
    long clickedCategory;
}
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UIView *sideNav;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSearch;
@property (assign)BOOL isOpen;
@property (nonatomic,strong)NSIndexPath *selectIndex;

@property (weak, nonatomic) IBOutlet UIView *topview;

@end

@implementation ViewController

@synthesize pageControl,imagePage,scrollView,collectionview,types,typefeatured,typeMost,collectionViewFeat,collectionViewMost,imgSearch,bannerButtons,tableView1,delegate,typeRecntlyViewd,recentlyCollectionView,recentView,MostView,FeaturedView,NewArrView;

static NSString * const kCellReuseIdentifier = @"customCell";
static NSString * const kCellReuseIdentifierM = @"customCellM";
static NSString * const kCellReuseIdentifierF = @"customCellF";
static NSString * const kCellReuseIdentifierFour = @"customCellFr";
static NSString * const kCellReuseIdentifierFifth = @"customCellFf";
static NSString * const kCellReuseIdentifierSixth = @"customCellS";
static NSString * const kCellReuseIdentifierSeventh = @"customCellSevn";
static NSString * const kCellReuseIdentifierEighth = @"customCellEght";
static NSString * const kCellReuseIdentifierNinth = @"customCellN";
static NSString * const kCellReuseIdentifierTenth = @"customCellTen";
static NSString * const kCellReuseIdentifierEleventh = @"customCellElvn";
static NSString * const kCellReuseIdentifierR = @"customCellR";

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle

{
    self = [super initWithNibName:@"ViewController" bundle:nil];
    if (self != nil)
    {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:) name:@"TestNotification" object:nil];
    }
    return self;
    
}


- (void)viewDidLoad
{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]==nil)
    {
        //        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        //        NSLog(@"%@",language);
        //        if ([language isEqualToString:@"en"] || [language isEqualToString:@"ar"])
        //        {
        //           [[NSUserDefaults standardUserDefaults]setValue:language forKey:@"selectedLanguage"];
        //        }
        //        else
        //        {
        [[NSUserDefaults standardUserDefaults]setValue:@"en" forKey:@"selectedLanguage"];
        //        }
        //
        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]];
        LocalizationSetLanguage(str);
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]];
        LocalizationSetLanguage(@"en");
    }
    
    //rtl or ltr
    
    [self.view TransformViewCont];
    [_topview TransformationView];
    [_more1 TransformButton];
    [_more2 TransformButton];
    [_more3 TransformButton];
    [_more4 TransformButton];
    [_more5 TransformButton];
    [_more6 TransformButton];
    [_more7 TransformButton];
    [_more8 TransformButton];
    [_more9 TransformButton];
    [_more10 TransformButton];
    [_more11 TransformButton];
    
    [super viewDidLoad];
    
    //Word Change
    NSDictionary * linkAttributes = @{NSForegroundColorAttributeName:_more1.titleLabel.textColor, NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_more1.titleLabel.text attributes:linkAttributes];
    //[button.titleLabel setAttributedText:attributedString];
  //  lblText.attributedText = text;
  //  self.myUILabel.attributedText = text;
    [_more1 setAttributedTitle:attributedString forState:UIControlStateNormal];
    [_more2 setAttributedTitle:attributedString forState:UIControlStateNormal];
    [_more3 setAttributedTitle:attributedString forState:UIControlStateNormal];
    [_more4 setAttributedTitle:attributedString forState:UIControlStateNormal];
    [_more5 setAttributedTitle:attributedString forState:UIControlStateNormal];
    [_more6 setAttributedTitle:attributedString forState:UIControlStateNormal];
     [_more7 setAttributedTitle:attributedString forState:UIControlStateNormal];
     [_more8 setAttributedTitle:attributedString forState:UIControlStateNormal];
     [_more9 setAttributedTitle:attributedString forState:UIControlStateNormal];
     [_more10 setAttributedTitle:attributedString forState:UIControlStateNormal];
     [_more11 setAttributedTitle:attributedString forState:UIControlStateNormal];
    [btnSearch setTitle:AMLocalizedString(@"tSearchYourItem",nil) forState:UIControlStateNormal];

    
    menuOpen=NO;
    self.isOpen = NO;
    model = [ModelClass sharedManager];
    delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    imagePage.resizeImage=NO;
    
    //scrollview
    
    //    if (Is_IPhone4)
    //    {
    //        [scrollView setFrame:CGRectMake(0, 0, 320,self.view.bounds.size.height)];
    //        [scrollView setContentSize:CGSizeMake(320, 905)];
    //    }
    //    else
    //    {
    //    [scrollView setFrame:CGRectMake(0, 0, 320,self.view.bounds.size.height)];
    //    [scrollView setContentSize:CGSizeMake(320, 815)];
    //    }
    
    //    imgSearch.layer.masksToBounds = YES;
    //    imgSearch.layer.cornerRadius = 4.0;
    //    imgSearch.layer.borderWidth = 1.0;
    //    imgSearch.layer.borderColor=[model.themeColor CGColor];
    // [self.mainView addSubview:scrollView];
    //[self.view addSubview:scrollView];
    
    //new arrival
    
    [collectionview registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    collectionview.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(130, 170)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [collectionview setCollectionViewLayout:flowLayout];
    [collectionview setAllowsSelection:YES];
    
    //most selling
    
    [collectionViewMost registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierM];
    collectionViewMost.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayoutM = [[UICollectionViewFlowLayout alloc] init];
    [flowLayoutM setItemSize:CGSizeMake(130, 170)];
    [flowLayoutM setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayoutM setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [collectionViewMost setCollectionViewLayout:flowLayoutM];
    [collectionViewMost setAllowsSelection:YES];
    
    //featured
    [collectionViewFeat registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierF];
    collectionViewFeat.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayoutF = [[UICollectionViewFlowLayout alloc] init];
    [flowLayoutF setItemSize:CGSizeMake(130, 170)];
    [flowLayoutF setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayoutF setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [collectionViewFeat setCollectionViewLayout:flowLayoutF];
    [collectionViewFeat setAllowsSelection:YES];
    
    //Forth
    
    [_collectionFourth registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierFour];
    _collectionFourth.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayoutFr = [[UICollectionViewFlowLayout alloc] init];
    [flowLayoutFr setItemSize:CGSizeMake(130, 170)];
    [flowLayoutFr setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayoutFr setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionFourth setCollectionViewLayout:flowLayoutFr];
    [_collectionFourth setAllowsSelection:YES];
    
    //Fifth
    
    [_collectionViewFifth registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierFifth];
    _collectionViewFifth.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayoutFf = [[UICollectionViewFlowLayout alloc] init];
    [flowLayoutFf setItemSize:CGSizeMake(130, 170)];
    [flowLayoutFf setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayoutFf setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionViewFifth setCollectionViewLayout:flowLayoutFf];
    [_collectionViewFifth setAllowsSelection:YES];
    
    //Sixth
    [_collectionViewsixth registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierSixth];
    _collectionViewsixth.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayoutS = [[UICollectionViewFlowLayout alloc] init];
    [flowLayoutS setItemSize:CGSizeMake(130, 170)];
    [flowLayoutS setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayoutS setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionViewsixth setCollectionViewLayout:flowLayoutS];
    [_collectionViewsixth setAllowsSelection:YES];
    
    //Seventh
    [_collectionViewSeventh registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierSeventh];
    _collectionViewSeventh.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout7 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout7 setItemSize:CGSizeMake(130, 170)];
    [flowLayout7 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout7 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionViewSeventh setCollectionViewLayout:flowLayout7];
    [_collectionViewSeventh setAllowsSelection:YES];
    
    //Eight
    [_collectionViewEighth registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierEighth];
    _collectionViewEighth.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout8 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout8 setItemSize:CGSizeMake(130, 170)];
    [flowLayout8 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout8 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionViewEighth setCollectionViewLayout:flowLayout8];
    [_collectionViewEighth setAllowsSelection:YES];
    
    //Ninth
    [_collectionViewNinth registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierNinth];
    _collectionViewNinth.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout9 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout9 setItemSize:CGSizeMake(130, 170)];
    [flowLayout9 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout9 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionViewNinth setCollectionViewLayout:flowLayout9];
    [_collectionViewNinth setAllowsSelection:YES];
    
    //Tenth
    [_collectionViewTenth registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierTenth];
    _collectionViewTenth.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout10 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout10 setItemSize:CGSizeMake(130, 170)];
    [flowLayout10 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout10 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionViewTenth setCollectionViewLayout:flowLayout10];
    [_collectionViewTenth setAllowsSelection:YES];
    
    //Eleventh
    [_collectionViewEleventh registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierEleventh];
    _collectionViewEleventh.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout11 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout11 setItemSize:CGSizeMake(130, 170)];
    [flowLayout11 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout11 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_collectionViewEleventh setCollectionViewLayout:flowLayout11];
    [_collectionViewEleventh setAllowsSelection:YES];
    
    
    //Recently Viewed
    [recentlyCollectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifierR];
    recentlyCollectionView.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayoutR = [[UICollectionViewFlowLayout alloc] init];
    [flowLayoutR setItemSize:CGSizeMake(130, 170)];
    [flowLayoutR setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayoutR setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [recentlyCollectionView setCollectionViewLayout:flowLayoutR];
    [recentlyCollectionView setAllowsSelection:YES];
    
    //initialization
    count=0;
    i=0;
    arrImageBanner=[[NSMutableArray alloc]init];
    arrProductNew=[[NSMutableArray alloc]init];
    arrProductMostSell=[[NSMutableArray alloc]init];
    arrProductFeatured=[[NSMutableArray alloc]init];
    arrProductForth=[[NSMutableArray alloc]init];
    arrProductFifth=[[NSMutableArray alloc]init];
    arrProductSixth=[[NSMutableArray alloc]init];
    arrProductSeventh=[[NSMutableArray alloc]init];
    arrProductEighth=[[NSMutableArray alloc]init];
    arrProductNinth=[[NSMutableArray alloc]init];
    arrProductTenth=[[NSMutableArray alloc]init];
    arrProductEleventh=[[NSMutableArray alloc]init];
    arrProductSlider=[[NSMutableArray alloc]init];
    arrCustomBanner=[NSMutableArray new];
    arr=[[NSMutableArray alloc]init];
    arrProducRecentlyViewed=[NSMutableArray new];
    currencyIcon=[[NSString alloc]init];
    model.custId= [[NSUserDefaults standardUserDefaults]valueForKey:@"Cust_id"];
    
    // Swipe Gesture
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGesture.numberOfTouchesRequired =1;
    leftSwipeGesture.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:rightSwipeGesture];
    [self.view addGestureRecognizer:leftSwipeGesture];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]==nil)
    //    {
    ////        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    ////        NSLog(@"%@",language);
    ////        if ([language isEqualToString:@"en"] || [language isEqualToString:@"ar"])
    ////        {
    ////            [[NSUserDefaults standardUserDefaults]setValue:language forKey:@"selectedLanguage"];
    ////        }
    ////        else
    ////        {
    //            [[NSUserDefaults standardUserDefaults]setValue:@"en" forKey:@"selectedLanguage"];
    ////        }
    //
    //        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]];
    //        LocalizationSetLanguage(str);
    //    }
    //    else
    //    {
    //        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]];
    //        LocalizationSetLanguage(str);
    //    }
    
    [super viewWillAppear:YES];
    
    [_topview setBackgroundColor:model.themeColor];
//    [_more1 setBackgroundColor:statusBarColor];
//    [_more2 setBackgroundColor:statusBarColor];
//    [_more3 setBackgroundColor:statusBarColor];
//    [_more4 setBackgroundColor:statusBarColor];
//    [_more5 setBackgroundColor:statusBarColor];
//    [_more6 setBackgroundColor:statusBarColor];
        [_more1 setBackgroundColor:[UIColor clearColor]];
        [_more2 setBackgroundColor:[UIColor clearColor]];
        [_more3 setBackgroundColor:[UIColor clearColor]];
        [_more4 setBackgroundColor:[UIColor clearColor]];
        [_more5 setBackgroundColor:[UIColor clearColor]];
        [_more6 setBackgroundColor:[UIColor clearColor]];
     [_more7 setBackgroundColor:[UIColor clearColor]];
     [_more8 setBackgroundColor:[UIColor clearColor]];
     [_more9 setBackgroundColor:[UIColor clearColor]];
     [_more10 setBackgroundColor:[UIColor clearColor]];
     [_more11 setBackgroundColor:[UIColor clearColor]];
    [pageControl setCurrentPageIndicatorTintColor:statusBarColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"HomeView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    }
    
    //     [self.view setUserInteractionEnabled:NO];
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        [self.view setUserInteractionEnabled:YES];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        
        //API call
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            // Perform long running process
            //[self addLoadingView];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                if (check==NO)
                {
                    [self addLoadingView];
                    [self.view setUserInteractionEnabled:NO];
                    check=YES;
                }
                
                [self getCategory];
                [self getHomePagedata];
            });
        });
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
        arrAdd=[NSArray arrayWithObjects:AMLocalizedString(@"tProfile", nil),AMLocalizedString(@"tMyOrders", nil),AMLocalizedString(@"tMyWishList", nil),AMLocalizedString(@"tMyDownloadables", nil),AMLocalizedString(@"tAppInfo", nil),AMLocalizedString(@"tNotifications", nil),AMLocalizedString(@"tLanguage", nil),AMLocalizedString(@"tLogout", nil) , nil];
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
        [tableView1 reloadData];
    }
    //[self.view bringSubviewToFront:tableView1];
    
    
    //rate app code
    BOOL neverRate = [[NSUserDefaults standardUserDefaults] boolForKey:@"neverRate"];
    
    BOOL itemPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"purchased"];
    
    BOOL remindLater = [[NSUserDefaults standardUserDefaults] boolForKey:@"RemindMeLater"];
    //[defaults setBool:YES forKey:@"purchased"];
    
    if ((neverRate != YES)||(remindLater))
    {
        if (itemPurchased)
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"purchased"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"tPleaseRateOnGoBuyo",nil)  message:AMLocalizedString(@"tIfyoulikeitwedliketoknow",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:AMLocalizedString(@"tRateItNow",nil),AMLocalizedString(@"tRemindMeLater",nil),AMLocalizedString(@"tNoThanks",nil), nil];
            alert.tag = 1;
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
    //color change
    
    [_topview setBackgroundColor:model.themeColor];
//    [_more1 setBackgroundColor:statusBarColor];
//    [_more2 setBackgroundColor:statusBarColor];
//    [_more3 setBackgroundColor:statusBarColor];
//    [_more4 setBackgroundColor:statusBarColor];
//    [_more5 setBackgroundColor:statusBarColor];
//    [_more6 setBackgroundColor:statusBarColor];
    [_more1 setBackgroundColor:[UIColor clearColor]];
    [_more2 setBackgroundColor:[UIColor clearColor]];
    [_more3 setBackgroundColor:[UIColor clearColor]];
    [_more4 setBackgroundColor:[UIColor clearColor]];
    [_more5 setBackgroundColor:[UIColor clearColor]];
    [_more6 setBackgroundColor:[UIColor clearColor]];
     [_more7 setBackgroundColor:[UIColor clearColor]];
     [_more8 setBackgroundColor:[UIColor clearColor]];
     [_more9 setBackgroundColor:[UIColor clearColor]];
     [_more10 setBackgroundColor:[UIColor clearColor]];
     [_more11 setBackgroundColor:[UIColor clearColor]];
    [pageControl setCurrentPageIndicatorTintColor:statusBarColor];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



#pragma mark - Swipe Gesture Functionality

-(void)handleSwipeGesture:(UISwipeGestureRecognizer *)leftSwipe
{
    if (leftSwipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        // swipe Left
        [self removeSideNav];
    }
    else
    {
        // swipe Right
        frame = self.mainView.frame;
        [UIView setAnimationDelegate:self];
        //        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView beginAnimations:@"slideMenu" context:(__bridge void *)(self.mainView)];
        frame.origin.x = 270;
        self.sideNav.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.view bringSubviewToFront:self.sideNav];
        menuOpen = YES;
        
        self.mainView.frame = frame;
        [UIView commitAnimations];
    }
    
    [self.tableView1 setHidden:YES];
}

#pragma mark Api Calls - Category Images

-(void)getCategory
{
    NSString *str=[NSString stringWithFormat:@"%@categorylist?salt=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,model.storeID,model.currencyID];
    ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(GetCategoryApi:)];
    
}

-(void)GetCategoryApi:(id)response
{
    NSLog(@"category response------%@",response);
    if ([[response valueForKey:@"response"]isKindOfClass:[NSArray class]])
    {
        //Package Check
        
        model.pkgType=[NSString stringWithFormat:@"%@",[response valueForKey:@"pkg_type"]];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[response valueForKey:@"pkg_type"]] forKey:@"package"];
        
        if([[[response valueForKey:@"response"]valueForKey:@"name"]count]>0)
        {
            model.arrMainCategory = [[response valueForKey:@"response"]valueForKey:@"name"];
            model.arrMainCategoryID = [[response valueForKey:@"response"]valueForKey:@"category_id"];
        }
        
        if([[[[response valueForKey:@"response"]valueForKey:@"children"]valueForKey:@"name"]count]>0)
        {
            model.arrSubCategory = [[[response valueForKey:@"response"]valueForKey:@"children"]valueForKey:@"name"];
            model.arrSubCategoryID = [[[response valueForKey:@"response"]valueForKey:@"children"]valueForKey:@"category_id"];
            
            arr3 = [NSMutableArray new];
            [arr3 addObjectsFromArray:model.arrSubCategory];
            
        }
        
        if(model.arrMainCategory.count>0)
        {
            arr1 = [[NSMutableArray alloc]initWithObjects:AMLocalizedString(@"tHome",nil),nil];
            [arr1 addObjectsFromArray:model.arrMainCategory];
            [self.tblView reloadData];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:   AMLocalizedString(@"tOopsSomethingwentwrong",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark Api Calls

-(void)getHomePagedata
{
    NSString *strVist=[NSString stringWithFormat:@"%@",model.visitorID];
    if([strVist isEqualToString:@"(null)"])
    {
        strVist=@"";
    }
    NSString *str=[NSString stringWithFormat:@"%@homePage?salt=%@&visitor_id=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strVist,model.storeID,model.currencyID];
    
    //---------------- API----------------------
    
    ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
    
    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_HomePage_API_Response:)];
}

#pragma mark Api Response

-(void)Get_HomePage_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    [self.view setUserInteractionEnabled:YES];
    
    NSLog(@"%@",responseDict);
    int y=0;
    
    if ([[responseDict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
    {
        arrProductSlider=[[responseDict valueForKey:@"response"] valueForKey:@"product_slider"];
        currencyIcon=[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"response"] valueForKey:@"currency_symbol"] ];
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currencySymbo"]!=nil)
        {
            model.currencySymbo=[[NSUserDefaults standardUserDefaults] valueForKey:@"currencySymbo"];
        }
        else
        {
            model.currencySymbo = [NSString stringWithFormat:@"%@",currencyIcon];
        }
        NSLog(@"%@",model.currencySymbo);
        
        model.visitorID = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"response"] valueForKey:@"visitor_id"]];
        
        if (arrImageBanner.count>0)
        {
            [arrImageBanner removeAllObjects];
        }
        if ([responseDict valueForKey:@"response"]!=nil)
        {
            arr=[[responseDict valueForKey:@"response"] valueForKey:@"slider"];
            
            if (arr.count!=0)
            {
                _mediaView.hidden=NO;
                
                for (int j=0; j<arr.count; j++)
                {
                    [arrImageBanner addObject:[[arr objectAtIndex:j]valueForKey:@"img"]];
                }
                pageControl.numberOfPages=arrImageBanner.count;
                
                if (![[arrImageBanner objectAtIndex:0]isEqualToString:@""])
                {
                    NSURL *imageurl=[NSURL URLWithString:[arrImageBanner objectAtIndex:0]];
                    [imagePage setImageURL:imageurl];
                    [imagePage TransformImage];
                }
                bannerButtons.tag=30;
                i=1;
                y=y+_mediaView.frame.size.height+3;
                [self changeBannerAutomatically];
            }
            else
            {
                _mediaView.hidden=YES;
                y=10;
            }
            
            //new arrival products
            long count3=arrProductSlider.count;
            int z=0;
            if (z<count3)
            {
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    NewArrView.hidden=NO;
                    NewArrView.frame=CGRectMake(_mediaView.frame.origin.x, y, NewArrView.frame.size.width, NewArrView.frame.size.height);
                    y=y+NewArrView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductNew=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    
                    NSString *strType=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [types setText:strType];
                    [types TransformAlignLabel];
                }
                else
                {
                    NewArrView.hidden=YES;
                }
                z++;
            }
            //most selling products
            
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    MostView.hidden=NO;
                    MostView.frame=CGRectMake(NewArrView.frame.origin.x, y, MostView.frame.size.width, MostView.frame.size.height);
                    y=y+MostView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductMostSell=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType1=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [typeMost setText:strType1];
                    [typeMost TransformAlignLabel];
                }
                else
                {
                    MostView.hidden=YES;
                    
                }
                z++;
            }
            //        custom banner2
            
            
            if ([[[responseDict valueForKey:@"response"]valueForKey:@"custom_banner"]count]!=0)
            {
                arrCustomBanner=[[responseDict valueForKey:@"response"]valueForKey:@"custom_banner"];
                
                if (![[[arrCustomBanner objectAtIndex:0]valueForKey:@"img"]isEqualToString:@""] && ![[[arrCustomBanner objectAtIndex:0]valueForKey:@"img"]isEqual:[NSNull null]])
                {
                    _mediaView2.hidden=NO;
                    _mediaView2.frame=CGRectMake(_mediaView2.frame.origin.x,y, _mediaView2.frame.size.width, _mediaView2.frame.size.height);
                    y=y+_mediaView2.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    NSURL *imageurl=[NSURL URLWithString:[[arrCustomBanner objectAtIndex:0]valueForKey:@"img"]];
                    [_customImg2 setImageURL:imageurl];
                    [_customImg2 TransformImage];
                }
                
                else
                {
                    _mediaView2.hidden=YES;
                }
                if(1 < arrCustomBanner.count)
                {
                    if (![[[arrCustomBanner objectAtIndex:1]valueForKey:@"img"]isEqualToString:@""] && ![[[arrCustomBanner objectAtIndex:1]valueForKey:@"img"]isEqual:[NSNull null]])
                    {
                        _mediaView3.hidden=NO;
                        _mediaView3.frame=CGRectMake(_mediaView3.frame.origin.x,y,_mediaView3.frame.size.width, _mediaView3.frame.size.height);
                        y=y+_mediaView3.frame.size.height+10;
                        if (Is_IPhone4)
                        {
                            [scrollView setContentSize:CGSizeMake(320,y+50)];
                        }
                        else
                        {
                            [scrollView setContentSize:CGSizeMake(320,y+10)];
                        }
                        NSURL *imageurl=[NSURL URLWithString:[[arrCustomBanner objectAtIndex:1]valueForKey:@"img"]];
                        [_customImg3 setImageURL:imageurl];
                        [_customImg3 TransformImage];
                    }
 
                }
                
                else
                {
                    _mediaView3.hidden=YES;
                }
                
            }
            
            
            //featured products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    FeaturedView.hidden=NO;
                    FeaturedView.frame=CGRectMake(MostView.frame.origin.x,y, FeaturedView.frame.size.width, FeaturedView.frame.size.height);
                    y=y+FeaturedView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductFeatured=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType3=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [typefeatured setText:strType3];
                    [typefeatured TransformAlignLabel];
                    
                }
                else
                {
                    FeaturedView.hidden=YES;
                }
                z++;
            }
            //Fourth products
            
            if ( z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _fourthView.hidden=NO;
                    _fourthView.frame=CGRectMake(FeaturedView.frame.origin.x, y, _fourthView.frame.size.width, _fourthView.frame.size.height);
                    y=y+_fourthView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductForth=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    
                    NSString *strType=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeFourth setText:strType];
                    [_typeFourth TransformAlignLabel];
                }
                else
                {
                    _fourthView.hidden=YES;
                }
                z++;
            }
            //        custom banner2
            
            

            if ([arrCustomBanner count]!=0)
            {
                if(2 < arrCustomBanner.count)
                {
                if (![[[arrCustomBanner objectAtIndex:2]valueForKey:@"img"]isEqualToString:@""] && ![[[arrCustomBanner objectAtIndex:2]valueForKey:@"img"]isEqual:[NSNull null]])
                {
                    _mediaView4.hidden=NO;
                    _mediaView4.frame=CGRectMake(_mediaView4.frame.origin.x,y, _mediaView4.frame.size.width, _mediaView4.frame.size.height);
                    y=y+_mediaView4.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    NSURL *imageurl=[NSURL URLWithString:[[arrCustomBanner objectAtIndex:2]valueForKey:@"img"]];
                    [_customImg4 setImageURL:imageurl];
                    [_customImg4 TransformImage];
                }
                }
                else
                {
                    _mediaView4.hidden=YES;
                }
                
                if(3 < arrCustomBanner.count)
                {
                if (![[[arrCustomBanner objectAtIndex:3]valueForKey:@"img"]isEqualToString:@""] && ![[[arrCustomBanner objectAtIndex:3]valueForKey:@"img"]isEqual:[NSNull null]])
                {
                    _mediaView5.hidden=NO;
                    _mediaView5.frame=CGRectMake(_mediaView5.frame.origin.x,y,_mediaView5.frame.size.width, _mediaView5.frame.size.height);
                    y=y+_mediaView5.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    NSURL *imageurl=[NSURL URLWithString:[[arrCustomBanner objectAtIndex:3]valueForKey:@"img"]];
                    [_customImg5 setImageURL:imageurl];
                    [_customImg5 TransformImage];
                }
                }
                else
                {
                    _mediaView5.hidden=YES;
                }
                
                if(4 < arrCustomBanner.count)
                {
                if (![[[arrCustomBanner objectAtIndex:4]valueForKey:@"img"]isEqualToString:@""] && ![[[arrCustomBanner objectAtIndex:4]valueForKey:@"img"]isEqual:[NSNull null]])
                {
                    _mediaView6.hidden=NO;
                    _mediaView6.frame=CGRectMake(_mediaView6.frame.origin.x,y,_mediaView6.frame.size.width, _mediaView6.frame.size.height);
                    y=y+_mediaView6.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    NSURL *imageurl=[NSURL URLWithString:[[arrCustomBanner objectAtIndex:4]valueForKey:@"img"]];
                    [_customImg6 setImageURL:imageurl];
                    [_customImg6 TransformImage];
                }
                }
                else
                {
                    _mediaView6.hidden=YES;
                }
                
            }
            
            
            //fifth products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _fifthView.hidden=NO;
                    _fifthView.frame=CGRectMake(_fourthView.frame.origin.x, y, _fifthView.frame.size.width, _fifthView.frame.size.height);
                    y=y+_fifthView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductFifth=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType1=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeFifth setText:strType1];
                    [_typeFifth TransformAlignLabel];
                    
                }
                else
                {
                    _fifthView.hidden=YES;
                    
                }
                z++;
            }
            
            
            
            //sixth products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _sixthView.hidden=NO;
                    _sixthView.frame=CGRectMake(_fifthView.frame.origin.x,y, _sixthView.frame.size.width, _sixthView.frame.size.height);
                    y=y+_sixthView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductSixth=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType3=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeSixth setText:strType3];
                    [_typeSixth TransformAlignLabel];
                }
                else
                {
                    _sixthView.hidden=YES;
                }
                z++;
            }
            
            //seventh products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _SeventhView.hidden=NO;
                    _SeventhView.frame=CGRectMake(_sixthView.frame.origin.x,y, _SeventhView.frame.size.width, _SeventhView.frame.size.height);
                    y=y+_SeventhView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductSeventh=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType3=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeSeventh setText:strType3];
                    [_typeSeventh TransformAlignLabel];
                }
                else
                {
                    _SeventhView.hidden=YES;
                }
                z++;
            }
            
            //Eighth products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _eighthView.hidden=NO;
                    _eighthView.frame=CGRectMake(_SeventhView.frame.origin.x,y, _eighthView.frame.size.width, _eighthView.frame.size.height);
                    y=y+_eighthView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductEighth=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType3=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeEighth setText:strType3];
                    [_typeEighth TransformAlignLabel];
                }
                else
                {
                    _eighthView.hidden=YES;
                }
                z++;
            }
            
            //Ninth products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _ninthView.hidden=NO;
                    _ninthView.frame=CGRectMake(_eighthView.frame.origin.x,y, _ninthView.frame.size.width, _ninthView.frame.size.height);
                    y=y+_ninthView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductNinth=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType3=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeNinth setText:strType3];
                    [_typeNinth TransformAlignLabel];
                }
                else
                {
                    _ninthView.hidden=YES;
                }
                z++;
            }
            
            //Tenth products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _tenthView.hidden=NO;
                    _tenthView.frame=CGRectMake(_ninthView.frame.origin.x,y, _tenthView.frame.size.width, _tenthView.frame.size.height);
                    y=y+_tenthView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductTenth=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType3=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeTenth setText:strType3];
                    [_typeTenth TransformAlignLabel];
                }
                else
                {
                    _tenthView.hidden=YES;
                }
                z++;
            }
            
            //Eleventh products
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    _eleventhView.hidden=NO;
                    _eleventhView.frame=CGRectMake(_tenthView.frame.origin.x,y, _eleventhView.frame.size.width, _eleventhView.frame.size.height);
                    y=y+_eleventhView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProductEleventh=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType3=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [_typeEleventh setText:strType3];
                    [_typeEleventh TransformAlignLabel];
                }
                else
                {
                    _eleventhView.hidden=YES;
                }
                z++;
            }
            
            //recently Viewed product
            if (z<count3)
            {
                
                if ([[[arrProductSlider objectAtIndex:z]valueForKey:@"product"]count]!=0)
                {
                    recentView.hidden=NO;
                    recentView.frame=CGRectMake(recentView.frame.origin.x, y, recentView.frame.size.width, recentView.frame.size.height);
                    y=y+recentView.frame.size.height+10;
                    if (Is_IPhone4)
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+50)];
                    }
                    else
                    {
                        [scrollView setContentSize:CGSizeMake(320,y+10)];
                    }
                    arrProducRecentlyViewed=[[arrProductSlider objectAtIndex:z]valueForKey:@"product"];
                    NSString *strType4=[[arrProductSlider objectAtIndex:z]valueForKey:@"type"];
                    [typeRecntlyViewd setText:strType4];
                    [typeRecntlyViewd TransformAlignLabel];
                }
                else
                {
                    recentView.hidden=YES;
                }
            }
            [collectionViewMost reloadData];
            [collectionViewFeat reloadData];
            [collectionview reloadData];
            [_collectionFourth reloadData];
            [_collectionViewFifth reloadData];
            [_collectionViewsixth reloadData];
            [_collectionViewSeventh reloadData];
              [_collectionViewEighth reloadData];
              [_collectionViewNinth reloadData];
              [_collectionViewTenth reloadData];
              [_collectionViewEleventh reloadData];
            [recentlyCollectionView reloadData];
            
            //subscription
            
            NSDictionary *dict = [[NSDictionary alloc]init];
            dict = [[responseDict valueForKey:@"response"] valueForKey:@"subscription"];
            bool subscribeApp = [dict valueForKey:@"subs_closed"];
            
            if (!subscribeApp)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tWaitForSubscriptionoftheapp",nil) delegate:self cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles: nil];
                alert.tag  = 2;
                [alert show];
            }
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong",nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil];
        [alert show];
        
    }
}

#pragma mark Helper methods

-(void)changeBannerAutomatically
{
   
    [timer invalidate];
     timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(changeSlideImage:) userInfo:nil repeats:YES];
}

#pragma mark PageControl Action Method

- (IBAction)changeSlideImage:(id)sender
{
    if (i<arrImageBanner.count)
    {
        if (![[arrImageBanner objectAtIndex:i]isEqualToString:@""])
        {
            NSURL *imageurl=[NSURL URLWithString:[arrImageBanner objectAtIndex:i]];
            [imagePage setImageURL:imageurl];
        }
        
        //        [imagePage sd_setImageWithURL:[arrImageBanner objectAtIndex:i] placeholderImage:nil];
        pageControl.currentPage=i;
        bannerButtons.tag=i+30;
        
        if (i==arrImageBanner.count-1)
        {
            i=0;
        }
        else
        {
            i++;
        }
    }
}

#pragma mark Swipe gesture Handlers

- (IBAction)handleRight:(id)sender
{
    NSLog(@"Right");
    NSLog(@"%li",(long)pageControl.currentPage);
    
    long p=pageControl.currentPage;
    if (p==0)
    {
        NSInteger n=arrImageBanner.count;
        if (![[arrImageBanner objectAtIndex:n-1]isEqualToString:@""])
        {
            NSURL *imageurl=[NSURL URLWithString:[arrImageBanner objectAtIndex:n-1]];
            [imagePage setImageURL:imageurl];
        }
        
        //       [imagePage sd_setImageWithURL:[arrImageBanner objectAtIndex:n-1]  placeholderImage:nil];
        pageControl.currentPage=n-1;
        bannerButtons.tag=n-1+30;
        
    }
    else
    {
        if (![[arrImageBanner objectAtIndex:p-1]isEqualToString:@""])
        {
            NSURL *imageurl=[NSURL URLWithString:[arrImageBanner objectAtIndex:p-1]];
            [imagePage setImageURL:imageurl];
        }
        //      [imagePage sd_setImageWithURL:[arrImageBanner objectAtIndex:p-1] placeholderImage:nil];
        pageControl.currentPage=p-1;
        bannerButtons.tag=p-1+30;
    }
}

- (IBAction)handleLeft:(id)sender
{
    NSLog(@"left");
    NSInteger p=pageControl.currentPage;
    if (p==arrImageBanner.count-1)
    {
        if (![[arrImageBanner objectAtIndex:0]isEqualToString:@""])
        {
            NSURL *imageurl=[NSURL URLWithString:[arrImageBanner objectAtIndex:0]];
            [imagePage setImageURL:imageurl];
        }
        //        [imagePage sd_setImageWithURL:[arrImageBanner objectAtIndex:0] placeholderImage:nil];
        pageControl.currentPage=0;
        bannerButtons.tag=30;
    }
    else
    {
        if (![[arrImageBanner objectAtIndex:p+1]isEqualToString:@""])
        {
            NSURL *imageurl=[NSURL URLWithString:[arrImageBanner objectAtIndex:p+1]];
            [imagePage setImageURL:imageurl];
        }
        //        [imagePage sd_setImageWithURL:[arrImageBanner objectAtIndex:p+1] placeholderImage:nil];
        pageControl.currentPage=p+1;
        bannerButtons.tag=p+1+30;
    }
}

#pragma mark- Collection View DataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==collectionview)
    {
        return [arrProductNew count];
    }
    else if (collectionView==collectionViewMost)
    {
        return [arrProductMostSell count];
    }
    else if (collectionView==collectionViewFeat)
    {
        return [arrProductFeatured count];
    }
    else if (collectionView==_collectionFourth)
    {
        return [arrProductForth count];
    }
    else if (collectionView==_collectionViewFifth)
    {
        return [arrProductFifth count];
    }
    else if (collectionView==_collectionViewsixth)
    {
        return [arrProductSixth count];
    }
    else if (collectionView==_collectionViewSeventh)
    {
        return [arrProductSeventh count];
    }
    else if (collectionView==_collectionViewEighth)
    {
        return [arrProductEighth count];
    }
    else if (collectionView==_collectionViewNinth)
    {
        return [arrProductNinth count];
    }
    else if (collectionView==_collectionViewTenth)
    {
        return [arrProductTenth count];
    }
    else if (collectionView==_collectionViewEleventh)
    {
        return [arrProductEleventh count];
    }
    else if (collectionView==recentlyCollectionView)
    {
        return [arrProducRecentlyViewed count];
    }
    else return 0;
    
}

- (CollectionCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    if (collectionView==collectionview)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        [cell.productImage sd_setImageWithURL:[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        if (![[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        cell.productName.text=[[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if ([[[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            cell.productOff.attributedText=attrText;
            
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else  if (collectionView==collectionViewMost)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierM forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        [cell.productImage sd_setImageWithURL:[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //        cell.borderImage.layer.cornerRadius=4;
        //        cell.borderImage.layer.borderWidth=1;
        //        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        if (![[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        cell.productName.text=[[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if ([[[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else if (collectionView==collectionViewFeat)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierF forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        [cell.productImage sd_setImageWithURL:[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //    cell.borderImage.layer.cornerRadius=4;
        //    cell.borderImage.layer.borderWidth=1;
        //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        cell.productName.text=[[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if (![[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        
        if ([[[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else  if (collectionView==_collectionFourth)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierFour forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        [cell.productImage sd_setImageWithURL:[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        if (![[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        cell.productName.text=[[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if ([[[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            cell.productOff.attributedText=attrText;
            
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        
        return cell;
    }
    else  if (collectionView==_collectionViewFifth)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierFifth forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //        cell.borderImage.layer.cornerRadius=4;
        //        cell.borderImage.layer.borderWidth=1;
        //        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        if (![[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        cell.productName.text=[[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if ([[[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"final_price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else if (collectionView==_collectionViewsixth)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierSixth forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //    cell.borderImage.layer.cornerRadius=4;
        //    cell.borderImage.layer.borderWidth=1;
        //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        cell.productName.text=[[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if (![[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        
        if ([[[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else if (collectionView==_collectionViewSeventh)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierSeventh forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //    cell.borderImage.layer.cornerRadius=4;
        //    cell.borderImage.layer.borderWidth=1;
        //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        cell.productName.text=[[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if (![[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        
        if ([[[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else if (collectionView==_collectionViewEighth)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierEighth forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //    cell.borderImage.layer.cornerRadius=4;
        //    cell.borderImage.layer.borderWidth=1;
        //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        cell.productName.text=[[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if (![[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        
        if ([[[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else if (collectionView==_collectionViewNinth)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierNinth forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //    cell.borderImage.layer.cornerRadius=4;
        //    cell.borderImage.layer.borderWidth=1;
        //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        cell.productName.text=[[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if (![[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        
        if ([[[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    else if (collectionView==_collectionViewTenth)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierTenth forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //    cell.borderImage.layer.cornerRadius=4;
        //    cell.borderImage.layer.borderWidth=1;
        //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        cell.productName.text=[[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if (![[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        
        if ([[[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    
    
    else if (collectionView==_collectionViewEleventh)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierEleventh forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        //    cell.borderImage.layer.cornerRadius=4;
        //    cell.borderImage.layer.borderWidth=1;
        //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        cell.productName.text=[[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        if (![[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        
        if ([[[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        return cell;
    }
    
    else if (collectionView==recentlyCollectionView)
    {
        CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifierR forIndexPath:indexPath];
        cell.borderImage.layer.cornerRadius=4;
        cell.borderImage.layer.borderWidth=1;
        cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //rtl
        [cell.productImage TransformImage];
        [cell.productOff TransformLabel];
        [cell.productName TransformLabel];
        [cell.productPrice TransformLabel];
        [cell.orderImg TransformButton];
        
        
        [cell.productImage sd_setImageWithURL:[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
        
        if (![[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
        {
            cell.orderImg.hidden=NO;
            [cell.orderImg setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff",nil)] forState:UIControlStateNormal];
        }
        else
        {
            cell.orderImg.hidden=YES;
        }
        
        cell.productName.text=[[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"name"]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        if ([[[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"price"]stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            
            cell.productOff.hidden=NO;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x,152.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        else
        {
            cell.productOff.hidden=YES;
            
            cell.productPrice.frame=CGRectMake(cell.productPrice.frame.origin.x, 135.0, cell.productPrice.frame.size.width, cell.productPrice.frame.size.height);
        }
        cell.productPrice.textColor=model.greenClr;
        cell.productPrice.text=[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
        
        return cell;
    }
    
    else
        return 0;
}

#pragma mark- Collection View Delegate

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
    if (collectionView==collectionview)
    {
        objViewController.strProdId=[[arrProductNew objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==collectionViewMost)
    {
        objViewController.strProdId=[[arrProductMostSell objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==collectionViewFeat)
    {
        objViewController.strProdId=[[arrProductFeatured objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    
    else if (collectionView==_collectionFourth)
    {
        objViewController.strProdId=[[arrProductForth objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==_collectionViewFifth)
    {
        objViewController.strProdId=[[arrProductFifth objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==_collectionViewsixth)
    {
        objViewController.strProdId=[[arrProductSixth objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==_collectionViewSeventh)
    {
        objViewController.strProdId=[[arrProductSeventh objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==_collectionViewEighth)
    {
        objViewController.strProdId=[[arrProductEighth objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==_collectionViewNinth)
    {
        objViewController.strProdId=[[arrProductNinth objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==_collectionViewTenth)
    {
        objViewController.strProdId=[[arrProductTenth objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==_collectionViewEleventh)
    {
        objViewController.strProdId=[[arrProductEleventh objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    else if (collectionView==recentlyCollectionView)
    {
        objViewController.strProdId=[[arrProducRecentlyViewed objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    }
    
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

#pragma mark View more Methods

- (IBAction)viewMore:(id)sender
{
    UIButton *button=(UIButton*)sender;
    
    ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
    
    if (button.tag==11)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:0]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:0]valueForKey:@"type"]];
    }
    else if (button.tag==12)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:1]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:1]valueForKey:@"type"]];
    }
    else if (button.tag==13)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:2]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:2]valueForKey:@"type"]];
    }
    else if (button.tag==14)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:3]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:3]valueForKey:@"type"]];
    }
    else if (button.tag==15)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:4]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:4]valueForKey:@"type"]];
    }
    else if (button.tag==16)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:5]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:5]valueForKey:@"type"]];
    }
    else if (button.tag==17)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:6]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:6]valueForKey:@"type"]];
    }
    else if (button.tag==18)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:7]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:7]valueForKey:@"type"]];
    }
    else if (button.tag==19)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:8]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:8]valueForKey:@"type"]];
    }
    else if (button.tag==20)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:9]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:9]valueForKey:@"type"]];
    }
    else if (button.tag==21)
    {
        objViewController.strPrevious=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:10]valueForKey:@"type_id"]];
        objViewController.strName=[NSString stringWithFormat:@"%@",[[arrProductSlider objectAtIndex:10]valueForKey:@"type"]];
    }
    
    
    [self.navigationController pushViewController:objViewController animated:YES];
    
    objViewController = nil;
}

#pragma mark - Search Button Action

- (IBAction)searchBtn_Action:(id)sender
{
    SearchViewController * obj = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - Side Menu Button Action

- (IBAction)sideMenuBtn_Action:(id)sender
{
    frame = self.mainView.frame;
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector( animationDidStop:finished:context: )];
    [UIView beginAnimations:@"slideMenu" context:(__bridge void *)(self.mainView)];
    
    if(menuOpen)
    {
        frame.origin.x = 0;
        [self.view bringSubviewToFront:self.mainView];
        menuOpen = NO;
    }
    else
    {
        frame.origin.x = 270;
        self.sideNav.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.view bringSubviewToFront:self.sideNav];
        menuOpen = YES;
    }
    
    self.mainView.frame = frame;
    [UIView commitAnimations];
    [self.tableView1 setHidden:YES];
}

-(void)removeSideNav
{
    frame = self.mainView.frame;
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector( animationDidStop:finished:context: )];
    [UIView beginAnimations:@"slideMenu" context:(__bridge void *)(self.mainView)];
    
    frame.origin.x = 0;
    menuOpen = NO;
    [self.view bringSubviewToFront:self.mainView];
    [self.view addSubview:tableView1];
    
    self.mainView.frame = frame;
    [UIView commitAnimations];
    
}


#pragma mark - App Info Button Action

- (IBAction)appInfoBtn_Action:(id)sender
{
    //    if (clicked==NO)
    //    {
    tableView1.hidden=NO;
    
    [tableView1 setFrame:CGRectMake(140, 28, 170,delegate.arrOptions.count*35)];
    tableView1.layer.masksToBounds = YES;
    tableView1.layer.cornerRadius = 4.0;
    tableView1.layer.borderWidth = 1.0;
    tableView1.layer.borderColor=[[UIColor clearColor]CGColor];
    
    NSLog(@"views hierachy-----%@",self.view.subviews);
    
    //   [self.view addSubview:tableView1];
    //[self.view bringSubviewToFront:tableView1];
    //[self.mainView bringSubviewToFront:tableView1];
    [self removeSideNav];
    clicked=YES;
    
}

#pragma mark Banner Button Methods

- (IBAction)BannerButton:(id)sender
{
    UIButton *button =(UIButton*)sender;
    if ([arr isKindOfClass:[NSArray class]])
    {
        if([[[arr objectAtIndex:button.tag-30]valueForKey:@"link_type"] isEqualToString:@"category"])
        {
            if ([[[arr objectAtIndex:button.tag-30]valueForKey:@"has_link"] intValue]==1)
            {
                ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
                objViewController.strName=@"Products";
                objViewController.apiType = @"SearchApi";
                objViewController.categoryID=[[arr objectAtIndex:button.tag-30]valueForKey:@"link_val"];
                
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
        else if ([[[arr objectAtIndex:button.tag-30]valueForKey:@"link_type"] isEqualToString:@"product"])
        {
            if ([[[arr objectAtIndex:button.tag-30]valueForKey:@"has_link"] intValue]==1)
            {
                ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
                NSString *str=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:button.tag-30]valueForKey:@"link_val"]];
                
                NSRange range = [str rangeOfString:@"#"];
                NSString *newString = [str substringToIndex:range.location];
                NSLog(@"%@",newString);
                
                objViewController.strProdId=newString;
                [self.navigationController pushViewController:objViewController animated:YES];
                
                objViewController = nil;
            }
        }
        else if ([[[arr objectAtIndex:button.tag-30]valueForKey:@"link_type"] isEqualToString:@"custom"])
        {
            if ([[[arr objectAtIndex:button.tag-30]valueForKey:@"has_link"] intValue]==1)
            {
                CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
                
                objViewController.urlToDisplay=[[arr objectAtIndex:button.tag-30]valueForKey:@"link_val"];
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
        else if ([[[arr objectAtIndex:button.tag-30]valueForKey:@"link_type"] isEqualToString:@"page"])
        {
            if ([[[arr objectAtIndex:button.tag-30]valueForKey:@"has_link"] intValue]==1)
            {
                CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
                objViewController.urlToDisplay=[[arr objectAtIndex:button.tag-30]valueForKey:@"link_val"];
                objViewController.strPrev=@"page";
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
    }
}

- (IBAction)CustomBannerButton:(id)sender
{
    UIButton *button =(UIButton*)sender;
    if ([arrCustomBanner isKindOfClass:[NSArray class]])
    {
        if([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"link_type"] isEqualToString:@"category"])
        {
            if ([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"has_link"] intValue]==1)
            {
                ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
                objViewController.strName=@"Products";
                objViewController.apiType = @"SearchApi";
                objViewController.categoryID=[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"link_val"];
                
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
        else if ([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"link_type"] isEqualToString:@"product"])
        {
            if ([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"has_link"] intValue]==1)
            {
                ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
                NSString *str=[NSString stringWithFormat:@"%@",[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"link_val"]];
                
                NSRange range = [str rangeOfString:@"#"];
                NSString *newString = [str substringToIndex:range.location];
                NSLog(@"%@",newString);
                
                objViewController.strProdId=newString;
                [self.navigationController pushViewController:objViewController animated:YES];
                
                objViewController = nil;
            }
        }
        else if ([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"link_type"] isEqualToString:@"custom"])
        {
            if ([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"has_link"] intValue]==1)
            {
                CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
                
                objViewController.urlToDisplay=[[arrCustomBanner objectAtIndex:button.tag-30]valueForKey:@"link_val"];
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
        else if ([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"link_type"] isEqualToString:@"page"])
        {
            if ([[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"has_link"] intValue]==1)
            {
                CustomView *objViewController = [[CustomView alloc]initWithNibName:@"CustomView" bundle:nil];
                objViewController.urlToDisplay=[[arrCustomBanner objectAtIndex:button.tag-40]valueForKey:@"link_val"];
                objViewController.strPrev=@"page";
                [self.navigationController pushViewController:objViewController animated:YES];
                objViewController = nil;
            }
        }
    }
}


#pragma mark Table View Delegate & Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tblView)
    {
        return [arr1 count];
    }
    else
    {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView == self.tblView)
    {
        if (self.isOpen)
        {
            if (self.selectIndex.section == section)
            {
                return [arr2 count]+1;
            }
        }
        return 1;
    }
    else
    {
        return [delegate.arrOptions count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblView)
    {
        if (self.isOpen && self.selectIndex.section == indexPath.section&&indexPath.row!=0)
        {
            NSLog(@"row selected second");
            
            static NSString *CellIdentifier = @"TableCollaspe";
            TableCollaspe *cell = (TableCollaspe*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentName.text = [arr2 objectAtIndex:indexPath.row-1];
            cell.contentName.textColor = [UIColor colorwithHexString:@"555555" alpha:1.0];
            [cell.contentName TransformAlignLabel];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            tableView.separatorColor = [UIColor clearColor];
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"TableMain";
            TableMain *cell = (TableMain*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            //            TableMain *cell = [[TableMain alloc]init];
            if (cell==nil )
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSLog(@"row selected first");
            cell.userName.text = [arr1 objectAtIndex:indexPath.section];
            cell.userName.textColor = [UIColor colorwithHexString:@"ff7d00" alpha:1.0];

            
            [cell.userName TransformAlignLabel];// rtl
            if(indexPath.section != 0)
            {
                NSArray * str = [arr3 objectAtIndex:indexPath.section-1];
                
                if(str.count!=0)
                {
                    if (indexPath.section==indexSection)
                    {
                        [cell.btnPlus setImage:[UIImage imageNamed:@"ic_minus.png"] forState:UIControlStateNormal];
                   
                        
                      //  cell.imgBackGround.backgroundColor=model.themeColor;
                        cell.imgBackGround.backgroundColor=[UIColor whiteColor];
                        cell.userName.textColor = [UIColor colorwithHexString:@"ff7d00" alpha:1.0];

                    }
                    else
                    {
                        [cell.btnPlus setImage:[UIImage imageNamed:@"ic_plus.png"] forState:UIControlStateNormal];
                        
                        cell.imgBackGround.backgroundColor=[UIColor whiteColor];
                        
                        cell.userName.textColor=[UIColor colorwithHexString:@"ff7d00" alpha:1.0];
                    }
                    [cell.btnPlus setHidden:NO];
                    cell.btnPlus.tag = indexPath.section;
                    cell.imgBackGround.tag = indexPath.section+111;
                    cell.userName.tag = indexPath.section+222;
                }
                else
                {
                    [cell.btnPlus setHidden:YES];
                }
            }
            else
            {
                [cell.btnPlus setHidden:YES];
            }
            return cell;
        }
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
        [cell.textLabel TransformAlignLabel];
        cell.textLabel.text=[delegate.arrOptions objectAtIndex:indexPath.row];
        cell.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblView)
    {
        if (self.isOpen && self.selectIndex.section == indexPath.section&&indexPath.row!=0)
        {
            return 35.0;
        }
        else
        {
            return 44.0;
        }
    }
    else
    {
        return 35.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblView)
    {
        if (indexPath.row == 0)
        {
            if ([indexPath isEqual:self.selectIndex])
            {
                countArray =(int) [arr2 count];
                
                if(arr2.count>0)
                {
                    [arr2 removeAllObjects];
                }
                
                [(UIButton *)[self.view viewWithTag:indexPath.section]setImage:[UIImage imageNamed:@"ic_plus.png"] forState:UIControlStateNormal];
                
                [(UIImageView*)[self.view viewWithTag:indexSection1]setBackgroundColor:[UIColor whiteColor]];
                
                [(UILabel *)[self.view viewWithTag:indexPath.section+222]setTextColor:[UIColor colorwithHexString:@"ff7d00" alpha:1.0]];
                
                self.isOpen = NO;
                [self didSelectCellRowFirstDo:NO nextDo:NO];
                self.selectIndex = nil;
                
                NSArray * arr33 = [model.arrSubCategory objectAtIndex:indexPath.section-1];
                if(arr33.count == 0)
                {
                    ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
                    
                    NSString * categoryMainID = [model.arrMainCategoryID objectAtIndex:indexPath.section-1];
                    NSString * categoryMainName = [model.arrMainCategory objectAtIndex:indexPath.section-1];
                    objViewController.categoryID = categoryMainID;
                    objViewController.apiType = @"SearchApi";
                    objViewController.strName = categoryMainName;
                    
                    [self.navigationController pushViewController:objViewController animated:YES];
                    [self removeSideNav];
                }
            }
            else
            {
                if(arr2.count>0)
                {
                    countArray = (int)[arr2 count];
                }
                if(indexPath.section == 0)
                {
                    NSLog(@"indexPath");
                    ViewController * obj = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
                    [self.navigationController pushViewController:obj animated:YES];
                    [self removeSideNav];
                }
                else
                {
                    NSArray * arr33 = [model.arrSubCategory objectAtIndex:indexPath.section-1];
                    
                    if(arr33.count>0)
                    {
                        arr2 = [NSMutableArray new];
                        [arr2 addObjectsFromArray:arr33];
                    }
                    else
                    {
                        [arr2 removeAllObjects];
                        
                        ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
                        
                        NSString * categoryMainID = [model.arrMainCategoryID objectAtIndex:indexPath.section-1];
                        NSString * categoryMainName = [model.arrMainCategory objectAtIndex:indexPath.section-1];
                        objViewController.categoryID = categoryMainID;
                        objViewController.apiType = @"SearchApi";
                        objViewController.strName = categoryMainName;
                        
                        [self.navigationController pushViewController:objViewController animated:YES];
                        [self removeSideNav];
                        
                    }
                    if (!self.selectIndex)
                    {
                        self.selectIndex = indexPath;
                        indexSection = (int)indexPath.section;
                        indexSection1 =(int) indexPath.section+111;
                        indexSection2 =(int) indexPath.section+222;
                        
                        [(UIButton *)[self.view viewWithTag:indexPath.section]setImage:[UIImage imageNamed:@"ic_minus.png"] forState:UIControlStateNormal];
                        
                        clickedCategory=indexPath.section;
                        
                        [(UIImageView*)[self.view viewWithTag:indexPath.section+111]setBackgroundColor:[UIColor whiteColor]];
                        
                        [(UILabel *)[self.view viewWithTag:indexPath.section+222]setTextColor:[UIColor colorwithHexString:@"0c743f" alpha:1.0]];
                        [self didSelectCellRowFirstDo:YES nextDo:NO];
                    }
                    else
                    {
                        [(UIButton *)[self.view viewWithTag:indexPath.section]setImage:[UIImage imageNamed:@"ic_minus.png"] forState:UIControlStateNormal];
                        
                        [(UIImageView*)[self.view viewWithTag:indexPath.section+111]setBackgroundColor:[UIColor whiteColor]];
                        
                        [(UILabel *)[self.view viewWithTag:indexPath.section+222]setTextColor:[UIColor colorwithHexString:@"0c743f" alpha:1.0]];
                        
                        [(UIButton *)[self.view viewWithTag:indexSection]setImage:[UIImage imageNamed:@"ic_plus.png"] forState:UIControlStateNormal];
                        
                        [(UIImageView*)[self.view viewWithTag:indexSection1]setBackgroundColor:[UIColor clearColor]];
                        
                        [(UILabel *)[self.view viewWithTag:indexSection2]setTextColor:[UIColor colorwithHexString:@"ff7d00" alpha:1.0]];
                        
                        indexSection = (int)indexPath.section;
                        indexSection1 =(int) indexPath.section+111;
                        indexSection2 = (int)indexPath.section+222;
                        [self didSelectCellRowFirstDo:NO nextDo:YES];
                    }
                }
            }
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if(indexPath.row!=0)
        {
            NSLog(@"value");
            ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
            NSArray * arrSubVlue = [model.arrSubCategoryID objectAtIndex:indexPath.section-1];
            NSArray * arrSubName = [model.arrSubCategory objectAtIndex:indexPath.section-1];
            
            if(arrSubVlue.count!=0)
            {
                NSString * categorySubID = [arrSubVlue objectAtIndex:indexPath.row-1];
                
                NSString * categoryName = [arrSubName objectAtIndex:indexPath.row-1];
                objViewController.categoryID = categorySubID;
                objViewController.apiType = @"SearchApi";
                objViewController.strName = categoryName;
                [self.navigationController pushViewController:objViewController animated:YES];
            }
            [self removeSideNav];
        }
    }
    else
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
            obj.strPage=@"Home";
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
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"logout"];
            
            [self.lblCount setHidden:YES];
            
            if (delegate.arrOptions.count!=0)
            {
                [delegate.arrOptions removeAllObjects];
            }
            [delegate.arrOptions addObject:AMLocalizedString(@"tLogin",nil)];
            [delegate.arrOptions addObject:AMLocalizedString(@"tAppInfo",nil)];
            [delegate.arrOptions addObject:AMLocalizedString(@"tLanguage",nil)];
            
            [tableView1 reloadData];
        }
        [self.tableView1 setHidden:YES];
        [self removeSideNav];
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    [self.tblView beginUpdates];
    
    long section = self.selectIndex.section;
    
    long contentCount = [arr2 count];
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    
    for (NSUInteger i1=1; i1<contentCount + 1; i1++)
    {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i1 inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {
        [self.tblView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        if(rowToInsert.count>0)
        {
            [rowToInsert removeAllObjects];
        }
        
        for (NSUInteger i1=1; i1<countArray+1; i1++)
        {
            NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i1 inSection:section];
            [rowToInsert addObject:indexPathToInsert];
        }
        
        [self.tblView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
        
        if(arr2.count == 0)
        {
            countArray = 0;
        }
    }
    
    [self.tblView endUpdates];
    
    if (nextDoInsert)
    {
        self.isOpen = YES;
        self.selectIndex = [self.tblView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    
    if (self.isOpen)
    {
        
        //[btnFav setHidden:TRUE];
        //UIButton *btnEdit = (UIButton*)[self.view viewWithTag:kBtnEditHonkTag];
        //[btnEdit setHidden:FALSE];
        [self.tblView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        // UIButton *btnFav = (UIButton*)[self.view viewWithTag:kBtnFavRecentTag];
        // [btnFav setHidden:FALSE];
        //  UIButton *btnEdit = (UIButton*)[self.view viewWithTag:kBtnEditHonkTag];
        // [btnEdit setHidden:TRUE];
    }
}

#pragma mark - CartDetail Button Action

- (IBAction)cartDetailBtn_Action:(id)sender
{
    NSString * str =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"quote_count"]];
    NSLog(@"str quote_count == %@",str);
    if(![str isEqualToString:@"0"] && ![str isEqualToString:@"(null)"])
    {
        [self removeSideNav];
        AddToCartView * obj = [[AddToCartView alloc]initWithNibName:@"AddToCartView" bundle:nil];
        
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:AMLocalizedString(@"tYourCartIsEmpty",nil) message:nil delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK",nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark ---Touch Events---

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView1 setHidden:YES];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeSideNav];
    [self.tableView1 setHidden:YES];
}

#pragma mark alertView delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==1)
    {
        if (buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1122055336&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]]];
        }
        
        else if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RemindMeLater"];
        }
        
        else if (buttonIndex == 2)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverRate"];
        }
    }
    else if (alertView.tag==2)
    {
        if (buttonIndex == 0)
        {
            exit(0);
        }
    }
    
}

@end
