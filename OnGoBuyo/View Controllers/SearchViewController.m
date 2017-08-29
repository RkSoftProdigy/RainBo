//
//  SearchViewController.m
//  OnGoBuyo
//
//  Created by Gaurav Shukla on 2/11/16.
//  Copyright (c) 2016 navjot_sharma. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "ApiClasses.h"
#import "MBProgressHUD.h"
#import "ViewMoreViewController.h"
#import "ProductCollectionCellCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ModelClass.h"
#import "ProductDetailsViewController.h"
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "LocalizationSystem.h"
#import "UIView+transformView.h"
#import "UILabel+transformLabel.h"
#import "UIImageView+transforming.h"
#import "UIButton+Transformation.h"
#import "UITextField+transformField.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray * arrCategory;
    NSMutableArray * arrProductCategory;
    NSMutableArray * arrCategoryId;
    NSArray * SearchArray;
    NSMutableArray * arrMoreProducts;
    ModelClass * model;
}
@property (weak, nonatomic) IBOutlet UITableView *tblCategory;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;

@property (weak, nonatomic) IBOutlet UIImageView *imgSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (strong, nonatomic) IBOutlet UIView *viewCollection;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchFor;


@end

@implementation SearchViewController

static NSString * const kCellReuseIdentifier = @"customCell";

- (void)viewDidLoad
{
    //rtl
    [self.view TransformViewCont];
    [_topView TransformationView];
    [_tfSearch TransformTextField];
    [_lblSearchFor TransformLabel];
    
    [super viewDidLoad];
    
    
    //word change
    [_tfSearch setPlaceholder:AMLocalizedString(@"tSearch", nil)];
    
    
    model = [ModelClass sharedManager];
    
    [self.tblCategory setHidden:YES];
    
    //    self.imgSearch.layer.masksToBounds = YES;
    //    self.imgSearch.layer.cornerRadius = 4.0;
    arrMoreProducts = [[NSMutableArray alloc]init];
    [self.viewCollection setHidden:YES];
    
    [self.collectionview registerNib:[UINib nibWithNibName:@"ProductCollectionCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    self.collectionview.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(145, 170)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionview setCollectionViewLayout:flowLayout];
    [self.collectionview setAllowsSelection:YES];
    self.tfSearch.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    //API call
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self CategoryApi];
        });
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //change color
    [_topView setBackgroundColor:model.themeColor];
    
    NSString *pT=[NSString stringWithFormat:@"%@",model.pkgType];
    if([pT intValue]==301)
    {
        //manual tracking code
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"SearchView"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Search Category Api

-(void)CategoryApi
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
        
        //   ------API Call------
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];
        
        NSString *str=[NSString stringWithFormat:@"%@getSearchFormData?salt=%@",baseURL1,model.salt,model.storeID,model.currencyID];
        [obj_apiClass SearchCategory:str withTarget:self withSelector:@selector(Get_API_Response:)];
    }
}


#pragma mark Api Response

