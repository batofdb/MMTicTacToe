//
//  GameViewController.m
//  TicTacToe
//
//  Created by Francis Bato on 10/1/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *topLeft;
@property (weak, nonatomic) IBOutlet UILabel *topMiddle;
@property (weak, nonatomic) IBOutlet UILabel *topRight;
@property (weak, nonatomic) IBOutlet UILabel *middleLeft;
@property (weak, nonatomic) IBOutlet UILabel *middleMiddle;
@property (weak, nonatomic) IBOutlet UILabel *middleRight;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeft;
@property (weak, nonatomic) IBOutlet UILabel *bottomMiddle;
@property (weak, nonatomic) IBOutlet UILabel *bottomRight;
@property (weak, nonatomic) IBOutlet UILabel *gameIndicator;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *quitButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *computerEnabledButton;
@property int currentLocation;
@property NSMutableAttributedString *mark;
@property NSArray *gridLayout;
@property NSSet *answerKey;
@property NSMutableSet *playerOneMoves;
@property NSMutableSet *playerTwoMoves;
@property BOOL isWinner;
@property BOOL isValidMark;
@property BOOL isPlayerOne;
@property int timerCount;
@property NSTimer *timer;
@property BOOL isPlaying;
@property CGPoint defaultGameIndicatorCenter;
@property NSMutableSet *availableMoves;


@end

@implementation GameViewController

- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    
    self.mark = [[NSMutableAttributedString alloc]init];
    self.gridLayout = [NSArray arrayWithObjects:self.topLeft,self.topMiddle,self.topRight,self.middleLeft,self.middleMiddle,self.middleRight,self.bottomLeft,self.bottomMiddle,self.bottomRight,nil];

    self.answerKey = [NSSet setWithObjects:[NSSet setWithObjects:@0,@1,@2,nil],[NSSet setWithObjects:@3,@4,@5,nil],[NSSet setWithObjects:@6,@7,@8,nil],[NSSet setWithObjects:@0,@3,@6,nil],[NSSet setWithObjects:@1,@4,@7, nil],[NSSet setWithObjects:@2,@5,@8,nil],[NSSet setWithObjects:@0,@4,@8,nil],[NSSet setWithObjects:@2,@4,@6, nil],nil];

    self.availableMoves = [NSMutableSet setWithObjects:@0,@1,@2,@3,@4,@5,@6,@7,@8, nil];

    self.playerOneMoves = [[NSMutableSet alloc] init];
    self.playerTwoMoves = [[NSMutableSet alloc] init];
    self.isPlaying = NO;
    self.isWinner = NO;
    self.isPlayerOne = YES;
    self.isValidMark = NO;
    self.defaultGameIndicatorCenter = self.gameIndicator.center;

    [self startGame];
}



- (void) updateGameBoard {
    if (self.isPlaying){
        if (self.isPlayerOne)
            self.gameIndicator.text = @"X";
        else
            self.gameIndicator.text = @"O";
    }
/*
    if(self.isPlaying)
        [self.quitButtonLabel setTitle:@"Quit" forState:UIControlStateNormal];
*/
}

- (IBAction)tapHandler:(UITapGestureRecognizer *)sender {

    UIView *currentView = (UIView *)sender.view;
    self.currentLocation = (int) currentView.tag;

    if(self.isPlaying)
        [self markPlayerTap];

    [self updateGameBoard];
}

- (void) markPlayerTap {

    UIFont *fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    UIFont *fontLight = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];

    if (self.isPlayerOne == YES){
        self.mark = [self.mark initWithString:@"x"];
        [self.mark addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, [self.mark length])];
    } else {
        self.mark = [self.mark initWithString:@"o"];
        [self.mark addAttribute:NSFontAttributeName value:fontLight range:NSMakeRange(0, [self.mark length])];
    }

    [self makeMagicHappen:[self.gridLayout objectAtIndex:self.currentLocation]];

    if (!self.isValidMark){
        [self addPlayerMove];
        if(self.isPlayerOne)
            [self.availableMoves minusSet:self.playerOneMoves];
        else
            [self.availableMoves minusSet:self.playerTwoMoves];

        [self checkForWinner];
        if (self.isWinner)
            [self alertWinner];

        self.isValidMark = YES;
        [self resetTimer];
        self.isPlayerOne ^= YES;
        //Issue with AI belowvvvvvvvvv
        if(self.isComputerEnabled && (self.isPlayerOne == NO))
            [self makeComputerMove];



    }
}


