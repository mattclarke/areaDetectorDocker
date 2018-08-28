FROM ubuntu:bionic

USER root

# Install the things needed
RUN apt-get update
RUN apt-get install -yq build-essential
RUN apt-get install -yq libreadline7 libreadline-dev
RUN apt-get install -yq wget
RUN apt-get install -yq git

# Download EPICS base
RUN wget --quiet https://epics.anl.gov/download/base/base-3.15.5.tar.gz
RUN tar xvzf base-3.15.5.tar.gz
RUN mkdir /opt/epics
RUN mv base-3.15.5 /opt/epics/base
RUN rm base-3.15.5.tar.gz

# Download ASYN
RUN wget --quiet https://www.aps.anl.gov/epics/download/modules/asyn4-33.tar.gz
RUN tar xvzf asyn4-33.tar.gz
RUN mkdir /opt/epics/modules
RUN mv asyn4-33 asyn
RUN mv asyn /opt/epics/modules
# Copy in custom RELEASE file
COPY files/asyn_RELEASE /opt/epics/modules/asyn/configure/RELEASE
RUN rm asyn4-33.tar.gz

# Download Autosave
RUN wget --quiet https://github.com/epics-modules/autosave/archive/R5-9.tar.gz
RUN tar xvzf R5-9.tar.gz
RUN mv autosave-R5-9 autosave
RUN mv autosave /opt/epics/modules
# Copy in custom RELEASE file
COPY files/autosave_RELEASE /opt/epics/modules/autosave/configure/RELEASE
RUN rm R5-9.tar.gz

# Download Busy
RUN wget --quiet https://github.com/epics-modules/busy/archive/R1-7.tar.gz
RUN tar xvzf R1-7.tar.gz
RUN mv busy-R1-7 busy
RUN mv busy /opt/epics/modules
# Copy in custom RELEASE file
COPY files/busy_RELEASE /opt/epics/modules/busy/configure/RELEASE
RUN rm R1-7.tar.gz

# Download SSCAN
RUN wget --quiet https://github.com/epics-modules/sscan/archive/R2-11.tar.gz
RUN tar xvzf R2-11.tar.gz
RUN mv sscan-R2-11 sscan
RUN mv sscan /opt/epics/modules
# Copy in custom RELEASE file
COPY files/sscan_RELEASE /opt/epics/modules/sscan/configure/RELEASE
RUN rm R2-11.tar.gz

# Download Calc
RUN wget --quiet https://github.com/epics-modules/calc/archive/R3-7-1.tar.gz
RUN tar xvzf R3-7-1.tar.gz
RUN mv calc-R3-7-1 calc
RUN mv calc /opt/epics/modules
# Copy in custom RELEASE file
COPY files/calc_RELEASE /opt/epics/modules/calc/configure/RELEASE
RUN rm R3-7-1.tar.gz

# Build EPICS base
RUN cd /opt/epics/base && make

# Build ASYN
RUN cd /opt/epics/modules/asyn && make

# Build Autosave
RUN cd /opt/epics/modules/autosave && make

# Build Busy
RUN cd /opt/epics/modules/busy && make

# Build SSCAN
RUN cd /opt/epics/modules/sscan && make

# Build Calc
RUN cd /opt/epics/modules/calc && make
