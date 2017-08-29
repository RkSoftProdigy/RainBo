//
//  UIView+transformView.m
//  Ongobuyo
//
//  Created by navjot_sharma on 7/7/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import "UIView+transformView.h"

@implementation UIView (transformView)

-(void)TransformationView
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
    for (UIButton *label in self.subviews)
    {
        if ([label isKindOfClass:[UIButton class]] )
        {
            if (label.tag!=9999)
            {
                [label setTransform:CGAffineTransformMakeScale(-1.0, 1.0)];
                [label setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            }
            
            
        }
        if ( [label isKindOfClass:[UIImageView class]] || [label isKindOfClass:[UILabel class]])
        {
            
            [label setTransform:CGAffineTransformMakeScale(-1.0, 1.0)];
        }
    }
    }

}

-(void)TransformViewCont
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
     [self setTransform:CGAffineTransformMakeScale(-1.0, 1.0)];
    }
    
}


@end
