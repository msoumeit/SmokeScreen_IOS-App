//
//  UserSearchViewController.h
//  SmokeScreen
//
//  Created by me on 26/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSearchViewCell.h"
#import "Restkit/RestKit.h"
#import "UserSearch.h"

@protocol UserSearchViewControllerDelegate;

@interface UserSearchViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UISearchDisplayDelegate , UITextFieldDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, copy) NSArray *allItems;
@property (nonatomic, copy) NSArray *searchResults;
@property (nonatomic, retain) NSMutableDictionary *selectedUsers;
@property (nonatomic, retain) NSArray *allKeys;

@property (nonatomic, retain) NSMutableDictionary *origUserDic;

@property (nonatomic, assign) id<UserSearchViewControllerDelegate> delegate;

- (void) setUserList;
- (void)loadUsers;

- (IBAction)addMentionedUsersKeyPressed:(id)sender;

@end

@protocol UserSearchViewControllerDelegate
- (void)userSearchViewControllerDidFinish:(UserSearchViewController*) userSearchViewController;
@end