//
//  HelpViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/28/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "HelpViewController.h"
#import "ViewController.h"
#import "UIView+transformView.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"

@interface HelpViewController ()
{
    NSArray *arrHelpImages;
}
@end

@implementation HelpViewController
@synthesize leftButton,rightButton,pageControl,helpImages;
- (void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [helpImages TransformImage];
    [leftButton TransformButton];
    [rightButton TransformButton];
    
    [super viewDidLoad];
    arrHelpImages=[NSArray arrayWithObjects:@"Help-screen.png",@"Help-screen1.png",@"Help-screen2.png",@"Help-screen3.png", nil];
    
    pageControl.currentPage=0;
    
    [helpImages setImage:[UIImage imageNamed:[arrHelpImages objectAtIndex:0]]];
    
    [leftButton setImage:[UIImage imageNamed:@"btn_skip.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"btn_next.png"] forState:UIControlStateNormal];
    leftButton.tag=22;
    rightButton.tag=23;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---ButtonMethods---

- (IBAction)ButtonMethod:(id)sender
{
    UIButton *button=(UIButton*)sender;
    if (button.tag==22)
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FirstEnter"];
        ViewController *obj=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
        
    }
    else if(button.tag==23)
    {
        long p=pageControl.currentPage;
        
        if (p<arrHelpImages.count-1)
        {
            [helpImages setImage:[UIImage imageNamed:[arrHelpImages   objectAtIndex:p+1]]];
            
            pageControl.currentPage=p+1;
            
            if (pageControl.currentPage==0 || pageControl.currentPage==1 || pageControl.currentPage==2 )
            {
                leftButton.hidden=NO;
                [leftButton setImage:[UIImage imageNamed:@"btn_skip.png"] forState:UIControlStateNormal];
                [rightButton setImage:[UIImage imageNamed:@"btn_next.png"] forState:UIControlStateNormal];
                
                leftButton.tag=22;
                rightButton.tag=23;
            }
            else
            {
                leftButton.hidden=YES;
                [rightButton setImage:[UIImage imageNamed:@"got-it.png"] forState:UIControlStateNormal];
                rightButton.tag=22;
                leftButton.tag=23;
            }
        }
    }
}

#pragma ---Swipe Handle Methods---

- (IBAction)rightswipe:(id)sender
{
    long p=pageControl.currentPage;
    if (p>0)
    {
        [helpImages setImage:[UIImage imageNamed:[arrHelpImages   objectAtIndex:p-1]]];
        pageControl.currentPage=p-1;
        if (pageControl.currentPage==0 || pageControl.currentPage==1 || pageControl.currentPage==2 )
        {
            leftButton.hidden=NO;
            [leftButton setImage:[UIImage imageNamed:@"btn_skip.png"] forState:UIControlStateNormal];
            [rightButton setImage:[UIImage imageNamed:@"btn_next.png"] forState:UIControlStateNormal];
            leftButton.tag=22;
            rightButton.tag=23;
        }
        else
        {
            leftButton.hidden=YES;
            [rightButton setImage:[UIImage imageNamed:@"got-it.png"] forState:UIControlStateNormal];
            rightButton.tag=22;
            leftButton.tag=23;
        }
    }
}

- (IBAction)leftSwipe:(id)sender
{
    long p=pageControl.currentPage;
    if (p<arrHelpImages.count-1)
    {
        [helpImages setImage:[UIImage imageNamed:[arrHelpImages   objectAtIndex:p+1]]];
        
        pageControl.currentPage=p+1;
        if (pageControl.currentPage==0 || pageControl.currentPage==1 || pageControl.currentPage==2 )
        {
            leftButton.hidden=NO;
            [leftButton setImage:[UIImage imageNamed:@"btn_skip.png"] forState:UIControlStateNormal];
            [rightButton setImage:[UIImage imageNamed:@"btn_next.png"] forState:UIControlStateNormal];
            leftButton.tag=22;
            rightButton.tag=23;
        }
        else
        {
            leftButton.hidden=YES;
            [rightButton setImage:[UIImage imageNamed:@"got-it.png"] forState:UIControlStateNormal];
            rightButton.tag=22;
            leftButton.tag=23;
        }
    }
    
}



@end
