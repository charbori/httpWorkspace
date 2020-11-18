#docker run -it -u user <image name>

FROM ubuntu:16.04
#빌드시 환경변수 및 언어 설정 안 하면
#repository 설정할 때 에러 생김
ENV DEBIAN_FRONTEND noninteractive

ENV LC_ALL=C.UTF-8
ENV LANGUAGE=ko
#MAINTAINER jaehyeok <charbori@github.com>

#user를 생성하고
#sudo 권한 주기
#해당 계정으로 시작하기
#RUN apt-get update && apt-get install -y sudo

#RUN adduser --disabled-password --gecos "" user \ 
#        && echo 'user:user' | chpasswd \ 
#        && adduser user sudo \ 
#        && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#USER user

# sudo 매번 붙이기 않게 하기
#sudo groupadd docker
#sudo usermod -aG docker $USER
#newgrp docker

#ARG 빌드하는 동안에만 사용할 수 있는 설정들
#ARG DEBIAN_FRONTEND=noninteractive

#apache php mysql 설치
RUN apt update 
RUN apt install -y apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid


RUN apt install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php
RUN apt update
#php 7.3 코어 설치
# 보편적으로 많이 사용하는 패키지들 설치
RUN apt install -y php7.4 php7.4-common php7.4-cli
RUN apt install -y php7.4-bcmath php7.4-bz2 php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-readline php7.4-xml php7.4-zip
# 아파치와 연동
RUN apt install -y libapache2-mod-php7.3
# 편리한 편집을 위해 vim도 설치해 줍니다.
RUN apt install -y vim

RUN echo "mysql-server mysql-server/root_password password" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password" | debconf-set-selections
RUN apt install -y mysql-server-5.7
#RUN apache2 -v
#RUN php -v
#RUN mysql -v

#file 생성
RUN cd /home
RUN mkdir workspace
#add [복사할 로컬 프로젝트 파일 경로] [복사할 컨테이너 내부의 파일 경로]
#add [복사할 로컬 프로젝트 폴더 경로] [복사할 컨테이너 내부의 경로]
# *.[파일 형식] 가능
COPY index.php /home/workspace/index.php
COPY default.conf /etc/apache2/sites-available/default.conf
COPY apache2.conf /etc/apache2/apache2.conf
COPY mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
RUN ln -s /etc/apache2/sites-available/defualt.conf /etc/apache2/sites-enabled/
 
RUN service apache2 restart

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]