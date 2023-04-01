## ingress egress
    セキュリティグループ設定の際にインバウンド・アウトバウンドの設定を実施する場所

## 構成要素

- DynamoDB
- DynamoDB streams
- Event Bridge
- Lambda
- kinesis Data stream
- kinesis Data Analytics
- kinesis Data Firehose


## DynamoDB リレーションシップ構造

### 1:1
- partisionKey or GSI 例: UserId or OrderId
- GSIの場合は他の絞り込みたいカラムをpartistionKeyとして使用
- GetItem API etc... 使用する

### 1:N
- partisionKey sortKey 使用したGSI
- QueryAPI 1ユーザーが複数の商品を購入する場合

### N:M
- テーブルとGSIを用いてpartisionKeyとsortKeyを用いて設計
- QueryAPI設計
- 

## CompositeKey
カラム同士を結合してsortKeyである絞り込みする方法

## Spares Index
特定のテーブルの1カラムで全行の中で一つしか値がないケース
例: ランキングなど

spare GSIを用意して取得する