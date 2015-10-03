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

@end

@implementation TItleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    GameViewController *vc = segue.destinationViewController;
    vc.isComputerEnabled = [self.computerEnableSwitch isOn];
}


@end
