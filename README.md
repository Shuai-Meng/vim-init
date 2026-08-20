# 前言
轻量级 Vim 配置框架，全中文注释，这既是一份合理的轻量级配置，更是一份简明教程。话说，网上的 Vim 配置多的数不过来，这里又做一个干嘛？这些配置都有一些问题：

- 注释不够，很多配置就是劈里啪啦一堆 VimScript 看的人一头雾水，新人顶多只能 “用”，没法跟着 “学”。
- 大部分都是针对 Vim 7 以前的版本，太过陈旧，对 8.0/8.1 以后的各种现代编辑器特征支持不足。
- 模块化不够好，全部塞在一个几百行的 `vimrc` 文件里，各部分搅在一起，增改都比较麻烦。
- 插件没有分组，不能根据需要灵活选择功能组，所有插件一上就全上了，要禁止就是进去注释代码。
- 它们有很多错误的地方，比如中文编码都没设对，很多 Windows 下的 PowerShell 脚本都打开不了。
- 错误的习惯，比如把 jk 映射成 ESC 的，顺着从 a 打倒 z 都打不流畅，输入个 `Dijkstra` 都输入不了。
- 对 C/C++ 开发支持不足。

还有不少插件自己给设置门槛的，比如把方向键禁用掉，我见过很多才用 Vim 的新人，大部分都呆在插入模式下，保存文件才会退出一下，至少人家开始用了，等到熟练了，该用 hjkl 的时候自然会去用。你这上来就把方向键和鼠标禁止了，除了阻挡新人外，我不知道有什么作用。

总之，山寨居多，还有某些著名的广为流传的 Vim 配置，我都不想点名了，把 Leader 键映射成逗号了，它不知道逗号/分号在 Vim 里是用来定位 f/t 搜索的下一个/上一个结果的么？就和 n/N 定位斜杠搜索一样。把 Leader 定义成空格我都还觉得挺科学，定义成逗号和分号的这些配置，是在把错误的用法源源不断的交给未来的新用户。

所以网上缺一份合理的轻量级配置，适合新人学习那种，于是有了这个项目。


# 安装

将项目克隆到你喜欢的目录内，比如 `~/.vim` 内：

```bash
cd ~/.vim
git clone https://github.com/skywind3000/vim-init.git
```

然后创建你的 `~/.vimrc` 文件，里面只有一句话：

```VimL
source ~/.vim/vim-init/init.vim
```

请调整你的终端软件，确保对 ALT 键的支持，以及 Backspace 键发送正确扫描码：

