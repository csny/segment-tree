//
//  main.m
//  segment-tree1
//
//  Created by macbook on 2014/12/22.
//  Copyright (c) 2014年 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

// 0なら変更なし、1なら変更あり
int isUPDATE;
// p入れ替える番号,q入れ替える中身,r累積開始番号,s累積終了番号
int p,q,r,s;
// [0]〜[14]はセグメント木用の小計、実際の数字は[15]〜[30]
int tree[31]={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,8,14,9,19,17,19,18,8,4,5,9,15,11,20,7,2};
// 与えられた番号(1<=x<=16)の累積和
int sum[17];

// 与えられた番号a,b(1<= a < b <=16)間の累積和を返す
int sum_sequence(int a, int b){
    sum[16]=tree[0];
    sum[15]=tree[1]+tree[5]+tree[13]+tree[29];
    sum[14]=tree[1]+tree[5]+tree[13];
    sum[13]=tree[1]+tree[5]+tree[13]+tree[27];
    sum[12]=tree[1]+tree[5];
    sum[11]=tree[1]+tree[11]+tree[25];
    sum[10]=tree[1]+tree[11];
    sum[9]=tree[1]+tree[23];
    sum[8]=tree[1];
    sum[7]=tree[3]+tree[9]+tree[21];
    sum[6]=tree[3]+tree[9];
    sum[5]=tree[3]+tree[19];
    sum[4]=tree[3];
    sum[3]=tree[7]+tree[17];
    sum[2]=tree[7];
    sum[1]=tree[15];
    sum[0]=0;
    return sum[b]-sum[a-1];
}

// セグメント木作成
void init_tree(){
    for (int i=14;i>=0;i--){
        if (tree[i]==-1){
            tree[i]=tree[i*2+1]+tree[i*2+2];
        }
    }
}

// 与えられたm番(1<= m <=16)の数字をnに差し替えて、セグメント木更新
void tree_update(int m, int n){
    int k,l;
    k=m+14;
    if (tree[k]==n){
    } else {
        l=n-tree[k];
        tree[k]=n;
        for (int i=0;i<4;i++){
            k=floor((k-1)/2); // floorで小数点以下切り捨て
            tree[k]+=l;
        }
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 入力
        scanf("%d",&isUPDATE);
        // isUPDATEをフラグに更新情報を読み込み
        if(isUPDATE==1){
            scanf("%d\n%d", &p,&q);
        }
        scanf("%d\n%d", &r,&s);
        
        // 処理開始
        init_tree();
        if(isUPDATE==1){
            tree_update(p,q);
        }
        NSLog(@"%d",sum_sequence(r,s));
    }
    return 0;
}