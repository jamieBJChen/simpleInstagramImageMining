//
//  ViewController.m
//  easyInstagram
//
//  Created by Baijian Chen on 2015-06-29.
//  Copyright (c) 2015 Baijian Chen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSString *getUserIDUrlFirst;
    NSString *getUserIDUrlSecond;
    NSString *getUserIDUrlThird;
    
    NSString *getImageUrlFirst;
    NSString *getImageUrlSecond;
    NSString *getImageUrlThird;
    NSString *getImageUrlFourth;
    
    NSString *userSelected;
    
    NSMutableArray *allUserName;
    NSMutableArray *allUserPImage;
    NSMutableArray *allUserID;
    NSMutableArray *recentImage;
    NSMutableDictionary *dataDict;
    
    BOOL isCellClicked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    getUserIDUrlFirst = @"https://api.instagram.com/v1/users/search?q=";
    getUserIDUrlSecond = @"";
    getUserIDUrlThird = @"&access_token=14966305.b7a048a.07ecacdd87cf42e68c7955683728b7e2";
    
    getImageUrlFirst = @"https://api.instagram.com/v1/users/";
    getImageUrlSecond = @"";
    getImageUrlThird = @"/media/recent/?access_token=14966305.b7a048a.07ecacdd87cf42e68c7955683728b7e2&min_timestamp=";
    getImageUrlFourth = @"";
    
    userSelected = @"";
    //[self getJson:[NSString stringWithFormat:@"%@%@%@", getImageUrlFirst, getImageUrlSecond, getImageUrlThird]];
    //[self getJson:[NSString stringWithFormat:@"%@%@%@", getUserIDUrlFirst, getUserIDUrlSecond, getUserIDUrlThird]];
    isCellClicked = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isCellClicked == false){
        return [allUserName count];
    }
    else {
        return [recentImage count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isCellClicked == false){
        return 44;
    }
    else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"imageTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    if (isCellClicked == false){
        if (indexPath.row < [allUserName count]){
            cell.textLabel.text = [allUserName objectAtIndex:indexPath.row];
        }
        else {
            NSLog(@"user name out of range");
        }
    
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            if (indexPath.row < [allUserPImage count]){
                NSURL *url = [NSURL URLWithString:[allUserPImage objectAtIndex:indexPath.row]];
                NSData *image = [[NSData alloc] initWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [UIImage imageWithData:image];
                    CGSize itemSize = CGSizeMake(32, 32);
                    UIGraphicsBeginImageContext(itemSize);
                    [cell.imageView.image drawInRect:CGRectMake(0, 0, 32, 32)];
                    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                });
            }
            else {
                NSLog(@"image out range");
            }
        });
    }
    else {
        cell.textLabel.text = @"Tap for larger image";
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            if (indexPath.row < [recentImage count]){
                NSURL *url = [NSURL URLWithString:[recentImage objectAtIndex:indexPath.row]];
                NSData *image = [[NSData alloc] initWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [UIImage imageWithData:image];
                    CGSize itemSize = CGSizeMake(32, 32);
                    UIGraphicsBeginImageContext(itemSize);
                    [cell.imageView.image drawInRect:CGRectMake(0, 0, 32, 32)];
                    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                });
            }
            else {
                NSLog(@"image out range");
            }
        });
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%lu", indexPath.row);
    NSInteger unixTime = [[NSDate date] timeIntervalSince1970];
    unixTime = unixTime - 172800;
    NSString *unixTimeStr = [NSString stringWithFormat:@"%lu", unixTime];
    NSLog(@"%@", unixTimeStr);
    NSLog(@"%lu", unixTime);
    if (isCellClicked == false){
        getImageUrlSecond = [allUserID objectAtIndex:indexPath.row];
        getImageUrlFourth = unixTimeStr;
        [self getImageJson:[NSString stringWithFormat:@"%@%@%@%@", getImageUrlFirst, getImageUrlSecond, getImageUrlThird, getImageUrlFourth]];
        userSelected = [allUserName objectAtIndex:indexPath.row];
    }
    else {
        NSLog(@"YES touch the images");
        UIAlertView *imageAlertView = [[UIAlertView alloc] initWithTitle:userSelected message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            NSURL *url = [NSURL URLWithString:[recentImage objectAtIndex:indexPath.row]];
            NSData *image = [[NSData alloc] initWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:image];
                CGSize itemSize = CGSizeMake(320, 300);
                UIGraphicsBeginImageContext(itemSize);
                [imageView.image drawInRect:CGRectMake(0, 0, 320, 300)];
                imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            });
        });
        
        //[imageAlertView addSubview:imageView];
        [imageAlertView setValue:imageView forKey:@"accessoryView"];
        [imageAlertView show];

    }
}

#pragma UISearchDisplayController Method
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    //NSLog(@"%@", searchString);
    //getUserIDUrlSecond = self.searchBar.text;
    //[self getJson:[NSString stringWithFormat:@"%@%@%@", getUserIDUrlFirst, getUserIDUrlSecond, getUserIDUrlThird]];
    return YES;
}

