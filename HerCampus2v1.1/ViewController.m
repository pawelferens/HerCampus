//
//  ViewController.m
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize informationButton;
@synthesize shareButton;
@synthesize arrowLeftImage;
@synthesize arrowRightImage;
@synthesize screenHeigth;
@synthesize screenWidth;
@synthesize articles;
@synthesize manager;
@synthesize articlesTableView;
@synthesize contentController;
@synthesize sectionsView;
@synthesize selectedSectionName;
@synthesize line;
@synthesize loadingView;
@synthesize spinner;
@synthesize numberOfLoadedArticles;
@synthesize controller;
@synthesize advView;
@synthesize adBannerView;
@synthesize managerAdv;
@synthesize advTextLabel;
@synthesize isAdvertisementNull;



- (void)viewDidLoad
{
    
     [super viewDidLoad];
    managerAdv=[[AdvertisementManager alloc]init];
  
    
    
    numberOfLoadedArticles=10;
    screenWidth=self.view.frame.size.width;
    screenHeigth=self.view.frame.size.height;
    
    loadingView=[[UIView alloc]initWithFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, articlesTableView.frame.size.height)];
    [loadingView setBackgroundColor:[UIColor colorWithRed:184.0f/255.0f green:183.0f/255.0f blue:183.0f/255.0f alpha:1]];
    [loadingView setAlpha:0.8f];
    [self.view addSubview:loadingView];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color=[UIColor blackColor];
    [spinner setCenter:CGPointMake(screenWidth/2, screenHeigth/2)]; // I do this because I'm in landscape mode
    [spinner setHidden:true];
    [spinner startAnimating];
    [self.view addSubview:spinner];
    NSString *notificationName = @"DataRefreshed";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotificationWithString:)
     name:notificationName
     object:nil];
    
    NSString *notificationnName = @"TypeRefreshed";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(typeRefreshed:)
     name:notificationnName
     object:nil];
    
    [self.navigationController setNavigationBarHidden:TRUE];
    self.selectedSectionName=@"ALL";
    articles=[[NSMutableArray alloc]init];
   
//    shareButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 23, 18, 15)];
//    [shareButton setImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
//    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    arrowLeftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 54, 8, 10)];
    [arrowLeftImage setImage:[UIImage imageNamed:@"leftArrow.png"]];
    [self.navigationController.view addSubview:arrowLeftImage];
    arrowRightImage=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-10, 54, 8, 10)];
    [arrowRightImage setImage:[UIImage imageNamed:@"rightArrow.png"]];
    [self.navigationController.view addSubview:arrowRightImage];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIImageView*logo=[[UIImageView alloc]initWithFrame:CGRectMake(0,20, 320, 20)];
    [logo setImage:[UIImage imageNamed:@"bar.png"]];
     [self.navigationController.view addSubview:logo];
    [articlesTableView setDataSource:self];
    [articlesTableView setDelegate:self];
    
    shareButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 23, 18, 15)];
    [shareButton setImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setHidden:TRUE];
    [shareButton setTag:33];
    [self.navigationController.view addSubview:shareButton];
    [self loadSectionsView];
    [self initUnderline];
    [self.navigationController.view addSubview:sectionsView];
    [self addInformationButton];
    [self addSearchButton];
    [self loadNewestArticles];
    
    UIView*footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
    footer.backgroundColor=[UIColor whiteColor];
    UIButton*loadMore=[[UIButton alloc]initWithFrame:CGRectMake(100, 30, 103, 30)];
    [loadMore setImage:[UIImage imageNamed:@"load_more_btn.png"] forState:UIControlStateNormal];
    [loadMore addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];;
    [footer addSubview:loadMore ];
    [articlesTableView setTableFooterView:footer];
	// Do any additional setup after loading the view, typically from a nib.
}




- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			//NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:@"Sending message failed. "
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
			[alert show];
        }
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}
-(void)addSearchButton
{
    UIButton*searchButton=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-20, 23, 18, 15)];
    [searchButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(goToSearchPage:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.navigationController.view addSubview:searchButton];
    
}

