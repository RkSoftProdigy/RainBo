//
//  UILabel+transformLabel.m
//  Ongobuyo
//
//  Created by navjot_sharma on 7/8/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import "UILabel+transformLabel.h"

@implementation UILabel (transformLabel)

-(void)TransformAlignLabel
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
    self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self setTextAlignment:NSTextAlignmentRight];
    }
}

-(void)TransformAlignLeftLabel
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        [self setTextAlignment:NSTextAlignmentLeft];
    }
}

-(void)TransformLabel
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
    }
}
@end
