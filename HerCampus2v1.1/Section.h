//
//  Section.h
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject<NSCoding>
@property (nonatomic,retain)NSString* sectionName;
@property (nonatomic,retain)NSString* sectionNumber;
@property(nonatomic,retain)NSString* orderNumber;
@end

