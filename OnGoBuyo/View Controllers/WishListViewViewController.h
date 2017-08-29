//
//  WishListViewViewController.h
//  OnGoBuyo
//
//  Created by Jatiender on 4/7/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListViewViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *wishlist_items;
    NSString *wishlist_item_id;
    NSString *quantity;
    NSString *productId;
    NSString *productType;

}

//change color outlets
@property (weak, nonatomic) IBOutlet UIView *topView;

//word constants
@property (weak, nonatomic) IBOutlet UILabel *noItemLbl;
@property (weak, nonatomic) IBOutlet UILabel *wishListLbl;



- (IBAction)backBtn_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *wishlist_tblvew;
@property (strong, nonatomic) IBOutlet UIView *wishListNoItemFound;

@end
