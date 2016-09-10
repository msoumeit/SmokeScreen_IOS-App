//
//  WriteNoteUIViewController.h
//  SmokeScreen
//
//  Created by me on 20/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlateNote.h"
#import "Restkit/RestKit.h"
#import "UserSearch.h"
#import "UserSearchViewController.h"

@protocol WriteNoteUIViewControllerDelegate;

@interface WriteNoteUIViewController : UIViewController<UITextViewDelegate,RKObjectLoaderDelegate,UserSearchViewControllerDelegate>

@property (nonatomic , retain) SlateNote *note;
@property (nonatomic, weak) IBOutlet UILabel *textCount;
@property (nonatomic, retain) IBOutlet UITextView *textInView;



@property (nonatomic, assign) id<WriteNoteUIViewControllerDelegate> delegate;

- (IBAction) removeKeyboard:(id)sender; 
- (IBAction) writeNoteKeyPressed:(id)sender;
- (void) saveNote;


-(void) setSlateNoteInView:(SlateNote *)slatenote;

@end

@protocol WriteNoteUIViewControllerDelegate
- (void)writeNoteViewControllerDidFinish:(WriteNoteUIViewController*) writeNoteViewController;
@end