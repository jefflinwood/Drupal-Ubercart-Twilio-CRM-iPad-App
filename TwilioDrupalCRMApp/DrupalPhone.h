//
//  DrupalPhone.h
//  TwilioDrupalCRMApp
//
//  Created by Jeffrey Linwood on 3/19/12.
//  Copyright (c) 2012 Jeff Linwood. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCDevice.h"
#import "TCConnection.h"
#import "TCDeviceDelegate.h"

@interface DrupalPhone : NSObject 
@property (nonatomic, strong) TCDevice *device;
@property (nonatomic, strong) TCConnection *connection;

- (void) connect;
- (void) disconnect;
@end
