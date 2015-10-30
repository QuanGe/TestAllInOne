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

    
    int contentX = self.collectionView.contentOffset.x;
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
    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
    
   
}
@end
