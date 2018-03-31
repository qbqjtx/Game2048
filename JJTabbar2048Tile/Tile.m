//
//  Tile.m
//  Tile2048
//
//  Created by Adr!anoob on 5/20/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import "Tile.h"

@implementation Tile

- (instancetype)initWithOriginOfX:(int)x Y:(int)y {
    self = [super init];
    if (self) {
        _value = 0;
        _newValue = self.value;
        _origin.x = x;
        _origin.y = y;
        _destination = self.origin;
        _state = 0;
    }
    return self;
}

- (Tile *)duplicateSelf {
    Tile *nu = [[Tile alloc] init];
    nu.origin = self.origin;
    nu.destination = self.destination;
    nu.value = self.value;
    nu.newValue = self.newValue;
    nu.state = self.state;
    return nu;
}
@end
