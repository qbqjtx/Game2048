//
//  View.h
//  Tile2048
//
//  Created by Adr!anoob on 5/23/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TilePanelView : UIView
@property (nonatomic) int size;
@property (strong, nonatomic) NSString *direction;
@property (readonly) NSUInteger score;

@end
