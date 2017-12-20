//
//  ViewController.m
//  SliderView
//
//  Created by IsLand on 2017/12/20.
//  Copyright © 2017年 IsLand. All rights reserved.
//

#import "ViewController.h"
#import "LXMSliderView.h"
#import "UIColor+Helo.h"
static NSString *sliderText = @"请按住滑块,拖到最右边";
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface ViewController ()<HBLockSliderDelegate>
@property (nonatomic, strong) LXMSliderView   *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self sliderView];

}

- (LXMSliderView *)sliderView {
    
    if (!_sliderView) {
        _sliderView = [[LXMSliderView alloc]initWithFrame:CGRectMake(15,70,SCREEN_WIDTH - 30,40)];
        [self.view addSubview:_sliderView];
        [_sliderView setColorForBackgroud:[UIColor colorFromHexRGB:@"AFAFAF"] foreground:[UIColor colorFromHexRGB:@"F5A623"] thumb:nil border:[UIColor colorFromHexRGB:@"D5D5D5"] textColor:[UIColor whiteColor]];
        _sliderView.text = sliderText;
        _sliderView.delegate = self;
        _sliderView.font = [UIFont systemFontOfSize:15.0f];
        [_sliderView setThumbBeginImage:[UIImage imageNamed:@"slider_arrow_icon"] finishImage:[UIImage imageNamed:@"slider_done_icon"]];
        
    }
    return _sliderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
