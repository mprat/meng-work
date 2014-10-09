#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/vision/torralba/datasetbias/caffe/glog-0.3.3/lib
export LD_LIBRARY_PATH=/data/vision/torralba/datasetbias/caffe/cuda-5.5/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/data/vision/torralba/aditya_datasets/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/data/vision/torralba/datasetbias/caffe/protobuf-2.5.0/lib:$LD_LIBRARY_PATH
export KMP_DUPLICATE_LIB_OK=TRUE