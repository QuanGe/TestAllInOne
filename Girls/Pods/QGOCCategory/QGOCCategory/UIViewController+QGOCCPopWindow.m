//
//  UIViewController+QGOCCPopWindow.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/11.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "UIViewController+QGOCCPopWindow.h"
#import "UIView+QGOCCVFL.h"
#import <objc/objc.h>
#import <objc/runtime.h>
@implementation UIViewController (QGOCCPopWindow)
- (void)setQgocc_popBoxView:(UIView *)popBoxView {
    objc_setAssociatedObject(self, @selector(qgocc_popBoxView),
                             popBoxView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)qgocc_popBoxView {
    return objc_getAssociatedObject(self,  @selector(qgocc_popBoxView));
}

- (void)setQgocc_presentingVC:(UIViewController *)presentingVC {
    objc_setAssociatedObject(self,  @selector(qgocc_presentingVC),
                             presentingVC,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)qgocc_presentingVC {
    return objc_getAssociatedObject(self, @selector(qgocc_presentingVC));
}

/**
 *  创建显示层,第一步要做的就是这个，可以写在[super loadView]的下面
 *  return  无
 */
- (void)qgocc_buildPopBoxView
{
    
    self.view.superview.frame=[[UIScreen mainScreen] bounds];
    self.view.superview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor =[UIColor clearColor];
    UIControl * backgroundView=[[UIControl alloc] init];
    {
        [self.view addSubview:backgroundView];
        backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [backgroundView addTarget:self action:@selector(onPopoverDismissAction:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView qgocc_configConstraintsWithParentView:self.view rect:CGRectMake(0, 0, 0, 0) marginRightAndBottom:CGPointZero];
    }
    
    self.qgocc_popBoxView = [[UIView alloc] init];
    {
        self.qgocc_popBoxView.backgroundColor=[UIColor whiteColor];
        self.qgocc_popBoxView.layer.cornerRadius=5;
        [self.view addSubview:self.qgocc_popBoxView];
        
        [self.qgocc_popBoxView qgocc_configConstraintsWithParentView:self.view rect:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.25, self.view.frame.size.width*0.8, self.view.frame.size.height*0.5) marginRightAndBottom:CGPointZero];
       
        
        UIView *topBarView=[[UIView alloc] init];
        {
            topBarView.tag = 100;
            //topBarView.backgroundColor = [UIColor yellowColor];
            [self.qgocc_popBoxView addSubview:topBarView];
            [topBarView qgocc_configConstraintsWithParentView:self.qgocc_popBoxView rect:CGRectMake(0, 0, 0, 60) marginRightAndBottom:CGPointZero];
            
            UILabel * titileLabel = [[UILabel alloc] init];
            {
                titileLabel.textAlignment = NSTextAlignmentCenter;
                titileLabel.font = [UIFont systemFontOfSize:22];
                [topBarView addSubview:titileLabel];
                titileLabel.tag = 1000;
                
                [titileLabel qgocc_configConstraintsWithParentView:topBarView rect:CGRectMake(70, 0, 0, 0) marginRightAndBottom:CGPointMake(70, 0)];
               
            }
            UIView * line = [[UIView alloc] init];
            {
                [topBarView addSubview:line];
                line.backgroundColor =[UIColor lightGrayColor];
                NSArray * constraints = [line qgocc_configConstraintsWithParentView:topBarView rect:CGRectMake(0, 55.0, 0, 1.0) marginRightAndBottom:CGPointZero];
                for (NSLayoutConstraint * obj in constraints) {
                    if(obj.constant == 1.0)
                        obj.constant = 0.5;
                }
            }
            
        }
        
        
        
        
    }
    
    [self qgocc_addKeyboardNotificationObserver];
    
    {
        SEL viewWillAppear = sel_registerName("viewWillAppear:");
        Method dea = class_getInstanceMethod(object_getClass(self), viewWillAppear);
        Method qgocc_viewWillAppear = class_getInstanceMethod(object_getClass(self), @selector(qgocc_ViewWillAppear:));
        method_exchangeImplementations(dea, qgocc_viewWillAppear);
    }
    
    {
        SEL viewWillLayoutSubviews = sel_registerName("viewWillLayoutSubviews");
        Method dea = class_getInstanceMethod(object_getClass(self), viewWillLayoutSubviews);
        Method qgocc_viewWillLayoutSubviews = class_getInstanceMethod(object_getClass(self), @selector(qgocc_viewWillLayoutSubviews));
        method_exchangeImplementations(dea, qgocc_viewWillLayoutSubviews);
        
    }
    
}

/**
 *  返回
 *  @param  flag:是否有动画
 *  @param  completion:是否有完成block
 *  return  无
 */
-(void)qgocc_dismissViewController:(BOOL)flag completion:(void (^)(void))completion{
    
    [self removeNotification];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.qgocc_popBoxView.transform=CGAffineTransformMakeScale(0.001, 0.001);
        self.qgocc_popBoxView.alpha=0.f;
    } completion:^(BOOL finish){
        [self dismissViewControllerAnimated:flag completion:completion];
    }];
}

