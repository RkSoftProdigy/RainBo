//
//  AddToCartCell.h
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 2/16/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgSide;
@property (weak, nonatomic) IBOutlet UILabel *lblProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblprize;
@property (weak, nonatomic) IBOutlet UITextField *tftQuantity;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnWrite;
@property (weak, nonatomic) IBOutlet UITextField *lblQty;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UILabel *outOfStock;
@property (weak, nonatomic) IBOutlet UILabel *labelOptions;

@property (weak, nonatomic) IBOutlet UIButton *btnProduct;
@end
