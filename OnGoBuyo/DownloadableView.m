//
//  DownloadableView.m
//  OnGoBuyo
//
//  Created by Jatiender on 4/29/16.
//  Copyright © 2016 navjot_sharma. All rights reserved.
//

#import "DownloadableView.h"
#import "ApiClasses.h"
#import "MBProgressHUD.h"
#import "DownloadableCellTableViewCell.h"
#import "ViewController.h"
#import "Constants.h"
#import "ModelClass.h"
#import "Reachability.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIButton+Transformation.h"

@interface DownloadableView ()
{
    int v;
    NSMutableArray *arrProducts;
    ModelClass *model;
    __weak IBOutlet UILabel *mydownlodableLbl;
    __weak IBOutlet UILabel *noitemLbl;
}
@end

@implementation DownloadableView

- (void)viewDidLoad
{
    //    rtl or ltr
    [self.view TransformViewCont];
    [_topView TransformationView];
    [noitemLbl TransformLabel];
    [mydownlodableLbl TransformLabel];
    
    
    [super viewDidLoad];
    model=[ModelClass sharedManager];
    
    // change Word
    [mydownlodableLbl setText:AMLocalizedString(@"tMyDownloadables", nil)];
    [noitemLbl setText:AMLocalizedString(@"tNoItemtoView", nil)];
    
    v=0;
    _items=[[NSMutableArray alloc]init];
    [self getDownloadables];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //change color
    [_topView setBackgroundColor:model.themeColor];
    [mydownlodableLbl setTextColor:[UIColor whiteColor]];
    [noitemLbl setTextColor:model.secondaryColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"DownloadableView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate And DataSources


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_items.count!=0 && ViewMore==YES)
    {
        return _items.count+1;
    }
    else
    {
        return _items.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_items.count!=0 && indexPath.row<_items.count)
    {
        return 103;
    }
    else if(indexPath.row==_items.count)
    {
        return 45;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadableCellTableViewCell";
    DownloadableCellTableViewCell  *cell = (DownloadableCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    int y=93;
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    //rtl
    [cell.downloadable_lbl TransformAlignLabel];
    [cell.pending_lbl TransformAlignLabel];
    [cell.dateandTime_lbl TransformAlignLeftLabel];
    [cell.orderId_lbl TransformAlignLeftLabel];
    [cell.download_btn TransformButton];
    
    if (_items.count!=0 && indexPath.row<_items.count)
    {
        cell.downloadable_lbl.text = [[_items objectAtIndex:indexPath.row]valueForKey:@"product_title"];
        cell.pending_lbl.text = [[_items objectAtIndex:indexPath.row]valueForKey:@"status"];
        cell.pending_lbl.textColor=model.priceColor;
        cell.dateandTime_lbl.text = [[_items objectAtIndex:indexPath.row]valueForKey:@"order_date"];
        NSString *orderid = [[_items objectAtIndex:indexPath.row]valueForKey:@"order_id"];
        cell.orderId_lbl.text = [NSString stringWithFormat:@"%@%@",AMLocalizedString(@"tOrderId", nil),orderid];
        //        cell.download_btn.layer.masksToBounds = YES;
        //        cell.download_btn.layer.cornerRadius = 4.0;
        //        cell.download_btn.layer.borderWidth = 1.0;
        //        cell.download_btn.layer.borderColor = [[UIColor clearColor] CGColor];
        [cell.download_btn setBackgroundColor:model.secondaryColor];
        [cell.download_btn addTarget:self action:@selector(download_btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.download_btn setTitle:AMLocalizedString(@"tDownload", nil) forState:UIControlStateNormal];
        cell.download_btn.tag=indexPath.row;
    }
    
    if (indexPath.row==_items.count && ViewMore==YES)
    {
        UIButton *buttonView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _downloadable_tblVew.frame.size.width, 35)];
        [buttonView setBackgroundColor:[UIColor lightGrayColor]];
        [buttonView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonView setTitle:AMLocalizedString(@"tViewMore", nil) forState:UIControlStateNormal];
        [buttonView addTarget:self action:@selector(ViewMore:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:buttonView];
        cell.downloadable_lbl.hidden=YES;
        cell.pending_lbl.hidden=YES;
        cell.dateandTime_lbl.hidden=YES;
        cell.orderId_lbl.hidden = YES;
        cell.download_btn.hidden = YES;
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0,y, _downloadable_tblVew.frame.size.width, 10)];
    separator.backgroundColor=[UIColor whiteColor];
    [cell addSubview:separator];
    
    y=y+93;
    
    return cell;
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

#pragma  mark ---Download Method---

-(void)download_btnAction:(UIButton*)sender
{
    
    NSInteger tag = [sender tag];
    
    NSString *hash = [_items objectAtIndex:tag][@"link_hash"];
    NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
    if ([str5 isEqualToString:@"(null)"])
    {
        str5=@"";
    }
    NSString *str=[NSString stringWithFormat:@"%@getDLinkUrl?salt=%@&cust_id=%@&hash=%@&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,hash,model.storeID,model.currencyID];
    
    
    //---------------- API----------------------
    
    ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
    
    [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(dLinkUrlResponse:)];
    
    [self addLoadingView];
}

// Downloadable api response

-(void)dLinkUrlResponse:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    NSString *response = [responseDict valueForKey:@"response"];
    NSDictionary *returnCode = [responseDict valueForKey:@"returnCode"];
    
    NSString *resulttext = [returnCode valueForKey:@"resultText"];
    
    if ([resulttext isEqualToString:@"success" ])
    {
        NSString *stringURL = response;
        //NSURL  *url = [NSURL URLWithString:stringURL];
        NSURL *url = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else if([resulttext isEqualToString:@"Server Down" ])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:response delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)ViewMore:(id)sender
{
    if(ViewMore==YES)
    {
        [self getDownloadables];
    }
}


#pragma mark ---Get Downloadables API---

-(void)getDownloadables
{
    
    if (ViewMore==YES||v==0)
    {
        // -------------------------- Reachability --------------------//
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            NSLog(tNoInternet);
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoInternet", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [self addLoadingView];
            NSLog(@"There IS internet connection");
            v++;
            NSString *str5=[NSString stringWithFormat:@"%@",model.custId];
            if ([str5 isEqualToString:@"(null)"])
            {
                str5=@"";
            }
            NSString *str=[NSString stringWithFormat:@"%@getMyDownlodables?salt=%@&cust_id=%@&page_no=%i&cstore=%@&ccurrency=%@",baseURL1,model.salt,str5,v,model.storeID,model.currencyID];
            
            //---------------- API----------------------
            ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
            
            [obj_apiClass ViewMore:[str stringByReplacingOccurrencesOfString:@" " withString:@""] withTarget:self withSelector:@selector(DownloadableApiResponse:)];
        }
    }
}


-(void)DownloadableApiResponse:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    
    NSLog(@"%@",responseDict);
    NSDictionary *resultcode = [responseDict valueForKey:@"returnCode"];
    NSString *resultText = [resultcode valueForKey:@"resultText"];
    
    if ([resultText isEqualToString:@"success"])
    {
        NSDictionary *response = [responseDict valueForKey:@"response"];
        ViewMore = [[response valueForKey:@"more"]intValue];
        if (ViewMore)
        {
            ViewMore=YES;
            [_items addObjectsFromArray:[response valueForKey:@"items"]];
            [_downloadable_tblVew reloadData];
        }
        else
        {
            ViewMore=NO;
            [_items addObjectsFromArray:[response valueForKey:@"items"]];
            [_downloadable_tblVew reloadData];
        }
        if (_items.count == 0)
        {
            [_noDownload_item setHidden:NO];
            [_downloadable_tblVew setHidden:YES];
        }
    }
    else
    {
        
    }
}



- (IBAction)back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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


@end
