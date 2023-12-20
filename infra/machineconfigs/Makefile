SRCS = $(wildcard *.butane.yaml)
MACHINECONFIGS = $(SRCS:.butane.yaml=.yaml)

%.yaml: %.butane.yaml
	butane -o $@ $<

all: $(MACHINECONFIGS)
