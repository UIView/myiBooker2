//
//  DYLoadGuideView.h
//  DevelopDemo
//
//  Created by Yahui Duan on 15/9/11.
//  Copyright (c) 2015年 DuanYahui. All rights reserved.
//

#import <UIKit/UIKit.h>
/// DYLoadGuideView hide
extern NSString *const DYLoadGuideViewDisappearNotification;

@interface DYLoadGuideView : UIView<UIScrollViewDelegate>
///  是否拖滑动最后一引导页消失,默认YES
@property(nonatomic,unsafe_unretained) BOOL endScrollHide;
/// 定义PageControl更新样式
@property UIPageControl *pageC;
/// 定义更新样式，无须实现action。
@property UIButton  *updateButton;

/**
 *  初始化一个引导页
 *
 *  @param ViewController 需要显示引导页VC
 *  @param images         引导页图片数组
 *  @param loadGuideKey   标记是不是第一次启动展示key ,如果引导页图片变更了，key 必须变更。
 */
//+(instancetype)initLoadGuideVCFrom:(id)ViewController withImageDatas:(NSArray *)images withKey:(NSString *)loadGuideKey;

/**
 *  初始化一个引导页 , 显示到当前的 window 页面上。
 *
 *  @param images         引导页图片数组
 *  @param loadGuideKey   标记是不是第一次启动展示key ,如果引导页图片变更了，key 必须变更。
 */
+(instancetype)initLoadGuideVCWithImageDatas:(NSArray *)images withKey:(NSString *)loadGuideKey;
@end
