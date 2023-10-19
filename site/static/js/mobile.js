!(function () {
  var container = document.querySelector(".container"),
    menu_mobile_trigger = document.querySelector(".menu-trigger"),
    menu_mobile = document.querySelector(".menu-mobile"),
    menu_desktop =
      (document.querySelector(".menu-inner-desktop"),
      document.querySelector(".menu-inner-list-more-trigger")),
    menu_more = document.querySelector(".menu-inner-list-more"),
    page_form = document.querySelector(".pagination__form"),
    phone_width = getComputedStyle(document.body).getPropertyValue(
      "--phoneWidth",
    ),
    is_phone = function () {
      return window.matchMedia(phone_width).matches;
    },
    was_phone = is_phone(),
    toggle_mobile_menu = function () {
      menu_mobile && menu_mobile.classList.toggle("hidden");
    },
    hide_mobile_menu = function () {
      menu_mobile && menu_mobile.classList.add("hidden");
    },
    toggle_menu_more = function () {
      menu_more && menu_more.classList.toggle("hidden");
    },
    toggle_menu_more = function () {
      menu_more && menu_more.classList.add("hidden");
    },
    toggle_vis = function () {
      menu_mobile && is_phone() && menu_mobile.classList.add("hidden"),
        menu_more && !is_phone() && menu_more.classList.add("hidden");
    };

  toggle_vis(),
    page_form &&
      (page_form.onsubmit = function (event) {
        if (this.page.value == 1) {
          loc = this.action.slice(0, -5);
        } else {
          loc = this.action += this.page.value + "/";
        }
        event.preventDefault();
        window.location.href = loc;
      }),
    menu_mobile &&
      menu_mobile.addEventListener("click", function (event) {
        return event.stopPropagation();
      }),
    menu_more &&
      menu_more.addEventListener("click", function (event) {
        return event.stopPropagation();
      }),
    document.body.addEventListener("click", function () {
      if (is_phone() || !menu_more || menu_more.classList.contains("hidden")) {
        is_phone() && hide_mobile_menu();
      } else {
        hide_menu_more();
      }
    }),
    window.addEventListener("resize", toggle_vis),
    menu_mobile_trigger &&
      (menu_mobile_trigger.addEventListener("click", function (event) {
        event.stopPropagation(), toggle_mobile_menu();
      }),
      menu_mobile_trigger.addEventListener("keyup", function (event) {
        event.stopPropagation(), event.code === "Enter" && toggle_mobile_menu();
      })),
    menu_desktop &&
      (menu_desktop.addEventListener("click", function (event) {
        event.stopPropagation(),
          toggle_menu_more(),
          menu_more.getBoundingClientRect().right >
            container.getBoundingClientRect().right &&
            ((menu_more.style.left = "auto"), (menu_more.style.right = 0));
      }),
      menu_desktop.addEventListener("keyup", function (event) {
        event.stopPropagation(),
          event.code === "Enter" && toggle_menu_more(),
          menu_more.getBoundingClientRect().right >
            container.getBoundingClientRect().right &&
            ((menu_more.style.left = "auto"), (menu_more.style.right = 0));
      }));
})();
