//
//  SCSWaterFlowLayout.h
//  WaterFlowDemo
//
//  Created by chaoshuai song on 2019/9/25.
//  Copyright © 2019 com.zczy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SCSWaterFlowLayout;

@protocol SCSWaterFlowDelegate <NSObject>

@required
/** 返回indexPath对应的item高度 */
- (float)waterFlowLayout:(SCSWaterFlowLayout *)layout itemHeightAtIndex:(NSIndexPath *)indexPatch width:(float)itemWidth;

@optional
- (float)columnCountForWaterFlowLayout:(SCSWaterFlowLayout *)layout;
- (float)columnMarginForWaterFlowLayout:(SCSWaterFlowLayout *)layout;
- (float)rowMarginForWaterFlowLayout:(SCSWaterFlowLayout *)layout;
- (UIEdgeInsets)contentInsetForWaterFlowLayout:(SCSWaterFlowLayout *)layout;


@end





@interface SCSWaterFlowLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak)id<SCSWaterFlowDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
