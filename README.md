# 日本の野鳥 Web API / bird API

[![Build Status](https://travis-ci.org/KamataRyo/bird-api.svg?branch=master)](https://travis-ci.org/KamataRyo/bird-api)
[![npm version](https://badge.fury.io/js/bird-api.svg)](https://badge.fury.io/js/bird-api)


これは、日本の野鳥の名前を取得するエンドポイントを提供するWebサーバです。

## APIs
### 野鳥一覧を取得(全データを取得)
[GET /v1/birds](http://bird-api.biwako.io/v1/birds)
````
{
  "species":[
    {
      "_id":"570cd3d11d4260e3bc3db188",
      "alien":false,
      "upper":"genus",
      "rank":"species",
      "sc":"muta",
      "ja":"ライチョウ",
      "upper_id":"570cd3d01d4260e3bc3db068"
    },{
      "_id":"570cd3d11d4260e3bc3db189",
      "alien":false,
      "upper":"genus",
      "rank":"species",
      "sc":"japonica",
      "ja":"ウズラ",
      "upper_id":"570cd3d01d4260e3bc3db069"
    },
    ...
  ]
}
````
### 野鳥一覧を取得（フィールドを限定）
[GET /v1/birds?fields=ja,alien](http://bird-api.biwako.io/v1/birds?fields=ja,alien)
````
{
  "species":[
    {
      "alien":false,
      "ja":"ライチョウ",
    },{
      "alien":false,
      "ja":"ウズラ",
    },
    ...
  ]
}
````
### 野鳥一覧を取得（ページネーション）
[GET /v1/birds?limit=30](http://bird-api.biwako.io/v1/birds?limit=30)

[GET /v1/birds?offset=10](http://bird-api.biwako.io/v1/birds?offset=10)

[GET /v1/birds?offset=15&limit=5](http://bird-api.biwako.io/v1/birds?offset=10&limit=5)

### 分類群を取得(birdsリソースと同様にfields、limit、offsetクエリが使えます)
#### 目（order）
[GET /v1/orders](http://bird-api.biwako.io/v1/orders)

#### 科（family）
[GET /v1/families](http://bird-api.biwako.io/v1/families)

#### 属（genus）
[GET /v1/genuses](http://bird-api.biwako.io/v1/genuses)

#### 種（species）
[GET /v1/species](http://bird-api.biwako.io/v1/species)
※birdsリソースのエイリアス

### 単一の野鳥を取得
[GET /v1/birds/:標準和名?fields=ja,sc](http://bird-api.biwako.io/v1/birds/マガモ?fields=ja,sc)（マガモの例）
````
{
  "species":
    {
      "ja":"マガモ",
      "sc":"platyrhynchos"
    },
  "biomen":"Anas platyrhynchos",
  "taxonomies":[
    {
      "ja":"マガモ属",
      "sc":"anas"
    },{
      "ja":"カモ科",
      "sc":"anatidae"
    },{
      "ja":"カモ目",
      "sc":"anseriformes"
    }
  ]
}
````
[GET /v1/birds/:標準和名](http://bird-api.biwako.io/v1/birds/ツグミ)（ツグミの例、すべてのフィールドを取得）


## レスポンスのフィールド
|property|Type|description|
|---:|:---:|:---|
|rank|String|分類階級|
|ja|String|標準和名|
|sc|String|学名|
|upper|String|上位の分類階級|
|upper_id|String|上位の分類階級のObject_id|
|alien|Boolean|日本国内での外来種かどうか|
|biomen|String|二名法で表した学名|
