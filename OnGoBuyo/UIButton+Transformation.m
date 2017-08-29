//
//  UIButton+Transformation.m
//  Ongobuyo
//
//  Created by navjot_sharma on 7/8/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import "UIButton+Transformation.h"

@implementation UIButton (Transformation)

-(void)TransformButton
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
    }
}


-(void)TransformAlignButton
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
    self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
}

-(void)AlignButton
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
       
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
}

@end
