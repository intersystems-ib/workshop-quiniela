ARG IMAGE=containers.intersystems.com/intersystems/iris-ml-community:latest-cd
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown -R irisowner:irisowner /opt/irisapp

RUN apt-get update && apt-get install -y python3

RUN apt-get update && \
    apt-get install -y libgl1-mesa-glx libglib2.0-0

# install required packages
COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP /requirements.txt /
RUN chmod 777 /requirements.txt

RUN pip3 install -r /requirements.txt

USER irisowner

# copy files to image
WORKDIR /opt/irisapp
COPY --chown=irisowner:irisowner src src

COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP /iris/irissession.sh /
RUN chmod +x /irissession.sh

COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP /iris/webapp.xml /
RUN chmod +x /webapp.xml

SHELL ["/irissession.sh"]

RUN \
zn "%SYS" \
set sc = $SYSTEM.OBJ.LoadDir("/opt/irisapp/src/Test", "ck", , 1) \
if sc do ##class(Test.Installer).Install() \
zn "QUINIELA" \
# load lookup tables
set sc = $SYSTEM.OBJ.LoadDir("/opt/irisapp/src/QUINIELA", "ck", , 1) \
# start production
set production = "QUINIELA.Production" \
set ^Ens.Configuration("csp","LastProduction") = production \
do ##class(Ens.Director).SetAutoStart(production) \
set sc = 1 \ 
zn "%SYS" \
do ##class(Security.Applications).Import("/webapp.xml",.n) \