[终端软件下正确支持 ALT 键和 Backspace 键](https://github.com/skywind3000/vim-init/wiki/Setup-terminals-to-support-ALT-and-Backspace-correctly)

然后启动 Vim，在命令行运行 `:PlugInstall` 安装依赖插件即可。

# 结构

本配置按顺序，由如下几个主要模块组成：

- `init.vim`: 配置入口，设置 runtimepath 检测脚本路径，加载其他脚本。
- `init-basic.vim`: 所有人都能同意的基础配置，去除任何按键和样式定义，保证能用于 `tiny` 模式（没有 `+eval`）。
- `init-config.vim`: 支持 +eval 的非 tiny 配置，初始化 ALT 键支持，功能键键盘码，备份，终端兼容等
- `init-tabsize.vim`: 制表符宽度，是否展开空格等，因为个人差异太大，单独一个文件好更改。
- `init-plugin.vim`: 插件，使用 vim-plug，按照设定的插件分组进行配置。
- `init-style.vim`: 色彩主题，高亮优化，状态栏，更紧凑的标签栏文字等和显示相关的东西。
- `init-keymaps.vim`: 快捷键定义。

最好 fork 一份到你自己的仓库，然后不断修改，把它修改成你自己的东西，平时要更新时到这里同步下上游仓库，然后自己合并一下即可。

除去 vim-plug 额外安装的插件外，本配置自带一些依赖较大的[插件](https://github.com/skywind3000/vim-init/wiki/Integrated-Plugins)，保证内网连不了网的情况下，把本配置压缩包解压一下就能跑得起来，且基本功能可用，它们都比较简单，往往一两个文件，分布于 `plugin` 和 `autoload` 两个目录中，你可以根据自己需要增改。

# 帮助

既然是全中文注释，帮助主要看 [init-keymaps.vim](https://github.com/skywind3000/vim-init/blob/master/init/init-keymaps.vim) 和 [init-plugins.vim](https://github.com/skywind3000/vim-init/blob/master/init/init-plugins.vim) 两个文件，每个点我都写满了注释了，也是未来你自己可能修改的最多的两个文件。每次你修改或者调试了单个 .vim 配置文件后，命令行输入 `:so %` 即可重新载入，so 是 `source` 的简写，意思是加载脚本，`%` 代表当前正在编辑脚本的名字。

# Credit

TODO

# 快捷键总结

## Leader 键
- `<Space>` - 主 Leader 键（按下后等待 500ms 显示 which-key 菜单）

---

## 📁 文件/Buffer 操作
| 快捷键 | 功能 |
|--------|------|
| `<Space>bn` | 下一个 buffer |
| `<Space>bp` | 上一个 buffer |
| `<Space>nn` | 打开 NERDTree |
| `<Space>no` | NERDTree 聚焦当前文件 |
| `<Space>nm` | NERDTree 镜像同步 |
| `<Space>nt` | 切换 NERDTree |
| `<Space>ha` | 清除错误标记 |

---

## 📑 Tab 标签页
| 快捷键 | 功能 |
|--------|------|
| `<Space>1-9` | 切换到第 1-9 个 tab |
| `<Space>0` | 切换到最后一个 tab |
| `<Space>tc` | 新建 tab |
| `<Space>tq` | 关闭当前 tab |
| `<Space>tn` | 下一个 tab |
| `<Space>tp` | 上一个 tab |
| `<Space>to` | 关闭其他 tab |
| `<Space>tl` | 向左移动 tab |
| `<Space>tr` | 向右移动 tab |
| `Alt+1-9` | 切换到第 1-9 个 tab（Normal/Insert 模式） |

---

## 🪟 窗口操作（which-key: `<Space>w`）
| 快捷键 | 功能 |
|--------|------|
| `<Space>ww` | 切换到另一个窗口 |
| `<Space>wd` | 关闭当前窗口 |
| `<Space>w-` | 水平分割 |
| `<Space>w\|` | 垂直分割 |
| `<Space>wh` | 移动到左边窗口 |
| `<Space>wj` | 移动到下方窗口 |
| `<Space>wl` | 移动到右边窗口 |
| `<Space>wk` | 移动到上方窗口 |
| `<Space>w=` | 均衡窗口大小 |

---

## 🔍 EasyMotion 快速跳转
| 快捷键 | 功能 |
|--------|------|
| `s` | 跨窗口字符跳转 |
| `<Space>f` | 当前窗口字符跳转 |
| `<Space>F` | 跨窗口字符跳转 |
| `<Space>w` | 当前窗口单词跳转 |
| `<Space>W` | 跨窗口单词跳转 |
| `<Space>j` | 向下跳转 |
| `<Space>k` | 向上跳转 |
| `<Space>L` | 行内跳转 |
| `<Space>L` | 跨窗口行跳转 |

---

## 💻 coc.nvim LSP
| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gy` | 跳转到类型定义 |
| `gi` | 跳转到实现 |
| `gr` | 查找引用 |
| `K` | 显示文档 |
| `[d` | 上一个诊断 |
| `]d` | 下一个诊断 |
| `<Space>rn` | 重命名符号 |
| `<Space>ca` | 代码操作 |
| `<Space>f` | 格式化选中区域 |
| `Tab` | 补全下一项 |
| `Shift+Tab` | 补全上一项 |
| `Ctrl+Space` | 触发补全 |
| `Enter` | 确认补全 |

---

## 📝 编辑模式（EMACS 风格）
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+a` | 光标到行首 |
| `Ctrl+e` | 光标到行尾 |
| `Ctrl+d` | 删除字符 |
| `Ctrl+k` | 删除到行尾 |

---

## 🔧 工具插件
| 快捷键 | 功能 |
|--------|------|
| `F12` | 切换 Tagbar（键位可配置，见下文） |
| `Alt+e` | choosewin 窗口选择 |
| `Alt+=` | 展开选区 |
| `Alt+-` | 缩小选区 |
| `<Space>rg` | 语法检查 |
| `<Space>rr` | 打开语法检查窗口 |
| `<Space>rv` | 跳转到语法检查窗口 |
| `<Space>rs` | 重置语法检查 |
| `<Space>rx` | 关闭语法检查窗口 |
| `<Space>rm` | 删除语法错误 |
| `<Space>rd` | 禁用语法规则 |
| `<Space>rn` | 下一个语法错误 |
| `<Space>rp` | 上一个语法错误 |

---

## 🔎 搜索/导航
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+n` | LeaderF 最近文件 |
| `Alt+p` | LeaderF 函数列表 |
| `Alt+P` | LeaderF 标签列表 |
| `Alt+n` | LeaderF Buffer 列表 |
| `Alt+m` | LeaderF Tag 列表 |

---

## 🏗️ 编译/运行
| 快捷键 | 功能 |
|--------|------|
| `F9` | 编译 C/C++ 当前文件（gcc -Wall -O2，键位可配置） |
| `F5` | 运行当前文件（按文件类型选择解释器） |
| `F7` | 编译项目（make） |
| `F8` | 运行项目（make run） |
| `F6` | 测试项目（make test） |
| `F4` | 更新 CMake（cmake .） |
| `F2` | 项目内搜索光标下单词（rg/grep/findstr） |
| `F10` | 打开/关闭 Quickfix 窗口 |

---

## ⚙️ 可配置项与环境变量

以下配置可在 `~/.vimrc` 中 `source ~/.vim/vim-init/init.vim` 之前设置：

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `g:keymap_compile` | `<F9>` | 编译 C/C++ 文件的键位 |
| `g:tagbar_toggle_key` | `<F12>` | 切换 Tagbar 的键位（默认避开 F9 编译） |
| `$JAVA_HOME` | 未设置 | coc.nvim Java LSP 使用的 JDK 路径；未设置时使用 coc-java 自带 JDK |
| `$PYTHON` | 未设置 | F5 运行 Python 文件时使用的解释器；未设置时依次尝试 `python3`、`python` |

示例：

```vim
" 在 ~/.vimrc 中 source init.vim 之前设置
let g:keymap_compile = '<F12>'
let g:tagbar_toggle_key = '<F9>'
let $JAVA_HOME = '/usr/lib/jvm/java-21-openjdk'
let $PYTHON = 'python3.12'
source ~/.vim/vim-init/init.vim
```

注意：若把 `g:tagbar_toggle_key` 改回 `<F9>`，请同时把 `g:keymap_compile` 换成其他键位，避免两个映射互相覆盖。

---

**提示**: 按下 `<Space>` 等待 500ms 会显示 which-key 菜单，可以查看可用快捷键。
