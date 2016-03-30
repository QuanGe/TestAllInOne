//
//  UIAlertView+QGOCCBlock.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "UIAlertView+QGOCCBlock.h"
#import <objc/runtime.h>

@implementation UIAlertView (QGOCCBlock)

/**
 *  弹框 点击事件以block实现
 *  @param  title:弹框标题
 *  @param  message:弹框内容
 *  @param  style:弹框样式
 *  @param  cancelButtonTitle:取消按钮上的文字
 *  @param  otherButtonTitles:其他按钮上的文字
 *  @param  tapBlock:点击block
 *  return  点击事件以block实现的弹框
 */
+ (instancetype)qgocc_showWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(qgocc_UIAlertViewTapBlock)tapBlock {
    
    NSString *firstObject = otherButtonTitles.count ? otherButtonTitles[0] : nil;
    
    UIAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:firstObject, nil];
    
    alertView.alertViewStyle = style;
    
    if (otherButtonTitles.count > 1) {
        for (NSString *buttonTitle in [otherButtonTitles subarrayWithRange:NSMakeRange(1, otherButtonTitles.count - 1)]) {
            [alertView addButtonWithTitle:buttonTitle];
        }
    }
    
    if (tapBlock) {
        alertView.qgocc_tapBlock = tapBlock;
    }
    
    [alertView show];
    
#if !__has_feature(objc_arc)
    return [alertView autorelease];
#else
    return alertView;
#endif
}

/**
 *  弹框 点击事件以block实现
 *  @param  title:弹框标题
 *  @param  message:弹框内容
 *  @param  cancelButtonTitle:取消按钮上的文字
 *  @param  otherButtonTitles:其他按钮上的文字
 *  @param  tapBlock:点击block
 *  return  点击事件以block实现的弹框
 */
+ (instancetype)qgocc_showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(qgocc_UIAlertViewTapBlock)tapBlock {
    
    return [self qgocc_showWithTitle:title
                       message:message
                         style:UIAlertViewStyleDefault
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:otherButtonTitles
                      tapBlock:tapBlock];
}

- (qgocc_UIAlertViewTapBlock)qgocc_tapBlock {
    return objc_getAssociatedObject(self, @selector(qgocc_tapBlock));
}

- (void)setQgocc_tapBlock:(qgocc_UIAlertViewTapBlock)tapBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, @selector(qgocc_tapBlock), tapBlock, OBJC_ASSOCIATION_COPY);
}

- (void)_checkAlertViewDelegate {
    if (self.delegate != (id<UIAlertViewDelegate>)self) {
        objc_setAssociatedObject(self, @selector(_checkAlertViewDelegate), self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIAlertViewDelegate>)self;
    }
}


- (void)willPresentAlertView:(UIAlertView *)alertView {
    id originalDelegate = objc_getAssociatedObject(self, @selector(_checkAlertViewDelegate));
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [originalDelegate willPresentAlertView:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    id originalDelegate = objc_getAssociatedObject(self, @selector(_checkAlertViewDelegate));
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [originalDelegate didPresentAlertView:alertView];
    }
}


- (void)alertViewCancel:(UIAlertView *)alertView {
    id originalDelegate = objc_getAssociatedObject(self, @selector(_checkAlertViewDelegate));
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewCancel:)]) {
        [originalDelegate alertViewCancel:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    qgocc_UIAlertViewTapBlock completion = alertView.qgocc_tapBlock;
    
    if (completion) {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, @selector(_checkAlertViewDelegate));
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    id originalDelegate = objc_getAssociatedObject(self, @selector(_checkAlertViewDelegate));
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [originalDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    id originalDelegate = objc_getAssociatedObject(self, @selector(_checkAlertViewDelegate));
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [originalDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    id originalDelegate = objc_getAssociatedObject(self, @selector(_checkAlertViewDelegate));
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [originalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    
    return YES;
}
@end
