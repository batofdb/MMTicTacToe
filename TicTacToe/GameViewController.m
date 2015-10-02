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
@property NSArray *gridLayout;
@property BOOL isWinner;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridLayout = [NSArray arrayWithObjects:self.topLeft,self.topMiddle,self.topRight,self.middleLeft,self.middleMiddle,self.middleRight,self.bottomLeft,self.bottomMiddle,self.bottomRight,nil];

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

    [self checkForWinner];

    if (self.isWinner == YES){

        NSString *playerString = @"Player 1";
        if (self.isPlayerOne)
            playerString = @"Player 2";

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You're a Winner!" message:[playerString stringByAppendingString:@" won!"] preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"YESSS!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self resetAction];
        }];

        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (IBAction)tapHandler:(UITapGestureRecognizer *)sender {

    CGPoint currentPoint = [sender locationInView:self.view];
    NSLog(@"%f,%f",currentPoint.x,currentPoint.y);
    [self findLabelUsingPoint:currentPoint];
    [self markPlayerTap];
    [self updateGameBoard];
}


- (void) findLabelUsingPoint:(CGPoint) point {
    if (CGRectContainsPoint(self.topLeft.frame, point)){

        self.currentLocation = 0;

    } else if(CGRectContainsPoint(self.topMiddle.frame, point)){

        self.currentLocation = 1;

    } else if(CGRectContainsPoint(self.topRight.frame, point)){

        self.currentLocation = 2;

    } else if(CGRectContainsPoint(self.middleLeft.frame, point)){

        self.currentLocation = 3;

    } else if(CGRectContainsPoint(self.middleMiddle.frame, point)){

        self.currentLocation = 4;

    } else if(CGRectContainsPoint(self.middleRight.frame, point)){

        self.currentLocation = 5;

    } else if(CGRectContainsPoint(self.bottomLeft.frame, point)){

        self.currentLocation = 6;

    } else if(CGRectContainsPoint(self.bottomMiddle.frame, point)){

        self.currentLocation = 7;

    } else if(CGRectContainsPoint(self.bottomRight.frame, point)){

        self.currentLocation = 8;

    }
}

- (void) markPlayerTap {
    NSString *mark = @"";
    if (self.isPlayerOne == YES){
        mark = @"x";
    } else {
        mark = @"o";
    }

    for (int i=0;i<9;i++){
        if(i == self.currentLocation)
        {
            [self makeMagicHappen:[self.gridLayout objectAtIndex:i] mark:mark];
        }
    }

    if (!self.isValidMark){
        self.isPlayerOne ^= YES;
        self.isValidMark = YES;
    }

}


-(void) makeMagicHappen : (UILabel *) label  mark: (NSString *) mark{

    if (!([label.text containsString:@"x"] || [label.text containsString:@"o"])){
        label.text = mark;
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

    self.isPlayerOne = YES;
    self.isValidMark = YES;
    self.isWinner = NO;
    [self updateGameBoard];
}

//Brute Force method

- (void) checkForWinner{
    NSString *currentMark = @"o";
    if (self.isPlayerOne == NO)
        currentMark = @"x";

    if(([[self.gridLayout objectAtIndex:0] text] == currentMark) && ([[self.gridLayout objectAtIndex:4] text] == currentMark) && ([[self.gridLayout objectAtIndex:8] text] == currentMark)){
        self.isWinner = YES;
    }else if(([[self.gridLayout objectAtIndex:6] text] == currentMark) && ([[self.gridLayout objectAtIndex:4] text] == currentMark) && ([[self.gridLayout objectAtIndex:2] text] == currentMark)){
        self.isWinner = YES;
    }else if(([[self.gridLayout objectAtIndex:6] text] == currentMark) && ([[self.gridLayout objectAtIndex:7] text] == currentMark) && ([[self.gridLayout objectAtIndex:8] text] == currentMark)){
        self.isWinner = YES;
    }else if(([[self.gridLayout objectAtIndex:0] text] == currentMark) && ([[self.gridLayout objectAtIndex:1] text] == currentMark) && ([[self.gridLayout objectAtIndex:2] text] == currentMark)){
        self.isWinner = YES;
    } else if(([[self.gridLayout objectAtIndex:2] text] == currentMark) && ([[self.gridLayout objectAtIndex:5] text] == currentMark) && ([[self.gridLayout objectAtIndex:8] text] == currentMark)){
        self.isWinner = YES;
    }else if(([[self.gridLayout objectAtIndex:0] text] == currentMark) && ([[self.gridLayout objectAtIndex:3] text] == currentMark) && ([[self.gridLayout objectAtIndex:6] text] == currentMark)){
        self.isWinner = YES;
    }else if(([[self.gridLayout objectAtIndex:1] text] == currentMark) && ([[self.gridLayout objectAtIndex:4] text] == currentMark) && ([[self.gridLayout objectAtIndex:7] text] == currentMark)){
        self.isWinner = YES;
    }else if(([[self.gridLayout objectAtIndex:3] text] == currentMark) && ([[self.gridLayout objectAtIndex:4] text] == currentMark) && ([[self.gridLayout objectAtIndex:5] text] == currentMark)){
        self.isWinner = YES;
    }

}


@end
