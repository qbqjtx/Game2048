//
//  TileView.h
//  Tile2048
//
//  Created by Adr!anoob on 5/25/14.
//  Copyright (c) 2014 ForMyLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTileView : UIView
@property (nonatomic) NSUInteger value;
@property (nonatomic) CGFloat cornerRadius;

- (id)initWithFrame:(CGRect)frame Value:(NSUInteger)value CornerRadius:(CGFloat)radius;
@end
