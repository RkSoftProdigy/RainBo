//
//  ApiClasses.m
//  Created by Gaurav Shukla on 9/15/15.
//  Copyright (c) 2015 softProdigy. All rights reserved.
//

#import "ApiClasses.h"
#import "SBJSON.h"
#import "Constants.h"

@implementation ApiClasses
@synthesize m_callBackSelector;


#pragma mark NSURL Connection Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(dataResponse!=nil)
    {
        dataResponse=nil;
    }
    dataResponse=[[NSMutableData alloc]init];
    [dataResponse setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataResponse appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *str=[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding];
    if(dataResponse)
    {
        dataResponse = nil;
    }
    if (connection) {
        [connection cancel];
    }
    
    SBJSON *objJson=[SBJSON new];
    
    NSDictionary *dict = [objJson objectWithString:str];
   
    if(m_callBackSelector!=nil)
    {
        if([dict count]>0)
        {
            [m_callBackTarget performSelector:self.m_callBackSelector withObject:dict];
        }
        else
        {
            [m_callBackTarget performSelector:self.m_callBackSelector withObject:dict];
        }
    }
   
    str=nil;
    objJson=nil;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(dataResponse)
    {
        dataResponse = nil;
    }
    NSDictionary *dictReturnCode = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:3],@"result", @"Server Down",@"resultText",nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictReturnCode,@"returnCode",nil];
    dictReturnCode = nil;
    [m_callBackTarget performSelector:self.m_callBackSelector withObject:dict];
}

//-(void)Category:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection =[[NSString alloc]init];
//    strConnection=category1;
//    
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//    SBJSON *objJson=[SBJSON new];
//    NSString *str=[objJson stringWithObject:location];
//    objJson = nil;
//    
//    [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"String  %@",str);
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}


//#pragma mark Home Page API
//
//-(void)HomePage:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//  
//    NSString *strConnection =[[NSString alloc]init];
//    strConnection=home;
//    
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//     SBJSON *objJson=[SBJSON new];
//    NSString *str=[objJson stringWithObject:location];
//    objJson = nil;
//    
//    [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"String  %@",str);
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//
#pragma mark View More API

-(void)ViewMore:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
{
    m_callBackSelector=tempSelector;
    m_callBackTarget=tempTarget;
    
    NSURL *strConnection =[[NSURL alloc]init];
    strConnection=[NSURL URLWithString:location];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:strConnection cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    strConnection = nil;

    [theRequest setHTTPMethod:@"POST"];
    
    NSLog(@"request made --%@",theRequest);
    
    if(strConnection)
    {
        strConnection = nil;
    }
    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
}

-(void)UploadImage:(NSString *)url Data:(NSData *)ImageData parameters:(NSMutableDictionary *)Param withTarget:(id)tempTarget withSelector:(SEL)tempSelector
{
    NSLog(@"%lu",(unsigned long)ImageData.length);
    m_callBackSelector=tempSelector;
    m_callBackTarget=tempTarget;
   // NSString *urlString=@"URL NAME";
    
    NSString *strConnection =[[NSString alloc]init];
    strConnection=url;
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    strConnection = nil;
    
  //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
  //  [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",@"profileimage-file",@"image.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:ImageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    for (NSString *key in Param.keyEnumerator)
    {
        NSLog(@"%@",key);
        NSLog(@"%@",[Param objectForKey:key]);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[Param objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //do something here;
    }
    

    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // set request body
    [request setHTTPBody:body];
    
   // NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
   // NSLog(@"%@", returnString);
    
    if(strConnection)
    {
        strConnection = nil;
    }
    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:request delegate:self];

    
}


//-(void)ProductDetails:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection =[[NSString alloc]init];
//    strConnection=location;
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//    
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//
//}


-(void)SearchCategory:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
{
    m_callBackSelector=tempSelector;
    m_callBackTarget=tempTarget;
    
    NSString *strConnection =[[NSString alloc]init];
    strConnection=location;
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    strConnection = nil;
    
    [theRequest setHTTPMethod:@"POST"];
    
    NSLog(@"request made --%@",theRequest);
    
    if(strConnection)
    {
        strConnection = nil;
    }
    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
}

