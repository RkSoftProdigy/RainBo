//
//  UIWebView+transformWeb.m
//  Ongobuyo
//
//  Created by navjot_sharma on 7/8/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import "UIWebView+transformWeb.h"

@implementation UIWebView (transformWeb)

-(void)TransformWebView
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLanguage"]isEqualToString:@"ar"])
    {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
    }
    
}

@end
