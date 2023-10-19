function addCopyButtons(clipboard) {
  document.querySelectorAll("pre > code").forEach(function (codeBlock) {
    var button = document.createElement("button");
    button.className = "copy";
    button.type = "button";
    button.innerText = "📋 Copy";
    button.addEventListener("click", function () {
      clipboard.writeText(codeBlock.innerText).then(
        function () {
          button.blur();
          button.innerText = "Copied!";
          setTimeout(function () {
            button.innerText = "📋 Copy";
          }, 2000);
        },
        function (error) {
          button.innerText = "Error";
        },
      );
    });

    var pre = codeBlock.parentNode;
    if (pre.parentNode.classList.contains("highlight")) {
      var highlight = pre.parentNode;
      highlight.parentNode.insertBefore(button, highlight);
    } else {
      pre.parentNode.insertBefore(button, pre);
    }
  });
}

if (navigator && navigator.clipboard) {
  addCopyButtons(navigator.clipboard);
} else {
  var script = document.createElement("script");
  script.src =
    "https://cdnjs.cloudflare.com/ajax/libs/clipboard-polyfill/2.7.0/clipboard-polyfill.promise.js";
  script.integrity = "sha256-waClS2re9NUbXRsryKoof+F9qc1gjjIhc2eT7ZbIv94=";
  script.crossOrigin = "anonymous";
  script.onload = function () {
    addCopyButtons(clipboard);
  };
  document.body.appendChild(script);
}
