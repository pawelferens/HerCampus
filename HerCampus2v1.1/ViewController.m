//
//  ViewController.m
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
        CGRect naviBarFrame;
}
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
@synthesize sections;
@synthesize isLoading;
@synthesize spinner2;
@synthesize loadMore;
@synthesize footer;
@synthesize noContentLabel;
@synthesize isOfflinePreview;
@synthesize isOnline;
@synthesize logo;
@synthesize searchButton;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    isOfflinePreview = NO;
    contentController=[self.storyboard instantiateViewControllerWithIdentifier:@"contentView" ];
    
    if([[self appdelegate].deviceType isEqualToString:@"iPhone"] || [[self appdelegate].deviceType isEqualToString:@"iPhone Simulator"]){
        screenWidth=self.view.frame.size.width;
    }
    else if([[self appdelegate].deviceType isEqualToString:@"iPad"] || [[self appdelegate].deviceType isEqualToString:@"iPad Simulator"]){
        screenWidth=self.view.frame.size.height;
        [self addChildViewController:contentController];
        [contentController.view setFrame:CGRectMake(articlesTableView.frame.size.width, 60, 768, 704)];
        [self.view addSubview:contentController.view];
        
    }
 

    
    
    NSString *notificationName = @"DataRefreshed";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotificationWithString:)
     name:notificationName
     object:nil];
    
    NSString *notificationName5 = @"NoDataLoaded";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showNoDataAlert:)
     name:notificationName5
     object:nil];
    
    NSString *notificationnName = @"TypeRefreshed";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(typeRefreshed:)
     name:notificationnName
     object:nil];
    
    NSString *notificationnNamec = @"sectionsLoaded";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadSections:)
     name:notificationnNamec
     object:nil];
    
    NSString *notificationnNameccv = @"NoDataAtAll";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showNoDataAtAllAlert:)
     name:notificationnNameccv
     object:nil];
    
    
    
   

    isLoading=0;
    
    managerAdv=[[AdvertisementManager alloc]init];
    manager=[[ServerConnectionManager alloc]init];
    [manager getSections];
    numberOfLoadedArticles=10;
    
    
    NSLog(@"screenWidth: %d", screenWidth);
    screenHeigth=self.view.frame.size.height;
    
    loadingView=[[UIView alloc]initWithFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, articlesTableView.frame.size.height)];
    
    [loadingView setBackgroundColor:[UIColor colorWithRed:184.0f/255.0f green:183.0f/255.0f blue:183.0f/255.0f alpha:1]];
    [loadingView setAlpha:0.8f];
    [self.view addSubview:loadingView];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color=[UIColor blackColor];
    [spinner setCenter:CGPointMake(articlesTableView.frame.size.width/2, articlesTableView.frame.size.height/2)]; // I do this because I'm in landscape mode
    [spinner setHidden:true];
    [spinner startAnimating];
    [self.view addSubview:spinner];

    
    [self.navigationController setNavigationBarHidden:TRUE];
    self.selectedSectionName=@"ALL";
    articles=[[NSMutableArray alloc]init];
    

    naviBarFrame.origin.x = 0;
    naviBarFrame.origin.y = 20;
    naviBarFrame.size.width = screenWidth;
    naviBarFrame.size.height = 60;
    


    arrowLeftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, naviBarFrame.origin.y+34, 8, 10)];
    [arrowLeftImage setImage:[UIImage imageNamed:@"leftArrow.png"]];
    [self.navigationController.view addSubview:arrowLeftImage];
    arrowRightImage=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-10, naviBarFrame.origin.y+34, 8, 10)];
    [arrowRightImage setImage:[UIImage imageNamed:@"rightArrow.png"]];
    
    
    [self.navigationController.view addSubview:arrowRightImage];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    


    logo=[[UIImageView alloc]initWithFrame:CGRectMake(naviBarFrame.origin.x,
                                                                  naviBarFrame.origin.y,
                                                                  screenWidth,
                                                                  20)];
    
    [logo setBackgroundColor: [UIColor colorWithRed:255.0f/255.0f green:6.0f/255.0f blue:102.0f/255.0f alpha:1]];

    
    [logo setImage:[UIImage imageNamed:@"bar.png"]];
     [self.navigationController.view addSubview:logo];
    [articlesTableView setDataSource:self];
    [articlesTableView setDelegate:self];
    
    // [arrowLeftImage setAlpha:0.8f];
    shareButton=[[UIButton alloc]initWithFrame:CGRectMake(5, naviBarFrame.origin.y+3, 19, 15)];
    [shareButton setImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setHidden:TRUE];
    [shareButton setTag:33];
    [self.navigationController.view addSubview:shareButton];

    [self.navigationController.view addSubview:sectionsView];
    [self addInformationButton];
    [self addSearchButton];
    
    UIFont* font= [UIFont fontWithName:@"Jockey One" size:20];
    footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
    footer.backgroundColor=[UIColor whiteColor];
    loadMore=[[UIButton alloc]initWithFrame:CGRectMake(60, 30, 200, 30)];
    UIImage*arrow=[UIImage imageNamed:@"Loading.gif"];
    UIImageView*arrowView=[[UIImageView alloc]initWithFrame:CGRectMake(65, 30, 40, 40)];
    [arrowView setImage:arrow];

    [loadMore setTitle:@"Loading articles ..." forState:UIControlStateNormal];
    [loadMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loadMore.titleLabel setFont:font];
    [loadMore addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
  
    spinner2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner2.color=[UIColor blackColor];
    [spinner2 setCenter:CGPointMake(50, 44)]; // I do this because I'm in landscape mode
    [spinner2 setHidden:true];

    [footer addSubview:spinner2];
    [footer addSubview:loadMore ];
    [self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    if([[self appdelegate]checkNetworkStatus]){
        [articlesTableView setTableFooterView: footer];
    }
    else{
        [articlesTableView setTableFooterView: nil];
    }
    [self loadNewestArticles];
    [self.view bringSubviewToFront:articlesTableView];
    
    [logo setFrame:CGRectMake(naviBarFrame.origin.x,
                              naviBarFrame.origin.y,
                              self.view.frame.size.width,
                              20)];
   
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
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
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [sectionsView setFrame:CGRectMake(sectionsView.frame.origin.x, sectionsView.frame.origin.y, self.view.frame.size.width-32, 40)];
    [logo setFrame:CGRectMake(naviBarFrame.origin.x,
                              naviBarFrame.origin.y,
                              self.view.frame.size.width,
                              20)];
    [searchButton setFrame:CGRectMake(self.view.frame.size.width-20, naviBarFrame.origin.y+3, 14, 15)];
    
    
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
    searchButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-20, naviBarFrame.origin.y+3, 14, 15)];
    [searchButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(goToSearchPage:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.navigationController.view addSubview:searchButton];
    
}

