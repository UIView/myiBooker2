//
//  DYLoadGuideView.m
//  DevelopDemo
//
//  Created by Yahui Duan on 15/9/11.
//  Copyright (c) 2015年 DuanYahui. All rights reserved.
//

#import "DYLoadGuideView.h"

#define DYLAST_LOAD_GUIDE_KEY @"LastLoadGuideKey"
#define DYLAST_SCROLLVIEW_TAG 1800
#define DYLAST_IMAGEVIEW_TAG  1900
NSString *const DYLoadGuideViewDisappearNotification = @"DYLoadGuideViewDisappearNotification";
@interface DYLoadGuideView ()

@property(nonatomic,strong)NSArray  *imageArray;  // 引导页需要展示 图像数组

//@property(nonatomic,strong)UIScrollView *dyScrollView;
@property(nonatomic,strong)NSString *loadGuideKey; //  引导页 loadGuideKey

@end

@implementation DYLoadGuideView


-(void)dealloc
{
    self.imageArray=nil;
    self.pageC=nil;
    self.loadGuideKey=nil;
//    NSLog(@"DYLoadGuide dealloc");
}

+(instancetype)initLoadGuideVCWithImageDatas:(NSArray *)images withKey:(NSString *)loadGuideKey{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    BOOL isShowPage =[userDefaults boolForKey:loadGuideKey];
    
    if (!isShowPage) {
        DYLoadGuideView  *guideVC=[[DYLoadGuideView alloc] init];
        [DYLoadGuideView  removeLastLoadGuideKey:loadGuideKey];//删除之前记录的bool值
        guideVC.endScrollHide=YES;
        guideVC.imageArray=images;
        guideVC.loadGuideKey = loadGuideKey;
        
        UIWindow *tempWindow = [[UIApplication sharedApplication] keyWindow];
        guideVC.frame=tempWindow.frame;
        [tempWindow addSubview:guideVC];
        
        [guideVC loadGuideView];
        return guideVC;
    }
    return nil;
}

