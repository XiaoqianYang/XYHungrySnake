//
//  ViewController.m
//  XYHungrySnake
//
//  Created by Xiaoqian Yang on 5/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import "SnakeGameViewController.h"
#import "Map.h"
#import "SquareSnake.h"
#import "TopScore.h"
#import "XYCoreDataStack.h"

#define Score_Width self.view.frame.size.width - InnerPadding*2
#define Score_Hight 60
#define InnerPadding 10
#define Grid_Width 30
#define View_Width self.view.frame.size.width
#define MapView_Width ((int)((self.view.frame.size.width - InnerPadding) / 30)) * 30
#define MapView_Hight self.view.frame.size.height - Score_Hight*2 - InnerPadding * 3
#define Initial_TimeInterval 1

@interface SnakeGameViewController ()
@property (strong, nonatomic) SquareSnake * snake;
@property (strong, nonatomic) Map * map;
@property (strong, nonatomic) UIView * mapView;
@property (strong, nonatomic) UIView * food;
@property (strong, nonatomic) Coord * foodLocation;
@property (strong, nonatomic) UILabel * scoreLabel;
@property (strong, nonatomic) UILabel * highestScoreLabel;
@property (nonatomic) int score;
@property (nonatomic) Direction direction;
@property (nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) NSTimer * timer;
@property (nonatomic, strong) TopScore * highestScore;
@property (nonatomic, strong) UIAlertController * congratulationAlert;
@property (nonatomic, strong) UIAlertController * gameOverAlert;
@end

@implementation SnakeGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initGame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGame {
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    int statusBarHeight = rect.size.height;
    
    //init mapview
    _mapView = [[UIView alloc] initWithFrame:CGRectMake((View_Width - MapView_Width)/2, statusBarHeight + InnerPadding, MapView_Width, MapView_Hight - statusBarHeight)];
    _mapView.layer.borderColor = [[UIColor blackColor] CGColor];
    _mapView.layer.borderWidth = 1.0f;
    [self.view addSubview:_mapView];
    
    //init map
    _map = [[Map alloc] initWithView:_mapView GridWidth:Grid_Width];
    
    //init snake
    _direction = Direction_Right;
    _snake = [[SquareSnake alloc] initWithLength:2 Origin:[[Coord alloc]init] Direction:_direction Map:_map];
    
    //init food
    _foodLocation = [self getFoodLocation];
    _food = [[UIView alloc] initWithFrame:CGRectMake(Grid_Width * _foodLocation.x, Grid_Width * _foodLocation.y, Grid_Width, Grid_Width)];
    [_food setBackgroundColor:[UIColor yellowColor]];
    [_mapView addSubview:_food];
    
    //init score label
    [self setScore:0];
    
    //init timer
    [self setTimerWithInterval:Initial_TimeInterval];
    
    //add swipe gesture recognizer
    UISwipeGestureRecognizer * swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureUp];
    UISwipeGestureRecognizer * swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureDown];
    UISwipeGestureRecognizer * swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureLeft];
    UISwipeGestureRecognizer * swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRight];
    
    //init alertcontroller
}

-(void)setScore:(int)score{
    [self getHighestScore];
    
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(InnerPadding, MapView_Hight + InnerPadding, Score_Width, Score_Hight)];
        [self.view addSubview:_scoreLabel];
    }
    if (!_highestScoreLabel) {
        _highestScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(InnerPadding, MapView_Hight + InnerPadding + Score_Hight, Score_Width, Score_Hight)];
        [self.view addSubview:_highestScoreLabel];
    }
    
    _score = score;
    [_scoreLabel setText:[NSString stringWithFormat:@"Current score: %d",_score]];
    if (self.highestScore) {
        [_highestScoreLabel setText:[NSString stringWithFormat:@"Highest score: %d (%@)", self.highestScore.score, self.highestScore.showName]];
    }
    
    if (_score!=0 && _score % 500 == 0) {
        [self setTimerWithInterval:(_timeInterval / 2)];
    }
}

-(void)resetFood {
    _foodLocation = [self getFoodLocation];
    [_food setFrame:CGRectMake(Grid_Width * _foodLocation.x, Grid_Width * _foodLocation.y, Grid_Width, Grid_Width)];
}

