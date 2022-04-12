var scrollButton = document.querySelector(".scroll-back");
var rootElement = document.documentElement;

function handleScroll() {
  var scrollTotal = rootElement.scrollHeight - rootElement.clientHeight;
  if (rootElement.scrollTop / scrollTotal > 0.7) {
    scrollButton.style.display = "block";
  } else {
    scrollButton.style.display = "none";
  }
}

function scrollBack() {
  rootElement.scrollTo({
    top: 0,
    behavior: "smooth",
  });
}

scrollButton.addEventListener("click", scrollBack);
document.addEventListener("scroll", handleScroll);
