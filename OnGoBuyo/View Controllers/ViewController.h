//
//  ViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/8/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"
@class AppDelegate;

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
//    outlets for words
    
    __weak IBOutlet UIButton *btnSearch;
}
//Outlets for color change
@property (weak, nonatomic) IBOutlet UIButton *more1;
@property (weak, nonatomic) IBOutlet UIButton *more2;
@property (weak, nonatomic) IBOutlet UIButton *more3;
@property (weak, nonatomic) IBOutlet UIButton *more4;
@property (weak, nonatomic) IBOutlet UIButton *more5;
@property (weak, nonatomic) IBOutlet UIButton *more6;
@property (strong, nonatomic) IBOutlet UIButton *more7;
@property (strong, nonatomic) IBOutlet UIButton *more8;
@property (strong, nonatomic) IBOutlet UIButton *more9;
@property (strong, nonatomic) IBOutlet UIButton *more10;
@property (strong, nonatomic) IBOutlet UIButton *more11;

@property (strong,nonatomic) AppDelegate *delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


//Banner view
@property (strong, nonatomic) IBOutlet UIView *mediaView;
@property (strong, nonatomic) IBOutlet RemoteImageView *imagePage;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *bannerButtons;


//UIVIEWS
@property (weak, nonatomic) IBOutlet UIView *NewArrView;
@property (weak, nonatomic) IBOutlet UIView *MostView;
@property (weak, nonatomic) IBOutlet UIView *FeaturedView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;
@property (weak, nonatomic) IBOutlet UIView *fifthView;
@property (weak, nonatomic) IBOutlet UIView *sixthView;
@property (strong, nonatomic) IBOutlet UIView *recentView;
@property (weak, nonatomic) IBOutlet UIView *mediaView2;
@property (weak, nonatomic) IBOutlet UIView *mediaView3;
@property (weak, nonatomic) IBOutlet UIView *mediaView4;
@property (weak, nonatomic) IBOutlet UIView *mediaView5;
@property (weak, nonatomic) IBOutlet UIView *mediaView6;
@property (strong, nonatomic) IBOutlet UIView *SeventhView;
@property (strong, nonatomic) IBOutlet UIView *eighthView;
@property (strong, nonatomic) IBOutlet UIView *ninthView;
@property (strong, nonatomic) IBOutlet UIView *tenthView;
@property (strong, nonatomic) IBOutlet UIView *eleventhView;

//UIImageView

@property (weak, nonatomic) IBOutlet RemoteImageView *customImg2;
@property (weak, nonatomic) IBOutlet RemoteImageView *customImg3;
@property (weak, nonatomic) IBOutlet RemoteImageView *customImg4;
@property (weak, nonatomic) IBOutlet RemoteImageView *customImg5;
@property (weak, nonatomic) IBOutlet RemoteImageView *customImg6;

//collection views

@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewMost;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewFeat;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionFourth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewFifth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewsixth;
@property (strong, nonatomic) IBOutlet UICollectionView *recentlyCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewSeventh;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewEighth;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewNinth;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewTenth;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewEleventh;

//Labels

@property (strong, nonatomic) IBOutlet UILabel *types;
@property (strong, nonatomic) IBOutlet UILabel *typeMost;
@property (strong, nonatomic) IBOutlet UILabel *typefeatured;
@property (weak, nonatomic) IBOutlet UILabel *typeFourth;
@property (weak, nonatomic) IBOutlet UILabel *typeFifth;
@property (weak, nonatomic) IBOutlet UILabel *typeSixth;
@property (strong, nonatomic) IBOutlet UILabel *typeRecntlyViewd;
@property (strong, nonatomic) IBOutlet UILabel *typeSeventh;
@property (strong, nonatomic) IBOutlet UILabel *typeEighth;
@property (strong, nonatomic) IBOutlet UILabel *typeNinth;
@property (strong, nonatomic) IBOutlet UILabel *typeTenth;
@property (strong, nonatomic) IBOutlet UILabel *typeEleventh;



//table view

@property (strong, nonatomic) IBOutlet UITableView *tableView1;

//Methods
- (IBAction)changeSlideImage:(id)sender;
- (IBAction)handleRight:(id)sender;
- (IBAction)handleLeft:(id)sender;

//View More
- (IBAction)viewMore:(id)sender;

//banner buttons
- (IBAction)BannerButton:(id)sender;
- (IBAction)CustomBannerButton:(id)sender;

@end