-(void)goToSearchPage:(id)selector
{
   // SearchViewController*controller=[self.storyboard instantiateViewControllerWithIdentifier:@"sview"];
    
    [self viewAnimateBack];
    if (controller==nil) {
        controller=[[SearchViewController alloc]init];
        
        controller.dataSource = [[NSMutableArray alloc]init];
        //    for(char c = 'A';c<='Z';c++)
        //        [controller.dataSource addObject:[NSString stringWithFormat:@"%cTestString",c]];
      //  controller.dataSource=articles;
       // controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController pushViewController:controller animated:TRUE];
        
      //  self.navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
      //  [self presentModalViewController:controller animated:YES];
       
    }
    
 
    
}





- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, self.view.frame.size.height-60)];
    [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height, advView.frame.size.width, advView.frame.size.height)];
     [loadingView setFrame:articlesTableView.frame];
     [managerAdv getAdvertisementType];
  
   
   //  [shareButton setTag:33];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([selectedSectionName isEqualToString:@"ALL"]) {
        return 2;
    }
    else
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([selectedSectionName isEqualToString:@"ALL"])
    {
        switch (section) {
            case 0:
                return 2;
                break;
            case 1:
                return [articles count]-2;
                break;
            default:
                return 8;
                break;
                
        }
    }
    else
        return [articles count];
   
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==sectionsView)
    {
        if ([scrollView contentOffset].x<20) {
            [self.arrowLeftImage setHidden:true];
        }
        else if ([scrollView contentOffset].x>3*33) {
            [self.arrowRightImage setHidden:true];
            
        }
        else
        {
            [self.arrowLeftImage setHidden:false];
            [self.arrowRightImage setHidden:false];
            
        }
    }
}

-(void)loadNewestArticles
{
    spinner.hidden=false;
    manager=[[ServerConnectionManager alloc]init];
    [manager getSections];
    [manager getNewest:numberOfLoadedArticles];
    
}

