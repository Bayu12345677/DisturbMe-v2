setup:
	apt-get update
	apt-get upgrade
	apt-get install ruby python ossp-uuid figlet pv toilet nodejs openssl-tool file silversearcher-ag zsh -y
	apt-get install curl xh ncurses-utils tree jq clang bc nodejs-lts xz-utils nala ripgrep binutils gum pv -y
	pip install -r module.txt
	pip uninstall urllib3 -y
	pip install urllib3
	pip install httpie
	pip install phonenumbers
	@gem install lolcat
	@npm -g i chalk chalk-animation
	@echo "[+] paket berhasil di setup"

Run:
	@echo "[  INPO ] update kali ini mungkin akan sangat lama saat menjalankan script"
	@echo "[  INPO ] Security Pyramid ENCIENT: 10.0.0"
	@echo "[  MSG  ] SCRIPT INI FREE, DAN HANYA ADA DI YOUTUBE PEJUANG KENTANG"
	@echo "[  MSG  ] KALO UDAH DAPAT TOKEN JANGAN DI BAGI BAGIKAN MEK"
	@echo "[  MSG  ] REPOST BOLEH ASAL NGOTAK"
	@bash app.d
