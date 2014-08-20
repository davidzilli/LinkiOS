//
//  LNKMapViewController.m
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LNKSystemsManager.h"
#import "LNKSystem.h"
#import "LNKMarkerUtils.h"

@interface LNKMapViewController ()

@end

@implementation LNKMapViewController {
    GMSMapView *mapView_;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /** Get a System */
    LNKSystemsManager *sysmgr = [[LNKSystemsManager alloc] init];
    LNKSystem *system = [sysmgr getSystemForID:[NSNumber numberWithInt:1]];
    
    
    // Do any additional setup after loading the view from its nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[system.latitude doubleValue]
                                                            longitude:[system.longitude doubleValue]
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    /** Add Markers */
    NSSet *stations = [sysmgr getStationsForSystem:system];
    NSPredicate *active_predicate = [NSPredicate predicateWithFormat:@"status == %@", @"active"];
    NSSet *active_stations = [stations filteredSetUsingPredicate:active_predicate];
    for (LNKStation *station in active_stations) {
        GMSMarker *marker = [LNKMarkerUtils markerFromStation:station];
        [marker setMap:mapView_];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
