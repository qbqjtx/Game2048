//
//  View.m
//  Tile2048
//
//  Created by Adr!anoob on 5/23/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import "TilePanelView.h"
#import "SingleTileView.h"
#import "Game.h"
@interface TilePanelView()
@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) NSMutableArray *tileTemp;
@property (readwrite) NSUInteger score;


@property (nonatomic) CGFloat length;
@property (nonatomic) CGFloat margin;
@property (nonatomic) double ratio;
@property (nonatomic) CGFloat cornerRadius;

- (CGRect)rectAtCoordinateX:(int)x AndY:(int)y;
@end
@implementation TilePanelView
# pragma mark - Properties
#define LENGTH_RATIO 18
#define MARGIN_RATIO 3
#define CORNER_RADIUS_RATIO 1.5
#define PANEL_LENGTH 280
#define X 20
#define Y 160
- (double)ratio {
    double totalTheoreticalViewLength = LENGTH_RATIO * _size + MARGIN_RATIO * (_size + 1);
    double ratio = PANEL_LENGTH / totalTheoreticalViewLength;
    return ratio;
}
- (CGFloat)length {
    return LENGTH_RATIO * self.ratio;
}
- (CGFloat)margin {
    return MARGIN_RATIO * self.ratio;
}
- (CGFloat)cornerRadius {
    return CORNER_RADIUS_RATIO * self.ratio;
}
- (void)setSize:(int)size {
    _size = size;
    _game = [[Game alloc] initWithSize:size];
    [self setNeedsDisplay];
}
- (void)setDirection:(NSString *)direction {
    _direction = direction;
    [self setNeedsDisplay];
}
# pragma mark - Initialization

- (void)awakeFromNib {
    [self setup];
    _tileTemp = [[NSMutableArray alloc] init];
}
- (void)setup {
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (SingleTileView *t in _tileTemp) {
        [t removeFromSuperview];
    }
    [_tileTemp removeAllObjects];
    
    [self setupBackground];

    [self operateOnTiles];
}
- (void)setupBackground {
    UIImage *image = [UIImage imageNamed:@"backback"];
    [image drawInRect:self.bounds blendMode:kCGBlendModeNormal alpha:0.9];
    
    
    // draw panel
//    UIBezierPath *viewContour = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius: 1.5 * self.corderRadius];
//    [viewContour addClip];
//    UIImage *backgroundImage = [UIImage imageNamed:@"back"];
//    [backgroundImage drawInRect:self.bounds];
    [[self colorWithRed:205 Green:183 Blue:180] setStroke];
//    [viewContour stroke];
    
    for (int x = 0; x < _size; x++) {
        for (int y = 0; y < _size; y++) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[self rectAtCoordinateX:x AndY:y] cornerRadius:self.cornerRadius];
            [path stroke];
            //[[self colorWithRed:205 Green:183 Blue:180] setFill];
            //[path fillWithBlendMode:kCGBlendModeNormal alpha:0.4];
        }
    }
    UIBezierPath *contour = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(X, Y, PANEL_LENGTH, PANEL_LENGTH) cornerRadius:self.cornerRadius * 2];
    [contour stroke];
    
}
- (void)operateOnTiles {
    if (!_direction) {
        [self drawBeginning];
    }
    else {
        [_game wannaMoveTowards:_direction];
        [self drawMotion];
        [_game merge];
        [self updateScore];
        [_game produceARandomTile];
        [self drawNew];
        if (self.game.end) {
            [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.alpha = 0;} completion:nil];
        }
    }
}

- (void)updateScore {
    UIBezierPath *label = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 100, 280, 50) cornerRadius:4];
    [[UIColor blueColor] setFill];
    [label fill];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.score = self.game.score;
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"score:%lu",(unsigned long)self.score] attributes:@{NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    CGRect rec;
    rec.size = [text size];
    rec.origin.x = (label.bounds.size.width - rec.size.width) / 2 + label.bounds.origin.x;
    rec.origin.y = (label.bounds.size.height - rec.size.height) / 2 + label.bounds.origin.y;
    
    [text drawInRect:rec];
}

# pragma mark - Sub Methods
- (void)drawBeginning {
    [self updateScore];
    for (Tile *ti in _game.tile) {
        CGRect cgr = [self rectAtCoordinateX:ti.origin.x AndY:ti.origin.y];
        if (ti.state == 1) {
            CGRect cgr0 = CGRectMake(cgr.origin.x + cgr.size.width / 2,
                                     cgr.origin.y + cgr.size.height / 2,
                                     0,0);
            SingleTileView *v = [[SingleTileView alloc] initWithFrame:cgr0 Value:ti.value CornerRadius:self.cornerRadius];
            [self addSubview:v];
            [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{v.frame = cgr;} completion:nil];
            [_tileTemp addObject:v];
        }
        else {
            SingleTileView *v = [[SingleTileView alloc] initWithFrame:cgr Value:ti.value CornerRadius:self.cornerRadius];
            [self addSubview:v];
            [_tileTemp addObject:v];
        }
    }
}
- (void)drawMotion {
    NSMutableArray *bomb = [[NSMutableArray alloc] init];
    for (Tile *ti in _game.tile) {
        if (ti.state < 0) {
            [bomb addObject:ti];
        }
        else {
            CGRect cgr0 = [self rectAtCoordinateX:ti.origin.x AndY:ti.origin.y];
            CGRect cgr1 = [self rectAtCoordinateX:ti.destination.x AndY:ti.destination.y];
            SingleTileView *v = [[SingleTileView alloc] initWithFrame:cgr0 Value:ti.value CornerRadius:self.cornerRadius];
            [self addSubview:v];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{v.frame = cgr1;} completion:nil];
            [_tileTemp addObject:v];
        }
    }
    for (Tile *ti in bomb) {
        CGRect cgr0 = [self rectAtCoordinateX:ti.origin.x AndY:ti.origin.y];
        CGRect cgr1 = [self rectAtCoordinateX:ti.destination.x AndY:ti.destination.y];
        SingleTileView *v = [[SingleTileView alloc] initWithFrame:cgr0 Value:ti.value CornerRadius:self.cornerRadius];
        [self addSubview:v];
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{v.frame = cgr1;}
                         completion:^(BOOL finished){v.value *= 2;}];
        [_tileTemp addObject:v];
    }
}
- (void)drawNew {
    for (Tile *ti in _game.tile) {
        if (ti.state == 1) {
            CGRect cgr = [self rectAtCoordinateX:ti.origin.x AndY:ti.origin.y];
            CGRect cgr0 = CGRectMake(cgr.origin.x + cgr.size.width / 2,
                                     cgr.origin.y + cgr.size.height / 2,
                                     0,0);
            SingleTileView *v = [[SingleTileView alloc] initWithFrame:cgr0 Value:ti.value CornerRadius:self.cornerRadius];
            [self addSubview:v];
            [UIView animateWithDuration:0.2 delay:0.15 options:UIViewAnimationOptionBeginFromCurrentState animations:^{v.frame = cgr;} completion:nil];
            [_tileTemp addObject:v];
        }
    }
}
- (CGRect)rectAtCoordinateX:(int)x AndY:(int)y {
    double originX = self.margin * (x + 1) + self.length * x + X;
    double originY = self.margin * (y + 1) + self.length * y + Y;
    return CGRectMake(originX, originY,self.length,self.length);
}
- (UIColor *)colorWithRed:(double)r Green:(double)g Blue:(double)b {
    return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1];
}

@end
