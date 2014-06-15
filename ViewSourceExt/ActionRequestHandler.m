//
//  ActionRequestHandler.m
//  ViewSourceExt
//
//  Created by Dominic Dagradi on 6/14/14.
//  Copyright (c) 2014 ddagradi. All rights reserved.
//

#import "ActionRequestHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionRequestHandler ()

@property (nonatomic, strong) NSExtensionContext *extensionContext;

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
  self.extensionContext = context;
    
  [context.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem* item, NSUInteger idx, BOOL *stop) {
    [item.attachments enumerateObjectsUsingBlock:^(NSItemProvider* itemProvider, NSUInteger idx, BOOL *stop) {
      if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *dictionary, NSError *error) { }];
      }
    }];
  }];
    
  [self doneWithResults:nil];
}


- (void)doneWithResults:(NSDictionary *)resultsForJavaScriptFinalize {
  // Load static assets
  NSString *scriptPath      = [[NSBundle mainBundle] pathForResource:@"rainbow" ofType:@"js"];
  NSString *scriptContents  = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];

  NSString *themePath       = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"css"];
  NSString *themeContents   = [NSString stringWithContentsOfFile:themePath encoding:NSUTF8StringEncoding error:nil];
  
  resultsForJavaScriptFinalize = @{@"script": scriptContents, @"style": themeContents};
  NSDictionary *resultsDictionary = @{ NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize };

  NSItemProvider *resultsProvider = [[NSItemProvider alloc] initWithItem:resultsDictionary typeIdentifier:(NSString *)kUTTypePropertyList];

  NSExtensionItem *resultsItem = [[NSExtensionItem alloc] init];
  resultsItem.attachments = @[resultsProvider];

  // Signal that we're complete, passing contents of assets to JS
  [self.extensionContext completeRequestReturningItems:@[resultsItem] completionHandler:nil];

  // Don't hold on to this after we finished with it.
  self.extensionContext = nil;
}

@end
