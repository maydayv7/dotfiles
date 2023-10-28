{
  system = "x86_64-linux";
  name = "Futura";
  description = "PC - Dell Inspiron 11 3000";

  timezone = "Asia/Kolkata";
  locale = "IN";
  update = "weekly";

  kernel = "6_5";
  hardware = {
    boot = "efi";
    cores = 4;
    filesystem = "simple";
    modules = ["common-cpu-intel" "common-pc" "common-pc-laptop"];
  };

  gui.desktop = "xfce";
  apps.list = ["firefox" "office"];

  # User Navya
  user = {
    name = "navya";
    groups = ["wheel"];
    description = "Navya";
    shell = "zsh";
  };
}
