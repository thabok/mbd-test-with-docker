# Starting from public image mathworks/matlab & btces/ep
# with default versions defined below (can be overwritten using build-args)
ARG EP_RELEASE=24.3p0
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

# mex-compiler: gcc 11
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y gcc-11 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 && update-alternatives --config gcc && apt-get install -y g++-11 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100 && update-alternatives --config g++ && apt-get install -y cpp-11 && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-11 100 && update-alternatives --config cpp
RUN rm -f /home/matlab/Documents/MATLAB/startup.m
# matlab licensing
ENV MLM_LICENSE_FILE=27000@matlab.license.server

# ----------------------------------------------------------------------------------------
# BTC-specific configurations
# ----------------------------------------------------------------------------------------
# Copy files from public image btces/ep
COPY --chown=1000 --from=ep /opt /opt
COPY --chown=1000 --from=ep /root/.BTC /root/.BTC
# integrate BTC with MATLAB
RUN sudo chmod +x /opt/ep/addMLIntegration.bash && sudo /opt/ep/addMLIntegration.bash
# btc licensing
ENV LICENSE_LOCATION=27000@btc.license.server

# install python module btc_embedded
RUN pip3 install --no-cache-dir btc_embedded
ENV PYTHONUNBUFFERED=1

USER matlab

# Override default MATLAB entrypoint
ENTRYPOINT [ ]
CMD [ ]
