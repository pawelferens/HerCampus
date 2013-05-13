//
//  SearchViewController.m
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/23/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize dataSource;
@synthesize searchedText;
@synthesize cont;
@synthesize founded;
@synthesize foundedInContent;
@synthesize man;
@synthesize loadingView;
@synthesize spinner;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)searchCompleted:(id)notification
{
    founded=0;
    foundedInContent=0;
    self.dataSource=man.foundArticles;
    [spinner stopAnimating];
    spinner.hidden=true;
    NSLog(@"%@",searchedText);
    for(int i=0;i<[dataSource count];i++)
    {
        Article*t=[dataSource objectAtIndex:i];
        
        
        if ([t.title rangeOfString:self.searchedText options:NSCaseInsensitiveSearch].location == NSNotFound){
            //   NSLog(@"nie znaleziono");
        }
        else
        {
            founded++;
            [tableData addObject:t];
            NSLog(@"%@",t.title);
        }
        [loadingView setAlpha:0.0f];
        
    }
    
    for(int i=0;i<[dataSource count];i++)
    {
        Article*t=[dataSource objectAtIndex:i];
        
        
        if ([t.title rangeOfString:self.searchedText options:NSCaseInsensitiveSearch].location == NSNotFound){
            //   NSLog(@"nie znaleziono");
            
            if ([t.text rangeOfString:self.searchedText options:NSCaseInsensitiveSearch].location == NSNotFound){
                //   NSLog(@"nie znaleziono");
            }
            else
            {
                foundedInContent++;
                [tableData addObject:t];
                NSLog(@"%@",t.title);
            }
            
        }
        
        
        
    }
    
    NSLog(@"%d|| %d",founded,foundedInContent);
    [myTableView reloadData];
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   
    sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,60,self.view.frame.size.width,30)];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, self.view.frame.size.height-95)];
    NSLog(@"rot %f",self.view.frame.size.width);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
