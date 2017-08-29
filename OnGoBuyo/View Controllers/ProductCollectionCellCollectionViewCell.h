//
//  ProductCollectionCellCollectionViewCell.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/9/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageLine;

@property (strong, nonatomic) IBOutlet UIImageView *borderImage;
@property (strong, nonatomic) IBOutlet UILabel *inStock;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productOff;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;

@property (weak, nonatomic) IBOutlet UIButton *orderImage;

//rating star
@property (strong, nonatomic) IBOutlet UIImageView *rating1;
@property (strong, nonatomic) IBOutlet UIImageView *rating2;
@property (strong, nonatomic) IBOutlet UIImageView *rating3;
@property (strong, nonatomic) IBOutlet UIImageView *rating4;
@property (strong, nonatomic) IBOutlet UIImageView *rating5;

@end
