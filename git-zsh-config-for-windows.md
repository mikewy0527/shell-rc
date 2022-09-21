## Install zsh for git-for-windows (git-Bash)

0. install `weasel-0.14.3.0-installer.exe`
1. install `zsh-5.8-3-x86_64.pkg.tar.xz`
2. terminal color scheme:
```
{
    "profiles": {
        "list": [
            {
                "antialiasingMode": "grayscale",
                "colorScheme": "Breeze Dark",
                "commandline": "C:/Program Files/Git/bin/bash.exe -c \"/usr/bin/zsh -l -i\"",
                "cursorShape": "filledBox",
                "font":
                {
                    "face": "Fira Code Retina",
                    "size": 10
                },
                "guid": "{0e2b3041-5574-4917-9b6a-50f99bc1819d}",
                "hidden": false,
                "icon": "C:/Program Files/Git/mingw64/share/git/git-for-windows.ico",
                "name": "Git Zsh",
                "opacity": 95,
                "startingDirectory": "%USERPROFILE%",
                "suppressApplicationTitle": false,
                "useAcrylic": false
            }
        ]
    },
    "schemes": [
        {
            "background": "#242A32",
            "black": "#242A32",
            "blue": "#1D99F3",
            "brightBlack": "#7F8C8D",
            "brightBlue": "#3DAEE9",
            "brightCyan": "#16A085",
            "brightGreen": "#19CA8C",
            "brightPurple": "#8E44AD",
            "brightRed": "#BA362A",
            "brightWhite": "#AFB4BC",
            "brightYellow": "#E6AB45",
            "cursorColor": "#FFFFFF",
            "cyan": "#1ABC9C",
            "foreground": "#BEC3C8",
            "green": "#10BE13",
            "name": "Breeze Dark",
            "purple": "#9B59B6",
            "red": "#D61313",
            "selectionBackground": "#CFCFCF",
            "white": "#BEC3C8",
            "yellow": "#EC6E00"
        },
    ]
}
```
4. config `.minttyrc`:
```
CursorType=block
Term=xterm-256color
CursorBlinks=no
Font=Fira Code Retina
FontHeight=10
FontWeight=450
ThemeFile=
Transparency=7
Locale=en_US
Charset=UTF-8
Columns=120
Rows=40

ForegroundColour=190,195,200
BackgroundColour=36,42,50
CursorColour=220,220,220

Black=36,42,50
BoldBlack=127,140,141
Red=214,19,19
BoldRed=186,54,42
Green=16,190,19
BoldGreen=25,202,140
Yellow=236,110,0
BoldYellow=230,171,69
Blue=29,153,243
BoldBlue=61,174,233
Magenta=155,89,182
BoldMagenta=142,68,173
Cyan=26,188,156
BoldCyan=22,160,133
White=190,195,200
BoldWhite=175,180,188

FontSmoothing=full
RightClickAction=paste
Language=en_US
ClipShortcuts=no
RewrapOnResize=no
CtrlShiftShortcuts=yes
```
5. create shortcut for `Git-Zsh`, Path: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Git`
```
Target: "C:\Program Files\Git\usr\bin\mintty.exe" --dir "%USERPROFILE%" -- /usr/bin/zsh -l -i
```

## Tips:
1. mount:
```
mount -fo binary,noacl,posix=0,user <target-driver> <mount-point>
```
2.  make /<drive>/... autocompletion work.
```
# make /<drive>/... autocompletion work.
# e.g: /c/Windows/
local drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
zstyle ':completion:*' fake-files /: "/:$drives"
# local drives=($(mount | command grep --perl-regexp '^\w: on /\w ' | cut --delimiter=' ' --fields=3))
# zstyle ':completion:*' fake-files "/:${(j. .)drives//\//}"
unset drives
```
