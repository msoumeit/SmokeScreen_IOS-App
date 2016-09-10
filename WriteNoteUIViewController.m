//
//  WriteNoteUIViewController.m
//  SmokeScreen
//
//  Created by me on 20/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WriteNoteUIViewController.h"

@implementation WriteNoteUIViewController

@synthesize textCount,textInView, note,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

-(void) setSlateNoteInView:(SlateNote *)slatenote
{
    note = slatenote;
}
#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) textViewDidChange:(UITextView *)textView
{
    textCount.text = [NSString stringWithFormat:@"%d",[[textView text] length] ];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(range.length > text.length){
        return YES;
    }else if([[textView text] length] + text.length > 255){
        return NO;
    }
    
    return YES;
    
}

- (IBAction) removeKeyboard:(id)sender
{
    [ textInView resignFirstResponder];
}

- (IBAction) writeNoteKeyPressed:(id)sender
{
    [self saveNote];
    [delegate writeNoteViewControllerDidFinish:self];
    
}

- (void) saveNote
{
    [note setNoteText:textInView.text];    
    [note setNoteTitle:@"Russia With Love"];
    
    NSLog(@"%d", [[[note.users objectAtIndex:0] userId] intValue]);
    
    RKObjectMappingProvider* provider = [[RKObjectManager sharedManager] mappingProvider]; 
        
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];     
    [[RKObjectManager sharedManager] postObject:note mapResponseWith:[provider mappingForKeyPath:@"returnStatus"] delegate:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray *)objects
{
        [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectUsers"]) {
        
        // Get destination view
       UserSearchViewController *vc = [segue destinationViewController];
        
       /* NSDictionary* dictr = [[NSDictionary alloc]initWithObjectsAndKeys:
                               @"Alex",@"1", 
                               @"Ben",@"2",
                               @"Brinda",@"3",
                               @"Sam",@"4",
                               @"Dics",@"5"
                               ,nil];   
        */
        // Pass the information to your destination view
        [vc loadUsers];
        vc.delegate = self;
        
        
    }
}

- (void)userSearchViewControllerDidFinish:(UserSearchViewController*) userSearchViewController
{
    NSDictionary* dic = [userSearchViewController selectedUsers];
    
    for(NSString* key in dic ){
        UserSearch* user = [[UserSearch alloc]init];
        NSNumber* Id = [[NSNumber alloc]initWithInt:[key intValue]];
        user.userId = Id;
        user.userName = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
        [note.users addObject:user];
    }
    
    

}

@end
