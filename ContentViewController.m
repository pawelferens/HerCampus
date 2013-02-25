//
//  ContentViewController.m
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/21/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize contentScrollView;
@synthesize articlesWebViews;
@synthesize screenWidth;
@synthesize screenHeigth;
@synthesize selectedArticleIndex;
@synthesize selectedSectionName;
@synthesize sectionNameLabel;
@synthesize goToPreviousArticle;
@synthesize goToNextArticle;
@synthesize articles;
@synthesize lA;
@synthesize rA;
@synthesize anotherAdvTypeLabel;
@synthesize man;
@synthesize secondAdvView;
@synthesize advTextLabel;
@synthesize adBannerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *notificationnName = @"TypeRefreshed";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(typeRefreshed:)
     name:notificationnName
     object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share:) name:@"share" object:nil];
    
   
    self.sectionNameLabel.text=@"";
    screenWidth=self.view.frame.size.width;
    screenHeigth=self.view.frame.size.height;
    [contentScrollView setPagingEnabled:true];
    contentScrollView.delegate=self;
    
     UIFont* font= [UIFont fontWithName:@"OpenSans-Bold" size:12];
    UIFont* font2= [UIFont fontWithName:@"Jockey One" size:12];
    self.sectionNameLabel.font=font;
    self.goToNextArticle.titleLabel.font=font2;
    self.goToPreviousArticle.titleLabel.font=font2;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)typeRefreshed:(NSNotification *)notification //use notification method and logic
{
    NSLog(@">>%@>>", man.type);
    
    if([man.type isEqualToString:@"APPLE_I_ADDS\n"])
    {
        
        [contentScrollView setScrollEnabled:false];
        
        NSLog(@" >> RRR >>");
        
        bannerView_.alpha=0;
        // [self createAdBannerView];
        adBannerView=[[self appdelegate]IAD];
        [adBannerView setFrame:CGRectMake(0, screenHeigth-50, 320, 50)];
        adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
        [self.view addSubview:adBannerView];
        
        adBannerView.alpha=1;
        
        
        [self.contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height-60-50-20)];
        for(int i=0;i<[[contentScrollView subviews]count ];i++)
        {
            UIWebView* tt=[[contentScrollView subviews]objectAtIndex:i];
            [tt setFrame:CGRectMake(tt.frame.origin.x, tt.frame.origin.y, tt.frame.size.width, contentScrollView.frame.size.height)];
            
        }
       
    }
    else if([man.type isEqualToString:@"AD_MOB\n"])
    {
        
        adBannerView.alpha=0;
        [self.contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height-60-50-22)];
        [secondAdvView setFrame:CGRectMake(secondAdvView.frame.origin.x, self.view.frame.size.height-50, secondAdvView.frame.size.width, secondAdvView.frame.size.height)];
        [contentScrollView setScrollEnabled:false];
        for(int i=0;i<[[contentScrollView subviews]count ];i++)
        {
            UIWebView* tt=[[contentScrollView subviews]objectAtIndex:i];
            [tt setFrame:CGRectMake(tt.frame.origin.x, tt.frame.origin.y, tt.frame.size.width, contentScrollView.frame.size.height)];
            
        }
        
      
        bannerView_ = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        
        bannerView_.alpha=1;
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a151101590214be";                                     //banner id from website
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [bannerView_ loadRequest:[GADRequest request]];
        [self.secondAdvView addSubview:bannerView_];
     //   [loadingView setFrame:articlesTableView.frame];
    }
    else if([man.type isEqualToString:@"NONE\n"])
    {
         [contentScrollView setScrollEnabled:false];
        NSLog(@"okiii");
        adBannerView.alpha=0;
        bannerView_.alpha=0;
     //   [secondAdvView removeFromSuperview];
         [secondAdvView setFrame:CGRectMake(secondAdvView.frame.origin.x, self.view.frame.size.height, secondAdvView.frame.size.width, secondAdvView.frame.size.height)];
    
      [self.contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height-60-23)];

        
        for(int i=0;i<[[contentScrollView subviews]count ];i++)
        {
            UIWebView* tt=[[contentScrollView subviews]objectAtIndex:i];
            [tt setFrame:CGRectMake(tt.frame.origin.x, tt.frame.origin.y, tt.frame.size.width, contentScrollView.frame.size.height)];
            
        }
        
        
        
       // [loadingView setFrame:articlesTableView.frame];
    }
    else
    {
         [contentScrollView setScrollEnabled:false];
     //   secondAdvView.backgroundColor=[UIColor blackColor];
        adBannerView.alpha=0;
        bannerView_.alpha=0;
        anotherAdvTypeLabel.text=man.type;
        [self.contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height-60-50-22)];
        for(int i=0;i<[[contentScrollView subviews]count ];i++)
        {
            UIWebView* tt=[[contentScrollView subviews]objectAtIndex:i];
            [tt setFrame:CGRectMake(tt.frame.origin.x, tt.frame.origin.y, tt.frame.size.width, contentScrollView.frame.size.height)];
            
        }
        [secondAdvView setFrame:CGRectMake(secondAdvView.frame.origin.x, self.view.frame.size.height-50, secondAdvView.frame.size.width, secondAdvView.frame.size.height)];
        
       // [loadingView setFrame:articlesTableView.frame];
    }
}