-(void)goToSearchPage:(id)selector
{
    if([[self appdelegate]checkNetworkStatus]){
        [self viewAnimateBack];
        if (controller==nil) {
            controller=[[SearchViewController alloc]init];
            controller.dataSource = [[NSMutableArray alloc]init];
            [self.navigationController pushViewController:controller animated:TRUE];
        }
    }
    else{
        UIAlertView *searchAlert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                             message:@"Search option is unavailable in offline mode."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [searchAlert show];
    }
     
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //[manager getSections];
    screenWidth=self.view.frame.size.width;

    NSArray *newVCs = [NSArray arrayWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], contentController, nil];
    self.splitViewController.viewControllers = newVCs;
    
    [noContentLabel setHidden:YES];
    if(![[self appdelegate]checkNetworkStatus]  && !isOfflinePreview)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                        message:@"Do you want to view off-line content?"
                                                       delegate:nil
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alert setDelegate:self];
        [alert setTag:3];
        [alert show];
    }
    else if ([[self appdelegate]checkNetworkStatus]){
        [articlesTableView setHidden:NO];
        isOfflinePreview = NO;
        [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x,
                                                    articlesTableView.frame.origin.y,
                                                    articlesTableView.frame.size.width,
                                                    self.view.frame.size.height-60)];
        [advView setFrame:CGRectMake(advView.frame.origin.x,
                                     self.view.frame.size.height,
                                     advView.frame.size.width,
                                     advView.frame.size.height)];
        [self.view addSubview:advView];
    }
    
    
    [loadingView setFrame:articlesTableView.frame];
    [managerAdv getAdvertisementType];}


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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  
    isOnline= [[self appdelegate]checkNetworkStatus];
    
    if (!isOnline) {
       
          [articlesTableView setTableFooterView:nil];
    }
    else
    {
        if([articlesTableView tableFooterView]==nil)
        {
        [articlesTableView setTableFooterView:footer];
        }
    }
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
    else if (scrollView==articlesTableView)
    {
         NSLog(@" net status: ____ %d",isOnline);
            CGPoint offset = scrollView.contentOffset;
            CGRect bounds = scrollView.bounds;
            CGSize size = scrollView.contentSize;
            UIEdgeInsets inset = scrollView.contentInset;
            float y = offset.y + bounds.size.height - inset.bottom;
            float h = size.height;
        
        
            float reload_distance = -10;
       
            if(y > h + reload_distance && isOnline) {
                NSLog(@"load more rows");
                [spinner2 startAnimating];
                [loadMore setTitle:@"Loading articles ..." forState:UIControlStateNormal];
                if (isLoading==0) {
               
                //self load more
                
                    numberOfLoadedArticles=numberOfLoadedArticles+10;
                    if([selectedSectionName isEqualToString:@"ALL"])
                    {
                   
                        [manager getNewest:numberOfLoadedArticles];
                        NSLog(@"powinno doladowac");
                    }
                    else
                    {
                        for (int i=0; i<[sections count]; i++) {
                            Section* s=[sections objectAtIndex:i];
                            if ([[s.sectionName uppercaseString] isEqualToString:self.selectedSectionName]) {
                                [manager getArticlesFromSection:s.sectionNumber andLimit:numberOfLoadedArticles ];
                            }
                        }
                    }
                
                
                    [articlesTableView reloadData];
                
                    isLoading=1;
                }
            // [self loadMore:nil];
            }
        
    }
}

