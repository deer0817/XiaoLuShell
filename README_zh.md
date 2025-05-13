## XiaoLuShell - 有趣的 Shell 脚本

#### me.sh

> 可自定义的关于我

```sh
用法: me.sh [选项]
选项:
  --name <name>           指定名称 (默认: deer0817)
  --github <github>       指定 GitHub 链接 (默认: https://github.com/deer0817)
  --desc <description>    指定描述 (默认: About me)
  --date <date>           指定修改日期 (默认: 2025-05-12)
  --ascii-color <color>   指定 ASCII 颜色 (默认: skyblue)
  --ascii-str <string>    指定 ASCII 字符串 (默认: XIAOLU)
  --ascii-font <font>     指定 ASCII 字体 (默认: miniwi)
  --list-font             列出可用字体
  --list-color            列出可用 ASCII 颜色
  --help                  显示帮助信息
  --version               显示版本信息
```

![me.sh](https://cdn.jsdelivr.net/gh/deer0817/XiaoLuShell/preview/me.png)

- 快速开始

```sh
bash <(curl -sSL https://static.zloved.me/shell/me.sh) --ascii-color cyan
```

#### draw_char.sh

> 可自定义的 ASCII 字符画

```sh
用法: draw_char.sh [选项]
选项:
  --font <font_name>       指定字体名称 (默认: miniwi)
  --font-file <file_path>  指定字体文件路径 (本地或远程)
  --str <string>           指定要绘制的字符串 (默认: XIAOLU)
  --color <color_name>     指定颜色 (默认: plain)
  --to-bash <true|false>   将输出转换为 bash 命令 (默认: false)
  --list-font              列出可用字体
  --list-color             列出可用颜色
  --help                   显示帮助信息
  --version                显示版本信息
```

![draw_char.sh](https://cdn.jsdelivr.net/gh/deer0817/XiaoLuShell/preview/draw_char.png)

- 快速开始

```sh
bash <(curl -sSL https://static.zloved.me/shell/draw_char.sh) --font ANSI_Shadow
```