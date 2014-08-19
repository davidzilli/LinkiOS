//
//  LNKStationsManager.h
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNKAPI.h"

@interface LNKStationsManager : NSObject

-(void)sync:(int)system_id;
-(void)handleResponse:(NSURLResponse *) response withData:(NSData *) data withError:(NSError *) error;

@property (nonatomic, strong) LNKAPI* API;

@end
