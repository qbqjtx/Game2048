//
//  Game.h
//  Tile2048
//
//  Created by Adr!anoob on 5/20/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Game : NSObject
@property (strong, nonatomic) NSMutableArray *tile;
@property (nonatomic) NSUInteger size;
@property (nonatomic) BOOL end;
@property (nonatomic) NSUInteger score;
- (instancetype)initWithSize:(NSInteger)size;

// 1. wannaMove towards a direction && combine
// 1 only schedule the movements
// 2. animation according to destination
// 3. merge
// 4. ?end. if not, then produce another tile randomly
// 5. animation for new produced tile
- (void)wannaMoveTowards:(NSString *)direction;//upwards, downwards, leftwards, rightwards
- (void)produceARandomTile;

//merge after animation
- (void)merge;


//test helper
/* testing methods
- (void)showOrigin;
- (void)showDestination;
- (void)showDestinationState;
- (void)showTileArray;
 */
@end
