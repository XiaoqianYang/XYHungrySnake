//
//  Snake.h
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 6/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#define ErrorDomain_Snake @"Snake Error"
#define Error_SnakeWrongDirection @"error, snake Direction"
#define Error_SnakeExceedBoundary @"error, snake exceed boundary"
#define Error_SnakeRunOverSelf @"error, snake run over self"

#import <Foundation/Foundation.h>
#import "Map.h"


@interface Snake : NSObject

@property (nonatomic, readonly) Map * map;

-(id)initWithLength:(int)length Origin:(Coord*)coord Direction:(Direction)direction Map:(Map*)map;
-(int)length;
-(NSArray *)body;
-(void)increaseLength;
-(void)setDirection : (Direction) direction error:(NSError **)error;
-(void)move:(NSError **)error;
-(BOOL)moveWithFood:(Coord*)food error:(NSError**)error;

@end
