//
//  AppDelegate.m
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "AppDelegate.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@implementation AppDelegate
@synthesize IAD;
@synthesize documentsDirectory;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    // Override point for customization after application launch.
    IAD=[[ADBannerView alloc]init];
    IAD.delegate=self;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.deviceType = [UIDevice currentDevice].model;
    NSLog(@"device type = %@",self.deviceType);

  
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
-(bool)checkNetworkStatus
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable)
    {
        NSLog(@"nie ma wifi");
        return NO;
    }
    else
    {
        NSLog(@"jest wifi");
        return YES;
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self checkNetworkStatus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [self checkNetworkStatus];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"loaded ad");
    
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* newStr = [[NSString alloc] initWithData:deviceToken
                                             encoding:NSUTF8StringEncoding];
    
    newStr = [[[deviceToken description]
      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    NSString*final=[NSString stringWithFormat:@"http://cryptic-bastion-2421.herokuapp.com/addDevice.php?token=a1b2c3&id=%@",newStr];
    NSURL*url=[NSURL URLWithString:final];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSLog(@"size of Object: %zd",[request description]);
    
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:newStr forKey:@"deviceToken"];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    NSLog(@"zle zarejestrowano");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // data has the full response
    NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newdata
{
    // [data appendData:newdata];
    NSLog(@"response");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
@end
