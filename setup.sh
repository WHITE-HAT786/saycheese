#!/bin/bash

pkg uninstall cloudflared -y
ping -c 1 google.com >/dev/null 2>&1
if [ "$?" != '0' ]; then
    printf "\033[1;2;4;5;32m[\033[31m!\033[32m] \033[34mCheck your internet connection!\033[0;0;0;0;00m\n"
    exit 1
fi
printf "\033[32mSetting-up cloudflare in your system\033[00m\n"
cd $PREFIX/share >/dev/null 2>&1
rm -rf $PREFIX/share/cloudflare-ui >/dev/null 2>&1
git clone https://github.com/BHUTUU/cloudflare-ui
ver=$(cloudflared --version | awk '{print $2}')
if [[ $ver != 'version' ]]; then
    rm -rf $PREFIX/bin/cloudflared >/dev/null 2>&1
fi
clear
if ! hash cloudflared >/dev/null 2>&1; then
    source <(curl -fsSL "https://git.io/JinSa")
fi
clear
cat <<- VAR > $PREFIX/bin/cloudflare
#!/bin/bash
arg1="\$1"
arg2="\$2"
cd $PREFIX/share/cloudflare-ui
bash cloudflare \${arg1} \${arg2}
VAR
chmod +x $PREFIX/bin/cloudflare
printf "\n\nConfiguration completed just run 'clouflare --help' for help\n\n"

cd
rm -rf cloudflare-ui
cd saycheese

if [[ -e ngrok ]]; then
clear
printf "\n\nConfiguration Now add you ngrok auth token then start the tool \n\n"

echo -e '\e[96m   EXAMPLE AUTH CODE - ./ngrok authtoken KavOb3e638hhs9 '
echo -e '\e[96m                           |'
echo -e '\e[96m                   JUST PASTE THIS PART'
echo -e '\e[96m  (dont copy paste this dummy one)- KavOb3e638hhs973ijsiwu'
read -p $'\n\e[1;96m[\e[0m\e[1;92m+\e[0m\e[1;96m] NGROK AUTH CODE : \e[0m' name
./ngrok config add-authtoken $name
sleep 2
rm setup.sh
clear

exit

else
pkg install wget -y 
clear
wget https://github.com/uplodind/ngrok/raw/main/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
clear
printf "\n\nConfiguration Now add you ngrok auth token then start the tool \n\n"

echo -e '\e[96m   EXAMPLE AUTH CODE - ./ngrok authtoken KavOb3e638hhs9 '
echo -e '\e[96m                           |'
echo -e '\e[96m                   JUST PASTE THIS PART'
echo -e '\e[96m  (dont copy paste this dummy one)- KavOb3e638hhs973ijsiwu'
read -p $'\n\e[1;96m[\e[0m\e[1;92m+\e[0m\e[1;96m] NGROK AUTH CODE : \e[0m' name
./ngrok config add-authtoken $name
sleep 2
rm setup.sh
clear

exit



fi




