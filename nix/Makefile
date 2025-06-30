.DEFAULT_GOAL := switch

# update packages updating the flake.lock channel rev
.PHONY: update
update:
		nix flake update

# build current home-manager setup
.PHONY: switch
switch:
		nh switch --flake .

.PHONY: news
news:
		home-manager news --flake .

.PHONY: clean
clean:
		nix-collect-garbage -d
