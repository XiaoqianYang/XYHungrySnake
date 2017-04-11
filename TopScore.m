//
//  TopScore.m
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 17/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import "TopScore.h"

@implementation TopScore
@dynamic score;
@dynamic name;
@dynamic date;

-(NSString *)showName {
    if (self.name) {
        return self.name;
    }
    else {
        return @"N/A";
    }
}

-(void)setShowName:(NSString *)showName{
    if ([showName length] == 0) {
        self.name = nil;
    }
}


@end
