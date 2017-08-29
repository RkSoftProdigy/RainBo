//
//  OrdersCell.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 3/10/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "OrdersCell.h"

@implementation OrdersCell
@synthesize price,productImage,status,orderID,createdID,quantity,name;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
