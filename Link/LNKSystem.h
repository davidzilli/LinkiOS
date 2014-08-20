//
//  LNKSystem.h
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LNKStation.h"

@class LNKStation;

@interface LNKSystem : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * owner_id;
@property (nonatomic, retain) NSSet *stations;

-(instancetype) fillWithDictionary:(NSDictionary *)dictionary_;

@end

@interface LNKSystem (CoreDataGeneratedAccessors)

- (void)addStationsObject:(LNKStation *)value;
- (void)removeStationsObject:(LNKStation *)value;
- (void)addStations:(NSSet *)values;
- (void)removeStations:(NSSet *)values;

@end
