//
//  NotificationCell.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/29/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end
