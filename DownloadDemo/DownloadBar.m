//
//  DownloadBar.m
//  DownloadDemo
//
//  Created by lilei on 16/1/29.
//  Copyright © 2016年 handsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicHeader.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIDownloadBar
@synthesize DownloadRequest,DownloadConnection,receivedData,delegate,percentComplete;

- (UIDownloadBar *)initWithURL:(NSURL *)fileURL progressBarFrame:(CGRect)frame timeout:(NSInteger)timeout delegate:(id<UIDownloadBarDelegate>)theDelegate {
    self = [super initWithFrame:frame];
    if(self) {
        self.layer.borderWidth = 2.0;
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor blackColor];
        //进度条，中间
        progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.frame = CGRectMake(10, 20, self.frame.size.width-20, 20);
        [self addSubview:progressView];
        //左下角
        CGRect lblDownloadBytesFrame = CGRectMake(10, frame.size.height-35, 120, 20);
        lblDownloadBytes = [[UILabel alloc]initWithFrame:lblDownloadBytesFrame];
        lblDownloadBytes.textColor = [UIColor whiteColor];
        lblDownloadBytes.backgroundColor = [UIColor clearColor];
        [self addSubview:lblDownloadBytes];
        //右下角
        CGRect lblDownloadPercentFrame = CGRectMake(frame.size.width-50
                                                    , frame.size.height-35, 60, 20);
        lblDownloadPercent = [[UILabel alloc]initWithFrame:lblDownloadPercentFrame];
        lblDownloadPercent.textColor = [UIColor whiteColor];
        lblDownloadPercent.backgroundColor = [UIColor clearColor];
        [self addSubview:lblDownloadPercent];
        
        
        self.delegate = theDelegate;
        lblDownloadPercent.text = @"0%";
        bytesReceived = percentComplete = 0;
        localFilename = [[[fileURL absoluteString] lastPathComponent] copy];
        receivedData = [[NSMutableData alloc] initWithLength:0];
        progressView.progress = 0.0;
        progressView.backgroundColor = [UIColor clearColor];
        DownloadRequest = [[NSURLRequest alloc] initWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
        DownloadConnection = [[NSURLConnection alloc] initWithRequest:DownloadRequest delegate:self startImmediately:YES];
        
        if(DownloadConnection == nil) {
            [self.delegate downloadBar:self didFailWithError:[NSError errorWithDomain:@"UIDownloadBar Error" code:1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"NSURLConnection Failed", NSLocalizedDescriptionKey, nil]]];
        }
    }
    
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
    
    NSInteger receivedLen = [data length];
    bytesReceived = (bytesReceived + receivedLen);
    lblDownloadBytes.text = [NSString stringWithFormat:@"%.02f/%.02fMB",
                             (float)bytesReceived/1048576,(float)expectedBytes/1048576];
    //百分比
    lblDownloadPercent.text = [NSString stringWithFormat:@"%.0f%%",
                               (((float)bytesReceived/1048576)/((float)expectedBytes/1048576))*100];
    if(expectedBytes != NSURLResponseUnknownLength) {
        progressView.progress = ((bytesReceived/(float)expectedBytes)*100)/100;
        percentComplete = progressView.progress*100;
    }
    
    [delegate downloadBarUpdated:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate downloadBar:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    expectedBytes = [response expectedContentLength];
    lblDownloadBytes.text = [NSString stringWithFormat:@"0/%.02fMB",(float)expectedBytes/1048576];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate downloadBar:self didFinishWithData:self.receivedData suggestedFilename:localFilename];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

@end