//
//  TGSliderControl.m
//  TGFilterControl
//
//  Created by smallCar on 2019/7/12.
//  Copyright © 2019 twiglau. All rights reserved.
//

#import "TGSliderControl.h"
#import "Masonry.h"
#import "UIColor+RGB.h"
#define LEFT_OFFSET 5
#define RIGHT_OFFSET 5
@interface TGSliderControl (){
    CGPoint diffPoint;
    NSArray *dotsArray;
    BOOL _isMove;
    float oneSlotSize;
}
@property (nonatomic,strong) UIView *progressView,*bgProView;
@property (nonatomic,strong) MASConstraint *progressContraint;
@end
@implementation TGSliderControl
@synthesize SelectedIndex,progressColor,progress;

-(CGPoint)getCenterPointForIndex:(int) i{
    CGPoint point = CGPointZero;
    int total = (int)dotsArray.count - 1;
    if(i == 0){
        point = CGPointMake(4, self.frame.size.height/2.0);
    }else if (i == total){
        point = CGPointMake(self.frame.size.width - 4, self.frame.size.height/2.0);
    }else{
        point = CGPointMake(self.frame.size.width/(total*1.0) * i, self.frame.size.height/2.0);
    }
    
    return point;
}

-(CGPoint)fixFinalPoint:(CGPoint)pnt{
    
    CGFloat oneX = 0;
    if (pnt.x < oneX) {
        pnt.x = 0;
    }else if (pnt.x+(_handler.frame.size.width/2.f) > self.frame.size.width-RIGHT_OFFSET){
        pnt.x = self.frame.size.width-RIGHT_OFFSET- (_handler.frame.size.width/2.f);
        
    }
    return pnt;
}

