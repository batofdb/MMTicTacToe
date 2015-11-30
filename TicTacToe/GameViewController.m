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
@property NSMutableArray *computerAvailableMoves;
@property NSMutableSet *tempSet;
@property (weak, nonatomic) IBOutlet UIView *gameBoardView;
@property (weak, nonatomic) IBOutlet UIView *gameBoardBackgroundView;


@end

@implementation GameViewController

- (void)viewDidLoad {

    //Adding background gradient to gameboard background view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.gameBoardBackgroundView.frame.size.width, self.gameBoardBackgroundView.frame.size.height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[self.gameBoardBackgroundView.backgroundColor CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.gameBoardBackgroundView.layer insertSublayer:gradient atIndex:0];


    //Adding drop shadow to gameboard
    self.gameBoardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.gameBoardView.layer.shadowOffset = CGSizeMake(0, 0);
    self.gameBoardView.layer.shadowOpacity = 0.5;
    self.gameBoardView.layer.shadowRadius = 12.0;
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
    self.computerAvailableMoves = [[NSMutableArray alloc] init];
    self.tempSet = [[NSMutableSet alloc] init];
    self.isPlaying = NO;
    self.isWinner = NO;
    self.isPlayerOne = YES;
    self.isValidMark = NO;
    self.defaultGameIndicatorCenter = self.gameIndicator.center;

    [self startGame];
}



- (void) updateGameBoard {
    UIColor *color;

    UIFont *fontBold = [UIFont fontWithName:@"AvenirNext-UltraLight" size:50.0f];
    UIFont *fontLight = [UIFont fontWithName:@"AvenirNext-UltraLight" size:50.0f];

    NSMutableAttributedString *mark = [[NSMutableAttributedString alloc]init];

    if (self.isPlaying){
        if (self.isPlayerOne) {
            mark = [mark initWithString:@"X"];
        [mark addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, [mark length])];
        color = UIColorFromRGB(0x00BCD4); // select needed color
        } else {
            mark = [mark initWithString:@"O"];
            [mark addAttribute:NSFontAttributeName value:fontLight range:NSMakeRange(0, [mark length])];
            color = UIColorFromRGB(0xFF5722); // select needed color
        }

        [mark addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[mark length])];
        self.gameIndicator.attributedText = mark;
    }


}

- (IBAction)tapHandler:(UITapGestureRecognizer *)sender {

    UIView *currentView = (UIView *)sender.view;
    self.currentLocation = (int) currentView.tag;

    if(self.isPlaying)
        [self markPlayerTap];

    [self updateGameBoard];
}

- (void) markPlayerTap {

    UIColor *color;

    UIFont *fontBold = [UIFont fontWithName:@"AvenirNext-UltraLight" size:75.0f];
    UIFont *fontLight = [UIFont fontWithName:@"AvenirNext-UltraLight" size:75.0f];

    self.mark = [self.mark initWithString:@"x"];
    [self.mark addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, [self.mark length])];
    color = UIColorFromRGB(0x00BCD4); // select needed color

    if (self.isPlayerOne == YES){
        self.mark = [self.mark initWithString:@"x"];
        [self.mark addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, [self.mark length])];
        color = UIColorFromRGB(0x00BCD4); // select needed color
    } else {
        self.mark = [self.mark initWithString:@"o"];
        [self.mark addAttribute:NSFontAttributeName value:fontLight range:NSMakeRange(0, [self.mark length])];
        color = UIColorFromRGB(0xFF5722); // select needed color
    }

    [self.mark addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[self.mark length])];

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

-(void)clearBoard{
    for (UILabel *label in self.gridLayout){
        label.text = @"";
    }
    [self.playerOneMoves removeAllObjects];
    [self.playerTwoMoves removeAllObjects];
    [self updateGameBoard];
}

-(void) resetAction{

    self.availableMoves = [NSMutableSet setWithObjects:@0,@1,@2,@3,@4,@5,@6,@7,@8, nil];
    //[self.quitButtonLabel setTitle:@"Start" forState:UIControlStateNormal];
    self.gameIndicator.text = @"Ready";
    [self resetTimer];
    self.isPlaying = NO;
    [self clearBoard];
    self.isPlayerOne = YES;
    self.isValidMark = YES;
    self.isWinner = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Brute Force method
- (void) checkForWinner{
    for (NSSet *set in self.answerKey){
        if(self.isPlayerOne == YES) {
            if([set isSubsetOfSet:self.playerOneMoves]) {
            self.isWinner = YES;
            break;
            }
        } else {
            if([set isSubsetOfSet:self.playerTwoMoves]) {
            self.isWinner = YES;
            break;
            }
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

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Winner!" message:[playerString stringByAppendingString:@" won!"] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"YESSS!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self resetAction];
        }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) tieGameAlert{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cat's Game" message:[NSString stringWithFormat:@"It's a tie..=("] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    [self aiCheckForAvailableMoves];
    if ([self.computerAvailableMoves count] == 0)
        self.currentLocation = [[self randomAvailableMove:self.availableMoves] intValue];
    else
        self.currentLocation = [[self.computerAvailableMoves objectAtIndex:arc4random() % [self.computerAvailableMoves count]]intValue];

    [self markPlayerTap];
}

-(NSNumber *) randomAvailableMove:(NSSet *)set{

    NSArray *array = [set allObjects];

    if ([array count] == 0) {
        return nil;
    }
    return [array objectAtIndex: arc4random() % [array count]];
}
- (IBAction)onHelpButtonPressed:(UIButton *)sender {
    [self stopTimer];
    [self clearBoard];

}

- (void) aiCheckForAvailableMoves{

    int hits = 0;
    [self.computerAvailableMoves removeAllObjects];

    if([self.playerTwoMoves count]>1){
        //Logic to win game
        for(NSSet *moveWin in self.answerKey){
            int count = 0;
            for (NSNumber *numOne in moveWin)
            {
                if([self.playerTwoMoves member:numOne]!=nil){
                    hits++;
                } else {
                    if (hits == 2 && [self.availableMoves containsObject:numOne]){
                        [self.computerAvailableMoves addObject:numOne];
                    }
                }
                count++;
                if(count==4)
                    hits = 0;
            }
        }
    }

    //Logic to block player one's move
    if(([self.computerAvailableMoves count] == 0)&&([self.playerOneMoves count] > 1)){
        for(NSSet *moveBlock in self.answerKey){
            int count = 0;
            for (NSNumber *numTwo in moveBlock)
            {
                if([self.playerOneMoves member:numTwo]!=nil){
                    hits++;
                } else {
                    if (hits == 2 && [self.availableMoves containsObject:numTwo]){
                        [self.computerAvailableMoves addObject:numTwo];
                    }
                }
                count++;
                if(count==4)
                    hits = 0;
            }
        }
    }

    NSMutableSet *tempSet = [[NSMutableSet alloc] initWithArray:self.computerAvailableMoves];
    [tempSet intersectSet:self.availableMoves];
    self.computerAvailableMoves = [NSMutableArray arrayWithArray:[tempSet allObjects]];

}
@end


