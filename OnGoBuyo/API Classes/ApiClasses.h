//
//  JuckeBoxApiClasses.h
//  JukeBox
//
//  Created by Gaurav Shukla on 9/15/15.
//  Copyright (c) 2015 softProdigy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiClasses : NSObject
{
    
    NSMutableData   *dataResponse;
    NSURLConnection *m_connection;
    
    id m_callBackTarget;
    SEL m_callBackSelector;

}
@property(nonatomic,assign)SEL m_callBackSelector;
#pragma mark Custom Methods

//-(void)HomePage:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

-(void)ViewMore:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

//-(void)ProductDetails:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

-(void)SearchCategory:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

-(void)SearchKeyword:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

-(void)AppInfo:(NSString *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;
-(void)UploadImage:(NSString *)url Data:(NSData *)ImageData parameters:(NSMutableDictionary *)Param withTarget:(id)tempTarget withSelector:(SEL)tempSelector;


//-(void)Category:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

//-(void)GetCategoryFavoritesApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;
//
//-(void)SaveOffersFavoritesApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;
//
//-(void)SaveRatingsFavoritesApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;
//-(void)SongApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;
//
//-(void)RatingApi:(NSDictionary *)location withTarget:(id)tempTarget withSelector:(SEL)tempSelector;


@end