-(id) initWithFrame:(CGRect) frame Dots:(NSArray *) dots{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        dotsArray = [[NSArray alloc] initWithArray:dots];
        
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 6)];
        //        self.progressView.clipsToBounds = YES;
        //        self.progressView.layer.cornerRadius = 5.0;
        self.progressView.backgroundColor = [UIColor colorWithRGBHex:0x00CE9F];
        self.progressView.userInteractionEnabled = NO;
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.top.equalTo(self).mas_offset(9);
            make.trailing.equalTo(self);
            make.height.mas_equalTo(2);
        }];
        
        self.bgProView = [[UIView alloc] initWithFrame:CGRectZero];
        //        self.bgProView.clipsToBounds = YES;
        //        self.bgProView.layer.cornerRadius = 5.0f;
        self.bgProView.backgroundColor = [UIColor colorWithRGBHex:0xB5B8C9];
        self.bgProView.userInteractionEnabled = NO;
        [self addSubview:self.bgProView];
        [self.bgProView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.progressContraint = make.leading.equalTo(self).mas_offset(4);
            make.trailing.equalTo(self);
            make.top.equalTo(self).mas_offset(9);
            make.height.mas_equalTo(2);
        }];
        
        int i;
        NSString *title;
        
        
        oneSlotSize = 1.f*(self.frame.size.width-LEFT_OFFSET-RIGHT_OFFSET-1)/(dotsArray.count-1);
        for (i = 0; i < (int)dotsArray.count; i++) {
            UIImageView *lbl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 11)];
            lbl.image = [UIImage imageNamed:@"灰色块"];
            lbl.backgroundColor = UIColor.whiteColor;
            lbl.clipsToBounds = YES;
            [lbl setTag:i+50];
            [lbl setCenter:[self getCenterPointForIndex:i]];
            [self addSubview:lbl];
        }
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ItemSelected:)];
        [self addGestureRecognizer:gest];
        
        _handler = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handler setFrame:CGRectMake(LEFT_OFFSET, 0, 28.0*10/13.0, 28.0)];
        [_handler setAdjustsImageWhenHighlighted:NO];
        _handler.layer.shadowColor = UIColor.blackColor.CGColor;
        _handler.layer.shadowOffset = CGSizeMake(0.2, 0.2);
        _handler.layer.shadowOpacity = 0.2;
        [_handler setSelected:YES];
        
        [_handler setCenter:CGPointMake(7, self.frame.size.height/2.0)];
        [_handler addTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
        [_handler addTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_handler addTarget:self action:@selector(TouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
        
        UIImage *image1 = [UIImage imageNamed:@"绿色滑动按钮"];
        UIImage *image2 = [UIImage imageNamed:@"绿色滑动按钮"];
        
        [_handler setBackgroundImage:image1 forState:UIControlStateNormal];
        [_handler setBackgroundImage:image2 forState:UIControlStateSelected];
        
        [self addSubview:_handler];
    }
    return self;
}



- (void) TouchDown: (UIButton *) btn withEvent: (UIEvent *) ev{
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    diffPoint = CGPointMake(currPoint.x - btn.frame.origin.x, currPoint.y - btn.frame.origin.y);
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)setProgressColor:(UIColor *)progressColor{
    _progressView.backgroundColor = progressColor;
    int selected = [self getSelectedTitleInPoint:_handler.center];
    [self animateDotsToIndex:selected];
}

-(void) animateDotsToIndex:(int) index{
    int i;
    
    for (i = 0; i < (int)dotsArray.count; i++) {
        UIImageView *lbl = (UIImageView *)[self viewWithTag:i+50];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (i == index || i < index) {
            //选中时label颜色
            [lbl setImage:self.selectImage];
        }else{
            //未选中时label颜色
            [lbl setImage:[UIImage imageNamed:@"灰色块"]];
        }
        [UIView commitAnimations];
    }
}

-(void) animateHandlerToProgress:(CGFloat)pro{
    CGPoint toPoint = CGPointZero;
    toPoint = CGPointMake(pro*self.frame.size.width-(_handler.frame.size.width/2.f), _handler.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint];
    
    [UIView beginAnimations:nil context:nil];
    self.progressContraint.inset = toPoint.x+10;
    [self layoutIfNeeded];
    [_handler setFrame:CGRectMake(toPoint.x, toPoint.y, _handler.frame.size.width, _handler.frame.size.height)];
    [UIView commitAnimations];
}

-(void) animateHandlerToIndex:(int) index{
    CGPoint toPoint = [self getCenterPointForIndex:index];
    toPoint = CGPointMake(toPoint.x-(_handler.frame.size.width/2.f), _handler.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint];
    
    [UIView beginAnimations:nil context:nil];
    self.progressContraint.inset = toPoint.x+10;
    [self layoutIfNeeded];
    [_handler setFrame:CGRectMake(toPoint.x, toPoint.y, _handler.frame.size.width, _handler.frame.size.height)];
    [UIView commitAnimations];
}

- (void)setProgress:(CGFloat)pro{
    progress = pro;
    int index = (int)(progress*dotsArray.count);
    [self animateDotsToIndex:index];
    [self animateHandlerToProgress:progress];
    //    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
-(void) setSelectedIndex:(int)index{
    SelectedIndex = index;
    [self animateDotsToIndex:index];
    [self animateHandlerToIndex:index];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(int)getSelectedTitleInPoint:(CGPoint)pnt{
    return (int)((pnt.x-LEFT_OFFSET)/oneSlotSize);
}
//点击 dot ----
-(void) ItemSelected: (UITapGestureRecognizer *) tap {
    SelectedIndex = [self getSelectedTitleInPoint:[tap locationInView:self]];
    progress = SelectedIndex*1.0/(dotsArray.count-1);
    _isMove = NO;
    [self setSelectedIndex:SelectedIndex];
    
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
//释放---
-(void) TouchUp: (UIButton*) btn{
    btn.selected = YES;
    if(!_isMove){//滑动不需要移动到节点
        SelectedIndex = [self getSelectedTitleInPoint:btn.center];
        
        //        progress = SelectedIndex/titlesArr.count;
        //        [self setProgress:progress];
        [self animateHandlerToIndex:SelectedIndex];
    }
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

//滑动---
- (void) TouchMove: (UIButton *) btn withEvent: (UIEvent *) ev {
    btn.selected = NO;
    _isMove = YES;
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    CGFloat p_x = currPoint.x/self.frame.size.width;
    if(p_x < 0){
        progress = 0.0;
    }else if (p_x > 1.0){
        progress = 1.0;
    }else{
        progress = p_x;
    }
    //    [self setProgress:progress];
    CGPoint toPoint = CGPointMake(currPoint.x-diffPoint.x, _handler.frame.origin.y);//
    
    toPoint = [self fixFinalPoint:toPoint];
    
    self.progressContraint.inset = toPoint.x+10;
    [self layoutIfNeeded];
    [_handler setFrame:CGRectMake(toPoint.x, toPoint.y, _handler.frame.size.width, _handler.frame.size.height)];
    int selected = [self getSelectedTitleInPoint:btn.center];
    [self animateDotsToIndex:selected]; //计算并覆盖Dot
    
    [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}


@end
