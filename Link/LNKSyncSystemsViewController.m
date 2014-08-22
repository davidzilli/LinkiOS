//
//  LNKSyncSystemsViewController.m
//  Link
//
//  Created by David Zilli on 8/21/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKSyncSystemsViewController.h"

@interface LNKSyncSystemsViewController ()

@property (nonatomic, weak) IBOutlet UIView *backgroundFrame;
@property (nonatomic, weak) IBOutlet UIImageView *linkLogo;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (nonatomic, weak) IBOutlet UILabel *connectingLabel;
@property (nonatomic, weak) IBOutlet UIButton *retryButton;

-(IBAction)loadSelectSystemVC:(id)sender;
-(IBAction)loadMapVC:(id)sender;
-(IBAction)retrySync:(id)sender;

@end

@implementation LNKSyncSystemsViewController

@synthesize sysManager;

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
    // Do any additional setup after loading the view from its nib.
    _backgroundFrame.translatesAutoresizingMaskIntoConstraints = YES;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"View Will Appear");
    [_retryButton setHidden:YES];
    [_progressIndicator startAnimating];
    sysManager = [[LNKSystemsManager alloc] init];
    sysManager.delegate = self;
    [sysManager sync];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"View did appear");
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

-(void)systemSyncComplete:(BOOL)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Your code to run on the main queue/thread
        NSLog(@"Delegate Method Fired!");
        [_progressIndicator setHidden:YES];
        [_connectingLabel setHidden:YES];
        if (result) {
            [self animateExpandWindow];
        } else {
            [_retryButton setHidden:NO];
        }
    });
}

-(void) retrySync:(id)sender
{
    [sysManager sync];
    [_progressIndicator setHidden:NO];
    [_connectingLabel setHidden:NO];
    [_retryButton setHidden:YES];
}

-(void) animateExpandWindow
{
    CGRect linkLogoFrame = self.linkLogo.frame;
    linkLogoFrame.origin.y = -100;
    
    /** Get entire screen rect */
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    CGRect backgroundFrameNew = self.backgroundFrame.frame;
    backgroundFrameNew.size.width = screenRect.size.width - 40;
    backgroundFrameNew.size.height = screenRect.size.height - 40;
    
    backgroundFrameNew.origin.y = screenRect.origin.y + 20;
    backgroundFrameNew.origin.x = screenRect.origin.x + 20;
    
    NSLog(@"Systems are synced");
    [UIView animateWithDuration:0.3f
                          delay:.3
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.linkLogo.frame = linkLogoFrame;
                         self.backgroundFrame.frame = backgroundFrameNew;
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Animation Done");
                         [self loadSelectSystemVC:self];
                     }];
    
}

-(IBAction)loadSelectSystemVC:(id)sender
{
    self.selectSystemVC = [[LNKSelectSystemViewController alloc] initWithNibName:@"LNKSelectSystemViewController" bundle:nil];
    [self presentViewController:self.selectSystemVC
                       animated:NO
                     completion:^{
                         
                     }];
}

-(IBAction)loadMapVC:(id)sender
{
    NSLog(@"Found default system, skipping to map");
    self.mapVC = [[LNKMapViewController alloc] init];
    [self presentViewController:self.mapVC
                       animated:YES
                     completion:^{
                         
                     }];
}

@end
