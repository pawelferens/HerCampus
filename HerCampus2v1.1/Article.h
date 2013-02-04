//
//  Article.h
//  HerCampus
//
//  Created by Pawel Ferens on 11/20/12.
//  Copyright (c) 2012 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Article : NSObject
@property (nonatomic,retain) NSString * text;
@property (nonatomic,retain) NSString *textSummary;
@property (nonatomic,retain) NSString *primaryArticleImage;
@property (nonatomic,retain) NSString *pub_date;
@property (nonatomic,retain) NSString *link;
@property (nonatomic,retain) NSString *xpath;
@property (nonatomic,retain) NSString *author;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSMutableArray* sections;
@property (nonatomic,retain) NSMutableArray*media;
@property (nonatomic,retain) NSString* readCount;
@property (nonatomic,retain) UIImage* downloadedImage;
@end
