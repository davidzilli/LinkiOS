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

@end
