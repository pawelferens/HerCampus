//
//  AdvertisementManager.h
//  Her Campus 2.0
//
//  Created by Pawel Ferens on 1/28/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface AdvertisementManager : NSObject
@property (nonatomic,retain)NSString* type;
-(void)getAdvertisementType;
@end
