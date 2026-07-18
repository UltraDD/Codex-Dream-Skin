# 预设主题 · Preset packs

仓库只分发程序化生成的抽象预设。默认的 `preset-midnight-aurora` 与其余四套预设均由 `generate-presets.mjs` 生成，不包含照片、真人肖像、角色或第三方品牌素材。

## 一套预设的结构

```text
preset-example/
├── background.jpg
└── theme.json
```

- `background.jpg`：连续铺满画布的纯背景，不包含 UI、文字或 Logo。
- `theme.json`：主题名称、颜色、图像文件名和可选的自适应参数。
- 目录名和 `theme.json.id` 都使用稳定的 `preset-*` 标识。

## 素材红线

- 不提交真人肖像、受保护角色、客户物料、商标或来源不清的图片。
- 不提交账号名、聊天、真实任务标题、本机路径或其他私人截图。
- AI 生成不等于拥有再分发权；来源与生成过程必须可追溯。
- 预览截图不能作为 `background.jpg` 导入。

## 贡献方式

推荐修改 `generate-presets.mjs`，用程序化图形生成新的抽象背景。直接提供图片时，必须在 PR 中说明作者、来源、许可和是否允许修改及再分发。

## 提交前自检

```bash
./scripts/validate-theme-pack.mjs presets/preset-example
./tests/run-tests.sh
```

还需在真实 Codex 首页和任务页检查侧栏、输入框、常见窗口宽度、重启重应用与 Restore。
