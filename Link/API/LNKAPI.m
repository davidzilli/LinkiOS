//
//  LNKAPI.m
//  Link
//
//  Created by David Zilli on 8/18/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKAPI.h"
#import <CommonCrypto/CommonDigest.h>

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

- (NSString *)getURLEncodedStringForPost:(NSDictionary *)dictionary_
{
    NSString *postString = [NSString stringWithFormat:@"&api_key=%@&device_id=%@&fields=%@&timestamp=%@&hash=%@", [dictionary_ objectForKey:@"api_key"], [dictionary_ objectForKey:@"device_id"], [dictionary_ objectForKey:@"fields"], [dictionary_ objectForKey:@"timestamp"], [dictionary_ objectForKey:@"hash"]];
    
    return postString;
}

- (void)sendPost:(NSData *)data toURL:(NSString *)url;
{
    NSString *postLength = [NSString stringWithFormat:@"%d",[data length]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
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
