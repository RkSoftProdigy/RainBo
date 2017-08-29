//
//  wishlistCellTableViewCell.h
//  OnGoBuyo
//
//  Created by Jatiender on 4/7/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wishlistCellTableViewCell : UITableViewCell
- (IBAction)removeitem_BtnAction:(id)sender;
- (IBAction)additemToCartBtn_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *created_at_lbl;
@property (strong, nonatomic) IBOutlet UILabel *product_name_lbl;
- (IBAction)cart_btn_action:(id)sender;
- (IBAction)remove_btn_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *product_image;
@property (strong, nonatomic) IBOutlet UILabel *name_lbl;
@property (strong, nonatomic) IBOutlet UILabel *quantity_lbl;
@property (strong, nonatomic) IBOutlet UILabel *price_lbl;
@property (strong, nonatomic) IBOutlet UIButton *addToCart;
@property (strong, nonatomic) IBOutlet UIButton *remove_Btn;
@property (strong, nonatomic) IBOutlet UILabel *cartCountLbl;

@end
