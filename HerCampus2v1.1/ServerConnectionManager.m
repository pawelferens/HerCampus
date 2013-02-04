//
//  ServerConnectionManager.m
//  HerCampus
//
//  Created by Pawel Ferens on 11/20/12.
//  Copyright (c) 2012 Pawel Ferens. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "ServerConnectionManager.h"

@implementation ServerConnectionManager
@synthesize articles;
@synthesize briefs;
@synthesize sections;
-(void)getNewest:(int)limit
{
    NSString* urlString=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/new?token=a1b2c3&limit=%d",limit];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:@selector(loadBriefs:)
                               withObject:data waitUntilDone:NO];
    });
    
    
}

-(void)getArticlesFromSection:(NSString *)sectionId
                     andLimit:(int )limit
{
    dispatch_async(kBgQueue, ^{
        NSString*url=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/articles?token=a1b2c3&sectionId=%@&limit=%d&from=0",sectionId,limit];
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:url]];
        
        [self performSelectorOnMainThread:@selector(loadBriefs:)
                               withObject:data waitUntilDone:NO];
    });
}
-(void)getArticle:(NSString *)articleID
{
    dispatch_async(kBgQueue, ^{
        NSString*url=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/article?token=a1b2c3&articleId=%@",articleID];
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:url]];
        
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:NO];
    });
}



-(void)getSections
{
    dispatch_async(kBgQueue, ^{
     /*   NSString*url=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/sections?token=a1b2c3"];*/
    //    NSData* data = [NSData dataWithContentsOfURL:
                    //    [NSURL URLWithString:url]];
        
        //   [self performSelectorOnMainThread:@selector(fetchedData:)
        //                 withObject:data waitUntilDone:NO];
    });
}

-(void)loadBriefs:(NSData *)responseData
{
    if(responseData)
    {
        briefs=[[NSMutableArray alloc]init];
        [briefs removeAllObjects];
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
             //   NSLog(@"%@",[[article sections] objectAtIndex:0]);
                
            }
            
       //     NSLog(@"poszloladnie");
            
            [briefs addObject:article];
        }
        
        [self postNotification];
    }
    
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
     //   NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}
- (void)postNotification
{
    NSString *notificationName = @"DataRefreshed";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil ];
}
@end
