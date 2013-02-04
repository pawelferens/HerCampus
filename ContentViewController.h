//
//  ContentViewController.h
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import <MessageUI/MessageUI.h>
#import "GADBannerView.h"
#import "AdvertisementManager.h"
#import <iAd/iAd.h>
#import "DFPBannerView.h"
#import "AppDelegate.h"
@interface ContentViewController : UIViewController<UIScrollViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ADBannerViewDelegate>
{
        DFPBannerView *bannerView_;
     ADBannerView *adBannerView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property(nonatomic,retain)NSMutableArray* articlesWebViews;
@property int screenWidth;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
@property int screenHeigth;
@property (strong, nonatomic) IBOutlet UIButton *goToPreviousArticle;
@property (strong, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *goToNextArticle;
@property  int selectedArticleIndex;
@property(nonatomic,retain) NSString* selectedSectionName;
@property(nonatomic,retain)NSMutableArray* articles;
@property (strong, nonatomic) IBOutlet UIImageView *lA;
@property (strong, nonatomic) IBOutlet UIImageView *rA;
@property (strong, nonatomic) IBOutlet UIView *secondAdvView;
@property(nonatomic,retain) AdvertisementManager*man;
@property (strong, nonatomic) IBOutlet UIView *advView;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property(nonatomic,retain)UILabel*advTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *anotherAdvTypeLabel;
@end
