//
//  AppDelegate.h
//  easyInstagram
//
//  Created by Baijian Chen on 2015-06-29.
//  Copyright (c) 2015 Baijian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Download Data from url
+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

@end