-(void)onPopoverDismissAction:(UIControl *)controlView{
    
    [self qgocc_dismissViewController:NO completion:nil];
}

/**
 *  添加键盘监控，当弹出键盘时弹框界面上移
 *  return  无
 */
-(void)qgocc_addKeyboardNotificationObserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notif {
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         self.qgocc_popBoxView.transform=CGAffineTransformMakeTranslation(0, -100);
                     }
                     completion:NULL];
}

- (void)keyboardShow:(NSNotification *)notif {
    
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         self.qgocc_popBoxView.transform=CGAffineTransformIdentity;
                         
                     }
                     completion:NULL];
}

- (void)keyboardHide:(NSNotification *)notif {
    
    
}


-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidHideNotification];
}

/**
 *  设置弹框层的标题
 *  @param  title:标题
 *  return  无
 */
- (void)qgocc_updateTitle:(NSString*)title
{
    if(self.qgocc_popBoxView == nil)
        return;
    ((UILabel*)[[self.qgocc_popBoxView viewWithTag:100] viewWithTag:1000]).text =  title;
    
}

/**
 *  在最上面标题栏的view添加子控件
 *  @param  sub:子控件
 *  return  无
 */
- (void)qgocc_addTopSubView:(UIView*)sub
{
    [[self.qgocc_popBoxView viewWithTag:100] addSubview:sub];
    
}

/**
 *  在当前页面弹出此弹框
 *  @param  presentingVC:当前页面
 *  return  无
 */
- (void)qgocc_presentedByPresentingVC:(UIViewController*)presentingVC
{
    
    self.preferredContentSize=CGSizeMake(self.view.frame.size.width*0.8, self.view.frame.size.height*0.5);
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.qgocc_presentingVC = presentingVC;
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
    if([[[[UIDevice currentDevice] systemVersion]substringToIndex:1] floatValue] >= 8.0)
    {
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
#endif

    [presentingVC presentViewController:self animated:NO completion:NULL];
    
}

-(void)qgocc_ViewWillAppear:(BOOL)animated{
    [self qgocc_ViewWillAppear:animated];
    [self qgocc_popupAnimationWithSpring];
}

/**
 *  当要显示的时候需要有个动画可以在viewWillAppear中做此动作
 *  return  无
 */
-(void)qgocc_popupAnimationWithSpring{
    self.qgocc_popBoxView.transform=CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.qgocc_popBoxView.transform=CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finish){
    }];
    
}

-(void)qgocc_viewWillLayoutSubviews{
    
    [self qgocc_viewWillLayoutSubviews];
    [self qgocc_viewWillLayout];
}

/**
 *  更新背景颜色 和大小 在viewWillLayoutSubviews中调用
 *  return  无
 */
- (void)qgocc_viewWillLayout
{
    self.view.superview.frame=[[UIScreen mainScreen] bounds];
    self.view.superview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor =[UIColor clearColor];
}
@end
