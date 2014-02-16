//
//  JirViewController.m
//  JIR_Social2
//
//  Created by ZEmac on 2014/02/15.
//  Copyright (c) 2014年 ZEmac. All rights reserved.
//

//このサンプルは実機で実行してください。

#import "JirViewController.h"
//必要なフレームワークをインポートする
@import Social;
@import Social.SLServiceTypes;
#import "JirSocialSupport.h"

@interface JirViewController (){
    JirSocialSupport * sSupport;
    SLComposeViewController * composeVC;
}

@property (weak, nonatomic) IBOutlet UIButton *FacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *TwitterButton;

@property (nonatomic) NSArray * availServiceTypes;
@end

@implementation JirViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _FacebookButton.enabled = NO;
    _TwitterButton.enabled = NO;
    //サポートするサービスタイプを確認
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        _FacebookButton.enabled = YES;
    }
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        _TwitterButton.enabled = YES;
    }
   
    if (!_FacebookButton.isEnabled && !_TwitterButton.isEnabled) {
        [self alert:@"Socialフレームワークは実機でしか対応できません。実機で試してみでください。"];
    }
}
- (IBAction)onFacebookShare:(UIButton *)sender {
    [self socialPostWithServiceType:SLServiceTypeFacebook];
    
}
- (IBAction)onTwitterShare:(id)sender {
    [self socialPostWithServiceType:SLServiceTypeTwitter];
    
}
-(void)socialPostWithServiceType:(NSString*)serviceType{
    //serviceType(facebook,twitterなど）によってcomposeVc作成
    composeVC = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    if (!composeVC) {//なんらかの原因で作成できなかった場合
        [self alert:@"composeVC = nil"];
        return;
    }
    //
    SLComposeViewControllerCompletionHandler completionHandle = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {//composeVCのキャンセルボタンを押した場合
            NSLog(@"キャンセルされた!");
        }else{//投稿を押した場合
            NSLog(@"投稿した");
        }
        [composeVC dismissViewControllerAnimated:YES completion:nil]; //操作した後に元の画面に戻る
    };
    composeVC.completionHandler = completionHandle;//completionHandle設定
    [composeVC setInitialText:@"追加テキスト"];//追加テキストテスト
    //写真追加テスト(注：twitterは写真一枚しかアップロードできません）
    UIImage * img;
    if ([serviceType isEqualToString:SLServiceTypeTwitter]) {
        img = [UIImage imageNamed:@"twitter-icon"];
    }else{
        img = [UIImage imageNamed:@"facebook-icon"];
    }
    [composeVC addImage:img];//写真追加
    [composeVC addURL:[NSURL URLWithString:@"http://www.jiroiphone.blog.jp"]];//URL追加
    [self presentViewController:composeVC animated:YES completion:nil];//設定した後にcomposeVCを表示させる

}

#pragma mark - Alert View
//バグ用メソッド
-(void)alert:(NSString*)alertString{
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertString delegate:nil cancelButtonTitle:@"Okey" otherButtonTitles:nil];
    [alertV show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
