//
//  ViewController.h
//  TwilioDrupalCRMApp
//
//  Created by Jeffrey Linwood on 3/19/12.
//  Copyright (c) 2012 Jeff Linwood. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCDeviceDelegate.h"

@interface ViewController : UIViewController <TCDeviceDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *answerButton;
@property (strong, nonatomic) IBOutlet UIButton *hangupButton;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *orderCreatedLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingAddress1Label;
@property (strong, nonatomic) IBOutlet UILabel *shippingCityStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingPhoneLabel;

@property (strong, nonatomic) IBOutlet UILabel *billingNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *billingAddress1Label;
@property (strong, nonatomic) IBOutlet UILabel *billingCityStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *billingPhoneLabel;

@property (strong, nonatomic) IBOutlet UITableView *productsTable;

@property (strong, nonatomic) NSArray *products;


- (IBAction)answer:(id)sender;
- (IBAction)hangup:(id)sender;


-(void)deviceDidStartListeningForIncomingConnections:(TCDevice*)device;
-(void)device:(TCDevice*)device didStopListeningForIncomingConnections:(NSError*)error;
-(void)device:(TCDevice*)device didReceiveIncomingConnection:(TCConnection*)connection;


@end
