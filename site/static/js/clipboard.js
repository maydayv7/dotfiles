document.querySelectorAll("pre > code").forEach(function (codeBlock) {
  var button = document.createElement("button");
  button.className = "copy";
  button.type = "button";
  button.innerText = " Copy";
  button.addEventListener("click", function () {
    if (!navigator.clipboard) {
      button.innerText = "Select code to copy";
      return;
    }
    navigator.clipboard.writeText(codeBlock.innerText).then(
      function () {
        button.blur();
        button.innerText = "Copied!";
        setTimeout(function () {
          button.innerText = " Copy";
        }, 2000);
      },
      function (error) {
        button.innerText = "Error";
      },
    );
  });

  var pre = codeBlock.parentNode;
  pre.tabIndex = 0;
  var block = pre.parentNode.classList.contains("highlight")
    ? pre.parentNode
    : pre;

  var wrapper = document.createElement("div");
  wrapper.className = "code-wrapper";
  block.parentNode.insertBefore(wrapper, block);
  wrapper.appendChild(block);
  wrapper.appendChild(button);
});
