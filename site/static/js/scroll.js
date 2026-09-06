var scrollButton = document.querySelector(".scroll-back");
var rootElement = document.documentElement;

if (scrollButton) {
  function handleScroll() {
    var scrollTotal = rootElement.scrollHeight - rootElement.clientHeight;
    if (rootElement.scrollTop / scrollTotal > 0.5) {
      scrollButton.style.visibility = "visible";
      scrollButton.style.opacity = 100;
    } else {
      scrollButton.style.visibility = "hidden";
      scrollButton.style.opacity = 0;
    }
  }

  function scrollBack() {
    rootElement.scrollTo({
      top: 0,
      behavior: matchMedia("(prefers-reduced-motion: reduce)").matches
        ? "instant"
        : "smooth",
    });
  }

  scrollButton.addEventListener("click", scrollBack);
  document.addEventListener("scroll", handleScroll, { passive: true });
}
