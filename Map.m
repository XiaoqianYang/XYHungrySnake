//
//  Map.m
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 6/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import "Map.h"

@implementation Coord
- (id)init {
    if (self = [super init]) {
        self.x = 0;
        self.y = 0;
    }
    
    return self;
}
@end

@interface Map()
@property (nonatomic) int gridWidth;
@property (nonatomic) int xCount;
@property (nonatomic) int yCount;
@end

@implementation Map

-(id)initWithView:(UIView *)view GridWidth:(int)width {
    if (self = [super init]) {
        self.gridWidth = width;
        _view = view;
        self.xCount = (int)(_view.frame.size.width/_gridWidth);
        self.yCount = (int)(_view.frame.size.height/_gridWidth);
    }
    
    return self;
}

-(int)xCount {
    return _xCount;
}

-(int)yCount {
    return _yCount;
}

-(int)gridWidth {
    return _gridWidth;
}

//-(void)setSnakeDirection:(Direction)direction error:(NSError**)error{
//    [self.snake setDirection:direction error:error];
//}
//
//-(void)moveSnake:(NSError *__autoreleasing *)error {
//    [self.snake move];
//    
//    Coord * head = [self.snake.body firstObject];
//    if (head.x < 0 || head.y < 0 || head.x >= _xCount || head.y >= _yCount) {
//        NSMutableDictionary* details = [NSMutableDictionary dictionary];
//        [details setValue:Error_SnakeExceedBoundary forKey:NSLocalizedDescriptionKey];
//        *error = [NSError errorWithDomain:@"snake" code:201 userInfo:details];
//    }
//    else {
//        *error = nil;
//    }
//}

@end
