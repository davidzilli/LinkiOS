//
//  LNKMarkerUtils.h
//  Link
//
//  Created by David Zilli on 8/20/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LNKStation.h"

@interface LNKMarkerUtils : NSObject
+(GMSMarker *)markerFromStation:(LNKStation *)station_;
@end
