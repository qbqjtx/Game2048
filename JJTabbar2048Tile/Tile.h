//
//  Tile.h
//  Tile2048
//
//  Created by Adr!anoob on 5/20/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile : NSObject
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGPoint destination;
@property (nonatomic) NSUInteger value;
@property (nonatomic) NSUInteger newValue;
@property (nonatomic) int state;
//state is interface for Annimation
//state 1 = new, -1 = gonna combine, 0 = ordinary
//state 3 = empty tile
- (instancetype)initWithOriginOfX:(int)x Y:(int)y;
- (Tile *)duplicateSelf;
@end
