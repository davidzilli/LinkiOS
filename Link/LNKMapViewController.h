//
//  LNKMapViewController.h
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNKSystemsManager.h"

@interface LNKMapViewController : UIViewController <StationAvailabilitySyncCompleteDelegate>

@property (nonatomic, strong) LNKSystemsManager *sysManager;
@property (nonatomic, strong) LNKSystem *curSystem;

@end
