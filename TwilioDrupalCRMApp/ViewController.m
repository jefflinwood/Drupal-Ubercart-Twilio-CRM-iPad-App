//
//  ViewController.m
//  TwilioDrupalCRMApp
//
//  Created by Jeffrey Linwood on 3/19/12.
//  Copyright (c) 2012 Jeff Linwood. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import "DrupalPhone.h"
#import "AppHelper.h"

#import "AFJSONRequestOperation.h"

#define WAITING_TEXT @"Waiting for call..."

@interface ViewController ()

@end

@implementation ViewController
@synthesize answerButton;
@synthesize hangupButton;
@synthesize phoneNumberLabel;
@synthesize nameLabel;
@synthesize orderCreatedLabel;
@synthesize orderStatusLabel;
@synthesize orderTotalLabel;
@synthesize shippingNameLabel;
@synthesize shippingAddress1Label;
@synthesize shippingCityStateLabel;
@synthesize shippingPhoneLabel;
@synthesize billingNameLabel;
@synthesize billingAddress1Label;
@synthesize billingCityStateLabel;
@synthesize billingPhoneLabel;
@synthesize productsTable;
@synthesize products = _products;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    NSDictionary *product = [self.products objectAtIndex:indexPath.row];
    cell.textLabel.text = [product objectForKey:@"title"];
    NSString *quantity = [product objectForKey:@"qty"];
    float price = [[product objectForKey:@"price"] floatValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencySymbol = @"$";
    formatter.maximumFractionDigits = 2;
    NSString *fmtPrice = [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ordered at %@",quantity,fmtPrice];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)device:(TCDevice*)device didReceiveIncomingConnection:(TCConnection*)connection
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    DrupalPhone *phone = appDelegate.phone;
    
    if ( phone.connection )
    {
        [phone disconnect];
    }
    phone.connection = connection;
    NSLog(@"Incoming parameters: %@",connection.parameters);
    //get the From:
    NSString *phoneNumber = [connection.parameters objectForKey:@"From"];
    self.phoneNumberLabel.text = phoneNumber;
    self.answerButton.enabled = TRUE;
    NSLog(@"Device got connection");
    [self loadOrderData:[self convertPhoneNumber:phoneNumber]];
}

- (NSString*) convertPhoneNumber:(NSString*)twilioPhoneNumber {
    NSString *areaCode = [twilioPhoneNumber substringWithRange:NSMakeRange(2, 3)];
    NSString *firstPart = [twilioPhoneNumber substringWithRange:NSMakeRange(5, 3)];
    NSString *secondPart = [twilioPhoneNumber substringWithRange:NSMakeRange(8, 4)];
    NSString *phone = [NSString stringWithFormat:@"%@-%@-%@",areaCode,firstPart,secondPart];
    NSLog(@"Ubercart compatible phone:%@",phone);
    return phone;
}

- (void) loadOrderProductsData:(NSString*)orderId {
    
    //load up some order products data
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dev.d6test.gotpantheon.com/twilioipadcrm/orderproductdata?orderId=%@",orderId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *orderProducts = (NSArray*) JSON;
        self.products = orderProducts;
        [self.productsTable reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error!");
    }];
    [operation start];
}

- (void) loadOrderData:(NSString*)phoneNumber {
    
    //load up some order data
    NSString *uri = [NSString stringWithFormat:@"http://dev.d6test.gotpantheon.com/twilioipadcrm/orderdata?phone=%@",phoneNumber];
    NSURL *url = [NSURL URLWithString:uri];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dict = (NSDictionary*) JSON;
        
        //load up the individual products ordered
        [self loadOrderProductsData:[dict objectForKey:@"order_id"]];
        
        
        NSString* deliveryFirstName = [dict objectForKey:@"delivery_first_name"];
        NSString* deliveryLastName = [dict objectForKey:@"delivery_last_name"];
        self.shippingNameLabel.text = [NSString stringWithFormat:@"%@ %@",deliveryFirstName,deliveryLastName];
        self.shippingAddress1Label.text = [dict objectForKey:@"delivery_street1"];
        NSString *deliveryCity = [dict objectForKey:@"delivery_city"];
        NSString *deliveryState = [AppHelper stateNameForZone:[dict objectForKey:@"delivery_zone"]];
        NSString *deliveryZip = [dict objectForKey:@"delivery_postal_code"];
        self.shippingCityStateLabel.text = [NSString stringWithFormat:@"%@, %@ %@",deliveryCity, deliveryState, deliveryZip];
        self.shippingPhoneLabel.text = [dict objectForKey:@"delivery_phone"];
        
        NSString* billingFirstName = [dict objectForKey:@"billing_first_name"];
        NSString* billingLastName = [dict objectForKey:@"billing_last_name"];
        self.billingNameLabel.text = [NSString stringWithFormat:@"%@ %@",billingFirstName,billingLastName];
        self.billingAddress1Label.text = [dict objectForKey:@"delivery_street1"];
        NSString *billingCity = [dict objectForKey:@"billing_city"];
        NSString *billingState = [AppHelper stateNameForZone:[dict objectForKey:@"billing_zone"]];
        NSString *billingZip = [dict objectForKey:@"billing_postal_code"];
        self.billingCityStateLabel.text = [NSString stringWithFormat:@"%@, %@ %@",billingCity, billingState, billingZip];
        self.billingPhoneLabel.text = [dict objectForKey:@"billing_phone"];
        
        self.orderStatusLabel.text = [dict objectForKey:@"order_status"];
        float orderTotal = [[dict objectForKey:@"order_total"] floatValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.currencySymbol = @"$";
        formatter.maximumFractionDigits = 2;
        self.orderTotalLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:orderTotal]];
        
        NSDate *orderCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created"] intValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.orderCreatedLabel.text = [dateFormatter stringFromDate:orderCreatedDate];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Order Products Error!");
    }];
    [operation start];
}

- (IBAction)answer:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    DrupalPhone *phone = appDelegate.phone;
    [phone.connection accept];
    self.answerButton.enabled = FALSE;
    self.hangupButton.enabled = TRUE;

}

- (IBAction)hangup:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    DrupalPhone *phone = appDelegate.phone;
    [phone.connection disconnect];
    self.answerButton.enabled = FALSE;
    self.hangupButton.enabled = FALSE;
    self.phoneNumberLabel.text = WAITING_TEXT;
    self.nameLabel.text = @"";
}

-(void)deviceDidStartListeningForIncomingConnections:(TCDevice*)device
{
    NSLog(@"Device is now listening for incoming connections");
}

-(void)device:(TCDevice*)device didStopListeningForIncomingConnections:(NSError*)error
{
    if ( !error )
    {
        NSLog(@"Device is no longer listening for incoming connections");
    }
    else
    {
        NSLog(@"Device no longer listening for incoming connections due to error: %@", [error localizedDescription]);
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.phoneNumberLabel.text = WAITING_TEXT;
}

- (void)viewDidUnload
{
    [self setPhoneNumberLabel:nil];
    [self setAnswerButton:nil];
    [self setHangupButton:nil];
    [self setNameLabel:nil];
    [self setOrderStatusLabel:nil];
    [self setOrderTotalLabel:nil];
    [self setShippingNameLabel:nil];
    [self setShippingAddress1Label:nil];
    [self setShippingCityStateLabel:nil];
    [self setShippingPhoneLabel:nil];
    [self setBillingNameLabel:nil];
    [self setBillingAddress1Label:nil];
    [self setBillingCityStateLabel:nil];
    [self setBillingPhoneLabel:nil];
    [self setProductsTable:nil];
    [self setOrderCreatedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
