//
//  ReviewsViewViewController.m
//  OnGoBuyo
//
//  Created by navjot_sharma on 4/4/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "ReviewsViewViewController.h"
#import "MBProgressHUD.h"
#import "ApiClasses.h"
#import "ReviewCell.h"
#import "ModelClass.h"
#import "ViewController.h"
#import "Reachability.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"

@interface ReviewsViewViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrReviews;
    UIView *coverView;
    ModelClass *model;
    NSMutableArray *arrRating;
    NSMutableArray *arrRatingIds;
    NSMutableDictionary *dictRating;
    NSMutableArray *arrAddRatings;
    NSArray *arrRatingCodes;
}
@end

@implementation ReviewsViewViewController
@synthesize ratingImage1,ratingImage2,ratingImage3,ratingImage4,ratingImage5,strProdId,ratingView,addReviewButton,addReviewView,Thoughts,Summary,nickName,thoughtsView,summaryView,nicknameView,scrollView;

- (void)viewDidLoad
{
    [self.view TransformViewCont];
    [_topView TransformationView];
    [_productRevLbl TransformLabel];
    [_overallLbl TransformAlignLabel];
    [addReviewButton TransformButton];
    [_commentsLabel TransformLabel];
    [_letUsLbl TransformAlignLabel];
    [_summaryLbl TransformAlignLabel];
    [_whatIsLbl TransformAlignLabel];
    [_lblBackground TransformLabel];
    [Thoughts TransformTextField];
    [Summary TransformTextField];
    [nickName TransformTextField];
    
    [super viewDidLoad];
    
    //words change
    [_productRevLbl setText:AMLocalizedString(@"tProductReviews", nil)];
    [_overallLbl setText:AMLocalizedString(@"tOverallRating", nil)];
    [addReviewButton setTitle:AMLocalizedString(@"tAddReview", nil) forState:UIControlStateNormal];
    [_commentsLabel setText:AMLocalizedString(@"tCommentsReviews", nil)];
    [_lblBackground setText:AMLocalizedString(@"tHowDoYouRateThisProduct", nil)];
    [_letUsLbl setText:AMLocalizedString(@"tLetUsKnowYourThoughts", nil)];
    [_summaryLbl setText:AMLocalizedString(@"tSummaryofYourReview", nil)];
    [_whatIsLbl setText:AMLocalizedString(@"tWhatisyourNickname", nil)];
    
    
    
    arrRatingIds = [[NSMutableArray alloc]init];
    
    model=[ModelClass sharedManager];
    arrRating=[[NSMutableArray alloc]init];
    arrAddRatings=[[NSMutableArray alloc]init];
    // Borders
    //    ratingView.layer.cornerRadius=4.0;
    //    ratingView.layer.borderWidth=1;
    //    ratingView.layer.borderColor=[[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]CGColor];
    //    ratingView.layer.masksToBounds=YES;
    
    
    [self setButtonBorders:addReviewButton];
    
    [self setBorders:thoughtsView];
    [self setBorders:summaryView];
    [self setBorders:nicknameView];
    //API call
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self getListReviews];
        });
    });
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // color change
    [_topView setBackgroundColor:model.themeColor];
    [_lblBackground setBackgroundColor:model.buttonColor];
    [addReviewButton setBackgroundColor:model.buttonColor];
    [_productRevLbl setTextColor:model.secondaryColor];
    [_commentsLabel setTextColor:model.secondaryColor];
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ReviewsView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Api Calls

-(void)getListReviews
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil)  delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        
        //---------------- API----------------------
        
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        NSString *str=[NSString stringWithFormat:@"%@listProductReviews?salt=%@&prod_id=%@&store_id=&page_id=&limit=&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,model.storeID,model.currencyID];
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_ListReviews_Response:)];
    }
}

#pragma mark Api Response

