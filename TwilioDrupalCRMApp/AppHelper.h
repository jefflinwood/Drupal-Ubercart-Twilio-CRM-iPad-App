//
//  AppHelper.h
//  TwilioDrupalCRMApp
//
//  Created by Jeffrey Linwood on 3/19/12.
//  Copyright (c) 2012 Jeff Linwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject
+ (NSString*) extractDrupalFieldValue:(NSDictionary*) node fieldName:(NSString*)fieldName fieldAttr:(NSString*)fieldAttr;
+ (NSString*) stateNameForZone:(NSString*)zone;
@end
