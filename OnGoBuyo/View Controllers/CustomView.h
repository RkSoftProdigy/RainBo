//
//  CustomView.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/15/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIViewController<UIWebViewDelegate>

//color change
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIWebView *customView;
@property (strong, nonatomic) NSString *urlToDisplay;
@property (strong, nonatomic) NSString *strPrev;

//back

- (IBAction)Back:(id)sender;

@end
