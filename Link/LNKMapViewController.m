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

@synthesize sysManager;
@synthesize curSystem;



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
    sysManager = [[LNKSystemsManager alloc] init];
    sysManager.delegate = self;
    NSNumber *default_system_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_system_id"];
    curSystem = [sysManager getSystemForID:default_system_id];
    
    
    // Do any additional setup after loading the view from its nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[curSystem.latitude doubleValue]
                                                            longitude:[curSystem.longitude doubleValue]
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    [self addMarkers];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(refreshStationAvailability) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(mapView_.bounds.size.width - 110, mapView_.bounds.size.height - 30, 100, 20);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [button setTitle:@"Refresh" forState:UIControlStateNormal];
    [mapView_ addSubview:button];
    
    [sysManager updateStationAvailabilityForSystem:curSystem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshStationAvailability
{
    NSLog(@"Refresh availability");
    [sysManager updateStationAvailabilityForSystem:curSystem];
}

- (void) addMarkers
{
    [mapView_ clear];
    LNKSystemsManager *sysmgr = [[LNKSystemsManager alloc] init];
    LNKSystem *system = [sysmgr getSystemForID:[NSNumber numberWithInt:1]];
    /** Add Markers */
    NSSet *stations = [sysmgr getStationsForSystem:system];
    NSPredicate *active_predicate = [NSPredicate predicateWithFormat:@"status == %@", @"active"];
    NSSet *active_stations = [stations filteredSetUsingPredicate:active_predicate];
    for (LNKStation *station in active_stations) {
        GMSMarker *marker = [LNKMarkerUtils markerFromStation:station];
        [marker setMap:mapView_];
    }

}

#pragma mark Systems Manager Delegate functions
-(void)stationAvailabilitySyncComplete:(BOOL)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Your code to run on the main queue/thread
        NSLog(@"Delegate Method Fired!");
        [self addMarkers];
    });
    
}

@end
