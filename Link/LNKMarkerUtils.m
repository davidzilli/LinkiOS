//
//  LNKMarkerUtils.m
//  Link
//
//  Created by David Zilli on 8/20/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKMarkerUtils.h"

@implementation LNKMarkerUtils

+(GMSMarker *)markerFromStation:(LNKStation *)station_
{
    if (!station_) {
        return nil;
    }
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([station_.latitude doubleValue], [station_.longitude doubleValue]);
    marker.title = station_.name;
    NSMutableString *snippet_string = [[NSMutableString alloc] init];
    [snippet_string appendFormat:@"Bikes: %@ ", station_.bikeCount];
    [snippet_string appendFormat:@"Spaces: %d", [station_.bikeSpaces intValue] - [station_.bikeCount intValue]];
    marker.snippet = snippet_string;
    
    if ((station_.bikeCount == 0 && station_.bikeSpaces == 0) || [station_.status isEqualToString:@"disabled"]) {
        marker.icon = [UIImage imageNamed:@"ic_rack_disabled"];
    } else if ([station_.bikeCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
        marker.icon = [UIImage imageNamed:@"ic_rack_empty"];
    } else if ([station_.bikeSpaces intValue] == [station_.bikeCount intValue]) {
        marker.icon = [UIImage imageNamed:@"ic_rack_full"];
    } else {
        marker.icon = [UIImage imageNamed:@"ic_rack_perfect"];
    }
    
    return marker;
}

@end
