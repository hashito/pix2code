FROM jjanzic/docker-python3-opencv:opencv-3.3.0

RUN apt-get update && \
    apt-get -y install zip unzip && \
    git clone https://github.com/tonybeltramelli/pix2code.git && \
    cd pix2code && \
    pip install -r  requirements.txt && \
    cd datasets && \
    zip -F pix2code_datasets.zip --out datasets.zip && \
    /usr/local/bin/python -m pip install --upgrade pip && \
    unzip datasets.zip && \
    cd ../model && \
    ./build_datasets.py ../datasets/ios/all_data && \
    ./build_datasets.py ../datasets/android/all_data && \
    ./build_datasets.py ../datasets/web/all_data && \
    ./convert_imgs_to_arrays.py ../datasets/ios/training_set ../datasets/ios/training_features && \
    ./convert_imgs_to_arrays.py ../datasets/android/training_set ../datasets/android/training_features && \
    ./convert_imgs_to_arrays.py ../datasets/web/training_set ../datasets/web/training_features
RUN cd /pix2code && \
    mkdir bin && \
    cd model && \
    ./train.py ../datasets/web/training_set ../bin && \
    ./train.py ../datasets/web/training_features ../bin 1 && \
    cd .. && \
    mkdir code && \
    cd model && \
    ./sample.py ../bin pix2code ../test_gui.png ../code 

    #./train.py ../datasets/web/training_features ../bin
    #./train.py ../datasets/web/training_features ../bin 1 ../bin/pix2code.h5


# sess = tf.Session(config=tf.ConfigProto(
#         log_device_placement=True,
#         inter_op_parallelism_threads=1,
#         intra_op_parallelism_threads=1,
#         gpu_options=tf.GPUOptions(
#                 allow_growth=True,
#                 visible_device_list="0"
#                 )
# ))