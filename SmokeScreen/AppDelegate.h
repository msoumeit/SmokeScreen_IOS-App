//
//  AppDelegate.h
//  SmokeScreen
//
//  Created by me on 27/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlateNote.h"
#import "ReturnStatus.h"
#import "UserSearch.h"
#import <RestKit/RestKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setRouterForWeb:(RKObjectManager*) objectManager;

@end
