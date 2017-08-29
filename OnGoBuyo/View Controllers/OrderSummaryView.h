//
//  OrderSummaryView.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/10/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSummaryView : UIViewController<UITableViewDataSource,UITableViewDelegate>

//color change outlets
@property (weak, nonatomic) IBOutlet UIView *topView;


@property(strong , nonatomic) NSString *orderID;
@property (weak, nonatomic) IBOutlet UIView *labelTotalItems;
@property (weak, nonatomic) IBOutlet UIButton *borderCancelButton;
@property (weak, nonatomic) IBOutlet UITableView *orderTable;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *borderAddress;

@property (weak, nonatomic) IBOutlet UIView *borderGrandTotal;
@property (weak, nonatomic) IBOutlet UIView *borderStatus;
@property (weak, nonatomic) IBOutlet UIView *borderOrderId;
@property (weak, nonatomic) IBOutlet UIView *totalView;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *gTotal;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *orderid;


- (IBAction)cancelOrder:(id)sender;


@end
