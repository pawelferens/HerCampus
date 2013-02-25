//
//  ServerConnectionManager.h
//  HerCampus
//
//  Created by Pawel Ferens on 11/20/12.
//  Copyright (c) 2012 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"
#import "Section.h"
#import "AppDelegate.h"

@interface ServerConnectionManager : NSObject
@property (nonatomic)NSMutableArray* articles;
@property (nonatomic)NSMutableArray*briefs;
@property (nonatomic)NSMutableArray*sections;
@property (nonatomic)NSData *newestData;
-(void)getNewest:(int)limit;
-(void)getArticlesFromSection:(NSString *)sectionId
                     andLimit:(int )limit;
-(void)postNotification;
-(void)getArticle:(NSString *)articleID;
-(void)getSections;

@end
