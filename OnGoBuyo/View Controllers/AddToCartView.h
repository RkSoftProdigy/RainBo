//
//  AddToCartView.h
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 2/16/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface AddToCartView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //word change
    __weak IBOutlet UILabel *cartdetailLbl;
    
    __weak IBOutlet UILabel *deliveryChargeLbl;
    __weak IBOutlet UILabel *taxesLbl;
    __weak IBOutlet UILabel *discountLbl;
    __weak IBOutlet UILabel *subtotalLbl;
    __weak IBOutlet UILabel *orderTotalLbl;
    __weak IBOutlet UIButton *haveACouponLbl;
    __weak IBOutlet UIButton *removecouponLbl;
    
    __weak IBOutlet UILabel *orLbl;
    __weak IBOutlet UILabel *couponCodeLbl;
    __weak IBOutlet UILabel *enterCouponLbl;
    __weak IBOutlet UIButton *  continueAsGuestLbl;
}

// change color outlets

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *ifLbl;
@property (weak, nonatomic) IBOutlet UIButton *loginNowBorder;


@property (strong, nonatomic) AppDelegate *delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView1;

@property (weak, nonatomic) IBOutlet UIButton *buttonCoupon;
@property (weak, nonatomic) IBOutlet UIImageView *separator;
@property (weak, nonatomic) IBOutlet UIButton *removeCoupon;
@property (weak, nonatomic) IBOutlet UIImageView *completeIcon;

@property (strong, nonatomic) IBOutlet UIView *loginOrGuestView;

- (IBAction)LoginOrGuestButton:(id)sender;

- (IBAction)removeCoupon:(id)sender;

@end