-(void)Get_ListReviews_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict=[responseDict valueForKey:@"response"];
        NSString *str=[NSString stringWithFormat:@"%.1f",[[dict valueForKey:@"overall_rating"]floatValue]];
        float result= [str floatValue]/100*5;
        
        if (result==0.0)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>0.0 && result<=0.5)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-half.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>0.5 && result<=1.0)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>1.0 && result<=1.5)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-half.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>1.5 && result<=2.0)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>2.0 && result<=2.5)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-half.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>2.5 && result<=3.0)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-blank.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>3.0 && result<=3.5)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-half.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>3.5 && result<=4.0)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-blank.png"];
        }
        else if (result>4.0 && result<=4.5)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-half.png"];
        }
        else if (result>4.5 && result<=5.0)
        {
            ratingImage1.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage2.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage3.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage4.image=[UIImage imageNamed:@"star-filled.png"];
            ratingImage5.image=[UIImage imageNamed:@"star-filled.png"];
        }
        if ([[[responseDict valueForKey:@"response"]valueForKey:@"reviews"]count]!=0)
        {
            arrReviews=[[NSMutableArray alloc]init];
            arrReviews =[[responseDict valueForKey:@"response"]valueForKey:@"reviews"];
            
            [self.reviewTable setHidden:NO];
            self.commentsLabel.text=[NSString stringWithFormat:@"%@ (%@)",AMLocalizedString(@"tCommentsReviews", nil) ,[dict valueForKey:@"total_reviews"]];
            [self.reviewTable reloadData];
            if (self.reviewTable.contentSize.height< self.reviewTable.frame.size.height)
            {
                [self.reviewTable setScrollEnabled:NO];
            }
        }
        else
        {
            [self.reviewTable setHidden:YES];
            
            UILabel *noItems =[[UILabel alloc]initWithFrame:CGRectMake(8, 277, 304, 50)];
            
            [noItems setFont:[UIFont systemFontOfSize:14.0]];
            noItems.textAlignment=NSTextAlignmentCenter;
            noItems.numberOfLines=2;
            noItems.text=[NSString stringWithFormat:@"%@",AMLocalizedString(@"tNoReviewBethefirstone", nil)];
            noItems.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
            noItems.textColor=model.secondaryColor;
            [noItems TransformLabel];
            
            [self.view addSubview:noItems];
        }
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"fail"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[responseDict valueForKey:@"response"] delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrReviews.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *labelText = [[arrReviews objectAtIndex:indexPath.row] valueForKey:@"detail"];
    float height =[self heightForText:labelText];
    if (height<70)
    {
        return 125.0;
    }
    else
    {
        return height+60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReviewCell";
    ReviewCell *cell = (ReviewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    if (arrReviews.count!=0)
    {
        //rtl
        [cell.valueLbl TransformAlignLabel];
        [cell.priceLbl TransformAlignLabel];
        [cell.qualityLbl TransformAlignLabel];
        [cell.titleReview TransformAlignLabel];
        [cell.reviewText TransformAlignLabel];
        [cell.created TransformLabel];
        [cell.byName TransformLabel];
        
        // word change
        
        
        
        cell.titleReview.text=[[arrReviews objectAtIndex:indexPath.row] valueForKey:@"title"];
        cell.reviewText.textColor=model.priceColor;
        cell.reviewText.text=[[arrReviews objectAtIndex:indexPath.row] valueForKey:@"detail"];
        [cell.reviewText sizeToFit];
        cell.created.text=[[arrReviews objectAtIndex:indexPath.row] valueForKey:@"created_at"];
        cell.byName.text=[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"tBy", nil),[[arrReviews objectAtIndex:indexPath.row]valueForKey:@"nickname"]];
        if ([[[arrReviews objectAtIndex:indexPath.row]valueForKey:@"votes"]count]!=0)
        {
            NSMutableArray *arrvotes=[[arrReviews objectAtIndex:indexPath.row]valueForKey:@"votes"];
            if (0<arrvotes.count)
            {
                cell.valueLbl.text=[NSString stringWithFormat:@"%@",[[arrvotes objectAtIndex:0]valueForKey:@"rating_code"]];
                
                if([[[arrvotes objectAtIndex:0]valueForKey:@"rating_value"]intValue]==1)
                {
                    cell.valueRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating2.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:0]valueForKey:@"rating_value"]intValue]==2)
                {
                    cell.valueRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:0]valueForKey:@"rating_value"]intValue]==3)
                {
                    cell.valueRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:0]valueForKey:@"rating_value"]intValue]==4)
                {
                    cell.valueRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating4.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:0]valueForKey:@"rating_value"]intValue]==5)
                {
                    cell.valueRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating4.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.valueRating5.image=[UIImage imageNamed:@"star-filled.png"];
                }
                else if([[[arrvotes objectAtIndex:0]valueForKey:@"rating_value"]intValue]==0)
                {
                    cell.valueRating1.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating2.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.valueRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                
            }
            
            if (1<arrvotes.count)
            {
                cell.qualityLbl.text=[NSString stringWithFormat:@"%@",[[arrvotes objectAtIndex:1]valueForKey:@"rating_code"]];
                
                if ([[[arrvotes objectAtIndex:1]valueForKey:@"rating_value"]intValue]==1)
                {
                    cell.qualityRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating2.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:1]valueForKey:@"rating_value"]intValue]==2)
                {
                    cell.qualityRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:1]valueForKey:@"rating_value"]intValue]==3)
                {
                    cell.qualityRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:1]valueForKey:@"rating_value"]intValue]==4)
                {
                    cell.qualityRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating4.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:1]valueForKey:@"rating_value"]intValue]==5)
                {
                    cell.qualityRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating4.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.qualityRating5.image=[UIImage imageNamed:@"star-filled.png"];
                }
                else if([[[arrvotes objectAtIndex:1]valueForKey:@"rating_value"]intValue]==0)
                {
                    cell.qualityRating1.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating2.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.qualityRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
            }
            if (2<arrvotes.count)
            {
                cell.priceLbl.text=[NSString stringWithFormat:@"%@",[[arrvotes objectAtIndex:2]valueForKey:@"rating_code"]];
                
                if ([[[arrvotes objectAtIndex:2]valueForKey:@"rating_value"]intValue]==1)
                {
                    cell.priceRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating2.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:2]valueForKey:@"rating_value"]intValue]==2)
                {
                    cell.priceRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:2]valueForKey:@"rating_value"]intValue]==3)
                {
                    cell.priceRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:2]valueForKey:@"rating_value"]intValue]==4)
                {
                    cell.priceRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating4.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
                else if([[[arrvotes objectAtIndex:2]valueForKey:@"rating_value"]intValue]==5)
                {
                    cell.priceRating1.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating2.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating3.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating4.image=[UIImage imageNamed:@"star-filled.png"];
                    cell.priceRating5.image=[UIImage imageNamed:@"star-filled.png"];
                }
                else if([[[arrvotes objectAtIndex:2]valueForKey:@"rating_value"]intValue]==0)
                {
                    cell.priceRating1.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating2.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating3.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating4.image=[UIImage imageNamed:@"star-blank.png"];
                    cell.priceRating5.image=[UIImage imageNamed:@"star-blank.png"];
                }
            }
        }
        else
        {
            cell.valueRating1.image=[UIImage imageNamed:@"star-blank.png"];
            cell.valueRating2.image=[UIImage imageNamed:@"star-blank.png"];
            cell.valueRating3.image=[UIImage imageNamed:@"star-blank.png"];
            cell.valueRating4.image=[UIImage imageNamed:@"star-blank.png"];
            cell.valueRating5.image=[UIImage imageNamed:@"star-blank.png"];
            cell.qualityRating1.image=[UIImage imageNamed:@"star-blank.png"];
            cell.qualityRating2.image=[UIImage imageNamed:@"star-blank.png"];
            cell.qualityRating3.image=[UIImage imageNamed:@"star-blank.png"];
            cell.qualityRating4.image=[UIImage imageNamed:@"star-blank.png"];
            cell.qualityRating5.image=[UIImage imageNamed:@"star-blank.png"];
            cell.priceRating1.image=[UIImage imageNamed:@"star-blank.png"];
            cell.priceRating2.image=[UIImage imageNamed:@"star-blank.png"];
            cell.priceRating3.image=[UIImage imageNamed:@"star-blank.png"];
            cell.priceRating4.image=[UIImage imageNamed:@"star-blank.png"];
            cell.priceRating5.image=[UIImage imageNamed:@"star-blank.png"];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    return cell;
}

