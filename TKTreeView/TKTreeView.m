//
//  TKTreeView.m
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "TKTreeView.h"
#import "Masonry.h"
#import "TKTreeGroupTVC.h"

@interface TKTreeView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData;

@end

static NSString *TreeGroupTableViewCellIdentifier = @"TreeGroupTableViewCellIdentifier";

@implementation TKTreeView
#pragma mark - 初始化

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self commonInit];
    
    return self;
}

- (instancetype)init{
    self = [super init];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    [self commonInit];
    
    return self;
}

- (void)commonInit{
    [self registerClass:[TKTreeGroupTVC class] forCellReuseIdentifier:TreeGroupTableViewCellIdentifier];
    self.tableFooterView = [UIView new];
    self.dataSource = self;
    self.delegate = self;
    self.isGroupSelectEnable = NO;
}

- (void)setAllNodes:(NSArray *)allNodes{
    _allNodes = allNodes;
    self.tableData = [NSMutableArray new];
    for (TKTreeNode *node in allNodes) {
        if (node.depth == 0) {
            [self expandIfNeedWithTreeNode:node];
        }
    }
}

- (void)expandIfNeedWithTreeNode:(TKTreeNode *)node{
    [self.tableData addObject:node];
    if (node.isExpand) {
        for (TKTreeNode *childNode in node.childNodes) {
            [self expandIfNeedWithTreeNode:childNode];
        }
    }
}

- (void)expandFirstLevel{
    self.tableData = [NSMutableArray new];
    for (TKTreeNode *node in self.allNodes) {
        if (node.depth == 0 && !node.isExpand) {
            node.isExpand = YES;
            [self.tableData addObject:node];
            [self.tableData addObjectsFromArray:node.childNodes];
        }
    }
    [self reloadData];
}

#pragma mark - 建树

- (BOOL)setupWithAllNodes:(NSArray *)tempNodes{
    NSMutableArray *nodes = [NSMutableArray arrayWithArray:tempNodes];
    NSMutableArray *results = [NSMutableArray new];
    NSInteger count = nodes.count;
    
    BOOL isDidAdd = YES;
    while (count) {
        if (isDidAdd) {
            isDidAdd = NO;
        }else{
            break;
        }
        for (NSInteger i=0; i<nodes.count; i++) {
            NSObject *obj = nodes[i];
            if (![obj isKindOfClass:[TKTreeNode class]]) {
                continue;
            }
            TKTreeNode *node = nodes[i];
            if (!node.parentId.length) {
                node.depth = 0;
                [results addObject:node];
                isDidAdd = YES;
                nodes[i] = @"PlaceHolder";
                count--;
                continue;
            }
            for (TKTreeNode *parentNode in results) {
                if ([node.parentId isEqualToString:parentNode.id]) {
                    node.depth = parentNode.depth + 1;
                    node.parentNode = parentNode;
                    [parentNode.childNodes addObject:node];
                    [results addObject:node];
                    isDidAdd = YES;
                    count--;
                    nodes[i] = @"PlaceHolder";
                    break;
                }
            }
        }
    }
    self.allNodes = results;
    [self expandFirstLevel];
    
    return isDidAdd;
}

#pragma mark - TableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TKTreeGroupTVC *cell = [tableView dequeueReusableCellWithIdentifier:TreeGroupTableViewCellIdentifier];
    
    TKTreeNode *node = self.tableData[indexPath.row];
    if (node.isLeaf) {
        return [self.treeViewDelegate treeView:self cellForTreeNode:node];
    }else{
        cell.node = node;
    }
    
    if (self.isGroupSelectEnable) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TKTreeNode *selectNode = self.tableData[indexPath.row];
    if ([self.treeViewDelegate respondsToSelector:@selector(treeView:didSelectRowTreeNode:indexPath:)]) {
        [self.treeViewDelegate treeView:self didSelectRowTreeNode:selectNode indexPath:indexPath];
    }
    if (selectNode.isLeaf) {
        return;
    }
    TKTreeGroupTVC *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isExpand = !cell.isExpand;
    selectNode.isExpand = cell.isExpand;
    if (cell.isExpand) {
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (NSInteger i=0; i<selectNode.childNodes.count; i++) {
            TKTreeNode *childNode = selectNode.childNodes[i];
            NSIndexPath *childIndexPath = [NSIndexPath indexPathForRow:indexPath.row+i+1 inSection:0];
            [indexPaths addObject:childIndexPath];
            [self.tableData insertObject:childNode atIndex:indexPath.row+i+1];
        }
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }else{
        NSMutableArray *indexPaths = [NSMutableArray new];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
        for (NSInteger i=indexPath.row+1; i<self.tableData.count; i++) {
            TKTreeNode *childNode = self.tableData[i];
            if (childNode.depth <= selectNode.depth) {
                break;
            }
            [indexSet addIndex:i];
            NSIndexPath *childIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject:childIndexPath];
            
            TKTreeGroupTVC *cell = [tableView cellForRowAtIndexPath:childIndexPath];
            if ([cell isKindOfClass:[TKTreeGroupTVC class]]) {
                cell.isExpand = NO;
                cell.node.isExpand = NO;
            }
        }
        [self.tableData removeObjectsAtIndexes:indexSet];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TKTreeNode *selectNode = self.tableData[indexPath.row];
    if (selectNode.isLeaf) {
        if ([self.treeViewDelegate respondsToSelector:@selector(treeView:heightForRowTreeNode:indexPath:)]) {
            return [self.treeViewDelegate treeView:self heightForRowTreeNode:selectNode indexPath:indexPath];
        }
        return 44.0;
    }
    return 44.0;
}

@end
