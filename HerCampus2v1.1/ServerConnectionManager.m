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


-(void)saveArticlesfromData: (NSData*)data withFileName: (NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [[documentsDirectory stringByAppendingPathComponent:fileName]stringByAppendingPathExtension:@"json"];
    [data writeToFile:filePath atomically:YES];
    
//saving thumb image
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data 
                          options:kNilOptions
                          error:&error];
    
    NSArray* articleList=[json objectForKey:@"articles"];
    
    for(int i=0;i<articleList.count;i++)
    {
        NSDictionary* art = [articleList objectAtIndex:i];
        if([art objectForKey:@"primaryArticleImage"] != nil){
            NSString *onlineFileName =[[art objectForKey:@"primaryArticleImage"] lastPathComponent];
            NSString *localFileName = [[[documentsDirectory stringByAppendingPathComponent:[art objectForKey:@"title"]] stringByAppendingString: @"__"] stringByAppendingString:onlineFileName];
            [self downloadImageFromURL:[art objectForKey:@"primaryArticleImage"] andSaveAs:localFileName];
        }
    }
//list for testing
    NSArray *directoryContent = [[NSFileManager defaultManager] directoryContentsAtPath: documentsDirectory];
    NSLog(@"files: %@", directoryContent);
}

-(void) downloadImageFromURL:(NSString *)fileURL andSaveAs: (NSString*) fileName{
    NSLog(@"Downloading... ");
    NSLog(@"from path: %@", fileURL);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    NSString *extension = [fileURL pathExtension];
    
    NSLog(@"to file %@: ", fileName);
    NSLog(@"with extension %@: ", extension);
    UIImage *image =[[UIImage alloc]initWithData:data];
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:fileName options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:fileName options:nil error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
    
}
- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(void)getNewest:(int)limit
{
    NSLog(@"getting newest");
    if([[self appdelegate]checkNetworkStatus]){
        dispatch_async(kBgQueue, ^{
            NSString* urlString=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/new?token=a1b2c3&limit=%d",limit];
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            if(data!=nil){
                [self performSelectorOnMainThread:@selector(loadBriefs:) withObject:data waitUntilDone:NO];
                [self saveArticlesfromData:data withFileName: @"all"];
            }
            else{
                [self getNewest:limit];
                return;
            }
        });
    }
    else{
        NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"all.json"];
         BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(fileExists)
        {
            NSLog(@"path %@", filePath);
            NSData *jsonData = [[NSData alloc]initWithContentsOfFile: filePath];
            NSError* error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData: jsonData
                                  options:kNilOptions
                                  error:&error];
            NSArray *articles = [json objectForKey:@"articles"];
            NSLog(@"article len:%d", [articles count]);
            [self performSelectorOnMainThread:@selector(loadBriefs:)
                                   withObject:jsonData waitUntilDone:NO];
        }
        
       
    }
   
   // 
}

-(void)getArticlesFromSection:(NSString *)sectionId
                     andLimit:(int )limit
{
    if([[self appdelegate]checkNetworkStatus]){
        dispatch_async(kBgQueue, ^{
            NSString*url=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/articles?token=a1b2c3&sectionId=%@&limit=%d&from=0",sectionId,limit];
            NSData* data = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:url]];
            if(data!=nil){
                [self performSelectorOnMainThread:@selector(loadBriefs:) withObject:data waitUntilDone:NO];
                [self saveArticlesfromData:data withFileName: sectionId];
            }
            else{
                [self getArticlesFromSection: sectionId andLimit:limit];
                return;
            }
        });
    }
    else{
        NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *filePath = [[documentsDirectory stringByAppendingPathComponent: sectionId] stringByAppendingPathExtension: @"json"];
        NSLog(@"path %@", filePath);
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(fileExists)
        {
        NSData *jsonData = [[NSData alloc]initWithContentsOfFile: filePath];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData: jsonData
                              options:kNilOptions
                              error:&error];
        NSArray *articles = [json objectForKey:@"articles"];
        NSLog(@"article len:%d", [articles count]);
        [self performSelectorOnMainThread:@selector(loadBriefs:)
                               withObject:jsonData waitUntilDone:NO];
        }
        else
        {
            NSString *notificationName = @"NoDataLoaded";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil ];

        }
    }
    
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

-(void)saveSectionsFromData:(NSData*)data{
    NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *filePath = [[documentsDirectory
                           stringByAppendingPathComponent:@"sections"]
                          stringByAppendingPathExtension:@"json"];
    [data writeToFile:filePath atomically:YES];
}

-(void)getSections
{
    if([[self appdelegate]checkNetworkStatus]){
        dispatch_async(kBgQueue, ^{
            NSString*url=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/api/sections?token=a1b2c3"];
            NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:url]];
           [self performSelectorOnMainThread:@selector(loadSections:)
                         withObject:data waitUntilDone:YES];
            [self saveSectionsFromData:data];
        });
    }
    else{
        NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"sections.json"];
        
       
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if(fileExists)
        {
            NSData *jsonData = [[NSData alloc]initWithContentsOfFile: filePath];
            [self performSelectorOnMainThread:@selector(loadSections:)
                                   withObject:jsonData waitUntilDone:YES];
            NSLog(@"plik istnieje");
        }
        else
        {
            NSString *notificationName = @"NoDataAtAll";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil ];
        }
     
    }
}
-(void)loadSections:(NSData *)responseData
{
   
    if(responseData)
    {
   
        sections=[[NSMutableArray alloc]init];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData //1
                              
                              options:kNilOptions
                              error:&error];
        NSArray* sectionsArray=[json objectForKey:@"sections"];
              NSLog(@"%d",[sectionsArray count]);
        for(int i=0;i<[sectionsArray count];i++)
        {
            NSDictionary* sectionsDictionary=[sectionsArray objectAtIndex:i];
            Section* section=[[Section alloc]init];
            section.sectionName=[sectionsDictionary objectForKey:@"name"];
          
            section.sectionNumber=[sectionsDictionary objectForKey:@"id"];
            section.orderNumber=[sectionsDictionary objectForKey:@"order"];
            [sections addObject:section];
        }
        NSString *notificationName = @"sectionsLoaded";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil ];
    }
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
            
            if(![[self appdelegate]checkNetworkStatus]
               && article.primaryArticleImage != nil
               && ![article.primaryArticleImage isEqualToString:@""]){
                NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
                NSString *fileName = [[article.title stringByAppendingString:@"__"] stringByAppendingString:[article.primaryArticleImage lastPathComponent]];
                NSLog(@"downloadedImage path: %@", [documentsDirectory stringByAppendingPathComponent:fileName]);
                article.downloadedImage=[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:fileName]];
            }
            NSArray*sectionListArray=[art objectForKey:@"sections"];
           // NSLog(@"sekcje w artykule: %@",sectionListArray);
            for(int z=0;z<[sectionListArray count];z++)
            {
               
                [article.sections addObject:[sectionListArray objectAtIndex:z]];
           
                
            }
       
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
