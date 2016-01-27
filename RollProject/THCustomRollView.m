//
//  myScrollerView.m
//  RollProject
//
//  Created by 朱封毅 on 24/01/16.
//  Copyright © 2016年 tairan. All rights reserved.
//

#import "THCustomRollView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define TH0086D1  UIColorFromRGB(0x0086d1)
#define TH808080 UIColorFromRGB(0x808080)
#define THF8F8F8 UIColorFromRGB(0xF8F8F8)


@interface THCustomRollView () <UIScrollViewDelegate>
{
    UIScrollView *scrollview;
    
}
/**
 *  当前选中的第几个,下标从0 开始
 */
@property(nonatomic,assign)NSInteger selectIndex;

@end

@implementation THCustomRollView
#pragma mark LifeCyle
-(instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {

        self = [super initWithFrame:frame];
        
        if (self) {
            
            
            
            scrollview = ({
                NSInteger  kbuttonWidth =  DEVICE_SCREEN_WIDTH /3;
                
                UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(kbuttonWidth, 0,kbuttonWidth , frame.size.height)];
                scroll.pagingEnabled = YES;
//                scroll.layer.borderColor = [ UIColor yellowColor].CGColor;
//                scroll.layer.borderWidth  = 1;
                scroll.showsVerticalScrollIndicator = NO;
                scroll.showsHorizontalScrollIndicator = NO;
                scroll.delegate  = self;
                scroll.clipsToBounds = NO;
                scroll;
            });
            
            self.selectIndex = 0;
            [self addSubview:scrollview];
            self.clipsToBounds = YES;
        }
    }
        return self;
    
}

#pragma mark -
#pragma mark Setter Method
-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    for (UIView *view  in scrollview.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    NSInteger  kbuttonWidth =  DEVICE_SCREEN_WIDTH /3;
    scrollview.contentSize = CGSizeMake(kbuttonWidth * titleArray.count,  self.frame.size.height);
    
    for (int i=0; i<titleArray.count; i++) {
        
        double x = i*kbuttonWidth;
        double y = 0;
        double w = kbuttonWidth;
        double h = self.frame.size.height;
        CGRect frame = CGRectMake(x, y, w, h);
        UIButton *btn =  [self createButtonWithTitle:titleArray[i] frame:frame];
        btn.tag = 100+i;
        if (i==0) {
            btn.titleLabel.font = [UIFont systemFontOfSize:19];
            [btn setTitleColor:TH0086D1 forState:UIControlStateNormal];
        }
        [scrollview addSubview:btn];
        
    }

}
#pragma mark 设置当前下表

-(void)showTitleIndex:(NSInteger)index;
{
    NSTimeInterval delayInSeconds = 0.7;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIButton *button = (UIButton*)[self viewWithTag:100+index];
        button.tag = 100 + index;
        [self btnclick:button];

   });
}
#pragma mark Privite Method
#pragma mark 创建按钮
-(UIButton*)createButtonWithTitle:(NSString*)title frame:(CGRect)frame
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitleColor:TH808080 forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:THF8F8F8];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    return btn;
}

#pragma mark button 点击事件
-(void)btnclick:(UIButton*)currentButton
{

    NSLog(@"点击了第==%ld",(long)currentButton.tag-100);
    
    NSInteger buttonIndex = currentButton.tag - 100;

    //记录上次选择的那个
    UIButton *button = (UIButton*)[self viewWithTag:100+self.selectIndex];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:TH808080 forState:UIControlStateNormal];
    
    self.selectIndex = buttonIndex;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        currentButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [currentButton setTitleColor:TH0086D1 forState:UIControlStateNormal];

    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(THCustomRollViewScrollerIndex:)]) {
        
        [self.delegate THCustomRollViewScrollerIndex:buttonIndex];
    }
    NSInteger  kbuttonWidth =  DEVICE_SCREEN_WIDTH /3;
    [scrollview setContentOffset:CGPointMake(buttonIndex*kbuttonWidth , 0) animated:YES];

}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event  {
    
     UIView *view = [super hitTest:point withEvent:event];
     if ([view isEqual:self])
     {
         for (UIView *subview in scrollview.subviews)
         {
             CGPoint offset = CGPointMake(point.x - scrollview.frame.origin.x + scrollview.contentOffset.x - subview.frame.origin.x,
                                          point.y - scrollview.frame.origin.y + scrollview.contentOffset.y - subview.frame.origin.y);
             if ((view = [subview hitTest:offset withEvent:event]))
             {
                 return view;
             }
         }
         return scrollview;
     }
     return view;
 }

#pragma mark Delegate-
#pragma mark ScrollerViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float scrollerOffsetWidth = scrollview.contentOffset.x;
    
    NSLog(@"===%f",scrollerOffsetWidth);
    
    NSInteger  kbuttonWidth =  DEVICE_SCREEN_WIDTH /3;
    NSInteger  scrollIndex = (scrollerOffsetWidth / kbuttonWidth);
    
    //上次选择的那个初始化
    UIButton *button =(UIButton*) [self viewWithTag:100+self.selectIndex];
    
    self.selectIndex = scrollIndex;
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:TH808080 forState:UIControlStateNormal];
    
    UIButton *currentBtn = (UIButton*)[self viewWithTag:100+scrollIndex];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [currentBtn setTitleColor:TH0086D1 forState:UIControlStateNormal];

    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(THCustomRollViewScrollerIndex:)]) {
        
        [self.delegate THCustomRollViewScrollerIndex:scrollIndex];
    }
   
}
@end