- (void)viewDidUnload {
    [self setContentScrollView:nil];
    [self setSectionNameLabel:nil];
    [self setGoToNextArticle:nil];
    [self setGoToPreviousArticle:nil];
    [self setLA:nil];
    [self setRA:nil];
    [self setLA:nil];
    [self setRA:nil];
    [self setAdvView:nil];
    [self setSecondAdvView:nil];
    [self setAnotherAdvTypeLabel:nil];
    [super viewDidUnload];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
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
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}




- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    // secondAdvView.backgroundColor=[UIColor whiteColor];
   man=[[AdvertisementManager alloc]init];
   
    [man getAdvertisementType];
    [secondAdvView setFrame:CGRectMake(secondAdvView.frame.origin.x, self.view.frame.size.height, secondAdvView.frame.size.width, secondAdvView.frame.size.height)];
    [self.contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height-83)];
    [self.contentScrollView setShowsHorizontalScrollIndicator:NO];
    UIFont* font2= [UIFont fontWithName:@"Jockey One" size:14];
    self.sectionNameLabel.text=self.selectedSectionName;
    self.sectionNameLabel.font=font2;
    contentScrollView.contentSize=CGSizeMake(screenWidth*[articles count], contentScrollView.frame.size.height);
    
    for(int i=0;i<[articles count];i++)
    {
        UIWebView* tt=[[UIWebView alloc]initWithFrame:CGRectMake(i*screenWidth, 0, screenWidth, contentScrollView.frame.size.height)];
      
        Article*g=[articles objectAtIndex:i];
        NSLog(@"%d",[g.sections count]);
        NSString*tymcz;
        if([g.sections count]>0)
        {
          tymcz=[g.sections objectAtIndex:0];  
        }
        
        if (tymcz) {
            tymcz=[self getSectionNameWithId:tymcz];
        }
        else
        {
            tymcz=selectedSectionName;
        }
        NSString* s=[[NSString alloc]initWithFormat:@"<b>%@</b><br><br>By <font color=#808080>%@</font> in<font color=#FF1493> %@ </font><br><font color=#808080><font size=2>Posted %@</font></font><br><br>%@",g.title,g.author,tymcz,g.pub_date,g.text ];
        
        [tt loadHTMLString:s baseURL:nil];
        [contentScrollView addSubview:tt];
    }
    [contentScrollView setContentOffset:CGPointMake(screenWidth*selectedArticleIndex, 0) animated:false];
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
            return @"HIGH SCHOOL";
            break;
        case 278711104:
            return @"STYLE";
            break;
            
            
        default:
        return @"ALL";    }
    
}

- (IBAction)next:(id)sender {
    int temp=[contentScrollView contentOffset].x;
    temp=temp/screenWidth;
    [contentScrollView setContentOffset:CGPointMake(screenWidth*(temp+1),0) animated:YES];
}

