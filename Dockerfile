FROM ubuntu:bionic

USER root

# Install the things needed
RUN apt update
RUN apt install -yq build-essential
RUN apt install -yq libreadline7 libreadline-dev
RUN apt install -yq curl
RUN apt install -yq git

# Setup directory structure
RUN mkdir /opt/epics
RUN mkdir /opt/epics/modules

# Download EPICS 7 base
RUN curl -L https://epics-controls.org/download/base/base-7.0.4.1.tar.gz > base.tar.gz
RUN tar xvzf base.tar.gz
RUN rm base.tar.gz
RUN mv base-* /opt/epics/base

# Download ASYN
RUN curl -L https://epics.anl.gov/download/modules/asyn4-38.tar.gz > asyn.tar.gz
RUN tar xvzf asyn.tar.gz
RUN rm asyn.tar.gz
RUN mv asyn4-* asyn
RUN mv asyn /opt/epics/modules
# Copy in custom RELEASE file
COPY files/asyn_RELEASE /opt/epics/modules/asyn/configure/RELEASE

# Download Autosave
RUN curl -L https://github.com/epics-modules/autosave/archive/R5-10-1.tar.gz > autosave.tar.gz
RUN tar xvzf autosave.tar.gz
RUN rm autosave.tar.gz
RUN mv autosave-* autosave
RUN mv autosave /opt/epics/modules
# Copy in custom RELEASE file
COPY files/autosave_RELEASE /opt/epics/modules/autosave/configure/RELEASE

# Download Busy
RUN curl -L https://github.com/epics-modules/busy/archive/R1-7-2.tar.gz > busy.tar.gz
RUN tar xvzf busy.tar.gz
RUN rm busy.tar.gz
RUN mv busy* busy
RUN mv busy /opt/epics/modules
# Copy in custom RELEASE file
COPY files/busy_RELEASE /opt/epics/modules/busy/configure/RELEASE

# Download SSCAN
RUN curl -L https://github.com/epics-modules/sscan/archive/R2-11-3.tar.gz > sscan.tar.gz
RUN tar xvzf sscan.tar.gz
RUN rm sscan.tar.gz
RUN mv sscan* sscan
RUN mv sscan /opt/epics/modules
# Copy in custom RELEASE file
COPY files/sscan_RELEASE /opt/epics/modules/sscan/configure/RELEASE

# Download Calc
RUN curl -L https://github.com/epics-modules/calc/archive/R3-7-4.tar.gz > calc.tar.gz
RUN tar xvzf calc.tar.gz
RUN rm calc.tar.gz
RUN mv calc* calc
RUN mv calc /opt/epics/modules
# Copy in custom RELEASE file
COPY files/calc_RELEASE /opt/epics/modules/calc/configure/RELEASE

# Download AreaDetector
RUN curl -L https://github.com/areaDetector/areaDetector/archive/R3-9.tar.gz > ad.tar.gz
RUN tar xvzf ad.tar.gz
RUN rm ad.tar.gz
RUN mv areaDetector* areaDetector
RUN mv areaDetector /opt/epics/modules

# Download ADCore
RUN curl -L https://github.com/areaDetector/ADCore/archive/R3-9.tar.gz > adcore.tar.gz
RUN tar xvzf adcore.tar.gz
RUN rm adcore.tar.gz
RUN mv ADCore* ADCore
RUN mv ADCore /opt/epics/modules/areaDetector

# Download ADSupport
RUN curl -L https://github.com/areaDetector/ADSupport/archive/R1-4.tar.gz > adsup.tar.gz
RUN tar xvzf adsup.tar.gz
RUN rm adsup.tar.gz
RUN mv ADSupport* ADSupport
RUN mv ADSupport /opt/epics/modules/areaDetector

# Download ADSimDetector
RUN curl -L https://github.com/areaDetector/ADSimDetector/archive/R2-10.tar.gz > adsim.tar.gz
RUN tar xvzf adsim.tar.gz
RUN rm adsim.tar.gz
RUN mv ADSimDetector* ADSimDetector
RUN mv ADSimDetector /opt/epics/modules/areaDetector

# Copy AreaDetector config files in
COPY files/AD_CONFIG_SITE.local /opt/epics/modules/areaDetector/configure/CONFIG_SITE.local
COPY files/AD_RELEASE_LIBS.local /opt/epics/modules/areaDetector/configure/RELEASE_LIBS.local
COPY files/AD_RELEASE_PRODS.local /opt/epics/modules/areaDetector/configure/RELEASE_PRODS.local
COPY files/AD_RELEASE.local /opt/epics/modules/areaDetector/configure/RELEASE.local

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

# Build AreaDetector
RUN cd /opt/epics/modules/areaDetector && make

# Build sim detector IOC
RUN cd /opt/epics/modules/areaDetector/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector && make
COPY files/AD_st_base.cmd /opt/epics/modules/areaDetector/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector/st_base.cmd

# Expose the standard EPICS and V4 ports
EXPOSE 5064 5065 5064/udp 5075 5076 5075/tcp 5076/udp

# Set path
RUN export PATH=/opt/epics/base/bin/linux-x86_64:$PATH

# Start the IOC
CMD cd /opt/epics/modules/areaDetector/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector/ && ../../bin/linux-x86_64/simDetectorApp st.cmd
