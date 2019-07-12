//
//  TGSliderControl.h
//  TGFilterControl
//
//  Created by smallCar on 2019/7/12.
//  Copyright © 2019 twiglau. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGSliderControl : UIControl

-(id) initWithFrame:(CGRect) frame Dots:(NSArray *) dots;
-(void) setSelectedIndex:(int)index;
@property(nonatomic, strong) UIButton *handler;
@property(nonatomic, strong) UIImage *selectImage;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, strong) UIColor *TopTitlesColor;
@property(nonatomic, readonly) int SelectedIndex;
@property (nonatomic,readwrite) CGFloat progress;
@end

NS_ASSUME_NONNULL_END
