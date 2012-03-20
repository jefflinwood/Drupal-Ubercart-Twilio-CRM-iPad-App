//
//  AppHelper.m
//  TwilioDrupalCRMApp
//
//  Created by Jeffrey Linwood on 3/19/12.
//  Copyright (c) 2012 Jeff Linwood. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

+ (NSString*) extractDrupalFieldValue:(NSDictionary*) node fieldName:(NSString*)fieldName fieldAttr:(NSString*)fieldAttr{
    id field = [node objectForKey:fieldName];
    if ([field isKindOfClass:[NSArray class]] && [field count] > 0) {
        
        id item = [field objectAtIndex:0];
        if ([item isKindOfClass:[NSDictionary class]]) {
            id obj = [item objectForKey:fieldAttr];
            if ([obj isKindOfClass:[NSNull class]]) {
                return nil;
            } else {
                return obj;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+ (NSString*) stateNameForZone:(NSString*)zone {
   NSDictionary* zones = [[NSDictionary alloc] initWithObjectsAndKeys:
    @"Texas",@"57", nil];
    return [zones objectForKey:zone];
}

@end
