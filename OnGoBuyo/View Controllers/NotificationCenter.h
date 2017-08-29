//
//  NotificationCenter.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/29/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCenter : UIViewController

//change color outlets
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITableView *tableNotification;
@property (weak, nonatomic) IBOutlet UILabel *labelNoItem;

- (IBAction)Back:(id)sender;

@end
