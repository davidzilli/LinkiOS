//
//  LNKSyncSystemsViewController.h
//  Link
//
//  Created by David Zilli on 8/21/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNKSystemsManager.h"
#import "LNKSelectSystemViewController.h"

@interface LNKSyncSystemsViewController : UIViewController <SystemSyncCompleteDelegate>

@property (nonatomic, strong) LNKSystemsManager *sysManager;
@property (nonatomic, strong) LNKMapViewController *mapVC;
@property (nonatomic, strong) LNKSelectSystemViewController *selectSystemVC;

@end
