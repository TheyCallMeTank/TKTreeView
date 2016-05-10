//
//  TKTreeView.h
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTreeNode.h"

@class TKTreeView;
@protocol TKTreeViewDelegate <NSObject>

- (UITableViewCell *)treeView:(TKTreeView *)treeView cellForTreeNode:(TKTreeNode *)node;

@optional
- (void)treeView:(TKTreeView *)treeView didSelectRowTreeNode:(TKTreeNode *)node indexPath:(NSIndexPath *)indexPath;
- (CGFloat)treeView:(TKTreeView *)treeView heightForRowTreeNode:(TKTreeNode *)node indexPath:(NSIndexPath *)indexPath;

@end

@interface TKTreeView : UITableView

@property (nonatomic, strong) NSArray *allNodes;
@property (nonatomic, weak) id<TKTreeViewDelegate> treeViewDelegate;
@property (nonatomic, assign) BOOL isGroupSelectEnable;

/**
 *  载入Nodes数据建树并展示
 *
 *  @return 如果返回为YES则建树成功，如果为NO则数据层级关系有误
 */
- (BOOL)setupWithAllNodes:(NSArray *)nodes;

/**
 *  展开第一层
 */
- (void)expandFirstLevel;

@end
