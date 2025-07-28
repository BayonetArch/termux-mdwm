# **Termux-mdwm** #
:fire: *a simple and lightweight config for dwm with gpu acceleration in termux*   

## *PREVIEW* ##
![home screen](./images/img1.jpg)

![in terminal](./images/img2.jpg)

### **INSTRUCTIONS** ###
***for setting up the environment you need following requirements:***
- [x] termux app.
*Link:(https://github.com/termux/termux-app/releases/tag/v0.118.2)*  
>:warning:  **only use github or fdroid as playstore one is outdated**
- [x] **termux:x11** . 
*Link:(https://github.com/termux/termux-x11/releases/tag/nightly)*
- [x] **termux:api** .
*Link: (https://github.com/termux/termux-api/releases/tag/v0.51.0)*
- [x] **internet connection**

### first step ###
*first update the system and install git  by running following command*
```bash
apt update -y && apt upgrade -y  && apt install git -y && termux-setup-storage
```
> *CLICK ON ALLOW WHILE SETTING UP STORAGE*
### second step ###
**clone the repo and run install.sh**
```bash
git clone https://github.com/BayonetArch/termux-mdwm.git 
cd termux-mdwm
./install.sh
```


## **That's it you have succesfully installed the desktop** ##
*run the desktop by running*
```bash
start
```
# DWM Keybindings (My Build)


---

## Modifier Key

- **MODKEY**:it's set to `Alt`.

---

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

- If you want to change `MODKEY`, look for `#define MODKEY` in `config.h`.
- You can customize `termcmd`, `browsercmd`, etc., in the same file to use your preferred apps.

## Tips

- Use floating mode (`Alt + g`) when apps don't tile well.
- Combine `Alt + Shift + q` to cleanly close windows while staying on track.
- Customize `dmenu` with your own font/colors to match your rice.


## setup rofi launcher 

clone the repo :
   ```bash
   git clone --depth 1 https://BayonetArch/termux-mdwm.git && cd termux-mdwm 

   ```
run `setup_rofi`script :
    
   ```bash
    chmod +x ./setup_rofi.sh && ./setup_rofi.sh
   ```

done !!

## Need Help?

If you run into any issues or have questions, feel free to ask in the comments on my [YouTube channel](https://www.youtube.com/@Bayonet7). I’ll try to respond as soon as I can.
