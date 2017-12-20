//
//  NSString+Utility.m
//  LXVolunteer
//
//  Created by 李涛 on 15/5/20.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import "NSString+Utility.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Utility)
@dynamic successNoti;
@dynamic failNoti;
@dynamic realLength;


-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{

        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

- (CGSize)getSizeWithFont:(UIFont *)font{
    
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        return [self sizeWithAttributes:attributes];

}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndLineHeight:(CGFloat)lineHeight{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineHeight];
    return  [self getSizeWithFont:font constrainedToSize:size AndParagraphStyle:paragraphStyle];
}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndParagraphStyle:(NSParagraphStyle *)paragraphStyle{
    NSDictionary * attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

+ (NSString *)safeString:(NSString *)str{
    if (!str) {
        return @"";
    }
    else {
        return str;
    }
}


- (NSString *)successNoti{
    return [NSString stringWithFormat:@"%@SuccessNoti",self];
}

- (NSString *)failNoti{
    return [NSString stringWithFormat:@"%@FailNoti",self];
}

- (NSUInteger)realLength{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

- (NSString *)getRealStr{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)checkPhoneNum{
    if (self.length != 11) {
        return NO;
    }
    NSString *phoneRegex = @"^(1[0-9])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (NSAttributedString *)getAttributedStrWithUnderLine{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    return str;
}

- (NSAttributedString *)getAttributedStrWithUnderLineAndColor:(UIColor *)color{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:color range:strRange];
    return str;
}

- (NSString *)getMD5{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString  stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}

- (NSString*)getTimeFormat{
    if (self.realLength == 0) {
        return nil;
    }
    
    NSString *reFormat =@"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
    
    NSInteger now =[[NSDate date] timeIntervalSince1970];
    
    //来自未来
    if (self.integerValue>now) {
        reFormat = [formatter stringFromDate:confromTimesp];
    }
    if (self.integerValue==now) {
        reFormat = @"现在";
    }
    NSInteger sub =now-self.integerValue;
    if (sub>1&&sub<60) {
        reFormat = [NSString stringWithFormat:@"%ld秒前",(long)sub];
    }
    
    if (sub>60&&sub<60*60) {
        reFormat = [NSString stringWithFormat:@"%ld分钟前",(long)sub/60];
    }
    
    if (sub>60*60&&sub<60*60*24) {
        reFormat = [NSString stringWithFormat:@"%ld小时前",(long)sub/60/60];
    }
    
    if (sub>60*60*24&&sub<60*60*24*7) {
        reFormat = [NSString stringWithFormat:@"%ld天前",(long)sub/60/60/24];
    }
    
    if (sub>60*60*24*7) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateStyle:NSDateFormatterMediumStyle];
        [f setTimeStyle:NSDateFormatterShortStyle];
        [f setDateFormat:@"YYYY"];
        
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateStyle:NSDateFormatterMediumStyle];
        [f2 setTimeStyle:NSDateFormatterShortStyle];
        [f2 setDateFormat:@"MM月dd日"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
        NSString *str1= [f stringFromDate:confromTimesp];
        NSString *str2 =[f stringFromDate:[NSDate dateWithTimeIntervalSince1970:now]];
        if ([str1 isEqualToString:str2]) {
            reFormat = [f2 stringFromDate:confromTimesp];
        }else{
            reFormat =[formatter stringFromDate:confromTimesp];
        }
    }
    return reFormat;
}
- (NSString *)messageTimeFormat{
    if (self.realLength == 0) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd  aaHH:mm"];
//    NSInteger now =[[NSDate date] timeIntervalSince1970];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
    NSString *str1= [formatter stringFromDate:confromTimesp];
//    NSString *str2 =[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:now]];
    return str1;
    
}
/**
 *  数量转换
 */
