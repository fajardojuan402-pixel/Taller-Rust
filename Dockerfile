# Contenedor del laboratorio "¿Quién protege la memoria?"
# Todas las herramientas con versiones fijas. Cambiar una versión aquí
# cambia los resultados observables (lints, mensajes, Miri): regístrelo.
FROM ubuntu:24.04

# Versiones fijas de Rust (estable y nightly con Miri).
ARG RUST_STABLE=1.90.0
ARG RUST_NIGHTLY=nightly-2025-09-15

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# gcc 13 (por defecto en 24.04), clang 18 con compiler-rt (ASan, UBSan, TSan),
# JDK 21 y make.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git make coreutils procps \
        build-essential gcc-13 \
        clang-18 llvm-18 libclang-rt-18-dev clang-format-18 \
        openjdk-21-jdk-headless \
    && ln -sf /usr/bin/clang-18 /usr/local/bin/clang \
    && ln -sf /usr/bin/clang-format-18 /usr/local/bin/clang-format \
    && ln -sf /usr/bin/llvm-symbolizer-18 /usr/local/bin/llvm-symbolizer \
    && rm -rf /var/lib/apt/lists/*

# Rust: toolchain estable por defecto + nightly fijo con Miri.
# El nightly fijo se instala con el nombre "nightly" para que los comandos
# del documento (cargo +nightly miri run) funcionen tal cual.
ENV RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/cargo \
    XDG_CACHE_HOME=/opt/cache \
    PATH=/opt/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path --profile minimal \
            --default-toolchain ${RUST_STABLE} --component rustfmt \
    && rustup toolchain install ${RUST_NIGHTLY} --profile minimal \
        --component miri,rust-src \
    && HOST="$(rustc -vV | sed -n 's/^host: //p')" \
    && mv "${RUSTUP_HOME}/toolchains/${RUST_NIGHTLY}-${HOST}" \
          "${RUSTUP_HOME}/toolchains/nightly-${HOST}" \
    && mv "${RUSTUP_HOME}/update-hashes/${RUST_NIGHTLY}-${HOST}" \
          "${RUSTUP_HOME}/update-hashes/nightly-${HOST}" \
    && rustc +nightly --version \
    && cargo +nightly miri setup \
    && chmod -R a+rwX /opt/rustup /opt/cargo /opt/cache

# Usar el sysroot de Miri ya construido en la imagen: evita que cargo-miri
# intente reconstruirlo en cada contenedor (falla en overlayfs con
# "detected a concurrent sysroot build with different settings").
# Indica además a Makefile y scripts que ya estamos dentro del contenedor.
ENV MIRI_SYSROOT=/opt/cache/miri \
    LAB_IN_CONTAINER=1
WORKDIR /lab
CMD ["bash"]
