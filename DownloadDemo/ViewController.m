//
//  ViewController.m
//  DownloadDemo
//
//  Created by lilei on 16/1/29.
//  Copyright © 2016年 handsight. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)download:(id)sender {
    NSLog(@"调用了download函数");
    NSURL *url = [NSURL URLWithString:@"http://download.handsight.cn/tvhelper.apk"];
    UIDownloadBar *downloadBar = [[UIDownloadBar alloc] initWithURL:url progressBarFrame:CGRectMake(50, 130, 220, 80) timeout:5 delegate:self];
    [self.view addSubview:downloadBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename{
    NSLog(@"调用了downloadBar:didFinishWithData函数");
}
- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error{
    NSLog(@"调用了downloadBar:didFailWithError函数");
}
- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar{
    NSLog(@"调用了downloadBarUpdated函数");
}

@end
