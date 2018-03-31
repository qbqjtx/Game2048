//
//  Game.m
//  Tile2048
//
//  Created by Adr!anoob on 5/20/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import "Game.h"
@interface Game()
@property (nonatomic) BOOL changed;
//if changed, then produced a new tile.

- (NSInteger)originValueAtX:(NSInteger)x Y:(NSInteger)y;
- (NSInteger)destinationValueAtX:(NSInteger)x Y:(NSInteger)y;
- (int)stateOfDestinationAtX:(NSUInteger)x Y:(NSUInteger)y;

- (void)wannaMoveRightward;
- (void)wannaMoveLeftward;
- (void)wannaMoveUpward;
- (void)wannaMoveDownward;
- (Game *)duplicateSelf;
@end
@implementation Game


# pragma mark - Initialzation

- (instancetype)initWithSize:(NSInteger)size {
    self = [super init];
    if (self) {
        _tile = [[NSMutableArray alloc] init];
        _size = size;
        //at first, there are two tiles
        _changed = YES;
        _score = 0;
        [self produceARandomTile];
        [self produceARandomTile];
        _end = NO;
    }
    return self;
}

# pragma mark - Process
// 1. wannaMove towards a direction && combine
// 1 only schedule the movements
// 2. animation according to destination
// 3. merge
// 4. ?end. if not, then produce another tile randomly
// 5. animation for new produced tile

- (void)wannaMoveTowards:(NSString *)direction {
    if ([direction isEqualToString:@"upwards"]) {
        [self wannaMoveUpward];
    }
    else if ([direction isEqualToString:@"downwards"]) {
        [self wannaMoveDownward];
    }
    else if ([direction isEqualToString:@"leftwards"]) {
        [self wannaMoveLeftward];
    }
    else if ([direction isEqualToString:@"rightwards"]) {
        [self wannaMoveRightward];
    }
}

//only produce new tile when tiles have changed | _changed
#define POSSIBILITY_OF_TWO 10
#define POSSIBILITY_OF_FOUR 1//ratio
- (void)produceARandomTile {
    if (_changed) {
        int emptySlots = (int)(_size * _size - [_tile count]);
        for (Tile *tile in _tile) {
            if (tile.newValue == 0) {
                emptySlots++;
            }
        }
        if (emptySlots) {//
            NSInteger random = arc4random() % emptySlots;
            for (int i=0; i<_size; i++) {
                for (int j=0; j<_size; j++) {
                    if ([self destinationValueAtX:i Y:j]==0) {
                        if (random == 0) {
                            Tile *newTile = [[Tile alloc] initWithOriginOfX:i Y:j];
                            newTile.state = 1;
                            if (![_tile count]) {
                                newTile.value = 2;
                                newTile.newValue = newTile.value;
                            }
                            else {
                                int temp =(arc4random() % (POSSIBILITY_OF_TWO + POSSIBILITY_OF_FOUR))/POSSIBILITY_OF_TWO;
                                newTile.value = 2 + 2 * temp;
                                newTile.newValue = newTile.value;
                            }
                            [_tile addObject:newTile];
                            random--;
                            break;
                        }
                        else {
                            random--;
                        }
                    }
                }
                if (random < 0) {
                    break;
                }
            }
        }
    }
}

//only merge when tiles have changed | _changed
- (void)merge {
    _changed = NO;
    for (Tile *tile in _tile) {
        if ((tile.origin.x!=tile.destination.x)||(tile.origin.y!=tile.destination.y)) {
            _changed = YES;
            break;
        }
    }
    if (_changed) {
        NSMutableArray *new = [[NSMutableArray alloc] init];
        for (Tile *tile in _tile) {
            if (tile.state != -2) {
                tile.origin = tile.destination;
                tile.value = tile.newValue;
                tile.state = 0;
                [new addObject:tile];
            }
            else {
                self.score += tile.newValue;
            }
        }
        [_tile setArray:new];
    }
}

// end is called after merge
// this "end" can be replaced using better algorithm. This programmer is too lazy though

- (BOOL)end {
    _end = NO;
    if ([_tile count] == _size * _size) {
        _end = YES;
        Game *copy = [self duplicateSelf];
        [copy wannaMoveUpward];
        [copy merge];
        if ([copy.tile count] != [self.tile count]) {
            _end = NO;
        }
        else {
            copy = [self duplicateSelf];
            [copy wannaMoveDownward];
            [copy merge];
            if ([copy.tile count] != [self.tile count]) {
                _end = NO;
            }
            else {
                copy = [self duplicateSelf];
                [copy wannaMoveLeftward];
                [copy merge];
                if ([copy.tile count] != [self.tile count]) {
                    _end = NO;
                }
                else {
                    copy = [self duplicateSelf];
                    [copy wannaMoveRightward];
                    [copy merge];
                    if ([copy.tile count] != [self.tile count]) {
                        _end = NO;
                    }
                }
            }
        }
    }
    return _end;
}

