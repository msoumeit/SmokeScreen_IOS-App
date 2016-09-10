//
//  ReturnStatus.h
//  SmokeScreen
//
//  Created by me on 22/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnStatus : NSObject

@property(nonatomic,assign) NSNumber *statusCode;
@property(nonatomic,retain) NSString *statusMessage;
@property(nonatomic,retain) NSString *errorTrace;	

@end
