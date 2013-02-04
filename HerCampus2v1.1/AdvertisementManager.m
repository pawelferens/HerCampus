//
//  AdvertisementManager.m
//  Her Campus 2.0
//
//  Created by Pawel Ferens on 1/28/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "AdvertisementManager.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@implementation AdvertisementManager
@synthesize type;
-(void)getAdvertisementType
{
    NSString* urlString=[NSString stringWithFormat:@"http://hercampuscme.appspot.com/getInfo?token=a1b2c3"];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:@selector(dataToString:)
                               withObject:data waitUntilDone:NO];
    });
    
    
}
-(void)dataToString:(id)data
{
   type = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@--",self.type);
    [self postNotification];
}
- (void)postNotification
{
    NSString *notificationName = @"TypeRefreshed";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil ];
}
@end
