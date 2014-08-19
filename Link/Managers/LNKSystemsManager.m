//
//  LNKSystemsManager.m
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKSystemsManager.h"

@implementation LNKSystemsManager

@synthesize API;

-(void) sync
{
    API = [[LNKAPI alloc] init];

    NSData *postData = [API createPostData:[[NSString alloc] init]];
    
    API.handlePostBlock = ^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"CALL BACK");
        if ([data length] > 0 && error == nil) {
            
            NSString *myData = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
            NSLog(@"%@", myData);
            NSError *error;
            id jsonObject = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:NSJSONReadingAllowFragments
                             error:&error];
            
            if (jsonObject != nil && error == nil) {
                NSLog(@"Succesfully deserialized");
                NSMutableArray *systems = [NSMutableArray array];
                for (NSDictionary *system in jsonObject) {
                    [systems addObject:system];
                }
                
            }
        }
        
    };
    
    NSString *URL = URI_GET_SYSTEMS;
    [API sendPost:postData toURL:URL];
    
}

@end