-(void)loadNewestArticles
{
    spinner.hidden=false;
    manager=[[ServerConnectionManager alloc]init];
    [manager getSections];
    [manager getNewest:numberOfLoadedArticles];
    NSLog(@"newest   loaded");
    
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
         
         
         if([[self appdelegate]checkNetworkStatus]){
             [thumbnail setImageWithURL:[NSURL URLWithString:temp.primaryArticleImage]
                       placeholderImage:nil];
         }
         else{
             [thumbnail setImage:temp.downloadedImage];
         }
        
    }
    
    return cell;
  
}

-(NSString*)getSectionNameWithId:(NSString*)idOfSection
{
    for(int i=0; i<sections.count; i++){
        if([[[sections objectAtIndex:i] sectionNumber] isEqualToString:idOfSection]){
            return [[sections objectAtIndex:i] sectionName];
        }
    }
    return @"ALL";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];

    contentController.articlesWebViews=[[NSMutableArray alloc]init];
    contentController.articles=[[NSMutableArray alloc]init];
    for(int i=0;i<[articles count];i++)
    {
        
     
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
    
    
    if([[self appdelegate].deviceType isEqualToString:@"iPhone"] || [[self appdelegate].deviceType isEqualToString:@"iPhone Simulator"]){
        [self.navigationController pushViewController:contentController animated:TRUE];
    }
    else if([[self appdelegate].deviceType isEqualToString:@"iPad"] || [[self appdelegate].deviceType isEqualToString:@"iPad Simulator"]){
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             [articlesTableView setFrame:CGRectMake(0, 60, 0, articlesTableView.frame.size.height)];
                             [contentController.view  setFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60)];
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
        
        [self.contentController viewDidAppear:YES];
    }
    
  [self viewAnimate];
    
}

