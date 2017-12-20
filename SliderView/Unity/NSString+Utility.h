//
//  NSString+Utility.h
//  LXVolunteer
//
//  Created by 李涛 on 15/5/20.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Utility)

@property (nonatomic,strong) NSString * successNoti;
@property (nonatomic,strong) NSString * failNoti;
@property (nonatomic,assign) NSUInteger realLength;


+ (NSString *)safeString:(NSString *)str;
-(CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
-(CGSize)getSizeWithFont:(UIFont *)font;
-(CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndLineHeight:(CGFloat)lineHeight;
-(CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndParagraphStyle:(NSParagraphStyle *)paragraphStyle;
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//电话号码检测
- (BOOL)checkPhoneNum;

//获取下划线AttibutedString
- (NSAttributedString *)getAttributedStrWithUnderLine;

//获取下划线 并改变颜泽
- (NSAttributedString *)getAttributedStrWithUnderLineAndColor:(UIColor *)color;

/**
 *  MD5
 */
- (NSString *)getMD5;

/**
 *  去除空格 和 转行
 */
- (NSString *)getRealStr;

/**
 *  时间转换
 */
- (NSString *)getTimeFormat;

//系统消息时间格式
- (NSString *)messageTimeFormat;

/**
 *  数量转换
 */
- (NSString *)getShotCount;


/**
 *  检测是否为空字符串
 */
+ (BOOL)isEmpty:(NSString *)str;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 * 计算文字高度，可以处理计算带行间距的等属性
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font;
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;
/**
 * 计算最大行数文字高度，可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;

- (BOOL)containChinese:(NSString *)str;

+ (NSString *)unitStringFromString:(NSString *)numberStr;

/**
 *  传入秒转成时分秒
 */
-(NSString *)getMMSSFromSS:(NSString *)totalTime;

+(NSString *)formatSecondsToHHMMSS:(NSInteger)seconds;

@end
