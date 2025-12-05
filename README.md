# Termux-mdwm #
simple and lightweight config for dwm with gpu acceleration in termux   

## PREVIEW ##
![home screen](./images/img1.jpg)

![in terminal](./images/img2.jpg)

### INSTRUCTIONS ###
for setting up the environment you need following requirements:

- termux-app from [github](https://github.com/termux/termux-app/releases) or [fdroid](https://f-droid.org/packages/com.termux/)

- <a href="https://github.com/termux/termux-x11/releases/tag/nightly">termux:x11</a>
- <a href="https://github.com/termux/termux-api/releases">termux:api</a>
- internet connection

### first step ###
first update the system and install git  by running following command
```bash
apt update -y && apt upgrade -y  && apt install git -y && termux-setup-storage
```
click on allow.

### second step ###
clone the repo and run install.sh
```bash
git clone https://github.com/BayonetArch/termux-mdwm.git 
cd termux-mdwm
./install.sh
```


## you have succesfully installed the desktop ##
run the desktop by running
```bash
start
```
# Keybindings
Modifier is set to `Alt`


## Application Launching

| Shortcut        | Action                  |
|----------------|--------------------------|
| `Alt + d`      | Launch `dmenu`          |
| `Alt + Enter`  | Launch terminal          |
| `Alt + b`      | Launch browser           |

---

## Window Management

| Shortcut        | Action                          |
|----------------|----------------------------------|
| `Alt + q`      | Close focused window             |
| `Alt + f`      | Toggle fullscreen for a window   |
| `Alt + g`      | Toggle floating mode             |
| `Alt + j`      | Focus next window in stack       |
| `Alt + k`      | Focus previous window in stack   |

---

## Layouts & Tags

| Shortcut              | Action                        |
|-----------------------|-------------------------------|
| `Alt + [1-9]`         | Switch to tag (workspace)     |
| `Alt + Shift + [1-9]` | Move window to tag            |
| Click on layout icon  | Cycle through layouts         |

---

## Notes
You can change bindings and other stuff at `config.h`.


## setup rofi launcher 

clone the repo :
   ```bash
   git clone --depth 1 https://github.com/BayonetArch/termux-mdwm.git && cd termux-mdwm 

   ```
run `setup_rofi`script :
    
   ```bash
    chmod +x ./setup_rofi.sh && ./setup_rofi.sh
   ```

done !!

## Need Help?

If you run into any issues or have questions, feel free to ask in the comments on my [YouTube channel](https://www.youtube.com/@Bayonet7). I’ll try to respond as soon as I can.