- (void)viewDidUnload {
   
 
    [self setArticlesTableView:nil];
    [self setAdvView:nil];
    [self setAdvTextLabel:nil];
    [self setLabelLoadingView:nil];
    [super viewDidUnload];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
       
    
#pragma mark- generating thumbnails
        
            
        
    UIFont* font= [UIFont fontWithName:@"OpenSans-Bold" size:14];
    UIFont* font2= [UIFont fontWithName:@"OpenSans-Bold" size:10];
    static NSString *CellIdentifier = @"article";
    UITableViewCell *cell = (UITableViewCell *) [articlesTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if ([articles count]>0) {
        Article*temp;
        if ([selectedSectionName isEqualToString:@"ALL"]) {
            
        
        if (indexPath.section==0) {
            temp=[articles objectAtIndex:indexPath.row];
        }
        else
        {
             temp=[articles objectAtIndex:indexPath.row+2];
        }
        }
        else
        {
           temp=[articles objectAtIndex:indexPath.row]; 
        }
         UITextView* title=(UITextView*)[cell viewWithTag:2];
        title.font=font;
         title.text=temp.title;
        
         UILabel* published=(UILabel*)[cell viewWithTag:4];
        published.font=font2;
        if ([temp.sections count]>0) {
            published.text= [self getSectionNameWithId:[temp.sections objectAtIndex:0]];
        }
        else
        {
             published.text= [self getSectionNameWithId:0];
        }
        
        
        
        
    
         UIImageView*thumbnail=(UIImageView*)[cell viewWithTag:1];
         thumbnail.contentMode = UIViewContentModeScaleAspectFit;
         
         
         
         [thumbnail setImageWithURL:[NSURL URLWithString:temp.primaryArticleImage]
         placeholderImage:[UIImage imageNamed:@"gradient_border.png"]];
    }
    
    return cell;
  
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
       
            
        default:
            return @"ALL";    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //[adBannerView removeFromSuperview];
    contentController=[self.storyboard instantiateViewControllerWithIdentifier:@"contentView" ];
     contentController.articlesWebViews=[[NSMutableArray alloc]init];
    contentController.articles=[[NSMutableArray alloc]init];
    for(int i=0;i<[articles count];i++)
    {
        
      UIWebView* webview=[[UIWebView alloc]initWithFrame:CGRectMake(i*screenWidth, 0, screenWidth, contentController.contentScrollView.frame.size.height)];
       [webview loadHTMLString:[[articles objectAtIndex:i] text]baseURL:nil];
        [ contentController.articlesWebViews addObject:webview];
        [contentController.articles addObject:[articles objectAtIndex:i]];
    }
    if ([selectedSectionName isEqualToString:@"ALL"]) {
        if(indexPath.section==0)
        {
            contentController.selectedArticleIndex=indexPath.row;
        }
        else{
             contentController.selectedArticleIndex=indexPath.row+2;
        }
        
    }
    else
    {
      contentController.selectedArticleIndex=indexPath.row;  
    }
    
    contentController.selectedSectionName=self.selectedSectionName;
    [self.navigationController pushViewController:contentController animated:TRUE];
  [self viewAnimate];
    
}




-(void)loadSectionsView
{
    sectionsView=[[UIScrollView alloc]initWithFrame:CGRectMake(16, 40, screenWidth-32, 40)];
    sectionsView.backgroundColor=[UIColor blackColor];
    sectionsView.contentSize = CGSizeMake(7 * 57, 40);
    sectionsView.delegate=self;
    [sectionsView setShowsHorizontalScrollIndicator:NO];
    
    UIFont* font= [UIFont fontWithName:@"Jockey One" size:16];
    NSMutableArray* sections=[self loadSections];
    UIButton*but;
    for(int i=0; i<[sections count];i++)
    {
        
        switch (i) {
            case 0:
                but=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                break;
            case 1:
                but=[[UIButton alloc]initWithFrame:CGRectMake(45, 0, 50, 40)];
                break;
            case 2:
                but=[[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 40)];
                break;
            case 3:
                but=[[UIButton alloc]initWithFrame:CGRectMake(155, 0, 50, 40)];
                break;
            case 4:
                but=[[UIButton alloc]initWithFrame:CGRectMake(195, 0, 50, 40)];
                break;
            case 5:
                but=[[UIButton alloc]initWithFrame:CGRectMake(245, 0, 60, 40)];
                break;
            case 6:
                but=[[UIButton alloc]initWithFrame:CGRectMake(305, 0, 90, 40)];
                break;
           
                
            default:
                but=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
                break;
        }
        but.tag=i;
        
        [but addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [but.titleLabel setFont:font];
        [but setTitle:[sections objectAtIndex:i] forState:UIControlStateNormal];
        [sectionsView addSubview:but];
        
    }
    
    
}


-(NSMutableArray*)loadSections
{
   
    NSMutableArray* sections2=[[NSMutableArray alloc]initWithObjects:@"ALL",@"BEAUTY",@"HEALTH",@"LOVE ",@"LIFE",@"CAREER",@"HIGH SCHOOL", nil];
    return sections2;
}


-(void)addInformationButton
{
    
    informationButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 23, 18, 15)];
    [informationButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [informationButton addTarget:self action:@selector(goToInfoPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:informationButton];
}

-(void)goToInfoPage:(id)selector
{
    
}
- (void)useNotificationWithString:(NSNotification *)notification //use notification method and logic
{
  //  _spinner.hidden=TRUE;
   // [_spinner stopAnimating];
    self.articles=manager.briefs;
   // [self.articlesTableView setAlpha:1.0f];
    [loadingView setAlpha:0.0f];

    [articlesTableView reloadData];
    spinner.hidden=true;
    [spinner stopAnimating];
  
    
}
- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)typeRefreshed:(NSNotification *)notification //use notification method and logic
{
  //  NSLog(@">>%@>>", managerAdv.type);
    adBannerView.alpha=0;
    bannerView_.alpha=0;
    advTextLabel.text=@"";
    if([managerAdv.type isEqualToString:@"APPLE_I_ADDS\n"])
    {
       // [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height-50, advView.frame.size.width, advView.frame.size.height)];
        adBannerView.alpha=1;
        bannerView_.alpha=0;
        adBannerView=[[self appdelegate]IAD];
       [adBannerView setFrame:CGRectMake(0, screenHeigth-50, 320, 50)];
        adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
        [self.view addSubview:adBannerView];
        
         
       
         [loadingView setFrame:articlesTableView.frame];
        // [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, self.view.frame.size.height-50-60)];
      //  [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height-50, advView.frame.size.width, advView.frame.size.height)];

    }
    else if([managerAdv.type isEqualToString:@"AD_MOB\n"])
    {
       
        adBannerView.alpha=0;
        [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, self.view.frame.size.height-50-60)];
        [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height-50, advView.frame.size.width, advView.frame.size.height)];
        
//        [bannerView_ removeFromSuperview];
        
        
//        [adBannerView removeFromSuperview];
        bannerView_ = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        
         bannerView_.alpha=1;
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a151068fe6eaa69";                                     //banner id from website
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [bannerView_ loadRequest:[GADRequest request]];
        [self.advView addSubview:bannerView_];
         [loadingView setFrame:articlesTableView.frame];
    }
    else if([managerAdv.type isEqualToString:@"NONE\n"])
    {
       
        adBannerView.alpha=0;
        bannerView_.alpha=0;
        [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, self.view.frame.size.height-60)];
        [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height, advView.frame.size.width, advView.frame.size.height)];
        
         [loadingView setFrame:articlesTableView.frame];
    }
    else
    {
        
       adBannerView.alpha=0;
         bannerView_.alpha=0;
        advTextLabel.text=managerAdv.type;
        [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, self.view.frame.size.height-50-60)];
        [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height-50, advView.frame.size.width, advView.frame.size.height)];
        [loadingView setFrame:articlesTableView.frame];
    }
}
-(void)viewAnimate
{
    [shareButton setHidden:FALSE ];
    
    //[self.navigationController.view addSubview:informationButton];
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         informationButton.frame = CGRectMake(280, informationButton.frame.origin.y,
                                                              informationButton.frame.size.width, informationButton.frame.size.height);
                         //[informationButton setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                        // NSLog(@"Done!");
                     }];
}

