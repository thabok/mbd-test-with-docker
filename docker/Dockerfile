# Starting from public image mathworks/matlab & btces/ep
# with default versions definde below (can be overwritten during build)
ARG EP_RELEASE=24.2p0
ARG MATLAB_RELEASE=R2023b

FROM btces/ep:${EP_RELEASE} AS ep
FROM mathworks/matlab:${MATLAB_RELEASE} AS matlab

# add arg to make it accessible in this layer
ARG MATLAB_RELEASE
ARG MATLAB_PRODUCTS="Embedded_Coder AUTOSAR_Blockset MATLAB_Coder Simulink Simulink_Coder Simulink_Coverage Stateflow"

USER root
RUN apt update && apt-get install -y wget
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && chmod +x mpm \
    && ./mpm install \
    --release=${MATLAB_RELEASE}  \
    --destination=/opt/matlab  \
    --products ${MATLAB_PRODUCTS} \
    && rm -f mpm /tmp/mathworks_root.log \
    && ln -f -s /opt/matlab/bin/matlab /usr/local/bin/matlab

# License location can alternatively be provided during runtime
# ENV MLM_LICENSE_FILE=27000@matlab.license.server
ARG ML_LIC_PATH=/licenses/matlab.lic
ENV MLM_LICENSE_FILE=${ML_LIC_PATH}

# ----------------------------------------------------------------------------------------
# BTC EmbeddedPlatform specific configurations
# ----------------------------------------------------------------------------------------

# required and variables
ARG EP_RELEASE
ARG EP_INSTALL_PATH=/opt/ep
ENV EP_INSTALL_PATH=${EP_INSTALL_PATH}
ARG EP_WORK_DIR_ROOT=/tmp/ep
ENV EP_WORK_DIR_ROOT=${EP_WORK_DIR_ROOT}
ARG EP_REGISTRY=/opt/Configuration/eplinuxregistry
ENV EP_REGISTRY=${EP_REGISTRY}
ARG EP_LOG_CONFIG=${EP_INSTALL_PATH}/configuration/logback_linux.xml
ENV EP_LOG_CONFIG=${EP_LOG_CONFIG}
ARG REST_PORT
ENV REST_PORT=${REST_PORT:-8080}
EXPOSE ${REST_PORT}

ARG LICENSE_LOCATION=/licenses/btc.lic
ENV LICENSE_LOCATION=${LICENSE_LOCATION}
ARG LICENSE_PACKAGES
ENV LICENSE_PACKAGES=${LICENSE_PACKAGES:-ET_COMPLETE}
ARG TMP_DIR
ENV TMP_DIR=${TMP_DIR:-${EP_WORK_DIR_ROOT}/tmp}
ARG LOG_DIR
ENV LOG_DIR=${LOG_DIR:-${EP_WORK_DIR_ROOT}/logs}
ARG WORK_DIR
ENV WORK_DIR=${WORK_DIR:-${EP_WORK_DIR_ROOT}/workdir}

# Copy files from public image btces/ep
COPY --chown=1000 --from=ep /opt/jres /opt/jres
COPY --chown=1000 --from=ep /opt/Configuration/eplinuxregistry ${EP_REGISTRY}
COPY --chown=1000 --from=ep /root/.BTC/ep/${EP_RELEASE}/config/compiler_pref/compiler_setup.xml /root/.BTC/ep/${EP_RELEASE}/config/compiler_pref/compiler_setup.xml
COPY --chown=1000 --from=ep /opt/ep ${EP_INSTALL_PATH}

# and some files from the build context
COPY --chown=1000 addMLIntegration.bash /tmp/
RUN sudo chmod +x /tmp/addMLIntegration.bash && sudo /tmp/addMLIntegration.bash && sudo rm /tmp/addMLIntegration.bash

# install python module btc_embedded
RUN pip3 install --no-cache-dir btc_embedded
ENV PYTHONUNBUFFERED=1

# ----------------------------------------------------------------------------------------
# Optional settings for BTC
# ----------------------------------------------------------------------------------------
# to be able to migrate old *.epp profiles:
# COPY --chown=1000 --from=ep-migrator /opt/migrator /opt/migrator
# alternative: copy only a single migrator, e.g. if none of the profile are older than 23.3.0
# COPY --chown=1000 --from=ep-migrator /opt/migrator/23.3.0 /opt/migrator/23.3.0

USER matlab
COPY matlab.lic ${ML_LIC_PATH}
COPY btc.lic ${LICENSE_LOCATION}

RUN python3 -c "from btc_embedded import EPRestApi;ep=EPRestApi(skip_matlab_start=True);exit()"  && rm ${LOG_DIR}/current.log

CMD [ ]