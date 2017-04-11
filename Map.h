//
//  Map.h
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 6/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Coord : NSObject
@property (nonatomic) int x;
@property (nonatomic) int y;
- (id)init;
@end

typedef enum {
    Direction_Left,
    Direction_Right,
    Direction_Up,
    Direction_Down
} Direction;

@interface Map : NSObject

@property (nonatomic, readonly) UIView * view;

-(id)initWithView : (UIView *)view GridWidth:(int)width;
-(int)xCount;
-(int)yCount;
-(int)gridWidth;

@end
