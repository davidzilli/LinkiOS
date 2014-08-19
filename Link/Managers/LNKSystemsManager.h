//
//  LNKSystemsManager.h
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNKAPI.h"

@interface LNKSystemsManager : NSObject

-(void) sync;

@property (nonatomic, strong) LNKAPI* API;

@end
