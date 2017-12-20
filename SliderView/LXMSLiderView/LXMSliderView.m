//
//  HBLockSliderView.m
//  MySliderDemo
//
//  Created by 屌炸天 on 16/9/18.
//  Copyright © 2016年 yhb. All rights reserved.
//

#define kSliderW self.bounds.size.width
#define kSliderH self.bounds.size.height
#define kCornerRadius 2  //默认圆角为5
#define kBorderWidth 0.5 //默认边框为2
#define kAnimationSpeed 0.5 //默认动画移速
#define kForegroundColor [UIColor orangeColor] //默认滑过颜色
#define kBackgroundColor [UIColor darkGrayColor] //默认未滑过颜色
#define kThumbColor [UIColor lightGrayColor] //默认Thumb颜色
#define kBorderColor [UIColor blackColor] //默认边框颜色
#define kThumbW 15 //默认的thumb的宽度
#import "FBShimmeringView.h"
#import "NSString+Utility.h"
#define SuccessText @"验证成功"
#define KProcessVerify @"正在验证..."

#import "LXMSliderView.h"
@interface LXMSliderView () {
    UILabel *_label;
    UIImageView *_thumbImageView;
    UIView *_foregroundView;
    UIView *_touchView;
}
/**
 *  中间菊花
 */
@property (nonatomic, strong) UIActivityIndicatorView *actIdcView;
@property (nonatomic, strong)  FBShimmeringView *shimmeringView;

@end
@implementation LXMSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:20];
    
    [self addSubview:_label];

    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.bounds];
    [self addSubview:self.shimmeringView];
    self.shimmeringView.contentView = _label;
    self.shimmeringView.shimmering = YES;

    _foregroundView = [[UIView alloc] init];
    [self addSubview:_foregroundView];
    _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _thumbImageView.layer.cornerRadius = kCornerRadius;
    _thumbImageView.layer.masksToBounds = YES;
    _thumbImageView.userInteractionEnabled = YES;
    [self addSubview:_thumbImageView];
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = kBorderWidth;
    [self setSliderValue:0.0];
    //默认配置
    self.thumbBack = YES;
    self.backgroundColor = kBackgroundColor;
    _foregroundView.backgroundColor = kForegroundColor;
    _thumbImageView.backgroundColor = kThumbColor;
    [self.layer setBorderColor:kBorderColor.CGColor];
    _touchView = _thumbImageView;
    
    _actIdcView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _actIdcView.hidden = YES;
    [self addSubview:_actIdcView];
}

- (void)setIsNeedActView:(BOOL)isNeedActView {
    _isNeedActView = isNeedActView;

}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isNeedActView) {
        CGSize labeTextWidth = [_label.text getSizeWithFont:_label.font];
        CGFloat actIdcViewSize = 44;
        CGFloat actIdcViewX = (self.bounds.size.width - labeTextWidth.width) * 0.5 - actIdcViewSize;
        _actIdcView.frame = CGRectMake(actIdcViewX, 0, actIdcViewSize, self.bounds.size.height);
    }
}
/**
 *  开始转菊花
 */
- (void)startLoading {
    if (self.actIdcView) {
        [self.actIdcView startAnimating];
    }
   
}
/**
 *  停止转菊花
 */
- (void)stopLoading {
    if ([self.actIdcView isAnimating] && self.actIdcView) {
        [self.actIdcView stopAnimating];
    }
}
- (void)resetSliderView {

    
}
- (void)sliderViewSuccessVerify {
    _label.text = SuccessText;
    self.actIdcView.hidden = YES;
    [self stopLoading];
}
#pragma mark - Public
- (void)setText:(NSString *)text{
    _text = text;
    _label.text = text;
   
}

- (void)setFont:(UIFont *)font{
    _font = font;
    _label.font = font;
}

- (void)setSliderValue:(CGFloat)value{
    [self setSliderValue:value animation:NO completion:nil];
}