- (void)loadView {
    
    
    
    
    NSString *notificationnName = @"searchCompleted";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(searchCompleted:)
     name:notificationnName
     object:nil];
    
    //  self.view.backgroundColor=[UIColor blackColor];
    searchedText=[[NSString alloc]init];
    [super loadView];
    founded=0;
    foundedInContent=0;
    sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,60,self.view.frame.size.width,30)];
    UIImage *blackBack=[UIImage imageNamed:@"bar2.png"  ];
    sBar.backgroundImage=blackBack;
    sBar.delegate = self;
    sBar.barStyle  = UIBarStyleBlack;
    // sBar.showsCancelButton = YES;
    
    [self.view addSubview:sBar];
    int screenHeigth=self.view.frame.size.height;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, screenHeigth-95)];   //stare 91
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    //initialize the two arrays; dataSource will be initialized and populated by appDelegate
    searchedData = [[NSMutableArray alloc]init];
    tableData = [[NSMutableArray alloc]init];
    [tableData addObjectsFromArray:dataSource];//on launch it should display all the records
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(founded==0 && foundedInContent==0)
    {
        return 1;
    }
    else if(founded!=0 &&foundedInContent!=0 )
    {
        return 2;
    }
    else
    {
        return 1;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"contacts error in num of row");
    if(founded==0 && foundedInContent==0)
    {
        return [tableData count];
    }
    else if(founded!=0 &&foundedInContent!=0 )
    {
        if(section==0)
        {
            return founded;
        }
        else if (section==1)
        {
            return foundedInContent;
        }
    }
    else
    {
        return [tableData count];
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
    }
    Article*temp;
    if(founded==0 && foundedInContent==0)
    {
        temp=[tableData objectAtIndex:indexPath.row];
    }
    else if(founded!=0 &&foundedInContent!=0 )
    {
        
        if(indexPath.section==0)
        {
            temp=[tableData objectAtIndex:indexPath.row];
        }
        else
        {
            temp=[tableData objectAtIndex:indexPath.row+founded];
        }
        
    }
    else
    {
        temp=[tableData objectAtIndex:indexPath.row];
    }
    
    
    
    
    //cell.text = temp.title;
    //UIImageView*th=cell.imageView;
    UIImageView*th=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 45, 40)];
    //
    [th setImage:[UIImage imageNamed:@"gradient_border.png"]];
    [th setImageWithURL:[NSURL URLWithString:temp.primaryArticleImage]
       placeholderImage:[UIImage imageNamed:@"gradient_border.png"]];
    // th.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:th];
    
    UIFont* font2= [UIFont fontWithName:@"OpenSans-Bold" size:10];
    UILabel* l=[[UILabel alloc]initWithFrame:CGRectMake(th.frame.size.width+10, 2, 260, 40)];
    l.text=temp.title;
    l.font=font2;
    [cell addSubview:l];
    
    return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
    
    //    NSDictionary *attributes =
    //    [NSDictionary dictionaryWithObjectsAndKeys:
    //     [UIColor whiteColor], UITextAttributeTextColor,
    //     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], UITextAttributeTextShadowColor,
    //     [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
    //     [UIFont systemFontOfSize:12], UITextAttributeFont,
    //
    //     nil];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
    //     setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
    //     setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    
    founded=0;
    foundedInContent=0;
    sBar.showsCancelButton = YES;
    
    for (UIView *view in [searchBar subviews])
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UIButton *searchTextField = (UIButton *)view;
            [searchTextField setFrame:CGRectMake(searchTextField.frame.origin.x, searchTextField.frame.origin.y, searchTextField.frame.size.width, searchTextField.frame.size.height-30)];
        }
    }
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [tableData removeAllObjects];
    [myTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    founded=0;
    foundedInContent=0;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchedText=searchText;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cont=[[SearchResultViewController alloc]init];
    // cont=[self.storyboard instantiateViewControllerWithIdentifier:@"searchResultWindow"];
    Article*t;
    if(indexPath.section==0)
    {
        t=[tableData objectAtIndex:indexPath.row];
    }
    else
    {
        t=[tableData objectAtIndex:indexPath.row+founded];
    }
    
    
    cont.contentText=t.text;
    cont.articleA=t;
    
    [self.navigationController pushViewController:cont animated:TRUE];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    founded=0;
    foundedInContent=0;
    
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:dataSource];
    @try{
        [myTableView reloadData];
    }
    @catch(NSException *e){
        
    }
    [sBar resignFirstResponder];
    sBar.text = @"";
    sBar.showsCancelButton=false;
    
    
    
    
    
    
    //  [self dismissModalViewControllerAnimated:YES];
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    man=[[SearchArticlesConnectionManager alloc]init];
    [man searchArticleswithKeyword:self.searchedText];
    
    [searchBar resignFirstResponder];
    sBar.showsCancelButton=false;
    
    
    loadingView=[[UIView alloc]initWithFrame:CGRectMake(myTableView.frame.origin.x, myTableView.frame.origin.y, myTableView.frame.size.width, myTableView.frame.size.height)];
    [loadingView setBackgroundColor:[UIColor colorWithRed:184.0f/255.0f green:183.0f/255.0f blue:183.0f/255.0f alpha:1]];
    [loadingView setAlpha:0.8f];
    [self.view addSubview:loadingView];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.color=[UIColor blackColor];
    [spinner setCenter:CGPointMake(160, myTableView.frame.size.height/2)]; // I do this because I'm in landscape mode
    [spinner setHidden:false];
    
    [spinner startAnimating];
    [myTableView addSubview:spinner];
    
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
	headerLabel.frame = CGRectMake(6.0, 0.0, 320.0, 20.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    NSString * sectionName;
    if(founded==0 && foundedInContent==0)
    {
        sectionName=@"SEARCH RESULTS";
    }
    else if(founded!=0 &&foundedInContent!=0 )
    {
        if(section==0)
        {
            sectionName=@"SEARCH IN TITLE RESULTS";
        }
        else
        {
            sectionName=@"SEARCH IN CONTENT RESULTS";
        }
    }
    else if(founded==0 &&foundedInContent!=0 )
    {
        sectionName=@"SEARCH IN CONTENT RESULTS";
    }
    else if(founded!=0 &&foundedInContent==0 )
    {
        sectionName=@"SEARCH RESULTS";
    }
    else
    {
        sectionName=@"SEARCH RESULTS";
    }
    
    
    
    headerLabel.text =sectionName; // i.e. array element
    [customView addSubview:headerLabel];
    
    
	return customView;
}


@end
