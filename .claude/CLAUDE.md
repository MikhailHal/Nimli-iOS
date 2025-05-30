# Claude Development Guidelines for IlluMefy-iOS

## Project Overview
IlluMefy is a food management iOS app built with SwiftUI and Clean Architecture.

## Architecture Rules
- Follow Clean Architecture pattern:
  - Presentation Layer: Views, ViewModels
  - Domain Layer: UseCases, Entities
  - Data Layer: Repositories, DataSources
- Use dependency injection via `DependencyContainer`

## Coding Standards

### Naming Conventions
- Use `IlluMefy` prefix for all custom components (not `Nimli`)
- ViewModels: `[Feature]ViewModel`
- UseCases: `[Action][Entity]UseCase`
- Repositories: `[Entity]Repository`

### UI Components
- **基本方針**: 共有UIコンポーネントを優先的に使用する
- Always use existing shared components:
  - `IlluMefyButton` - グラデーションボタン
  - `IlluMefyCardNormal` - カードコンテナ
  - `IlluMefyCheckbox` - チェックボックス  
  - `IlluMefyLoadingDialog` - ローディング表示
  - `IlluMefyPlainTextField` - 通常テキストフィールド
  - `IlluMefyConfidentialTextField` - セキュアテキストフィールド
- **新規コンポーネント作成時**:
  - 必ず`IlluMefy`プレフィックスを付ける
  - `/Utilities/Components/[ComponentType]/`に配置
- Define constants for hardcoded values
- Use color assets from `Asset.Color.*`

### Localization
- Add strings to `Resources/Localizable.strings`
- Follow naming pattern: `[screen].[component].[usage]`
- **必ずSwiftGenで生成したアクセッサを使用** (直接文字列リテラルは使用禁止)
  - 例: `L10n.login.button.submit` を使用 (❌ "Submit" を直接使用)
- Run swiftgen after adding strings:
  ```bash
  cd IlluMefy/IlluMefy && swiftgen run strings Resources/Localizable.strings -t structured-swift5 -o Generated/Strings.swift
  ```

### Git Workflow
- **Branch Strategy**: 各issueに対して1つのブランチのみを作成し、派生ブランチは作らない
  - Example: Issue #2 → `claude/issue-2-YYYYMMDD_HHMMSS` (1つのブランチで完結)
- Commit messages: Use conventional commits (feat:, fix:, refactor:)
- Don't include "Generated by Claude" or similar messages
- Always run lint/typecheck before committing

### Testing
- Check for build errors before pushing
- Test UI changes in SwiftUI Preview when possible

## Common Tasks

### Adding a new screen
1. Create View and ViewModel in `/Presentations/[Feature]/`
2. Create UseCase in `/UseCases/[Feature]/`
3. Create Repository in `/Data/Repositories/[Feature]/`
4. Add localization strings
5. Register dependencies in `DependencyContainer`

### Modifying existing components
1. Check all usages before making changes
2. Maintain backward compatibility
3. Update documentation if needed

## Important Notes
- Phone number fields should use `.keyboardType(.phonePad)`
- Always handle loading and error states
- Follow existing patterns in the codebase

## Common Mistakes to Avoid
**CRITICAL RULE**: ハードコードされた文字列は絶対に使用禁止
- ❌ `errorMessage = "ネットワークエラー"`
- ✅ `errorMessage = L10n.Error.network`
- すべてのユーザー向け文字列は必ずLocalizable.strings → SwiftGen経由で使用

## Common Mistakes to Avoid
1. **Using non-existent constants**: Always check available constants in `Spacing.swift` before using
   - Available: `none`, `componentGrouping`, `relatedComponentDivider`, `screenEdgePadding`, `cardEdgePadding`, `unrelatedComponentDivider`
   - Do NOT use: `componentSeparation` (doesn't exist)
2. **Router destinations**: Check `IlluMefyAppRouter.Destination` enum for available navigation targets
   - Available: `phoneNumberRegistration`, `login`, `groupList`
   - Do NOT use: `register` (use `phoneNumberRegistration` instead)
3. **SwiftLint trailing closure rule**: When Button has both action and label closures, use explicit `label:` parameter
   - ❌ `Button(action: { }) { Text("Label") }`
   - ✅ `Button(action: { }, label: { Text("Label") })`
4. **iOS 17 onChange deprecation**: Use two-parameter closure for onChange
   - ❌ `.onChange(of: value) { newValue in }`
   - ✅ `.onChange(of: value) { oldValue, newValue in }`
   - Note: If you don't need the values, use `{ _, _ in }`

## Design Language & Visual Identity

### Core Design Philosophy
**"Playful Professionalism"** - モダンで洗練されているが、親しみやすく楽しい雰囲気

### アプリの世界観
**「親密な探索体験」** - 推しを、もっと推せる世界へ

#### ブランドアイデンティティ
- **多様性と流動性**: やわらかいグラデーションで表現
- **偶然の出会い**: 浮遊パーティクルで発見の喜びを演出
- **親しみやすさ**: 角丸フォルム、優しい色使い

#### デザイン原則
1. **探索の楽しさ**
   - アニメーションで期待感を演出
   - マイクロインタラクションでワクワク感
   - グラデーションの動きで流動性を表現

2. **コミュニティ感**
   - 温かみのある色温度
   - 有機的な動き（Spring animation）
   - ユーザー生成コンテンツを引き立てるシンプルな枠組み

3. **愛のある分類**
   - タグは角丸で柔らかく
   - 選択時は優しくハイライト
   - グループ化は視覚的に分かりやすく

#### カラーストラテジー
- **プライマリ**: 淡いグラデーション（探索・発見）
- **アクセント**: 鮮やかだが優しい色（推し活のエネルギー）
- **ベース**: 落ち着いた背景（コンテンツを引き立てる）

### Visual Characteristics
1. **グラデーション & 透明感**
   - 背景：薄いグラデーション（opacity 0.05-0.08）で深みを演出
   - アニメーション：ゆっくり動くアンビエントグラデーション
   - 重要要素：グラデーションカラーを効果的に使用

2. **シャドウ & デプス**
   - 主要要素：`shadow(radius: 20, y: 10)` で浮遊感
   - ボタン：有効時により強いシャドウで存在感強調
   - カード：微細なシャドウで階層を表現

3. **アニメーション原則**
   - Spring animation：`spring(response: 0.8, dampingFraction: 0.6)`
   - 段階的表示：0.3秒間隔でプログレッシブディスクロージャー
   - マイクロインタラクション：フォーカス時やタップ時の微細な動き

4. **スペーシング**
   - 主要セクション間：`unrelatedComponentDivider`
   - 関連要素間：`relatedComponentDivider`
   - グループ内：`componentGrouping`

5. **タイポグラフィ**
   - タイトル：`.largeTitle` or `.system(size: 36, weight: .bold, design: .rounded)`
   - 説明文：透明度で階層表現（0.85 → 0.65）
   - フォントデザイン：`.rounded` で親しみやすさ

6. **インタラクション**
   - 重要アクション：触覚フィードバック（UIImpactFeedbackGenerator）
   - 入力フィールド：フォーカス時にスケール拡大
   - チェックボックス：選択時にボーダーハイライト

### 実装時の注意
- **パフォーマンス優先**：過剰なアニメーションは避ける
- **一貫性**：全画面で同じアニメーション設定を使用
- **アクセシビリティ**：Reduce Motion設定の考慮

## Feedback Reference
**IMPORTANT**: Always check `.claude/FEEDBACK_LOG.md` for specific feedback and corrections before implementing features.