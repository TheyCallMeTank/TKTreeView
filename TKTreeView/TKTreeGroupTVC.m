//
//  TKTreeGroupTVC.m
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "TKTreeGroupTVC.h"
#import "Masonry.h"

@interface TriangleView : UIView

@end

@implementation TriangleView

- (instancetype)init{
    self = [super init];
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor lightGrayColor] set];
    
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height/2)];
    
    [path fill];
}

@end

@interface TKTreeGroupTVC()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TriangleView *triangleView;

@end

@implementation TKTreeGroupTVC
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    __weak __typeof(self) weakSelf = self;
    self.triangleView = [TriangleView new];
    [self.contentView addSubview:self.triangleView];
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(8);
        make.centerY.equalTo(weakSelf.contentView.mas_top).offset(22);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.triangleView.mas_right).offset(8);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-8);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(12);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-12);
    }];
    
    return self;
}

- (void)setNode:(TKTreeNode *)node{
    _node = node;
    self.titleLabel.text = node.title;
    
    __weak __typeof(self) weakSelf = self;
    [self.triangleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(8+(node.depth)*TreeNodeOffset);
    }];
    
    self.isExpand = node.isExpand;
}

- (void)setIsExpand:(BOOL)isExpand{
    if (_isExpand == isExpand) {
        return;
    }
    if (!isExpand) {
        CGAffineTransform transForm = CGAffineTransformMakeRotation(0);
        [UIView animateWithDuration:0.25 animations:^{
            [self.triangleView setTransform:transForm];
        }];
    }else{
        CGAffineTransform transForm = CGAffineTransformMakeRotation(M_PI/2);
        [UIView animateWithDuration:0.25 animations:^{
            [self.triangleView setTransform:transForm];
        }];
    }
    _isExpand = isExpand;
}

@end
