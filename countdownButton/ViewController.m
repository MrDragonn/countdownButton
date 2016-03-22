//
//  ViewController.m
//  countdownButton
//
//  Created by saintPN on 15/10/28.
//  Copyright © 2015年 saintPN. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *countdownButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.countdownButton.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)countdown:(id)sender {
    __weak  typeof(self) wSelf = self;
    int __block time = 10;
    
    self.countdownButton.enabled = NO;
    //获取系统全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //基于全局队列创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置定时器为点击后马上开始，间隔时间为1秒，没有延迟
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (time == 0) {
            wSelf.countdownButton.enabled = YES;
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                wSelf.countdownButton.backgroundColor = [UIColor orangeColor];
                [wSelf.countdownButton setTitle:@"点击获取验证短信" forState:UIControlStateNormal];
            });
        } else {
            time --;
            NSString *string = [NSString stringWithFormat:@"%d秒后重新获取", time];
            dispatch_async(dispatch_get_main_queue(), ^{
                wSelf.countdownButton.backgroundColor = [UIColor cyanColor];
                [wSelf.countdownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [wSelf.countdownButton setTitle:string forState:UIControlStateNormal];
            });
        }
    });
    //初始状态默认是挂起，创建后必须手动恢复
    dispatch_resume(timer);
}




@end