- (IBAction)previous:(id)sender {
    if ([contentScrollView contentOffset].x>0) {
        int temp=[contentScrollView contentOffset].x;
        temp=temp/screenWidth;
        [contentScrollView setContentOffset:CGPointMake(screenWidth*(temp-1),0) animated:YES];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  
        if ([scrollView contentOffset].x<=0) {
            [self.goToPreviousArticle setHidden:true];
            [self.lA setHidden:TRUE];
            
            
        }
        
        else if ([scrollView contentOffset].x >= screenWidth*([articles count]-1))
        {
            [self.goToNextArticle setHidden:TRUE];
            [self.rA setHidden:TRUE];
        }
        else{
            [self.goToNextArticle setHidden:false];
             [self.goToPreviousArticle setHidden:false];
            [self.rA setHidden:false];
             [self.lA setHidden:false];
        }
        
        
        
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            int temp=[contentScrollView contentOffset].x/screenWidth;
            NSString* someText = [[articles objectAtIndex:temp] link];
            
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            [mailer setSubject:@"Check this article!"];
            //           NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
            //           [mailer setToRecipients:toRecipients];
            //           UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
            //           NSData *imageData = UIImagePNGRepresentation(myImage);
            //           [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
            NSString *emailBody = someText;
            [mailer setMessageBody:emailBody isHTML:NO];
            [self presentModalViewController:mailer animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:@"Your device doesn't support the composer sheet"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else if (buttonIndex==1)
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            int temp=[contentScrollView contentOffset].x/screenWidth;
            NSString* someText = [[articles objectAtIndex:temp] link];
            
            controller.body =someText;
            controller.recipients = [NSArray arrayWithObjects:@"", nil];
            controller.messageComposeDelegate = self;
            controller.delegate = self;
            [self presentModalViewController:controller animated:YES];
        }
    }
    else if (buttonIndex==3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Facebook is not supported "
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
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


-(void)share:(id)selector
{
    int temp=[contentScrollView contentOffset].x/screenWidth;
    NSLog(@"%d",temp);
    if(NSClassFromString(@"UIActivityViewController")) {        //checking if native sharing is avaible
        
        Article* showedArticle=[articles objectAtIndex:temp];
        NSString* someText = showedArticle.link;
        NSArray* dataToShare = @[someText];  // ... pieces of data you want to share.
        
        UIActivityViewController* activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                          applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:^{}];
        
    }
    else{
        NSString *actionSheetTitle = @""; //Action Sheet Title
        NSString *other1 = @"";
        NSString *other2 = @"";
        NSString *other3 = @"";
        NSString *other4 = @"";
        NSString *cancelTitle = @"Cancel";
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other1, other2, other3,other4, nil];
        actionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        actionSheet.alpha=0.9;// setAlpha:0.8];
        
        
        UIButton*temp=[[actionSheet subviews]objectAtIndex:1];
        [temp setBackgroundImage:[UIImage imageNamed:@"email.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"email2.png"] forState:UIControlStateHighlighted];
        [temp setBounds:CGRectMake(0, 0, 65, 65)];
        [temp setBackgroundColor:[UIColor blackColor]];
        [temp setCenter:CGPointMake(60, 66)];
        [temp setBackgroundColor:[UIColor clearColor]];
        UIFont* font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(0, 68, 65, 12)];
        [title setTextAlignment:NSTextAlignmentCenter];
        title.font=font;
        title.text=@"Mail";
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[UIColor whiteColor];
        [temp addSubview:title];
        
        
        UIButton*temp2=[[actionSheet subviews]objectAtIndex:2];
        [temp2 setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
        [temp2 setBackgroundImage:[UIImage imageNamed:@"message2.png"] forState:UIControlStateHighlighted];
        [temp2 setBounds:CGRectMake(0, 0, 60, 60)];
        [temp2 setBackgroundColor:[UIColor blackColor]];
        [temp2 setCenter:CGPointMake(self.view.frame.size.width/2, 65)];
        [temp2 setBackgroundColor:[UIColor clearColor]];
        UILabel*title2=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, 60, 12)];
        [title2 setTextAlignment:NSTextAlignmentCenter];
        title2.font=font;
        title2.text=@"Message";
        title2.backgroundColor=[UIColor clearColor];
        title2.textColor=[UIColor whiteColor];
        [temp2 addSubview:title2];
        
        UIButton*temp3=[[actionSheet subviews]objectAtIndex:3];
        [temp3 setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
        [temp3 setBackgroundImage:[UIImage imageNamed:@"twitter2.png"] forState:UIControlStateHighlighted];
        [temp3 setBounds:CGRectMake(0, 0, 60, 60)];
        [temp3 setBackgroundColor:[UIColor blackColor]];
        [temp3 setCenter:CGPointMake(260, 65)];
        [temp3 setBackgroundColor:[UIColor clearColor]];
        UILabel*title3=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, 60, 12)];
        [title3 setTextAlignment:NSTextAlignmentCenter];
        title3.font=font;
        title3.text=@"Twitter";
        title3.backgroundColor=[UIColor clearColor];
        title3.textColor=[UIColor whiteColor];
        [temp3 addSubview:title3];
        
        UIButton*temp4=[[actionSheet subviews]objectAtIndex:4];
        [temp4 setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
        [temp4 setBackgroundImage:[UIImage imageNamed:@"facebook2.png"] forState:UIControlStateHighlighted];
        [temp4 setBounds:CGRectMake(0, 0, 60, 60)];
        [temp4 setBackgroundColor:[UIColor blackColor]];
        [temp4 setCenter:CGPointMake(60, 180)];
        [temp4 setBackgroundColor:[UIColor clearColor]];
        UILabel*title4=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, 60, 12)];
        [title4 setTextAlignment:NSTextAlignmentCenter];
        title4.font=font;
        title4.text=@"Facebook";
        title4.backgroundColor=[UIColor clearColor];
        title4.textColor=[UIColor whiteColor];
        [temp4 addSubview:title4];
        
        
        
    }
    
}



@end