-(void)viewAnimateBack
{
    
    [shareButton setHidden:TRUE];
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         informationButton.frame = CGRectMake(5, informationButton.frame.origin.y,
                                                              informationButton.frame.size.width, informationButton.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                        // NSLog(@"Done!");
                     }];
}



-(void)changeSection:(id)selector
{
    [loadingView setAlpha:0.8f];
    if (![shareButton isHidden]) {
        [self viewAnimateBack];
        
    }
    controller=nil;
    spinner.hidden=FALSE;
    [spinner startAnimating];
    
 //   [self.articlesTableView setAlpha:0.08f];
    

    int temp=[selector tag];
  //  UILabel*label=(UILabel*)[ [sectionView subviews]objectAtIndex:0];
    switch (temp) {
        case 0:
            numberOfLoadedArticles=10;
            [manager getNewest:numberOfLoadedArticles];
            self.selectedSectionName=@"ALL";
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self animateUndelineWithSectionTag:7 andLength:24];
            
//           [self animateUndelineWithSectionTag:15 andLength:30];
//            [_spinner setCenter:CGPointMake(40, 9)];
            
            break;
        case 1:
             numberOfLoadedArticles=10;
            [manager getArticlesFromSection:@"401135240" andLimit:numberOfLoadedArticles];
              self.selectedSectionName=@"BEAUTY";
            [self animateUndelineWithSectionTag:45 andLength:48];
           [self.navigationController popToRootViewControllerAnimated:YES];
            
//            [self animateUndelineWithSectionTag:56 andLength:54];
//            [_spinner setCenter:CGPointMake(65, 9)];
            break;
        case 2:
           numberOfLoadedArticles=10;
            [manager getArticlesFromSection:@"255674304"andLimit:numberOfLoadedArticles];
              self.selectedSectionName=@"HEALTH";
            [self animateUndelineWithSectionTag:100 andLength:48];
             [self.navigationController popToRootViewControllerAnimated:YES];
             
//            [self animateUndelineWithSectionTag:126 andLength:80];
//            [_spinner setCenter:CGPointMake(75, 9)];
            break;
        case 3:
              numberOfLoadedArticles=10;
            [manager getArticlesFromSection:@"845395371"andLimit:numberOfLoadedArticles];
              self.selectedSectionName=@"LOVE";
            [self animateUndelineWithSectionTag:162 andLength:30];
          [self.navigationController popToRootViewControllerAnimated:YES];
           
//            [self animateUndelineWithSectionTag:216 andLength:57];
//            [_spinner setCenter:CGPointMake(65, 9)];
            break;
        case 4:
               numberOfLoadedArticles=10;
            [manager getArticlesFromSection:@"25823041"andLimit:numberOfLoadedArticles];
              self.selectedSectionName=@"LIFE";
            [self animateUndelineWithSectionTag:207 andLength:26];
            [self.navigationController popToRootViewControllerAnimated:YES];
          
//            [self animateUndelineWithSectionTag:283 andLength:40];
//            [_spinner setCenter:CGPointMake(55, 9)];
            break;
        case 5:
             numberOfLoadedArticles=10;
            [manager getArticlesFromSection:@"749367636"andLimit:numberOfLoadedArticles];
              self.selectedSectionName=@"CAREER";
            [self animateUndelineWithSectionTag:254 andLength:42];
             [self.navigationController popToRootViewControllerAnimated:YES];
            
//                       [self animateUndelineWithSectionTag:330 andLength:60];
//            [_spinner setCenter:CGPointMake(65, 9)];
            break;
        case 6:
             numberOfLoadedArticles=10;
            [manager getArticlesFromSection:@"182151392"andLimit:numberOfLoadedArticles];
              self.selectedSectionName=@"HIGHSCHOOL";
            [self animateUndelineWithSectionTag:311 andLength:76];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
//            [self animateUndelineWithSectionTag:400 andLength:28];
//            [_spinner setCenter:CGPointMake(45, 9)];
            break;
        
        default:
            break;
    }
   
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
    UIColor *color=[UIColor colorWithRed:184.0f/255.0f green:183.0f/255.0f blue:183.0f/255.0f alpha:1];
	
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 44.0)];
   
	customView.backgroundColor=color;
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor=[UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
    

    
    
    UIFont* font2= [UIFont fontWithName:@"Jockey One" size:14];
	headerLabel.font = font2;
	headerLabel.frame = CGRectMake(6.0, 2.0, 320.0, 20.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    NSString * sectionName;
    if ([selectedSectionName isEqualToString:@"ALL"]) {
        switch (section)
        {
            case 0:
                sectionName = @"EDITOR'S PICKS";
                break;
            case 1:
                sectionName = @"ALL";
                break;
                
            default:
                sectionName = @"";
                break;
        }
    }
    else
    {
        sectionName=selectedSectionName;
    }
        headerLabel.text =sectionName; // i.e. array element
        [customView addSubview:headerLabel];
    
    
	return customView;
}


-(void)initUnderline
{
    line=[[UIView alloc]initWithFrame:CGRectMake(7, 28, 24, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.sectionsView addSubview:line];
}

-(void)animateUndelineWithSectionTag:(int)tag
                           andLength:(int)length
{
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         line.frame = CGRectMake(tag, 28, length, 1);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}
-(void)share:(id)selector
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"share" object:self];
}
-(void)loadMore:(id)selector
{
    [loadingView setAlpha:0.8f];
    spinner.hidden=FALSE;
    [spinner startAnimating];
    
    numberOfLoadedArticles=numberOfLoadedArticles+10;
    if([selectedSectionName isEqualToString:@"ALL"])
    {
   [manager getNewest:numberOfLoadedArticles];
    }
    else if ([selectedSectionName isEqualToString:@"BEAUTY"])
    {
        [manager getArticlesFromSection:@"401135240" andLimit:numberOfLoadedArticles];
   // NSLog(@"OK");
    }
    else if ([selectedSectionName isEqualToString:@"HEALTH"])
    {
        [manager getArticlesFromSection:@"255674304" andLimit:numberOfLoadedArticles];
    }

    else if ([selectedSectionName isEqualToString:@"LOVE"])
    {
        [manager getArticlesFromSection:@"845395371" andLimit:numberOfLoadedArticles];
    }

    else if ([selectedSectionName isEqualToString:@"LIFE"])
    {
          [manager getArticlesFromSection:@"25823041"andLimit:numberOfLoadedArticles];
    }

    else if ([selectedSectionName isEqualToString:@"CAREER"])
    {
         [manager getArticlesFromSection:@"749367636"andLimit:numberOfLoadedArticles];
    }
    else if ([selectedSectionName isEqualToString:@"HIGHSCHOOL"])
    {
      [manager getArticlesFromSection:@"182151392"andLimit:numberOfLoadedArticles];
    }
    
    [articlesTableView reloadData];
    
}
@end
