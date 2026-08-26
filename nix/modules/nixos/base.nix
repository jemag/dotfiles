# Bare-metal host baseline: the host-agnostic settings plus the boot/kernel/
# network/audio/display stack. WSL hosts import ./common.nix directly instead.
{
  imports = [
    ./common.nix
    ./physical.nix
  ];
}
