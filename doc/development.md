# Setup

- clone
  - 各自別途連絡したリポジトリよりcloneする。
    - `git clone git@github.com:<account>/<your gear name>`

- セットアップ
  - `cd /path/to/your_gear`
  - [asdf](https://github.com/asdf-vm/asdf)のinstall
    - [here](https://github.com/access-company/solomon/blob/master/doc/gear_developers/development_environment.md#setting-up-your-development-environment)を参照
  - `$ mix deps.get`
  - `$ asdf install`
  - `$ mix deps.get`
  - `hosts`ファイルの修正
    - ファイルを開いて
    ```
    $ sudo vi /etc/hosts
    ```
    - 下記の行を追加(gear名の`_`の部分は`-`に置き換えてください。)
    ```
    127.0.0.1 {your gear name}.localhost
    ```
      - example
      ```
      127.0.0.1 stackoverflow-team-a.localhost
      ```

- Webfrontend向けのセットアップ
  - [yarn](https://yarnpkg.com/en/docs/install#mac-stable)のインストール
    - `$ brew install yarn --without-node`
    - 環境の問題などでyarnのインストールに失敗し、解決に時間がかかりそうな場合、この後の作業をyarnの部分をnpmに置き換えても問題ない(その後の作業でライブラリのバージョンの差異による問題が出る可能性はある)。
  - パッケージインストール
    - `$ yarn`
      - yarnのインストールに失敗してyarnではなくnpmを利用する場合は、`$ npm install`。
  - Chromeに[Vue.js devtools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd?hl=en)をインストールする。

# gearの実行

- local環境でのgearの実行
  - `{capitalized your gear name}_CONFIG_JSON='{"root_key": "{root key}", "app_key": "{app key}"}' $iex -S mix`
    - 例: `STACKOVERFLOW_CLONE_CONFIG_JSON='{"root_key": "rkey_xxx", "app_key": "akey_xxx"}' iex -S mix`
    - `root key`や`app key`は[ac console](https://ac-console.solomondev.access-company.com/login?redirect_path=%2F)から確認ください。
      - ac consoleにログインするためのメールアドレスとパスワードは別途ご連絡します。
  - ブラウザで下記のurlを開く(gear名の`_`の部分は`-`に置き換えてください。)
    - `http://{your gear name}.localhost:8080/`
  - curlで`retrieveQuestionList API`が叩けることを確認する。(gear名の`_`の部分は`-`に置き換えてください。)
    - `curl -XGET http://{your gear name}.localhost:8080/v1/question | jq`

# Webfrontendのwebpack-dev-serverの実行

webpack-dev-serverを利用することで、ソースコードを修正した時に自動的にビルドとブラウザの再読み込みが行われる。

- あらかじめgearを実行している状態で下記を実行
  - `$ yarn run webpack-dev-server`
  - ブラウザで下記のurlを開く(gear名の`_`の部分は`-`に置き換えてください。)
    - `http://{your gear name}.localhost:8080/`.

# gearのデプロイ

各自が開発するgearはリポジトリをcloneした時点のものが既にsolomonのdev環境にデプロイされています。
具体的なURLは下記です。(gear名の`_`の部分は`-`に置き換えてください。)

`https://<your gear name>.solomondev.access-company.com/`

各自のリポジトリのmasterブランチにpushすると自動的にdev環境にデプロイされます。
(そのため、必ずmasterブランチにpushする前に下記のテストと静的解析を行いエラーが発生しないことをご確認ください。)

# gearのテストの実行

- 下記を実行
  - `$ mix test`

# gearの静的解析

- [Dialyzer](https://github.com/access-company/solomon/blob/master/doc/gear_developers/development_environment.md#static-analysis)の実行
  - `$ mix dialyze --unknown`

- [Credo](https://github.com/rrrene/credo)の実行
  - `$ mix credo`

# Webfrontendのテストの実行

- 下記を実行
  - `$ yarn run karma-single-run`

- ソースコードをwatchして変更されたら自動的に実行する場合は下記を実行
  - `$ yarn run karma`

- カバレッジを取得する場合は、それぞれ下記になる。結果は`coverage`以下に配置される。
  - `$ yarn run karma-single-run-with-coverage`
  - `$ yarn run karma-with-coverage`

# WebfrontendのLint

- 下記を実行。内部でESLintを呼び出すときに`--fix`を付けているため、ESLintが修正可能なコードは自動的に修正される。
  - `$ yarn run eslint`

# 補足

本研修では各種リソースを下記の方針で提供します。

- ac console account: 全受講者で共通
- app_id: 全受講者で共通
  - そのため、上述の`root key`と`app key`は全受講者で共通のものになります。
- group_id: 受講者(チーム)によって異なる
  - [ここ](../lib/dodai.ex)で定義されているgroup_idが受講者によって異なっています。
  - ac console上で実習で作成するデータ等を閲覧することができますが、各自に割り当てられたgroupを選択ください。
- gear名: 受講者(チーム)によって異なる
  - そのため、前述したリポジトリのgear名が異なっており、またdev環境のURLも受講者によって異なります。