-(void)SearchKeyword:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
{
    m_callBackSelector=tempSelector;
    m_callBackTarget=tempTarget;
    
    NSString *strConnection =[[NSString alloc]init];
    strConnection=location;
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    strConnection = nil;
    
    [theRequest setHTTPMethod:@"POST"];
    
    NSLog(@"request made --%@",theRequest);
    
    if(strConnection)
    {
        strConnection = nil;
    }
    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
}

-(void)AppInfo:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
{
    m_callBackSelector=tempSelector;
    m_callBackTarget=tempTarget;
    
    NSString *strConnection =[[NSString alloc]init];
    strConnection=location;
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    strConnection = nil;
    
    [theRequest setHTTPMethod:@"POST"];
    
    NSLog(@"request made --%@",theRequest);
    
    if(strConnection)
    {
        strConnection = nil;
    }
    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    
}


//-(void)GetCategoriesApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection = GetCategories;
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//    SBJSON *objJson=[SBJSON new];
//    NSString *str=[objJson stringWithObject:location];
//    objJson = nil;
//    
//    [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"String  %@",str);
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//
//
//
//-(void)BannersAPIwithTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection = GetBanners;
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//    
//
//    [theRequest setHTTPMethod:@"POST"];
//    
//        NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//
//-(void)LocationApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection = getLocation;
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//    SBJSON *objJson=[SBJSON new];
//    NSString *str=[objJson stringWithObject:location];
//    objJson = nil;
//    
//    [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"String  %@",str);
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//
//-(void)LocationAPIwithTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection = getLocations;
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//    
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//
//-(void)GetCategoryFavoritesApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection = SaveFavorites;
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    
//    strConnection = nil;
//    SBJSON *objJson=[SBJSON new];
//    NSString *str=[objJson stringWithObject:location];
//    objJson = nil;
//    
//    [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"String  %@",str);
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//-(void)SaveOffersFavoritesApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection = SaveFavorites;
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    NSLog(@"Dictionary:%@",location);
//    
//    strConnection = nil;
//    SBJSON *objJson=[SBJSON new];
//    NSString *str=[objJson stringWithObject:location];
//    objJson = nil;
//    
//    [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"String  %@",str);
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//
//-(void)SaveRatingsFavoritesApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector
//{
//    m_callBackSelector=tempSelector;
//    m_callBackTarget=tempTarget;
//    
//    NSString *strConnection = SaveRatings;
//    
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strConnection] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
//    NSLog(@"Dictionary:%@",location);
//    
//    strConnection = nil;
//    SBJSON *objJson=[SBJSON new];
//    NSString *str=[objJson stringWithObject:location];
//    objJson = nil;
//    
//    [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"String  %@",str);
//    NSLog(@"request made --%@",theRequest);
//    
//    if(strConnection)
//    {
//        strConnection = nil;
//    }
//    strConnection = (NSString*)[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//}
//
//
//
//
//#pragma mark Connection Delegate Methods
//
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    if(dataResponse)
//    {
//        dataResponse = nil;
//    }
//    dataResponse = [[NSMutableData alloc]init];
//    [dataResponse setLength:0];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [dataResponse appendData:data];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    m_connection = nil;
//    NSLog(@"Connection failed: %@", [error description]);
//    
//    NSDictionary *dictReturnCode = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:3],@"result", @"Server Down",@"resultText",nil];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictReturnCode,@"Response",nil];
//    dictReturnCode = nil;
//    
//    [m_callBackTarget performSelector:m_callBackSelector withObject:dict];
//    
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    
//    m_connection = nil;
//    NSString *responseString = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
//    NSLog(@"response string ---%@",responseString);
//    dataResponse = nil;
//    
//    SBJSON *json = [SBJSON new];
//    NSDictionary *dict = [json objectWithString:responseString error:nil];
//    
//    json = nil;
//    responseString = nil;
//    //NSLog(@"array---%@",response);
//    [m_callBackTarget performSelector:m_callBackSelector withObject:dict];
//    
//}
//
//
@end
