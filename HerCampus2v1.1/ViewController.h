//
//  ViewController.h
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnectionManager.h"
#import "UIImageView+WebCache.h"
#import <MessageUI/MessageUI.h>
#import "ContentViewController.h"
#import "SearchViewController.h"
#import "GADBannerView.h"
#import <iAd/iAd.h>
#import "AdvertisementManager.h"
#import "DFPBannerView.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,ADBannerViewDelegate>
{
    DFPBannerView *bannerView_;
     ADBannerView *adBannerView;
    int currentSection;
    UIButton*b;
}
@property(nonatomic,retain)UIButton*informationButton;
@property(nonatomic,retain)UIButton* shareButton;
@property(nonatomic,retain)UIImageView * arrowLeftImage;
@property(nonatomic,retain)UIImageView * arrowRightImage;
@property(nonatomic,retain)NSMutableArray* articles;
@property (strong, nonatomic) IBOutlet UITableView *articlesTableView;
@property int screenWidth;
@property int screenHeigth;
@property (nonatomic,retain)ServerConnectionManager* manager;
@property(nonatomic,retain)ContentViewController* contentController;
@property (nonatomic,retain)UIScrollView* sectionsView;
@property(nonatomic,retain) NSString* selectedSectionName;
@property(nonatomic,retain)UIView* line;
@property(nonatomic,retain)UIActivityIndicatorView*spinner;
@property(nonatomic,retain)UIActivityIndicatorView*spinner2;
@property(nonatomic,retain)UIView *loadingView;
@property int numberOfLoadedArticles;
@property(nonatomic,retain)SearchViewController*controller;
@property (strong, nonatomic) IBOutlet UIView *advView;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (strong, nonatomic) IBOutlet UILabel *advTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *labelLoadingView;
@property(nonatomic,retain)AdvertisementManager*managerAdv;
@property int isAdvertisementNull;
@property(nonatomic,retain)NSMutableArray* sections;
@property int isLoading;
@property(nonatomic,retain)UIButton*loadMore;
@property(nonatomic, retain) UIView* footer;
@property(nonatomic, retain) UITextView *noContentLabel;
@property bool isOfflinePreview;
@property bool isOnline;
@end
