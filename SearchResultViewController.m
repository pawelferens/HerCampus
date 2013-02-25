//
//  SearchResultViewController.m
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/24/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
@synthesize content;
@synthesize contentText;
@synthesize webView;
@synthesize articleA;
@synthesize adBannerView;
@synthesize man;
@synthesize advView;
@synthesize advPlace;
@synthesize label;
@synthesize screenHeigth;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) createAdBannerView
{
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    CGRect bannerFrame = self.adBannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    self.adBannerView.frame = bannerFrame;
    
    self.adBannerView.delegate = self;
    self.adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
}
- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)typeRefreshed:(NSNotification *)notification //use notification method and logic
{
    NSLog(@">>%@>>", man.type);
    
    if([man.type isEqualToString:@"APPLE_I_ADDS\n"])
    {
        bannerView_.alpha=0;
        adBannerView=[[self appdelegate]IAD];
      
        [adBannerView setFrame:CGRectMake(0, screenHeigth -50, 320, 50)];
        adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
        [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, self.view.frame.size.height-123)];
        [self.view addSubview:adBannerView];
        
        adBannerView.alpha=1;
      
    }
    else if([man.type isEqualToString:@"AD_MOB\n"])
    {
        [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, self.view.frame.size.height-123)];
        bannerView_ = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        adBannerView.alpha=0;
        bannerView_.alpha=1;
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a151101590214be";                                     //banner id from website
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [bannerView_ loadRequest:[GADRequest request]];
        [self.advPlace addSubview:bannerView_];
        [self.view addSubview:advPlace];
        
      
    }
    else if([man.type isEqualToString:@"NONE\n"])
    {
       [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, self.view.frame.size.height-73)];
    }
    else
    {
        UILabel*t=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        [t setTextColor:[UIColor whiteColor]];
        t.backgroundColor=[UIColor blackColor];
        t.text=man.type;
        t.textAlignment = UITextAlignmentCenter;
       [t setFont: [UIFont boldSystemFontOfSize:21.0]];
        [advPlace addSubview:t];
        [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, self.view.frame.size.height-123)];
        [self.view addSubview:advPlace];
        
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    // [self.contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height-60-50)];
    //[secondAdvView setFrame:CGRectMake(secondAdvView.frame.origin.x, self.view.frame.size.height-50, secondAdvView.frame.size.width, secondAdvView.frame.size.height)];
    [self adjustBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self adjustBannerView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void) adjustBannerView
{
    CGRect contentViewFrame = self.view.bounds;
    CGRect adBannerFrame = self.adBannerView.frame;
    
    if([self.adBannerView isBannerLoaded])
    {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier];
        contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    else
    {
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.adBannerView.frame = adBannerFrame;
        // self.articlesTableView.frame = contentViewFrame;
    }];
  //  [ self.secondAdvView setFrame:CGRectMake(0, self.view.frame.origin.y, 320, self.adBannerView.frame.size.height )];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.advPlace=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    advPlace.backgroundColor=[UIColor blackColor];

    NSString *notificationnName = @"TypeRefreshed";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(typeRefreshed:)
     name:notificationnName
     object:nil];
     screenHeigth=self.view.frame.size.height;
   
	// Do any additional setup after loading the view.
    int screenHeigth=self.view.frame.size.height;
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 80, 320, screenHeigth-80)];
  //  [webView loadHTMLString:contentText baseURL:nil];
    UIView* bar=[[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 20)];
    UIButton* back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [back setTitle:@"BACK" forState:UIControlStateNormal];
    UIFont* font= [UIFont fontWithName:@"Jockey One" size:14];
    back.titleLabel.font = font;
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:back];
    UIColor *color=[UIColor colorWithRed:184.0f/255.0f green:183.0f/255.0f blue:183.0f/255.0f alpha:1];
    bar.backgroundColor=color;
    [self.view addSubview:bar];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back:(id)selector
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSString*t;
    if ([articleA.sections count]>0) {
        t=[self getSectionNameWithId:[articleA.sections objectAtIndex:0] ];
    }
    else
    {
        t=@"";
    }
    
     NSString* s=[[NSString alloc]initWithFormat:@"<b>%@</b><br><br>By <font color=#808080>%@</font> in<font color=#FF1493> %@ </font><br><font color=#808080><font size=2>Posted %@</font></font><br><br>%@",articleA.title,articleA.author,t,articleA.pub_date,articleA.text ];
     [webView loadHTMLString:s baseURL:nil];
    
    
    
    
    man=[[AdvertisementManager alloc]init];
    
    [man getAdvertisementType];
    
    
    
}


-(NSString*)getSectionNameWithId:(NSString*)idOfSection
{
    int t=[idOfSection intValue];
    switch (t) {
        case 401135240:
            return @"BEAUTY";
            break;
        case 255674304:
            return @"HEALTH";
            break;
        case 845395371:
            return @"LOVE";
            break;
        case 25823041:
            return @"LIFE";
            break;
        case 749367636:
            return @"CAREER";
            break;
        case 182151392:
            return @"HIGHSCHOOL";
            break;
        case 278711104:
            return @"STYLE";
            break;
            
        default:
        return @"ALL";    }
    
}


- (void)viewDidUnload {
    [self setContent:nil];
    [self setAdvView:nil];
    [self setLabel:nil];
    [super viewDidUnload];
}
@end
