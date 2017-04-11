//
//  Snake.m
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 6/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import "Snake.h"

@interface Snake ()
@property (nonatomic) NSMutableArray * body;
@property (nonatomic) Direction direction;
@end

@implementation Snake

-(id)initWithLength:(int)length Origin:(Coord*)coord Direction:(Direction)direction Map:(Map *)map {
    if (self = [super init]) {
        _body = [[NSMutableArray alloc] init];
        _direction = direction;
        _map = map;
        
        for (int i = 0; i < length; i++) {
            if (i == 0) {
                [_body addObject:coord];
            }
            else {
                [self increaseLengthWithTailDirection:direction];
            }
        }
    }
    return self;
}

- (int) length {
    return (int)[_body count];
}

- (NSArray *)body {
    return [NSArray arrayWithArray:_body];
}

-(void)increaseLengthWithTailDirection:(Direction)direction {
    Coord * co = [[Coord alloc]init];
    int count = (int)[_body count];
    
    if (direction == Direction_Right) {
        co.x = ((Coord*)[self.body objectAtIndex:(count-1)]).x - 1;
        co.y = ((Coord*)[self.body objectAtIndex:(count-1)]).y;
    }
    else if (direction == Direction_Left) {
        co.x = ((Coord*)[self.body objectAtIndex:(count-1)]).x + 1;
        co.y = ((Coord*)[self.body objectAtIndex:(count-1)]).y;
    }
    else if (direction == Direction_Up) {
        co.y = ((Coord*)[self.body objectAtIndex:(count-1)]).y + 1;
        co.x = ((Coord*)[self.body objectAtIndex:(count-1)]).x;
    }
    else if (direction == Direction_Down) {
        co.y = ((Coord*)[self.body objectAtIndex:(count-1)]).y - 1;
        co.x = ((Coord*)[self.body objectAtIndex:(count-1)]).x;
    }
    
    [_body addObject:co];
    
}

-(void)increaseLength {
    if ([_body count] < 2) {
        NSLog(@"snake body should not short than 2");
        return;
    }
    Direction direction;
    Coord * beforeLast = [_body objectAtIndex:([_body count] -2)];
    Coord * last = [_body lastObject];
    
    if (last.x == beforeLast.x - 1 && last.y == beforeLast.y) {
        direction = Direction_Right;
    }
    else if (last.x == beforeLast.x + 1 && last.y == beforeLast.y) {
        direction = Direction_Left;
    }
    else if (last.x == beforeLast.x && last.y == beforeLast.y - 1) {
        direction = Direction_Down;
    }
    else if (last.x == beforeLast.x && last.y == beforeLast.y + 1) {
        direction = Direction_Up;
    }
    
    [self increaseLengthWithTailDirection:direction];
}

-(void)setDirection : (Direction)direction error:(NSError *__autoreleasing *)error {
    if ((_direction == Direction_Left && direction == Direction_Right) || (_direction == Direction_Right && direction == Direction_Left)
        || (_direction == Direction_Up && direction == Direction_Down) || (_direction == Direction_Down && direction == Direction_Up)) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:Error_SnakeWrongDirection forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"snake" code:200 userInfo:details];
        
        return;
    }
    _direction = direction;
}

-(void)move:(NSError **)error {
    Coord * co = [[Coord alloc]init];
    
    if (_direction == Direction_Right) {
        co.x = ((Coord*)[self.body firstObject]).x + 1;
        co.y = ((Coord*)[self.body firstObject]).y;
    }
    else if (_direction == Direction_Left) {
        co.x = ((Coord*)[self.body firstObject]).x - 1;
        co.y = ((Coord*)[self.body firstObject]).y;
    }
    else if (_direction == Direction_Up) {
        co.x = ((Coord*)[self.body firstObject]).x;
        co.y = ((Coord*)[self.body firstObject]).y - 1;
    }
    else if (_direction == Direction_Down) {
        co.x = ((Coord*)[self.body firstObject]).x;
        co.y = ((Coord*)[self.body firstObject]).y + 1;
    }
    
    //exceed boundary
    if (co.x < 0 || co.y < 0 || co.x >= _map.xCount || co.y >= _map.yCount) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:Error_SnakeExceedBoundary forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ErrorDomain_Snake code:201 userInfo:details];
        
        return;
    }
    
    for (Coord* body in _body) {
        if (body == [_body lastObject]) {
            break;
        }
        
        if (body.x == co.x && body.y == co.y) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:Error_SnakeRunOverSelf forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:ErrorDomain_Snake code:202 userInfo:details];
            
            return;

        }
    }
    
    [_body insertObject:co atIndex:0];
    [_body removeLastObject];
}

- (BOOL)moveWithFood:(Coord *)food error:(NSError *__autoreleasing *)error {
    [self move:error];
    
    Coord* head = [_body firstObject];
    if (head.x == food.x && head.y == food.y) {
        [self increaseLength];
        return YES;
    }
    else {
        return NO;
    }
}

@end
