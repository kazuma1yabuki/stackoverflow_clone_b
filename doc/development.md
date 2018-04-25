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
  - パッケージインストール
    - `$ yarn`
  - Chromeに[Vue.js devtools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd?hl=en)をインストールする。

# gearの実行

- local環境でのgearの実行
  - `{capitalized new gear name}_CONFIG_JSON='{"root_key": "{root key}", "app_key": "{app key}"}' $iex -S mix`
  - ブラウザで下記のurlを開く(gear名の`_`の部分は`-`に置き換えてください。)
      `http://{new gear name}.localhost:8080/`.

# Webfrontendのwebpack-dev-serverの実行

webpack-dev-serverを利用することで、ソースコードを修正した時に自動的にビルドとブラウザの再読み込みが行われる。

- あらかじめgearを実行している状態で下記を実行
  - `$ yarn run webpack-dev-server`
  - ブラウザで下記のurlを開く(gear名の`_`の部分は`-`に置き換えてください。)
      `http://{new gear name}.localhost:8080/`.

# gearのテストの実行

- 下記を実行
  `$ mix test`

# gearの静的解析

- [Dialyzer](https://github.com/access-company/solomon/blob/master/doc/gear_developers/development_environment.md#static-analysis)の実行
  - `$ mix dialyze --unknown`

- [Credo](https://github.com/rrrene/credo)の実行
  - `$ mix credo`

# Webfrontendのテストの実行

- 下記を実行
  `$ yarn run karma-single-run`

- ソースコードをwatchして変更されたら自動的に実行する場合は下記を実行
  `$ yarn run karma`

# WebfrontendのLint

- 下記を実行。内部でESLintを呼び出すときに`--fix`を付けているため、ESLintが修正可能なコードは自動的に修正される。
  `$ yarn run eslint`
