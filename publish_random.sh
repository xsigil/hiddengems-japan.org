#!/bin/bash

# 設定: 記事があるディレクトリ
POSTS_DIR="content/posts"
# 今日の日付 (Hugoの標準的な形式: 2026-02-10T19:44:00+09:00)
CURRENT_DATE=$(date +"%Y-%m-%dT%H:%M:%S+09:00")

# 1. draft: true となっているファイルの中からランダムに30個選出
# (もし30個に満たない場合は、存在する分だけ処理)
FILES=$(grep -l "draft: true" $POSTS_DIR/*.md | shuf -n 30)

if [ -z "$FILES" ]; then
    echo "draft: true のファイルが見つかりませんでした。"
    exit 1
fi

echo "以下の30記事を公開設定に更新します:"

for FILE in $FILES; do
    echo "Processing: $FILE"
    
    # 2. draft: true を draft: false に置換
    sed -i 's/draft: true/draft: false/g' "$FILE"
    
    # 3. date: で始まる行を今日の日付に置換
    # Front Matterの形式に合わせて調整
    sed -i "s/^date: .*/date: $CURRENT_DATE/" "$FILE"
done

echo "完了しました！"
