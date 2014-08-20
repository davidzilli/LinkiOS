//
//  LNKCoreDataObject.m
//  Link
//
//  Created by David Zilli on 8/20/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKCoreDataObject.h"

@implementation LNKCoreDataObject

-(BOOL) save
{
    /** Implemented an UPDATE/INSERT behavior */
    
    /** Try to fetch an object of this type from the DB.
     If an object is returned, update its values,
     else insert a new object*/

    return true;
}

@end
