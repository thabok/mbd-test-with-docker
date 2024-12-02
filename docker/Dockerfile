# Starting from public image mathworks/matlab & btces/ep
# with default versions defined below (can be overwritten using build-args)
ARG EP_RELEASE=24.2p0
ARG MATLAB_RELEASE=R2023b

FROM btces/ep:${EP_RELEASE} AS ep
FROM mathworks/matlab:${MATLAB_RELEASE} AS matlab

# ----------------------------------------------------------------------------------------
# MATLAB-specific configurations
# ----------------------------------------------------------------------------------------
# Install required matlab products & set up license
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

ARG ML_LIC_PATH=/licenses/matlab.lic
ENV MLM_LICENSE_FILE=${ML_LIC_PATH}
# ENV MLM_LICENSE_FILE=27000@matlab.license.server

# ----------------------------------------------------------------------------------------
# BTC-specific configurations
# ----------------------------------------------------------------------------------------
# Copy files from public image btces/ep
COPY --chown=1000 --from=ep /opt /opt
COPY --chown=1000 --from=ep /root/.BTC /root/.BTC
# integrate BTC with MATLAB
RUN sudo chmod +x /opt/ep/addMLIntegration.bash && sudo /opt/ep/addMLIntegration.bash
# configure licenses
ARG LICENSE_LOCATION=/licenses/btc.lic
ENV LICENSE_LOCATION=${LICENSE_LOCATION}
# ENV LICENSE_LOCATION=27000@btc.license.server

# install python module btc_embedded
RUN pip3 install --no-cache-dir btc_embedded
ENV PYTHONUNBUFFERED=1

USER matlab
COPY matlab.lic ${ML_LIC_PATH}
COPY btc.lic ${LICENSE_LOCATION}

# Override default MATLAB entrypoint
ENTRYPOINT [ ]
CMD [ ]