#pragma mark ---Add review Button method---

- (IBAction)AddReviewButton:(id)sender
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self addLoadingView];
        
        //---------------- API----------------------
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        NSString *str=[NSString stringWithFormat:@"%@getReviewRatingCodes?salt=%@&store_id=&cstore=%@&ccurrency=%@",baseURL1,model.salt,model.storeID,model.currencyID];
        [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Get_ReviewRatingCode_Response:)];
    }
}

#pragma mark Api Response

-(void)Get_ReviewRatingCode_Response:(NSDictionary*)responseDict
{
    // to remove all buttons
    [self removeLoadingView];
    for (UIView*  view in scrollView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]] && view.tag!=888)
        {
            [view removeFromSuperview];
        }
    }
    
    
    NSLog(@"%@",responseDict);
    if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        arrRatingCodes=[[responseDict valueForKey:@"response"]valueForKey:@"rating_codes"];
        [arrAddRatings removeAllObjects];
        [arrRatingIds removeAllObjects];
        if (arrRatingCodes.count!=0)
        {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            coverView = [[UIView alloc] initWithFrame:screenRect];
            coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.addReviewView.frame=CGRectMake(self.view.frame.origin.x+15, 60, self.view.frame.size.width-30, 420);
            int y = 54;
            
            for (int i=0; i<arrRatingCodes.count; i++)
            {
                UILabel *ratingtype=[[UILabel alloc]initWithFrame:CGRectMake(16, y, 52, 21)];
                [ratingtype setFont:[UIFont boldSystemFontOfSize:14.0]];
                ratingtype.textColor=model.priceColor;
                ratingtype.text=[NSString stringWithFormat:@"%@",[[arrRatingCodes objectAtIndex:i] valueForKey:@"rating_code"]];
                [ratingtype TransformAlignLabel];
                
                [scrollView addSubview:ratingtype];
                int x = 95;
                
                NSArray *options=[[arrRatingCodes objectAtIndex:i] valueForKey:@"options"];
                
                
                for (int j=0; j<options.count;j++)
                {
                    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(x, y, 18, 18)];
                    [button setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(RatingButton:) forControlEvents:UIControlEventTouchUpInside];
                    NSString *str=[NSString stringWithFormat:@"%@",[[arrRatingCodes objectAtIndex:i]valueForKey:@"rating_id"]];
                    button.accessibilityLabel =  str ;
                    
                    button.tag=[[NSString stringWithFormat:@"%@",[[options objectAtIndex:j]valueForKey:@"option_id"]]intValue];
                    [scrollView addSubview:button];
                    x=x+30;
                }
                y=y+32;
            }
            if(arrRatingCodes.count!=0 && arrAddRatings.count==0)
            {
                for (int n=0; n<arrRatingCodes.count; n++)
                {
                    [arrAddRatings insertObject:@"0" atIndex:n];
                    [arrRatingIds insertObject:@"0" atIndex:n];
                }
            }
            Thoughts.text=@"";
            Summary.text=@"";
            nickName.text=@"";
            
            UIButton *CancelButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 215, 120, 37)];
            [CancelButton setTitle:AMLocalizedString(@"tCancel", nil) forState:UIControlStateNormal];
            [CancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            CancelButton.titleLabel.font=[UIFont systemFontOfSize:15.0];
            CancelButton.backgroundColor=model.buttonColor;
            CancelButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            [CancelButton addTarget:self action:@selector(CancelButton:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonBorders:CancelButton];
            [CancelButton TransformButton];
            [self.reviewSecondView addSubview:CancelButton];
            
            
            UIButton *SubmitReviewButton=[[UIButton alloc]initWithFrame:CGRectMake(140, 215, 120, 37)];
            [SubmitReviewButton setTitle:AMLocalizedString(@"tSubmitReview", nil) forState:UIControlStateNormal];
            [SubmitReviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            SubmitReviewButton.titleLabel.font=[UIFont systemFontOfSize:15.0];
            SubmitReviewButton.backgroundColor=model.buttonColor;
            SubmitReviewButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            [SubmitReviewButton addTarget:self action:@selector(SubmitReview:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonBorders:SubmitReviewButton];
            self.reviewSecondView.frame=CGRectMake(11, y, addReviewView.frame.size.width-22, 256);
            [SubmitReviewButton TransformButton];
            [self.reviewSecondView addSubview:SubmitReviewButton];
            
            [self.view addSubview:coverView];
            self.addReviewView.frame=CGRectMake(self.view.frame.origin.x+15, 60, self.view.frame.size.width-30, _reviewSecondView.frame.origin.y+_reviewSecondView.frame.size.height+10);
            [coverView addSubview:self.addReviewView];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tYoucannotratethisproductrightnowasRatingsaredisabledtemporarily", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
            [alert show];
        }
    }
    else if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark Loaders

- (void)addLoadingView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    NSLog(@"addLoadingView");
}

- (void)removeLoadingView
{
    NSLog(@"removeLoadingView");
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
}


#pragma mark ---POPUP BUTTON METHODS---

- (IBAction)RatingButton:(id)sender
{
    
    long OptId = [sender tag];
    int RateId =[[sender accessibilityLabel]intValue];
    NSLog(@"%ld---%d",OptId,RateId);
    
    
    for (int h=0; h<arrRatingCodes.count; h++)
    {
        if ([[[arrRatingCodes objectAtIndex:h]valueForKey:@"rating_id"]intValue]==RateId)
        {
            NSArray *opt=[[arrRatingCodes objectAtIndex:h]valueForKey:@"options"];
            
            for (int c=0; c<opt.count; c++)
            {
                if ([[[opt objectAtIndex:c]valueForKey:@"option_id"]intValue]== OptId)
                {
                    
                    [(UIButton *)[self.view viewWithTag:OptId]setImage:[UIImage imageNamed:@"btn_radio-selected.png"] forState:UIControlStateNormal];
                }
                else
                {
                    
                    [(UIButton *)[self.view viewWithTag:[[[opt objectAtIndex:c]valueForKey:@"option_id"]intValue]]setImage:[UIImage imageNamed:@"btn_radio.png"] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    
    for (int k= 0; k<arrRatingCodes.count; k++)
    {
        if ([[[arrRatingCodes objectAtIndex:k]valueForKey:@"rating_id"]intValue]==RateId)
        {
            dictRating=[[NSMutableDictionary alloc]init];
            NSString *str = [NSString stringWithFormat:@"%d",RateId];
            NSString *optionId=[NSString stringWithFormat:@"%ld",OptId];
            [dictRating setValue:str forKey:@"rateid"];
            [dictRating setValue:optionId forKey:@"optionId"];
            
            NSLog(@"%@",dictRating);
            [arrAddRatings replaceObjectAtIndex:k withObject:dictRating];
            dictRating=nil;
            
        }
    }
    NSLog(@"%@",arrAddRatings);
}

#pragma mark ---Cancel Review Method---

- (IBAction)CancelButton:(id)sender
{
    [coverView setHidden:YES];
}

#pragma mark ---Submit Review Method---

/*
 optionId = 10;
 rateid = 2;
 },
 {
 optionId = 4;
 rateid = 1;
 },
 {
 optionId = 13;
 rateid = 3;
 */







- (IBAction)SubmitReview:(id)sender
{
    // -------------------------- Reachability --------------------//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(tNoInternet);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:tNoInternet delegate:nil cancelButtonTitle:tOK otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        NSString *msg=@"0";
        if ([arrAddRatings containsObject:@"0"]&& [msg isEqualToString:@"0"])
        {
            msg=@"1";
            [self alertViewMethod:AMLocalizedString(@"tPleaseselectoneofeachoftheratingsabove", nil)];
        }
        else if(([[Thoughts.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"])
        {
            msg=@"1";
            [self alertViewMethod:AMLocalizedString(@"tPleasetypeyourthoughtsfirst", nil)];
        }
        else if(([[Summary.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"])
        {
            msg=@"1";
            [self alertViewMethod:AMLocalizedString(@"tPleaseprovidesummaryofyourReview", nil)];
        }
        else if(([[nickName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) && [msg isEqualToString:@"0"])
        {
            msg=@"1";
            [self alertViewMethod:AMLocalizedString(@"tPleaseprovideyourNickname", nil)];
        }
        else
        {
            [self addLoadingView];
            
            //---------------- API----------------------
            
            NSMutableString *rating=[[NSMutableString alloc]init];
            for (int i=0; i<arrAddRatings.count; i++)
            {
                NSString *str6;
                if (arrAddRatings.count-1==i)
                {
                    str6=[NSString stringWithFormat:@"ratings[%@]=%@",[[arrAddRatings objectAtIndex:i]valueForKey:@"rateid"],[[arrAddRatings objectAtIndex:i]valueForKey:@"optionId"]];
                }
                else
                {
                    str6=[NSString stringWithFormat:@"ratings[%@]=%@&",[[arrAddRatings objectAtIndex:i]valueForKey:@"rateid"],[[arrAddRatings objectAtIndex:i]valueForKey:@"optionId"]];
                }
                [rating appendString:str6];
            }
            ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
            NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
            if ([str5 isEqualToString:@"(null)"])
            {
                str5=@"";
            }
            
            NSString *str1=[[NSString stringWithFormat:@"%@addProductReview?salt=%@&prod_id=%@&store_id=&page_id=&cust_id=%@&review_field=%@&summary_field=%@&nickname_field=%@&%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,strProdId,str5,Thoughts.text,Summary.text,nickName.text,rating,model.storeID,model.currencyID]stringByReplacingOccurrencesOfString:@" " withString:@""];
            [obj_apiClass ViewMore:[str1 stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(Submit_review_Response:)];
        }
    }
}


#pragma mark Api Response

-(void)Submit_review_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if ([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"success"])
    {
        [coverView setHidden:YES];
        [self.view endEditing:YES];
        [self alertViewMethod:[[responseDict valueForKey:@"response"]valueForKey:@"msg"]];
    }
    else
    {
        [self alertViewMethod:AMLocalizedString(@"tOopsSomethingwentwrong", nil)];
        [self.view endEditing:YES];
        [coverView setHidden:YES];
    }
}


#pragma mark Back Button Method

- (IBAction)BackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---Helper Methods---

-(void)setBorders:(UIView*)str
{
    //    str.layer.cornerRadius=4.0;
    //    str.layer.borderColor=[[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]CGColor];
    //    str.layer.borderWidth=1.0;
    //    str.layer.masksToBounds=YES;
}

-(void)setButtonBorders:(UIButton*)str
{
    //    str.layer.cornerRadius=4.0;
    //    str.layer.borderColor=[[UIColor clearColor]CGColor];
    //    str.layer.borderWidth=1.0;
    //    str.layer.masksToBounds=YES;
}

-(void)alertViewMethod:(NSString*)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
    [alert show];
    
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0], NSParagraphStyleAttributeName: style};
    CGRect rect = [bodyText boundingRectWithSize:CGSizeMake(190, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    return rect.size.height;
}


//#pragma mark touch event method
//
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [coverView setHidden:YES];
//
//}

#pragma mark Home Button method

- (IBAction)homeButton:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

#pragma mark TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==Thoughts)
    {
        [Summary becomeFirstResponder];
    }
    else if(textField==Summary)
    {
        [nickName becomeFirstResponder];
    }
    else
    {
        [nickName resignFirstResponder];
    }
    
    return YES;
}

@end
