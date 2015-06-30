//
//  ViewController.h
//  easyInstagram
//
//  Created by Baijian Chen on 2015-06-29.
//  Copyright (c) 2015 Baijian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *imageTableView;
@property (strong, nonatomic) IBOutlet UITableView *imageAlertTableView;

- (void) getJson:(NSString*)searchUrl;
- (void) getImageJson:(NSString*)searchUrl;

@end

