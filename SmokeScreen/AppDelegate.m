//
//  AppDelegate.m
//  SmokeScreen
//
//  Created by me on 27/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://192.168.1.2:8080/SmokeServer"];
    
    // Enable automatic network activity indicator management
    [RKRequestQueue sharedQueue].showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Setup our object mappings
    RKObjectMapping* snoteMapping = [RKObjectMapping mappingForClass:[SlateNote class]];
    
    RKObjectMapping* statusMapping = [RKObjectMapping mappingForClass:[ReturnStatus class]];
    
    [snoteMapping mapKeyPathsToAttributes:@"noteId", @"noteId",
     @"noteText", @"noteText",
     @"noteTitle", @"noteTitle",
     @"slateId" , @"slateId",
     @"userId", @"userId",
    nil];

    [statusMapping mapKeyPathsToAttributes:@"statusCode", @"statusCode",
     @"statusMessage", @"statusMessage",
     @"errorTrace", @"errorTrace",
     nil];
    
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[UserSearch class]];
    
    [userMapping mapKeyPathsToAttributes:@"userId", @"userId",
     @"userName", @"userName",
     @"userNickName", @"userNickName",
     nil];
    
    [snoteMapping mapKeyPath:@"users" toRelationship:@"users" withMapping:userMapping];
    
    // Register our mappings with the provider
   [objectManager.mappingProvider setMapping:snoteMapping forKeyPath:@"slateNote"];   
   [objectManager.mappingProvider setMapping:statusMapping forKeyPath:@"returnStatus"];  
   [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"userSearch"]; 
    
    RKObjectMapping* slateNoteSerializationMapping = [snoteMapping inverseMapping];
    // You can customize the mapping here as necessary -- adding/removing mappings
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:slateNoteSerializationMapping forClass:[SlateNote class]];
    
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    
   [self setRouterForWeb:objectManager];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)setRouterForWeb:(RKObjectManager*) objectManager
{
    
  
    // Define a default resource path for all unspecified HTTP verbs
    [objectManager.router routeClass:[SlateNote class] toResourcePath:@"/myresource/(identifier)"];
    [objectManager.router routeClass:[SlateNote class] toResourcePath:@"/myresource" forMethod:RKRequestMethodPOST];
    
}
@end