#pragma UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *str = searchBar.text;
    NSLog(@"%@", str);
    NSString *inputStringTest = searchBar.text;
    NSRange whiteSpaceRange = [inputStringTest rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location == NSNotFound){
        getUserIDUrlSecond = searchBar.text;
        [self getJson:[NSString stringWithFormat:@"%@%@%@", getUserIDUrlFirst, getUserIDUrlSecond, getUserIDUrlThird]];
        //[searchBar setShowsCancelButton:NO animated:YES];
        [self.searchBar resignFirstResponder];
        [self.imageTableView becomeFirstResponder];
        [self.view endEditing:YES];
        [self.searchBar performSelectorOnMainThread:@selector(resignFirstResponder) withObject:nil waitUntilDone:NO];
        self.searchBar.searchResultsButtonSelected = YES;
        //isCellClicked = false;
    }
    else {
        UIAlertView *stringErralertView = [[UIAlertView alloc] initWithTitle:@"Input Warning" message:@"No White Space" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [stringErralertView show];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"YES");
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma Helper Functions
- (void) getJson:(NSString*)searchUrl {
    NSString *URLString = searchUrl;
    NSURL *url = [NSURL URLWithString:URLString];
    
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil){
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil){
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                //NSLog(@"%@", returnedDict);
                //NSLog(@"%@", returnedDict[@"meta"][@"code"]);
                NSInteger httpCode = [returnedDict[@"meta"][@"code"] integerValue];
                NSInteger dataCount = [returnedDict[@"data"] count];
                if (httpCode == 200){
                    NSLog(@"YES");
                    if (dataCount > 0){
                        NSLog(@"There are more than 1 person");
                        dataDict = returnedDict[@"data"];
                        //NSLog(@"%@", dataDict);
                        allUserName = [NSMutableArray new];
                        allUserPImage = [NSMutableArray new];
                        allUserID = [NSMutableArray new];
                        //NSLog(@"%lu", [allUserPImage count]);
                        int i;
                        for (i=0; i<dataCount; i++){
                            [allUserName addObject:returnedDict[@"data"][i][@"username"]];
                        }
                        //NSLog(@"%@", allUserName);
                        //NSLog(@"%lu", [allUserName count]);
                        for (i=0; i<dataCount; i++){
                            [allUserPImage addObject:returnedDict[@"data"][i][@"profile_picture"]];
                        }
                        for (i=0; i<dataCount; i++){
                            NSInteger userID = [returnedDict[@"data"][i][@"id"] integerValue];
                            NSString *userIDStr = [NSString stringWithFormat:@"%lu", userID];
                            [allUserID addObject:userIDStr];
                        }
                        NSLog(@"%@", allUserID);
                        //NSLog(@"%lu", [allUserPImage count]);
                        isCellClicked = false;
                        [self.imageTableView reloadData];
                        [self.imageTableView becomeFirstResponder];
                    }
                    else {
                        NSLog(@"NO RESULT");
                        UIAlertView *noResultalertView = [[UIAlertView alloc] initWithTitle:@"No Result" message:@"Please check the name and search again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [noResultalertView show];
                    }
                }
                else {
                    NSLog(@"The Http Code is not 200");
                    UIAlertView *netWorkErralertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [netWorkErralertView show];
                }
            }
        }
    }];
}

- (void) getImageJson:(NSString*)searchUrl {
    NSString *URLString = searchUrl;
    NSURL *url = [NSURL URLWithString:URLString];
    
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil){
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil){
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSLog(@"%@", returnedDict);
                NSInteger httpCode = [returnedDict[@"meta"][@"code"] integerValue];
                NSInteger dataCount = [returnedDict[@"data"] count];
                if (httpCode == 200){
                    NSLog(@"YES");
                    if (dataCount > 0){
                        NSLog(@"has data");
                        recentImage = [NSMutableArray new];
                        int i;
                        for (i=0; i<dataCount; i++){
                            NSString *isImage = returnedDict[@"data"][i][@"type"];
                            NSLog(@"%@", isImage);
                            if ([isImage isEqual:@"image"]){
                                [recentImage addObject:returnedDict[@"data"][i][@"images"][@"standard_resolution"][@"url"]];
                            }
                        }
                        NSLog(@"%@", recentImage);
                        
                        //[imageAlertView show];
                        if ([recentImage count] != 0){
                            isCellClicked = true;
                        }
                        else {
                            UIAlertView *noImageResultalertView = [[UIAlertView alloc] initWithTitle:@"No Image Result" message:@"The user has no recent images posted at last 2 days" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [noImageResultalertView show];
                        }
                        [self.imageTableView reloadData];
                    }
                    else {
                        NSLog(@"NO IMAGE POST AT LAST 2 DAYS");
                        UIAlertView *noResultalertView = [[UIAlertView alloc] initWithTitle:@"No Result" message:@"The user has no recent images posted at last 2 days" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [noResultalertView show];
                    }
                }
                else {
                    NSLog(@"The Http Code is not 200");
                    UIAlertView *netWorkErralertView = [[UIAlertView alloc] initWithTitle:@"Privacy" message:@"Not all to access the user's image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [netWorkErralertView show];
                }
            }
        }
    }];
}

@end
