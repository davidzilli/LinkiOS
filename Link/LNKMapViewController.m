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
@property (nonatomic, strong) NSArray *systemArray;
@property (nonatomic, strong) UIButton *systemsButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIImageView *refreshProgressView;

-(IBAction)showSystems:(id)sender;
@end

@implementation LNKMapViewController {
    GMSMapView *mapView_;
}

@synthesize sysManager;
@synthesize curSystem;
@synthesize systemsButton;
@synthesize locationButton;
@synthesize refreshButton;
@synthesize refreshProgressView;
@synthesize systemArray;



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
    NSLog(@"View Did Load");
    [super viewDidLoad];
    
    /** Get default System */
    sysManager = [[LNKSystemsManager alloc] init];
    sysManager.delegate = self;
    NSNumber *default_system_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_system_id"];
    curSystem = [sysManager getSystemForID:default_system_id];
    
    /*Get all systems loaded into array */
    systemArray = [sysManager fetchSystems];
    
    // Do any additional setup after loading the view from its nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[curSystem.latitude doubleValue]
                                                            longitude:[curSystem.longitude doubleValue]
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    [self addMarkers];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"View Will Appear");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"ic_refresh_floating"]  forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"ic_refresh_floating_sel"] forState:UIControlStateHighlighted];
    [refreshButton sizeToFit];
    refreshButton.center = CGPointMake(screenRect.size.width - (refreshButton.bounds.size.width / 2) - 10, screenRect.size.height - (refreshButton.bounds.size.height / 2) - 10);
    [refreshButton addTarget:self action:@selector(refreshStationAvailability) forControlEvents:UIControlEventTouchUpInside];
    [mapView_ addSubview:refreshButton];
    
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setImage:[UIImage imageNamed:@"ic_location_floating_icon"] forState:UIControlStateNormal];
    [locationButton setImage:[UIImage imageNamed:@"ic_location_floating_icon_sel"] forState:UIControlStateHighlighted];
    [locationButton sizeToFit];
    locationButton.center = CGPointMake(refreshButton.center.x - (locationButton.bounds.size.width), screenRect.size.height - (locationButton.bounds.size.height / 2) - 10);
    [locationButton addTarget:self action:@selector(moveCameraToLocation) forControlEvents:UIControlEventTouchUpInside];
    [mapView_ addSubview:locationButton];
    
    refreshProgressView = [[UIImageView alloc] initWithFrame:refreshButton.frame];
    [refreshProgressView setImage:[UIImage imageNamed:@"ic_square_floating"]];
    UIActivityIndicatorView *refreshProgress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshProgress.center = CGPointMake(refreshProgressView.bounds.size.width / 2, refreshProgressView.bounds.size.height / 2);
    [refreshProgressView addSubview:refreshProgress];
    [mapView_ addSubview:refreshProgressView];
    [refreshProgress startAnimating];
    refreshProgressView.hidden = YES;
                                                
    systemsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [systemsButton addTarget:self action:@selector(showSystems:) forControlEvents:UIControlEventTouchUpInside];
    [systemsButton setBackgroundColor:[UIColor colorWithRed:0.396 green:0.757 blue:0.761 alpha:1]];
    systemsButton.frame = CGRectMake(screenRect.origin.x + 4, screenRect.origin.y + 20, screenRect.size.width - 8, 40);
    [systemsButton setTitle:curSystem.name forState:UIControlStateNormal];
    [systemsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [systemsButton setContentEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    [systemsButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
    systemsButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    systemsButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [mapView_ addSubview:systemsButton];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"View Did Appear");
    [sysManager updateStationAvailabilityForSystem:curSystem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate
{
    return NO;
}

-(void) moveCameraToSystem
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[curSystem.latitude doubleValue]
                                                            longitude:[curSystem.longitude doubleValue]
                                                                 zoom:13];

    [mapView_ setCamera:camera];
}

-(void) moveCameraToLocation
{
    if (mapView_.myLocation) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:mapView_.myLocation.coordinate zoom:15];
        [mapView_ animateToCameraPosition:camera];
    }
}

- (void) refreshStationAvailability
{
    NSLog(@"Refresh availability");
    NSLog(@"My Location: %@", mapView_.myLocation);
    refreshProgressView.hidden = NO;
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
        refreshProgressView.hidden = YES;
        [self addMarkers];
    });
    
}

-(IBAction)showSystems:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Bikeshare System"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (LNKSystem *system in self.systemArray) {
        [actionSheet addButtonWithTitle:system.name];
    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        curSystem = self.systemArray[buttonIndex];
        [self.systemsButton setTitle:curSystem.name forState:UIControlStateNormal];
        [self moveCameraToSystem];
    }
}


@end
