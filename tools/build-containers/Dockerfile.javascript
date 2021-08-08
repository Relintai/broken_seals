ARG img_version
FROM godot-fedora:${img_version}

ENV EMSCRIPTEN_CLASSICAL=2.0.25

RUN dnf -y install --setopt=install_weak_deps=False \
      java-openjdk && \
    git clone --branch ${EMSCRIPTEN_CLASSICAL} --progress https://github.com/emscripten-core/emsdk emsdk_${EMSCRIPTEN_CLASSICAL} && \
    emsdk_${EMSCRIPTEN_CLASSICAL}/emsdk install ${EMSCRIPTEN_CLASSICAL} && \
    emsdk_${EMSCRIPTEN_CLASSICAL}/emsdk activate ${EMSCRIPTEN_CLASSICAL}
#    echo "source /root/emsdk_${EMSCRIPTEN_CLASSICAL}/emsdk_env.sh" >> /root/.bashrc

CMD /bin/bash
