{
  system = "x86_64-linux";
  name = "futura";
  description = "PC - Dell Inspiron 11 3000";

  timezone = "Asia/Kolkata";
  locale = "IN";
  update = "weekly";

  kernel = "lts";
  hardware = {
    boot = "efi";
    cpu.cores = 4;
    filesystem = "simple";
    support = ["laptop"];
    modules = ["common-pc" "common-pc-laptop" "common-cpu-intel" "common-gpu-intel"];
  };

  apps.list = ["firefox" "office"];
  gui = {
    desktop = "xfce";
    display = "eDP-1";
  };

  # User Navya
  user = {
    name = "navya";
    groups = ["wheel"];
    description = "Navya";
    shell = "zsh";
  };
}
