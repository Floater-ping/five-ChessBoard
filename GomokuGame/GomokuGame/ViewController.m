//
//  ViewController.m
//  GomokuGame
//
//  Created by ZYP-MAC on 2017/8/18.
//  Copyright © 2017年 ZYP-MAC. All rights reserved.
//

#import "ViewController.h"
#import "TOCGraphicView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TOCGraphicView *chessBoardView;
@property (weak, nonatomic) IBOutlet UILabel *showStatusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chessBoardView.gameOverBlock = ^(NSString *winnerColor) {
        self.showStatusLabel.text = [NSString stringWithFormat:@"%@方胜！",winnerColor];
        self.chessBoardView.userInteractionEnabled = NO;
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)beginNewchessboard:(UIButton *)sender {
    [self.chessBoardView clearnBoard];
    self.showStatusLabel.text = @"比赛进行中";
   
}


@end
