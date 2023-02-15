# Telescope
- fuzy find all symbols
```
install ripgrep and use in normal mode :Telescope live_grep
```
Could be slow in large projects, alternatively do:
```
:Telescope grep_string search=sometext and them be able to fuzzy search
```
## help_tags can search through documentation.

# Emoji support
install and use proper font 💯
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<!--
Noto Mono + Color Emoji Font Configuration.
Currently the only Terminal Emulator I'm aware that supports colour fonts is Konsole.
Usage:
0. Ensure that the Noto fonts are installed on your machine.
1. Install this file to ~/.config/fontconfig/conf.d/99-noto-mono-color-emoji.conf
2. Run `fc-cache`
3. Set Konsole to use "Noto Mono" as the font.
4. Restart Konsole.
-->
<fontconfig>
  <match>
    <test name="family"><string>Noto Mono</string></test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Noto Color Emoji</string>
    </edit>
  </match>
</fontconfig>
```
And now 🔥

# Emojii and nerd font support
Install font from https://www.nerdfonts.com/font-downloads 
- download file
- unzip into .fonts e.g.
```
unzip FiraCode.zip -d ~/.fonts 
``` 
- refresh cache 
```
fc-cache -fv
```
- change console font to picked one

