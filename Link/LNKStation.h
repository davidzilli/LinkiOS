//
//  LNKStation.h
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class LNKSystem;

@interface LNKStation : NSManagedObject

@property (nonatomic, retain) NSNumber * bikeCount;
@property (nonatomic, retain) NSNumber * bikeSpaces;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * vehicle_types_id;
@property (nonatomic, retain) LNKSystem *system;

-(instancetype) fillWithDictionary:(NSDictionary *)dictionary_;

@end
