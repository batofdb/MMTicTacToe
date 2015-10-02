//
//  WebViewController.m
//  TicTacToe
//
//  Created by Francis Bato on 10/2/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self loadPage:@"https://en.wikipedia.org/wiki/Tic-tac-toe"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCloseButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadPage:(NSString *)webStr{
    NSURL *url = [NSURL URLWithString:webStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [self.webView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.spinner startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.spinner stopAnimating];
}

@end
