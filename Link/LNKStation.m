//
//  LNKStation.m
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKStation.h"
#import "LNKSystem.h"


@implementation LNKStation

@synthesize bikeCount;
@synthesize bikeSpaces;
@dynamic id;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic status;
@dynamic vehicle_types_id;
@dynamic system;

-(instancetype) fillWithDictionary:(NSDictionary *)dictionary_
{
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    if (self) {
        self.id = [numFormatter numberFromString:[dictionary_ objectForKey:@"id"]];
        self.name = [dictionary_ objectForKey:@"name"];
        self.status = [dictionary_ objectForKey:@"status"];
        self.latitude = [numFormatter numberFromString:[dictionary_ objectForKey:@"latitude"]];
        self.longitude = [numFormatter numberFromString:[dictionary_ objectForKey:@"longitude"]];
    }
    
    return self;
}

-(instancetype) updateAvailabilityWithDictionary:(NSDictionary *)dictionary_
{
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if (self) {
        self.status = [dictionary_ objectForKey:@"status"];
        self.bikeCount = [numFormatter numberFromString:[dictionary_ objectForKey:@"vehicle_count"]];
        self.bikeSpaces = [numFormatter numberFromString:[dictionary_ objectForKey:@"space_count"]];

    }
    
    return self;
}

- (NSString *) description
{
    NSMutableString *description_string = [[NSMutableString alloc] init];
    [description_string appendString:[NSString stringWithFormat:@"ID: %@\n", self.id]];
    [description_string appendString:[NSString stringWithFormat:@"Name: %@\n", self.name]];
    [description_string appendString:[NSString stringWithFormat:@"Status: %@\n", self.status]];
    [description_string appendString:[NSString stringWithFormat:@"Lat: %@\n", self.latitude]];
    [description_string appendString:[NSString stringWithFormat:@"Lng: %@\n", self.longitude]];
    [description_string appendString:[NSString stringWithFormat:@"Bikes: %@\n", self.bikeCount]];
    [description_string appendString:[NSString stringWithFormat:@"Spaces: %@\n\n", self.bikeSpaces]];
    return description_string;
}

@end
