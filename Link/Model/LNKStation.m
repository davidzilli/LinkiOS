//
//  LNKStation.m
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKStation.h"

@implementation LNKStation

@synthesize id;
@synthesize name;
@synthesize vehicle_types_id;
@synthesize status;
@synthesize latitude;
@synthesize longitude;
@synthesize bikeCount;
@synthesize bikeSpaces;

-(id) initWithDictionary:(NSDictionary *)stationInfo_
{
    self = [super init];
    if (self) {
        
        NSDictionary *stationInfo = stationInfo_;
        NSLog(@"Station Info = %@", stationInfo);
        self.id = [[stationInfo objectForKey:@"id"] intValue];
        self.name = [stationInfo valueForKey:@"name"];
        self.vehicle_types_id = [[stationInfo objectForKey:@"vehicle_types_id"] intValue];
        self.status = [stationInfo valueForKey:@"status"];
        self.latitude = [[stationInfo objectForKey:@"latitude"]doubleValue];
        self.longitude = [[stationInfo objectForKey:@"longitude"]doubleValue];
        
        // Not initialized by server
        self.bikeCount = 0;
        self.bikeSpaces = 0;
    }
    
    return self;
}

@end
