//
//  ViewMoreViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/9/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface ViewMoreViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) AppDelegate *delegate;

//from previous View
@property (strong,nonatomic) NSString *strPrevious;
@property (strong,nonatomic) NSString *strName;
@property (strong,nonatomic) NSString *apiType;
@property (strong,nonatomic) NSString *categoryID;

@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView1;
@property (strong, nonatomic) IBOutlet UIView *sortingView;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;

//color change outlets

@property (weak, nonatomic) IBOutlet UIButton *sortLbl;
@property (strong, nonatomic) IBOutlet UIView *topView;



- (IBAction)Back:(id)sender;
- (IBAction)SortBy:(id)sender;
// Sorting Method
- (IBAction)Sorting:(id)sender;


@end
