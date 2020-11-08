//
//  ShareViewController.m
//  Open in Chrome Extension
//
//  Created by Fernando Urbina on 1/12/17.
//  Copyright © 2017 Razz Software. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize url;

- (NSString *)nibName
{
    return @"ShareViewController";
}

- (void)loadView
{
    [super loadView];
    
    NSExtensionContext *myExtensionContext = self.extensionContext;
    NSArray *inputItems = myExtensionContext.inputItems;
    
    for (NSExtensionItem *item in inputItems)
    {
        NSArray * attachments = item.attachments;
        
        // If we don't have any attachments, then we should look to see if we just have some
        // attributed text that contains the link
        if ([attachments count] > 0)
        {
            for (NSItemProvider *itemProvider in attachments)
            {
                if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL])
                {
                    [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *theURL, NSError *error)
                    {
                        // Save the URL and update the UI.  Create a tooltip with the full URL string, in case it gets truncated in the UI
                        self.url = theURL;
                        self.urlField.stringValue = self->url.absoluteString;
                        self.urlField.toolTip = self->url.absoluteString;
                        self.urlField.selectable = YES;
                    }];
                }
            }
        }
        else
        {
            // See if there is an attributed string and if so, look for a NSLink
            NSAttributedString * attrString = item.attributedContentText;
            if ( attrString != nil)
            {
                NSRange range = NSMakeRange(0, [attrString length]);
                NSDictionary *attributesDictionary = [attrString attributesAtIndex:0 effectiveRange:&range];
                self.url = [attributesDictionary objectForKey:NSLinkAttributeName];
            }
            
            if (self.url != nil)
            {
                self.urlField.stringValue = self.url.absoluteString;
                self.urlField.toolTip = self.url.absoluteString;
                self.urlField.selectable = YES;
           }
            else
            {
                _sendButton.enabled = NO;
            }
        }
    }
}


- (IBAction)send:(id)sender
{
    NSExtensionItem *outputItem = [[NSExtensionItem alloc] init];

    // Get the URL and open it with Chrome
    NSString * CHROME_IDENTIFIER = @"com.google.Chrome";
    NSArray *urls = [NSArray arrayWithObjects:self.url, nil];
    [[NSWorkspace sharedWorkspace] openURLs:urls withAppBundleIdentifier:CHROME_IDENTIFIER options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifiers:nil];

    NSArray *outputItems = @[outputItem];
    [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
}


- (IBAction)cancel:(id)sender
{
    NSError *cancelError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
    [self.extensionContext cancelRequestWithError:cancelError];
}

@end

