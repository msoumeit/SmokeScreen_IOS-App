//
//  UserSearchViewController.m
//  SmokeScreen
//
//  Created by me on 26/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserSearchViewController.h"


@implementation UserSearchViewController

@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize allItems;
@synthesize searchResults;
@synthesize selectedUsers, allKeys, origUserDic;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) setUserList
{
    self.allItems = [origUserDic allValues];
    self.allKeys = [origUserDic allKeys];
    NSLog(@"%@", self.allItems);
    NSLog(@"%@", self.allKeys);
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIView *view in self.searchBar.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }    
    }
    // [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;

    self.searchResults = [NSMutableArray arrayWithCapacity:self.allItems.count];
    
    self.selectedUsers = [[NSMutableDictionary alloc] init];
    
    self.origUserDic = [[NSMutableDictionary alloc]init];
    
   // [self loadUsers];
      
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView 
         isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else{
        rows = [self.allItems count];
    }
    
    return rows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UserSearchViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UserSearchViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:CellIdentifier];
        
        
    }
    
    /* Configure the cell. */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text = 
        [self.searchResults objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text =
        [self.allItems objectAtIndex:indexPath.row];
    }
    cell.keyForUser = [[self.origUserDic allKeysForObject:cell.textLabel.text] objectAtIndex:0];
    
    NSLog(@"Selected Users %@", self.selectedUsers);
    NSLog(@"Selected Value %@", cell.textLabel.text);  
    NSLog(@"Selected Row Value %@" ,[self.selectedUsers objectForKey:cell.keyForUser]);
    NSLog(@"cell detail Before %@",cell.keyForUser);
    
    if([self.selectedUsers objectForKey:cell.keyForUser] == nil)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */     
    
    UserSearchViewCell *cell = (UserSearchViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if([self.selectedUsers objectForKey:cell.keyForUser] == nil)
    {
        NSMutableString *mstr = [[NSMutableString alloc]initWithString:cell.textLabel.text];
        NSMutableString *mkey = [[NSMutableString alloc]initWithString:cell.keyForUser];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [ self.selectedUsers setObject:mstr forKey:mkey];
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [ self.selectedUsers removeObjectForKey:cell.keyForUser];  
    }
    
   // [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.allItems filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //if we only try and resignFirstResponder on textField or searchBar,
    //the keyboard will not dissapear (at least not on iPad)!
    //[self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.searchBar afterDelay: 0.1];
    [self.tableView reloadData];
    return YES;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"A %@", objects);
    NSLog(@"B %d", objects.count);
    NSLog(@"C %@", [[objects objectAtIndex:0] isKindOfClass:[UserSearch class]] ? @"Yes":@"No");
    
    for(UserSearch *user in objects){
        NSLog(@"USER %@", user.userName);
            NSLog(@"USER %d", [user.userId intValue]);
        NSMutableString *mstr = [[NSMutableString alloc]initWithString:user.userName];
        NSMutableString *mkey = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%d",[user.userId intValue]]];  
        [self.origUserDic setObject:mstr forKey:mkey];
        }
        
    [self setUserList];
    [self.tableView reloadData]; 
       
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

- (void)loadUsers{
    // Load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:1],@"id",@"venue", @"type", nil];
    
    [objectManager loadObjectsAtResourcePath:[@"/users" appendQueryParams:params ]delegate:self block:^(RKObjectLoader* loader) 
     {
         // WebService returns as a naked array in JSON, so we instruct the loader
         // to user the appropriate object mapping
         if ([objectManager.acceptMIMEType isEqualToString:RKMIMETypeJSON]) {
             loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[UserSearch class]];
         }
     }];
    
    
}

- (IBAction)addMentionedUsersKeyPressed:(id)sender
{
     [self.delegate userSearchViewControllerDidFinish:self];
     [self.navigationController popViewControllerAnimated:YES];
}

@end
