//
//  Section.m
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "Section.h"

@implementation Section
@synthesize sectionName;
@synthesize sectionNumber;
@synthesize orderNumber;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:sectionName forKey:@"sectionName"];
    [aCoder encodeObject:sectionNumber forKey:@"sectionNumber"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSString* sectionName=[aDecoder decodeObjectForKey:@"sectionName"];
     NSString* sectionNumber=[aDecoder decodeObjectForKey:@"sectionNumber"];
    return [self initWithName:sectionName andNumber:sectionNumber];
    
}
- (id) initWithName:(NSString* )name
          andNumber:(NSString*)number
{
    if(self = [super init]) {
        // do initialization of instance variables etc.
        self.sectionName=name;
        self.sectionNumber=number;
    }
    
    return self;
}
@end
