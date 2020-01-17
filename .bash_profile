#----- bounties -----
bbounties(){
echo "$(tput setaf 1)bmkdir $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setab 7)#----- tools -----$(tput sgr 0)"
echo "$(tput setaf 1)bdirb $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setaf 1)bnmaptcp $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setaf 1)bnmapudp $(tput setab 7)artssec.com$(tput sgr 0)"

echo "$(tput setab 7)#----- recon -----$(tput sgr 0)"
echo "$(tput setaf 1)bamass $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setaf 1)bassetfinder $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setaf 1)bsublist3r $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setaf 1)bcertspotter $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setaf 1)bcrt $(tput setab 7)artssec.com$(tput sgr 0)"
echo "$(tput setaf 1)brecon $(tput setab 7)artssec.com$(tput sgr 0)"
}

#----- mkdir -----
bmkdir(){
dia=$(date '+%Y-%m-%d')
mkdir -p /home/pentest/compartido_docker/prueba/${1}/${dia}/dirb/
mkdir -p /home/pentest/compartido_docker/prueba/${1}/${dia}/nmap/
mkdir -p /home/pentest/compartido_docker/prueba/${1}/${dia}/amass/
mkdir -p /home/pentest/compartido_docker/prueba/${1}/${dia}/assetfinder/
mkdir -p /home/pentest/compartido_docker/prueba/${1}/${dia}/sublist3r/
mkdir -p /home/pentest/compartido_docker/prueba/${1}/${dia}/certspotter/
mkdir -p /home/pentest/compartido_docker/prueba/${1}/${dia}/crt/
}


#----- recon -----
bamass(){
amass enum -d ${1} -o /home/pentest/compartido_docker/prueba/${1}/${dia}/amass/amass_${1}.txt
}

bassetfinder(){
assetfinder -subs-only ${1} >> /home/pentest/compartido_docker/prueba/${1}/${dia}/assetfinder/assetfinder_${1}.txt
}

bsublist3r(){
python /home/pentest/tools/Sublist3r/sublist3r.py -d ${1} -o /home/pentest/compartido_docker/prueba/${1}/${dia}/sublist3r/sublist3r_${1}.txt
}

bcertspotter(){
curl https://certspotter.com/api/v0/certs\?domain\=${1} -s | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep ${1} >> /home/pentest/compartido_docker/prueba/${1}/${dia}/certspotter/certspotter_${1}.txt
} #h/t Jobert Abma


bcrt(){
curl -s https://crt.sh/\?q\=\%.${1}\&output\=json -s | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> /home/pentest/compartido_docker/prueba/${1}/${dia}/crt/crt${1}.txt
}

brecon(){
echo "$(tput setaf 1)bmkdir$(tput sgr 0)"
bmkdir ${1}
echo "$(tput setaf 1)bamass$(tput sgr 0)"
bamass ${1}
echo "$(tput setaf 1)bassetfinder$(tput sgr 0)"
bassetfinder ${1}
echo "$(tput setaf 1)bsublist3r$(tput sgr 0)"
bsublist3r ${1}
echo "$(tput setaf 1)bcertnmap$(tput sgr 0)"
bcertspotter ${1}
echo "$(tput setaf 1)bcertspotter$(tput sgr 0)"
bcrt ${1}
echo "$(tput setaf 1)creando archivo final de dominios$(tput sgr 0)"
cat /home/pentest/compartido_docker/prueba/${1}/${dia}/amass/amass_${1}.txt /home/pentest/compartido_docker/prueba/${1}/${dia}/assetfinder/assetfinder_${1}.txt /home/pentest/compartido_docker/prueba/${1}/${dia}/sublist3r/sublist3r_${1}.txt /home/pentest/compartido_docker/prueba/${1}/${dia}/certspotter/certspotter_${1}.txt /home/pentest/compartido_docker/prueba/${1}/${dia}/crt/crt${1}.txt >> /home/pentest/compartido_docker/prueba/${1}/${dia}/merge_${1}.txt
sort /home/pentest/compartido_docker/prueba/${1}/${dia}/merge_${1}.txt | uniq >> /home/pentest/compartido_docker/prueba/${1}/${dia}/final_${1}.txt
}


#----- tools -----
bmiip(){
curl ifconfig.io
}   


bdirb(){
#dominio=$(echo $1 | sed 's/https:\/\///g')
#screen -A -m -d -S screen_dirb_${dominio} dirb $1 /home/pentest/tools/listas/commonfinal.txt -z 2000 -o /home/pentest/compartido_docker/prueba/${1}/${dia}/dirb/$dirb_${dominio}.txt -w -R 
screen -A -m -d -S screen_dirb_${1} dirb https://$1/ /home/pentest/tools/listas/commonfinal.txt -z 2000 -o /home/pentest/compartido_docker/prueba/${1}/${dia}/dirb/$dirb_${1}.txt -w -R 
}

bnmaptcp(){
screen -A -m -d -S screen_nmaptcp_${1} nmap -Pn -sTV -vv -p- -n --max-retries 1 -oA mkdir /home/pentest/compartido_docker/prueba/${1}/${dia}/nmap/nmap_tcp_full_{1} {1}
}

bnmapudp(){
screen -A -m -d -S screen_nmaptcp_${1} sudo nmap -Pn -sUV -vv --top-ports 100 -n --max-retries 1 -oA /home/pentest/compartido_docker/prueba/${1}/${dia}/nmap/nmap_udp_top100_{1} {1}
}

