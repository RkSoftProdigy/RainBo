//
//  LanguageSettingView.h
//  Ongobuyo
//
//  Created by navjot_sharma on 7/7/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageSettingView : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *languageSettingLbl;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableLanguage;
@property (weak, nonatomic) IBOutlet UITableView *tableCurrency;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;


- (IBAction)ApplyButton:(id)sender;
- (IBAction)back_BtnAction:(id)sender;
- (IBAction)homeButton:(id)sender;

@end
