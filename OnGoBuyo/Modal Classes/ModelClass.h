//
//  ModelClass.h
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 2/8/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ModelClass : NSObject

@property (strong,nonatomic)NSArray  * arrSubCategory;
@property (strong,nonatomic)NSArray  * arrMainCategory;
@property (strong,nonatomic)NSString * currencySymbo;
@property (strong,nonatomic)NSString * visitorID;
@property (strong,nonatomic)NSString * storeID;
@property (strong,nonatomic)NSString * currencyID;
@property (strong,nonatomic)NSArray  * arrImages;
@property (strong,nonatomic)NSString * custId;
@property (assign,nonatomic)NSInteger  totalCount;
@property (strong,nonatomic)NSArray  * arrMainCategoryID;
@property (strong,nonatomic)NSArray  * arrSubCategoryID;
@property (strong,nonatomic)NSString * salt;
@property (strong,nonatomic)NSString * wishlist_item_id;
@property (strong,nonatomic)NSString * pkgType;
@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UIColor *buttonColor;
@property (strong, nonatomic) UIColor *priceColor;
@property (strong, nonatomic) UIColor *secondaryColor;
@property (strong, nonatomic) UIColor *saffronClr;
@property (strong, nonatomic) UIColor *greenClr;
@property (strong, nonatomic) UIColor *blueClr;



+ (id)sharedManager;

@end
