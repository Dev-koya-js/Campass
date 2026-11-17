# Campass

同じ大学の学生同士が、キャンパス内の手渡しで教科書を譲り合うアプリです。対価は現金や無料に加えて、学食 1 食やジュース 1 本からも選べます。受け渡しを、履修の話が始まるきっかけにします。

大学の認証 API は使わず、大学が発行するメールアドレスの確認で同じ大学の利用者かどうかを判定します。企画の詳細は [docs/CampassProposal.pdf](docs/CampassProposal.pdf) にあります。

## 技術スタック

- フロントエンド: TypeScript、React、Vite
- バックエンド: Ruby on Rails（API）
- データベース: PostgreSQL
- 開発環境: Docker Compose
- 本番環境（予定）: Render

## 起動

Docker Desktop の WSL 統合を有効にしてから、リポジトリのルートで次を実行します。

```bash
docker compose up --build
```

起動後の入口は次の 2 つです。

- API: http://localhost:3000/up
- 画面: http://localhost:5173

開発用データベースのユーザー名、パスワード、データベース名はいずれも `campass` / `campass` / `campass_development` です。この値は自分の PC の中だけで使います。

止めるときは Ctrl+C のあと、次を実行します。

```bash
docker compose down
```

データごと消すときは `docker compose down -v` を使います。
