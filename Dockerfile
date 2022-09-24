FROM hpretl/iic-osic-tools:latest
# copy data into docker container
COPY xschem/ /foss/data
COPY ngspice-runner.sh /foss/data
RUN ls -la /foss/data
RUN ls -la /foss/data/simulation

CMD ["-s", "/foss/data/ngspice-runner.sh"]
#CMD ["-s", "ls", "-l"]
