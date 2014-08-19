//
//  LNKAPI.h
//  Link
//
//  Created by David Zilli on 8/18/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNKAPI : NSObject
- (NSString*) getHash:(NSString*) password;
- (NSString *)getURLEncodedStringForPost:(NSDictionary *)dictionary_;
- (void)sendPost:(NSData *)data toURL:(NSString *)url;

@property (nonatomic, copy) void (^handlePostBlock)(NSURLResponse *response, NSData *data, NSError *error);

@end