# pragma mark - Move/Combine Helper Methods
- (void)wannaMoveUpward {
    for (int x = 0; x < _size; x++) {
        NSMutableArray *aColumn = [[NSMutableArray alloc] init];
        for (int y = 0; y < _size; y++) {
            if ([self originValueAtX:x Y:y] != 0) {
                for (Tile *tile in _tile) {
                    if (tile.origin.x == x && tile.origin.y == y) {
                        tile.state = 0;
                        [aColumn addObject:tile];
                    }
                }
            }
        }
        //found aColumn
        //now sort the aColumn
        Tile *temp1;
        Tile *temp2;
        if ([aColumn count] == 1) {
            temp1 = [aColumn firstObject];
            temp1.destination = CGPointMake(x, 0);
        }
        else if ([aColumn count] > 1) {
            Tile *temp0 = [aColumn firstObject];
            temp0.destination = CGPointMake(x, 0);
            for (int i = 1; i < [aColumn count]; i++) {
                temp1 = [aColumn objectAtIndex:i-1];
                temp2 = [aColumn objectAtIndex:i];
                if (temp1.value == temp2.value) {
                    temp2.destination = temp1.destination;
                    temp1.newValue = temp1.value * 2;
                    temp2.newValue = temp1.newValue;
                    temp1.state = -1;
                    temp2.state = -2;
                    i++;
                    if (i < [aColumn count]) {
                        Tile *tileAfter = [aColumn objectAtIndex:i];
                        tileAfter.destination = CGPointMake(x, temp2.destination.y+1);
                    }
                }
                else {
                    temp2.destination = CGPointMake(x, temp1.destination.y+1);
                }
            }
        }
    }
}

- (void)wannaMoveDownward {
    for (int x = 0; x < _size; x++) {
        NSMutableArray *aColumn = [[NSMutableArray alloc] init];
        for (int y = (int)_size - 1; y >= 0; y--) {
            if ([self originValueAtX:x Y:y] != 0) {
                for (Tile *tile in _tile) {
                    if (tile.origin.x == x && tile.origin.y == y) {
                        tile.state = 0;
                        [aColumn addObject:tile];
                    }
                }
            }
        }
        //found aColumn
        //now sort the aColumn
        if ([aColumn count] == 1) {
            Tile *temp = [aColumn firstObject];
            temp.destination = CGPointMake(x, _size-1);
        }
        else if ([aColumn count] > 1) {
            Tile *temp0 = [aColumn firstObject];
            temp0.destination = CGPointMake(x, _size-1);
            for (int i = 1; i < [aColumn count]; i++) {
                Tile *temp1 = [aColumn objectAtIndex:i-1];
                Tile *temp2 = [aColumn objectAtIndex:i];
                if (temp1.value == temp2.value) {
                    temp2.destination = temp1.destination;
                    temp1.newValue = temp1.value * 2;
                    temp2.newValue = temp1.newValue;
                    temp1.state = -1;
                    temp2.state = -2;
                    i++;
                    if (i < [aColumn count]) {
                        Tile *tileAfter = [aColumn objectAtIndex:i];
                        tileAfter.destination = CGPointMake(x, temp2.destination.y-1);
                    }
                }
                else {
                    temp2.destination = CGPointMake(x, temp1.destination.y-1);
                }
            }
        }
    }
}

- (void)wannaMoveLeftward {
    for (int y = 0; y < _size; y++) {
        NSMutableArray *aRow = [[NSMutableArray alloc] init];
        for (int x = 0; x < _size; x++) {
            if ([self originValueAtX:x Y:y] != 0) {
                for (Tile *tile in _tile) {
                    if (tile.origin.x == x && tile.origin.y == y) {
                        tile.state = 0;
                        [aRow addObject:tile];
                    }
                }
            }
        }
        //found aRow
        //now sort the aRow
        if ([aRow count] == 1) {
            Tile *temp = [aRow firstObject];
            temp.destination = CGPointMake(0, y);
        }
        else if ([aRow count] > 1) {
            Tile *temp0 = [aRow firstObject];
            temp0.destination = CGPointMake(0, y);
            for (int i = 1; i < [aRow count]; i++) {
                Tile *temp1 = [aRow objectAtIndex:i-1];
                Tile *temp2 = [aRow objectAtIndex:i];
                if (temp1.value == temp2.value) {
                    temp2.destination = temp1.destination;
                    temp1.newValue = temp1.value * 2;
                    temp2.newValue = temp1.newValue;
                    temp1.state = -1;
                    temp2.state = -2;
                    i++;
                    if (i < [aRow count]) {
                        Tile *tileAfter = [aRow objectAtIndex:i];
                        tileAfter.destination = CGPointMake(temp2.destination.x+1, y);
                    }
                }
                else {
                    temp2.destination = CGPointMake(temp1.destination.x+1, y);
                }
            }
        }
    }
}

