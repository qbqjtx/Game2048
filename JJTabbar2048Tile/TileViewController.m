//
//  TileViewController.m
//  Tile2048
//
//  Created by Adr!anoob on 5/21/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import "TileViewController.h"
#import "Game.h"
#import "Tile.h"
#import "TilePanelView.h"

@interface TileViewController ()

@property (strong, nonatomic) IBOutlet TilePanelView *view;
@property (strong, nonatomic) IBOutlet UINavigationItem *nagivationItem;


@end

@implementation TileViewController

- (void)setSize:(int)size {
    _size = size;
    _nagivationItem.title = [NSString stringWithFormat:@"%d x %d",size,size];
    self.view.size = size;
}

- (IBAction)swipeUp:(UISwipeGestureRecognizer *)sender {
    self.view.direction = @"upwards";
}
- (IBAction)swipeDown:(UISwipeGestureRecognizer *)sender {
    self.view.direction = @"downwards";
}
- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    self.view.direction = @"leftwards";
}
- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    self.view.direction = @"rightwards";
}

@end
