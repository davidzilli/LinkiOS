//
//  LNKStationsManager.m
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKStationsManager.h"
#import "LNKAPI.h"

@implementation LNKStationsManager

@synthesize API;

-(void)sync:(int)system_id
{
    API = [[LNKAPI alloc] init];
    
    /** Create fields JSON String */
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    NSError *error;
    [fields setObject:[NSNumber numberWithInt:system_id] forKey:@"system_id"];
    NSData *fieldsJSON = [NSJSONSerialization dataWithJSONObject:fields options:0 error:&error];
    NSString *fieldsJSONString = [[NSString alloc] initWithData:fieldsJSON encoding:NSUTF8StringEncoding];

    NSData *postData = [API createPostData:fieldsJSONString];
    
    API.handlePostBlock = ^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"CALL BACK");
        if ([data length] > 0 && error == nil) {
            
            NSString *myData = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
            NSLog(@"%@", myData);
            
        }

    };
    
    NSString *URL = URI_GET_STATIONS;
    [API sendPost:postData toURL:URL];
    
}

@end