- (void)wannaMoveRightward {
    for (int y = 0; y < _size; y++) {
        NSMutableArray *aRow = [[NSMutableArray alloc] init];
        for (int x = (int)_size - 1; x >= 0; x--) {
            if ([self originValueAtX:x Y:y] != 0) {
                for (Tile *tile in _tile) {
                    if (tile.origin.x == x && tile.origin.y == y) {
                        tile.state = 0;
                        [aRow addObject:tile];
                    }
                }
            }
        }
        //found aRow
        //now sort the aRow
        if ([aRow count] == 1) {
            Tile *temp = [aRow firstObject];
            temp.destination = CGPointMake(_size-1, y);
        }
        else if ([aRow count] > 1) {
            Tile *temp0 = [aRow firstObject];
            temp0.destination = CGPointMake(_size-1, y);
            for (int i = 1; i < [aRow count]; i++) {
                Tile *temp1 = [aRow objectAtIndex:i-1];
                Tile *temp2 = [aRow objectAtIndex:i];
                if (temp1.value == temp2.value) {
                    temp2.destination = temp1.destination;
                    temp1.newValue = temp1.value * 2;
                    temp2.newValue = temp1.newValue;
                    temp1.state = -1;
                    temp2.state = -2;
                    i++;
                    if (i < [aRow count]) {
                        Tile *tileAfter = [aRow objectAtIndex:i];
                        tileAfter.destination = CGPointMake(temp2.destination.x-1, y);
                    }
                }
                else {
                    temp2.destination = CGPointMake(temp1.destination.x-1, y);
                }
            }
        }
    }
}

# pragma mark - Helper Show Functions

- (NSInteger)originValueAtX:(NSInteger)x Y:(NSInteger)y {
    NSInteger v = 0;
    for (Tile *t in _tile) {
        if (t.origin.x == x && t.origin.y==y) {
            v = t.value;
            break;
        }
    }
    return v;
}

- (NSInteger)destinationValueAtX:(NSInteger)x Y:(NSInteger)y {
    NSInteger v = 0;
    for (Tile *t in _tile) {
        if (t.destination.x == x && t.destination.y==y) {
            v = t.newValue;
            break;
        }
    }
    return v;
}

- (int)stateOfDestinationAtX:(NSUInteger)x Y:(NSUInteger)y {
    int sta = 3;
    for (Tile *tile in _tile) {
        if (tile.destination.x == x && tile.destination.y == y) {
            sta = tile.state;
            break;
        }
    }
    return sta;
}

- (Game *)duplicateSelf {
    Game *new = [[Game alloc] initWithSize:self.size];
    [new.tile removeAllObjects];
    for (Tile *t in self.tile) {
        [new.tile addObject:[t duplicateSelf]];
    }
    new.score = self.score;
    new.end = NO;
    return new;
}

/* testing methods
- (void)showOrigin {
    for (int i=0; i<_size; i++) {
        for (int j=0; j<_size; j++) {
            int v = (int)[self originValueAtX:j Y:i];
            if (v==0) {
                printf("   ");
            }
            else {
                printf("% 3ld",(long)v);
            }
        }
        printf("\n");
    }
    printf("\n");
}

- (void)showDestination {
    for (int i = 0; i < _size; i++) {
        for (int j = 0; j < _size; j++) {
            printf("% 3ld",(long)[self destinationValueAtX:j Y:i]);
        }
        printf("\n");
    }
    printf("\n");
}

- (void)showDestinationState {
    for (int i = 0; i < _size; i++) {
        for (int j = 0; j < _size; j++) {
            printf("% 3d",[self stateOfDestinationAtX:j Y:i]);
        }
        printf("\n");
    }
    printf("\n");
}

- (void)showTileArray {
    NSLog(@"array length = %lu",(long)[_tile count]);
    for (Tile *tile in _tile) {
        NSLog(@"origin: %d,%d -> destination: %d,%d |%lu %d",(int)tile.origin.x,(int)tile.origin.y,(int)tile.destination.x,(int)tile.destination.y,(unsigned long)tile.value,tile.state);
    }
}
 */

@end