-(void) makeMagicHappen : (UILabel *) label{

    if (!([[label.attributedText string] containsString:@"x"] || [[label.attributedText string]containsString:@"o"])){
        label.attributedText = self.mark;
        self.isValidMark = NO;
    }
}
- (IBAction)resetButton:(UIButton *)sender {
    [self resetAction];
}

-(void) resetAction{

    for (UILabel *label in self.gridLayout){
        label.text = @"";
    }
    self.availableMoves = [NSMutableSet setWithObjects:@0,@1,@2,@3,@4,@5,@6,@7,@8, nil];
    //[self.quitButtonLabel setTitle:@"Start" forState:UIControlStateNormal];
    self.gameIndicator.text = @"Ready";
    [self resetTimer];
    self.isPlaying = NO;
    [self.playerOneMoves removeAllObjects];
    [self.playerTwoMoves removeAllObjects];
    self.isPlayerOne = YES;
    self.isValidMark = YES;
    self.isWinner = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Brute Force method
- (void) checkForWinner{
    for (NSSet *set in self.answerKey){
        if(self.isPlayerOne == YES) {
        if([set isSubsetOfSet:self.playerOneMoves])
            self.isWinner = YES;
        } else {
        if([set isSubsetOfSet:self.playerTwoMoves])
            self.isWinner = YES;
        }
    }
    if((self.isWinner == NO) &&([self.availableMoves count]==0)){
        [self tieGameAlert];
    }
}

- (void) addPlayerMove{
    if (self.isPlayerOne)
        [self.playerOneMoves addObject:[NSNumber numberWithInt:self.currentLocation]];
    else
        [self.playerTwoMoves addObject:[NSNumber numberWithInt:self.currentLocation]];
}

-(void) alertWinner{

    [self stopTimer];
    NSString *playerString = @"Player 1";
    if (!self.isPlayerOne)
        playerString = @"Player 2";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You're a Winner!" message:[playerString stringByAppendingString:@" won!"] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"YESSS!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self resetAction];
        }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) tieGameAlert{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cat's Game" message:[NSString stringWithFormat:@"It's a tie..=("] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Aw man!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self stopTimer];
        [self resetAction];
    }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

////////////////////
// Stretch Goals
////////////////////

///////////////////
// Timer
///////////////////

-(void) timerAlert{
    
    NSString *playerString = @"Player 2";
    if (!self.isPlayerOne)
        playerString = @"Player 1";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Time is up!" message:[playerString stringByAppendingString:@" won!"] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"I guess." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self resetAction];
    }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) resetTimer{
    self.timerCount = 10;
    self.timerLabel.text = [NSString stringWithFormat:@"%i",self.timerCount];
}

-(void) startTimer{
    [self resetTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void) stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) countDown{
    self.timerCount--;
    self.timerLabel.text = [NSString stringWithFormat:@"%i",self.timerCount];
    if (self.timerCount == 0)
    {
        [self stopTimer];
        [self timerAlert];
    }
}

//////////////
// Interface
//////////////

- (IBAction)quitButton:(UIButton *)sender {
    [self stopTimer];
    [self resetAction];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) startGame{
    self.isPlaying ^= YES;

    if(self.isPlaying){
        self.isValidMark = YES;
        [self updateGameBoard];
        [self startTimer];
        NSLog(@"1");
    } else {
        [self resetTimer];
        [self stopTimer];
        [self resetAction];
        NSLog(@"2");
    }
}

- (IBAction)panHandler:(UIPanGestureRecognizer *)sender {
    if (self.isPlaying){
        CGPoint point = [sender locationInView:self.view];
        self.gameIndicator.center = point;

        if (sender.state == UIGestureRecognizerStateEnded){

            int count =0;
            for(UILabel *label in self.gridLayout){
                if(CGRectContainsPoint(label.frame,point)){
                    self.currentLocation = count;

                    if(self.isPlaying)
                    [self markPlayerTap];
                
                    [self updateGameBoard];
                }
                count++;
        }
        self.gameIndicator.center = self.defaultGameIndicatorCenter;
        }
    }
}

////////////////
// AI
////////////////

-(void) makeComputerMove{
    self.currentLocation = [[self randomAvailableMove:self.availableMoves] intValue];
    [self markPlayerTap];
}

-(NSNumber *) randomAvailableMove:(NSSet *)set{

    NSArray *array = [set allObjects];

    if ([array count] == 0) {
        return nil;
    }
    return [array objectAtIndex: arc4random() % [array count]];
}
@end




//Click and drag game fails after 4 moves
