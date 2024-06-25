FROM nvcr.io/nvidia/pytorch:24.05-py3
ENV NCCL_SOCKET_IFNAME=eth0
ENV NCCL_DEBUG=INFO
ENV NCCL_NET_GDR_LEVEL=4
ENV NCCL_IGNORE_CPU_AFFINITY=1
ENV NCCL_IB_TIMEOUT=4
ENV NCCL_BUFFSIZE=2097152
ENV WANDB_MODE=offline
#ENV NCCL_TOPO_FILE=/nfs/akim.xml
#ENV https_proxy=http://192.168.101.101:3128
#ENV http_proxy=http://192.168.101.101:3128

# Install libraries for russol
RUN pip install -U pip && pip install packaging ninja

RUN MAX_JOBS=255 FLASH_ATTENTION_FORCE_BUILD=TRUE FLASH_ATTENTION_FORCE_CXX11_ABI=TRUE \
    pip install -U -v git+https://github.com/Dao-AILab/flash-attention.git@v2.5.9.post1#egg=flash-attn
RUN MAX_JOBS=255 pip install -v -U git+https://github.com/facebookresearch/xformers.git@v0.0.26.post1#egg=xformers

WORKDIR /zephyr
COPY ./ ./
# RUN git clone https://github.com/deepvk/alignment-handbook.git
# WORKDIR /alignment-handbook

RUN python -m pip install -e .

ENTRYPOINT ["bash"]
