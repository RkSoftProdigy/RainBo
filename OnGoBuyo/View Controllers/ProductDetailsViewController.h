//
//  ProductDetailsViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/10/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"
@class AppDelegate;

@interface ProductDetailsViewController : UIViewController<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate>
{
    
    IBOutlet UIActivityIndicatorView *indicator;
    __weak IBOutlet UILabel *optionLbl1;
    __weak IBOutlet UILabel *groupedLbl;
    __weak IBOutlet UILabel *reviewLbl;
    __weak IBOutlet UILabel *orLbl;
    __weak IBOutlet UILabel *relatedLbl;
    __weak IBOutlet UILabel *additionalLbl;
    __weak IBOutlet UILabel *descriptionLbl;
    __weak IBOutlet UIButton *doneLbl;
    __weak IBOutlet UILabel *linkLbl;
    __weak IBOutlet UILabel *optionLbl2;
    
}
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) IBOutlet UIWebView *descriptionWEB;

//color change

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *itLooksLbl;


//From previous page

@property (strong,nonatomic) NSString *strProdId;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;

// Delivery options
@property (weak, nonatomic) IBOutlet UILabel *deliveryOptionLbl;
@property (strong, nonatomic) IBOutlet UIView *deliveryOptionView;
@property (weak, nonatomic) IBOutlet UITextField *pinCode;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *deliveryOrder;
@property (weak, nonatomic) IBOutlet UIImageView *shippingImg;
@property (weak, nonatomic) IBOutlet UILabel *shipLabel;
@property (weak, nonatomic) IBOutlet UILabel *codlabel;
@property (weak, nonatomic) IBOutlet UILabel *DeliveryDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *samedayDispatchLbl;
@property (weak, nonatomic) IBOutlet UIImageView *deliveryImg;
@property (weak, nonatomic) IBOutlet UIImageView *optionImage;

@property (weak, nonatomic) IBOutlet UIImageView *cODImg;
- (IBAction)checkPincode:(id)sender;

//firstPart

@property (strong, nonatomic) IBOutlet UIImageView *productBorder;
@property (strong, nonatomic) IBOutlet UIImageView *productImages;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *inStock;
@property (strong, nonatomic) IBOutlet UILabel *productsName;
@property (strong, nonatomic) IBOutlet UILabel *productsPrice;
@property (strong, nonatomic) IBOutlet UILabel *productsOff;
@property (strong, nonatomic) IBOutlet UIButton *buttonOnImage;
@property (weak, nonatomic) IBOutlet UIButton *orderImage;

// Custom Banner
@property (strong, nonatomic) IBOutlet UIView *customBannerView;
@property (weak, nonatomic) IBOutlet RemoteImageView *customImg;


//configurable products

@property (strong, nonatomic) IBOutlet UIView *selectionView;

// Grouped products

@property (strong, nonatomic) IBOutlet UIView *groupedView;
@property (strong, nonatomic) IBOutlet UITableView *tableGrouped;

//custom products
@property (strong, nonatomic) IBOutlet UIView *customOptions;
@property (strong, nonatomic) IBOutlet UIView *dateTimeView;
@property (weak, nonatomic) IBOutlet UILabel *LabelDateOrtime;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)DoneButton:(UIButton*)sender;
- (IBAction)pickerSelect:(UIDatePicker*)sender;

//Downloadable products

@property (strong, nonatomic) IBOutlet UIView *linksView;

//Bundle Products

@property (strong, nonatomic) IBOutlet UIView *bundleOptionView;


//second part
@property (strong, nonatomic) IBOutlet UIView *descriptionBorder;
@property (strong, nonatomic) IBOutlet UITextView *descriptions;

//third part
@property (strong, nonatomic) IBOutlet UIView *specificationView;

//fourth part(reviews)

@property (strong, nonatomic) IBOutlet UIView *reviewsView;
@property (strong, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;


- (IBAction)reviewViewButton:(id)sender;


//fifth part
@property (strong, nonatomic) IBOutlet UIView *relatedProducts;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewRelated;

//Button outlets
@property (strong, nonatomic) IBOutlet UIButton *AddToCart;
@property (strong, nonatomic) IBOutlet UIButton *buyNow;
@property (strong, nonatomic) IBOutlet UIButton *guestUser;

// Popup View

@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIButton *LoginNowBorder;

//Swipe Gesture
- (IBAction)imagePreview:(id)sender;
- (IBAction)handleRight:(id)sender;
- (IBAction)handleLeft:(id)sender;
- (IBAction)pageControl:(id)sender;

//Back

- (IBAction)Back:(id)sender;

//PopUp Action
- (IBAction)UsersAction:(id)sender;

//Add to cart method
- (IBAction)AddToCartBuyNow:(id)sender;


- (IBAction)wishlistBtn_Action:(id)sender;

// wishlist parameter
@property (strong, nonatomic) NSString *wishlistItem;
@property (strong, nonatomic) NSString *wishListProductId;
@property (strong, nonatomic) IBOutlet UIButton *wishlistButton;

@end
