//
//  ReviewCell.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/6/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell

//word change

@property (weak, nonatomic) IBOutlet UILabel *valueLbl;
@property (weak, nonatomic) IBOutlet UILabel *qualityLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
   

@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIImageView *valueRating1;
@property (weak, nonatomic) IBOutlet UIImageView *valueRating2;
@property (weak, nonatomic) IBOutlet UIImageView *valueRating3;
@property (weak, nonatomic) IBOutlet UIImageView *valueRating4;
@property (weak, nonatomic) IBOutlet UIImageView *valueRating5;

@property (weak, nonatomic) IBOutlet UIImageView *qualityRating1;
@property (weak, nonatomic) IBOutlet UIImageView *qualityRating2;
@property (weak, nonatomic) IBOutlet UIImageView *qualityRating3;
@property (weak, nonatomic) IBOutlet UIImageView *qualityRating4;
@property (weak, nonatomic) IBOutlet UIImageView *qualityRating5;

@property (weak, nonatomic) IBOutlet UIImageView *priceRating1;
@property (weak, nonatomic) IBOutlet UIImageView *priceRating2;
@property (weak, nonatomic) IBOutlet UIImageView *priceRating3;
@property (weak, nonatomic) IBOutlet UIImageView *priceRating4;
@property (weak, nonatomic) IBOutlet UIImageView *priceRating5;

@property (weak, nonatomic) IBOutlet UILabel *titleReview;
@property (weak, nonatomic) IBOutlet UILabel *reviewText;
@property (weak, nonatomic) IBOutlet UILabel *byName;
@property (weak, nonatomic) IBOutlet UILabel *created;


@end
