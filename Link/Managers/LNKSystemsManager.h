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

@protocol SystemSyncCompleteDelegate <NSObject>

-(void)systemSyncComplete:(BOOL)result;

@end

@protocol StationAvailabilitySyncCompleteDelegate <NSObject>

-(void)stationAvailabilitySyncComplete:(BOOL)result;

@end

@interface LNKSystemsManager : NSObject

-(void) sync;
-(NSArray *)fetchSystems;
- (void) updateStationAvailabilityForSystem:(LNKSystem *)system_;
-(LNKSystem *) getSystemForID:(NSNumber *)id_;
-(NSSet *)getStationsForSystem:(LNKSystem *)system_;
-(LNKStation *) getStationForID:(NSNumber *)id_ fromSystem:(LNKSystem *)system_;

@property (nonatomic, strong) LNKAPI* API;
@property (nonatomic, assign)id delegate;

@end
