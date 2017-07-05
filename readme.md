## HexChat - 

<h4>
Dev Branch: <a href="https://travis-ci.org/codemonkeyrawks/HexChat/branches"><img src="https://travis-ci.org/codemonkeyrawks/HexChat.svg?branch=dev" alt="" width="80px" align="top"></a>
-
Master Branch: <a href="https://travis-ci.org/codemonkeyrawks/HexChat/branches"><img src="https://travis-ci.org/codemonkeyrawks/HexChat.svg?branch=master" alt="" width="80px" align="top"></a>
</h4>

#### Folder Structure:

    Main Project:
    *.pl - Perl Scripts for HexChat *Note: They do not run without HexChat*
    readme.md - Getting Started Guide
    
    Testing:
    .travis.yml - Used for Testing Only (Checks if Code Passes or Not)

#### Building:
```shell
Open Terminal and Run:
# sudo apt-get install git
# git clone https://github.com/codemonkeyrawks/HexChat.git
# mv /HexChat/*.pl "/home/$USER/.config/hexchat/addons"
# mv /HexChat/*.conf "/home/$USER/.config/hexchat"
# rm -rf HexChat
```
