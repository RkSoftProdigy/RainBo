//
//  PaymentCell.h
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 3/4/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCell : UITableViewCell

//word change
@property (weak, nonatomic) IBOutlet UILabel *QuantityLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;


@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *quantityNumber;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *imgName;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@end
