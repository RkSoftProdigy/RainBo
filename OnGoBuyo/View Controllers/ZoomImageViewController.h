//
//  ZoomImageViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/16/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"

@interface ZoomImageViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIActivityIndicatorView *indicator;

}
//change color outlets

@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet RemoteImageView *imageToZoom;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGesture;




//swipe gesture

- (IBAction)handleRight:(id)sender;
- (IBAction)handleLeft:(id)sender;
- (IBAction)handleDoubleTap:(id)sender;





- (IBAction)Back:(id)sender;
@end
