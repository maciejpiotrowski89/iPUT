//
//  MPBookViewController.m
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBookViewController.h"
#import "MPSynchronizationFacade.h"

@implementation MPBookViewController

#pragma mark - Instance methods

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [self loadBook];
}

- (void)loadBook {
    if (nil == self.book.filePath || [self.book.filePath isEqualToString:@""]) {
        [[MPSynchronizationFacade sharedInstance]fetchBlobFileForBlob:self.book];
        return;
    }
    NSURL *targetURL = [NSURL fileURLWithPath:self.book.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
}

- (void)synchronizationEnded:(NSNotification *)notification {
    [super synchronizationEnded:notification];
    [self performSelectorOnMainThread:@selector(loadBook) withObject:nil waitUntilDone:YES];
}

- (void)synchronizationFailed:(NSNotification *)notification {
    [super synchronizationFailed:notification];
    [MPUtils displayErrorAlertViewForMessage:@"Issues occured while downloading the file."];
}

@end
