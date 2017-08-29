//
//  PayPallView.h
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 3/16/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol orderDisplay <NSObject>

-(void)methodCall:(NSString *)str;

@end

@interface PayPallView : UIViewController

@property (strong,nonatomic) id <orderDisplay> delegate;
//change color outlets
@property (weak, nonatomic) IBOutlet UIView *topView;


@end
