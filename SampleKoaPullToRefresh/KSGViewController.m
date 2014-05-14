//
//  KSGTableViewController.m
//  SampleKoaPullToRefresh
//
//  Created by Ryo Kosuge on 2014/05/14.
//  Copyright (c) 2014年 kosuge. All rights reserved.
//

#import "KSGViewController.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import <QuartzCore/QuartzCore.h>

@interface KSGViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *tableDatas;

- (void)configPullToRefresh;
- (void)refreshTable;

@end

@implementation KSGViewController

static NSString *const kTableDatasTitleKey = @"title";
static NSString *const kTableDatasSubTitleKey = @"subTitle";

static NSInteger const kTableDatasFirstCount = 20;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"Sample";
    
    [self configPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)configPullToRefresh
{

    // tableViewにPullToRefreshを追加します。
    
    // actionHandler:^(void())
    // pull to refreshされた時にする処理です。
    //
    // backgroundColor:UIColor
    // pull to refresh時に見える背景の色です。
    //
    // HeightShowed:CGFloat
    // なにもしていない状態（普通の状態）の時に上から見えるpullToRefreshViewnの高さです。
    // ここの値が大きいほど、チラ見せ度がなくなっていきます。
    
    __block KSGViewController *viewController = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [viewController refreshTable];
    } withBackgroundColor:[UIColor greenColor] withPullToRefreshHeightShowed:5.0f];
    
    // カスタマイズ
    
    // PullToRefreshの文字の色の設定
    [self.tableView.pullToRefreshView setTextColor:[UIColor whiteColor]];
    
    // PullToRefreshの文字のFontの設定
    // [self.tableView.pullToRefreshView setTextFont:[UIFont systemFontOfSize:18.0f]];
    
    // PullToRefreshのiconの設定
    [self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
    
    // PullToRefreshの各文言の設定
    // 下げている時の文言
    [self.tableView.pullToRefreshView setTitle:@"下げて更新" forState:KoaPullToRefreshStateStopped];
    // 下げきった時の文言
    [self.tableView.pullToRefreshView setTitle:@"指を話して更新" forState:KoaPullToRefreshStateTriggered];
    // iconが回転している時の文言
    [self.tableView.pullToRefreshView setTitle:@"更新中..." forState:KoaPullToRefreshStateLoading];
    
    
    // scrollViewの右にあるインディケーター（現在の位置がわかるやつ）を表示するかどうかです。
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [self.tableView.pullToRefreshView startAnimating];
    
}

- (void)refreshTable
{
    // refresh table
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
    [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}

#pragma mark - accessor

- (NSArray *)tableDatas
{
    if (!_tableDatas) {
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < kTableDatasFirstCount; i++) {
            NSString *title = [NSString stringWithFormat:@"title_%d", i];
            NSString *subTitle = [NSString stringWithFormat:@"sub_title_%d", i];
            NSDictionary *data = @{kTableDatasTitleKey: title, kTableDatasSubTitleKey: subTitle};
            [datas addObject:data];
        }
        _tableDatas = [datas copy];
    }
    
    return _tableDatas;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tableDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *tableData = self.tableDatas[indexPath.row];
    cell.textLabel.text = tableData[kTableDatasTitleKey];
    cell.detailTextLabel.text = tableData[kTableDatasSubTitleKey];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
