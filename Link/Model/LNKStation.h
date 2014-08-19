//
//  LNKStation.h
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNKStation : NSManagedObject

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int vehicle_types_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int bikeCount;
@property (nonatomic) int bikeSpaces;

- (id)initWithDictionary:(NSDictionary *) stationInfo;

@end
