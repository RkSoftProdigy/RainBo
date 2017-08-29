//
//  MyOrderCell.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/9/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *order_id;
@property (weak, nonatomic) IBOutlet UILabel *created_at;
@property (strong, nonatomic) IBOutlet UIButton *buttonViewOrder;


@end
