//
//  LNKSystemsManager.m
//  Link
//
//  Created by David Zilli on 8/19/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKSystemsManager.h"
#import "LNKSystem.h"

@implementation LNKSystemsManager

@synthesize API;

/** Sync Systems with server */

-(void) sync
{
    API = [[LNKAPI alloc] init];

    NSData *postData = [API createPostData:[[NSString alloc] init]];
    
    API.handlePostBlock = ^(NSURLResponse *response, NSData *data, NSError *error){

        if ([data length] > 0 && error == nil) {
            
            id jsonData = [API deserializeData:data];
            
            if (!jsonData) {
                NSLog(@"ERROR DESERIALIZING");
                return;
            }
            
            if (![API checkResponseIsValid:jsonData]) {
                NSLog(@"INVALID RESPONSE FROM SERVER");
                return;
            }
            
            id responseObject = [API getResponseObject:jsonData];
            if (!responseObject) {
                NSLog(@"NO RESPONSE OBJECT");
                return;
            }
            
            NSArray *systems = [responseObject objectForKey:@"systems"];
            NSLog(@"Fetched %d system(s)", [systems count]);
            
            for (NSDictionary *system in systems) {
                
                NSNumber *id = [system objectForKey:@"id"];
                LNKSystem *new_system = [self getSystemForID:id];
                /** Try to fetch System with this ID. Update it if we find it,
                 else create a new object to insert */
                
                if (!new_system) {
                    /** Create a new object to insert*/
                    NSLog(@"Couldn't find object for ID:%@", id);
                    new_system = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LNKSystem class])
                                                                         inManagedObjectContext:[AppDelegate managedObjectContext]];
                    [new_system fillWithDictionary:system];
                } else {
                    NSLog(@"Found object for ID:%@", id);
                    /** Update and save the fetched object*/
                    [new_system fillWithDictionary:system];
                }
                
                [self syncStationsForSystem:new_system];
                
                NSError *error;
                if (![[AppDelegate managedObjectContext] save:&error]) {
                    NSLog(@"ERROR SAVING: %@", [error localizedDescription]);
                }
            }
        }
        
    };
    
    NSString *URL = URI_GET_SYSTEMS;
    [API sendPost:postData toURL:URL];
    
}

/** Sync Station info with serer */

-(void) syncStationsForSystem:(LNKSystem *)system_
{
    if(!system_) {
        NSLog(@"Sytem is null");
        return;
    }
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    API = [[LNKAPI alloc] init];
    
    /** Create fields JSON String */
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    NSError *error;
    NSNumber *system_id = system_.id;
    [fields setObject:system_id forKey:@"system_id"];
    NSData *fieldsJSON = [NSJSONSerialization dataWithJSONObject:fields options:0 error:&error];
    NSString *fieldsJSONString = [[NSString alloc] initWithData:fieldsJSON encoding:NSUTF8StringEncoding];
    
    NSData *postData = [API createPostData:fieldsJSONString];
    
    API.handlePostBlock = ^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"CALL BACK");
        if ([data length] > 0 && error == nil) {
            
            id jsonData = [API deserializeData:data];
            
            if (!jsonData) {
                NSLog(@"ERROR DESERIALIZING");
                return;
            }
            
            if (![API checkResponseIsValid:jsonData]) {
                NSLog(@"INVALID RESPONSE FROM SERVER");
                return;
            }
            
            id responseObject = [API getResponseObject:jsonData];
            if (!responseObject) {
                NSLog(@"NO RESPONSE OBJECT");
                return;
            }
                
            NSArray *stations = [responseObject objectForKey:@"stations"];
            NSLog(@"Fectched %d station(s)", [stations count]);
            
            for (NSDictionary *station in stations) {
                
                NSNumber *station_id = [numFormatter numberFromString:[station objectForKey:@"id"]];
                LNKStation *new_station = [self getStationForID:station_id fromSystem:system_];
                
                if (!new_station) {
                    /** Create new station and insert */
                    NSLog(@"Couldn't find station for ID:%@", station_id);
                    new_station = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LNKStation class])
                                                                inManagedObjectContext:[AppDelegate managedObjectContext]];
                    [new_station fillWithDictionary:station];
                    [system_ addStationsObject:new_station];
                } else {
                    NSLog(@"Found station for ID:%@", station_id);
                    [new_station fillWithDictionary:station];
                }
            }
            
            if (![[AppDelegate managedObjectContext] save:&error]) {
                NSLog(@"ERROR SAVING: %@", [error localizedDescription]);
            }
        }
    };
    
    NSString *URL = URI_GET_STATIONS;
    [API sendPost:postData toURL:URL];
}

-(NSArray *)fetchSystems
{
    NSLog(@"Fetching Systems from Core Data");
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([LNKSystem class])
                                              inManagedObjectContext:[AppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedSystems = [[AppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (LNKSystem *system in fetchedSystems) {
        NSLog(@"%@", [system description]);
        for (LNKStation *station in system.stations) {
            NSLog(@"%@", [station description]);
        }
    }

    return fetchedSystems;
}

-(LNKSystem *) getSystemForID:(NSNumber *)id_
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([LNKSystem class])
                                              inManagedObjectContext:[AppDelegate managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id == %@", id_]]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedSystems = [[AppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Found %d systems matching ID:%@", [fetchedSystems count], id_);
    if ([fetchedSystems count] == 0) {
        return nil;
    } else {
        return [fetchedSystems objectAtIndex:0];
    }
}

/** Returns the Set of Stations for a System object */
-(NSSet *)getStationsForSystem:(LNKSystem *)system_
{
    return [system_ stations];
}

/** Returns a Station object with the given ID from the given system, or nil
 if it can't be found. The list of stations for a system are return as a set,
 so we use a predicate to filter the set rather than iterate through it */
-(LNKStation *) getStationForID:(NSNumber *)id_ fromSystem:(LNKSystem *)system_
{
    NSSet *stations = [self getStationsForSystem:system_];
    
    if (!stations) {
        return nil;
    }
    
    NSPredicate *id_predicate = [NSPredicate predicateWithFormat:@"id == %@", id_];
    return [stations filteredSetUsingPredicate:id_predicate].anyObject;
}

@end
