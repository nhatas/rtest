FROM ubuntu:20.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && \
  apt-get install -y wget bzip2 build-essential \
  ca-certificates git libglib2.0-0 libxext6 libsm6 \
  libxrender1 mercurial subversion python3-dev \
  zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev \
  libssl-dev libreadline-dev libffi-dev libsqlite3-dev \
  libbz2-dev checkinstall && \
  apt-get clean

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh && \
  /opt/conda/bin/conda clean -tipsy && \
  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
  echo "conda activate base" >> ~/.bashrc && \
  find /opt/conda/ -follow -type f -name '*.a' -delete && \
  find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
  /opt/conda/bin/conda clean -afy

ENV PATH=/opt/conda/bin:$PATH

# install mamba
RUN conda install -n base -c conda-forge mamba

COPY environment.yml /var/tmp/environment.yml
RUN mamba env update -f /var/tmp/environment.yml && \
  rm -rf /var/tmp/environment.yml

COPY /entrypoint.sh /opt/conda/bin/entrypoint.sh
RUN chmod a+x /opt/conda/bin/entrypoint.sh

#ENTRYPOINT ["/opt/conda/bin/entrypoint.sh"]
CMD [".", "/opt/conda/bin/entrypoint.sh"]


#### bashrc testing (/code already exists in dockerfile)
# RUN cp /root/.bashrc /code
# RUN chmod -R 777 /code
# RUN chmod -R 777 /root

# try...
# CMD ["source / or ." "/code/.bashrc"]

# might have to manually source /code/.bashrc