-(void)loadSectionsView
{
    
    sectionsView=[[UIScrollView alloc]initWithFrame:CGRectMake(16, naviBarFrame.origin.y+20, screenWidth-32, 40)];
    sectionsView.backgroundColor=[UIColor blackColor];
    
    
    
    sectionsView.delegate=self;
    [sectionsView setShowsHorizontalScrollIndicator:NO];
    
    UIFont* font= [UIFont fontWithName:@"Jockey One" size:16];
    //   NSMutableArray* sections=[self loadSections];
    UIButton*but;
    
    but=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];   //all section
    [but addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
    [but.titleLabel setFont:font];
    [but setTitle:@"ALL" forState:UIControlStateNormal];
    but.tag=0;
    [sectionsView addSubview:but];
    float tempIndex=30;
    for(int i=0; i<[sections count];i++)
    {
        but=[[UIButton alloc]initWithFrame:CGRectMake(tempIndex, 0, [[[sections objectAtIndex:i]sectionName]length]*10, 40)];
        
        sectionsView.contentSize = CGSizeMake(tempIndex+but.frame.size.width, 40);
        
        tempIndex=tempIndex+[[[sections objectAtIndex:i]sectionName]length]*9;
        
        but.tag=i+1;
        
        [but addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
        [but.titleLabel setFont:font];
        
        [but setTitle:[[[sections objectAtIndex:i]sectionName]uppercaseString] forState:UIControlStateNormal];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // but.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [sectionsView addSubview:but];
        
        
    }
    
    [self.navigationController.view addSubview:sectionsView];

    
}


-(void)loadSections:(id)notification
{
    sections=manager.sections;
    [self loadSectionsView];
    [self initUnderline];
   
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     for(int i=0;i<[sections count];i++)
     {
          NSString*key=[NSString stringWithFormat:@"section%d",i];
          [defaults setObject:[[sections objectAtIndex:i] sectionName] forKey:key];
         
     }
    for(int i=0;i<[sections count];i++)
    {
        NSString*key=[NSString stringWithFormat:@"sectionNumber%d",i];
        [defaults setObject:[[sections objectAtIndex:i] sectionNumber] forKey:key];
        
    }
    [defaults setInteger:[sections count ] forKey:@"numberOfSections"];
    int number=[defaults integerForKey:@"numberOfSections"];
    NSLog(@"lll %d",number);
    for(int z=0;z<number;z++)
    {
        NSString*key=[NSString stringWithFormat:@"section%d",z];
       NSString *o = [defaults objectForKey:key];
        NSLog(@"%@",o);
    }
   
}


-(void)addInformationButton
{
    informationButton=[[UIButton alloc]initWithFrame:CGRectMake(5, naviBarFrame.origin.y+3, 16, 15)];
    [informationButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [informationButton addTarget:self action:@selector(goToInfoPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:informationButton];
}

-(void)goToInfoPage:(id)selector
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if([alertView tag] == 1)
    {
        [articlesTableView setHidden:YES];
        noContentLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height/2)-10, self.view.frame.size.width-40, 400)];
        [noContentLabel setText:@"No content to display. Please connect to internet to download articles."];
        [noContentLabel setTextAlignment:NSTextAlignmentCenter];
        [noContentLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        [noContentLabel setEditable:NO];
        [self.view addSubview: noContentLabel];
        [spinner setHidden:YES];

    }
    else if((int)[alertView tag] == 2 || (int)[alertView tag] == 3){
        if(buttonIndex == 1){
            [articlesTableView setHidden:NO];
            isOfflinePreview = YES;
            NSLog(@"offline adview load");
           
            if(currentSection == 0){
                [self loadNewestArticles];
            }
            else{
                [manager getArticlesFromSection:[[sections objectAtIndex:(currentSection-1)]sectionNumber] andLimit:numberOfLoadedArticles];
                [self animateUndelineWithSectionTag:b.frame.origin.x andLength:[b.titleLabel.text length]*7];
            }
            [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x,
                                                        articlesTableView.frame.origin.y,
                                                        articlesTableView.frame.size.width,
                                                        self.view.frame.size.height-60)];
            [advView removeFromSuperview];
            
        }
        else if(buttonIndex == [alertView cancelButtonIndex]){
            isOfflinePreview = NO;
            [articlesTableView setHidden:YES];
            noContentLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height/2)-10, self.view.frame.size.width-40, 400)];
            [noContentLabel setText:@"No content to display. Please connect to internet to download articles."];
            [noContentLabel setTextAlignment:NSTextAlignmentCenter];
            [noContentLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
            [noContentLabel setEditable:NO];
            [self.view addSubview: noContentLabel];
            [spinner setHidden:YES];
        }
        
    }
    else if ((int)[alertView tag]==4)
    {
        if(buttonIndex == [alertView cancelButtonIndex]){
            [manager getSections];
            [manager getNewest:10];
           
            
            NSLog(@"ok klikniete");
            // [manager getNewest:10];
            
        }
    }

}