- (void)setSliderValue:(CGFloat)value animation:(BOOL)animation completion:(void (^)(BOOL))completion{
    if (value > 1) {
        value = 1;
    }
    if (value < 1) {
        value = 0;
    }
    CGPoint point = CGPointMake(value * kSliderW, 0);
    typeof(self) weakSelf = self;
    if (animation) {
        [UIView animateWithDuration:kAnimationSpeed animations:^{
            [weakSelf fillForeGroundViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self fillForeGroundViewWithPoint:point];
    }
}

- (void)setColorForBackgroud:(UIColor *)backgroud foreground:(UIColor *)foreground thumb:(UIColor *)thumb border:(UIColor *)border textColor:(UIColor *)textColor{
    self.backgroundColor = backgroud;
    _foregroundView.backgroundColor = foreground;
    _thumbImageView.backgroundColor = thumb;
    [self.layer setBorderColor:border.CGColor];
    _label.textColor = textColor;
}

- (void)setThumbImage:(UIImage *)thumbImage{
    _thumbImage = thumbImage;
    _thumbImageView.image = thumbImage ;
    //    _thumbImageView.image = [self imageAddCornerWithImage:thumbImage Radius:kCornerRadius andSize:thumbImage.size];
    [_thumbImageView sizeToFit];
    [self setSliderValue:0.0];
}

- (void)setThumbBeginImage:(UIImage *)beginImage finishImage:(UIImage *)finishImage{
    self.thumbImage = beginImage;
    self.finishImage = finishImage;
}

- (void)removeRoundCorners:(BOOL)corners border:(BOOL)border{
    if (corners) {
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = NO;
        _thumbImageView.layer.cornerRadius = 0.0;
        _thumbImageView.layer.masksToBounds = NO;
    }
    if (border) {
        [self.layer setBorderWidth:0.0];
    }
}

- (void)setThumbHidden:(BOOL)thumbHidden{
    _thumbHidden = thumbHidden;
    _touchView = thumbHidden ? self : _thumbImageView;
    _thumbImageView.hidden = thumbHidden;
}
- (void)setOriginLabel:(NSString *)sliderText{

    _label.text = sliderText;

}

- (void)insetLabelToBack{
    
    [self insertSubview:_foregroundView aboveSubview:_label];
    self.shimmeringView.shimmering = YES;
    [self insertSubview:_thumbImageView aboveSubview:_foregroundView];


}

#pragma mark - Private
- (void)fillForeGroundViewWithPoint:(CGPoint)point{
    CGFloat thunmbW = self.thumbImage ? self.thumbImage.size.width : kThumbW;
    if (point.x < 0) {
        point.x = 0;
    }
    if (point.x > kSliderW) {
        point.x = kSliderW;
    }
    self.value = point.x  / kSliderW;
    
    _foregroundView.frame = CGRectMake(0, 0, point.x, kSliderH);

    if (point.x <= 0) {
        _thumbImageView.frame = CGRectMake(0, kBorderWidth, thunmbW,kSliderH);
        
    }else if (point.x > kSliderW) {
        _thumbImageView.frame = CGRectMake(_foregroundView.frame.size.width - thunmbW - 10, kBorderWidth, thunmbW, kSliderH);
        
    }else{
        _thumbImageView.frame = CGRectMake(_foregroundView.frame.size.width-thunmbW, kBorderWidth, thunmbW, kSliderH);
    }
    
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    if ([self.delegate respondsToSelector:@selector(sliderValueBeginChanging:)] ) {
        [self.delegate sliderValueBeginChanging:self];
    }
    if ( _touchView == _thumbImageView) {
        return;
    }
    CGPoint point = [touch locationInView:self];
    NSLog(@"%f",point.x);
    [self fillForeGroundViewWithPoint:point];
    
//    if ([self.delegate respondsToSelector:@selector(sliderValueTouchView:)]) {
//        [self.delegate sliderValueTouchView:touch.view];
//    }
    
   
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    if (touch.view != _touchView ) {
        
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(sliderValueTouchView:)]) {
        [self.delegate sliderValueTouchView:touch.view];
    }
    
    CGPoint point = [touch locationInView:self];
    [self fillForeGroundViewWithPoint:point];
    if ([self.delegate respondsToSelector:@selector(sliderValueChanging:)] ) {
        [self.delegate sliderValueChanging:self];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view == _touchView ) {
        
       
    CGPoint __block point = [touch locationInView:self];

    
    typeof(self) weakSelf = self;
    if (_thumbBack) {

        if (point.x >= kSliderW ) {
            self.userInteractionEnabled = NO;
            _thumbImageView.image = _finishImage;
            _label.text = self.isNeedActView == YES ? KProcessVerify : SuccessText;
            [self insertSubview:_label aboveSubview:_foregroundView];
            self.shimmeringView.shimmering = NO;
            
            if (_isNeedActView) {
                self.actIdcView.hidden = NO;
                [self startLoading];
            }
            else {
                self.actIdcView.hidden = YES;
                [self stopLoading];
            }
            if ([self.delegate respondsToSelector:@selector(sliderEndValueChanged:)]) {
                    [self.delegate sliderEndValueChanged:self];
            }
           
        }else {
            
            [UIView animateWithDuration:0.5 animations:^{
                point.x = 0;
                [weakSelf fillForeGroundViewWithPoint:point];
                
            }];
        
        }
        
        
    }
        
    }
}

@end
