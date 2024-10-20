!(function (e, t) {
  "object" == typeof exports && "object" == typeof module
    ? (module.exports = t(require("katex")))
    : "function" == typeof define && define.amd
      ? define(["katex"], t)
      : "object" == typeof exports
        ? (exports.renderMathInElement = t(require("katex")))
        : (e.renderMathInElement = t(e.katex));
})("undefined" != typeof self ? self : this, function (e) {
  return (function (e) {
    var t = {};
    function r(n) {
      if (t[n]) return t[n].exports;
      var o = (t[n] = { i: n, l: !1, exports: {} });
      return e[n].call(o.exports, o, o.exports, r), (o.l = !0), o.exports;
    }
    return (
      (r.m = e),
      (r.c = t),
      (r.d = function (e, t, n) {
        r.o(e, t) || Object.defineProperty(e, t, { enumerable: !0, get: n });
      }),
      (r.r = function (e) {
        "undefined" != typeof Symbol &&
          Symbol.toStringTag &&
          Object.defineProperty(e, Symbol.toStringTag, { value: "Module" }),
          Object.defineProperty(e, "__esModule", { value: !0 });
      }),
      (r.t = function (e, t) {
        if ((1 & t && (e = r(e)), 8 & t)) return e;
        if (4 & t && "object" == typeof e && e && e.__esModule) return e;
        var n = Object.create(null);
        if (
          (r.r(n),
          Object.defineProperty(n, "default", { enumerable: !0, value: e }),
          2 & t && "string" != typeof e)
        )
          for (var o in e)
            r.d(
              n,
              o,
              function (t) {
                return e[t];
              }.bind(null, o),
            );
        return n;
      }),
      (r.n = function (e) {
        var t =
          e && e.__esModule
            ? function () {
                return e.default;
              }
            : function () {
                return e;
              };
        return r.d(t, "a", t), t;
      }),
      (r.o = function (e, t) {
        return Object.prototype.hasOwnProperty.call(e, t);
      }),
      (r.p = ""),
      r((r.s = 1))
    );
  })([
    function (t, r) {
      t.exports = e;
    },
    function (e, t, r) {
      "use strict";
      r.r(t);
      var n = r(0),
        o = r.n(n),
        a = function (e, t, r) {
          for (var n = r, o = 0, a = e.length; n < t.length; ) {
            var i = t[n];
            if (o <= 0 && t.slice(n, n + a) === e) return n;
            "\\" === i ? n++ : "{" === i ? o++ : "}" === i && o--, n++;
          }
          return -1;
        },
        i = function (e, t, r, n) {
          for (var o = [], i = 0; i < e.length; i++)
            if ("text" === e[i].type) {
              var l = e[i].data,
                d = !0,
                s = 0,
                f = void 0;
              for (
                -1 !== (f = l.indexOf(t)) &&
                ((s = f),
                o.push({ type: "text", data: l.slice(0, s) }),
                (d = !1));
                ;

              ) {
                if (d) {
                  if (-1 === (f = l.indexOf(t, s))) break;
                  o.push({ type: "text", data: l.slice(s, f) }), (s = f);
                } else {
                  if (-1 === (f = a(r, l, s + t.length))) break;
                  o.push({
                    type: "math",
                    data: l.slice(s + t.length, f),
                    rawData: l.slice(s, f + r.length),
                    display: n,
                  }),
                    (s = f + r.length);
                }
                d = !d;
              }
              o.push({ type: "text", data: l.slice(s) });
            } else o.push(e[i]);
          return o;
        },
        l = function (e, t) {
          var r = (function (e, t) {
            for (
              var r = [{ type: "text", data: e }], n = 0;
              n < t.length;
              n++
            ) {
              var o = t[n];
              r = i(r, o.left, o.right, o.display || !1);
            }
            return r;
          })(e, t.delimiters);
          if (1 === r.length && "text" === r[0].type) return null;
          for (
            var n = document.createDocumentFragment(), a = 0;
            a < r.length;
            a++
          )
            if ("text" === r[a].type)
              n.appendChild(document.createTextNode(r[a].data));
            else {
              var l = document.createElement("span"),
                d = r[a].data;
              t.displayMode = r[a].display;
              try {
                t.preProcess && (d = t.preProcess(d)), o.a.render(d, l, t);
              } catch (e) {
                if (!(e instanceof o.a.ParseError)) throw e;
                t.errorCallback(
                  "KaTeX auto-render: Failed to parse `" +
                    r[a].data +
                    "` with ",
                  e,
                ),
                  n.appendChild(document.createTextNode(r[a].rawData));
                continue;
              }
              n.appendChild(l);
            }
          return n;
        };
      t.default = function (e, t) {
        if (!e) throw new Error("No element provided to render");
        var r = {};
        for (var n in t) t.hasOwnProperty(n) && (r[n] = t[n]);
        (r.delimiters = r.delimiters || [
          { left: "$$", right: "$$", display: !0 },
          { left: "\\(", right: "\\)", display: !1 },
          { left: "\\[", right: "\\]", display: !0 },
        ]),
          (r.ignoredTags = r.ignoredTags || [
            "script",
            "noscript",
            "style",
            "textarea",
            "pre",
            "code",
            "option",
          ]),
          (r.ignoredClasses = r.ignoredClasses || []),
          (r.errorCallback = r.errorCallback || console.error),
          (r.macros = r.macros || {}),
          (function e(t, r) {
            for (var n = 0; n < t.childNodes.length; n++) {
              var o = t.childNodes[n];
              if (3 === o.nodeType) {
                var a = l(o.textContent, r);
                a && ((n += a.childNodes.length - 1), t.replaceChild(a, o));
              } else
                1 === o.nodeType &&
                  (function () {
                    var t = " " + o.className + " ";
                    -1 === r.ignoredTags.indexOf(o.nodeName.toLowerCase()) &&
                      r.ignoredClasses.every(function (e) {
                        return -1 === t.indexOf(" " + e + " ");
                      }) &&
                      e(o, r);
                  })();
            }
          })(e, r);
      };
    },
  ]).default;
});
