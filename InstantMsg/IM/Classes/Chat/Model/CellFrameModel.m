//
//  CellFrame.m
//  IM
//
//  Created by Chan on 15/2/10.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import "CellFrameModel.h"
#import "CellMessageModel.h"

#define kAvatorWidth   35
#define kAvatorHeight  35
#define kBodyMaxWidth  150
#define kFileImageWidth 120
#define kImageSizingRatio 0.2
#define kVoiceImageViewWidthAndHeight 15


@implementation CellFrameModel
#pragma mark -setter
- (void)setCellMsg:(CellMessageModel *)cellMsg
{
    _cellMsg = cellMsg;

    UIFont *font = [UIFont systemFontOfSize:10.0f];
    CGSize timestampSize = [cellMsg.timestamp getContraintedSize:CGSizeMake(kScreenWidth, MAXFLOAT) withFont:font];
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    self.timeLbFrame = CGRectMake(timeX, timeY, kScreenWidth, timestampSize.height);
    
    CGFloat avatorX = 0;
    CGFloat avatorY = CGRectGetMaxY(self.timeLbFrame);
    if (!cellMsg.isOutgoing) {
        avatorX = kSpace;
    }else{
        avatorX = kScreenWidth - kSpace - kAvatorWidth;
    }
    self.avatorBtnFrame = CGRectMake(avatorX, avatorY, kAvatorWidth, kAvatorWidth);
    
    CGFloat bodyX = 0;
    CGFloat bodyY = avatorY;
//    CGSize bodySize =  [cellMsg.body getContraintedSize:CGSizeMake(kBodyMaxWidth, MAXFLOAT) withFont:[UIFont systemFontOfSize:14.0f]];
    if ([cellMsg.body hasPrefix:@"http"]) {//是链接
        
        //根据链接来计算frame
//        NSRange range = [cellMsg.body rangeOfString:@"]"];
//        NSRange sizeRange = (NSRange){5,range.location - 5};
//        NSString *sizeStr = [cellMsg.body substringWithRange:sizeRange];
        int ft = [[cellMsg.body getParameterValue:@"ft"] intValue];
  
        if (0 == ft ) {//图片
            NSString *sizeStr = [cellMsg.body getParameterValue:@"s"];
            NSArray *nubs = [sizeStr componentsSeparatedByString:@"*"];
            CGFloat width = 100;
            CGFloat height = 100;
            if (nubs.count > 1) {
                width = [nubs[0] floatValue];
                height = [nubs[1] floatValue];
            }
            if (!cellMsg.isOutgoing) {
                bodyX = CGRectGetMaxX(self.avatorBtnFrame) + kSpace;
            }else{
                bodyX = avatorX - kSpace - kFileImageWidth;
            }
            if (width < kFileImageWidth) {
                self.textBtnFrame = (CGRect){(CGPoint){bodyX, bodyY},CGSizeMake(width, height *kImageSizingRatio)};
            }else{
                self.textBtnFrame = (CGRect){(CGPoint){bodyX, bodyY},CGSizeMake(kFileImageWidth, height *kImageSizingRatio)};
            }
            
        }else if (1 == ft){//音频文件
            
            if (!cellMsg.isOutgoing) {
                bodyX = CGRectGetMaxX(self.avatorBtnFrame) + kSpace;
            }else{
                bodyX = avatorX - kSpace - 150;
            }
            self.textBtnFrame = (CGRect){(CGPoint){bodyX, bodyY},CGSizeMake(150, 50)};
            // 计算音频视图的frame
            CGRect audioIVFrame = CGRectZero;

            if (!cellMsg.isOutgoing) {
                audioIVFrame.origin.x = 2*kSpace;
                
            }else{
                audioIVFrame.origin.x = self.textBtnFrame.size.width - 2*kSpace - kVoiceImageViewWidthAndHeight;
            }
            audioIVFrame = CGRectMake(audioIVFrame.origin.x, (self.textBtnFrame.size.height - kVoiceImageViewWidthAndHeight)/2, kVoiceImageViewWidthAndHeight, kVoiceImageViewWidthAndHeight);
            self.voiceFrame = audioIVFrame;

        }else if (2 == ft){//视频文件
            
            if (!cellMsg.isOutgoing) {
                bodyX = CGRectGetMaxX(self.avatorBtnFrame) + kSpace;
            }else{
                bodyX = avatorX - kSpace - 150;
            }
            self.textBtnFrame = (CGRect){(CGPoint){bodyX, bodyY},CGSizeMake(150, 100)};
            
        }

    }else{//不是链接,是文字
        CGSize textMaxSize = CGSizeMake(kBodyMaxWidth, MAXFLOAT);
        CGSize bodySize = [cellMsg.body sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize];
        
        CGSize bodyRealSize = CGSizeMake(bodySize.width + 4*kSpace, bodySize.height + 2*kSpace);
        
        if (!cellMsg.isOutgoing) {
            bodyX = CGRectGetMaxX(self.avatorBtnFrame) + kSpace;
            
        }else{
            bodyX = avatorX - kSpace - bodyRealSize.width;
        }
        self.textBtnFrame = (CGRect){(CGPoint){bodyX, bodyY},bodyRealSize};

    }

    CGFloat height1 = CGRectGetMaxY(self.textBtnFrame);
    CGFloat height2 = CGRectGetMaxY(self.avatorBtnFrame);
    
    self.cellHeight = (height1 >= height2) ? (height1 + kSpace) : (height2 + kSpace);
}
@end
