//
//  HelpViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/28/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *helpImages;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)ButtonMethod:(id)sender;
- (IBAction)rightswipe:(id)sender;
- (IBAction)leftSwipe:(id)sender;

@end
