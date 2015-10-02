//
//  GameViewController.m
//  TicTacToe
//
//  Created by Francis Bato on 10/1/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
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
@property int currentLocation;
@property BOOL isValidMark;
@property BOOL isPlayerOne;
@property NSString *mark;
@property NSArray *gridLayout;
@property NSSet *answerKey;
@property NSMutableSet *playerOneMoves;
@property NSMutableSet *playerTwoMoves;
@property BOOL isWinner;

@end

@implementation GameViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.gridLayout = [NSArray arrayWithObjects:self.topLeft,self.topMiddle,self.topRight,self.middleLeft,self.middleMiddle,self.middleRight,self.bottomLeft,self.bottomMiddle,self.bottomRight,nil];

    self.answerKey = [NSSet setWithObjects:[NSSet setWithObjects:@0,@1,@2,nil],[NSSet setWithObjects:@3,@4,@5,nil],[NSSet setWithObjects:@6,@7,@8,nil],[NSSet setWithObjects:@0,@3,@6,nil],[NSSet setWithObjects:@1,@4,@7,nil],[NSSet setWithObjects:@2,@5,@8,nil],[NSSet setWithObjects:@0,@4,@8,nil],[NSSet setWithObjects:@2,@5,@6,nil],nil];

    self.playerOneMoves = [[NSMutableSet alloc] init];
    self.playerTwoMoves = [[NSMutableSet alloc] init];

    self.isWinner = NO;
    self.isPlayerOne = YES;
    self.isValidMark = YES;
    [self updateGameBoard];

}

- (void) updateGameBoard {

    if (self.isPlayerOne){
        self.gameIndicator.text = @"X";
    } else {
        self.gameIndicator.text = @"O";
    }
}

- (IBAction)tapHandler:(UITapGestureRecognizer *)sender {

    UIView *currentView = (UIView *)sender.view;
    self.currentLocation = (int) currentView.tag;
    [self markPlayerTap];
    [self updateGameBoard];
}

- (void) markPlayerTap {

    if (self.isPlayerOne == YES){
        self.mark = @"x";
    } else {
        self.mark = @"o";
    }

    [self makeMagicHappen:[self.gridLayout objectAtIndex:self.currentLocation]];

    if (!self.isValidMark){
        [self addPlayerMove];
        [self checkForWinner];
        if (self.isWinner)
            [self alertWinner];
        self.isPlayerOne ^= YES;
        self.isValidMark = YES;
    }
}


-(void) makeMagicHappen : (UILabel *) label{

    if (!([label.text containsString:@"x"] || [label.text containsString:@"o"])){
        label.text = self.mark;
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

    [self.playerOneMoves removeAllObjects];
    [self.playerTwoMoves removeAllObjects];
    self.isPlayerOne = YES;
    self.isValidMark = YES;
    self.isWinner = NO;
    [self updateGameBoard];
}

//Brute Force method
- (void) checkForWinner{
    
    if(self.isPlayerOne == YES) {
        if([self.answerKey containsObject:self.playerOneMoves])
            self.isWinner = YES;
    } else {
        if([self.answerKey containsObject:self.playerTwoMoves])
            self.isWinner = YES;
    }
}

- (void) addPlayerMove{
    if (self.isPlayerOne)
        [self.playerOneMoves addObject:[NSNumber numberWithInt:self.currentLocation]];
    else
        [self.playerTwoMoves addObject:[NSNumber numberWithInt:self.currentLocation]];

}

-(void) alertWinner{
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
@end
