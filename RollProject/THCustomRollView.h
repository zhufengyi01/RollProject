//
//  myScrollerView.h
//  RollProject
//
//  Created by 朱封毅 on 24/01/16.
//  Copyright © 2016年 tairan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@protocol THCustomRollViewDelegate <NSObject>

-(void)THCustomRollViewScrollerIndex:(NSInteger) index;

@end
@interface THCustomRollView : UIView

@property(nonatomic,weak)id <THCustomRollViewDelegate> delegate;

/**
 *  添加按钮
 *
 *  @param titleArray
 */
@property(nonatomic,strong)NSArray *titleArray;



/**
 *  设置当前下表
 *
 *  @param index 下标
 */
-(void)showTitleIndex:(NSInteger)index;


@end
