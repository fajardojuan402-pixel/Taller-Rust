# Laboratorio "¿Quién protege la memoria?"
# Desde el anfitrión, cada objetivo se ejecuta en un contenedor efímero.
# Dentro del contenedor (devcontainer o CI, LAB_IN_CONTAINER=1) se ejecuta directo.

IMAGE ?= lab-memoria:1.0
SHELL := /bin/bash

ifeq ($(LAB_IN_CONTAINER),1)
  RUN :=
else
  TTY := $(shell [ -t 1 ] && echo -t)
  RUN := docker run --rm -i $(TTY) -u $$(id -u):$$(id -g) -e HOME=/tmp -e CC=$(CC) \
         -v "$(CURDIR)":/lab -w /lab $(IMAGE)
endif

.PHONY: help setup versions m1 m2 m3 minivec test clean

help:
	@echo "Objetivos: setup versions m1 m2 m3 minivec test clean"

setup:
ifeq ($(LAB_IN_CONTAINER),1)
	@echo "Ya está dentro del contenedor del laboratorio."
else
	docker build -t $(IMAGE) .
endif

versions:
	$(RUN) bash scripts/versions.sh

m1:
	$(RUN) bash modulos/m1-limites/run-expect-fail.sh

m2:
	$(RUN) bash modulos/m2-ownership/run-expect-fail.sh

m3:
	$(RUN) bash modulos/m3-concurrencia/run-expect-fail.sh

minivec:
	$(RUN) bash -c 'cd minivec && cargo test && cargo +nightly miri test'

test: m1 m2 m3 minivec

clean:
	$(RUN) bash -c 'rm -rf build target'
