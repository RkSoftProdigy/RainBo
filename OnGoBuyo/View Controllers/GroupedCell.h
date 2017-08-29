//
//  GroupedCell.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/18/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupedImage;
@property (weak, nonatomic) IBOutlet UILabel *groupedName;
@property (weak, nonatomic) IBOutlet UILabel *groupedQuantity;
@property (weak, nonatomic) IBOutlet UITextField *tftGroupedQty;
@property (weak, nonatomic) IBOutlet UILabel *groupedPrice;
@property (weak, nonatomic) IBOutlet UILabel *groupedDiscount;
@property (weak, nonatomic) IBOutlet UIImageView *textFieldBorder;




@end
