//
//  SearchArticlesConnectionManager.m
//  Her Campus 2.0
//
//  Created by Pawel Ferens on 1/29/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "SearchArticlesConnectionManager.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@implementation SearchArticlesConnectionManager
@synthesize foundArticles;
-(void)searchArticleswithKeyword:(NSString*)keyword
{
    NSString* urlString=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/articles?token=a1b2c3&limit=20&from=0&keyword=%@&inTitleOnly=false",keyword];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:@selector(loadBriefs:)
                               withObject:data waitUntilDone:NO];
    });
    
    
}


-(void)loadBriefs:(NSData *)responseData
{
    if(responseData)
    {
        foundArticles=[[NSMutableArray alloc]init];
        [foundArticles removeAllObjects];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData //1
                              
                              options:kNilOptions
                              error:&error];
        NSArray* articleList=[json objectForKey:@"articles"];//2
        
        for(int i=0;i<articleList.count;i++)
        {
            NSDictionary* art = [articleList objectAtIndex:i];
            Article* article=[[Article alloc]init];
            article.textSummary=[art objectForKey:@"textSumary"];
            article.title=[art objectForKey:@"title"];
            article.readCount=[art objectForKey:@"readCount"];
            article.pub_date=[art objectForKey:@"pub_date"];
            article.primaryArticleImage=[art objectForKey:@"primaryArticleImage"];
            article.link=[art objectForKey:@"link"];
            article.text=[art objectForKey:@"text"];
            article.author=[art objectForKey:@"author"];
            article.sections=[[NSMutableArray alloc]init];
            
            NSArray*sectionListArray=[art objectForKey:@"sections"];
            for(int z=0;z<[sectionListArray count];z++)
            {
                
                [article.sections addObject:[sectionListArray objectAtIndex:z]];
                NSLog(@"%@",[[article sections] objectAtIndex:0]);
                
            }
            
            NSLog(@"poszloladnie");
            
            [foundArticles addObject:article];
        }
        
        [self postNotification];
    }
    
    
}
- (void)postNotification
{
    NSString *notificationName = @"searchCompleted";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil ];
}
@end
