//
//  DownloadableCellTableViewCell.h
//  OnGoBuyo
//
//  Created by Jatiender on 4/29/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadableCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *downloadable_lbl;
@property (strong, nonatomic) IBOutlet UILabel *pending_lbl;
@property (strong, nonatomic) IBOutlet UILabel *dateandTime_lbl;
@property (strong, nonatomic) IBOutlet UILabel *orderId_lbl;
@property (strong, nonatomic) IBOutlet UIButton *download_btn;

@end
