//
//  MyOrdersViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/9/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrdersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *orderTable;
@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction)Back:(id)sender;

@end
