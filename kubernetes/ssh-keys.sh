#!/bin/bash 
for server in `cat list_of_servers`; do
	ssh-copy-id -i ~/.ssh/ansible aaron@$server
done

ansible kubeservers -m user -a "name=ansible groups=sudo append=yes shell=/bin/bash" -i hosts.ini --key-file "~/.ssh/ansible" --become
ansible kubeservers -m file -a "dest=/home/ansible/.ssh state=directory" -i hosts.ini --key-file "~/.ssh/ansible" --become
ansible kubeservers -m shell -a "cat /home/aaron/.ssh/authorized_keys >> /home/ansible/.ssh/authorized_keys; chmod 600 /home/ansible/.ssh/authorized_keys" -i hosts.ini --key-file "~/.ssh/ansible" --become
ansible kubeservers -m file -a "dest=/home/ansible/.ssh/authorized_keys mode=600 owner=ansible group=ansible" -i hosts.ini --key-file "~/.ssh/ansible" --become
ansible kubeservers -m lineinfile -a "path=/etc/sudoers state=present regexp='^%sudo' line='%sudo ALL=(ALL) NOPASSWD: ALL' validate='visudo -cf %s'" -i hosts.ini --key-file "~/.ssh/ansible" --become
