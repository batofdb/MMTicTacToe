//
//  TItleViewController.m
//  TicTacToe
//
//  Created by Francis Bato on 10/3/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "TItleViewController.h"
#import "GameViewController.h"

@interface TItleViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *computerEnableSwitch;
@property (weak, nonatomic) IBOutlet UILabel *movingX;
@property (weak, nonatomic) IBOutlet UILabel *movingO;
@property (weak, nonatomic) IBOutlet UILabel *movingX2;
@property (weak, nonatomic) IBOutlet UILabel *movingO2;
@property (weak, nonatomic) IBOutlet UILabel *movingX3;
@property (weak, nonatomic) IBOutlet UILabel *movingO3;
@property (weak, nonatomic) IBOutlet UILabel *movingX4;
@property (weak, nonatomic) IBOutlet UILabel *movingO4;
@property (weak, nonatomic) IBOutlet UILabel *movingX5;
@property (weak, nonatomic) IBOutlet UILabel *movingO5;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundVIew;
@property BOOL isTitleAnimationEnabled;
@property (weak, nonatomic) IBOutlet UIView *startGameView;
@property BOOL onFirstLoad;
@end

@implementation TItleViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //Add gradient to background view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.titleBackgroundVIew.frame.size.width, self.titleBackgroundVIew.frame.size.height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor],(id)[self.titleBackgroundVIew.backgroundColor CGColor], nil];
    [self.titleBackgroundVIew.layer insertSublayer:gradient atIndex:0];


    //Add diagonal shape
    self.titleBackgroundVIew.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(45), CGAffineTransformMakeTranslation(-220, -200));

    //Add dropshadow to game start dialog box
    self.startGameView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.startGameView.layer.shadowOffset = CGSizeMake(0, 0);
    self.startGameView.layer.shadowOpacity = 0.5;
    self.startGameView.layer.shadowRadius = 12.0;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.isTitleAnimationEnabled = YES;
    [self startTitleAnimation];
}


- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self.view.layer removeAllAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    GameViewController *vc = segue.destinationViewController;
    vc.isComputerEnabled = [self.computerEnableSwitch isOn];
}

-(void) moveObject:(UILabel *)obj{

    [UIView animateWithDuration: 2+arc4random_uniform(12)
                          delay: arc4random_uniform(5)
                        options: UIViewAnimationOptionRepeat
                     animations: ^{

                         obj.frame = CGRectOffset(obj.frame, -([UIScreen mainScreen].bounds.size.width+obj.bounds.size.width), [UIScreen mainScreen].bounds.size.height);

                     } completion: ^(BOOL finished){
                         if (!self.isTitleAnimationEnabled) {
                             [UIView setAnimationRepeatCount: 0];
                         }
                     }];
}

-(void) startTitleAnimation{
    if (self.isTitleAnimationEnabled){
        [self moveObject:self.movingX];
        [self moveObject:self.movingO];
        [self moveObject:self.movingX2];
        [self moveObject:self.movingO2];
        [self moveObject:self.movingX3];
        [self moveObject:self.movingO3];
        [self moveObject:self.movingX4];
        [self moveObject:self.movingO4];
        [self moveObject:self.movingX5];
        [self moveObject:self.movingO5];
    }
}

@end
