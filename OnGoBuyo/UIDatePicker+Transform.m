//
//  UIDatePicker+Transform.m
//  Ongobuyo
//
//  Created by navjot_sharma on 7/11/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import "UIDatePicker+Transform.h"

@implementation UIDatePicker (Transform)
-(void)TransformPicker
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
    }
    
}
@end
