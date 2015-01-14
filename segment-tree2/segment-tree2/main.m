//
//  main.m
//  segment-tree2
//
//  Created by macbook on 2015/01/13.
//  Copyright (c) 2015年 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

// 番号の総数
const int TOTALNUM = 16;
// 0なら変更なし、1なら変更あり
int isUPDATE;
// p入れ替える番号,q入れ替える中身,r累積開始番号,s累積終了番号
int p,q,r,s;
// [0]〜[14]はセグメント木用の小計、実際の数字は[15]〜[30]
int tree[TOTALNUM*2-1]={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,8,14,9,19,17,19,18,8,4,5,9,15,11,20,7,2};
// セグメント木のセグメント区間幅[0][0-30]と区間の開始番号[1][0-30]
int treeattr[2][TOTALNUM*2-1];


/* Queue  First-In First-Out方式 */
const int SIZE = 500; // キューとして使う配列のサイズ
// [0][i]累積和のキュー[1][i]番号の飛び方の計算キュー
int queue[2][SIZE];
NSString *path[SIZE]; // 経路出力用に文字列の配列を用意

// 幅優先探索で、開始番号start=rから終了番号goal=s+1までの累積和を表示する
// 探索の根幹は#1.2.3.4.5のループ
void sum_sequence( int start, int goal ){
    // キュー入出力用に使う変数。frontは先頭、rearは末尾。
    // rearは次のノードの取り込み位置、frontは親ノード兼次の削除位置として利用。
    int rear = 1, front = 0;
    queue[0][front]=0; // 累積和の最初の親ノード
    queue[1][front]=start; // 番号の一番最初の親ノード
    path[front]=@"経路";
    while( front < rear ){ // #0.ループ設定 front=rearはキューが空の状態を表す
        for(int i = 0; i < TOTALNUM*2-1; i++){ // #1.子ノード取り込み処理開始
            if(queue[1][front]==goal){ // #2.条件判定等の処理
                // 探索結果出力
                NSLog(@"%d",queue[0][front]);
                NSLog(@"%@",path[front]);
                return; // キューのサイズが足りないので、答えが出たら探索途中でwhileループ終了
            }else if(queue[1][front] + treeattr[0][i] <= goal){
                // 開始番号と一致するか
                if(treeattr[1][i] == queue[1][front]){
                    // #3.キュー取り込み
                    queue[0][rear] = queue[0][front] + tree[i];
                    queue[1][rear] = queue[1][front] + treeattr[0][i];
                    path[rear]=[NSString stringWithFormat:@"%@,%d",path[front],tree[i]];
                    rear++; // #4.キューに取り込んだら、次に取り込む位置に移動
                }
            } // キューサイズ節約のため、queue[1][rear]がgoalより大きくなりそうならキューに取り込まない
        }
        front++; // #5.キューの先頭の枝１本を探索済み・削除扱いして、次の枝の取り込みへ
    }
}

// 与えられたm番(1<= m <=16)の数字をnに差し替えて、セグメント木更新
void tree_update(int m, int n){
    int k,l;
    k=m+TOTALNUM-2;
    // セグメント木の階層をresult4として算出
    double result3 = log2(TOTALNUM);
    int result4 = floor(result3);
    if (tree[k]==n){
    } else {
        l=n-tree[k];
        tree[k]=n;
        for (int i=0;i<result4;i++){
            k=floor((k-1)/2); // floorで小数点以下切り捨て
            tree[k]+=l;
        }
    }
}

// セグメント木作成
void init_tree(){
    // セグメント木生成
    for (int i=TOTALNUM-2;i>=0;i--){
        if (tree[i]==-1){
            tree[i]=tree[i*2+1]+tree[i*2+2];
        }
    }
    
    // 区間幅と開始番号の配列treeattr初期化
    int treewidth=TOTALNUM;
    for (int i=TOTALNUM*2-2;i>=0;i--){
        // セグメント木の区間幅
        // 2を底とするi+1の対数の整数部分が階層。上から0,1,2となる。
        double result1 = log2(i+1);
        // 16を2の累乗で割る
        int result2 = pow(2, floor(result1));
        treeattr[0][i]=TOTALNUM/result2;
        
        // セグメント木の区間の開始番号
        treeattr[1][i]=treewidth-treeattr[0][i]+1;
        treewidth -= treeattr[0][i];
        if (treewidth == 0){
            treewidth = TOTALNUM;
        }
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 入力受付
        scanf("%d",&isUPDATE);
        // isUPDATEをフラグに更新情報を読み込み
        if(isUPDATE==1){
            scanf("%d\n%d", &p,&q);
        }
        scanf("%d\n%d", &r,&s);
        
        // 処理開始
        // セグメント木の初期化
        init_tree();
        // 構成変更があれば修正
        if(isUPDATE==1){
            tree_update(p,q);
        }
        // 累積和計算の本体
        sum_sequence(r,s+1);
    }
    return 0;
}