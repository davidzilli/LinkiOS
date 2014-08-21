//
//  LNKAPI.h
//  Link
//
//  Created by David Zilli on 8/18/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *URI_GET_STATIONS;
extern NSString *URI_GET_SYSTEMS;
extern NSString *URI_GET_STATION_AVAILABILITY;
extern NSString *API_ENDPOINT;

@interface LNKAPI : NSObject

// Completion block as a callback to the class which made the POST
@property (nonatomic, copy) void (^handlePostBlock)(NSURLResponse *response, NSData *data, NSError *error);

//API End Point URIs

- (NSString*) getHash:(NSString*) password;
- (NSData *)createPostData:(NSString *)fieldsJSON;
- (NSString *)getURLEncodedStringForPost:(NSDictionary *)dictionary_;
- (void)sendPost:(NSData *)data toURL:(NSString *)url;
- (id) deserializeData:(NSData *)data;
- (BOOL) checkResponseIsValid:(id)data;
-(id)getResponseObject:(id)data;

@end