-(void)Get_API_Response:(NSDictionary*)responseDict
{
    [self removeLoadingView];
    NSLog(@"%@",responseDict);
    if([[[responseDict valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        [self removeLoadingView];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        arrCategory = [[[responseDict valueForKey:@"response"]valueForKey:@"categories"]valueForKey:@"name"];
        
        arrCategoryId =[[[responseDict valueForKey:@"response"]valueForKey:@"categories"]valueForKey:@"category_id"];
        
        arrProductCategory =[[responseDict valueForKey:@"response"]valueForKey:@"products"];
        
        [self.tblSearch reloadData];
    }
}


#pragma mark - TableView Delegate And DataSources


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblSearch)
    {
        return 44;
    }
    else
    {
        return 30;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tblSearch)
    {
        return [arrCategory count];
    }
    else
    {
        return [SearchArray count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tblSearch)
    {
        ViewMoreViewController *objViewController = [[ViewMoreViewController alloc]initWithNibName:@"ViewMoreViewController" bundle:nil];
        
        NSString * categoryID = [arrCategoryId objectAtIndex:indexPath.row];
        NSString * categoryName = [arrCategory objectAtIndex:indexPath.row];
        
        objViewController.categoryID = categoryID;
        objViewController.apiType = @"SearchApi";
        objViewController.strName = categoryName;
        
        
        [self.navigationController pushViewController:objViewController animated:YES];
    }
    else
    {
        [self.tfSearch resignFirstResponder];
        [self.tblSearch setHidden:YES];
        [self.tblCategory setHidden:YES];
        NSString * str = [SearchArray objectAtIndex:indexPath.row];
        self.tfSearch.text = str;
        [self Search_Api:str];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tblSearch)
    {
        static NSString *CellIdentifier = @"SearchCell";
        SearchCell *cell = (SearchCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        cell.lblCategory.text = [arrCategory objectAtIndex:indexPath.row];
        [cell.lblCategory TransformAlignLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.textLabel.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        
        cell.textLabel.text = [SearchArray objectAtIndex:indexPath.row];
        [cell.textLabel TransformAlignLabel];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}


#pragma mark -  textField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self.tblSearch setHidden:YES];
    [self.tblCategory setHidden:NO];
    
    NSString *stringText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", stringText];
    
    if ([stringText isEqualToString:@""])
    {
        
    } else {
        
        
        SearchArray = [arrProductCategory filteredArrayUsingPredicate:resultPredicate];
        
    }
    
    if(stringText.length==0)
    {
        if(arrMoreProducts.count>0)
        {
            [self.tblSearch setHidden:NO];
            [self.tblCategory setHidden:YES];
        }
        else
        {
            [self.tblSearch setHidden:NO];
            [self.tblCategory setHidden:YES];
        }
    }
    else
    {
        [self.tblSearch setHidden:YES];
        [self.tblCategory setHidden:NO];
        [self.viewCollection setHidden:YES];
    }
    
    
    [self.tblCategory reloadData];
    
    if(self.tblCategory.contentSize.height>self.view.frame.size.height-140)
    {
        self.tblCategory.frame = CGRectMake(10, 124, 299,self.view.frame.size.height-140);
    }
    else
    {
        self.tblCategory.frame = CGRectMake(10, 124, 299, SearchArray.count*30);
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField.text.length!=0)
    {
        NSString * str = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self Search_Api:str];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasetypesomewords", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        
    }
    return YES;
}

- (IBAction)searchButton:(id)sender
{
    [_tfSearch resignFirstResponder];
    
    if(_tfSearch.text.length!=0)
    {
        NSString * str = [_tfSearch.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self Search_Api:str];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tPleasetypesomewords", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles:nil];
        [alert show];
        
    }
}

#pragma mark - Search Api

-(void)Search_Api:(NSString *)searchKey
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
        
        //   ------API Call------
        
        self.lblSearchFor.text = [NSString stringWithFormat:@"%@ '%@'",AMLocalizedString(@"tSearchfor", nil),searchKey];
        
        ApiClasses *obj_apiClass= [[ApiClasses alloc]init];

        NSString *unreserved = @"*-._";
        NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                          alphanumericCharacterSet];
        [allowed addCharactersInString:unreserved];
    
            [allowed addCharactersInString:@" "];
        
        NSString *encoded = [searchKey stringByAddingPercentEncodingWithAllowedCharacters:allowed];
       
            encoded = [encoded stringByReplacingOccurrencesOfString:@" "
                                                         withString:@"+"];
        NSLog(@"%@",encoded);

        NSString *str=[NSString stringWithFormat:@"%@getSearch?salt=%@&keyword=%@",baseURL1,model.salt,encoded];
        NSLog(@"%@",str);
        [obj_apiClass SearchKeyword:str withTarget:self withSelector:@selector(Get_API_Response1:)];
    }
}

-(void)Get_API_Response1:(NSDictionary *)response
{
    [self removeLoadingView];
    NSLog(@"response------%@",response);
    
    
    if (![[[response valueForKey:@"returnCode"]valueForKey:@"resultText"] isEqualToString:@"fail"])
    {
        NSArray *arr=[[NSArray alloc]init];
        arr=[response valueForKey:@"response"];
        if (arrMoreProducts.count>0)
        {
            [arrMoreProducts removeAllObjects];
            
        }
        [arrMoreProducts addObjectsFromArray:arr];
        
        self.viewCollection.frame = CGRectMake(10, 135, 300, self.view.frame.size.height-115);
        
        [self.viewCollection setHidden:NO];
        [self.view addSubview:self.viewCollection];
        [self.tblCategory setHidden:YES];
        [self.tblSearch setHidden:YES];
        [self.collectionview reloadData];
    }
    else if([[[response valueForKey:@"returnCode"]valueForKey:@"resultText"]isEqualToString:@"Server Down"])
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tOopsSomethingwentwrong", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:AMLocalizedString(@"tNoresultfound", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"tOK", nil)  otherButtonTitles:nil, nil];
        [alert show];
        [self.tblSearch setHidden:NO];
        
    }
    
}

