{ files, ... }: {
  # Credentials
  credentials = {
    mail = "gnavya009@gmail.com";
    key = "B141E0D9F711DD86DEAE1269D9B023AB01B68EFE";
  };

  # Profile Picture
  home.file.".face".source = files.images.profile;
}
