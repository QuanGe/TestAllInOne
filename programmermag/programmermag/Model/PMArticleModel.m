//
//  PMArticleModel.m
//  programmermag
//
//  Created by 张如泉 on 15/11/2.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMArticleModel.h"
#import <CoreText/CoreText.h>

@implementation PMArticleModel

-(void)buildHeaderStr
{
    
    self.headerStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    {
        NSString * titleFont= [UIFont boldSystemFontOfSize:30].fontName;
        CTFontRef titleFontRef = CTFontCreateWithName((CFStringRef)titleFont,
                                                      30.0f, NULL);
        
        NSDictionary* titleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)[UIColor blackColor], NSForegroundColorAttributeName,
                                    (__bridge id)titleFontRef, kCTFontAttributeName,
                                    
                                    nil];
        [self.headerStr appendAttributedString:[[NSAttributedString alloc] initWithString:self.titile attributes:titleAttrs]];
        
        if(self.subTitile != nil)
        {
            NSString * subTitleFont= [UIFont boldSystemFontOfSize:25].fontName;
            CTFontRef subTitleFontRef = CTFontCreateWithName((CFStringRef)subTitleFont,
                                                             25.0f, NULL);
            NSDictionary* subTitleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                           (id)[UIColor blackColor], NSForegroundColorAttributeName,
                                           (__bridge id)subTitleFontRef, kCTFontAttributeName,
                                           
                                           nil];
            [self.headerStr appendAttributedString:[[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:self.subTitile]  attributes:subTitleAttrs] ];
        }
        if(self.editor != nil)
        {
            NSString * editorFont= [UIFont systemFontOfSize:14].fontName;
            CTFontRef editorFontRef = CTFontCreateWithName((CFStringRef)editorFont,
                                                           17.0f, NULL);
            NSDictionary* editorAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                         (id)[UIColor grayColor], NSForegroundColorAttributeName,
                                         (__bridge id)editorFontRef, kCTFontAttributeName,
                                         
                                         nil];
            [self.headerStr appendAttributedString:[[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:self.editor]  attributes:editorAttrs] ];
            
        }
        
    }
    
}

@end
