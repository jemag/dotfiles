.PHONY: update

update:
		home-manager switch --flake .#jemag

.PHONY: news

news:
		home-manager news --flake .#jemag

.PHONY: clean

clean:
		nix-collect-garbage -d
