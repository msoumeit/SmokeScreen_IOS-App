//
//  SlateNote.h
//  SmokeScreen
//
//  Created by me on 12/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface SlateNote : NSObject

@property(nonatomic,assign) NSNumber *noteId;
@property(nonatomic,retain) NSString *noteTitle;
@property(nonatomic,retain) NSString *noteText;	
@property(nonatomic,retain) NSNumber *slateId;
@property(nonatomic,retain) NSNumber *userId;

@property (nonatomic, retain) NSMutableArray* users;

@end
