//
//  LNKSystem.m
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKSystem.h"
#import "LNKStation.h"


@implementation LNKSystem

@dynamic id;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic owner_id;
@dynamic stations;

-(instancetype) fillWithDictionary:(NSDictionary *)dictionary_
{
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if (self) {
        self.id = [numFormatter numberFromString:[dictionary_ objectForKey:@"id"]];
        self.name = [dictionary_ objectForKey:@"name"];
        self.owner_id = [numFormatter numberFromString:[dictionary_ objectForKey:@"owner_id"]];
        self.latitude = [numFormatter numberFromString:[dictionary_ objectForKey:@"latitude"]];
        self.longitude = [numFormatter numberFromString:[dictionary_ objectForKey:@"longitude"]];
    }
    
    return self;
}

-(NSString *)description
{
    NSMutableString *description_string = [[NSMutableString alloc] init];
    [description_string appendString:[NSString stringWithFormat:@"ID: %@\n", self.id]];
    [description_string appendString:[NSString stringWithFormat:@"Name: %@\n", self.name]];
    [description_string appendString:[NSString stringWithFormat:@"Owner Id: %@\n", self.owner_id]];
    [description_string appendString:[NSString stringWithFormat:@"Lat: %@\n", self.latitude]];
    [description_string appendString:[NSString stringWithFormat:@"Lng: %@\n", self.longitude]];
    [description_string appendString:[NSString stringWithFormat:@"STATIONS:\n"]];
    for (LNKStation *station in self.stations) {
        [description_string appendString:[station description]];
    }
    
    return description_string;
}

@end
