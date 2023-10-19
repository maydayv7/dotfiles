window.addEventListener("load", function () {
  for (const ref of document.getElementsByClassName("footnote-reference")) {
    const hash = ref.children[0].hash.substring(1);
    const refhash = "ref:" + hash;
    ref.id = refhash;
  }

  for (const footnote of document.getElementsByClassName(
    "footnote-definition",
  )) {
    const hash = footnote.id;
    const refhash = "ref:" + hash;
    const backlink = document.createElement("a");
    backlink.href = "#" + refhash;
    backlink.className = "backlink";
    backlink.innerText = "↩";
    const paras = footnote.children;
    const lastPara = paras[paras.length - 1];
    lastPara.appendChild(backlink);
  }
});
