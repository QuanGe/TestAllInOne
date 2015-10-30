//
//  PMImageCollectionFlowLayout.m
//  programmermag
//
//  Created by 张如泉 on 15/10/30.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMImageCollectionFlowLayout.h"

@implementation PMImageCollectionFlowLayout
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {

    
    /*int contentX = self.collectionView.contentOffset.x-self.headerReferenceSize.width;
    int contentXChange = contentX%((int)self.itemSize.width);
    int frontNum = (contentX-contentXChange)/((int)self.itemSize.width);
    BOOL canNext = contentXChange>(((int)self.itemSize.width)/2);
    
    int pageIndex = 0;
    if(velocity.x==0)
        pageIndex= frontNum +(canNext?1:0);
    else
    {
        pageIndex = frontNum+(velocity.x>0?1:-1);
    }
    if(pageIndex <0)
        pageIndex = 0;
    CGFloat theLeft = pageIndex*470;
    proposedContentOffset.x = theLeft;
*/
    /*
    CGFloat approximatePage = self.collectionView.contentOffset.x / self.pageWidth;
    
    CGFloat currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage);
    
    NSInteger flickedPages = ceil(velocity.x / self.flickVelocity);
    
    if (flickedPages) {
        proposedContentOffset.x = (currentPage + flickedPages) * self.pageWidth;
    } else {
        proposedContentOffset.x = currentPage * self.pageWidth;
    }*/
    
    //return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
    
    // 计算最终的可见范围
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    
    // 取得cell的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最终中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 计算最小的间距值
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDetal) > ABS(attrs.center.x - centerX)) {
            minDetal = attrs.center.x - centerX;
        }
    }
    
    // 在原有offset的基础上进行微调
    return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
}
@end
