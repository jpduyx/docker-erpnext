FROM ubuntu:16.04
MAINTAINER JPDuyx based on lukptr <lukptr@ridhosribumi.com>

ENV FRAPPE_USER=frappe \
    MYSQL_PASSWORD=12345678 \
    ADMIN_PASSWORD=12345678 \
    ERPNEXT_APPS_JSON=https://raw.githubusercontent.com/frappe/bench/master/install_scripts/erpnext-apps-master.json \
    DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y wget python sudo curl && rm -rf /var/lib/apt/lists/*
RUN useradd $FRAPPE_USER && mkdir /home/$FRAPPE_USER && chown -R $FRAPPE_USER.$FRAPPE_USER /home/$FRAPPE_USER
WORKDIR /home/$FRAPPE_USER
RUN wget https://raw.githubusercontent.com/frappe/bench/master/playbooks/install.py && sed -i "s/'', ''/'$MYSQL_PASSWORD', '$ADMIN_PASSWORD'/g" install.py
COPY setup.sh /
RUN bash /setup.sh
COPY all.conf /etc/supervisor/conf.d/
EXPOSE 80

CMD ["/usr/bin/supervisord","-n"]
