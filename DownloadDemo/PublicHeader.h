//
//  PublicHeader.h
//  DownloadDemo
//
//  Created by lilei on 16/1/29.
//  Copyright © 2016年 handsight. All rights reserved.
//

#ifndef PublicHeader_h
#define PublicHeader_h
#import <UIKit/UIKit.h>

@class UIDownloadBar;
@protocol UIDownloadBarDelegate<NSObject>

@optional
- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename;
- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error;
- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar;

@end

@interface UIDownloadBar : UIView {
    UIProgressView *progressView;
    NSURLRequest* DownloadRequest;
    NSURLConnection* DownloadConnection;
    NSMutableData* receivedData;
    NSString* localFilename;
    __unsafe_unretained id<UIDownloadBarDelegate> delegate;
    long long bytesReceived;
    long long expectedBytes;
    
    float percentComplete;
    UILabel *lblDownloadBytes;
    UILabel *lblDownloadPercent;
}
@property (nonatomic, readonly) NSMutableData* receivedData;
@property (nonatomic, readonly, retain) NSURLRequest* DownloadRequest;
@property (nonatomic, readonly, retain) NSURLConnection* DownloadConnection;
@property (nonatomic, assign) id<UIDownloadBarDelegate> delegate;
@property (nonatomic, readonly) float percentComplete;
- (UIDownloadBar *)initWithURL:(NSURL *)fileURL progressBarFrame:(CGRect)frame timeout:(NSInteger)timeout delegate:(id<UIDownloadBarDelegate>)theDelegate;
@end



#endif /* PublicHeader_h */
