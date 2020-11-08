//
//  ShareViewController.h
//  Open in Chrome Extension
//
//  Created by Fernando Urbina on 1/12/17.
//  Copyright © 2017 Razz Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ShareViewController : NSViewController

@property (nonatomic, strong)               NSURL *          url;
@property (strong)              IBOutlet    NSTextField *   urlField;
@property (strong) IBOutlet NSButtonCell *sendButton;

@end
