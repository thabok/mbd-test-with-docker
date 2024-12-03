# This script is provided for convenience purposes to allow users to run the tests locally.
# It sets up the necessary environment and executes the test suite, ensuring that all tests
# are run in a consistent manner. Users can simply execute this script to verify that their
# changes do not break any existing functionality.

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
    python3 /workdir/scripts/run_tests.py