-(NSString *)getShotCount{
    NSInteger times = self.integerValue;
    NSInteger tenThousand = 10000;
    if (times < tenThousand) {
        return [NSString stringWithFormat:@"%zd", times];
    }
    NSInteger thousand = 1000;
    NSInteger left = times % thousand;
    times = (times - left) / thousand;
    // < 1M, 99.9W
    //    if (times < 999.5f) {
    if (times < 999) {
        if (left >= 0) {
            times += 1;
        }
        return [NSString stringWithFormat:@"%.1f万", times / 10.f];
    }
    // < 100M 9999W
    //    if (times < 99995.f) {
    if (times < 99990) {
        times /= 10;
        if (left >= 0) {
            times += 1;
        }
        return [NSString stringWithFormat:@"%zd万", times];
    }
    // >= 100M, 1.1
    left = times % tenThousand;
    times = (times - left) / tenThousand;
    if (left >= 0) {
        times += 1;
    }
    return [NSString stringWithFormat:@"%.1f亿", times / 10.f];
}
/**
 *  判断输入的字符串是否全部为空格
 */
+ (BOOL)isEmpty:(NSString *)str
{
    if (!str) {
        return true;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        }
        else
        {
            return false;
        }
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
	if (jsonString == nil) {
		return nil;
	}
	
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	NSError *err;
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
														options:NSJSONReadingMutableContainers
														  error:&err];
	if(err) {
		return nil;
	}
	return dic;
}
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    LLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    LLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 *  计算最大行数文字高度,可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines{
    
    if (maxLines <= 0) {
        return 0;
    }
    
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    
    CGSize orginalSize = [self boundingRectWithSize:size font:font lineSpacing:lineSpacing];
    
    if ( orginalSize.height >= maxHeight ) {
        return maxHeight;
    }else{
        return orginalSize.height;
    }
}

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    
    if ( [self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}


+ (NSString *)unitStringFromString:(NSString *)numberStr{
    NSString *resultStr = nil;
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:numberStr];
    NSString *devisor;
    NSString *resultUnit = @"";
    CGFloat nfloat = [numberStr floatValue];
    //0～5位数不变，6～8位数转换为**万，9-12位数转换为**亿，12位数以上转化为**万亿
    if (nfloat/10000<1) {
        devisor = @"1";
        resultUnit = @"";
    }else if(nfloat/100000000<1){
        devisor = @"10000";
        resultUnit = @"万";
    }else if(nfloat/1000000000000<1){
        devisor = @"100000000";
        resultUnit = @"亿";
    }else{
        devisor = @"1000000000000";
        resultUnit = @"万亿";
    }
    NSDecimalNumber *divisorNumber = [NSDecimalNumber decimalNumberWithString:devisor];
    NSDecimalNumber *resultDec = [decNumber decimalNumberByDividingBy:divisorNumber];
    //直接输出结果
    //resultStr = [resultDec stringValue];
    //resultStr = [NSString stringWithFormat:@"%@%@",resultStr,resultUnit];
    //这里保留两位小数，并去除多余的0
    NSString *tempStr = [NSString stringWithFormat:@"%.2f",[resultDec floatValue]];
    resultStr = [NSString stringWithFormat:@"%@%@",@([tempStr floatValue]),resultUnit];
    return resultStr;
}

//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@小时%@分钟%@秒",str_hour,str_minute,str_second];
    
    return format_time;
}

+ (NSString *)formatSecondsToHHMMSS:(NSInteger)seconds {
    NSString *hhmmss = nil;
    if (seconds <= 0) {
      return  hhmmss = [NSString stringWithFormat:@"%02d小时%02d分钟%02d秒",00,00,00];
    }
    if (seconds<60 && seconds > 0) {
        return   hhmmss = [NSString stringWithFormat:@"%d分钟",1];
    }
    
    int m = (int)round(seconds/60);
    int s = (int)round(seconds%60);
    
    if(m/60 >0 )
    {
        if (s!=0) {
            hhmmss = [NSString stringWithFormat:@"%01d小时%01d分钟",m/60, m%60 + 1];
        }else {
            hhmmss = [NSString stringWithFormat:@"%01d小时%01d分钟",m/60, m%60];
        }
    }
    else if(s==00)
    {
        
        hhmmss = [NSString stringWithFormat:@"%01d分钟",m];
        
        
    }else {
        
        hhmmss = [NSString stringWithFormat:@"%01d分钟",m+1];
        
    }
    
    return hhmmss;
}
@end
