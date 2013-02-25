//
//  AppDelegate.h
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,ADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)ADBannerView*IAD;
@property (nonatomic, assign) NSString *documentsDirectory;

-(bool)checkNetworkStatus;
@end
