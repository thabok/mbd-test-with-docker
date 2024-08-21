EP_RELEASE=24.2p0
MATLAB_RELEASE=R2024a

docker build \
    --build-arg EP_RELEASE=${EP_RELEASE} \
    --build-arg MATLAB_RELEASE=${MATLAB_RELEASE} \
    --tag ep-ml:${EP_RELEASE}_${MATLAB_RELEASE} \
    docker

docker run \
    --rm \
    --volume "$(pwd):/workdir" \
    --workdir /workdir \
    ep-ml:${EP_RELEASE}_${MATLAB_RELEASE} \
    python3 /workdir/test/run_tests.py