//
//  BRViewController.h
//  UdpSocketsDemo
//
//  Created by Eduardo Gutiérrez Silva on 07/05/14.
//  Copyright (c) 2014 Brachiosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <errno.h>
#define UDP 17
typedef struct sockaddr_in sockaddr_in;

@interface BRViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtMessage;
@property (strong, nonatomic) IBOutlet UITextField *txtIpAddress;

- (IBAction)sendMessage:(id)sender;

@end
