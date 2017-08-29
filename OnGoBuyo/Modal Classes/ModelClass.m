//
//  ModelClass.m
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 2/8/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "ModelClass.h"

@implementation ModelClass

@synthesize arrSubCategory,arrMainCategory,arrImages,currencySymbo;

+ (id)sharedManager
{
    static ModelClass *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
