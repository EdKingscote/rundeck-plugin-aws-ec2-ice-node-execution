FROM rundeck/rundeck:latest
USER root
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install unzip curl python3 python-is-python3 groff \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \ 
    && unzip awscliv2.zip \ 
    && ./aws/install
USER rundeck
