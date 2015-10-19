//
//  UIView+VFL.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/8.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "UIView+VFL.h"

@implementation UIView (VFL)

/**
 *  以VFL方式实现自动布局
 *  @param  parentView:父view
 *  @param  rect:左上边距 和 宽高
 *  @param  margin:右下边距
 *  return  所有Constraints组成的数组NSArray
 */
- (NSArray *)qgocc_configConstraintsWithParentView:(UIView *)parentView rect:(CGRect)rect marginRightAndBottom:(CGPoint)margin
{
    
    if([parentView.subviews containsObject:self])
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //Hvfl与Vvfl分别是水平方向与垂直方向的约束
        NSString *Hvfl = rect.size.width == 0.0? @"H:|-marginLeft-[self]-marginRight-|" : @"H:|-marginLeft-[self(rectWidth)]";
        NSString *Vvfl = rect.size.height == 0.0? @"V:|-marginTop-[self]-marginBottom-|" : @"V:|-marginTop-[self(rectHeight)]";
        //设置margin的数值
        NSDictionary *metrics = @{ @"marginLeft":@(rect.origin.x).stringValue,@"marginRight":@(margin.x).stringValue,@"marginTop":@(rect.origin.y).stringValue,@"marginBottom":@(margin.y).stringValue,@"rectWidth":@(rect.size.width).stringValue,@"rectHeight":@(rect.size.height).stringValue};
        
        //把要添加约束的View转成字典
        NSDictionary *views = NSDictionaryOfVariableBindings(self);//这个方法会自动把传入的参数以字典的形式返回，字典的KEY就是其本身的名字
        //如@{@"redView"：redView}
        
        //添加对齐方式，
        NSLayoutFormatOptions ops = NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllTop;//左边与顶部
        
        NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:ops metrics:metrics views:views];
        
        NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:ops metrics:metrics views:views];
        //self.view分别添加水平与垂直方向的约束
        [parentView addConstraints:Hconstraints];
        [parentView addConstraints:Vconstraints];
        
        NSMutableArray * array = [[NSMutableArray alloc] initWithArray:Hconstraints];
        [array addObjectsFromArray:Vconstraints];
        return array;
    }
    else
    {
        NSLog(@"必须将%@添加到%@",self,parentView);
        return nil;
    }
    
    
}
@end