- (void)showNoDataAlert:(NSNotification *)notification //use notification method and logic
{
    [articlesTableView setHidden:YES];
    UIAlertView *noDataAlert=[[UIAlertView alloc]initWithTitle:@"No data" message:@"There are no articles to display from this section " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [noDataAlert setTag:1];
    [noDataAlert setDelegate:self];
    [noDataAlert show];
    
    
}
- (void)showNoDataAtAllAlert:(NSNotification *)notification //use notification method and logic
{
    [articlesTableView setHidden:YES];
    UIAlertView *noDataAlert=[[UIAlertView alloc]initWithTitle:@"No data" message:@"Internet connection is required while first launch.  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [noDataAlert setTag:4];
   
    [noDataAlert show];
    
    
}

- (void)useNotificationWithString:(NSNotification *)notification //use notification method and logic
{
    int temp=[self.articles count];
    self.articles=manager.briefs;
    if (temp==[self.articles count]) {
        [spinner2 stopAnimating];
        [loadMore setTitle:@"There are no more articles" forState:UIControlStateNormal];
    }
    [loadingView setAlpha:0.0f];

    [articlesTableView reloadData];
  
    spinner.hidden=true;
    [spinner stopAnimating];
    isLoading=0;
     [[self articlesTableView]setHidden:NO];
}
- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)typeRefreshed:(NSNotification *)notification //use notification method and logic
{
    adBannerView.alpha=0;
    bannerView_.alpha=0;
    advTextLabel.text=@"";
    if([managerAdv.type isEqualToString:@"APPLE_I_ADDS\n"])
    {
        adBannerView.alpha=1;
        adBannerView=[[self appdelegate]IAD];
        [adBannerView setFrame:CGRectMake(0, screenHeigth-50, 320, 50)];
        adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
        
      
        bannerView_.alpha=0;
        advTextLabel.text=@"Loading ...";
        [self.view addSubview:adBannerView];
        
         
       
         [loadingView setFrame:articlesTableView.frame];
        [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, self.view.frame.size.height-50-60)];
        [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height-50, advView.frame.size.width, advView.frame.size.height)];
        

    }
    else if([managerAdv.type isEqualToString:@"AD_MOB\n"])
    {
       
        adBannerView.alpha=0;
        [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x, articlesTableView.frame.origin.y, articlesTableView.frame.size.width, self.view.frame.size.height-50-60)];
        [advView setFrame:CGRectMake(advView.frame.origin.x, self.view.frame.size.height-50, advView.frame.size.width, advView.frame.size.height)];

        bannerView_ = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        
         bannerView_.alpha=1;
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a151101590214be";                                     //banner id from website
        
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
                         informationButton.frame = CGRectMake(self.navigationController.view.frame.size.width-40, informationButton.frame.origin.y,
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

-(IBAction)changeSection:(id)selector
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                            [articlesTableView setFrame:CGRectMake(0, 60, 320, articlesTableView.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];


    
    
    [noContentLabel setHidden:YES];
    [articlesTableView setHidden:NO];
    
    int temp=[selector tag];
    numberOfLoadedArticles=10;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    b=[selector self];
    self.selectedSectionName=[b.titleLabel.text uppercaseString];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"] || [deviceType isEqualToString:@"iPhone Simulator"])
    [sectionsView setContentOffset:CGPointMake(b.frame.origin.x-115, 0) animated:TRUE];
    
    if([[self appdelegate]checkNetworkStatus] || isOfflinePreview){
        if([[self appdelegate]checkNetworkStatus]){
            [articlesTableView setTableFooterView: footer];
        }
        if (temp==0) {
            [manager getNewest:numberOfLoadedArticles];
            [self animateUndelineWithSectionTag:3 andLength:25];
        }
        else
        {
            [manager getArticlesFromSection:[[sections objectAtIndex:(temp-1)]sectionNumber] andLimit:numberOfLoadedArticles];
            [self animateUndelineWithSectionTag:b.frame.origin.x andLength:[b.titleLabel.text length]*7];
        }
        
    }
    else{
        currentSection = temp;
        [articlesTableView setTableFooterView: nil];
    }
    
    if(![[self appdelegate]checkNetworkStatus]  && !isOfflinePreview)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                        message:@"Do you want to view off-line content?"
                                                       delegate:nil
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alert setDelegate:self];
        [alert setTag:3];
        [alert show];
    }
    else if ([[self appdelegate]checkNetworkStatus]){
        NSLog(@"online adview load");
        [articlesTableView setHidden:NO];
        isOfflinePreview = NO;
        [self.articlesTableView setFrame:CGRectMake(articlesTableView.frame.origin.x,
                                                    articlesTableView.frame.origin.y,
                                                    articlesTableView.frame.size.width,
                                                    self.view.frame.size.height-60)];
        [advView setFrame:CGRectMake(advView.frame.origin.x,
                                     self.view.frame.size.height,
                                     advView.frame.size.width,
                                     advView.frame.size.height)];
        [self.view addSubview:advView];
    }
    
    
    [loadingView setFrame:articlesTableView.frame];
    [managerAdv getAdvertisementType];
    
    
    [noContentLabel setHidden:YES];
    [loadingView setAlpha:0.8f];
    if (![shareButton isHidden]) {
        [self viewAnimateBack];
    }
    controller=nil;
    spinner.hidden=FALSE;
    [spinner startAnimating];
    
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
    line=[[UIView alloc]initWithFrame:CGRectMake(3, 28, 25, 1)];
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
    if([[self appdelegate]checkNetworkStatus])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"share" object:self];
    else{
        UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                message:@"Share option is unavailable in offline mode."
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [shareAlert show];
    }
}
-(void)loadMore:(id)selector
{
    if([[self appdelegate]checkNetworkStatus]){
        [loadingView setAlpha:0.8f];
        spinner.hidden=FALSE;
        [spinner startAnimating];
        
        numberOfLoadedArticles=numberOfLoadedArticles+10;
        if([selectedSectionName isEqualToString:@"ALL"])
        {
            [manager getNewest:numberOfLoadedArticles];
            NSLog(@"powinno doladowac");
        }
        else
        {
            for (int i=0; i<[sections count]; i++) {
                Section* s=[sections objectAtIndex:i];
                if ([[s.sectionName uppercaseString] isEqualToString:self.selectedSectionName]) {
                    [manager getArticlesFromSection:s.sectionNumber andLimit:numberOfLoadedArticles ];
                }
            }
        }
        [articlesTableView reloadData];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