-(void)resetGame {
    //reset snake
    _snake = nil;
    _direction = Direction_Right;
    _snake = [[SquareSnake alloc] initWithLength:2 Origin:[[Coord alloc]init] Direction:_direction Map:_map];
    
    [self resetFood];
    
    [self setScore:0];
    
    //init timer
    [self setTimerWithInterval:Initial_TimeInterval];
}

-(void)moveSnake {
    NSError * error;
    
    BOOL increased = [_snake moveWithFood:_foodLocation error:&error];
    if (error) {
        [self gameOver:error];
        return;
    }
    else {
        if (increased) {
            [self setScore : _score+100];
            [self resetFood];
        }
    }
}

-(void) setTimerWithInterval:(NSTimeInterval)timeInterval {
//    if (_timeInterval == timeInterval) {
//        return;
//    }
    
    [self removeTimer];
    _timeInterval = timeInterval;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(moveSnake) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

-(void)gameOver:(NSError *) error {
    NSLog(@"error..............%ld", (long)error.code);
    [self removeTimer];
    
    if (self.score > self.highestScore.score) {
        if (!_congratulationAlert) {
            [self initCongratulationAlert];
        }
        [self presentViewController:_congratulationAlert animated:YES completion:nil];
    }
    else {
        if (!_gameOverAlert) {
            [self initGameOverAlert];
        }
        [self presentViewController:_gameOverAlert animated:YES completion:nil];
    }
}

- (Coord *)getFoodLocation {
    Coord * foodLocation = [[Coord alloc] init];
    while (YES) {
        foodLocation.x = arc4random() % _snake.map.xCount;
        foodLocation.y = arc4random() % _snake.map.yCount;
        
        BOOL conflict = NO;
        for (Coord * coord in _snake.body) {
            if (coord.x == foodLocation.x || coord.y == foodLocation.y) {
                conflict = YES;
                break;
            }
        }
        if (!conflict) {
            return foodLocation;
        }
    }
}

#pragma mark alert view method

-(void)initCongratulationAlert {
    _congratulationAlert = [UIAlertController alertControllerWithTitle:@"Congratulations" message:@"You got the highest score!" preferredStyle:UIAlertControllerStyleAlert];
    [_congratulationAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Input your name...";
    }];
    
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self saveScore];
        [self resetGame];
    }];
    [_congratulationAlert addAction:defaultAction];
    
}

-(void)initGameOverAlert {
    _gameOverAlert = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Game Over!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Play again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self resetGame];
    }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"Quit game" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        exit(0);
    }];
    
    [_gameOverAlert addAction:defaultAction];
    [_gameOverAlert addAction:quitAction];
    
}

#pragma mark coredata method

-(void)getHighestScore {
    self.highestScore = 0;
    return;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TopScore"];
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    [fetchRequest setSortDescriptors:@[descriptor]];
    
    NSFetchedResultsController * fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XYCoreDataStack defaultStack].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError * error;
    [fetchController performFetch:&error];
    
    if([fetchController.fetchedObjects count]>0) {
        self.highestScore = [fetchController.fetchedObjects objectAtIndex:0];
    }
    else {
        self.highestScore = [NSEntityDescription insertNewObjectForEntityForName:@"TopScore" inManagedObjectContext:[XYCoreDataStack defaultStack].managedObjectContext];

    }
}

-(void)saveScore {
    return;
    if (self.score <= self.highestScore.score) {
        return;
    }
    XYCoreDataStack * coreDataStack = [XYCoreDataStack defaultStack];
    self.highestScore.score = self.score;
    self.highestScore.date = [NSDate date];
    self.highestScore.showName = [_congratulationAlert.textFields objectAtIndex:0].text;
    [coreDataStack saveContext];
    
}


#pragma mark IBAction

-(IBAction)swipe:(UISwipeGestureRecognizer *)recognizer {
    NSError * error;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [_snake setDirection:Direction_Up error:&error];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [_snake setDirection:Direction_Down error:&error];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [_snake setDirection:Direction_Left error:&error];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [_snake setDirection:Direction_Right error:&error];
    }
    
}

@end
