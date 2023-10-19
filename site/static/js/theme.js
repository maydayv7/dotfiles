(function (switch_theme) {
  const THEME_KEY = "theme_color";
  const THEME = localStorage.getItem(THEME_KEY);
  const STOP_BLINK_CSS_ID = "stop-blink";
  const STYLESHEET_CLASSNAME = "stylesheet";
  let previousLink = null;
  let baseUrl = "";

  const onLinkLoad = (event) => {
    let link = event.currentTarget;
    link.removeEventListener("load", onLinkLoad);
    link.removeEventListener("error", onLinkError);
    removeStylesheets();
    link.className += STYLESHEET_CLASSNAME;
    previousLink = null;
    showBody();
  };

  const onLinkError = (event) => {
    let link = event.currentTarget;
    link.removeEventListener("load", onLinkLoad);
    link.removeEventListener("error", onLinkError);
    clearTheme();
    updateThemeSelect(link.id, false);
    link.remove();
    if (previousLink) {
      document.getElementsByTagName("head")[0].appendChild(previousLink);
    }
    updateThemeSelect(
      document.querySelectorAll(`.${STYLESHEET_CLASSNAME}`)[0].id,
      true,
    );
    showBody();
  };

  function changeTheme(themeName, firstLoad) {
    var fileref = document.createElement("link");
    fileref.rel = "stylesheet";
    fileref.type = "text/css";
    fileref.href = `${baseUrl}${
      baseUrl.slice(-1) !== "/" ? "/" : ""
    }color/${themeName}.css`;
    fileref.id = themeName;

    let link = document.getElementsByTagName("head")[0].appendChild(fileref);
    link.addEventListener("load", onLinkLoad);
    link.addEventListener("error", onLinkError);

    if (firstLoad) {
      previousLink = document.querySelectorAll(`.${STYLESHEET_CLASSNAME}`)[0];
      removeStylesheets();
    }

    saveTheme(themeName);
  }

  function removeStylesheets() {
    document.querySelectorAll(`.${STYLESHEET_CLASSNAME}`).forEach((el) => {
      el.remove();
    });
  }

  function saveTheme(themeName) {
    localStorage.setItem(THEME_KEY, themeName);
  }

  function clearTheme() {
    localStorage.removeItem(THEME_KEY);
  }

  function hideBody() {
    let head = document.getElementsByTagName("head")[0];
    let style = document.createElement("style");
    let css = "body{visibility:hidden;}";

    style.id = STOP_BLINK_CSS_ID;
    style.setAttribute("type", "text/css");

    if (style.styleSheet) {
      style.styleSheet.cssText = css;
    } else {
      style.appendChild(document.createTextNode(css));
    }
    head.appendChild(style);
  }

  function showBody() {
    let css = document.getElementById(STOP_BLINK_CSS_ID);
    if (css) css.remove();
  }

  function updateThemeSelect(theme, setSelected) {
    let elements = document.querySelectorAll("#theme-select>option");
    if (elements.length) {
      elements.forEach((element) => {
        if (element.value === theme) {
          if (setSelected) {
            element.selected = "selected";
          } else {
            element.remove();
          }
        }
      });
    } else {
      window.addEventListener("DOMContentLoaded", () => {
        updateThemeSelect(theme, setSelected);
      });
    }
  }

  switch_theme.init = function (url) {
    baseUrl = url;
    if (THEME && !document.getElementById(THEME)) {
      hideBody();
      changeTheme(THEME, true);
      updateThemeSelect(THEME, true);
    }
    window.addEventListener("DOMContentLoaded", () => {
      document.getElementById("theme-select").onchange = function () {
        changeTheme(this.value);
      };
    });
  };
})((switch_theme = window.switch_theme || {}));
