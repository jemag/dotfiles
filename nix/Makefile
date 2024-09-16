.PHONY: update

update:
		home-manager switch --flake .

.PHONY: news

news:
		home-manager news --flake .

.PHONY: clean

clean:
		nix-collect-garbage -d
