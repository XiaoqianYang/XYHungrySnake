//
//  SquareSnake.m
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 14/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import "SquareSnake.h"

@implementation SquareSnake

-(id)initWithLength:(int)length Origin:(Coord*)coord Direction:(Direction)direction Map:(Map *)map {
    if (self = [super initWithLength:length Origin:coord Direction:direction Map:map]) {
        _squareBody = [[NSMutableArray alloc] init];
        for (Coord * coord in [self body]) {
            int x = coord.x < 0 ? 0 : coord.x;
            int y = coord.y < 0 ? 0 : coord.y;
            UIView * square = [[UIView alloc] initWithFrame:CGRectMake(self.map.gridWidth * x, self.map.gridWidth * y, self.map.gridWidth, self.map.gridWidth)];
            
            [square setBackgroundColor:[UIColor brownColor]];
            
            [self.squareBody addObject:square];
            [self.map.view addSubview:square];
        }
    }
    
    return self;
}

- (void)dealloc {
    for (UIView * square in _squareBody) {
        [square removeFromSuperview];
    }
}

-(void)increaseSquare {
    int bodyCount = (int)[self.body count];
    int squareCount = (int)[self.squareBody count];
    
    for (int i = squareCount; i < bodyCount; i++) {
        Coord * coord = [self.body objectAtIndex:squareCount];
        int x = coord.x < 0 ? 0 : coord.x;
        int y = coord.y < 0 ? 0 : coord.y;
        UIView * square = [[UIView alloc] initWithFrame:CGRectMake(self.map.gridWidth * x, self.map.gridWidth * y, self.map.gridWidth, self.map.gridWidth)];
        
        [square setBackgroundColor:[UIColor brownColor]];
        
        [self.squareBody addObject:square];
        [self.map.view addSubview:square];
    }
    
}

-(void)increaseLength {
    [super increaseLength];
    [self increaseSquare];
}

- (BOOL)moveWithFood:(Coord *)food error:(NSError *__autoreleasing *)error {
    BOOL increased = [super moveWithFood:food error:error];
    for (int i = 0; i < [self.squareBody count]; i++) {
        UIView * square = [self.squareBody objectAtIndex:i];
        Coord * coord = [self.body objectAtIndex:i];
        [square setFrame:CGRectMake(self.map.gridWidth * coord.x, self.map.gridWidth * coord.y, self.map.gridWidth, self.map.gridWidth)];
    }
    
    if (increased) {
        [self increaseSquare];
    }
    
    return increased;
}

@end