+(instancetype)initLoadGuideVCFrom:(id)ViewController withImageDatas:(NSArray *)images withKey:(NSString *)loadGuideKey{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    BOOL isShowPage =[userDefaults boolForKey:loadGuideKey];
   
    if (!isShowPage) {
        DYLoadGuideView  *guideVC=[[DYLoadGuideView alloc] init];

        [DYLoadGuideView  removeLastLoadGuideKey:loadGuideKey];//删除之前记录的bool值
        guideVC.endScrollHide=YES;
        guideVC.imageArray=images;
        guideVC.loadGuideKey = loadGuideKey;
        
        if ([ViewController isKindOfClass:[UIViewController class]]) {
            UIViewController *testViewController = (UIViewController *)ViewController;
            if (testViewController.navigationController) {
                ViewController=testViewController.navigationController;
            }
            if ([testViewController.parentViewController isKindOfClass:[UITabBarController class]]) {
                ViewController=testViewController.parentViewController;
            }
            guideVC.frame=testViewController.view.bounds;
            [testViewController.view addSubview:guideVC];
            [testViewController.view bringSubviewToFront:guideVC];
        }
        if (ViewController==nil) {
            UIWindow *tempWindow = [[UIApplication sharedApplication] keyWindow];
            guideVC.frame=tempWindow.frame;
            [tempWindow addSubview:guideVC];
        }
        
        [guideVC loadGuideView];
         return guideVC;
    }
    return nil;
}
#pragma mark loadGuideView
//加载引导页
-(void)loadGuideView
{
    
    CGRect screnFrame=[[UIScreen mainScreen] bounds];
    CGFloat screnWidth = CGRectGetWidth(screnFrame);
    CGFloat screnHight = CGRectGetHeight(screnFrame);
    
    NSInteger imgCount=[self.imageArray count];
    
    self.pageC=[[UIPageControl alloc] initWithFrame:CGRectMake(0,screnHight-80, screnWidth, 20)];
    self.pageC.numberOfPages=imgCount;
    self.pageC.currentPage=0.;
    //    self.pageC.hidden=YES;
    
    self.pageC.backgroundColor=[UIColor clearColor];
    UIScrollView *dyScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screnWidth, screnHight)];
    dyScrollView.tag = DYLAST_SCROLLVIEW_TAG;
    dyScrollView.delegate=self;
    dyScrollView.contentSize=CGSizeMake(screnWidth*imgCount, screnHight);
    dyScrollView.showsVerticalScrollIndicator=NO;
    dyScrollView.pagingEnabled=YES;        //按页浏览
    dyScrollView.bounces=NO;               //取消弹性
    dyScrollView.showsHorizontalScrollIndicator=NO;
    [self addSubview:dyScrollView ];
    [self addSubview:self.pageC];
    for (int i=0; i<imgCount; i++)
    {
        NSString *imgName=[self.imageArray objectAtIndex:i];
        UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame=CGRectMake(i*screnWidth, 0, screnWidth, screnHight);
        imgView.tag=DYLAST_IMAGEVIEW_TAG+i;
        if (i==(imgCount-1))
        {
            [imgView setUserInteractionEnabled:YES];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            float width=170;
            float y_frame=CGRectGetHeight(screnFrame)-50;
            float x_frame=(CGRectGetWidth(screnFrame)-170)/2;

            button.frame=CGRectMake(x_frame, y_frame, width, 40);
            [button setBackgroundImage:[UIImage imageNamed:@"guide_btn_nomal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"guide_btn_highlight"] forState:UIControlStateHighlighted];
            //            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            //            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            //            [button setTitle:@"马上体验" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:button];
            self.updateButton=button;
            if (_endScrollHide) {
                imgView.userInteractionEnabled=YES;
                UIPanGestureRecognizer *swipeG=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizerAction:)];
                [imgView addGestureRecognizer:swipeG];
                
                UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizerAction:)];
                  [imgView addGestureRecognizer:tapG];

            }
        }
        
        [dyScrollView addSubview:imgView];
    }
}
- (void)setEndScrollHide:(BOOL)endScrollHide{
    _endScrollHide=endScrollHide;
    if (!endScrollHide) {
        if (self.imageArray.count>0) {
            NSInteger lastPage = self.imageArray.count-1;
            UIScrollView *scrollView=(UIScrollView *)[self viewWithTag:DYLAST_SCROLLVIEW_TAG];
            UIView *subView =[scrollView viewWithTag:DYLAST_IMAGEVIEW_TAG+lastPage];
            for (UIGestureRecognizer *gesture in subView.gestureRecognizers) {
                [subView removeGestureRecognizer:gesture];
            }
        }
    }
}
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger currentPage = offset.x / bounds.size.width;
    [self.pageC setCurrentPage:currentPage];
    if (currentPage==self.imageArray.count-1&&self.imageArray.count>0) {
        UIView *subView =[scrollView viewWithTag:DYLAST_IMAGEVIEW_TAG+currentPage];
        subView.userInteractionEnabled=YES;
    }
}
#pragma mark swipeGesture
-(void)swipeGestureRecognizerAction:(UIGestureRecognizer *)recognizer{
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIView *topContentView=[recognizer view];
        UIPanGestureRecognizer *recognizerTemp=(UIPanGestureRecognizer *)recognizer;
        CGPoint currentPoint = [recognizerTemp translationInView:topContentView];
        
        switch (recognizerTemp.state) {
            case UIGestureRecognizerStateBegan:{
                if (currentPoint.x>0) {
                    topContentView.userInteractionEnabled=NO;
                }
            }
                break;
            case UIGestureRecognizerStateChanged:
                break;
            case UIGestureRecognizerStateEnded:
            {
                if (currentPoint.x>0&&self.imageArray.count>1) {
                    NSInteger page =self.imageArray.count -2;
                    UIScrollView *dyScrollView= (UIScrollView *)[self viewWithTag:DYLAST_SCROLLVIEW_TAG];
                    [dyScrollView setContentOffset:CGPointMake(page*dyScrollView.frame.size.width, 0) animated:YES];
                    [self.pageC setCurrentPage:page];
                }else{
                  [self hideView];
                }

            }
                break;
            default:
            break;
        }
    }else{
     [self hideView];
    }
    
}
#pragma mark Remove View
-(void)hideView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DYLoadGuideViewDisappearNotification object:nil];

    [self saveLastLoadGuideKey];
    NSInteger anTime =1;
    [UIView animateWithDuration:anTime animations:^{
        self.alpha=0;
        for (UIView *subView in self.subviews) {
            subView.alpha=0;
            [subView removeFromSuperview];
        }
    }];
    [self performSelector:@selector(removeLoadGuideView) withObject:nil afterDelay:anTime];
    
}

-(void)removeLoadGuideView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];// performSelector 可能泄漏
    [self.pageC removeFromSuperview];
    [self removeFromSuperview];
}
#pragma mark userDefaults
// 记住引导页是否展示过。
-(void)saveLastLoadGuideKey{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:self.loadGuideKey];
    [userDefaults setObject:self.loadGuideKey forKey:DYLAST_LOAD_GUIDE_KEY];
    [userDefaults synchronize];
}
//
+(void)removeLastLoadGuideKey:(NSString *)tempKeyString{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    NSString *lastKey =[userDefaults objectForKey:DYLAST_LOAD_GUIDE_KEY];
    if (![tempKeyString isEqualToString:lastKey]&&lastKey) {
        [userDefaults removeObjectForKey:lastKey];
    }
}


@end
