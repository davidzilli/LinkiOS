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

-(void) sync
{
    API = [[LNKAPI alloc] init];

    NSData *postData = [API createPostData:[[NSString alloc] init]];
    
    API.handlePostBlock = ^(NSURLResponse *response, NSData *data, NSError *error){

        if ([data length] > 0 && error == nil) {
            
            NSError *error;
            id jsonObject = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:NSJSONReadingAllowFragments
                             error:&error];
            
            if (jsonObject != nil && error == nil) {
                NSLog(@"Succesfully deserialized");
                NSNumber *success = [jsonObject objectForKey:@"valid"];
                if ([success boolValue]) {
                    NSLog(@"SUCCESS!");
                } else {
                    NSLog(@"FAILURE!");
                    return;
                }
                // Pull out systems and init LNKSystem objects from dictionary (must implement)
                id responseObject = [jsonObject objectForKey:@"response"];
                
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
                        new_system = [NSEntityDescription insertNewObjectForEntityForName:@"LNKSystem"
                                                                             inManagedObjectContext:[AppDelegate managedObjectContext]];
                        [new_system fillWithDictionary:system];
                    } else {
                        NSLog(@"Found object for ID:%@", id);
                        /** Update and save the fetched object*/
                        [new_system fillWithDictionary:system];
                    }
                    
                }
                
                NSError *error;
                if (![[AppDelegate managedObjectContext] save:&error]) {
                    NSLog(@"ERROR SAVING: %@", [error localizedDescription]);
                }
                
                [self fetchSystems];
            }
        }
        
    };
    
    NSString *URL = URI_GET_SYSTEMS;
    [API sendPost:postData toURL:URL];
    
}

-(NSArray *)fetchSystems
{
    NSLog(@"Fetching Systems from Core Data");
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LNKSystem"
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
    NSLog(@"Found %lu systems matching ID:%@", [fetchedSystems count], id_);
    if ([fetchedSystems count] == 0) {
        return nil;
    } else {
        return [fetchedSystems objectAtIndex:0];
    }
}

@end
