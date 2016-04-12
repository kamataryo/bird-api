# 日本の野鳥 Web API / bird API

[![Build Status](https://travis-ci.org/KamataRyo/bird-api.svg?branch=master)](https://travis-ci.org/KamataRyo/bird-api)
[![npm version](https://badge.fury.io/js/bird-api.svg)](https://badge.fury.io/js/bird-api)


これは、日本の野鳥の名前を取得するエンドポイントを提供するWebサーバです。
This is a server program to host an endpoint to get names of birds in Japan.

## APIs

|methods|directory|description|
|:---:|:---|:---|
|GET|/v1/|get document|
|GET|/v1/birds/|get the list of all birds in Japan|
|GET|/v1/orders/|get the list of all orders of birds in Japan|
|GET|/v1/families/|get the list of all families of birds in Japan|
|GET|/v1/genuses/|get the list of all genuses of birds in Japan|
|GET|/v1/species/|alias of /v1/birds/|
|GET|/v1/birds/:name?fields=rank,ja,sc,alien|get name and taxonomy object of a bird.|
