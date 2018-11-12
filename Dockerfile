#FROM tomcat:7.0.70-jre7-alpine
#ADD ./target/ROOT.war /usr/local/tomcat/webapps/mybank.war

FROM tomcat:9.0-jre10-slim

RUN apt-get update \
     && apt-get install --reinstall -y locales \
     && sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen \
     && locale-gen zh_CN.UTF-8

COPY ./target/ROOT.war /usr/local/tomcat/webapps/mybank.war

# Remove default-apps, create user, move tomcat folder, adjust owner
RUN rm -rf /usr/local/tomcat/webapps/docs \
    && rm -rf /usr/local/tomcat/webapps/examples \
    && rm -rf /usr/local/tomcat/webapps/host-manager \
    && rm -rf /usr/local/tomcat/webapps/manager \
    && useradd -ms /bin/bash tcuser \
    && mv /usr/local/tomcat /home/tcuser/ \
    && chown -R tcuser:tcuser /home/tcuser/tomcat

USER tcuser
WORKDIR /home/tcuser

ENV CATALINA_HOME /home/tcuser/tomcat
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN
ENV LC_ALL zh_CN.UTF-8
ENV TZ="Asia/Shanghai"

ENTRYPOINT ["/home/tcuser/tomcat/bin/catalina.sh", "run"]

EXPOSE 8080