#pragma mark - Collection View Datasource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrMoreProducts count];
}

- (ProductCollectionCellCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCollectionCellCollectionViewCell *cell = (ProductCollectionCellCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    //    cell.borderImage.layer.cornerRadius=4;
    //    cell.borderImage.layer.borderWidth=1;
    //    cell.borderImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [cell.inStock TransformAlignLeftLabel];
    [cell.productImage TransformImage];
    [cell.productPrice TransformAlignLeftLabel];
    [cell.productName TransformAlignLabel];
    [cell.productOff TransformAlignLabel];
    [cell.orderImage TransformButton];
    
    if ([[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"in_stock"]intValue]==1)
        
    {
        cell.inStock.textColor=[UIColor colorWithRed:133.0/255.0 green:183.0/255.0 blue:78.0/255.0 alpha:1.0];
        cell.inStock.text=AMLocalizedString(@"tInStock", nil);
        
    }
    else
    {
        cell.inStock.textColor=[UIColor redColor];
        cell.inStock.text=AMLocalizedString(@"tOutofStock", nil);
        
    }
    cell.imageLine.backgroundColor=model.buttonColor;
    
    [cell.productImage sd_setImageWithURL:[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    
    cell.productName.text=[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"name"];
    
    if (![[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_disc"]isEqualToString:@"0"])
    {
        cell.orderImage.hidden=NO;
        [cell.orderImage setTitle:[NSString stringWithFormat:@"%d%@%@",[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_disc"]intValue],@"%",AMLocalizedString(@"tOff", nil)] forState:UIControlStateNormal];
    }
    else
    {
        cell.orderImage.hidden=YES;
    }
    
    
    if ([[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"type_id"] isEqualToString:@"grouped"]||[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"type_id"] isEqualToString:@"bundle"])
    {
        cell.productOff.hidden=YES;
        [cell.productPrice setTextColor:model.priceColor];
        cell.productPrice.text=[NSString stringWithFormat:@"%@",[self stringByStrippingHTML:[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"price_html"]stringByReplacingOccurrencesOfString:@"\n" withString:@""]]];
    }
    else
    {
        if ([[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue ]>[[[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_price"] stringByReplacingOccurrencesOfString:@"," withString:@""]floatValue])
        {
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                         };
            
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",model.currencySymbo,[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"price"]] attributes:attributes];
            
            cell.productOff.attributedText=attrText;
            
            cell.productOff.hidden=NO;
        }
        else
        {
            cell.productOff.hidden=YES;
        }
        [cell.productPrice setTextColor:model.priceColor];
        cell.productPrice.text=[NSString stringWithFormat:@"%@%@",model.currencySymbo,[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"final_price"]];
    }
    
    float result= [[[arrMoreProducts objectAtIndex:indexPath.row ] valueForKey:@"rating"]floatValue]/100*5;
    
    if (result==0.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==0.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==1.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==1.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==2.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==2.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==3.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-blank.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==3.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-half.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==4.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-blank.png"];
    }
    else if (result==4.5)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-half.png"];
    }
    else if (result==5.0)
    {
        cell.rating1.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating2.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating3.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating4.image=[UIImage imageNamed:@"star-filled.png"];
        cell.rating5.image=[UIImage imageNamed:@"star-filled.png"];
    }
    
    return cell;
    
}

#pragma mark- Collection View Delegate

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    ProductDetailsViewController *objViewController = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
    
    objViewController.strProdId=[[arrMoreProducts objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    [self.navigationController pushViewController:objViewController animated:YES];
    
    objViewController = nil;
}


#pragma mark - Loaders

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

#pragma mark - Back Button Action

- (IBAction)backButto_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --Helper Method--

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str;
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
