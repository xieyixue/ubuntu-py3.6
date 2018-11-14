FROM ubuntu

RUN apt-get update \
    apt-get install -y software-properties-common vim  openssh-server \
    add-apt-repository ppa:jonathonf/python-3.6 \
    apt-get update \

    apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv \
    apt-get install -y git

# update pip
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
ENV PYTHONIOENCODING=utf-8
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
