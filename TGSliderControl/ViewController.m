//
//  ViewController.m
//  TGFilterControl
//
//  Created by smallCar on 2019/7/12.
//  Copyright © 2019 twiglau. All rights reserved.
//

#import "ViewController.h"
#import "TGSliderControl.h"
#import "UIColor+RGB.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *sliderContainerView;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (nonatomic,strong) TGSliderControl *tSlider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tSlider = [[TGSliderControl alloc]initWithFrame:self.sliderContainerView.bounds Dots:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3",@"4", nil]];//定制dots
    self.tSlider.selectImage = [UIImage imageNamed:@"绿色块"];//
    [self.tSlider.handler setBackgroundImage:[UIImage imageNamed:@"绿色滑动按钮"] forState:UIControlStateNormal];
    self.tSlider.progressColor = [UIColor colorWithRGBHex:0x00CE9F];
    [self.tSlider  addTarget:self action:@selector(progressShow:) forControlEvents:UIControlEventValueChanged];
    [self.sliderContainerView addSubview:self.tSlider];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (void)progressShow:(TGSliderControl *)slider{
    self.displayLabel.text = [NSString stringWithFormat:@"%.4f",slider.progress];
}
@end
