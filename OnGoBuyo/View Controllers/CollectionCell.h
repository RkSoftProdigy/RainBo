//
//  CollectionCell.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/8/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *borderImage;

@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productOff;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;

@property (strong, nonatomic) IBOutlet UIButton *orderImg;


@end
