//
//  MainMenuController.m
//  Tile2048
//
//  Created by Adr!anoob on 5/26/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import "MainMenuController.h"
#import "TileViewController.h"

@interface MainMenuController ()

@end

@implementation MainMenuController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *iden = segue.identifier;
    NSString *str = [iden substringToIndex:[iden length]-1];
    NSString *n = [iden substringFromIndex:[iden length]-1];
    int size = (int)[n integerValue];
    if ([str isEqualToString:@"size"]) {
        if ([segue.destinationViewController isKindOfClass:[TileViewController class]]) {
            TileViewController *tc = segue.destinationViewController;
            tc.size = size;
            tc.navigationController.title = [NSString stringWithFormat:@"%d x %d",size,size];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
