//
//  ViewController.m
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "ViewController.h"
#import "TKTreeView.h"
#import "TKTreeLeafTVC.h"

@interface ViewController ()<TKTreeViewDelegate>

@property (weak, nonatomic) IBOutlet TKTreeView *treeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"城市";
    
    self.treeView.treeViewDelegate = self;
    
    NSArray *datas = [self loadData];
    
    if(![self.treeView setupWithAllNodes:datas]){
        NSLog(@"数据层级关系有误！");
    }
}

- (NSArray *)loadData{
    TKTreeNode *chinaNode = [TKTreeNode nodeWithTitle:@"中国" id:@"china" parentId:nil leaf:NO];
    TKTreeNode *americaNode = [TKTreeNode nodeWithTitle:@"美国" id:@"america" parentId:nil leaf:NO];
    
    TKTreeNode *californiaNode = [TKTreeNode nodeWithTitle:@"加利福尼亚" id:@"california" parentId:@"america" leaf:NO];
    TKTreeNode *losAngelesNode = [TKTreeNode nodeWithTitle:@"洛杉矶" id:@"losAngeles" parentId:@"california" leaf:NO];
    TKTreeNode *losAreaNode = [TKTreeNode nodeWithTitle:@"洛杉矶县" id:@"losArea" parentId:@"losAngeles" leaf:YES];
    
    TKTreeNode *hunanNode = [TKTreeNode nodeWithTitle:@"湖南" id:@"hunan" parentId:chinaNode.id leaf:NO];
    TKTreeNode *changshaNode = [TKTreeNode nodeWithTitle:@"长沙" id:@"changsha" parentId:hunanNode.id leaf:NO];
    TKTreeNode *yueluNode = [TKTreeNode nodeWithTitle:@"岳麓区" id:@"yuelu" parentId:changshaNode.id leaf:YES];
    TKTreeNode *yuhuaNode = [TKTreeNode nodeWithTitle:@"雨花区" id:@"yuhua" parentId:changshaNode.id leaf:YES];
    TKTreeNode *xiangtanNode = [TKTreeNode nodeWithTitle:@"湘潭" id:@"xiangtan" parentId:hunanNode.id leaf:NO];
    TKTreeNode *yuetangNode = [TKTreeNode nodeWithTitle:@"岳塘区" id:@"yuetang" parentId:xiangtanNode.id leaf:YES];
    
    TKTreeNode *sichuanNode = [TKTreeNode nodeWithTitle:@"四川" id:@"sichuan" parentId:chinaNode.id leaf:NO];
    TKTreeNode *chengduNode = [TKTreeNode nodeWithTitle:@"成都" id:@"chengdu" parentId:sichuanNode.id leaf:NO];
    TKTreeNode *wuhouNode = [TKTreeNode nodeWithTitle:@"武侯区" id:@"wuhou" parentId:chengduNode.id leaf:YES];
    
    TKTreeNode *shanghaiNode = [TKTreeNode nodeWithTitle:@"上海" id:@"shanghai" parentId:chinaNode.id leaf:NO];
    TKTreeNode *jinganNode = [TKTreeNode nodeWithTitle:@"静安区" id:@"jing'an" parentId:shanghaiNode.id leaf:YES];
    TKTreeNode *pudongNode = [TKTreeNode nodeWithTitle:@"浦东新区" id:@"pudong" parentId:shanghaiNode.id leaf:YES];
    
    return @[chinaNode,americaNode,californiaNode,losAngelesNode,losAreaNode,hunanNode,changshaNode,yueluNode,yuhuaNode,yuetangNode,xiangtanNode,sichuanNode,chengduNode,wuhouNode,shanghaiNode,jinganNode,pudongNode];
}

- (UITableViewCell *)treeView:(TKTreeView *)treeView cellForTreeNode:(TKTreeNode *)node{
    static NSString *CellIdentifier = @"CellIdentifier";
    TKTreeLeafTVC *cell = [treeView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TKTreeLeafTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.isShowTip = YES;
    cell.textLabel.text = node.title;
    cell.detailTextLabel.text = node.id;
    cell.node = node;
    
    return cell;
}

- (void)treeView:(TKTreeView *)treeView didSelectRowTreeNode:(TKTreeNode *)node indexPath:(NSIndexPath *)indexPath{
    [treeView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
