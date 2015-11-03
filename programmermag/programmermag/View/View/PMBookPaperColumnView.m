//
//  PMBookPaperColumnView.m
//  programmermag
//
//  Created by 张如泉 on 15/11/3.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookPaperColumnView.h"
#import <CoreText/CoreText.h>
@implementation PMBookPaperColumnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((CTFrameRef)self.ctFrame, context);
    
    for (NSArray* imageData in self.images) {
        UIImage* img = [imageData objectAtIndex:0];
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
}
@end
