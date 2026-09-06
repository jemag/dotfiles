.DEFAULT_GOAL := home

# update packages updating the flake.lock channel rev
.PHONY: update
update:
		nix flake update

# build current home-manager setup
.PHONY: home
home:
		nh home switch . --show-activation-logs

# test current home-manager system setup
.PHONY: test-home
test-home:
		nh home build . --show-activation-logs

# build current nixos system setup
.PHONY: os
os:
		nh os switch . --show-activation-logs

# test current nixos system setup
.PHONY: test-os
test-os:
		nh os build .

# system then home
.PHONY: all
all: os switch

.PHONY: news
news:
		home-manager news --flake .

.PHONY: clean
clean:
		nix-collect-garbage -d
