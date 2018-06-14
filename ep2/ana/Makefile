
#nvcc ep2.cu -o main -gencode arch=compute_20,code=sm_20 -gencode arch=compute_35,code=sm_35

all:
	nvcc ep2.cu -o main -Xptxas --opt-level=3 -arch sm_30 -g -G