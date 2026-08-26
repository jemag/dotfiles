.DEFAULT_GOAL := switch

# update packages updating the flake.lock channel rev
.PHONY: update
update:
		nix flake update

# build current home-manager setup
.PHONY: switch
switch:
		nh home switch . --show-activation-logs

# build current nixos system setup
.PHONY: os
os:
		nh os switch . --show-activation-logs

# system then home
.PHONY: all
all: os switch

.PHONY: news
news:
		home-manager news --flake .

.PHONY: clean
clean:
		nix-collect-garbage -d
