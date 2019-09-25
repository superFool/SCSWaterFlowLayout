//
//  ViewController.m
//  WaterFlowDemo
//
//  Created by chaoshuai song on 2019/9/25.
//  Copyright © 2019 com.zczy. All rights reserved.
//

#import "ViewController.h"
#import "SCSWaterFlowLayout.h"

@interface ViewController ()<SCSWaterFlowDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

/** 数据源 */
@property (nonatomic, strong)NSMutableArray * dataSourceArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    SCSWaterFlowLayout *waterFlowLayout = [[SCSWaterFlowLayout alloc] init];
    waterFlowLayout.delegate = self;
    
    
    
    
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:waterFlowLayout];
    cv.dataSource = self;
    cv.delegate = self;
    [cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:cv];
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
        for (int i = 0; i < 100; i++) {
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            NSInteger rand = arc4random()%10;
            float scale = rand*1.0/5 + 0.1;
            UIColor *color = [UIColor colorWithRed:(arc4random()%255*1.0)/255 green:(arc4random()%255*1.0)/255 blue:(arc4random()%255*1.0)/255 alpha:1.0];
            [mDic setValue:@(scale) forKey:@"scale"];
            [mDic setValue:color forKey:@"color"];
            [_dataSourceArr addObject:mDic];
        }
    }
    return _dataSourceArr;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSourceArr[indexPath.row];
    cell.backgroundColor = dic[@"color"];
    return cell;
}

#pragma mark - SCSWaterFlowDelegate
/** 返回indexPath对应的item高度 */
- (float)waterFlowLayout:(SCSWaterFlowLayout *)layout itemHeightAtIndex:(NSIndexPath *)indexPatch width:(float)itemWidth{
    NSDictionary *dic = self.dataSourceArr[indexPatch.row];
    float scale = [dic[@"scale"] floatValue];
    return itemWidth * scale;
}

@end
