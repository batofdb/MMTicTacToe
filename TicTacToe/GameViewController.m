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
@property NSMutableAttributedString *mark;
@property NSArray *gridLayout;
@property NSSet *answerKey;
@property NSMutableSet *playerOneMoves;
@property NSMutableSet *playerTwoMoves;
@property BOOL isWinner;
@property BOOL isValidMark;
@property BOOL isPlayerOne;

@end

@implementation GameViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.mark = [[NSMutableAttributedString alloc]init];
    self.gridLayout = [NSArray arrayWithObjects:self.topLeft,self.topMiddle,self.topRight,self.middleLeft,self.middleMiddle,self.middleRight,self.bottomLeft,self.bottomMiddle,self.bottomRight,nil];

    self.answerKey = [NSSet setWithObjects:[NSSet setWithObjects:@0,@1,@2,nil],[NSSet setWithObjects:@3,@4,@5,nil],[NSSet setWithObjects:@6,@7,@8,nil],[NSSet setWithObjects:@0,@3,@6,nil],[NSSet setWithObjects:@1,@4,@7, nil],[NSSet setWithObjects:@2,@5,@8,nil],[NSSet setWithObjects:@0,@4,@8,nil],[NSSet setWithObjects:@2,@4,@6, nil],nil];

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
        [self checkForWinner];
        if (self.isWinner)
            [self alertWinner];
        self.isPlayerOne ^= YES;
        self.isValidMark = YES;
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

    [self.playerOneMoves removeAllObjects];
    [self.playerTwoMoves removeAllObjects];
    self.isPlayerOne = YES;
    self.isValidMark = YES;
    self.isWinner = NO;
    [self updateGameBoard];
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


////////////////////
// Stretch Goals
////////////////////




@end
