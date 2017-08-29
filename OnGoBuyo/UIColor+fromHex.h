//
//  UIColor+fromHex.h
//  Ongobuyo
//
//  Created by navjot_sharma on 6/22/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (fromHex)

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
