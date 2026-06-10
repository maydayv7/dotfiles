pkgs: let
  style = builtins.readFile ./style.css;
  mkTheme = name: colors:
    with colors;
      pkgs.writeText "style-${name}.css" ''
        ${style}
        :root {
          --bg: ${bg};
          --fg: ${fg};
          --fg-dim: ${fgDim};
          --border: ${border};
          --border-subtle: rgba(255, 255, 255, 0.05);

          /* Theme Colors */
          --accent: ${accent};
          --accent-alpha-70: ${accentAlpha70};
          --secondary: ${secondary};
          --secondary-alpha-20: ${secondaryAlpha20};
          --secondary-alpha-70: ${secondaryAlpha70};
          --bg-hover: rgba(255, 255, 255, 0.03);
          --bg-code: rgba(0, 0, 0, 0.2);
          --diff-add: ${diffAdd};
          --diff-del: ${diffDel};
          --diff-mod: ${diffMod};
        }
      '';
in {
  red = mkTheme "red" {
    bg = "#221f29";
    fg = "whitesmoke";
    fgDim = "#888888";
    border = "rgba(255,255,255,0.1)";
    accent = "#ff6266";
    accentAlpha70 = "rgba(255, 98, 102, 0.7)";
    secondary = "#23b0ff";
    secondaryAlpha20 = "rgba(35, 176, 255, 0.2)";
    secondaryAlpha70 = "rgba(35, 176, 255, 0.7)";
    diffAdd = "#23b0ff";
    diffDel = "#ff6266";
    diffMod = "#e59c19";
  };

  blue = mkTheme "blue" {
    bg = "#1d1e28";
    fg = "whitesmoke";
    fgDim = "#888888";
    border = "rgba(255,255,255,0.1)";
    accent = "#23b0ff";
    accentAlpha70 = "rgba(35, 176, 255, 0.7)";
    secondary = "#ee72f1";
    secondaryAlpha20 = "rgba(238, 114, 241, 0.2)";
    secondaryAlpha70 = "rgba(238, 114, 241, 0.7)";
    diffAdd = "#23b0ff";
    diffDel = "#ee72f1";
    diffMod = "#e59c19";
  };

  black = mkTheme "black" {
    bg = "#1d1d1d";
    fg = "whitesmoke";
    fgDim = "#bbbbbb";
    border = "rgba(255,255,255,0.1)";
    accent = "#7b7b7b";
    accentAlpha70 = "rgba(123, 123, 123, 0.7)";
    secondary = "#e59c19";
    secondaryAlpha20 = "rgba(229, 156, 25, 0.2)";
    secondaryAlpha70 = "rgba(229, 156, 25, 0.7)";
    diffAdd = "#e59c19";
    diffDel = "#7b7b7b";
    diffMod = "#ffffff";
  };
}
