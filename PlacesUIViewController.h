//
//  PlacesUIViewController.h
//  SmokeScreen
//
//  Created by me on 27/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restkit/RestKit.h"
#import "SlateNote.h"
#import "WriteNoteUIViewController.h"

@interface PlacesUIViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, WriteNoteUIViewControllerDelegate>

@property(nonatomic, retain) NSMutableArray *slatenotes;
@property(nonatomic, retain) IBOutlet UITableView *slateTableView;
@property(nonatomic, weak) SlateNote* currentSlateNote;

-(float)getHeightByWidth:(NSString*)myString textWidth:(int)myWidth;

@end
