//
//  SearchViewController.h
//  HerCampus2v1.1
//
//  Created by Pawel Ferens on 1/23/13.
//  Copyright (c) 2013 Pawel Ferens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "UIImageView+WebCache.h"
#import "ContentViewController.h"
#import "SearchResultViewController.h"
@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{

UITableView *myTableView;
//NSMutableArray *dataSource; //will be storing all the data
NSMutableArray *tableData;//will be storing data that will be displayed in table
NSMutableArray *searchedData;//will be storing data matching with the search string

UISearchBar *sBar;//search bar
}
- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic,retain)NSMutableArray* dataSource;
@property(nonatomic,retain)NSString*searchedText;
@property(nonatomic,retain)SearchResultViewController* cont;
@property int founded;
@property int foundedInContent;
@property(nonatomic,retain)SearchArticlesConnectionManager*man;
@property(nonatomic,retain)UIView *loadingView;
@property(nonatomic,retain)UIActivityIndicatorView*spinner;
@end
