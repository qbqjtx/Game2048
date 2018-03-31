//
//  TileView.m
//  Tile2048
//
//  Created by Adr!anoob on 5/25/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import "SingleTileView.h"

@implementation SingleTileView

- (id)initWithFrame:(CGRect)frame Value:(NSUInteger)value CornerRadius:(CGFloat)radius{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.value = value;
        self.cornerRadius = radius;
    }
    return self;
}

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)setValue:(NSUInteger)value {
    _value = value;
    [self setNeedsDisplay];
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSString *str = [NSString stringWithFormat:@"%d",(int)self.value];
    UIImage *image = [UIImage imageNamed:str];
    UIBezierPath *contour = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [contour addClip];
    [image drawInRect:self.bounds];
}


@end
