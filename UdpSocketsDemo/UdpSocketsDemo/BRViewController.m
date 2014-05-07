//
//  BRViewController.m
//  UdpSocketsDemo
//
//  Created by Eduardo Gutiérrez Silva on 07/05/14.
//  Copyright (c) 2014 Brachiosoft. All rights reserved.
//

#import "BRViewController.h"

@interface BRViewController ()

@end

@implementation BRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(id)sender {
    // Get IP Address
    NSString *ipAddrs = self.txtIpAddress.text;
    
    // Get Message
    NSString *message = self.txtMessage.text;
    
    // Our dialog.
    UIAlertView *alert;
    
    // DEST Address
    sockaddr_in *dest_addr = (sockaddr_in*)malloc(sizeof(sockaddr_in));
    if(dest_addr == NULL){
        // Message Box with error.
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error!"
                 message:@"Error creating dest_addr"
                 delegate:nil  // set nil if you don't want the yes button callback
                 cancelButtonTitle:@"Ok :("
                 otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // Init address
    memset(dest_addr, 0, sizeof(sockaddr_in));
    dest_addr->sin_family = AF_INET;
    
    // Get Source.
    
    // Load address.
    int pton_val = inet_pton(AF_INET, [ipAddrs UTF8String], &(dest_addr->sin_addr.s_addr));
    if(pton_val == 0){
        // Message Box with error.
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error!"
                 message:@"Invalid address"
                 delegate:nil  // set nil if you don't want the yes button callback
                 cancelButtonTitle:@"Ok :("
                 otherButtonTitles:nil, nil];
        [alert show];

    }else if(pton_val < 0){
        // Message Box with error.
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error!"
                 message:@"Error in pton"
                 delegate:nil  // set nil if you don't want the yes button callback
                 cancelButtonTitle:@"Ok :("
                 otherButtonTitles:nil, nil];
        [alert show];

    }
    // Setting port
    dest_addr->sin_port=htons(1514);
    
    // Create our socket.
    int sock_fd = socket(AF_INET, SOCK_DGRAM, UDP);
    
    // Error handling.
    if(sock_fd < 0){
        perror("socket");
        // Message Box with error.
        alert = [[UIAlertView alloc]
                              initWithTitle:@"Error!"
                              message:@"Socket could not be opened"
                              delegate:nil  // set nil if you don't want the yes button callback
                              cancelButtonTitle:@"Ok :("
                              otherButtonTitles:nil, nil];
        [alert show];
    }else{  // Our socket was opened
        // Get Message Data
        NSData *bytes = [message dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t * rawBytes = (uint8_t*)[bytes bytes];
        
        // Send our message.
        int error = sendto(sock_fd, rawBytes, [message length], 0, (struct sockaddr*)dest_addr, sizeof(sockaddr_in));
        if(error < 0){
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Error!"
                     message:@"Message could not be sent"
                     delegate:nil  // set nil if you don't want the yes button callback
                     cancelButtonTitle:@"Ok :("
                     otherButtonTitles:nil, nil];
            [alert show];
        }else{
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Success!"
                     message:@"Message sent!"
                     delegate:nil  // set nil if you don't want the yes button callback
                     cancelButtonTitle:@"Ok :)"
                     otherButtonTitles:nil, nil];
            [alert show];
            
            close(sock_fd);
        }
    }
}
@end
