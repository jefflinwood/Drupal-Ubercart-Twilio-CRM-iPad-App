//
//  DrupalPhone.m
//  TwilioDrupalCRMApp
//
//  Created by Jeffrey Linwood on 3/19/12.
//  Copyright (c) 2012 Jeff Linwood. All rights reserved.
//

#import "DrupalPhone.h"
#import "AppDelegate.h"
#import "ViewController.h"


@implementation DrupalPhone
@synthesize device = _device;
@synthesize connection = _connection;


-(void)disconnect
{
    [self.connection disconnect];
    self.connection = nil;
}

-(void)connect
{
    self.connection = [self.device connect:nil delegate:nil];
}

-(id)init
{
    if ( self = [super init] )
    {
        NSURL* url = [NSURL URLWithString:@"http://dev.d6test.gotpantheon.com/twilioipadcrm/auth"];
        NSURLResponse* response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:
                        [NSURLRequest requestWithURL:url] 
                                             returningResponse:&response
                                                         error:&error];
        if (data)
        {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            
            if (httpResponse.statusCode == 200)
            {
                NSString* capabilityToken = 
                [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
                
                NSLog(@"Capability token: %@",capabilityToken);
                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                

                
                self.device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken
                                                           delegate:appDelegate.viewController];
            }
            else
            {
                NSString*  errorString = [NSString stringWithFormat:
                                          @"HTTP status code %d",                          
                                          httpResponse.statusCode];
                NSLog(@"Error logging in: %@", errorString);
            }
        }
        else
        {
            NSLog(@"Error logging in: %@", [error localizedDescription]);
        }
    }
    return self;
}
@end
