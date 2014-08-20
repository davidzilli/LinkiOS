//
//  LNKSystemsManager.h
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNKAPI.h"
#import "LNKSystem.h"

@interface LNKSystemsManager : NSObject

-(void) sync;
-(NSArray *)fetchSystems;
-(LNKSystem *) getSystemForID:(NSNumber *)id_;
-(NSSet *)getStationsForSystem:(LNKSystem *)system_;
-(LNKStation *) getStationForID:(NSNumber *)id_ fromSystem:(LNKSystem *)system_;

@property (nonatomic, strong) LNKAPI* API;

@end
