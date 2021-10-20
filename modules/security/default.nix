{ lib, ... }:
{
  ## Security Settings ##
  security =
  {
    sudo.extraConfig =
    "
      Defaults pwfeedback
    ";
  };
}
