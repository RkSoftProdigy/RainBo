//
//  DownloadableView.h
//  OnGoBuyo
//
//  Created by Jatiender on 4/29/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.


#import <UIKit/UIKit.h>

@interface DownloadableView : UIViewController
{
  BOOL ViewMore;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *downloadable_tblVew;
@property (strong, nonatomic) NSMutableArray *items;

- (IBAction)back_BtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *noDownload_item;

@end
