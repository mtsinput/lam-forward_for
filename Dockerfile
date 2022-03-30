FROM ldapaccountmanager/lam:7.9

COPY remote_addr_with_x_frwd_for.php /usr/share/ldap-account-manager/remote_addr_with_x_frwd_for.php
RUN chmod 644 /usr/share/ldap-account-manager/remote_addr_with_x_frwd_for.php
RUN sed -i.bkp '/auto_prepend_file/a auto_prepend_file = \/usr\/share\/ldap-account-manager\/remote_addr_with_x_frwd_for.php' /etc/php/7.4/apache2/php.ini
RUN sed -i.bkp 's/\%h/\%\{X-Forwarded-For\}i/g' /etc/apache2/apache2.conf
RUN sed -i.bkp 's/\%a/\%\{X-Forwarded-For\}i/g' /etc/apache2/apache2.conf

WORKDIR /var/lib/ldap-account-manager/config

# start Apache when container starts
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/usr/local/bin/start.sh" ]

#HEALTHCHECK --interval=1m --timeout=10s \
#    CMD wget -qO- http://localhost/lam/ | grep -q '<title>LDAP Account Manager</title>'
