//
//  PlacesUIViewController.m
//  SmokeScreen
//
//  Created by me on 27/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesUIViewController.h"
#import "SlateNoteCellView.h"
#import "WriteNoteUIViewController.h"

@interface PlacesUIViewController (Private)
- (void)loadSlate;
@end

@implementation PlacesUIViewController


@synthesize slatenotes,slateTableView,currentSlateNote;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadSlate {
    // Load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    //objectManager.client.baseURL = @"http://192.168.1.2:8080/SmokeServer";
    //objectManager.client.baseURL = @"http://www.twitter.com";
    
    [objectManager loadObjectsAtResourcePath:@"/myresource" delegate:self block:^(RKObjectLoader* loader) 
     {
        // WebService returns as a naked array in JSON, so we instruct the loader
        // to user the appropriate object mapping
        if ([objectManager.acceptMIMEType isEqualToString:RKMIMETypeJSON]) {
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[SlateNote class]];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    [self loadSlate];
}


- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSMutableArray*)objects {
	//NSLog(@"Loaded statuses: %@", objects);    
    slatenotes = objects;
    for(SlateNote *note in slatenotes){
        NSLog(@"Note Text %@", note.noteText);
    
    }
	[slateTableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [slatenotes count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
   	SlateNoteCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"SlateNote"];
    
    int size = self.slatenotes.count;
    int rowAt = [indexPath row] + 1;
    
    SlateNote *note = [self.slatenotes objectAtIndex:(size-rowAt)];
    
       
    
    if(cell == nil)
    {
        NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"SlateNoteCellView" owner:self options:nil];
        for(id currentObject in objects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (SlateNoteCellView *)currentObject;
                break;
            }
        }
                            
        
        //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ABC"];
    }
    
    CGRect newframe = cell.textDescription.frame;
    
    newframe.size.height = [self getHeightByWidth:note.noteText textWidth:220]; 
    
    cell.textDescription.frame = newframe;
    
    cell.textLabel.text = note.noteTitle;
    cell.textDescription.text = note.noteText;
    
    
    NSLog(@"noteText %@", note.noteText );
    
    return cell;
}

-(float)getHeightByWidth:(NSString*)myString textWidth:(int)myWidth {
    
    CGSize boundingSize = CGSizeMake(myWidth, CGFLOAT_MAX);
    CGSize requiredSize = [myString sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
    
    return requiredSize.height;
    
}

- (CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int size = self.slatenotes.count;
    int rowAt = [indexPath row] + 1;
    
    currentSlateNote = [self.slatenotes objectAtIndex:(size-rowAt)];
    //currentSlateNote = [self.slatenotes objectAtIndex:[indexPath row]];
    CGFloat newHeight = [self getHeightByWidth:currentSlateNote.noteText textWidth:155]; 
    
    if (newHeight < 44 )
        return 65;
    
    return newHeight;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushWriteNote"]) {
        
        // Get destination view
         WriteNoteUIViewController *vc = [segue destinationViewController];
        
        SlateNote *note = [[SlateNote alloc]init];        
        [note setSlateId:[NSNumber numberWithInt:1]];
        [note setUserId:[NSNumber numberWithInt:1]];  
        [note setUsers:[[NSMutableArray alloc]initWithCapacity:0]];
        
        // Pass the information to your destination view
        [vc setSlateNoteInView:note];
        vc.delegate = self;
    }
}

- (void)writeNoteViewControllerDidFinish:(WriteNoteUIViewController*) writeNoteViewController
{
    [self.slatenotes addObject:writeNoteViewController.note];
    
    [self.slateTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    
    //[self.slateTableView reloadData];
     }   

@end