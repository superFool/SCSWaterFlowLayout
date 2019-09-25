//
//  SCSWaterFlowLayout.m
//  WaterFlowDemo
//
//  Created by chaoshuai song on 2019/9/25.
//  Copyright © 2019 com.zczy. All rights reserved.
//

#import "SCSWaterFlowLayout.h"



#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface SCSWaterFlowLayout ()
/** 列数 */
@property (nonatomic, assign)NSInteger columnCount;
/** 列间距 */
@property (nonatomic, assign)float columnMargin;
/** 行间距 */
@property (nonatomic, assign)float rowMargin;
/** 内边距 */
@property (nonatomic, assign)UIEdgeInsets contentInsets;
/** 存所有item的布局对象 */
@property (nonatomic, strong)NSMutableArray * attrisArr;
/** 存每列的高度 */
@property (nonatomic, strong)NSMutableArray * columnHeights;
/** content高度 */
@property (nonatomic, assign)float contentHeight;

@end

static const NSInteger      SCSDefaultColumnCount = 3;
static const float          SCSDefaultColumnMargin = 10.0f;
static const float          SCSDefaultRowMargin = 10.0f;
static const UIEdgeInsets   SCSDefaultContentInsets = {10 ,15 ,10 ,15};



@implementation SCSWaterFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    _attrisArr = [NSMutableArray array];
    _columnHeights = [NSMutableArray array];
    for (int i = 0; i < self.columnCount; i++) {
        [_columnHeights addObject:@(10)];
    }
    _contentHeight = 0;
    [_attrisArr removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i =0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attri = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attrisArr addObject:attri];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attrisArr;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算每列宽度
    float w = (ScreenWidth - self.contentInsets.left - self.contentInsets.right - (self.columnCount -1)*self.columnMargin)*1.0f/self.columnCount;
    //获取cell高度 这里不做容错处理 这个方法必须实现
    float h = [self.delegate waterFlowLayout:self itemHeightAtIndex:indexPath width:w];
    //查找高度最低的行的位置并记录高度(计算cell的y)
    NSInteger index = 0;
    float minHeight = [self.columnHeights[index] floatValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        float currentHeight = [self.columnHeights[i] floatValue];
        index = minHeight <= currentHeight ? index : i;
        minHeight = [self.columnHeights[index] floatValue];
    }
    
    float y = minHeight;
    if (fabs(minHeight - self.contentInsets.top) > 1e-3) {
        y += self.rowMargin;
    }
    //计算cell的x
    float x = self.contentInsets.left + index * (w + self.columnMargin);
    //设置当前cell的frame
    attri.frame = CGRectMake(x, y, w, h);
    //更新最低高度
    self.columnHeights[index] = @(CGRectGetMaxY(attri.frame));
    //更新contentHeight
    if (self.contentHeight < [self.columnHeights[index] floatValue] + self.contentInsets.bottom) {
        self.contentHeight = [self.columnHeights[index] floatValue] + self.contentInsets.bottom;
    }
    return attri;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.contentHeight);
}



- (NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountForWaterFlowLayout:)]) {
        return [self.delegate columnCountForWaterFlowLayout:self];
    }
    return SCSDefaultColumnCount;
}
- (float)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginForWaterFlowLayout:)]) {
        return [self.delegate columnMarginForWaterFlowLayout:self];
    }
    return SCSDefaultColumnMargin;
}

- (float)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginForWaterFlowLayout:)]) {
        return [self.delegate rowMarginForWaterFlowLayout:self];
    }
    return SCSDefaultRowMargin;
}

- (UIEdgeInsets)contentInsets{
    if ([self.delegate respondsToSelector:@selector(contentInsetForWaterFlowLayout:)]) {
        return [self.delegate contentInsetForWaterFlowLayout:self];
    }
    return SCSDefaultContentInsets;
}

@end
