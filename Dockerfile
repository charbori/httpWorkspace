#docker run -it -u user <image name>

FROM ubuntu:16.04
#����� ȯ�溯�� �� ��� ���� �� �ϸ�
#repository ������ �� ���� ����
ENV DEBIAN_FRONTEND noninteractive

ENV LC_ALL=C.UTF-8
ENV LANGUAGE=ko
#MAINTAINER jaehyeok <charbori@github.com>

#user�� �����ϰ�
#sudo ���� �ֱ�
#�ش� �������� �����ϱ�
#RUN apt-get update && apt-get install -y sudo

#RUN adduser --disabled-password --gecos "" user \ 
#        && echo 'user:user' | chpasswd \ 
#        && adduser user sudo \ 
#        && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#USER user

# sudo �Ź� ���̱� �ʰ� �ϱ�
#sudo groupadd docker
#sudo usermod -aG docker $USER
#newgrp docker

#ARG �����ϴ� ���ȿ��� ����� �� �ִ� ������
#ARG DEBIAN_FRONTEND=noninteractive

#apache php mysql ��ġ
RUN apt update 
RUN apt install -y apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid


RUN apt install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php
RUN apt update
#php 7.3 �ھ� ��ġ
# ���������� ���� ����ϴ� ��Ű���� ��ġ
RUN apt install -y php7.4 php7.4-common php7.4-cli
RUN apt install -y php7.4-bcmath php7.4-bz2 php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-readline php7.4-xml php7.4-zip
# ����ġ�� ����
RUN apt install -y libapache2-mod-php7.3
# ���� ������ ���� vim�� ��ġ�� �ݴϴ�.
RUN apt install -y vim

RUN echo "mysql-server mysql-server/root_password password" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password" | debconf-set-selections
RUN apt install -y mysql-server-5.7
#RUN apache2 -v
#RUN php -v
#RUN mysql -v

#file ����
RUN cd /home
RUN mkdir workspace
#add [������ ���� ������Ʈ ���� ���] [������ �����̳� ������ ���� ���]
#add [������ ���� ������Ʈ ���� ���] [������ �����̳� ������ ���]
# *.[���� ����] ����
COPY index.php /home/workspace/index.php
COPY default.conf /etc/apache2/sites-available/default.conf
COPY apache2.conf /etc/apache2/apache2.conf
COPY mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
RUN ln -s /etc/apache2/sites-available/defualt.conf /etc/apache2/sites-enabled/
 
RUN service apache2 restart

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]