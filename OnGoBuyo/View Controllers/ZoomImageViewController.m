//
//  ZoomImageViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 2/16/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "ZoomImageViewController.h"
#import "ModelClass.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "UIView+transformView.h"
#import "UIImageView+transforming.h"

#define ZOOM_STEP 1.5

@interface ZoomImageViewController ()
{
    ModelClass *model;
}
@end

@implementation ZoomImageViewController
@synthesize pageControl,imageToZoom,doubleTapGesture,scrollView,topView;

- (void)viewDidLoad
{
    [self.view TransformViewCont];
    [topView TransformationView];
    [imageToZoom TransformImage];
    
    [super viewDidLoad];

    
    model=[ModelClass sharedManager];
    pageControl.numberOfPages=model.arrImages.count;
    NSLog(@"%@",model.arrImages);
    
    pageControl.currentPage=0;
    
    imageToZoom.resizeImage=NO;
    if(model.arrImages.count == 0 || model.arrImages.count == 1)
    {
        pageControl.hidden = YES;
    }
    
    if (![[[model.arrImages objectAtIndex:0] valueForKey:@"url"]isEqualToString:@""])
    {
        NSURL *imageurl=[NSURL URLWithString:[[model.arrImages objectAtIndex:0] valueForKey:@"url"]];
        
        indicator.hidden = NO;
        [indicator startAnimating];
      
        
        [imageToZoom sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"place_holder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
            {
                [indicator stopAnimating];
                indicator.hidden = YES;
            }
            NSLog(@"Downloaded");
        }];    }
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //change color
  //   pageControl.currentPageIndicatorTintColor=model.themeColor;
    [topView setBackgroundColor:model.themeColor];
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ZoomImageView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Swipe handlers

- (IBAction)handleRight:(id)sender
{
    long p=pageControl.currentPage;
    if (p>0)
    {
        if (![[[model.arrImages objectAtIndex:p-1] valueForKey:@"url"]isEqualToString:@""])
        {
            NSURL *imageurl=[NSURL URLWithString:[[model.arrImages objectAtIndex:p-1] valueForKey:@"url"]];
            
            indicator.hidden = NO;
            [indicator startAnimating];
            
            
            [imageToZoom sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"place_holder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image)
                {
                    [indicator stopAnimating];
                    indicator.hidden = YES;
                }
                NSLog(@"Downloaded");
            }];
           // [imageToZoom setImageURL:imageurl];
        }
        pageControl.currentPage=p-1;
    }
}

- (IBAction)handleLeft:(id)sender
{
    long p=pageControl.currentPage;
    if (p<model.arrImages.count-1)
    {
        if (![[[model.arrImages objectAtIndex:p+1] valueForKey:@"url"]isEqualToString:@""])
        {
            NSURL *imageurl=[NSURL URLWithString:[[model.arrImages objectAtIndex:p+1] valueForKey:@"url"]];
            indicator.hidden = NO;
            [indicator startAnimating];
            
            
            [imageToZoom sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"place_holder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image)
                {
                    [indicator stopAnimating];
                    indicator.hidden = YES;
                }
                NSLog(@"Downloaded");
            }];
           // [imageToZoom setImageURL:imageurl];
        }
       
        pageControl.currentPage=p+1;
    }
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer*)gesture
{
    float newScale = [scrollView zoomScale] * 4.0;
    
    if (scrollView.zoomScale > scrollView.minimumZoomScale)
    {
        [scrollView setZoomScale:scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        CGRect zoomRect = [self zoomRectForScale:newScale
                                      withCenter:[doubleTapGesture locationInView:doubleTapGesture.view]];
        [scrollView zoomToRect:zoomRect animated:YES];
    }
    
//    float newScale = [scrollView zoomScale] * ZOOM_STEP;
//    
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleTapGesture locationInView:doubleTapGesture.view]];
//    
//    [self.scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark ---Utility methods---

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
        CGRect zoomRect;
        
        zoomRect.size.height = [imageToZoom frame].size.height / scale;
        zoomRect.size.width  = [imageToZoom frame].size.width  / scale;
        
        center = [imageToZoom convertPoint:center fromView:scrollView];
        
        zoomRect.origin.x = center.x - ((zoomRect.size.width / 2.0));
        zoomRect.origin.y = center.y - ((zoomRect.size.height / 2.0));
        
        return zoomRect;
  }

#pragma mark zoom with scrolling


-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageToZoom;
}


#pragma mark Swipe handlers

- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
