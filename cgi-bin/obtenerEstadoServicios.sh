#!/bin/sh


postfix=$(systemctl status postfix | head -n 3 | tail -n 1 | awk '{print $2}')
dovecot=$(systemctl status dovecot | head -n 3 | tail -n 1 | awk '{print $2}')
ssh=$(systemctl status ssh | head -n 3 | tail -n 1 | awk '{print $2}')
rsyslog=$(systemctl status rsyslog | head -n 3 | tail -n 1 | awk '{print $2}')
mariadb=$(systemctl status mariadb | head -n 3 | tail -n 1 | awk '{print $2}')
apache2=$(systemctl status apache2 | head -n 3 | tail -n 1 | awk '{print $2}')

perl estadoSistema.pl "$postfix" "$dovecot" "$ssh" "$rsyslog" "$mariadb" "$apache2"
