//
//  LNKAPI.m
//  Link
//
//  Created by David Zilli on 8/18/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKAPI.h"
#import <CommonCrypto/CommonDigest.h>

NSString *API_ENDPOINT = @"http://54.235.245.3/";
NSString *URI_GET_STATIONS = @"api/get_station_locations";
NSString *URI_GET_SYSTEMS = @"api/fetch_systems";

@implementation LNKAPI

- (NSString*)getHash:(NSString *)password{
    const char* str = [password UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
        result[i] = 0;
    }
    return ret;
}

- (NSData *)createPostData:(NSString *)fieldsJSON
{
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSMutableString *hashString = [[NSMutableString alloc] init];
    [hashString appendString:@"2f3j2jvbqpmgx6q"];
    [hashString appendString:@"4wz9ajxejfih3ai"];
    [hashString appendString:timestamp];

    
    NSMutableDictionary *requestPackage = [[NSMutableDictionary alloc] init];
    [requestPackage setObject:@"4wz9ajxejfih3ai" forKey:@"api_key"];
    [requestPackage setObject:@"101010101010101" forKey:@"device_id"];
    [requestPackage setObject:fieldsJSON forKey:@"fields"];
    [requestPackage setObject:timestamp forKey:@"timestamp"];
    [requestPackage setObject:[self getHash:hashString] forKey:@"hash"];
    NSString *postString = [self getURLEncodedStringForPost:requestPackage];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding];
    
    return postData;
}

- (NSString *)getURLEncodedStringForPost:(NSDictionary *)dictionary_
{
    NSString *postString = [NSString stringWithFormat:@"&api_key=%@&device_id=%@&fields=%@&timestamp=%@&hash=%@", [dictionary_ objectForKey:@"api_key"], [dictionary_ objectForKey:@"device_id"], [dictionary_ objectForKey:@"fields"], [dictionary_ objectForKey:@"timestamp"], [dictionary_ objectForKey:@"hash"]];
    
    return postString;
}

- (void)sendPost:(NSData *)data toURL:(NSString *)url;
{

    NSMutableString *uri_string = [[NSMutableString alloc] init];
    [uri_string appendString:API_ENDPOINT];
    [uri_string appendString:url];
    NSLog(uri_string);
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[data length]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri_string]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:data];
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[urlRequest HTTPBody] encoding:NSUTF8StringEncoding]);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:self.handlePostBlock];
    
}

@end
