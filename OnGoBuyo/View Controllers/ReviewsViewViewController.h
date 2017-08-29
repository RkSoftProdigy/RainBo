//
//  ReviewsViewViewController.h
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/4/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewsViewViewController : UIViewController

//change color outlets
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblBackground;

//word change
@property (weak, nonatomic) IBOutlet UILabel *letUsLbl;
@property (weak, nonatomic) IBOutlet UILabel *summaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *whatIsLbl;
@property (weak, nonatomic) IBOutlet UILabel *overallLbl;
@property (weak, nonatomic) IBOutlet UILabel *productRevLbl;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic) NSString *strProdId;

@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage1;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage2;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage3;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage4;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage5;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (strong, nonatomic) IBOutlet UIButton *addReviewButton;
@property (weak, nonatomic) IBOutlet UITableView *reviewTable;

//Add Review popup

@property (strong, nonatomic) IBOutlet UIView *addReviewView;
@property (weak, nonatomic) IBOutlet UIView *reviewSecondView;
@property (weak, nonatomic) IBOutlet UITextField *Thoughts;
@property (weak, nonatomic) IBOutlet UITextField *Summary;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UIView *thoughtsView;
@property (strong, nonatomic) IBOutlet UIView *summaryView;
@property (strong, nonatomic) IBOutlet UIView *nicknameView;


- (IBAction)homeButton:(id)sender;

//Rating Buttons

- (IBAction)RatingButton:(id)sender;

//Review buttons

- (IBAction)AddReviewButton:(id)sender;
- (IBAction)SubmitReview:(id)sender;
- (IBAction)BackButton:(id)sender;

@end
