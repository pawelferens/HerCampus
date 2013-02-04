//
//  SearchResultViewController.h
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/24/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "SearchArticlesConnectionManager.h"
#import "GADBannerView.h"
#import <iAd/iAd.h>
#import "AdvertisementManager.h"
#import "AppDelegate.h"
#import "DFPBannerView.h"
@interface SearchResultViewController : UIViewController<ADBannerViewDelegate>
{
    DFPBannerView *bannerView_;
    ADBannerView *adBannerView;
}
@property(nonatomic,retain)NSString* contentText;
@property (strong, nonatomic) IBOutlet UIWebView *content;
@property(nonatomic,retain)UIWebView* webView;
@property(nonatomic,retain)Article* articleA;
-(NSString*)getSectionNameWithId:(NSString*)idOfSection;
@property(nonatomic,retain) AdvertisementManager*man;
@property (strong, nonatomic) IBOutlet UIView *advView;
@property (nonatomic, retain) ADBannerView *adBannerView;
//@property (strong, nonatomic) IBOutlet UILabel *advView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property(nonatomic,retain)UIView * advPlace;
@property int screenHeigth;
@end
