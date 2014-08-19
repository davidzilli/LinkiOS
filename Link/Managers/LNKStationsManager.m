//
//  LNKStationsManager.m
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKStationsManager.h"

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
    
    /** Create Top level request object */
    NSString *URL = [[NSString alloc] initWithFormat:@"http://54.235.245.3/api/get_station_locations"];
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSMutableString *hashString = [[NSMutableString alloc] init];
    [hashString appendString:@"2f3j2jvbqpmgx6q"];
    [hashString appendString:@"4wz9ajxejfih3ai"];
    [hashString appendString:timestamp];
    
    NSMutableDictionary *requestPackage = [[NSMutableDictionary alloc] init];
    [requestPackage setObject:@"4wz9ajxejfih3ai" forKey:@"api_key"];
    [requestPackage setObject:@"101010101010101" forKey:@"device_id"];
    [requestPackage setObject:fieldsJSONString forKey:@"fields"];
    [requestPackage setObject:timestamp forKey:@"timestamp"];
    [requestPackage setObject:[API getHash:hashString] forKey:@"hash"];
   
    
    NSString *postString = [API getURLEncodedStringForPost:requestPackage];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding];
    
    API.handlePostBlock = ^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"CALL BACK");
        if ([data length] > 0 && error == nil) {
            
            NSString *myData = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
            NSLog(@"%@", myData);
        }

    };
    
    [API sendPost:postData toURL:URL];
    
}

-(void) handleResponse:(NSURLResponse *) response withData:(NSData *) data withError:(NSError *) error
{
    
}

@end
