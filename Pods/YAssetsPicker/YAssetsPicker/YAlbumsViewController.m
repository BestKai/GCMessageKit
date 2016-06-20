//
//  YAlbumsViewController.m
//  YAssetsPickerDemo
//
//  Created by BestKai on 15/12/11.
//  Copyright © 2015年 BestKai. All rights reserved.
//

#import "YAlbumsViewController.h"
#import "YImagePickerNavController.h"


@interface YAlbumsViewController ()<UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver>

@end

@implementation YAlbumsViewController


- (instancetype)initWithNavController:(YImagePickerNavController *)navController
{
    self = [super init];
    
    if (self) {
        
        self.navController = navController;
        
        [self loadAlbumsGroup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    [self registerForNotifications];
    [self.view addSubview:self.groupTableView];
}


- (void)registerForNotifications
{
    if (!IOS9Later) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeLibrary:)
                                                     name:ALAssetsLibraryChangedNotification
                                                   object:nil];
    }else
    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
}

- (void)unregisterFromNotifications
{
    if (!IOS9Later) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:ALAssetsLibraryChangedNotification
                                                      object:nil];
    }else
    {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}


- (void)didChangeLibrary:(NSNotification *)notification
{
    [self loadAlbumsGroup];
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [self loadAlbumsGroup];
}

- (UILabel *)noPhotoLabel
{
    if (!_noPhotoLabel) {
        
        _noPhotoLabel = [[UILabel alloc] init];
        _noPhotoLabel.text = @"无照片";
        _noPhotoLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _noPhotoLabel.font = [UIFont systemFontOfSize:14];
        _noPhotoLabel.frame = CGRectMake(0, 40, self.view.frame.size.width, 20);
        _noPhotoLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_noPhotoLabel];
    }
    return _noPhotoLabel;
}


- (UITableView *)groupTableView
{
    if (!_groupTableView) {
        
        _groupTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight-64) style:UITableViewStylePlain];
        _groupTableView.tableFooterView = [UIView new];
        _groupTableView.rowHeight = 75;
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        
        [self.view addSubview:_groupTableView];
    }
    return _groupTableView;
}

- (void)loadAlbumsGroup
{
    [[YImageManager manager] getAllAlbumscompletion:^(NSArray<YAlbumModel *> *models) {
        self.groupAlbums = [NSMutableArray arrayWithArray:models];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.groupTableView reloadData];
            
            if (self.groupAlbums.count) {
                [self pushToAssetsController];
            }
            self.noPhotoLabel.hidden = self.groupAlbums.count;
        });
    }];
}


#pragma mark ---- UITableViewDelegate  &&  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
        UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 75, 75)];
        
        postImageView.tag = 101;
        
        postImageView.contentMode = UIViewContentModeScaleAspectFill;
        postImageView.clipsToBounds = YES;
        
        [cell.contentView addSubview:postImageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(98, 25, 200, 25)];
        
        label.tag = 102;
        
        [cell.contentView addSubview:label];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *imageView = [cell.contentView viewWithTag:101];
    
    UILabel *textLabel = [cell.contentView viewWithTag:102];
    
    
    YAlbumModel *model = self.groupAlbums[indexPath.row];
    
    NSString *number;
    NSString *name;
    NSUInteger numberOfAssets;
    
    name = model.name;
    
    numberOfAssets = model.count;
    
    number = [[NSString alloc] initWithFormat:@"(%zd)",numberOfAssets];
    
    NSString *textString = [NSString stringWithFormat:@"%@  %@",name,number];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] range:NSMakeRange(name.length+2, number.length)];
    
    textLabel.attributedText = attributeString;
    
    [[YImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            imageView.image = postImage;
        });
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YAssetsViewController *assetsVC = [[YAssetsViewController alloc] initWithNav:self.navController];
    
    assetsVC.assetsGroup = self.groupAlbums[indexPath.row];
    
    [self.navigationController pushViewController:assetsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToAssetsController
{
    [self.navigationController popToRootViewControllerAnimated:NO];
 
    if ([[YImageManager manager] authorizationStatusAuthorized]) {
        YAssetsViewController *assetsVC = [[YAssetsViewController alloc] initWithNav:self.navController];
        if (self.groupAlbums.count) {
            assetsVC.assetsGroup = self.groupAlbums.count?self.groupAlbums[0]:nil;
            [self.navigationController pushViewController:assetsVC animated:NO];
        }
    }else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-照片”选项中，允许大白采购访问你的相册。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
    }
}

- (void)dismissAction
{
    if (self.navController.navDelegate) {
        
        [self.navController.navDelegate imagePickerNavController:self.navController DidFinshed:nil];
    }
}

- (void)dealloc
{
    [self unregisterFromNotifications];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
