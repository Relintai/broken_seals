ARG img_version
FROM godot-fedora:${img_version}

RUN dnf -y install --setopt=install_weak_deps=False \
      gcc gcc-c++ java-openjdk yasm && \
    git clone --progress https://github.com/emscripten-core/emsdk && \
    cd emsdk && \
    git checkout a5082b232617c762cb65832429f896c838df2483 && \
    ./emsdk install 1.38.47-upstream && \
    ./emsdk activate 1.38.47-upstream && \
    echo "source /root/emsdk/emsdk_env.sh" >> /root/.bashrc

CMD /bin/bash
