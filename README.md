# resty-auth-serve

Google 認証をした上で S3 のファイルを転送するサービス。

イメージを作っておけば AWS Fargate で構築が可能。

## 環境構築

### ECR準備

まず ECR を作っておく。
`cfn/ecr.yaml` を使って CloudFormation で構築するか、手動で構築する。

その後、以下の設定をする。

```
exrpot ECR_URI="<さっき作ったECRのURI>"
```

あるいは `VERSION.local` を作って

```
ECR_URI="<さっき作ったECRのURI>"
```

を定義しても良い。

### 依存ライブラリの取得

以下のコマンドを実行する。

```
./local_setup.sh
```

これで依存ライブラリを取得する。

### GCP の設定

Google 認証するために、GCP の [認証情報](https://console.cloud.google.com/apis/credentials) から OAuth クライアントを作り、リダイレクトURLの設定をする。
クライアントIDとシークレットとリダイレクトURLを控えておいて、以下のコマンドを実行する。

```
$ cp secret.example.lua local/secret.lua
$ cp secret.example.lua secret.lua
```

その後 `local/secret.lua` と `secret.lua` を適切に編集する。
`local/secret.lua` はローカルでの実行時に利用する設定で、`secret.lua` は本番環境での実行時に利用する設定となる。

それぞれのファイルに、クライアントIDとシークレットとリダイレクトURLを `openidc_opts` の `client_id`, `client_secret`, `redirect_uri` に入力する。

### 許可するドメインの設定

必要に応じて特定のドメインのみを許可する設定を入力する。

これには `local/secret.lua` と `secret.lua` の `validate_user` 関数を編集すれば良い。

### S3 の設定

S3 のバケットを事前に作っておく必要がある。
また、実行環境からこの S3 のファイルを読み込む権限が必要となるので、設定しておくこと。

## ローカルでの実行

```
openresty -p `pwd` -c local/nginx.conf
```

全てがうまく設定されていれば、`http://localhost:8080/<s3-bucket-name>/<s3-path>` をブラウザで開いたら Google 認証が発生した上で S3 のファイルが表示されるはずである。

## デプロイ

### ECR イメージの push

VERSION を開いて、`RESTY_AUTH_SERVE_IMAGE_VERSION` のバージョンを上げる。
その後、以下のコマンドを実行して、イメージを構築してそのイメージを ECR に push する。

```
$ ./build.sh
$ ./push.sh
```

この時 `secret.lua` も一緒にイメージに入れてしまうので、`secret.lua` を編集した時も再度デプロイする必要がある。

### デプロイ

`cfn/fargate.yaml` を使って CloudFormation で更新する。
イメージ名には、上記で push した `$ECR_URI:$RESTY_AUTH_SERVE_IMAGE_VERSION` を指定して更新すること。
