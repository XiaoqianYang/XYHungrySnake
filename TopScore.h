//
//  TopScore.h
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 17/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TopScore : NSManagedObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * showName;
@property (nonatomic) int16_t score;
@property (nonatomic, strong) NSDate * date;
@end
