//
//  SearchArticlesConnectionManager.h
//  Her Campus 2.0
//
//  Created by Pawel Ferens on 1/29/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"
@interface SearchArticlesConnectionManager : NSObject
@property(nonatomic,retain)NSMutableArray* foundArticles;
-(void)searchArticleswithKeyword:(NSString*)keyword;
@end
