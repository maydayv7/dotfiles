!(function (t, e) {
  "object" == typeof exports && "object" == typeof module
    ? (module.exports = e())
    : "function" == typeof define && define.amd
      ? define([], e)
      : "object" == typeof exports
        ? (exports.katex = e())
        : (t.katex = e());
})("undefined" != typeof self ? self : this, function () {
  return (function (t) {
    var e = {};
    function r(a) {
      if (e[a]) return e[a].exports;
      var n = (e[a] = { i: a, l: !1, exports: {} });
      return t[a].call(n.exports, n, n.exports, r), (n.l = !0), n.exports;
    }
    return (
      (r.m = t),
      (r.c = e),
      (r.d = function (t, e, a) {
        r.o(t, e) || Object.defineProperty(t, e, { enumerable: !0, get: a });
      }),
      (r.r = function (t) {
        "undefined" != typeof Symbol &&
          Symbol.toStringTag &&
          Object.defineProperty(t, Symbol.toStringTag, { value: "Module" }),
          Object.defineProperty(t, "__esModule", { value: !0 });
      }),
      (r.t = function (t, e) {
        if ((1 & e && (t = r(t)), 8 & e)) return t;
        if (4 & e && "object" == typeof t && t && t.__esModule) return t;
        var a = Object.create(null);
        if (
          (r.r(a),
          Object.defineProperty(a, "default", { enumerable: !0, value: t }),
          2 & e && "string" != typeof t)
        )
          for (var n in t)
            r.d(
              a,
              n,
              function (e) {
                return t[e];
              }.bind(null, n),
            );
        return a;
      }),
      (r.n = function (t) {
        var e =
          t && t.__esModule
            ? function () {
                return t.default;
              }
            : function () {
                return t;
              };
        return r.d(e, "a", e), e;
      }),
      (r.o = function (t, e) {
        return Object.prototype.hasOwnProperty.call(t, e);
      }),
      (r.p = ""),
      r((r.s = 1))
    );
  })([
    function (t, e, r) {},
    function (t, e, r) {
      "use strict";
      r.r(e);
      r(0);
      var a = (function () {
          function t(t, e, r) {
            (this.lexer = void 0),
              (this.start = void 0),
              (this.end = void 0),
              (this.lexer = t),
              (this.start = e),
              (this.end = r);
          }
          return (
            (t.range = function (e, r) {
              return r
                ? e && e.loc && r.loc && e.loc.lexer === r.loc.lexer
                  ? new t(e.loc.lexer, e.loc.start, r.loc.end)
                  : null
                : e && e.loc;
            }),
            t
          );
        })(),
        n = (function () {
          function t(t, e) {
            (this.text = void 0),
              (this.loc = void 0),
              (this.noexpand = void 0),
              (this.treatAsRelax = void 0),
              (this.text = t),
              (this.loc = e);
          }
          return (
            (t.prototype.range = function (e, r) {
              return new t(r, a.range(this, e));
            }),
            t
          );
        })(),
        i = function t(e, r) {
          this.position = void 0;
          var a,
            n = "KaTeX parse error: " + e,
            i = r && r.loc;
          if (i && i.start <= i.end) {
            var o = i.lexer.input;
            a = i.start;
            var s = i.end;
            a === o.length
              ? (n += " at end of input: ")
              : (n += " at position " + (a + 1) + ": ");
            var l = o.slice(a, s).replace(/[^]/g, "$&\u0332");
            n +=
              (a > 15 ? "\u2026" + o.slice(a - 15, a) : o.slice(0, a)) +
              l +
              (s + 15 < o.length ? o.slice(s, s + 15) + "\u2026" : o.slice(s));
          }
          var h = new Error(n);
          return (
            (h.name = "ParseError"),
            (h.__proto__ = t.prototype),
            (h.position = a),
            h
          );
        };
      i.prototype.__proto__ = Error.prototype;
      var o = i,
        s = /([A-Z])/g,
        l = {
          "&": "&amp;",
          ">": "&gt;",
          "<": "&lt;",
          '"': "&quot;",
          "'": "&#x27;",
        },
        h = /[&><"']/g;
      var m = function t(e) {
          return "ordgroup" === e.type
            ? 1 === e.body.length
              ? t(e.body[0])
              : e
            : "color" === e.type
              ? 1 === e.body.length
                ? t(e.body[0])
                : e
              : "font" === e.type
                ? t(e.body)
                : e;
        },
        c = {
          contains: function (t, e) {
            return -1 !== t.indexOf(e);
          },
          deflt: function (t, e) {
            return void 0 === t ? e : t;
          },
          escape: function (t) {
            return String(t).replace(h, function (t) {
              return l[t];
            });
          },
          hyphenate: function (t) {
            return t.replace(s, "-$1").toLowerCase();
          },
          getBaseElem: m,
          isCharacterBox: function (t) {
            var e = m(t);
            return (
              "mathord" === e.type || "textord" === e.type || "atom" === e.type
            );
          },
          protocolFromUrl: function (t) {
            var e = /^\s*([^\\/#]*?)(?::|&#0*58|&#x0*3a)/i.exec(t);
            return null != e ? e[1] : "_relative";
          },
        },
        u = (function () {
          function t(t) {
            (this.displayMode = void 0),
              (this.output = void 0),
              (this.leqno = void 0),
              (this.fleqn = void 0),
              (this.throwOnError = void 0),
              (this.errorColor = void 0),
              (this.macros = void 0),
              (this.minRuleThickness = void 0),
              (this.colorIsTextColor = void 0),
              (this.strict = void 0),
              (this.trust = void 0),
              (this.maxSize = void 0),
              (this.maxExpand = void 0),
              (this.globalGroup = void 0),
              (t = t || {}),
              (this.displayMode = c.deflt(t.displayMode, !1)),
              (this.output = c.deflt(t.output, "htmlAndMathml")),
              (this.leqno = c.deflt(t.leqno, !1)),
              (this.fleqn = c.deflt(t.fleqn, !1)),
              (this.throwOnError = c.deflt(t.throwOnError, !0)),
              (this.errorColor = c.deflt(t.errorColor, "#cc0000")),
              (this.macros = t.macros || {}),
              (this.minRuleThickness = Math.max(
                0,
                c.deflt(t.minRuleThickness, 0),
              )),
              (this.colorIsTextColor = c.deflt(t.colorIsTextColor, !1)),
              (this.strict = c.deflt(t.strict, "warn")),
              (this.trust = c.deflt(t.trust, !1)),
              (this.maxSize = Math.max(0, c.deflt(t.maxSize, 1 / 0))),
              (this.maxExpand = Math.max(0, c.deflt(t.maxExpand, 1e3))),
              (this.globalGroup = c.deflt(t.globalGroup, !1));
          }
          var e = t.prototype;
          return (
            (e.reportNonstrict = function (t, e, r) {
              var a = this.strict;
              if (
                ("function" == typeof a && (a = a(t, e, r)),
                a && "ignore" !== a)
              ) {
                if (!0 === a || "error" === a)
                  throw new o(
                    "LaTeX-incompatible input and strict mode is set to 'error': " +
                      e +
                      " [" +
                      t +
                      "]",
                    r,
                  );
                "warn" === a
                  ? "undefined" != typeof console &&
                    console.warn(
                      "LaTeX-incompatible input and strict mode is set to 'warn': " +
                        e +
                        " [" +
                        t +
                        "]",
                    )
                  : "undefined" != typeof console &&
                    console.warn(
                      "LaTeX-incompatible input and strict mode is set to unrecognized '" +
                        a +
                        "': " +
                        e +
                        " [" +
                        t +
                        "]",
                    );
              }
            }),
            (e.useStrictBehavior = function (t, e, r) {
              var a = this.strict;
              if ("function" == typeof a)
                try {
                  a = a(t, e, r);
                } catch (t) {
                  a = "error";
                }
              return (
                !(!a || "ignore" === a) &&
                (!0 === a ||
                  "error" === a ||
                  ("warn" === a
                    ? ("undefined" != typeof console &&
                        console.warn(
                          "LaTeX-incompatible input and strict mode is set to 'warn': " +
                            e +
                            " [" +
                            t +
                            "]",
                        ),
                      !1)
                    : ("undefined" != typeof console &&
                        console.warn(
                          "LaTeX-incompatible input and strict mode is set to unrecognized '" +
                            a +
                            "': " +
                            e +
                            " [" +
                            t +
                            "]",
                        ),
                      !1)))
              );
            }),
            (e.isTrusted = function (t) {
              t.url && !t.protocol && (t.protocol = c.protocolFromUrl(t.url));
              var e =
                "function" == typeof this.trust ? this.trust(t) : this.trust;
              return Boolean(e);
            }),
            t
          );
        })(),
        p = (function () {
          function t(t, e, r) {
            (this.id = void 0),
              (this.size = void 0),
              (this.cramped = void 0),
              (this.id = t),
              (this.size = e),
              (this.cramped = r);
          }
          var e = t.prototype;
          return (
            (e.sup = function () {
              return d[f[this.id]];
            }),
            (e.sub = function () {
              return d[g[this.id]];
            }),
            (e.fracNum = function () {
              return d[x[this.id]];
            }),
            (e.fracDen = function () {
              return d[v[this.id]];
            }),
            (e.cramp = function () {
              return d[b[this.id]];
            }),
            (e.text = function () {
              return d[y[this.id]];
            }),
            (e.isTight = function () {
              return this.size >= 2;
            }),
            t
          );
        })(),
        d = [
          new p(0, 0, !1),
          new p(1, 0, !0),
          new p(2, 1, !1),
          new p(3, 1, !0),
          new p(4, 2, !1),
          new p(5, 2, !0),
          new p(6, 3, !1),
          new p(7, 3, !0),
        ],
        f = [4, 5, 4, 5, 6, 7, 6, 7],
        g = [5, 5, 5, 5, 7, 7, 7, 7],
        x = [2, 3, 4, 5, 6, 7, 6, 7],
        v = [3, 3, 5, 5, 7, 7, 7, 7],
        b = [1, 1, 3, 3, 5, 5, 7, 7],
        y = [0, 1, 2, 3, 2, 3, 2, 3],
        w = { DISPLAY: d[0], TEXT: d[2], SCRIPT: d[4], SCRIPTSCRIPT: d[6] },
        k = [
          {
            name: "latin",
            blocks: [
              [256, 591],
              [768, 879],
            ],
          },
          { name: "cyrillic", blocks: [[1024, 1279]] },
          { name: "brahmic", blocks: [[2304, 4255]] },
          { name: "georgian", blocks: [[4256, 4351]] },
          {
            name: "cjk",
            blocks: [
              [12288, 12543],
              [19968, 40879],
              [65280, 65376],
            ],
          },
          { name: "hangul", blocks: [[44032, 55215]] },
        ];
      var S = [];
      function M(t) {
        for (var e = 0; e < S.length; e += 2)
          if (t >= S[e] && t <= S[e + 1]) return !0;
        return !1;
      }
      k.forEach(function (t) {
        return t.blocks.forEach(function (t) {
          return S.push.apply(S, t);
        });
      });
      var z = {
          leftParenInner: "M291 0 H417 V300 H291 z",
          rightParenInner: "M457 0 H583 V300 H457 z",
          doubleleftarrow:
            "M262 157\nl10-10c34-36 62.7-77 86-123 3.3-8 5-13.3 5-16 0-5.3-6.7-8-20-8-7.3\n 0-12.2.5-14.5 1.5-2.3 1-4.8 4.5-7.5 10.5-49.3 97.3-121.7 169.3-217 216-28\n 14-57.3 25-88 33-6.7 2-11 3.8-13 5.5-2 1.7-3 4.2-3 7.5s1 5.8 3 7.5\nc2 1.7 6.3 3.5 13 5.5 68 17.3 128.2 47.8 180.5 91.5 52.3 43.7 93.8 96.2 124.5\n 157.5 9.3 8 15.3 12.3 18 13h6c12-.7 18-4 18-10 0-2-1.7-7-5-15-23.3-46-52-87\n-86-123l-10-10h399738v-40H218c328 0 0 0 0 0l-10-8c-26.7-20-65.7-43-117-69 2.7\n-2 6-3.7 10-5 36.7-16 72.3-37.3 107-64l10-8h399782v-40z\nm8 0v40h399730v-40zm0 194v40h399730v-40z",
          doublerightarrow:
            "M399738 392l\n-10 10c-34 36-62.7 77-86 123-3.3 8-5 13.3-5 16 0 5.3 6.7 8 20 8 7.3 0 12.2-.5\n 14.5-1.5 2.3-1 4.8-4.5 7.5-10.5 49.3-97.3 121.7-169.3 217-216 28-14 57.3-25 88\n-33 6.7-2 11-3.8 13-5.5 2-1.7 3-4.2 3-7.5s-1-5.8-3-7.5c-2-1.7-6.3-3.5-13-5.5-68\n-17.3-128.2-47.8-180.5-91.5-52.3-43.7-93.8-96.2-124.5-157.5-9.3-8-15.3-12.3-18\n-13h-6c-12 .7-18 4-18 10 0 2 1.7 7 5 15 23.3 46 52 87 86 123l10 10H0v40h399782\nc-328 0 0 0 0 0l10 8c26.7 20 65.7 43 117 69-2.7 2-6 3.7-10 5-36.7 16-72.3 37.3\n-107 64l-10 8H0v40zM0 157v40h399730v-40zm0 194v40h399730v-40z",
          leftarrow:
            "M400000 241H110l3-3c68.7-52.7 113.7-120\n 135-202 4-14.7 6-23 6-25 0-7.3-7-11-21-11-8 0-13.2.8-15.5 2.5-2.3 1.7-4.2 5.8\n-5.5 12.5-1.3 4.7-2.7 10.3-4 17-12 48.7-34.8 92-68.5 130S65.3 228.3 18 247\nc-10 4-16 7.7-18 11 0 8.7 6 14.3 18 17 47.3 18.7 87.8 47 121.5 85S196 441.3 208\n 490c.7 2 1.3 5 2 9s1.2 6.7 1.5 8c.3 1.3 1 3.3 2 6s2.2 4.5 3.5 5.5c1.3 1 3.3\n 1.8 6 2.5s6 1 10 1c14 0 21-3.7 21-11 0-2-2-10.3-6-25-20-79.3-65-146.7-135-202\n l-3-3h399890zM100 241v40h399900v-40z",
          leftbrace:
            "M6 548l-6-6v-35l6-11c56-104 135.3-181.3 238-232 57.3-28.7 117\n-45 179-50h399577v120H403c-43.3 7-81 15-113 26-100.7 33-179.7 91-237 174-2.7\n 5-6 9-10 13-.7 1-7.3 1-20 1H6z",
          leftbraceunder:
            "M0 6l6-6h17c12.688 0 19.313.3 20 1 4 4 7.313 8.3 10 13\n 35.313 51.3 80.813 93.8 136.5 127.5 55.688 33.7 117.188 55.8 184.5 66.5.688\n 0 2 .3 4 1 18.688 2.7 76 4.3 172 5h399450v120H429l-6-1c-124.688-8-235-61.7\n-331-161C60.687 138.7 32.312 99.3 7 54L0 41V6z",
          leftgroup:
            "M400000 80\nH435C64 80 168.3 229.4 21 260c-5.9 1.2-18 0-18 0-2 0-3-1-3-3v-38C76 61 257 0\n 435 0h399565z",
          leftgroupunder:
            "M400000 262\nH435C64 262 168.3 112.6 21 82c-5.9-1.2-18 0-18 0-2 0-3 1-3 3v38c76 158 257 219\n 435 219h399565z",
          leftharpoon:
            "M0 267c.7 5.3 3 10 7 14h399993v-40H93c3.3\n-3.3 10.2-9.5 20.5-18.5s17.8-15.8 22.5-20.5c50.7-52 88-110.3 112-175 4-11.3 5\n-18.3 3-21-1.3-4-7.3-6-18-6-8 0-13 .7-15 2s-4.7 6.7-8 16c-42 98.7-107.3 174.7\n-196 228-6.7 4.7-10.7 8-12 10-1.3 2-2 5.7-2 11zm100-26v40h399900v-40z",
          leftharpoonplus:
            "M0 267c.7 5.3 3 10 7 14h399993v-40H93c3.3-3.3 10.2-9.5\n 20.5-18.5s17.8-15.8 22.5-20.5c50.7-52 88-110.3 112-175 4-11.3 5-18.3 3-21-1.3\n-4-7.3-6-18-6-8 0-13 .7-15 2s-4.7 6.7-8 16c-42 98.7-107.3 174.7-196 228-6.7 4.7\n-10.7 8-12 10-1.3 2-2 5.7-2 11zm100-26v40h399900v-40zM0 435v40h400000v-40z\nm0 0v40h400000v-40z",
          leftharpoondown:
            "M7 241c-4 4-6.333 8.667-7 14 0 5.333.667 9 2 11s5.333\n 5.333 12 10c90.667 54 156 130 196 228 3.333 10.667 6.333 16.333 9 17 2 .667 5\n 1 9 1h5c10.667 0 16.667-2 18-6 2-2.667 1-9.667-3-21-32-87.333-82.667-157.667\n-152-211l-3-3h399907v-40zM93 281 H400000 v-40L7 241z",
          leftharpoondownplus:
            "M7 435c-4 4-6.3 8.7-7 14 0 5.3.7 9 2 11s5.3 5.3 12\n 10c90.7 54 156 130 196 228 3.3 10.7 6.3 16.3 9 17 2 .7 5 1 9 1h5c10.7 0 16.7\n-2 18-6 2-2.7 1-9.7-3-21-32-87.3-82.7-157.7-152-211l-3-3h399907v-40H7zm93 0\nv40h399900v-40zM0 241v40h399900v-40zm0 0v40h399900v-40z",
          lefthook:
            "M400000 281 H103s-33-11.2-61-33.5S0 197.3 0 164s14.2-61.2 42.5\n-83.5C70.8 58.2 104 47 142 47 c16.7 0 25 6.7 25 20 0 12-8.7 18.7-26 20-40 3.3\n-68.7 15.7-86 37-10 12-15 25.3-15 40 0 22.7 9.8 40.7 29.5 54 19.7 13.3 43.5 21\n 71.5 23h399859zM103 281v-40h399897v40z",
          leftlinesegment:
            "M40 281 V428 H0 V94 H40 V241 H400000 v40z\nM40 281 V428 H0 V94 H40 V241 H400000 v40z",
          leftmapsto:
            "M40 281 V448H0V74H40V241H400000v40z\nM40 281 V448H0V74H40V241H400000v40z",
          leftToFrom:
            "M0 147h400000v40H0zm0 214c68 40 115.7 95.7 143 167h22c15.3 0 23\n-.3 23-1 0-1.3-5.3-13.7-16-37-18-35.3-41.3-69-70-101l-7-8h399905v-40H95l7-8\nc28.7-32 52-65.7 70-101 10.7-23.3 16-35.7 16-37 0-.7-7.7-1-23-1h-22C115.7 265.3\n 68 321 0 361zm0-174v-40h399900v40zm100 154v40h399900v-40z",
          longequal:
            "M0 50 h400000 v40H0z m0 194h40000v40H0z\nM0 50 h400000 v40H0z m0 194h40000v40H0z",
          midbrace:
            "M200428 334\nc-100.7-8.3-195.3-44-280-108-55.3-42-101.7-93-139-153l-9-14c-2.7 4-5.7 8.7-9 14\n-53.3 86.7-123.7 153-211 199-66.7 36-137.3 56.3-212 62H0V214h199568c178.3-11.7\n 311.7-78.3 403-201 6-8 9.7-12 11-12 .7-.7 6.7-1 18-1s17.3.3 18 1c1.3 0 5 4 11\n 12 44.7 59.3 101.3 106.3 170 141s145.3 54.3 229 60h199572v120z",
          midbraceunder:
            "M199572 214\nc100.7 8.3 195.3 44 280 108 55.3 42 101.7 93 139 153l9 14c2.7-4 5.7-8.7 9-14\n 53.3-86.7 123.7-153 211-199 66.7-36 137.3-56.3 212-62h199568v120H200432c-178.3\n 11.7-311.7 78.3-403 201-6 8-9.7 12-11 12-.7.7-6.7 1-18 1s-17.3-.3-18-1c-1.3 0\n-5-4-11-12-44.7-59.3-101.3-106.3-170-141s-145.3-54.3-229-60H0V214z",
          oiintSize1:
            "M512.6 71.6c272.6 0 320.3 106.8 320.3 178.2 0 70.8-47.7 177.6\n-320.3 177.6S193.1 320.6 193.1 249.8c0-71.4 46.9-178.2 319.5-178.2z\nm368.1 178.2c0-86.4-60.9-215.4-368.1-215.4-306.4 0-367.3 129-367.3 215.4 0 85.8\n60.9 214.8 367.3 214.8 307.2 0 368.1-129 368.1-214.8z",
          oiintSize2:
            "M757.8 100.1c384.7 0 451.1 137.6 451.1 230 0 91.3-66.4 228.8\n-451.1 228.8-386.3 0-452.7-137.5-452.7-228.8 0-92.4 66.4-230 452.7-230z\nm502.4 230c0-111.2-82.4-277.2-502.4-277.2s-504 166-504 277.2\nc0 110 84 276 504 276s502.4-166 502.4-276z",
          oiiintSize1:
            "M681.4 71.6c408.9 0 480.5 106.8 480.5 178.2 0 70.8-71.6 177.6\n-480.5 177.6S202.1 320.6 202.1 249.8c0-71.4 70.5-178.2 479.3-178.2z\nm525.8 178.2c0-86.4-86.8-215.4-525.7-215.4-437.9 0-524.7 129-524.7 215.4 0\n85.8 86.8 214.8 524.7 214.8 438.9 0 525.7-129 525.7-214.8z",
          oiiintSize2:
            "M1021.2 53c603.6 0 707.8 165.8 707.8 277.2 0 110-104.2 275.8\n-707.8 275.8-606 0-710.2-165.8-710.2-275.8C311 218.8 415.2 53 1021.2 53z\nm770.4 277.1c0-131.2-126.4-327.6-770.5-327.6S248.4 198.9 248.4 330.1\nc0 130 128.8 326.4 772.7 326.4s770.5-196.4 770.5-326.4z",
          rightarrow:
            "M0 241v40h399891c-47.3 35.3-84 78-110 128\n-16.7 32-27.7 63.7-33 95 0 1.3-.2 2.7-.5 4-.3 1.3-.5 2.3-.5 3 0 7.3 6.7 11 20\n 11 8 0 13.2-.8 15.5-2.5 2.3-1.7 4.2-5.5 5.5-11.5 2-13.3 5.7-27 11-41 14.7-44.7\n 39-84.5 73-119.5s73.7-60.2 119-75.5c6-2 9-5.7 9-11s-3-9-9-11c-45.3-15.3-85\n-40.5-119-75.5s-58.3-74.8-73-119.5c-4.7-14-8.3-27.3-11-40-1.3-6.7-3.2-10.8-5.5\n-12.5-2.3-1.7-7.5-2.5-15.5-2.5-14 0-21 3.7-21 11 0 2 2 10.3 6 25 20.7 83.3 67\n 151.7 139 205zm0 0v40h399900v-40z",
          rightbrace:
            "M400000 542l\n-6 6h-17c-12.7 0-19.3-.3-20-1-4-4-7.3-8.3-10-13-35.3-51.3-80.8-93.8-136.5-127.5\ns-117.2-55.8-184.5-66.5c-.7 0-2-.3-4-1-18.7-2.7-76-4.3-172-5H0V214h399571l6 1\nc124.7 8 235 61.7 331 161 31.3 33.3 59.7 72.7 85 118l7 13v35z",
          rightbraceunder:
            "M399994 0l6 6v35l-6 11c-56 104-135.3 181.3-238 232-57.3\n 28.7-117 45-179 50H-300V214h399897c43.3-7 81-15 113-26 100.7-33 179.7-91 237\n-174 2.7-5 6-9 10-13 .7-1 7.3-1 20-1h17z",
          rightgroup:
            "M0 80h399565c371 0 266.7 149.4 414 180 5.9 1.2 18 0 18 0 2 0\n 3-1 3-3v-38c-76-158-257-219-435-219H0z",
          rightgroupunder:
            "M0 262h399565c371 0 266.7-149.4 414-180 5.9-1.2 18 0 18\n 0 2 0 3 1 3 3v38c-76 158-257 219-435 219H0z",
          rightharpoon:
            "M0 241v40h399993c4.7-4.7 7-9.3 7-14 0-9.3\n-3.7-15.3-11-18-92.7-56.7-159-133.7-199-231-3.3-9.3-6-14.7-8-16-2-1.3-7-2-15-2\n-10.7 0-16.7 2-18 6-2 2.7-1 9.7 3 21 15.3 42 36.7 81.8 64 119.5 27.3 37.7 58\n 69.2 92 94.5zm0 0v40h399900v-40z",
          rightharpoonplus:
            "M0 241v40h399993c4.7-4.7 7-9.3 7-14 0-9.3-3.7-15.3-11\n-18-92.7-56.7-159-133.7-199-231-3.3-9.3-6-14.7-8-16-2-1.3-7-2-15-2-10.7 0-16.7\n 2-18 6-2 2.7-1 9.7 3 21 15.3 42 36.7 81.8 64 119.5 27.3 37.7 58 69.2 92 94.5z\nm0 0v40h399900v-40z m100 194v40h399900v-40zm0 0v40h399900v-40z",
          rightharpoondown:
            "M399747 511c0 7.3 6.7 11 20 11 8 0 13-.8 15-2.5s4.7-6.8\n 8-15.5c40-94 99.3-166.3 178-217 13.3-8 20.3-12.3 21-13 5.3-3.3 8.5-5.8 9.5\n-7.5 1-1.7 1.5-5.2 1.5-10.5s-2.3-10.3-7-15H0v40h399908c-34 25.3-64.7 57-92 95\n-27.3 38-48.7 77.7-64 119-3.3 8.7-5 14-5 16zM0 241v40h399900v-40z",
          rightharpoondownplus:
            "M399747 705c0 7.3 6.7 11 20 11 8 0 13-.8\n 15-2.5s4.7-6.8 8-15.5c40-94 99.3-166.3 178-217 13.3-8 20.3-12.3 21-13 5.3-3.3\n 8.5-5.8 9.5-7.5 1-1.7 1.5-5.2 1.5-10.5s-2.3-10.3-7-15H0v40h399908c-34 25.3\n-64.7 57-92 95-27.3 38-48.7 77.7-64 119-3.3 8.7-5 14-5 16zM0 435v40h399900v-40z\nm0-194v40h400000v-40zm0 0v40h400000v-40z",
          righthook:
            "M399859 241c-764 0 0 0 0 0 40-3.3 68.7-15.7 86-37 10-12 15-25.3\n 15-40 0-22.7-9.8-40.7-29.5-54-19.7-13.3-43.5-21-71.5-23-17.3-1.3-26-8-26-20 0\n-13.3 8.7-20 26-20 38 0 71 11.2 99 33.5 0 0 7 5.6 21 16.7 14 11.2 21 33.5 21\n 66.8s-14 61.2-42 83.5c-28 22.3-61 33.5-99 33.5L0 241z M0 281v-40h399859v40z",
          rightlinesegment:
            "M399960 241 V94 h40 V428 h-40 V281 H0 v-40z\nM399960 241 V94 h40 V428 h-40 V281 H0 v-40z",
          rightToFrom:
            "M400000 167c-70.7-42-118-97.7-142-167h-23c-15.3 0-23 .3-23\n 1 0 1.3 5.3 13.7 16 37 18 35.3 41.3 69 70 101l7 8H0v40h399905l-7 8c-28.7 32\n-52 65.7-70 101-10.7 23.3-16 35.7-16 37 0 .7 7.7 1 23 1h23c24-69.3 71.3-125 142\n-167z M100 147v40h399900v-40zM0 341v40h399900v-40z",
          twoheadleftarrow:
            "M0 167c68 40\n 115.7 95.7 143 167h22c15.3 0 23-.3 23-1 0-1.3-5.3-13.7-16-37-18-35.3-41.3-69\n-70-101l-7-8h125l9 7c50.7 39.3 85 86 103 140h46c0-4.7-6.3-18.7-19-42-18-35.3\n-40-67.3-66-96l-9-9h399716v-40H284l9-9c26-28.7 48-60.7 66-96 12.7-23.333 19\n-37.333 19-42h-46c-18 54-52.3 100.7-103 140l-9 7H95l7-8c28.7-32 52-65.7 70-101\n 10.7-23.333 16-35.7 16-37 0-.7-7.7-1-23-1h-22C115.7 71.3 68 127 0 167z",
          twoheadrightarrow:
            "M400000 167\nc-68-40-115.7-95.7-143-167h-22c-15.3 0-23 .3-23 1 0 1.3 5.3 13.7 16 37 18 35.3\n 41.3 69 70 101l7 8h-125l-9-7c-50.7-39.3-85-86-103-140h-46c0 4.7 6.3 18.7 19 42\n 18 35.3 40 67.3 66 96l9 9H0v40h399716l-9 9c-26 28.7-48 60.7-66 96-12.7 23.333\n-19 37.333-19 42h46c18-54 52.3-100.7 103-140l9-7h125l-7 8c-28.7 32-52 65.7-70\n 101-10.7 23.333-16 35.7-16 37 0 .7 7.7 1 23 1h22c27.3-71.3 75-127 143-167z",
          tilde1:
            "M200 55.538c-77 0-168 73.953-177 73.953-3 0-7\n-2.175-9-5.437L2 97c-1-2-2-4-2-6 0-4 2-7 5-9l20-12C116 12 171 0 207 0c86 0\n 114 68 191 68 78 0 168-68 177-68 4 0 7 2 9 5l12 19c1 2.175 2 4.35 2 6.525 0\n 4.35-2 7.613-5 9.788l-19 13.05c-92 63.077-116.937 75.308-183 76.128\n-68.267.847-113-73.952-191-73.952z",
          tilde2:
            "M344 55.266c-142 0-300.638 81.316-311.5 86.418\n-8.01 3.762-22.5 10.91-23.5 5.562L1 120c-1-2-1-3-1-4 0-5 3-9 8-10l18.4-9C160.9\n 31.9 283 0 358 0c148 0 188 122 331 122s314-97 326-97c4 0 8 2 10 7l7 21.114\nc1 2.14 1 3.21 1 4.28 0 5.347-3 9.626-7 10.696l-22.3 12.622C852.6 158.372 751\n 181.476 676 181.476c-149 0-189-126.21-332-126.21z",
          tilde3:
            "M786 59C457 59 32 175.242 13 175.242c-6 0-10-3.457\n-11-10.37L.15 138c-1-7 3-12 10-13l19.2-6.4C378.4 40.7 634.3 0 804.3 0c337 0\n 411.8 157 746.8 157 328 0 754-112 773-112 5 0 10 3 11 9l1 14.075c1 8.066-.697\n 16.595-6.697 17.492l-21.052 7.31c-367.9 98.146-609.15 122.696-778.15 122.696\n -338 0-409-156.573-744-156.573z",
          tilde4:
            "M786 58C457 58 32 177.487 13 177.487c-6 0-10-3.345\n-11-10.035L.15 143c-1-7 3-12 10-13l22-6.7C381.2 35 637.15 0 807.15 0c337 0 409\n 177 744 177 328 0 754-127 773-127 5 0 10 3 11 9l1 14.794c1 7.805-3 13.38-9\n 14.495l-20.7 5.574c-366.85 99.79-607.3 139.372-776.3 139.372-338 0-409\n -175.236-744-175.236z",
          vec: "M377 20c0-5.333 1.833-10 5.5-14S391 0 397 0c4.667 0 8.667 1.667 12 5\n3.333 2.667 6.667 9 10 19 6.667 24.667 20.333 43.667 41 57 7.333 4.667 11\n10.667 11 18 0 6-1 10-3 12s-6.667 5-14 9c-28.667 14.667-53.667 35.667-75 63\n-1.333 1.333-3.167 3.5-5.5 6.5s-4 4.833-5 5.5c-1 .667-2.5 1.333-4.5 2s-4.333 1\n-7 1c-4.667 0-9.167-1.833-13.5-5.5S337 184 337 178c0-12.667 15.667-32.333 47-59\nH213l-171-1c-8.667-6-13-12.333-13-19 0-4.667 4.333-11.333 13-20h359\nc-16-25.333-24-45-24-59z",
          widehat1:
            "M529 0h5l519 115c5 1 9 5 9 10 0 1-1 2-1 3l-4 22\nc-1 5-5 9-11 9h-2L532 67 19 159h-2c-5 0-9-4-11-9l-5-22c-1-6 2-12 8-13z",
          widehat2:
            "M1181 0h2l1171 176c6 0 10 5 10 11l-2 23c-1 6-5 10\n-11 10h-1L1182 67 15 220h-1c-6 0-10-4-11-10l-2-23c-1-6 4-11 10-11z",
          widehat3:
            "M1181 0h2l1171 236c6 0 10 5 10 11l-2 23c-1 6-5 10\n-11 10h-1L1182 67 15 280h-1c-6 0-10-4-11-10l-2-23c-1-6 4-11 10-11z",
          widehat4:
            "M1181 0h2l1171 296c6 0 10 5 10 11l-2 23c-1 6-5 10\n-11 10h-1L1182 67 15 340h-1c-6 0-10-4-11-10l-2-23c-1-6 4-11 10-11z",
          widecheck1:
            "M529,159h5l519,-115c5,-1,9,-5,9,-10c0,-1,-1,-2,-1,-3l-4,-22c-1,\n-5,-5,-9,-11,-9h-2l-512,92l-513,-92h-2c-5,0,-9,4,-11,9l-5,22c-1,6,2,12,8,13z",
          widecheck2:
            "M1181,220h2l1171,-176c6,0,10,-5,10,-11l-2,-23c-1,-6,-5,-10,\n-11,-10h-1l-1168,153l-1167,-153h-1c-6,0,-10,4,-11,10l-2,23c-1,6,4,11,10,11z",
          widecheck3:
            "M1181,280h2l1171,-236c6,0,10,-5,10,-11l-2,-23c-1,-6,-5,-10,\n-11,-10h-1l-1168,213l-1167,-213h-1c-6,0,-10,4,-11,10l-2,23c-1,6,4,11,10,11z",
          widecheck4:
            "M1181,340h2l1171,-296c6,0,10,-5,10,-11l-2,-23c-1,-6,-5,-10,\n-11,-10h-1l-1168,273l-1167,-273h-1c-6,0,-10,4,-11,10l-2,23c-1,6,4,11,10,11z",
          baraboveleftarrow:
            "M400000 620h-399890l3 -3c68.7 -52.7 113.7 -120 135 -202\nc4 -14.7 6 -23 6 -25c0 -7.3 -7 -11 -21 -11c-8 0 -13.2 0.8 -15.5 2.5\nc-2.3 1.7 -4.2 5.8 -5.5 12.5c-1.3 4.7 -2.7 10.3 -4 17c-12 48.7 -34.8 92 -68.5 130\ns-74.2 66.3 -121.5 85c-10 4 -16 7.7 -18 11c0 8.7 6 14.3 18 17c47.3 18.7 87.8 47\n121.5 85s56.5 81.3 68.5 130c0.7 2 1.3 5 2 9s1.2 6.7 1.5 8c0.3 1.3 1 3.3 2 6\ns2.2 4.5 3.5 5.5c1.3 1 3.3 1.8 6 2.5s6 1 10 1c14 0 21 -3.7 21 -11\nc0 -2 -2 -10.3 -6 -25c-20 -79.3 -65 -146.7 -135 -202l-3 -3h399890z\nM100 620v40h399900v-40z M0 241v40h399900v-40zM0 241v40h399900v-40z",
          rightarrowabovebar:
            "M0 241v40h399891c-47.3 35.3-84 78-110 128-16.7 32\n-27.7 63.7-33 95 0 1.3-.2 2.7-.5 4-.3 1.3-.5 2.3-.5 3 0 7.3 6.7 11 20 11 8 0\n13.2-.8 15.5-2.5 2.3-1.7 4.2-5.5 5.5-11.5 2-13.3 5.7-27 11-41 14.7-44.7 39\n-84.5 73-119.5s73.7-60.2 119-75.5c6-2 9-5.7 9-11s-3-9-9-11c-45.3-15.3-85-40.5\n-119-75.5s-58.3-74.8-73-119.5c-4.7-14-8.3-27.3-11-40-1.3-6.7-3.2-10.8-5.5\n-12.5-2.3-1.7-7.5-2.5-15.5-2.5-14 0-21 3.7-21 11 0 2 2 10.3 6 25 20.7 83.3 67\n151.7 139 205zm96 379h399894v40H0zm0 0h399904v40H0z",
          baraboveshortleftharpoon:
            "M507,435c-4,4,-6.3,8.7,-7,14c0,5.3,0.7,9,2,11\nc1.3,2,5.3,5.3,12,10c90.7,54,156,130,196,228c3.3,10.7,6.3,16.3,9,17\nc2,0.7,5,1,9,1c0,0,5,0,5,0c10.7,0,16.7,-2,18,-6c2,-2.7,1,-9.7,-3,-21\nc-32,-87.3,-82.7,-157.7,-152,-211c0,0,-3,-3,-3,-3l399351,0l0,-40\nc-398570,0,-399437,0,-399437,0z M593 435 v40 H399500 v-40z\nM0 281 v-40 H399908 v40z M0 281 v-40 H399908 v40z",
          rightharpoonaboveshortbar:
            "M0,241 l0,40c399126,0,399993,0,399993,0\nc4.7,-4.7,7,-9.3,7,-14c0,-9.3,-3.7,-15.3,-11,-18c-92.7,-56.7,-159,-133.7,-199,\n-231c-3.3,-9.3,-6,-14.7,-8,-16c-2,-1.3,-7,-2,-15,-2c-10.7,0,-16.7,2,-18,6\nc-2,2.7,-1,9.7,3,21c15.3,42,36.7,81.8,64,119.5c27.3,37.7,58,69.2,92,94.5z\nM0 241 v40 H399908 v-40z M0 475 v-40 H399500 v40z M0 475 v-40 H399500 v40z",
          shortbaraboveleftharpoon:
            "M7,435c-4,4,-6.3,8.7,-7,14c0,5.3,0.7,9,2,11\nc1.3,2,5.3,5.3,12,10c90.7,54,156,130,196,228c3.3,10.7,6.3,16.3,9,17c2,0.7,5,1,9,\n1c0,0,5,0,5,0c10.7,0,16.7,-2,18,-6c2,-2.7,1,-9.7,-3,-21c-32,-87.3,-82.7,-157.7,\n-152,-211c0,0,-3,-3,-3,-3l399907,0l0,-40c-399126,0,-399993,0,-399993,0z\nM93 435 v40 H400000 v-40z M500 241 v40 H400000 v-40z M500 241 v40 H400000 v-40z",
          shortrightharpoonabovebar:
            "M53,241l0,40c398570,0,399437,0,399437,0\nc4.7,-4.7,7,-9.3,7,-14c0,-9.3,-3.7,-15.3,-11,-18c-92.7,-56.7,-159,-133.7,-199,\n-231c-3.3,-9.3,-6,-14.7,-8,-16c-2,-1.3,-7,-2,-15,-2c-10.7,0,-16.7,2,-18,6\nc-2,2.7,-1,9.7,3,21c15.3,42,36.7,81.8,64,119.5c27.3,37.7,58,69.2,92,94.5z\nM500 241 v40 H399408 v-40z M500 435 v40 H400000 v-40z",
        },
        A = (function () {
          function t(t) {
            (this.children = void 0),
              (this.classes = void 0),
              (this.height = void 0),
              (this.depth = void 0),
              (this.maxFontSize = void 0),
              (this.style = void 0),
              (this.children = t),
              (this.classes = []),
              (this.height = 0),
              (this.depth = 0),
              (this.maxFontSize = 0),
              (this.style = {});
          }
          var e = t.prototype;
          return (
            (e.hasClass = function (t) {
              return c.contains(this.classes, t);
            }),
            (e.toNode = function () {
              for (
                var t = document.createDocumentFragment(), e = 0;
                e < this.children.length;
                e++
              )
                t.appendChild(this.children[e].toNode());
              return t;
            }),
            (e.toMarkup = function () {
              for (var t = "", e = 0; e < this.children.length; e++)
                t += this.children[e].toMarkup();
              return t;
            }),
            (e.toText = function () {
              var t = function (t) {
                return t.toText();
              };
              return this.children.map(t).join("");
            }),
            t
          );
        })(),
        T = function (t) {
          return t
            .filter(function (t) {
              return t;
            })
            .join(" ");
        },
        B = function (t, e, r) {
          if (
            ((this.classes = t || []),
            (this.attributes = {}),
            (this.height = 0),
            (this.depth = 0),
            (this.maxFontSize = 0),
            (this.style = r || {}),
            e)
          ) {
            e.style.isTight() && this.classes.push("mtight");
            var a = e.getColor();
            a && (this.style.color = a);
          }
        },
        C = function (t) {
          var e = document.createElement(t);
          for (var r in ((e.className = T(this.classes)), this.style))
            this.style.hasOwnProperty(r) && (e.style[r] = this.style[r]);
          for (var a in this.attributes)
            this.attributes.hasOwnProperty(a) &&
              e.setAttribute(a, this.attributes[a]);
          for (var n = 0; n < this.children.length; n++)
            e.appendChild(this.children[n].toNode());
          return e;
        },
        q = function (t) {
          var e = "<" + t;
          this.classes.length &&
            (e += ' class="' + c.escape(T(this.classes)) + '"');
          var r = "";
          for (var a in this.style)
            this.style.hasOwnProperty(a) &&
              (r += c.hyphenate(a) + ":" + this.style[a] + ";");
          for (var n in (r && (e += ' style="' + c.escape(r) + '"'),
          this.attributes))
            this.attributes.hasOwnProperty(n) &&
              (e += " " + n + '="' + c.escape(this.attributes[n]) + '"');
          e += ">";
          for (var i = 0; i < this.children.length; i++)
            e += this.children[i].toMarkup();
          return (e += "</" + t + ">");
        },
        N = (function () {
          function t(t, e, r, a) {
            (this.children = void 0),
              (this.attributes = void 0),
              (this.classes = void 0),
              (this.height = void 0),
              (this.depth = void 0),
              (this.width = void 0),
              (this.maxFontSize = void 0),
              (this.style = void 0),
              B.call(this, t, r, a),
              (this.children = e || []);
          }
          var e = t.prototype;
          return (
            (e.setAttribute = function (t, e) {
              this.attributes[t] = e;
            }),
            (e.hasClass = function (t) {
              return c.contains(this.classes, t);
            }),
            (e.toNode = function () {
              return C.call(this, "span");
            }),
            (e.toMarkup = function () {
              return q.call(this, "span");
            }),
            t
          );
        })(),
        I = (function () {
          function t(t, e, r, a) {
            (this.children = void 0),
              (this.attributes = void 0),
              (this.classes = void 0),
              (this.height = void 0),
              (this.depth = void 0),
              (this.maxFontSize = void 0),
              (this.style = void 0),
              B.call(this, e, a),
              (this.children = r || []),
              this.setAttribute("href", t);
          }
          var e = t.prototype;
          return (
            (e.setAttribute = function (t, e) {
              this.attributes[t] = e;
            }),
            (e.hasClass = function (t) {
              return c.contains(this.classes, t);
            }),
            (e.toNode = function () {
              return C.call(this, "a");
            }),
            (e.toMarkup = function () {
              return q.call(this, "a");
            }),
            t
          );
        })(),
        O = (function () {
          function t(t, e, r) {
            (this.src = void 0),
              (this.alt = void 0),
              (this.classes = void 0),
              (this.height = void 0),
              (this.depth = void 0),
              (this.maxFontSize = void 0),
              (this.style = void 0),
              (this.alt = e),
              (this.src = t),
              (this.classes = ["mord"]),
              (this.style = r);
          }
          var e = t.prototype;
          return (
            (e.hasClass = function (t) {
              return c.contains(this.classes, t);
            }),
            (e.toNode = function () {
              var t = document.createElement("img");
              for (var e in ((t.src = this.src),
              (t.alt = this.alt),
              (t.className = "mord"),
              this.style))
                this.style.hasOwnProperty(e) && (t.style[e] = this.style[e]);
              return t;
            }),
            (e.toMarkup = function () {
              var t = "<img  src='" + this.src + " 'alt='" + this.alt + "' ",
                e = "";
              for (var r in this.style)
                this.style.hasOwnProperty(r) &&
                  (e += c.hyphenate(r) + ":" + this.style[r] + ";");
              return e && (t += ' style="' + c.escape(e) + '"'), (t += "'/>");
            }),
            t
          );
        })(),
        R = {
          "\xee": "\u0131\u0302",
          "\xef": "\u0131\u0308",
          "\xed": "\u0131\u0301",
          "\xec": "\u0131\u0300",
        },
        E = (function () {
          function t(t, e, r, a, n, i, o, s) {
            (this.text = void 0),
              (this.height = void 0),
              (this.depth = void 0),
              (this.italic = void 0),
              (this.skew = void 0),
              (this.width = void 0),
              (this.maxFontSize = void 0),
              (this.classes = void 0),
              (this.style = void 0),
              (this.text = t),
              (this.height = e || 0),
              (this.depth = r || 0),
              (this.italic = a || 0),
              (this.skew = n || 0),
              (this.width = i || 0),
              (this.classes = o || []),
              (this.style = s || {}),
              (this.maxFontSize = 0);
            var l = (function (t) {
              for (var e = 0; e < k.length; e++)
                for (var r = k[e], a = 0; a < r.blocks.length; a++) {
                  var n = r.blocks[a];
                  if (t >= n[0] && t <= n[1]) return r.name;
                }
              return null;
            })(this.text.charCodeAt(0));
            l && this.classes.push(l + "_fallback"),
              /[\xee\xef\xed\xec]/.test(this.text) &&
                (this.text = R[this.text]);
          }
          var e = t.prototype;
          return (
            (e.hasClass = function (t) {
              return c.contains(this.classes, t);
            }),
            (e.toNode = function () {
              var t = document.createTextNode(this.text),
                e = null;
              for (var r in (this.italic > 0 &&
                ((e = document.createElement("span")).style.marginRight =
                  this.italic + "em"),
              this.classes.length > 0 &&
                ((e = e || document.createElement("span")).className = T(
                  this.classes,
                )),
              this.style))
                this.style.hasOwnProperty(r) &&
                  ((e = e || document.createElement("span")).style[r] =
                    this.style[r]);
              return e ? (e.appendChild(t), e) : t;
            }),
            (e.toMarkup = function () {
              var t = !1,
                e = "<span";
              this.classes.length &&
                ((t = !0),
                (e += ' class="'),
                (e += c.escape(T(this.classes))),
                (e += '"'));
              var r = "";
              for (var a in (this.italic > 0 &&
                (r += "margin-right:" + this.italic + "em;"),
              this.style))
                this.style.hasOwnProperty(a) &&
                  (r += c.hyphenate(a) + ":" + this.style[a] + ";");
              r && ((t = !0), (e += ' style="' + c.escape(r) + '"'));
              var n = c.escape(this.text);
              return t ? ((e += ">"), (e += n), (e += "</span>")) : n;
            }),
            t
          );
        })(),
        L = (function () {
          function t(t, e) {
            (this.children = void 0),
              (this.attributes = void 0),
              (this.children = t || []),
              (this.attributes = e || {});
          }
          var e = t.prototype;
          return (
            (e.toNode = function () {
              var t = document.createElementNS(
                "http://www.w3.org/2000/svg",
                "svg",
              );
              for (var e in this.attributes)
                Object.prototype.hasOwnProperty.call(this.attributes, e) &&
                  t.setAttribute(e, this.attributes[e]);
              for (var r = 0; r < this.children.length; r++)
                t.appendChild(this.children[r].toNode());
              return t;
            }),
            (e.toMarkup = function () {
              var t = "<svg";
              for (var e in this.attributes)
                Object.prototype.hasOwnProperty.call(this.attributes, e) &&
                  (t += " " + e + "='" + this.attributes[e] + "'");
              t += ">";
              for (var r = 0; r < this.children.length; r++)
                t += this.children[r].toMarkup();
              return (t += "</svg>");
            }),
            t
          );
        })(),
        P = (function () {
          function t(t, e) {
            (this.pathName = void 0),
              (this.alternate = void 0),
              (this.pathName = t),
              (this.alternate = e);
          }
          var e = t.prototype;
          return (
            (e.toNode = function () {
              var t = document.createElementNS(
                "http://www.w3.org/2000/svg",
                "path",
              );
              return (
                this.alternate
                  ? t.setAttribute("d", this.alternate)
                  : t.setAttribute("d", z[this.pathName]),
                t
              );
            }),
            (e.toMarkup = function () {
              return this.alternate
                ? "<path d='" + this.alternate + "'/>"
                : "<path d='" + z[this.pathName] + "'/>";
            }),
            t
          );
        })(),
        D = (function () {
          function t(t) {
            (this.attributes = void 0), (this.attributes = t || {});
          }
          var e = t.prototype;
          return (
            (e.toNode = function () {
              var t = document.createElementNS(
                "http://www.w3.org/2000/svg",
                "line",
              );
              for (var e in this.attributes)
                Object.prototype.hasOwnProperty.call(this.attributes, e) &&
                  t.setAttribute(e, this.attributes[e]);
              return t;
            }),
            (e.toMarkup = function () {
              var t = "<line";
              for (var e in this.attributes)
                Object.prototype.hasOwnProperty.call(this.attributes, e) &&
                  (t += " " + e + "='" + this.attributes[e] + "'");
              return (t += "/>");
            }),
            t
          );
        })();
      function H(t) {
        if (t instanceof E) return t;
        throw new Error("Expected symbolNode but got " + String(t) + ".");
      }
      var F = {
          "AMS-Regular": {
            32: [0, 0, 0, 0, 0.25],
            65: [0, 0.68889, 0, 0, 0.72222],
            66: [0, 0.68889, 0, 0, 0.66667],
            67: [0, 0.68889, 0, 0, 0.72222],
            68: [0, 0.68889, 0, 0, 0.72222],
            69: [0, 0.68889, 0, 0, 0.66667],
            70: [0, 0.68889, 0, 0, 0.61111],
            71: [0, 0.68889, 0, 0, 0.77778],
            72: [0, 0.68889, 0, 0, 0.77778],
            73: [0, 0.68889, 0, 0, 0.38889],
            74: [0.16667, 0.68889, 0, 0, 0.5],
            75: [0, 0.68889, 0, 0, 0.77778],
            76: [0, 0.68889, 0, 0, 0.66667],
            77: [0, 0.68889, 0, 0, 0.94445],
            78: [0, 0.68889, 0, 0, 0.72222],
            79: [0.16667, 0.68889, 0, 0, 0.77778],
            80: [0, 0.68889, 0, 0, 0.61111],
            81: [0.16667, 0.68889, 0, 0, 0.77778],
            82: [0, 0.68889, 0, 0, 0.72222],
            83: [0, 0.68889, 0, 0, 0.55556],
            84: [0, 0.68889, 0, 0, 0.66667],
            85: [0, 0.68889, 0, 0, 0.72222],
            86: [0, 0.68889, 0, 0, 0.72222],
            87: [0, 0.68889, 0, 0, 1],
            88: [0, 0.68889, 0, 0, 0.72222],
            89: [0, 0.68889, 0, 0, 0.72222],
            90: [0, 0.68889, 0, 0, 0.66667],
            107: [0, 0.68889, 0, 0, 0.55556],
            160: [0, 0, 0, 0, 0.25],
            165: [0, 0.675, 0.025, 0, 0.75],
            174: [0.15559, 0.69224, 0, 0, 0.94666],
            240: [0, 0.68889, 0, 0, 0.55556],
            295: [0, 0.68889, 0, 0, 0.54028],
            710: [0, 0.825, 0, 0, 2.33334],
            732: [0, 0.9, 0, 0, 2.33334],
            770: [0, 0.825, 0, 0, 2.33334],
            771: [0, 0.9, 0, 0, 2.33334],
            989: [0.08167, 0.58167, 0, 0, 0.77778],
            1008: [0, 0.43056, 0.04028, 0, 0.66667],
            8245: [0, 0.54986, 0, 0, 0.275],
            8463: [0, 0.68889, 0, 0, 0.54028],
            8487: [0, 0.68889, 0, 0, 0.72222],
            8498: [0, 0.68889, 0, 0, 0.55556],
            8502: [0, 0.68889, 0, 0, 0.66667],
            8503: [0, 0.68889, 0, 0, 0.44445],
            8504: [0, 0.68889, 0, 0, 0.66667],
            8513: [0, 0.68889, 0, 0, 0.63889],
            8592: [-0.03598, 0.46402, 0, 0, 0.5],
            8594: [-0.03598, 0.46402, 0, 0, 0.5],
            8602: [-0.13313, 0.36687, 0, 0, 1],
            8603: [-0.13313, 0.36687, 0, 0, 1],
            8606: [0.01354, 0.52239, 0, 0, 1],
            8608: [0.01354, 0.52239, 0, 0, 1],
            8610: [0.01354, 0.52239, 0, 0, 1.11111],
            8611: [0.01354, 0.52239, 0, 0, 1.11111],
            8619: [0, 0.54986, 0, 0, 1],
            8620: [0, 0.54986, 0, 0, 1],
            8621: [-0.13313, 0.37788, 0, 0, 1.38889],
            8622: [-0.13313, 0.36687, 0, 0, 1],
            8624: [0, 0.69224, 0, 0, 0.5],
            8625: [0, 0.69224, 0, 0, 0.5],
            8630: [0, 0.43056, 0, 0, 1],
            8631: [0, 0.43056, 0, 0, 1],
            8634: [0.08198, 0.58198, 0, 0, 0.77778],
            8635: [0.08198, 0.58198, 0, 0, 0.77778],
            8638: [0.19444, 0.69224, 0, 0, 0.41667],
            8639: [0.19444, 0.69224, 0, 0, 0.41667],
            8642: [0.19444, 0.69224, 0, 0, 0.41667],
            8643: [0.19444, 0.69224, 0, 0, 0.41667],
            8644: [0.1808, 0.675, 0, 0, 1],
            8646: [0.1808, 0.675, 0, 0, 1],
            8647: [0.1808, 0.675, 0, 0, 1],
            8648: [0.19444, 0.69224, 0, 0, 0.83334],
            8649: [0.1808, 0.675, 0, 0, 1],
            8650: [0.19444, 0.69224, 0, 0, 0.83334],
            8651: [0.01354, 0.52239, 0, 0, 1],
            8652: [0.01354, 0.52239, 0, 0, 1],
            8653: [-0.13313, 0.36687, 0, 0, 1],
            8654: [-0.13313, 0.36687, 0, 0, 1],
            8655: [-0.13313, 0.36687, 0, 0, 1],
            8666: [0.13667, 0.63667, 0, 0, 1],
            8667: [0.13667, 0.63667, 0, 0, 1],
            8669: [-0.13313, 0.37788, 0, 0, 1],
            8672: [-0.064, 0.437, 0, 0, 1.334],
            8674: [-0.064, 0.437, 0, 0, 1.334],
            8705: [0, 0.825, 0, 0, 0.5],
            8708: [0, 0.68889, 0, 0, 0.55556],
            8709: [0.08167, 0.58167, 0, 0, 0.77778],
            8717: [0, 0.43056, 0, 0, 0.42917],
            8722: [-0.03598, 0.46402, 0, 0, 0.5],
            8724: [0.08198, 0.69224, 0, 0, 0.77778],
            8726: [0.08167, 0.58167, 0, 0, 0.77778],
            8733: [0, 0.69224, 0, 0, 0.77778],
            8736: [0, 0.69224, 0, 0, 0.72222],
            8737: [0, 0.69224, 0, 0, 0.72222],
            8738: [0.03517, 0.52239, 0, 0, 0.72222],
            8739: [0.08167, 0.58167, 0, 0, 0.22222],
            8740: [0.25142, 0.74111, 0, 0, 0.27778],
            8741: [0.08167, 0.58167, 0, 0, 0.38889],
            8742: [0.25142, 0.74111, 0, 0, 0.5],
            8756: [0, 0.69224, 0, 0, 0.66667],
            8757: [0, 0.69224, 0, 0, 0.66667],
            8764: [-0.13313, 0.36687, 0, 0, 0.77778],
            8765: [-0.13313, 0.37788, 0, 0, 0.77778],
            8769: [-0.13313, 0.36687, 0, 0, 0.77778],
            8770: [-0.03625, 0.46375, 0, 0, 0.77778],
            8774: [0.30274, 0.79383, 0, 0, 0.77778],
            8776: [-0.01688, 0.48312, 0, 0, 0.77778],
            8778: [0.08167, 0.58167, 0, 0, 0.77778],
            8782: [0.06062, 0.54986, 0, 0, 0.77778],
            8783: [0.06062, 0.54986, 0, 0, 0.77778],
            8785: [0.08198, 0.58198, 0, 0, 0.77778],
            8786: [0.08198, 0.58198, 0, 0, 0.77778],
            8787: [0.08198, 0.58198, 0, 0, 0.77778],
            8790: [0, 0.69224, 0, 0, 0.77778],
            8791: [0.22958, 0.72958, 0, 0, 0.77778],
            8796: [0.08198, 0.91667, 0, 0, 0.77778],
            8806: [0.25583, 0.75583, 0, 0, 0.77778],
            8807: [0.25583, 0.75583, 0, 0, 0.77778],
            8808: [0.25142, 0.75726, 0, 0, 0.77778],
            8809: [0.25142, 0.75726, 0, 0, 0.77778],
            8812: [0.25583, 0.75583, 0, 0, 0.5],
            8814: [0.20576, 0.70576, 0, 0, 0.77778],
            8815: [0.20576, 0.70576, 0, 0, 0.77778],
            8816: [0.30274, 0.79383, 0, 0, 0.77778],
            8817: [0.30274, 0.79383, 0, 0, 0.77778],
            8818: [0.22958, 0.72958, 0, 0, 0.77778],
            8819: [0.22958, 0.72958, 0, 0, 0.77778],
            8822: [0.1808, 0.675, 0, 0, 0.77778],
            8823: [0.1808, 0.675, 0, 0, 0.77778],
            8828: [0.13667, 0.63667, 0, 0, 0.77778],
            8829: [0.13667, 0.63667, 0, 0, 0.77778],
            8830: [0.22958, 0.72958, 0, 0, 0.77778],
            8831: [0.22958, 0.72958, 0, 0, 0.77778],
            8832: [0.20576, 0.70576, 0, 0, 0.77778],
            8833: [0.20576, 0.70576, 0, 0, 0.77778],
            8840: [0.30274, 0.79383, 0, 0, 0.77778],
            8841: [0.30274, 0.79383, 0, 0, 0.77778],
            8842: [0.13597, 0.63597, 0, 0, 0.77778],
            8843: [0.13597, 0.63597, 0, 0, 0.77778],
            8847: [0.03517, 0.54986, 0, 0, 0.77778],
            8848: [0.03517, 0.54986, 0, 0, 0.77778],
            8858: [0.08198, 0.58198, 0, 0, 0.77778],
            8859: [0.08198, 0.58198, 0, 0, 0.77778],
            8861: [0.08198, 0.58198, 0, 0, 0.77778],
            8862: [0, 0.675, 0, 0, 0.77778],
            8863: [0, 0.675, 0, 0, 0.77778],
            8864: [0, 0.675, 0, 0, 0.77778],
            8865: [0, 0.675, 0, 0, 0.77778],
            8872: [0, 0.69224, 0, 0, 0.61111],
            8873: [0, 0.69224, 0, 0, 0.72222],
            8874: [0, 0.69224, 0, 0, 0.88889],
            8876: [0, 0.68889, 0, 0, 0.61111],
            8877: [0, 0.68889, 0, 0, 0.61111],
            8878: [0, 0.68889, 0, 0, 0.72222],
            8879: [0, 0.68889, 0, 0, 0.72222],
            8882: [0.03517, 0.54986, 0, 0, 0.77778],
            8883: [0.03517, 0.54986, 0, 0, 0.77778],
            8884: [0.13667, 0.63667, 0, 0, 0.77778],
            8885: [0.13667, 0.63667, 0, 0, 0.77778],
            8888: [0, 0.54986, 0, 0, 1.11111],
            8890: [0.19444, 0.43056, 0, 0, 0.55556],
            8891: [0.19444, 0.69224, 0, 0, 0.61111],
            8892: [0.19444, 0.69224, 0, 0, 0.61111],
            8901: [0, 0.54986, 0, 0, 0.27778],
            8903: [0.08167, 0.58167, 0, 0, 0.77778],
            8905: [0.08167, 0.58167, 0, 0, 0.77778],
            8906: [0.08167, 0.58167, 0, 0, 0.77778],
            8907: [0, 0.69224, 0, 0, 0.77778],
            8908: [0, 0.69224, 0, 0, 0.77778],
            8909: [-0.03598, 0.46402, 0, 0, 0.77778],
            8910: [0, 0.54986, 0, 0, 0.76042],
            8911: [0, 0.54986, 0, 0, 0.76042],
            8912: [0.03517, 0.54986, 0, 0, 0.77778],
            8913: [0.03517, 0.54986, 0, 0, 0.77778],
            8914: [0, 0.54986, 0, 0, 0.66667],
            8915: [0, 0.54986, 0, 0, 0.66667],
            8916: [0, 0.69224, 0, 0, 0.66667],
            8918: [0.0391, 0.5391, 0, 0, 0.77778],
            8919: [0.0391, 0.5391, 0, 0, 0.77778],
            8920: [0.03517, 0.54986, 0, 0, 1.33334],
            8921: [0.03517, 0.54986, 0, 0, 1.33334],
            8922: [0.38569, 0.88569, 0, 0, 0.77778],
            8923: [0.38569, 0.88569, 0, 0, 0.77778],
            8926: [0.13667, 0.63667, 0, 0, 0.77778],
            8927: [0.13667, 0.63667, 0, 0, 0.77778],
            8928: [0.30274, 0.79383, 0, 0, 0.77778],
            8929: [0.30274, 0.79383, 0, 0, 0.77778],
            8934: [0.23222, 0.74111, 0, 0, 0.77778],
            8935: [0.23222, 0.74111, 0, 0, 0.77778],
            8936: [0.23222, 0.74111, 0, 0, 0.77778],
            8937: [0.23222, 0.74111, 0, 0, 0.77778],
            8938: [0.20576, 0.70576, 0, 0, 0.77778],
            8939: [0.20576, 0.70576, 0, 0, 0.77778],
            8940: [0.30274, 0.79383, 0, 0, 0.77778],
            8941: [0.30274, 0.79383, 0, 0, 0.77778],
            8994: [0.19444, 0.69224, 0, 0, 0.77778],
            8995: [0.19444, 0.69224, 0, 0, 0.77778],
            9416: [0.15559, 0.69224, 0, 0, 0.90222],
            9484: [0, 0.69224, 0, 0, 0.5],
            9488: [0, 0.69224, 0, 0, 0.5],
            9492: [0, 0.37788, 0, 0, 0.5],
            9496: [0, 0.37788, 0, 0, 0.5],
            9585: [0.19444, 0.68889, 0, 0, 0.88889],
            9586: [0.19444, 0.74111, 0, 0, 0.88889],
            9632: [0, 0.675, 0, 0, 0.77778],
            9633: [0, 0.675, 0, 0, 0.77778],
            9650: [0, 0.54986, 0, 0, 0.72222],
            9651: [0, 0.54986, 0, 0, 0.72222],
            9654: [0.03517, 0.54986, 0, 0, 0.77778],
            9660: [0, 0.54986, 0, 0, 0.72222],
            9661: [0, 0.54986, 0, 0, 0.72222],
            9664: [0.03517, 0.54986, 0, 0, 0.77778],
            9674: [0.11111, 0.69224, 0, 0, 0.66667],
            9733: [0.19444, 0.69224, 0, 0, 0.94445],
            10003: [0, 0.69224, 0, 0, 0.83334],
            10016: [0, 0.69224, 0, 0, 0.83334],
            10731: [0.11111, 0.69224, 0, 0, 0.66667],
            10846: [0.19444, 0.75583, 0, 0, 0.61111],
            10877: [0.13667, 0.63667, 0, 0, 0.77778],
            10878: [0.13667, 0.63667, 0, 0, 0.77778],
            10885: [0.25583, 0.75583, 0, 0, 0.77778],
            10886: [0.25583, 0.75583, 0, 0, 0.77778],
            10887: [0.13597, 0.63597, 0, 0, 0.77778],
            10888: [0.13597, 0.63597, 0, 0, 0.77778],
            10889: [0.26167, 0.75726, 0, 0, 0.77778],
            10890: [0.26167, 0.75726, 0, 0, 0.77778],
            10891: [0.48256, 0.98256, 0, 0, 0.77778],
            10892: [0.48256, 0.98256, 0, 0, 0.77778],
            10901: [0.13667, 0.63667, 0, 0, 0.77778],
            10902: [0.13667, 0.63667, 0, 0, 0.77778],
            10933: [0.25142, 0.75726, 0, 0, 0.77778],
            10934: [0.25142, 0.75726, 0, 0, 0.77778],
            10935: [0.26167, 0.75726, 0, 0, 0.77778],
            10936: [0.26167, 0.75726, 0, 0, 0.77778],
            10937: [0.26167, 0.75726, 0, 0, 0.77778],
            10938: [0.26167, 0.75726, 0, 0, 0.77778],
            10949: [0.25583, 0.75583, 0, 0, 0.77778],
            10950: [0.25583, 0.75583, 0, 0, 0.77778],
            10955: [0.28481, 0.79383, 0, 0, 0.77778],
            10956: [0.28481, 0.79383, 0, 0, 0.77778],
            57350: [0.08167, 0.58167, 0, 0, 0.22222],
            57351: [0.08167, 0.58167, 0, 0, 0.38889],
            57352: [0.08167, 0.58167, 0, 0, 0.77778],
            57353: [0, 0.43056, 0.04028, 0, 0.66667],
            57356: [0.25142, 0.75726, 0, 0, 0.77778],
            57357: [0.25142, 0.75726, 0, 0, 0.77778],
            57358: [0.41951, 0.91951, 0, 0, 0.77778],
            57359: [0.30274, 0.79383, 0, 0, 0.77778],
            57360: [0.30274, 0.79383, 0, 0, 0.77778],
            57361: [0.41951, 0.91951, 0, 0, 0.77778],
            57366: [0.25142, 0.75726, 0, 0, 0.77778],
            57367: [0.25142, 0.75726, 0, 0, 0.77778],
            57368: [0.25142, 0.75726, 0, 0, 0.77778],
            57369: [0.25142, 0.75726, 0, 0, 0.77778],
            57370: [0.13597, 0.63597, 0, 0, 0.77778],
            57371: [0.13597, 0.63597, 0, 0, 0.77778],
          },
          "Caligraphic-Regular": {
            32: [0, 0, 0, 0, 0.25],
            65: [0, 0.68333, 0, 0.19445, 0.79847],
            66: [0, 0.68333, 0.03041, 0.13889, 0.65681],
            67: [0, 0.68333, 0.05834, 0.13889, 0.52653],
            68: [0, 0.68333, 0.02778, 0.08334, 0.77139],
            69: [0, 0.68333, 0.08944, 0.11111, 0.52778],
            70: [0, 0.68333, 0.09931, 0.11111, 0.71875],
            71: [0.09722, 0.68333, 0.0593, 0.11111, 0.59487],
            72: [0, 0.68333, 0.00965, 0.11111, 0.84452],
            73: [0, 0.68333, 0.07382, 0, 0.54452],
            74: [0.09722, 0.68333, 0.18472, 0.16667, 0.67778],
            75: [0, 0.68333, 0.01445, 0.05556, 0.76195],
            76: [0, 0.68333, 0, 0.13889, 0.68972],
            77: [0, 0.68333, 0, 0.13889, 1.2009],
            78: [0, 0.68333, 0.14736, 0.08334, 0.82049],
            79: [0, 0.68333, 0.02778, 0.11111, 0.79611],
            80: [0, 0.68333, 0.08222, 0.08334, 0.69556],
            81: [0.09722, 0.68333, 0, 0.11111, 0.81667],
            82: [0, 0.68333, 0, 0.08334, 0.8475],
            83: [0, 0.68333, 0.075, 0.13889, 0.60556],
            84: [0, 0.68333, 0.25417, 0, 0.54464],
            85: [0, 0.68333, 0.09931, 0.08334, 0.62583],
            86: [0, 0.68333, 0.08222, 0, 0.61278],
            87: [0, 0.68333, 0.08222, 0.08334, 0.98778],
            88: [0, 0.68333, 0.14643, 0.13889, 0.7133],
            89: [0.09722, 0.68333, 0.08222, 0.08334, 0.66834],
            90: [0, 0.68333, 0.07944, 0.13889, 0.72473],
            160: [0, 0, 0, 0, 0.25],
          },
          "Fraktur-Regular": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69141, 0, 0, 0.29574],
            34: [0, 0.69141, 0, 0, 0.21471],
            38: [0, 0.69141, 0, 0, 0.73786],
            39: [0, 0.69141, 0, 0, 0.21201],
            40: [0.24982, 0.74947, 0, 0, 0.38865],
            41: [0.24982, 0.74947, 0, 0, 0.38865],
            42: [0, 0.62119, 0, 0, 0.27764],
            43: [0.08319, 0.58283, 0, 0, 0.75623],
            44: [0, 0.10803, 0, 0, 0.27764],
            45: [0.08319, 0.58283, 0, 0, 0.75623],
            46: [0, 0.10803, 0, 0, 0.27764],
            47: [0.24982, 0.74947, 0, 0, 0.50181],
            48: [0, 0.47534, 0, 0, 0.50181],
            49: [0, 0.47534, 0, 0, 0.50181],
            50: [0, 0.47534, 0, 0, 0.50181],
            51: [0.18906, 0.47534, 0, 0, 0.50181],
            52: [0.18906, 0.47534, 0, 0, 0.50181],
            53: [0.18906, 0.47534, 0, 0, 0.50181],
            54: [0, 0.69141, 0, 0, 0.50181],
            55: [0.18906, 0.47534, 0, 0, 0.50181],
            56: [0, 0.69141, 0, 0, 0.50181],
            57: [0.18906, 0.47534, 0, 0, 0.50181],
            58: [0, 0.47534, 0, 0, 0.21606],
            59: [0.12604, 0.47534, 0, 0, 0.21606],
            61: [-0.13099, 0.36866, 0, 0, 0.75623],
            63: [0, 0.69141, 0, 0, 0.36245],
            65: [0, 0.69141, 0, 0, 0.7176],
            66: [0, 0.69141, 0, 0, 0.88397],
            67: [0, 0.69141, 0, 0, 0.61254],
            68: [0, 0.69141, 0, 0, 0.83158],
            69: [0, 0.69141, 0, 0, 0.66278],
            70: [0.12604, 0.69141, 0, 0, 0.61119],
            71: [0, 0.69141, 0, 0, 0.78539],
            72: [0.06302, 0.69141, 0, 0, 0.7203],
            73: [0, 0.69141, 0, 0, 0.55448],
            74: [0.12604, 0.69141, 0, 0, 0.55231],
            75: [0, 0.69141, 0, 0, 0.66845],
            76: [0, 0.69141, 0, 0, 0.66602],
            77: [0, 0.69141, 0, 0, 1.04953],
            78: [0, 0.69141, 0, 0, 0.83212],
            79: [0, 0.69141, 0, 0, 0.82699],
            80: [0.18906, 0.69141, 0, 0, 0.82753],
            81: [0.03781, 0.69141, 0, 0, 0.82699],
            82: [0, 0.69141, 0, 0, 0.82807],
            83: [0, 0.69141, 0, 0, 0.82861],
            84: [0, 0.69141, 0, 0, 0.66899],
            85: [0, 0.69141, 0, 0, 0.64576],
            86: [0, 0.69141, 0, 0, 0.83131],
            87: [0, 0.69141, 0, 0, 1.04602],
            88: [0, 0.69141, 0, 0, 0.71922],
            89: [0.18906, 0.69141, 0, 0, 0.83293],
            90: [0.12604, 0.69141, 0, 0, 0.60201],
            91: [0.24982, 0.74947, 0, 0, 0.27764],
            93: [0.24982, 0.74947, 0, 0, 0.27764],
            94: [0, 0.69141, 0, 0, 0.49965],
            97: [0, 0.47534, 0, 0, 0.50046],
            98: [0, 0.69141, 0, 0, 0.51315],
            99: [0, 0.47534, 0, 0, 0.38946],
            100: [0, 0.62119, 0, 0, 0.49857],
            101: [0, 0.47534, 0, 0, 0.40053],
            102: [0.18906, 0.69141, 0, 0, 0.32626],
            103: [0.18906, 0.47534, 0, 0, 0.5037],
            104: [0.18906, 0.69141, 0, 0, 0.52126],
            105: [0, 0.69141, 0, 0, 0.27899],
            106: [0, 0.69141, 0, 0, 0.28088],
            107: [0, 0.69141, 0, 0, 0.38946],
            108: [0, 0.69141, 0, 0, 0.27953],
            109: [0, 0.47534, 0, 0, 0.76676],
            110: [0, 0.47534, 0, 0, 0.52666],
            111: [0, 0.47534, 0, 0, 0.48885],
            112: [0.18906, 0.52396, 0, 0, 0.50046],
            113: [0.18906, 0.47534, 0, 0, 0.48912],
            114: [0, 0.47534, 0, 0, 0.38919],
            115: [0, 0.47534, 0, 0, 0.44266],
            116: [0, 0.62119, 0, 0, 0.33301],
            117: [0, 0.47534, 0, 0, 0.5172],
            118: [0, 0.52396, 0, 0, 0.5118],
            119: [0, 0.52396, 0, 0, 0.77351],
            120: [0.18906, 0.47534, 0, 0, 0.38865],
            121: [0.18906, 0.47534, 0, 0, 0.49884],
            122: [0.18906, 0.47534, 0, 0, 0.39054],
            160: [0, 0, 0, 0, 0.25],
            8216: [0, 0.69141, 0, 0, 0.21471],
            8217: [0, 0.69141, 0, 0, 0.21471],
            58112: [0, 0.62119, 0, 0, 0.49749],
            58113: [0, 0.62119, 0, 0, 0.4983],
            58114: [0.18906, 0.69141, 0, 0, 0.33328],
            58115: [0.18906, 0.69141, 0, 0, 0.32923],
            58116: [0.18906, 0.47534, 0, 0, 0.50343],
            58117: [0, 0.69141, 0, 0, 0.33301],
            58118: [0, 0.62119, 0, 0, 0.33409],
            58119: [0, 0.47534, 0, 0, 0.50073],
          },
          "Main-Bold": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69444, 0, 0, 0.35],
            34: [0, 0.69444, 0, 0, 0.60278],
            35: [0.19444, 0.69444, 0, 0, 0.95833],
            36: [0.05556, 0.75, 0, 0, 0.575],
            37: [0.05556, 0.75, 0, 0, 0.95833],
            38: [0, 0.69444, 0, 0, 0.89444],
            39: [0, 0.69444, 0, 0, 0.31944],
            40: [0.25, 0.75, 0, 0, 0.44722],
            41: [0.25, 0.75, 0, 0, 0.44722],
            42: [0, 0.75, 0, 0, 0.575],
            43: [0.13333, 0.63333, 0, 0, 0.89444],
            44: [0.19444, 0.15556, 0, 0, 0.31944],
            45: [0, 0.44444, 0, 0, 0.38333],
            46: [0, 0.15556, 0, 0, 0.31944],
            47: [0.25, 0.75, 0, 0, 0.575],
            48: [0, 0.64444, 0, 0, 0.575],
            49: [0, 0.64444, 0, 0, 0.575],
            50: [0, 0.64444, 0, 0, 0.575],
            51: [0, 0.64444, 0, 0, 0.575],
            52: [0, 0.64444, 0, 0, 0.575],
            53: [0, 0.64444, 0, 0, 0.575],
            54: [0, 0.64444, 0, 0, 0.575],
            55: [0, 0.64444, 0, 0, 0.575],
            56: [0, 0.64444, 0, 0, 0.575],
            57: [0, 0.64444, 0, 0, 0.575],
            58: [0, 0.44444, 0, 0, 0.31944],
            59: [0.19444, 0.44444, 0, 0, 0.31944],
            60: [0.08556, 0.58556, 0, 0, 0.89444],
            61: [-0.10889, 0.39111, 0, 0, 0.89444],
            62: [0.08556, 0.58556, 0, 0, 0.89444],
            63: [0, 0.69444, 0, 0, 0.54305],
            64: [0, 0.69444, 0, 0, 0.89444],
            65: [0, 0.68611, 0, 0, 0.86944],
            66: [0, 0.68611, 0, 0, 0.81805],
            67: [0, 0.68611, 0, 0, 0.83055],
            68: [0, 0.68611, 0, 0, 0.88194],
            69: [0, 0.68611, 0, 0, 0.75555],
            70: [0, 0.68611, 0, 0, 0.72361],
            71: [0, 0.68611, 0, 0, 0.90416],
            72: [0, 0.68611, 0, 0, 0.9],
            73: [0, 0.68611, 0, 0, 0.43611],
            74: [0, 0.68611, 0, 0, 0.59444],
            75: [0, 0.68611, 0, 0, 0.90138],
            76: [0, 0.68611, 0, 0, 0.69166],
            77: [0, 0.68611, 0, 0, 1.09166],
            78: [0, 0.68611, 0, 0, 0.9],
            79: [0, 0.68611, 0, 0, 0.86388],
            80: [0, 0.68611, 0, 0, 0.78611],
            81: [0.19444, 0.68611, 0, 0, 0.86388],
            82: [0, 0.68611, 0, 0, 0.8625],
            83: [0, 0.68611, 0, 0, 0.63889],
            84: [0, 0.68611, 0, 0, 0.8],
            85: [0, 0.68611, 0, 0, 0.88472],
            86: [0, 0.68611, 0.01597, 0, 0.86944],
            87: [0, 0.68611, 0.01597, 0, 1.18888],
            88: [0, 0.68611, 0, 0, 0.86944],
            89: [0, 0.68611, 0.02875, 0, 0.86944],
            90: [0, 0.68611, 0, 0, 0.70277],
            91: [0.25, 0.75, 0, 0, 0.31944],
            92: [0.25, 0.75, 0, 0, 0.575],
            93: [0.25, 0.75, 0, 0, 0.31944],
            94: [0, 0.69444, 0, 0, 0.575],
            95: [0.31, 0.13444, 0.03194, 0, 0.575],
            97: [0, 0.44444, 0, 0, 0.55902],
            98: [0, 0.69444, 0, 0, 0.63889],
            99: [0, 0.44444, 0, 0, 0.51111],
            100: [0, 0.69444, 0, 0, 0.63889],
            101: [0, 0.44444, 0, 0, 0.52708],
            102: [0, 0.69444, 0.10903, 0, 0.35139],
            103: [0.19444, 0.44444, 0.01597, 0, 0.575],
            104: [0, 0.69444, 0, 0, 0.63889],
            105: [0, 0.69444, 0, 0, 0.31944],
            106: [0.19444, 0.69444, 0, 0, 0.35139],
            107: [0, 0.69444, 0, 0, 0.60694],
            108: [0, 0.69444, 0, 0, 0.31944],
            109: [0, 0.44444, 0, 0, 0.95833],
            110: [0, 0.44444, 0, 0, 0.63889],
            111: [0, 0.44444, 0, 0, 0.575],
            112: [0.19444, 0.44444, 0, 0, 0.63889],
            113: [0.19444, 0.44444, 0, 0, 0.60694],
            114: [0, 0.44444, 0, 0, 0.47361],
            115: [0, 0.44444, 0, 0, 0.45361],
            116: [0, 0.63492, 0, 0, 0.44722],
            117: [0, 0.44444, 0, 0, 0.63889],
            118: [0, 0.44444, 0.01597, 0, 0.60694],
            119: [0, 0.44444, 0.01597, 0, 0.83055],
            120: [0, 0.44444, 0, 0, 0.60694],
            121: [0.19444, 0.44444, 0.01597, 0, 0.60694],
            122: [0, 0.44444, 0, 0, 0.51111],
            123: [0.25, 0.75, 0, 0, 0.575],
            124: [0.25, 0.75, 0, 0, 0.31944],
            125: [0.25, 0.75, 0, 0, 0.575],
            126: [0.35, 0.34444, 0, 0, 0.575],
            160: [0, 0, 0, 0, 0.25],
            163: [0, 0.69444, 0, 0, 0.86853],
            168: [0, 0.69444, 0, 0, 0.575],
            172: [0, 0.44444, 0, 0, 0.76666],
            176: [0, 0.69444, 0, 0, 0.86944],
            177: [0.13333, 0.63333, 0, 0, 0.89444],
            184: [0.17014, 0, 0, 0, 0.51111],
            198: [0, 0.68611, 0, 0, 1.04166],
            215: [0.13333, 0.63333, 0, 0, 0.89444],
            216: [0.04861, 0.73472, 0, 0, 0.89444],
            223: [0, 0.69444, 0, 0, 0.59722],
            230: [0, 0.44444, 0, 0, 0.83055],
            247: [0.13333, 0.63333, 0, 0, 0.89444],
            248: [0.09722, 0.54167, 0, 0, 0.575],
            305: [0, 0.44444, 0, 0, 0.31944],
            338: [0, 0.68611, 0, 0, 1.16944],
            339: [0, 0.44444, 0, 0, 0.89444],
            567: [0.19444, 0.44444, 0, 0, 0.35139],
            710: [0, 0.69444, 0, 0, 0.575],
            711: [0, 0.63194, 0, 0, 0.575],
            713: [0, 0.59611, 0, 0, 0.575],
            714: [0, 0.69444, 0, 0, 0.575],
            715: [0, 0.69444, 0, 0, 0.575],
            728: [0, 0.69444, 0, 0, 0.575],
            729: [0, 0.69444, 0, 0, 0.31944],
            730: [0, 0.69444, 0, 0, 0.86944],
            732: [0, 0.69444, 0, 0, 0.575],
            733: [0, 0.69444, 0, 0, 0.575],
            915: [0, 0.68611, 0, 0, 0.69166],
            916: [0, 0.68611, 0, 0, 0.95833],
            920: [0, 0.68611, 0, 0, 0.89444],
            923: [0, 0.68611, 0, 0, 0.80555],
            926: [0, 0.68611, 0, 0, 0.76666],
            928: [0, 0.68611, 0, 0, 0.9],
            931: [0, 0.68611, 0, 0, 0.83055],
            933: [0, 0.68611, 0, 0, 0.89444],
            934: [0, 0.68611, 0, 0, 0.83055],
            936: [0, 0.68611, 0, 0, 0.89444],
            937: [0, 0.68611, 0, 0, 0.83055],
            8211: [0, 0.44444, 0.03194, 0, 0.575],
            8212: [0, 0.44444, 0.03194, 0, 1.14999],
            8216: [0, 0.69444, 0, 0, 0.31944],
            8217: [0, 0.69444, 0, 0, 0.31944],
            8220: [0, 0.69444, 0, 0, 0.60278],
            8221: [0, 0.69444, 0, 0, 0.60278],
            8224: [0.19444, 0.69444, 0, 0, 0.51111],
            8225: [0.19444, 0.69444, 0, 0, 0.51111],
            8242: [0, 0.55556, 0, 0, 0.34444],
            8407: [0, 0.72444, 0.15486, 0, 0.575],
            8463: [0, 0.69444, 0, 0, 0.66759],
            8465: [0, 0.69444, 0, 0, 0.83055],
            8467: [0, 0.69444, 0, 0, 0.47361],
            8472: [0.19444, 0.44444, 0, 0, 0.74027],
            8476: [0, 0.69444, 0, 0, 0.83055],
            8501: [0, 0.69444, 0, 0, 0.70277],
            8592: [-0.10889, 0.39111, 0, 0, 1.14999],
            8593: [0.19444, 0.69444, 0, 0, 0.575],
            8594: [-0.10889, 0.39111, 0, 0, 1.14999],
            8595: [0.19444, 0.69444, 0, 0, 0.575],
            8596: [-0.10889, 0.39111, 0, 0, 1.14999],
            8597: [0.25, 0.75, 0, 0, 0.575],
            8598: [0.19444, 0.69444, 0, 0, 1.14999],
            8599: [0.19444, 0.69444, 0, 0, 1.14999],
            8600: [0.19444, 0.69444, 0, 0, 1.14999],
            8601: [0.19444, 0.69444, 0, 0, 1.14999],
            8636: [-0.10889, 0.39111, 0, 0, 1.14999],
            8637: [-0.10889, 0.39111, 0, 0, 1.14999],
            8640: [-0.10889, 0.39111, 0, 0, 1.14999],
            8641: [-0.10889, 0.39111, 0, 0, 1.14999],
            8656: [-0.10889, 0.39111, 0, 0, 1.14999],
            8657: [0.19444, 0.69444, 0, 0, 0.70277],
            8658: [-0.10889, 0.39111, 0, 0, 1.14999],
            8659: [0.19444, 0.69444, 0, 0, 0.70277],
            8660: [-0.10889, 0.39111, 0, 0, 1.14999],
            8661: [0.25, 0.75, 0, 0, 0.70277],
            8704: [0, 0.69444, 0, 0, 0.63889],
            8706: [0, 0.69444, 0.06389, 0, 0.62847],
            8707: [0, 0.69444, 0, 0, 0.63889],
            8709: [0.05556, 0.75, 0, 0, 0.575],
            8711: [0, 0.68611, 0, 0, 0.95833],
            8712: [0.08556, 0.58556, 0, 0, 0.76666],
            8715: [0.08556, 0.58556, 0, 0, 0.76666],
            8722: [0.13333, 0.63333, 0, 0, 0.89444],
            8723: [0.13333, 0.63333, 0, 0, 0.89444],
            8725: [0.25, 0.75, 0, 0, 0.575],
            8726: [0.25, 0.75, 0, 0, 0.575],
            8727: [-0.02778, 0.47222, 0, 0, 0.575],
            8728: [-0.02639, 0.47361, 0, 0, 0.575],
            8729: [-0.02639, 0.47361, 0, 0, 0.575],
            8730: [0.18, 0.82, 0, 0, 0.95833],
            8733: [0, 0.44444, 0, 0, 0.89444],
            8734: [0, 0.44444, 0, 0, 1.14999],
            8736: [0, 0.69224, 0, 0, 0.72222],
            8739: [0.25, 0.75, 0, 0, 0.31944],
            8741: [0.25, 0.75, 0, 0, 0.575],
            8743: [0, 0.55556, 0, 0, 0.76666],
            8744: [0, 0.55556, 0, 0, 0.76666],
            8745: [0, 0.55556, 0, 0, 0.76666],
            8746: [0, 0.55556, 0, 0, 0.76666],
            8747: [0.19444, 0.69444, 0.12778, 0, 0.56875],
            8764: [-0.10889, 0.39111, 0, 0, 0.89444],
            8768: [0.19444, 0.69444, 0, 0, 0.31944],
            8771: [0.00222, 0.50222, 0, 0, 0.89444],
            8776: [0.02444, 0.52444, 0, 0, 0.89444],
            8781: [0.00222, 0.50222, 0, 0, 0.89444],
            8801: [0.00222, 0.50222, 0, 0, 0.89444],
            8804: [0.19667, 0.69667, 0, 0, 0.89444],
            8805: [0.19667, 0.69667, 0, 0, 0.89444],
            8810: [0.08556, 0.58556, 0, 0, 1.14999],
            8811: [0.08556, 0.58556, 0, 0, 1.14999],
            8826: [0.08556, 0.58556, 0, 0, 0.89444],
            8827: [0.08556, 0.58556, 0, 0, 0.89444],
            8834: [0.08556, 0.58556, 0, 0, 0.89444],
            8835: [0.08556, 0.58556, 0, 0, 0.89444],
            8838: [0.19667, 0.69667, 0, 0, 0.89444],
            8839: [0.19667, 0.69667, 0, 0, 0.89444],
            8846: [0, 0.55556, 0, 0, 0.76666],
            8849: [0.19667, 0.69667, 0, 0, 0.89444],
            8850: [0.19667, 0.69667, 0, 0, 0.89444],
            8851: [0, 0.55556, 0, 0, 0.76666],
            8852: [0, 0.55556, 0, 0, 0.76666],
            8853: [0.13333, 0.63333, 0, 0, 0.89444],
            8854: [0.13333, 0.63333, 0, 0, 0.89444],
            8855: [0.13333, 0.63333, 0, 0, 0.89444],
            8856: [0.13333, 0.63333, 0, 0, 0.89444],
            8857: [0.13333, 0.63333, 0, 0, 0.89444],
            8866: [0, 0.69444, 0, 0, 0.70277],
            8867: [0, 0.69444, 0, 0, 0.70277],
            8868: [0, 0.69444, 0, 0, 0.89444],
            8869: [0, 0.69444, 0, 0, 0.89444],
            8900: [-0.02639, 0.47361, 0, 0, 0.575],
            8901: [-0.02639, 0.47361, 0, 0, 0.31944],
            8902: [-0.02778, 0.47222, 0, 0, 0.575],
            8968: [0.25, 0.75, 0, 0, 0.51111],
            8969: [0.25, 0.75, 0, 0, 0.51111],
            8970: [0.25, 0.75, 0, 0, 0.51111],
            8971: [0.25, 0.75, 0, 0, 0.51111],
            8994: [-0.13889, 0.36111, 0, 0, 1.14999],
            8995: [-0.13889, 0.36111, 0, 0, 1.14999],
            9651: [0.19444, 0.69444, 0, 0, 1.02222],
            9657: [-0.02778, 0.47222, 0, 0, 0.575],
            9661: [0.19444, 0.69444, 0, 0, 1.02222],
            9667: [-0.02778, 0.47222, 0, 0, 0.575],
            9711: [0.19444, 0.69444, 0, 0, 1.14999],
            9824: [0.12963, 0.69444, 0, 0, 0.89444],
            9825: [0.12963, 0.69444, 0, 0, 0.89444],
            9826: [0.12963, 0.69444, 0, 0, 0.89444],
            9827: [0.12963, 0.69444, 0, 0, 0.89444],
            9837: [0, 0.75, 0, 0, 0.44722],
            9838: [0.19444, 0.69444, 0, 0, 0.44722],
            9839: [0.19444, 0.69444, 0, 0, 0.44722],
            10216: [0.25, 0.75, 0, 0, 0.44722],
            10217: [0.25, 0.75, 0, 0, 0.44722],
            10815: [0, 0.68611, 0, 0, 0.9],
            10927: [0.19667, 0.69667, 0, 0, 0.89444],
            10928: [0.19667, 0.69667, 0, 0, 0.89444],
            57376: [0.19444, 0.69444, 0, 0, 0],
          },
          "Main-BoldItalic": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69444, 0.11417, 0, 0.38611],
            34: [0, 0.69444, 0.07939, 0, 0.62055],
            35: [0.19444, 0.69444, 0.06833, 0, 0.94444],
            37: [0.05556, 0.75, 0.12861, 0, 0.94444],
            38: [0, 0.69444, 0.08528, 0, 0.88555],
            39: [0, 0.69444, 0.12945, 0, 0.35555],
            40: [0.25, 0.75, 0.15806, 0, 0.47333],
            41: [0.25, 0.75, 0.03306, 0, 0.47333],
            42: [0, 0.75, 0.14333, 0, 0.59111],
            43: [0.10333, 0.60333, 0.03306, 0, 0.88555],
            44: [0.19444, 0.14722, 0, 0, 0.35555],
            45: [0, 0.44444, 0.02611, 0, 0.41444],
            46: [0, 0.14722, 0, 0, 0.35555],
            47: [0.25, 0.75, 0.15806, 0, 0.59111],
            48: [0, 0.64444, 0.13167, 0, 0.59111],
            49: [0, 0.64444, 0.13167, 0, 0.59111],
            50: [0, 0.64444, 0.13167, 0, 0.59111],
            51: [0, 0.64444, 0.13167, 0, 0.59111],
            52: [0.19444, 0.64444, 0.13167, 0, 0.59111],
            53: [0, 0.64444, 0.13167, 0, 0.59111],
            54: [0, 0.64444, 0.13167, 0, 0.59111],
            55: [0.19444, 0.64444, 0.13167, 0, 0.59111],
            56: [0, 0.64444, 0.13167, 0, 0.59111],
            57: [0, 0.64444, 0.13167, 0, 0.59111],
            58: [0, 0.44444, 0.06695, 0, 0.35555],
            59: [0.19444, 0.44444, 0.06695, 0, 0.35555],
            61: [-0.10889, 0.39111, 0.06833, 0, 0.88555],
            63: [0, 0.69444, 0.11472, 0, 0.59111],
            64: [0, 0.69444, 0.09208, 0, 0.88555],
            65: [0, 0.68611, 0, 0, 0.86555],
            66: [0, 0.68611, 0.0992, 0, 0.81666],
            67: [0, 0.68611, 0.14208, 0, 0.82666],
            68: [0, 0.68611, 0.09062, 0, 0.87555],
            69: [0, 0.68611, 0.11431, 0, 0.75666],
            70: [0, 0.68611, 0.12903, 0, 0.72722],
            71: [0, 0.68611, 0.07347, 0, 0.89527],
            72: [0, 0.68611, 0.17208, 0, 0.8961],
            73: [0, 0.68611, 0.15681, 0, 0.47166],
            74: [0, 0.68611, 0.145, 0, 0.61055],
            75: [0, 0.68611, 0.14208, 0, 0.89499],
            76: [0, 0.68611, 0, 0, 0.69777],
            77: [0, 0.68611, 0.17208, 0, 1.07277],
            78: [0, 0.68611, 0.17208, 0, 0.8961],
            79: [0, 0.68611, 0.09062, 0, 0.85499],
            80: [0, 0.68611, 0.0992, 0, 0.78721],
            81: [0.19444, 0.68611, 0.09062, 0, 0.85499],
            82: [0, 0.68611, 0.02559, 0, 0.85944],
            83: [0, 0.68611, 0.11264, 0, 0.64999],
            84: [0, 0.68611, 0.12903, 0, 0.7961],
            85: [0, 0.68611, 0.17208, 0, 0.88083],
            86: [0, 0.68611, 0.18625, 0, 0.86555],
            87: [0, 0.68611, 0.18625, 0, 1.15999],
            88: [0, 0.68611, 0.15681, 0, 0.86555],
            89: [0, 0.68611, 0.19803, 0, 0.86555],
            90: [0, 0.68611, 0.14208, 0, 0.70888],
            91: [0.25, 0.75, 0.1875, 0, 0.35611],
            93: [0.25, 0.75, 0.09972, 0, 0.35611],
            94: [0, 0.69444, 0.06709, 0, 0.59111],
            95: [0.31, 0.13444, 0.09811, 0, 0.59111],
            97: [0, 0.44444, 0.09426, 0, 0.59111],
            98: [0, 0.69444, 0.07861, 0, 0.53222],
            99: [0, 0.44444, 0.05222, 0, 0.53222],
            100: [0, 0.69444, 0.10861, 0, 0.59111],
            101: [0, 0.44444, 0.085, 0, 0.53222],
            102: [0.19444, 0.69444, 0.21778, 0, 0.4],
            103: [0.19444, 0.44444, 0.105, 0, 0.53222],
            104: [0, 0.69444, 0.09426, 0, 0.59111],
            105: [0, 0.69326, 0.11387, 0, 0.35555],
            106: [0.19444, 0.69326, 0.1672, 0, 0.35555],
            107: [0, 0.69444, 0.11111, 0, 0.53222],
            108: [0, 0.69444, 0.10861, 0, 0.29666],
            109: [0, 0.44444, 0.09426, 0, 0.94444],
            110: [0, 0.44444, 0.09426, 0, 0.64999],
            111: [0, 0.44444, 0.07861, 0, 0.59111],
            112: [0.19444, 0.44444, 0.07861, 0, 0.59111],
            113: [0.19444, 0.44444, 0.105, 0, 0.53222],
            114: [0, 0.44444, 0.11111, 0, 0.50167],
            115: [0, 0.44444, 0.08167, 0, 0.48694],
            116: [0, 0.63492, 0.09639, 0, 0.385],
            117: [0, 0.44444, 0.09426, 0, 0.62055],
            118: [0, 0.44444, 0.11111, 0, 0.53222],
            119: [0, 0.44444, 0.11111, 0, 0.76777],
            120: [0, 0.44444, 0.12583, 0, 0.56055],
            121: [0.19444, 0.44444, 0.105, 0, 0.56166],
            122: [0, 0.44444, 0.13889, 0, 0.49055],
            126: [0.35, 0.34444, 0.11472, 0, 0.59111],
            160: [0, 0, 0, 0, 0.25],
            168: [0, 0.69444, 0.11473, 0, 0.59111],
            176: [0, 0.69444, 0, 0, 0.94888],
            184: [0.17014, 0, 0, 0, 0.53222],
            198: [0, 0.68611, 0.11431, 0, 1.02277],
            216: [0.04861, 0.73472, 0.09062, 0, 0.88555],
            223: [0.19444, 0.69444, 0.09736, 0, 0.665],
            230: [0, 0.44444, 0.085, 0, 0.82666],
            248: [0.09722, 0.54167, 0.09458, 0, 0.59111],
            305: [0, 0.44444, 0.09426, 0, 0.35555],
            338: [0, 0.68611, 0.11431, 0, 1.14054],
            339: [0, 0.44444, 0.085, 0, 0.82666],
            567: [0.19444, 0.44444, 0.04611, 0, 0.385],
            710: [0, 0.69444, 0.06709, 0, 0.59111],
            711: [0, 0.63194, 0.08271, 0, 0.59111],
            713: [0, 0.59444, 0.10444, 0, 0.59111],
            714: [0, 0.69444, 0.08528, 0, 0.59111],
            715: [0, 0.69444, 0, 0, 0.59111],
            728: [0, 0.69444, 0.10333, 0, 0.59111],
            729: [0, 0.69444, 0.12945, 0, 0.35555],
            730: [0, 0.69444, 0, 0, 0.94888],
            732: [0, 0.69444, 0.11472, 0, 0.59111],
            733: [0, 0.69444, 0.11472, 0, 0.59111],
            915: [0, 0.68611, 0.12903, 0, 0.69777],
            916: [0, 0.68611, 0, 0, 0.94444],
            920: [0, 0.68611, 0.09062, 0, 0.88555],
            923: [0, 0.68611, 0, 0, 0.80666],
            926: [0, 0.68611, 0.15092, 0, 0.76777],
            928: [0, 0.68611, 0.17208, 0, 0.8961],
            931: [0, 0.68611, 0.11431, 0, 0.82666],
            933: [0, 0.68611, 0.10778, 0, 0.88555],
            934: [0, 0.68611, 0.05632, 0, 0.82666],
            936: [0, 0.68611, 0.10778, 0, 0.88555],
            937: [0, 0.68611, 0.0992, 0, 0.82666],
            8211: [0, 0.44444, 0.09811, 0, 0.59111],
            8212: [0, 0.44444, 0.09811, 0, 1.18221],
            8216: [0, 0.69444, 0.12945, 0, 0.35555],
            8217: [0, 0.69444, 0.12945, 0, 0.35555],
            8220: [0, 0.69444, 0.16772, 0, 0.62055],
            8221: [0, 0.69444, 0.07939, 0, 0.62055],
          },
          "Main-Italic": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69444, 0.12417, 0, 0.30667],
            34: [0, 0.69444, 0.06961, 0, 0.51444],
            35: [0.19444, 0.69444, 0.06616, 0, 0.81777],
            37: [0.05556, 0.75, 0.13639, 0, 0.81777],
            38: [0, 0.69444, 0.09694, 0, 0.76666],
            39: [0, 0.69444, 0.12417, 0, 0.30667],
            40: [0.25, 0.75, 0.16194, 0, 0.40889],
            41: [0.25, 0.75, 0.03694, 0, 0.40889],
            42: [0, 0.75, 0.14917, 0, 0.51111],
            43: [0.05667, 0.56167, 0.03694, 0, 0.76666],
            44: [0.19444, 0.10556, 0, 0, 0.30667],
            45: [0, 0.43056, 0.02826, 0, 0.35778],
            46: [0, 0.10556, 0, 0, 0.30667],
            47: [0.25, 0.75, 0.16194, 0, 0.51111],
            48: [0, 0.64444, 0.13556, 0, 0.51111],
            49: [0, 0.64444, 0.13556, 0, 0.51111],
            50: [0, 0.64444, 0.13556, 0, 0.51111],
            51: [0, 0.64444, 0.13556, 0, 0.51111],
            52: [0.19444, 0.64444, 0.13556, 0, 0.51111],
            53: [0, 0.64444, 0.13556, 0, 0.51111],
            54: [0, 0.64444, 0.13556, 0, 0.51111],
            55: [0.19444, 0.64444, 0.13556, 0, 0.51111],
            56: [0, 0.64444, 0.13556, 0, 0.51111],
            57: [0, 0.64444, 0.13556, 0, 0.51111],
            58: [0, 0.43056, 0.0582, 0, 0.30667],
            59: [0.19444, 0.43056, 0.0582, 0, 0.30667],
            61: [-0.13313, 0.36687, 0.06616, 0, 0.76666],
            63: [0, 0.69444, 0.1225, 0, 0.51111],
            64: [0, 0.69444, 0.09597, 0, 0.76666],
            65: [0, 0.68333, 0, 0, 0.74333],
            66: [0, 0.68333, 0.10257, 0, 0.70389],
            67: [0, 0.68333, 0.14528, 0, 0.71555],
            68: [0, 0.68333, 0.09403, 0, 0.755],
            69: [0, 0.68333, 0.12028, 0, 0.67833],
            70: [0, 0.68333, 0.13305, 0, 0.65277],
            71: [0, 0.68333, 0.08722, 0, 0.77361],
            72: [0, 0.68333, 0.16389, 0, 0.74333],
            73: [0, 0.68333, 0.15806, 0, 0.38555],
            74: [0, 0.68333, 0.14028, 0, 0.525],
            75: [0, 0.68333, 0.14528, 0, 0.76888],
            76: [0, 0.68333, 0, 0, 0.62722],
            77: [0, 0.68333, 0.16389, 0, 0.89666],
            78: [0, 0.68333, 0.16389, 0, 0.74333],
            79: [0, 0.68333, 0.09403, 0, 0.76666],
            80: [0, 0.68333, 0.10257, 0, 0.67833],
            81: [0.19444, 0.68333, 0.09403, 0, 0.76666],
            82: [0, 0.68333, 0.03868, 0, 0.72944],
            83: [0, 0.68333, 0.11972, 0, 0.56222],
            84: [0, 0.68333, 0.13305, 0, 0.71555],
            85: [0, 0.68333, 0.16389, 0, 0.74333],
            86: [0, 0.68333, 0.18361, 0, 0.74333],
            87: [0, 0.68333, 0.18361, 0, 0.99888],
            88: [0, 0.68333, 0.15806, 0, 0.74333],
            89: [0, 0.68333, 0.19383, 0, 0.74333],
            90: [0, 0.68333, 0.14528, 0, 0.61333],
            91: [0.25, 0.75, 0.1875, 0, 0.30667],
            93: [0.25, 0.75, 0.10528, 0, 0.30667],
            94: [0, 0.69444, 0.06646, 0, 0.51111],
            95: [0.31, 0.12056, 0.09208, 0, 0.51111],
            97: [0, 0.43056, 0.07671, 0, 0.51111],
            98: [0, 0.69444, 0.06312, 0, 0.46],
            99: [0, 0.43056, 0.05653, 0, 0.46],
            100: [0, 0.69444, 0.10333, 0, 0.51111],
            101: [0, 0.43056, 0.07514, 0, 0.46],
            102: [0.19444, 0.69444, 0.21194, 0, 0.30667],
            103: [0.19444, 0.43056, 0.08847, 0, 0.46],
            104: [0, 0.69444, 0.07671, 0, 0.51111],
            105: [0, 0.65536, 0.1019, 0, 0.30667],
            106: [0.19444, 0.65536, 0.14467, 0, 0.30667],
            107: [0, 0.69444, 0.10764, 0, 0.46],
            108: [0, 0.69444, 0.10333, 0, 0.25555],
            109: [0, 0.43056, 0.07671, 0, 0.81777],
            110: [0, 0.43056, 0.07671, 0, 0.56222],
            111: [0, 0.43056, 0.06312, 0, 0.51111],
            112: [0.19444, 0.43056, 0.06312, 0, 0.51111],
            113: [0.19444, 0.43056, 0.08847, 0, 0.46],
            114: [0, 0.43056, 0.10764, 0, 0.42166],
            115: [0, 0.43056, 0.08208, 0, 0.40889],
            116: [0, 0.61508, 0.09486, 0, 0.33222],
            117: [0, 0.43056, 0.07671, 0, 0.53666],
            118: [0, 0.43056, 0.10764, 0, 0.46],
            119: [0, 0.43056, 0.10764, 0, 0.66444],
            120: [0, 0.43056, 0.12042, 0, 0.46389],
            121: [0.19444, 0.43056, 0.08847, 0, 0.48555],
            122: [0, 0.43056, 0.12292, 0, 0.40889],
            126: [0.35, 0.31786, 0.11585, 0, 0.51111],
            160: [0, 0, 0, 0, 0.25],
            168: [0, 0.66786, 0.10474, 0, 0.51111],
            176: [0, 0.69444, 0, 0, 0.83129],
            184: [0.17014, 0, 0, 0, 0.46],
            198: [0, 0.68333, 0.12028, 0, 0.88277],
            216: [0.04861, 0.73194, 0.09403, 0, 0.76666],
            223: [0.19444, 0.69444, 0.10514, 0, 0.53666],
            230: [0, 0.43056, 0.07514, 0, 0.71555],
            248: [0.09722, 0.52778, 0.09194, 0, 0.51111],
            338: [0, 0.68333, 0.12028, 0, 0.98499],
            339: [0, 0.43056, 0.07514, 0, 0.71555],
            710: [0, 0.69444, 0.06646, 0, 0.51111],
            711: [0, 0.62847, 0.08295, 0, 0.51111],
            713: [0, 0.56167, 0.10333, 0, 0.51111],
            714: [0, 0.69444, 0.09694, 0, 0.51111],
            715: [0, 0.69444, 0, 0, 0.51111],
            728: [0, 0.69444, 0.10806, 0, 0.51111],
            729: [0, 0.66786, 0.11752, 0, 0.30667],
            730: [0, 0.69444, 0, 0, 0.83129],
            732: [0, 0.66786, 0.11585, 0, 0.51111],
            733: [0, 0.69444, 0.1225, 0, 0.51111],
            915: [0, 0.68333, 0.13305, 0, 0.62722],
            916: [0, 0.68333, 0, 0, 0.81777],
            920: [0, 0.68333, 0.09403, 0, 0.76666],
            923: [0, 0.68333, 0, 0, 0.69222],
            926: [0, 0.68333, 0.15294, 0, 0.66444],
            928: [0, 0.68333, 0.16389, 0, 0.74333],
            931: [0, 0.68333, 0.12028, 0, 0.71555],
            933: [0, 0.68333, 0.11111, 0, 0.76666],
            934: [0, 0.68333, 0.05986, 0, 0.71555],
            936: [0, 0.68333, 0.11111, 0, 0.76666],
            937: [0, 0.68333, 0.10257, 0, 0.71555],
            8211: [0, 0.43056, 0.09208, 0, 0.51111],
            8212: [0, 0.43056, 0.09208, 0, 1.02222],
            8216: [0, 0.69444, 0.12417, 0, 0.30667],
            8217: [0, 0.69444, 0.12417, 0, 0.30667],
            8220: [0, 0.69444, 0.1685, 0, 0.51444],
            8221: [0, 0.69444, 0.06961, 0, 0.51444],
            8463: [0, 0.68889, 0, 0, 0.54028],
          },
          "Main-Regular": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69444, 0, 0, 0.27778],
            34: [0, 0.69444, 0, 0, 0.5],
            35: [0.19444, 0.69444, 0, 0, 0.83334],
            36: [0.05556, 0.75, 0, 0, 0.5],
            37: [0.05556, 0.75, 0, 0, 0.83334],
            38: [0, 0.69444, 0, 0, 0.77778],
            39: [0, 0.69444, 0, 0, 0.27778],
            40: [0.25, 0.75, 0, 0, 0.38889],
            41: [0.25, 0.75, 0, 0, 0.38889],
            42: [0, 0.75, 0, 0, 0.5],
            43: [0.08333, 0.58333, 0, 0, 0.77778],
            44: [0.19444, 0.10556, 0, 0, 0.27778],
            45: [0, 0.43056, 0, 0, 0.33333],
            46: [0, 0.10556, 0, 0, 0.27778],
            47: [0.25, 0.75, 0, 0, 0.5],
            48: [0, 0.64444, 0, 0, 0.5],
            49: [0, 0.64444, 0, 0, 0.5],
            50: [0, 0.64444, 0, 0, 0.5],
            51: [0, 0.64444, 0, 0, 0.5],
            52: [0, 0.64444, 0, 0, 0.5],
            53: [0, 0.64444, 0, 0, 0.5],
            54: [0, 0.64444, 0, 0, 0.5],
            55: [0, 0.64444, 0, 0, 0.5],
            56: [0, 0.64444, 0, 0, 0.5],
            57: [0, 0.64444, 0, 0, 0.5],
            58: [0, 0.43056, 0, 0, 0.27778],
            59: [0.19444, 0.43056, 0, 0, 0.27778],
            60: [0.0391, 0.5391, 0, 0, 0.77778],
            61: [-0.13313, 0.36687, 0, 0, 0.77778],
            62: [0.0391, 0.5391, 0, 0, 0.77778],
            63: [0, 0.69444, 0, 0, 0.47222],
            64: [0, 0.69444, 0, 0, 0.77778],
            65: [0, 0.68333, 0, 0, 0.75],
            66: [0, 0.68333, 0, 0, 0.70834],
            67: [0, 0.68333, 0, 0, 0.72222],
            68: [0, 0.68333, 0, 0, 0.76389],
            69: [0, 0.68333, 0, 0, 0.68056],
            70: [0, 0.68333, 0, 0, 0.65278],
            71: [0, 0.68333, 0, 0, 0.78472],
            72: [0, 0.68333, 0, 0, 0.75],
            73: [0, 0.68333, 0, 0, 0.36111],
            74: [0, 0.68333, 0, 0, 0.51389],
            75: [0, 0.68333, 0, 0, 0.77778],
            76: [0, 0.68333, 0, 0, 0.625],
            77: [0, 0.68333, 0, 0, 0.91667],
            78: [0, 0.68333, 0, 0, 0.75],
            79: [0, 0.68333, 0, 0, 0.77778],
            80: [0, 0.68333, 0, 0, 0.68056],
            81: [0.19444, 0.68333, 0, 0, 0.77778],
            82: [0, 0.68333, 0, 0, 0.73611],
            83: [0, 0.68333, 0, 0, 0.55556],
            84: [0, 0.68333, 0, 0, 0.72222],
            85: [0, 0.68333, 0, 0, 0.75],
            86: [0, 0.68333, 0.01389, 0, 0.75],
            87: [0, 0.68333, 0.01389, 0, 1.02778],
            88: [0, 0.68333, 0, 0, 0.75],
            89: [0, 0.68333, 0.025, 0, 0.75],
            90: [0, 0.68333, 0, 0, 0.61111],
            91: [0.25, 0.75, 0, 0, 0.27778],
            92: [0.25, 0.75, 0, 0, 0.5],
            93: [0.25, 0.75, 0, 0, 0.27778],
            94: [0, 0.69444, 0, 0, 0.5],
            95: [0.31, 0.12056, 0.02778, 0, 0.5],
            97: [0, 0.43056, 0, 0, 0.5],
            98: [0, 0.69444, 0, 0, 0.55556],
            99: [0, 0.43056, 0, 0, 0.44445],
            100: [0, 0.69444, 0, 0, 0.55556],
            101: [0, 0.43056, 0, 0, 0.44445],
            102: [0, 0.69444, 0.07778, 0, 0.30556],
            103: [0.19444, 0.43056, 0.01389, 0, 0.5],
            104: [0, 0.69444, 0, 0, 0.55556],
            105: [0, 0.66786, 0, 0, 0.27778],
            106: [0.19444, 0.66786, 0, 0, 0.30556],
            107: [0, 0.69444, 0, 0, 0.52778],
            108: [0, 0.69444, 0, 0, 0.27778],
            109: [0, 0.43056, 0, 0, 0.83334],
            110: [0, 0.43056, 0, 0, 0.55556],
            111: [0, 0.43056, 0, 0, 0.5],
            112: [0.19444, 0.43056, 0, 0, 0.55556],
            113: [0.19444, 0.43056, 0, 0, 0.52778],
            114: [0, 0.43056, 0, 0, 0.39167],
            115: [0, 0.43056, 0, 0, 0.39445],
            116: [0, 0.61508, 0, 0, 0.38889],
            117: [0, 0.43056, 0, 0, 0.55556],
            118: [0, 0.43056, 0.01389, 0, 0.52778],
            119: [0, 0.43056, 0.01389, 0, 0.72222],
            120: [0, 0.43056, 0, 0, 0.52778],
            121: [0.19444, 0.43056, 0.01389, 0, 0.52778],
            122: [0, 0.43056, 0, 0, 0.44445],
            123: [0.25, 0.75, 0, 0, 0.5],
            124: [0.25, 0.75, 0, 0, 0.27778],
            125: [0.25, 0.75, 0, 0, 0.5],
            126: [0.35, 0.31786, 0, 0, 0.5],
            160: [0, 0, 0, 0, 0.25],
            163: [0, 0.69444, 0, 0, 0.76909],
            167: [0.19444, 0.69444, 0, 0, 0.44445],
            168: [0, 0.66786, 0, 0, 0.5],
            172: [0, 0.43056, 0, 0, 0.66667],
            176: [0, 0.69444, 0, 0, 0.75],
            177: [0.08333, 0.58333, 0, 0, 0.77778],
            182: [0.19444, 0.69444, 0, 0, 0.61111],
            184: [0.17014, 0, 0, 0, 0.44445],
            198: [0, 0.68333, 0, 0, 0.90278],
            215: [0.08333, 0.58333, 0, 0, 0.77778],
            216: [0.04861, 0.73194, 0, 0, 0.77778],
            223: [0, 0.69444, 0, 0, 0.5],
            230: [0, 0.43056, 0, 0, 0.72222],
            247: [0.08333, 0.58333, 0, 0, 0.77778],
            248: [0.09722, 0.52778, 0, 0, 0.5],
            305: [0, 0.43056, 0, 0, 0.27778],
            338: [0, 0.68333, 0, 0, 1.01389],
            339: [0, 0.43056, 0, 0, 0.77778],
            567: [0.19444, 0.43056, 0, 0, 0.30556],
            710: [0, 0.69444, 0, 0, 0.5],
            711: [0, 0.62847, 0, 0, 0.5],
            713: [0, 0.56778, 0, 0, 0.5],
            714: [0, 0.69444, 0, 0, 0.5],
            715: [0, 0.69444, 0, 0, 0.5],
            728: [0, 0.69444, 0, 0, 0.5],
            729: [0, 0.66786, 0, 0, 0.27778],
            730: [0, 0.69444, 0, 0, 0.75],
            732: [0, 0.66786, 0, 0, 0.5],
            733: [0, 0.69444, 0, 0, 0.5],
            915: [0, 0.68333, 0, 0, 0.625],
            916: [0, 0.68333, 0, 0, 0.83334],
            920: [0, 0.68333, 0, 0, 0.77778],
            923: [0, 0.68333, 0, 0, 0.69445],
            926: [0, 0.68333, 0, 0, 0.66667],
            928: [0, 0.68333, 0, 0, 0.75],
            931: [0, 0.68333, 0, 0, 0.72222],
            933: [0, 0.68333, 0, 0, 0.77778],
            934: [0, 0.68333, 0, 0, 0.72222],
            936: [0, 0.68333, 0, 0, 0.77778],
            937: [0, 0.68333, 0, 0, 0.72222],
            8211: [0, 0.43056, 0.02778, 0, 0.5],
            8212: [0, 0.43056, 0.02778, 0, 1],
            8216: [0, 0.69444, 0, 0, 0.27778],
            8217: [0, 0.69444, 0, 0, 0.27778],
            8220: [0, 0.69444, 0, 0, 0.5],
            8221: [0, 0.69444, 0, 0, 0.5],
            8224: [0.19444, 0.69444, 0, 0, 0.44445],
            8225: [0.19444, 0.69444, 0, 0, 0.44445],
            8230: [0, 0.12, 0, 0, 1.172],
            8242: [0, 0.55556, 0, 0, 0.275],
            8407: [0, 0.71444, 0.15382, 0, 0.5],
            8463: [0, 0.68889, 0, 0, 0.54028],
            8465: [0, 0.69444, 0, 0, 0.72222],
            8467: [0, 0.69444, 0, 0.11111, 0.41667],
            8472: [0.19444, 0.43056, 0, 0.11111, 0.63646],
            8476: [0, 0.69444, 0, 0, 0.72222],
            8501: [0, 0.69444, 0, 0, 0.61111],
            8592: [-0.13313, 0.36687, 0, 0, 1],
            8593: [0.19444, 0.69444, 0, 0, 0.5],
            8594: [-0.13313, 0.36687, 0, 0, 1],
            8595: [0.19444, 0.69444, 0, 0, 0.5],
            8596: [-0.13313, 0.36687, 0, 0, 1],
            8597: [0.25, 0.75, 0, 0, 0.5],
            8598: [0.19444, 0.69444, 0, 0, 1],
            8599: [0.19444, 0.69444, 0, 0, 1],
            8600: [0.19444, 0.69444, 0, 0, 1],
            8601: [0.19444, 0.69444, 0, 0, 1],
            8614: [0.011, 0.511, 0, 0, 1],
            8617: [0.011, 0.511, 0, 0, 1.126],
            8618: [0.011, 0.511, 0, 0, 1.126],
            8636: [-0.13313, 0.36687, 0, 0, 1],
            8637: [-0.13313, 0.36687, 0, 0, 1],
            8640: [-0.13313, 0.36687, 0, 0, 1],
            8641: [-0.13313, 0.36687, 0, 0, 1],
            8652: [0.011, 0.671, 0, 0, 1],
            8656: [-0.13313, 0.36687, 0, 0, 1],
            8657: [0.19444, 0.69444, 0, 0, 0.61111],
            8658: [-0.13313, 0.36687, 0, 0, 1],
            8659: [0.19444, 0.69444, 0, 0, 0.61111],
            8660: [-0.13313, 0.36687, 0, 0, 1],
            8661: [0.25, 0.75, 0, 0, 0.61111],
            8704: [0, 0.69444, 0, 0, 0.55556],
            8706: [0, 0.69444, 0.05556, 0.08334, 0.5309],
            8707: [0, 0.69444, 0, 0, 0.55556],
            8709: [0.05556, 0.75, 0, 0, 0.5],
            8711: [0, 0.68333, 0, 0, 0.83334],
            8712: [0.0391, 0.5391, 0, 0, 0.66667],
            8715: [0.0391, 0.5391, 0, 0, 0.66667],
            8722: [0.08333, 0.58333, 0, 0, 0.77778],
            8723: [0.08333, 0.58333, 0, 0, 0.77778],
            8725: [0.25, 0.75, 0, 0, 0.5],
            8726: [0.25, 0.75, 0, 0, 0.5],
            8727: [-0.03472, 0.46528, 0, 0, 0.5],
            8728: [-0.05555, 0.44445, 0, 0, 0.5],
            8729: [-0.05555, 0.44445, 0, 0, 0.5],
            8730: [0.2, 0.8, 0, 0, 0.83334],
            8733: [0, 0.43056, 0, 0, 0.77778],
            8734: [0, 0.43056, 0, 0, 1],
            8736: [0, 0.69224, 0, 0, 0.72222],
            8739: [0.25, 0.75, 0, 0, 0.27778],
            8741: [0.25, 0.75, 0, 0, 0.5],
            8743: [0, 0.55556, 0, 0, 0.66667],
            8744: [0, 0.55556, 0, 0, 0.66667],
            8745: [0, 0.55556, 0, 0, 0.66667],
            8746: [0, 0.55556, 0, 0, 0.66667],
            8747: [0.19444, 0.69444, 0.11111, 0, 0.41667],
            8764: [-0.13313, 0.36687, 0, 0, 0.77778],
            8768: [0.19444, 0.69444, 0, 0, 0.27778],
            8771: [-0.03625, 0.46375, 0, 0, 0.77778],
            8773: [-0.022, 0.589, 0, 0, 1],
            8776: [-0.01688, 0.48312, 0, 0, 0.77778],
            8781: [-0.03625, 0.46375, 0, 0, 0.77778],
            8784: [-0.133, 0.67, 0, 0, 0.778],
            8801: [-0.03625, 0.46375, 0, 0, 0.77778],
            8804: [0.13597, 0.63597, 0, 0, 0.77778],
            8805: [0.13597, 0.63597, 0, 0, 0.77778],
            8810: [0.0391, 0.5391, 0, 0, 1],
            8811: [0.0391, 0.5391, 0, 0, 1],
            8826: [0.0391, 0.5391, 0, 0, 0.77778],
            8827: [0.0391, 0.5391, 0, 0, 0.77778],
            8834: [0.0391, 0.5391, 0, 0, 0.77778],
            8835: [0.0391, 0.5391, 0, 0, 0.77778],
            8838: [0.13597, 0.63597, 0, 0, 0.77778],
            8839: [0.13597, 0.63597, 0, 0, 0.77778],
            8846: [0, 0.55556, 0, 0, 0.66667],
            8849: [0.13597, 0.63597, 0, 0, 0.77778],
            8850: [0.13597, 0.63597, 0, 0, 0.77778],
            8851: [0, 0.55556, 0, 0, 0.66667],
            8852: [0, 0.55556, 0, 0, 0.66667],
            8853: [0.08333, 0.58333, 0, 0, 0.77778],
            8854: [0.08333, 0.58333, 0, 0, 0.77778],
            8855: [0.08333, 0.58333, 0, 0, 0.77778],
            8856: [0.08333, 0.58333, 0, 0, 0.77778],
            8857: [0.08333, 0.58333, 0, 0, 0.77778],
            8866: [0, 0.69444, 0, 0, 0.61111],
            8867: [0, 0.69444, 0, 0, 0.61111],
            8868: [0, 0.69444, 0, 0, 0.77778],
            8869: [0, 0.69444, 0, 0, 0.77778],
            8872: [0.249, 0.75, 0, 0, 0.867],
            8900: [-0.05555, 0.44445, 0, 0, 0.5],
            8901: [-0.05555, 0.44445, 0, 0, 0.27778],
            8902: [-0.03472, 0.46528, 0, 0, 0.5],
            8904: [0.005, 0.505, 0, 0, 0.9],
            8942: [0.03, 0.9, 0, 0, 0.278],
            8943: [-0.19, 0.31, 0, 0, 1.172],
            8945: [-0.1, 0.82, 0, 0, 1.282],
            8968: [0.25, 0.75, 0, 0, 0.44445],
            8969: [0.25, 0.75, 0, 0, 0.44445],
            8970: [0.25, 0.75, 0, 0, 0.44445],
            8971: [0.25, 0.75, 0, 0, 0.44445],
            8994: [-0.14236, 0.35764, 0, 0, 1],
            8995: [-0.14236, 0.35764, 0, 0, 1],
            9136: [0.244, 0.744, 0, 0, 0.412],
            9137: [0.244, 0.744, 0, 0, 0.412],
            9651: [0.19444, 0.69444, 0, 0, 0.88889],
            9657: [-0.03472, 0.46528, 0, 0, 0.5],
            9661: [0.19444, 0.69444, 0, 0, 0.88889],
            9667: [-0.03472, 0.46528, 0, 0, 0.5],
            9711: [0.19444, 0.69444, 0, 0, 1],
            9824: [0.12963, 0.69444, 0, 0, 0.77778],
            9825: [0.12963, 0.69444, 0, 0, 0.77778],
            9826: [0.12963, 0.69444, 0, 0, 0.77778],
            9827: [0.12963, 0.69444, 0, 0, 0.77778],
            9837: [0, 0.75, 0, 0, 0.38889],
            9838: [0.19444, 0.69444, 0, 0, 0.38889],
            9839: [0.19444, 0.69444, 0, 0, 0.38889],
            10216: [0.25, 0.75, 0, 0, 0.38889],
            10217: [0.25, 0.75, 0, 0, 0.38889],
            10222: [0.244, 0.744, 0, 0, 0.412],
            10223: [0.244, 0.744, 0, 0, 0.412],
            10229: [0.011, 0.511, 0, 0, 1.609],
            10230: [0.011, 0.511, 0, 0, 1.638],
            10231: [0.011, 0.511, 0, 0, 1.859],
            10232: [0.024, 0.525, 0, 0, 1.609],
            10233: [0.024, 0.525, 0, 0, 1.638],
            10234: [0.024, 0.525, 0, 0, 1.858],
            10236: [0.011, 0.511, 0, 0, 1.638],
            10815: [0, 0.68333, 0, 0, 0.75],
            10927: [0.13597, 0.63597, 0, 0, 0.77778],
            10928: [0.13597, 0.63597, 0, 0, 0.77778],
            57376: [0.19444, 0.69444, 0, 0, 0],
          },
          "Math-BoldItalic": {
            32: [0, 0, 0, 0, 0.25],
            48: [0, 0.44444, 0, 0, 0.575],
            49: [0, 0.44444, 0, 0, 0.575],
            50: [0, 0.44444, 0, 0, 0.575],
            51: [0.19444, 0.44444, 0, 0, 0.575],
            52: [0.19444, 0.44444, 0, 0, 0.575],
            53: [0.19444, 0.44444, 0, 0, 0.575],
            54: [0, 0.64444, 0, 0, 0.575],
            55: [0.19444, 0.44444, 0, 0, 0.575],
            56: [0, 0.64444, 0, 0, 0.575],
            57: [0.19444, 0.44444, 0, 0, 0.575],
            65: [0, 0.68611, 0, 0, 0.86944],
            66: [0, 0.68611, 0.04835, 0, 0.8664],
            67: [0, 0.68611, 0.06979, 0, 0.81694],
            68: [0, 0.68611, 0.03194, 0, 0.93812],
            69: [0, 0.68611, 0.05451, 0, 0.81007],
            70: [0, 0.68611, 0.15972, 0, 0.68889],
            71: [0, 0.68611, 0, 0, 0.88673],
            72: [0, 0.68611, 0.08229, 0, 0.98229],
            73: [0, 0.68611, 0.07778, 0, 0.51111],
            74: [0, 0.68611, 0.10069, 0, 0.63125],
            75: [0, 0.68611, 0.06979, 0, 0.97118],
            76: [0, 0.68611, 0, 0, 0.75555],
            77: [0, 0.68611, 0.11424, 0, 1.14201],
            78: [0, 0.68611, 0.11424, 0, 0.95034],
            79: [0, 0.68611, 0.03194, 0, 0.83666],
            80: [0, 0.68611, 0.15972, 0, 0.72309],
            81: [0.19444, 0.68611, 0, 0, 0.86861],
            82: [0, 0.68611, 0.00421, 0, 0.87235],
            83: [0, 0.68611, 0.05382, 0, 0.69271],
            84: [0, 0.68611, 0.15972, 0, 0.63663],
            85: [0, 0.68611, 0.11424, 0, 0.80027],
            86: [0, 0.68611, 0.25555, 0, 0.67778],
            87: [0, 0.68611, 0.15972, 0, 1.09305],
            88: [0, 0.68611, 0.07778, 0, 0.94722],
            89: [0, 0.68611, 0.25555, 0, 0.67458],
            90: [0, 0.68611, 0.06979, 0, 0.77257],
            97: [0, 0.44444, 0, 0, 0.63287],
            98: [0, 0.69444, 0, 0, 0.52083],
            99: [0, 0.44444, 0, 0, 0.51342],
            100: [0, 0.69444, 0, 0, 0.60972],
            101: [0, 0.44444, 0, 0, 0.55361],
            102: [0.19444, 0.69444, 0.11042, 0, 0.56806],
            103: [0.19444, 0.44444, 0.03704, 0, 0.5449],
            104: [0, 0.69444, 0, 0, 0.66759],
            105: [0, 0.69326, 0, 0, 0.4048],
            106: [0.19444, 0.69326, 0.0622, 0, 0.47083],
            107: [0, 0.69444, 0.01852, 0, 0.6037],
            108: [0, 0.69444, 0.0088, 0, 0.34815],
            109: [0, 0.44444, 0, 0, 1.0324],
            110: [0, 0.44444, 0, 0, 0.71296],
            111: [0, 0.44444, 0, 0, 0.58472],
            112: [0.19444, 0.44444, 0, 0, 0.60092],
            113: [0.19444, 0.44444, 0.03704, 0, 0.54213],
            114: [0, 0.44444, 0.03194, 0, 0.5287],
            115: [0, 0.44444, 0, 0, 0.53125],
            116: [0, 0.63492, 0, 0, 0.41528],
            117: [0, 0.44444, 0, 0, 0.68102],
            118: [0, 0.44444, 0.03704, 0, 0.56666],
            119: [0, 0.44444, 0.02778, 0, 0.83148],
            120: [0, 0.44444, 0, 0, 0.65903],
            121: [0.19444, 0.44444, 0.03704, 0, 0.59028],
            122: [0, 0.44444, 0.04213, 0, 0.55509],
            160: [0, 0, 0, 0, 0.25],
            915: [0, 0.68611, 0.15972, 0, 0.65694],
            916: [0, 0.68611, 0, 0, 0.95833],
            920: [0, 0.68611, 0.03194, 0, 0.86722],
            923: [0, 0.68611, 0, 0, 0.80555],
            926: [0, 0.68611, 0.07458, 0, 0.84125],
            928: [0, 0.68611, 0.08229, 0, 0.98229],
            931: [0, 0.68611, 0.05451, 0, 0.88507],
            933: [0, 0.68611, 0.15972, 0, 0.67083],
            934: [0, 0.68611, 0, 0, 0.76666],
            936: [0, 0.68611, 0.11653, 0, 0.71402],
            937: [0, 0.68611, 0.04835, 0, 0.8789],
            945: [0, 0.44444, 0, 0, 0.76064],
            946: [0.19444, 0.69444, 0.03403, 0, 0.65972],
            947: [0.19444, 0.44444, 0.06389, 0, 0.59003],
            948: [0, 0.69444, 0.03819, 0, 0.52222],
            949: [0, 0.44444, 0, 0, 0.52882],
            950: [0.19444, 0.69444, 0.06215, 0, 0.50833],
            951: [0.19444, 0.44444, 0.03704, 0, 0.6],
            952: [0, 0.69444, 0.03194, 0, 0.5618],
            953: [0, 0.44444, 0, 0, 0.41204],
            954: [0, 0.44444, 0, 0, 0.66759],
            955: [0, 0.69444, 0, 0, 0.67083],
            956: [0.19444, 0.44444, 0, 0, 0.70787],
            957: [0, 0.44444, 0.06898, 0, 0.57685],
            958: [0.19444, 0.69444, 0.03021, 0, 0.50833],
            959: [0, 0.44444, 0, 0, 0.58472],
            960: [0, 0.44444, 0.03704, 0, 0.68241],
            961: [0.19444, 0.44444, 0, 0, 0.6118],
            962: [0.09722, 0.44444, 0.07917, 0, 0.42361],
            963: [0, 0.44444, 0.03704, 0, 0.68588],
            964: [0, 0.44444, 0.13472, 0, 0.52083],
            965: [0, 0.44444, 0.03704, 0, 0.63055],
            966: [0.19444, 0.44444, 0, 0, 0.74722],
            967: [0.19444, 0.44444, 0, 0, 0.71805],
            968: [0.19444, 0.69444, 0.03704, 0, 0.75833],
            969: [0, 0.44444, 0.03704, 0, 0.71782],
            977: [0, 0.69444, 0, 0, 0.69155],
            981: [0.19444, 0.69444, 0, 0, 0.7125],
            982: [0, 0.44444, 0.03194, 0, 0.975],
            1009: [0.19444, 0.44444, 0, 0, 0.6118],
            1013: [0, 0.44444, 0, 0, 0.48333],
            57649: [0, 0.44444, 0, 0, 0.39352],
            57911: [0.19444, 0.44444, 0, 0, 0.43889],
          },
          "Math-Italic": {
            32: [0, 0, 0, 0, 0.25],
            48: [0, 0.43056, 0, 0, 0.5],
            49: [0, 0.43056, 0, 0, 0.5],
            50: [0, 0.43056, 0, 0, 0.5],
            51: [0.19444, 0.43056, 0, 0, 0.5],
            52: [0.19444, 0.43056, 0, 0, 0.5],
            53: [0.19444, 0.43056, 0, 0, 0.5],
            54: [0, 0.64444, 0, 0, 0.5],
            55: [0.19444, 0.43056, 0, 0, 0.5],
            56: [0, 0.64444, 0, 0, 0.5],
            57: [0.19444, 0.43056, 0, 0, 0.5],
            65: [0, 0.68333, 0, 0.13889, 0.75],
            66: [0, 0.68333, 0.05017, 0.08334, 0.75851],
            67: [0, 0.68333, 0.07153, 0.08334, 0.71472],
            68: [0, 0.68333, 0.02778, 0.05556, 0.82792],
            69: [0, 0.68333, 0.05764, 0.08334, 0.7382],
            70: [0, 0.68333, 0.13889, 0.08334, 0.64306],
            71: [0, 0.68333, 0, 0.08334, 0.78625],
            72: [0, 0.68333, 0.08125, 0.05556, 0.83125],
            73: [0, 0.68333, 0.07847, 0.11111, 0.43958],
            74: [0, 0.68333, 0.09618, 0.16667, 0.55451],
            75: [0, 0.68333, 0.07153, 0.05556, 0.84931],
            76: [0, 0.68333, 0, 0.02778, 0.68056],
            77: [0, 0.68333, 0.10903, 0.08334, 0.97014],
            78: [0, 0.68333, 0.10903, 0.08334, 0.80347],
            79: [0, 0.68333, 0.02778, 0.08334, 0.76278],
            80: [0, 0.68333, 0.13889, 0.08334, 0.64201],
            81: [0.19444, 0.68333, 0, 0.08334, 0.79056],
            82: [0, 0.68333, 0.00773, 0.08334, 0.75929],
            83: [0, 0.68333, 0.05764, 0.08334, 0.6132],
            84: [0, 0.68333, 0.13889, 0.08334, 0.58438],
            85: [0, 0.68333, 0.10903, 0.02778, 0.68278],
            86: [0, 0.68333, 0.22222, 0, 0.58333],
            87: [0, 0.68333, 0.13889, 0, 0.94445],
            88: [0, 0.68333, 0.07847, 0.08334, 0.82847],
            89: [0, 0.68333, 0.22222, 0, 0.58056],
            90: [0, 0.68333, 0.07153, 0.08334, 0.68264],
            97: [0, 0.43056, 0, 0, 0.52859],
            98: [0, 0.69444, 0, 0, 0.42917],
            99: [0, 0.43056, 0, 0.05556, 0.43276],
            100: [0, 0.69444, 0, 0.16667, 0.52049],
            101: [0, 0.43056, 0, 0.05556, 0.46563],
            102: [0.19444, 0.69444, 0.10764, 0.16667, 0.48959],
            103: [0.19444, 0.43056, 0.03588, 0.02778, 0.47697],
            104: [0, 0.69444, 0, 0, 0.57616],
            105: [0, 0.65952, 0, 0, 0.34451],
            106: [0.19444, 0.65952, 0.05724, 0, 0.41181],
            107: [0, 0.69444, 0.03148, 0, 0.5206],
            108: [0, 0.69444, 0.01968, 0.08334, 0.29838],
            109: [0, 0.43056, 0, 0, 0.87801],
            110: [0, 0.43056, 0, 0, 0.60023],
            111: [0, 0.43056, 0, 0.05556, 0.48472],
            112: [0.19444, 0.43056, 0, 0.08334, 0.50313],
            113: [0.19444, 0.43056, 0.03588, 0.08334, 0.44641],
            114: [0, 0.43056, 0.02778, 0.05556, 0.45116],
            115: [0, 0.43056, 0, 0.05556, 0.46875],
            116: [0, 0.61508, 0, 0.08334, 0.36111],
            117: [0, 0.43056, 0, 0.02778, 0.57246],
            118: [0, 0.43056, 0.03588, 0.02778, 0.48472],
            119: [0, 0.43056, 0.02691, 0.08334, 0.71592],
            120: [0, 0.43056, 0, 0.02778, 0.57153],
            121: [0.19444, 0.43056, 0.03588, 0.05556, 0.49028],
            122: [0, 0.43056, 0.04398, 0.05556, 0.46505],
            160: [0, 0, 0, 0, 0.25],
            915: [0, 0.68333, 0.13889, 0.08334, 0.61528],
            916: [0, 0.68333, 0, 0.16667, 0.83334],
            920: [0, 0.68333, 0.02778, 0.08334, 0.76278],
            923: [0, 0.68333, 0, 0.16667, 0.69445],
            926: [0, 0.68333, 0.07569, 0.08334, 0.74236],
            928: [0, 0.68333, 0.08125, 0.05556, 0.83125],
            931: [0, 0.68333, 0.05764, 0.08334, 0.77986],
            933: [0, 0.68333, 0.13889, 0.05556, 0.58333],
            934: [0, 0.68333, 0, 0.08334, 0.66667],
            936: [0, 0.68333, 0.11, 0.05556, 0.61222],
            937: [0, 0.68333, 0.05017, 0.08334, 0.7724],
            945: [0, 0.43056, 0.0037, 0.02778, 0.6397],
            946: [0.19444, 0.69444, 0.05278, 0.08334, 0.56563],
            947: [0.19444, 0.43056, 0.05556, 0, 0.51773],
            948: [0, 0.69444, 0.03785, 0.05556, 0.44444],
            949: [0, 0.43056, 0, 0.08334, 0.46632],
            950: [0.19444, 0.69444, 0.07378, 0.08334, 0.4375],
            951: [0.19444, 0.43056, 0.03588, 0.05556, 0.49653],
            952: [0, 0.69444, 0.02778, 0.08334, 0.46944],
            953: [0, 0.43056, 0, 0.05556, 0.35394],
            954: [0, 0.43056, 0, 0, 0.57616],
            955: [0, 0.69444, 0, 0, 0.58334],
            956: [0.19444, 0.43056, 0, 0.02778, 0.60255],
            957: [0, 0.43056, 0.06366, 0.02778, 0.49398],
            958: [0.19444, 0.69444, 0.04601, 0.11111, 0.4375],
            959: [0, 0.43056, 0, 0.05556, 0.48472],
            960: [0, 0.43056, 0.03588, 0, 0.57003],
            961: [0.19444, 0.43056, 0, 0.08334, 0.51702],
            962: [0.09722, 0.43056, 0.07986, 0.08334, 0.36285],
            963: [0, 0.43056, 0.03588, 0, 0.57141],
            964: [0, 0.43056, 0.1132, 0.02778, 0.43715],
            965: [0, 0.43056, 0.03588, 0.02778, 0.54028],
            966: [0.19444, 0.43056, 0, 0.08334, 0.65417],
            967: [0.19444, 0.43056, 0, 0.05556, 0.62569],
            968: [0.19444, 0.69444, 0.03588, 0.11111, 0.65139],
            969: [0, 0.43056, 0.03588, 0, 0.62245],
            977: [0, 0.69444, 0, 0.08334, 0.59144],
            981: [0.19444, 0.69444, 0, 0.08334, 0.59583],
            982: [0, 0.43056, 0.02778, 0, 0.82813],
            1009: [0.19444, 0.43056, 0, 0.08334, 0.51702],
            1013: [0, 0.43056, 0, 0.05556, 0.4059],
            57649: [0, 0.43056, 0, 0.02778, 0.32246],
            57911: [0.19444, 0.43056, 0, 0.08334, 0.38403],
          },
          "SansSerif-Bold": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69444, 0, 0, 0.36667],
            34: [0, 0.69444, 0, 0, 0.55834],
            35: [0.19444, 0.69444, 0, 0, 0.91667],
            36: [0.05556, 0.75, 0, 0, 0.55],
            37: [0.05556, 0.75, 0, 0, 1.02912],
            38: [0, 0.69444, 0, 0, 0.83056],
            39: [0, 0.69444, 0, 0, 0.30556],
            40: [0.25, 0.75, 0, 0, 0.42778],
            41: [0.25, 0.75, 0, 0, 0.42778],
            42: [0, 0.75, 0, 0, 0.55],
            43: [0.11667, 0.61667, 0, 0, 0.85556],
            44: [0.10556, 0.13056, 0, 0, 0.30556],
            45: [0, 0.45833, 0, 0, 0.36667],
            46: [0, 0.13056, 0, 0, 0.30556],
            47: [0.25, 0.75, 0, 0, 0.55],
            48: [0, 0.69444, 0, 0, 0.55],
            49: [0, 0.69444, 0, 0, 0.55],
            50: [0, 0.69444, 0, 0, 0.55],
            51: [0, 0.69444, 0, 0, 0.55],
            52: [0, 0.69444, 0, 0, 0.55],
            53: [0, 0.69444, 0, 0, 0.55],
            54: [0, 0.69444, 0, 0, 0.55],
            55: [0, 0.69444, 0, 0, 0.55],
            56: [0, 0.69444, 0, 0, 0.55],
            57: [0, 0.69444, 0, 0, 0.55],
            58: [0, 0.45833, 0, 0, 0.30556],
            59: [0.10556, 0.45833, 0, 0, 0.30556],
            61: [-0.09375, 0.40625, 0, 0, 0.85556],
            63: [0, 0.69444, 0, 0, 0.51945],
            64: [0, 0.69444, 0, 0, 0.73334],
            65: [0, 0.69444, 0, 0, 0.73334],
            66: [0, 0.69444, 0, 0, 0.73334],
            67: [0, 0.69444, 0, 0, 0.70278],
            68: [0, 0.69444, 0, 0, 0.79445],
            69: [0, 0.69444, 0, 0, 0.64167],
            70: [0, 0.69444, 0, 0, 0.61111],
            71: [0, 0.69444, 0, 0, 0.73334],
            72: [0, 0.69444, 0, 0, 0.79445],
            73: [0, 0.69444, 0, 0, 0.33056],
            74: [0, 0.69444, 0, 0, 0.51945],
            75: [0, 0.69444, 0, 0, 0.76389],
            76: [0, 0.69444, 0, 0, 0.58056],
            77: [0, 0.69444, 0, 0, 0.97778],
            78: [0, 0.69444, 0, 0, 0.79445],
            79: [0, 0.69444, 0, 0, 0.79445],
            80: [0, 0.69444, 0, 0, 0.70278],
            81: [0.10556, 0.69444, 0, 0, 0.79445],
            82: [0, 0.69444, 0, 0, 0.70278],
            83: [0, 0.69444, 0, 0, 0.61111],
            84: [0, 0.69444, 0, 0, 0.73334],
            85: [0, 0.69444, 0, 0, 0.76389],
            86: [0, 0.69444, 0.01528, 0, 0.73334],
            87: [0, 0.69444, 0.01528, 0, 1.03889],
            88: [0, 0.69444, 0, 0, 0.73334],
            89: [0, 0.69444, 0.0275, 0, 0.73334],
            90: [0, 0.69444, 0, 0, 0.67223],
            91: [0.25, 0.75, 0, 0, 0.34306],
            93: [0.25, 0.75, 0, 0, 0.34306],
            94: [0, 0.69444, 0, 0, 0.55],
            95: [0.35, 0.10833, 0.03056, 0, 0.55],
            97: [0, 0.45833, 0, 0, 0.525],
            98: [0, 0.69444, 0, 0, 0.56111],
            99: [0, 0.45833, 0, 0, 0.48889],
            100: [0, 0.69444, 0, 0, 0.56111],
            101: [0, 0.45833, 0, 0, 0.51111],
            102: [0, 0.69444, 0.07639, 0, 0.33611],
            103: [0.19444, 0.45833, 0.01528, 0, 0.55],
            104: [0, 0.69444, 0, 0, 0.56111],
            105: [0, 0.69444, 0, 0, 0.25556],
            106: [0.19444, 0.69444, 0, 0, 0.28611],
            107: [0, 0.69444, 0, 0, 0.53056],
            108: [0, 0.69444, 0, 0, 0.25556],
            109: [0, 0.45833, 0, 0, 0.86667],
            110: [0, 0.45833, 0, 0, 0.56111],
            111: [0, 0.45833, 0, 0, 0.55],
            112: [0.19444, 0.45833, 0, 0, 0.56111],
            113: [0.19444, 0.45833, 0, 0, 0.56111],
            114: [0, 0.45833, 0.01528, 0, 0.37222],
            115: [0, 0.45833, 0, 0, 0.42167],
            116: [0, 0.58929, 0, 0, 0.40417],
            117: [0, 0.45833, 0, 0, 0.56111],
            118: [0, 0.45833, 0.01528, 0, 0.5],
            119: [0, 0.45833, 0.01528, 0, 0.74445],
            120: [0, 0.45833, 0, 0, 0.5],
            121: [0.19444, 0.45833, 0.01528, 0, 0.5],
            122: [0, 0.45833, 0, 0, 0.47639],
            126: [0.35, 0.34444, 0, 0, 0.55],
            160: [0, 0, 0, 0, 0.25],
            168: [0, 0.69444, 0, 0, 0.55],
            176: [0, 0.69444, 0, 0, 0.73334],
            180: [0, 0.69444, 0, 0, 0.55],
            184: [0.17014, 0, 0, 0, 0.48889],
            305: [0, 0.45833, 0, 0, 0.25556],
            567: [0.19444, 0.45833, 0, 0, 0.28611],
            710: [0, 0.69444, 0, 0, 0.55],
            711: [0, 0.63542, 0, 0, 0.55],
            713: [0, 0.63778, 0, 0, 0.55],
            728: [0, 0.69444, 0, 0, 0.55],
            729: [0, 0.69444, 0, 0, 0.30556],
            730: [0, 0.69444, 0, 0, 0.73334],
            732: [0, 0.69444, 0, 0, 0.55],
            733: [0, 0.69444, 0, 0, 0.55],
            915: [0, 0.69444, 0, 0, 0.58056],
            916: [0, 0.69444, 0, 0, 0.91667],
            920: [0, 0.69444, 0, 0, 0.85556],
            923: [0, 0.69444, 0, 0, 0.67223],
            926: [0, 0.69444, 0, 0, 0.73334],
            928: [0, 0.69444, 0, 0, 0.79445],
            931: [0, 0.69444, 0, 0, 0.79445],
            933: [0, 0.69444, 0, 0, 0.85556],
            934: [0, 0.69444, 0, 0, 0.79445],
            936: [0, 0.69444, 0, 0, 0.85556],
            937: [0, 0.69444, 0, 0, 0.79445],
            8211: [0, 0.45833, 0.03056, 0, 0.55],
            8212: [0, 0.45833, 0.03056, 0, 1.10001],
            8216: [0, 0.69444, 0, 0, 0.30556],
            8217: [0, 0.69444, 0, 0, 0.30556],
            8220: [0, 0.69444, 0, 0, 0.55834],
            8221: [0, 0.69444, 0, 0, 0.55834],
          },
          "SansSerif-Italic": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69444, 0.05733, 0, 0.31945],
            34: [0, 0.69444, 0.00316, 0, 0.5],
            35: [0.19444, 0.69444, 0.05087, 0, 0.83334],
            36: [0.05556, 0.75, 0.11156, 0, 0.5],
            37: [0.05556, 0.75, 0.03126, 0, 0.83334],
            38: [0, 0.69444, 0.03058, 0, 0.75834],
            39: [0, 0.69444, 0.07816, 0, 0.27778],
            40: [0.25, 0.75, 0.13164, 0, 0.38889],
            41: [0.25, 0.75, 0.02536, 0, 0.38889],
            42: [0, 0.75, 0.11775, 0, 0.5],
            43: [0.08333, 0.58333, 0.02536, 0, 0.77778],
            44: [0.125, 0.08333, 0, 0, 0.27778],
            45: [0, 0.44444, 0.01946, 0, 0.33333],
            46: [0, 0.08333, 0, 0, 0.27778],
            47: [0.25, 0.75, 0.13164, 0, 0.5],
            48: [0, 0.65556, 0.11156, 0, 0.5],
            49: [0, 0.65556, 0.11156, 0, 0.5],
            50: [0, 0.65556, 0.11156, 0, 0.5],
            51: [0, 0.65556, 0.11156, 0, 0.5],
            52: [0, 0.65556, 0.11156, 0, 0.5],
            53: [0, 0.65556, 0.11156, 0, 0.5],
            54: [0, 0.65556, 0.11156, 0, 0.5],
            55: [0, 0.65556, 0.11156, 0, 0.5],
            56: [0, 0.65556, 0.11156, 0, 0.5],
            57: [0, 0.65556, 0.11156, 0, 0.5],
            58: [0, 0.44444, 0.02502, 0, 0.27778],
            59: [0.125, 0.44444, 0.02502, 0, 0.27778],
            61: [-0.13, 0.37, 0.05087, 0, 0.77778],
            63: [0, 0.69444, 0.11809, 0, 0.47222],
            64: [0, 0.69444, 0.07555, 0, 0.66667],
            65: [0, 0.69444, 0, 0, 0.66667],
            66: [0, 0.69444, 0.08293, 0, 0.66667],
            67: [0, 0.69444, 0.11983, 0, 0.63889],
            68: [0, 0.69444, 0.07555, 0, 0.72223],
            69: [0, 0.69444, 0.11983, 0, 0.59722],
            70: [0, 0.69444, 0.13372, 0, 0.56945],
            71: [0, 0.69444, 0.11983, 0, 0.66667],
            72: [0, 0.69444, 0.08094, 0, 0.70834],
            73: [0, 0.69444, 0.13372, 0, 0.27778],
            74: [0, 0.69444, 0.08094, 0, 0.47222],
            75: [0, 0.69444, 0.11983, 0, 0.69445],
            76: [0, 0.69444, 0, 0, 0.54167],
            77: [0, 0.69444, 0.08094, 0, 0.875],
            78: [0, 0.69444, 0.08094, 0, 0.70834],
            79: [0, 0.69444, 0.07555, 0, 0.73611],
            80: [0, 0.69444, 0.08293, 0, 0.63889],
            81: [0.125, 0.69444, 0.07555, 0, 0.73611],
            82: [0, 0.69444, 0.08293, 0, 0.64584],
            83: [0, 0.69444, 0.09205, 0, 0.55556],
            84: [0, 0.69444, 0.13372, 0, 0.68056],
            85: [0, 0.69444, 0.08094, 0, 0.6875],
            86: [0, 0.69444, 0.1615, 0, 0.66667],
            87: [0, 0.69444, 0.1615, 0, 0.94445],
            88: [0, 0.69444, 0.13372, 0, 0.66667],
            89: [0, 0.69444, 0.17261, 0, 0.66667],
            90: [0, 0.69444, 0.11983, 0, 0.61111],
            91: [0.25, 0.75, 0.15942, 0, 0.28889],
            93: [0.25, 0.75, 0.08719, 0, 0.28889],
            94: [0, 0.69444, 0.0799, 0, 0.5],
            95: [0.35, 0.09444, 0.08616, 0, 0.5],
            97: [0, 0.44444, 0.00981, 0, 0.48056],
            98: [0, 0.69444, 0.03057, 0, 0.51667],
            99: [0, 0.44444, 0.08336, 0, 0.44445],
            100: [0, 0.69444, 0.09483, 0, 0.51667],
            101: [0, 0.44444, 0.06778, 0, 0.44445],
            102: [0, 0.69444, 0.21705, 0, 0.30556],
            103: [0.19444, 0.44444, 0.10836, 0, 0.5],
            104: [0, 0.69444, 0.01778, 0, 0.51667],
            105: [0, 0.67937, 0.09718, 0, 0.23889],
            106: [0.19444, 0.67937, 0.09162, 0, 0.26667],
            107: [0, 0.69444, 0.08336, 0, 0.48889],
            108: [0, 0.69444, 0.09483, 0, 0.23889],
            109: [0, 0.44444, 0.01778, 0, 0.79445],
            110: [0, 0.44444, 0.01778, 0, 0.51667],
            111: [0, 0.44444, 0.06613, 0, 0.5],
            112: [0.19444, 0.44444, 0.0389, 0, 0.51667],
            113: [0.19444, 0.44444, 0.04169, 0, 0.51667],
            114: [0, 0.44444, 0.10836, 0, 0.34167],
            115: [0, 0.44444, 0.0778, 0, 0.38333],
            116: [0, 0.57143, 0.07225, 0, 0.36111],
            117: [0, 0.44444, 0.04169, 0, 0.51667],
            118: [0, 0.44444, 0.10836, 0, 0.46111],
            119: [0, 0.44444, 0.10836, 0, 0.68334],
            120: [0, 0.44444, 0.09169, 0, 0.46111],
            121: [0.19444, 0.44444, 0.10836, 0, 0.46111],
            122: [0, 0.44444, 0.08752, 0, 0.43472],
            126: [0.35, 0.32659, 0.08826, 0, 0.5],
            160: [0, 0, 0, 0, 0.25],
            168: [0, 0.67937, 0.06385, 0, 0.5],
            176: [0, 0.69444, 0, 0, 0.73752],
            184: [0.17014, 0, 0, 0, 0.44445],
            305: [0, 0.44444, 0.04169, 0, 0.23889],
            567: [0.19444, 0.44444, 0.04169, 0, 0.26667],
            710: [0, 0.69444, 0.0799, 0, 0.5],
            711: [0, 0.63194, 0.08432, 0, 0.5],
            713: [0, 0.60889, 0.08776, 0, 0.5],
            714: [0, 0.69444, 0.09205, 0, 0.5],
            715: [0, 0.69444, 0, 0, 0.5],
            728: [0, 0.69444, 0.09483, 0, 0.5],
            729: [0, 0.67937, 0.07774, 0, 0.27778],
            730: [0, 0.69444, 0, 0, 0.73752],
            732: [0, 0.67659, 0.08826, 0, 0.5],
            733: [0, 0.69444, 0.09205, 0, 0.5],
            915: [0, 0.69444, 0.13372, 0, 0.54167],
            916: [0, 0.69444, 0, 0, 0.83334],
            920: [0, 0.69444, 0.07555, 0, 0.77778],
            923: [0, 0.69444, 0, 0, 0.61111],
            926: [0, 0.69444, 0.12816, 0, 0.66667],
            928: [0, 0.69444, 0.08094, 0, 0.70834],
            931: [0, 0.69444, 0.11983, 0, 0.72222],
            933: [0, 0.69444, 0.09031, 0, 0.77778],
            934: [0, 0.69444, 0.04603, 0, 0.72222],
            936: [0, 0.69444, 0.09031, 0, 0.77778],
            937: [0, 0.69444, 0.08293, 0, 0.72222],
            8211: [0, 0.44444, 0.08616, 0, 0.5],
            8212: [0, 0.44444, 0.08616, 0, 1],
            8216: [0, 0.69444, 0.07816, 0, 0.27778],
            8217: [0, 0.69444, 0.07816, 0, 0.27778],
            8220: [0, 0.69444, 0.14205, 0, 0.5],
            8221: [0, 0.69444, 0.00316, 0, 0.5],
          },
          "SansSerif-Regular": {
            32: [0, 0, 0, 0, 0.25],
            33: [0, 0.69444, 0, 0, 0.31945],
            34: [0, 0.69444, 0, 0, 0.5],
            35: [0.19444, 0.69444, 0, 0, 0.83334],
            36: [0.05556, 0.75, 0, 0, 0.5],
            37: [0.05556, 0.75, 0, 0, 0.83334],
            38: [0, 0.69444, 0, 0, 0.75834],
            39: [0, 0.69444, 0, 0, 0.27778],
            40: [0.25, 0.75, 0, 0, 0.38889],
            41: [0.25, 0.75, 0, 0, 0.38889],
            42: [0, 0.75, 0, 0, 0.5],
            43: [0.08333, 0.58333, 0, 0, 0.77778],
            44: [0.125, 0.08333, 0, 0, 0.27778],
            45: [0, 0.44444, 0, 0, 0.33333],
            46: [0, 0.08333, 0, 0, 0.27778],
            47: [0.25, 0.75, 0, 0, 0.5],
            48: [0, 0.65556, 0, 0, 0.5],
            49: [0, 0.65556, 0, 0, 0.5],
            50: [0, 0.65556, 0, 0, 0.5],
            51: [0, 0.65556, 0, 0, 0.5],
            52: [0, 0.65556, 0, 0, 0.5],
            53: [0, 0.65556, 0, 0, 0.5],
            54: [0, 0.65556, 0, 0, 0.5],
            55: [0, 0.65556, 0, 0, 0.5],
            56: [0, 0.65556, 0, 0, 0.5],
            57: [0, 0.65556, 0, 0, 0.5],
            58: [0, 0.44444, 0, 0, 0.27778],
            59: [0.125, 0.44444, 0, 0, 0.27778],
            61: [-0.13, 0.37, 0, 0, 0.77778],
            63: [0, 0.69444, 0, 0, 0.47222],
            64: [0, 0.69444, 0, 0, 0.66667],
            65: [0, 0.69444, 0, 0, 0.66667],
            66: [0, 0.69444, 0, 0, 0.66667],
            67: [0, 0.69444, 0, 0, 0.63889],
            68: [0, 0.69444, 0, 0, 0.72223],
            69: [0, 0.69444, 0, 0, 0.59722],
            70: [0, 0.69444, 0, 0, 0.56945],
            71: [0, 0.69444, 0, 0, 0.66667],
            72: [0, 0.69444, 0, 0, 0.70834],
            73: [0, 0.69444, 0, 0, 0.27778],
            74: [0, 0.69444, 0, 0, 0.47222],
            75: [0, 0.69444, 0, 0, 0.69445],
            76: [0, 0.69444, 0, 0, 0.54167],
            77: [0, 0.69444, 0, 0, 0.875],
            78: [0, 0.69444, 0, 0, 0.70834],
            79: [0, 0.69444, 0, 0, 0.73611],
            80: [0, 0.69444, 0, 0, 0.63889],
            81: [0.125, 0.69444, 0, 0, 0.73611],
            82: [0, 0.69444, 0, 0, 0.64584],
            83: [0, 0.69444, 0, 0, 0.55556],
            84: [0, 0.69444, 0, 0, 0.68056],
            85: [0, 0.69444, 0, 0, 0.6875],
            86: [0, 0.69444, 0.01389, 0, 0.66667],
            87: [0, 0.69444, 0.01389, 0, 0.94445],
            88: [0, 0.69444, 0, 0, 0.66667],
            89: [0, 0.69444, 0.025, 0, 0.66667],
            90: [0, 0.69444, 0, 0, 0.61111],
            91: [0.25, 0.75, 0, 0, 0.28889],
            93: [0.25, 0.75, 0, 0, 0.28889],
            94: [0, 0.69444, 0, 0, 0.5],
            95: [0.35, 0.09444, 0.02778, 0, 0.5],
            97: [0, 0.44444, 0, 0, 0.48056],
            98: [0, 0.69444, 0, 0, 0.51667],
            99: [0, 0.44444, 0, 0, 0.44445],
            100: [0, 0.69444, 0, 0, 0.51667],
            101: [0, 0.44444, 0, 0, 0.44445],
            102: [0, 0.69444, 0.06944, 0, 0.30556],
            103: [0.19444, 0.44444, 0.01389, 0, 0.5],
            104: [0, 0.69444, 0, 0, 0.51667],
            105: [0, 0.67937, 0, 0, 0.23889],
            106: [0.19444, 0.67937, 0, 0, 0.26667],
            107: [0, 0.69444, 0, 0, 0.48889],
            108: [0, 0.69444, 0, 0, 0.23889],
            109: [0, 0.44444, 0, 0, 0.79445],
            110: [0, 0.44444, 0, 0, 0.51667],
            111: [0, 0.44444, 0, 0, 0.5],
            112: [0.19444, 0.44444, 0, 0, 0.51667],
            113: [0.19444, 0.44444, 0, 0, 0.51667],
            114: [0, 0.44444, 0.01389, 0, 0.34167],
            115: [0, 0.44444, 0, 0, 0.38333],
            116: [0, 0.57143, 0, 0, 0.36111],
            117: [0, 0.44444, 0, 0, 0.51667],
            118: [0, 0.44444, 0.01389, 0, 0.46111],
            119: [0, 0.44444, 0.01389, 0, 0.68334],
            120: [0, 0.44444, 0, 0, 0.46111],
            121: [0.19444, 0.44444, 0.01389, 0, 0.46111],
            122: [0, 0.44444, 0, 0, 0.43472],
            126: [0.35, 0.32659, 0, 0, 0.5],
            160: [0, 0, 0, 0, 0.25],
            168: [0, 0.67937, 0, 0, 0.5],
            176: [0, 0.69444, 0, 0, 0.66667],
            184: [0.17014, 0, 0, 0, 0.44445],
            305: [0, 0.44444, 0, 0, 0.23889],
            567: [0.19444, 0.44444, 0, 0, 0.26667],
            710: [0, 0.69444, 0, 0, 0.5],
            711: [0, 0.63194, 0, 0, 0.5],
            713: [0, 0.60889, 0, 0, 0.5],
            714: [0, 0.69444, 0, 0, 0.5],
            715: [0, 0.69444, 0, 0, 0.5],
            728: [0, 0.69444, 0, 0, 0.5],
            729: [0, 0.67937, 0, 0, 0.27778],
            730: [0, 0.69444, 0, 0, 0.66667],
            732: [0, 0.67659, 0, 0, 0.5],
            733: [0, 0.69444, 0, 0, 0.5],
            915: [0, 0.69444, 0, 0, 0.54167],
            916: [0, 0.69444, 0, 0, 0.83334],
            920: [0, 0.69444, 0, 0, 0.77778],
            923: [0, 0.69444, 0, 0, 0.61111],
            926: [0, 0.69444, 0, 0, 0.66667],
            928: [0, 0.69444, 0, 0, 0.70834],
            931: [0, 0.69444, 0, 0, 0.72222],
            933: [0, 0.69444, 0, 0, 0.77778],
            934: [0, 0.69444, 0, 0, 0.72222],
            936: [0, 0.69444, 0, 0, 0.77778],
            937: [0, 0.69444, 0, 0, 0.72222],
            8211: [0, 0.44444, 0.02778, 0, 0.5],
            8212: [0, 0.44444, 0.02778, 0, 1],
            8216: [0, 0.69444, 0, 0, 0.27778],
            8217: [0, 0.69444, 0, 0, 0.27778],
            8220: [0, 0.69444, 0, 0, 0.5],
            8221: [0, 0.69444, 0, 0, 0.5],
          },
          "Script-Regular": {
            32: [0, 0, 0, 0, 0.25],
            65: [0, 0.7, 0.22925, 0, 0.80253],
            66: [0, 0.7, 0.04087, 0, 0.90757],
            67: [0, 0.7, 0.1689, 0, 0.66619],
            68: [0, 0.7, 0.09371, 0, 0.77443],
            69: [0, 0.7, 0.18583, 0, 0.56162],
            70: [0, 0.7, 0.13634, 0, 0.89544],
            71: [0, 0.7, 0.17322, 0, 0.60961],
            72: [0, 0.7, 0.29694, 0, 0.96919],
            73: [0, 0.7, 0.19189, 0, 0.80907],
            74: [0.27778, 0.7, 0.19189, 0, 1.05159],
            75: [0, 0.7, 0.31259, 0, 0.91364],
            76: [0, 0.7, 0.19189, 0, 0.87373],
            77: [0, 0.7, 0.15981, 0, 1.08031],
            78: [0, 0.7, 0.3525, 0, 0.9015],
            79: [0, 0.7, 0.08078, 0, 0.73787],
            80: [0, 0.7, 0.08078, 0, 1.01262],
            81: [0, 0.7, 0.03305, 0, 0.88282],
            82: [0, 0.7, 0.06259, 0, 0.85],
            83: [0, 0.7, 0.19189, 0, 0.86767],
            84: [0, 0.7, 0.29087, 0, 0.74697],
            85: [0, 0.7, 0.25815, 0, 0.79996],
            86: [0, 0.7, 0.27523, 0, 0.62204],
            87: [0, 0.7, 0.27523, 0, 0.80532],
            88: [0, 0.7, 0.26006, 0, 0.94445],
            89: [0, 0.7, 0.2939, 0, 0.70961],
            90: [0, 0.7, 0.24037, 0, 0.8212],
            160: [0, 0, 0, 0, 0.25],
          },
          "Size1-Regular": {
            32: [0, 0, 0, 0, 0.25],
            40: [0.35001, 0.85, 0, 0, 0.45834],
            41: [0.35001, 0.85, 0, 0, 0.45834],
            47: [0.35001, 0.85, 0, 0, 0.57778],
            91: [0.35001, 0.85, 0, 0, 0.41667],
            92: [0.35001, 0.85, 0, 0, 0.57778],
            93: [0.35001, 0.85, 0, 0, 0.41667],
            123: [0.35001, 0.85, 0, 0, 0.58334],
            125: [0.35001, 0.85, 0, 0, 0.58334],
            160: [0, 0, 0, 0, 0.25],
            710: [0, 0.72222, 0, 0, 0.55556],
            732: [0, 0.72222, 0, 0, 0.55556],
            770: [0, 0.72222, 0, 0, 0.55556],
            771: [0, 0.72222, 0, 0, 0.55556],
            8214: [-99e-5, 0.601, 0, 0, 0.77778],
            8593: [1e-5, 0.6, 0, 0, 0.66667],
            8595: [1e-5, 0.6, 0, 0, 0.66667],
            8657: [1e-5, 0.6, 0, 0, 0.77778],
            8659: [1e-5, 0.6, 0, 0, 0.77778],
            8719: [0.25001, 0.75, 0, 0, 0.94445],
            8720: [0.25001, 0.75, 0, 0, 0.94445],
            8721: [0.25001, 0.75, 0, 0, 1.05556],
            8730: [0.35001, 0.85, 0, 0, 1],
            8739: [-0.00599, 0.606, 0, 0, 0.33333],
            8741: [-0.00599, 0.606, 0, 0, 0.55556],
            8747: [0.30612, 0.805, 0.19445, 0, 0.47222],
            8748: [0.306, 0.805, 0.19445, 0, 0.47222],
            8749: [0.306, 0.805, 0.19445, 0, 0.47222],
            8750: [0.30612, 0.805, 0.19445, 0, 0.47222],
            8896: [0.25001, 0.75, 0, 0, 0.83334],
            8897: [0.25001, 0.75, 0, 0, 0.83334],
            8898: [0.25001, 0.75, 0, 0, 0.83334],
            8899: [0.25001, 0.75, 0, 0, 0.83334],
            8968: [0.35001, 0.85, 0, 0, 0.47222],
            8969: [0.35001, 0.85, 0, 0, 0.47222],
            8970: [0.35001, 0.85, 0, 0, 0.47222],
            8971: [0.35001, 0.85, 0, 0, 0.47222],
            9168: [-99e-5, 0.601, 0, 0, 0.66667],
            10216: [0.35001, 0.85, 0, 0, 0.47222],
            10217: [0.35001, 0.85, 0, 0, 0.47222],
            10752: [0.25001, 0.75, 0, 0, 1.11111],
            10753: [0.25001, 0.75, 0, 0, 1.11111],
            10754: [0.25001, 0.75, 0, 0, 1.11111],
            10756: [0.25001, 0.75, 0, 0, 0.83334],
            10758: [0.25001, 0.75, 0, 0, 0.83334],
          },
          "Size2-Regular": {
            32: [0, 0, 0, 0, 0.25],
            40: [0.65002, 1.15, 0, 0, 0.59722],
            41: [0.65002, 1.15, 0, 0, 0.59722],
            47: [0.65002, 1.15, 0, 0, 0.81111],
            91: [0.65002, 1.15, 0, 0, 0.47222],
            92: [0.65002, 1.15, 0, 0, 0.81111],
            93: [0.65002, 1.15, 0, 0, 0.47222],
            123: [0.65002, 1.15, 0, 0, 0.66667],
            125: [0.65002, 1.15, 0, 0, 0.66667],
            160: [0, 0, 0, 0, 0.25],
            710: [0, 0.75, 0, 0, 1],
            732: [0, 0.75, 0, 0, 1],
            770: [0, 0.75, 0, 0, 1],
            771: [0, 0.75, 0, 0, 1],
            8719: [0.55001, 1.05, 0, 0, 1.27778],
            8720: [0.55001, 1.05, 0, 0, 1.27778],
            8721: [0.55001, 1.05, 0, 0, 1.44445],
            8730: [0.65002, 1.15, 0, 0, 1],
            8747: [0.86225, 1.36, 0.44445, 0, 0.55556],
            8748: [0.862, 1.36, 0.44445, 0, 0.55556],
            8749: [0.862, 1.36, 0.44445, 0, 0.55556],
            8750: [0.86225, 1.36, 0.44445, 0, 0.55556],
            8896: [0.55001, 1.05, 0, 0, 1.11111],
            8897: [0.55001, 1.05, 0, 0, 1.11111],
            8898: [0.55001, 1.05, 0, 0, 1.11111],
            8899: [0.55001, 1.05, 0, 0, 1.11111],
            8968: [0.65002, 1.15, 0, 0, 0.52778],
            8969: [0.65002, 1.15, 0, 0, 0.52778],
            8970: [0.65002, 1.15, 0, 0, 0.52778],
            8971: [0.65002, 1.15, 0, 0, 0.52778],
            10216: [0.65002, 1.15, 0, 0, 0.61111],
            10217: [0.65002, 1.15, 0, 0, 0.61111],
            10752: [0.55001, 1.05, 0, 0, 1.51112],
            10753: [0.55001, 1.05, 0, 0, 1.51112],
            10754: [0.55001, 1.05, 0, 0, 1.51112],
            10756: [0.55001, 1.05, 0, 0, 1.11111],
            10758: [0.55001, 1.05, 0, 0, 1.11111],
          },
          "Size3-Regular": {
            32: [0, 0, 0, 0, 0.25],
            40: [0.95003, 1.45, 0, 0, 0.73611],
            41: [0.95003, 1.45, 0, 0, 0.73611],
            47: [0.95003, 1.45, 0, 0, 1.04445],
            91: [0.95003, 1.45, 0, 0, 0.52778],
            92: [0.95003, 1.45, 0, 0, 1.04445],
            93: [0.95003, 1.45, 0, 0, 0.52778],
            123: [0.95003, 1.45, 0, 0, 0.75],
            125: [0.95003, 1.45, 0, 0, 0.75],
            160: [0, 0, 0, 0, 0.25],
            710: [0, 0.75, 0, 0, 1.44445],
            732: [0, 0.75, 0, 0, 1.44445],
            770: [0, 0.75, 0, 0, 1.44445],
            771: [0, 0.75, 0, 0, 1.44445],
            8730: [0.95003, 1.45, 0, 0, 1],
            8968: [0.95003, 1.45, 0, 0, 0.58334],
            8969: [0.95003, 1.45, 0, 0, 0.58334],
            8970: [0.95003, 1.45, 0, 0, 0.58334],
            8971: [0.95003, 1.45, 0, 0, 0.58334],
            10216: [0.95003, 1.45, 0, 0, 0.75],
            10217: [0.95003, 1.45, 0, 0, 0.75],
          },
          "Size4-Regular": {
            32: [0, 0, 0, 0, 0.25],
            40: [1.25003, 1.75, 0, 0, 0.79167],
            41: [1.25003, 1.75, 0, 0, 0.79167],
            47: [1.25003, 1.75, 0, 0, 1.27778],
            91: [1.25003, 1.75, 0, 0, 0.58334],
            92: [1.25003, 1.75, 0, 0, 1.27778],
            93: [1.25003, 1.75, 0, 0, 0.58334],
            123: [1.25003, 1.75, 0, 0, 0.80556],
            125: [1.25003, 1.75, 0, 0, 0.80556],
            160: [0, 0, 0, 0, 0.25],
            710: [0, 0.825, 0, 0, 1.8889],
            732: [0, 0.825, 0, 0, 1.8889],
            770: [0, 0.825, 0, 0, 1.8889],
            771: [0, 0.825, 0, 0, 1.8889],
            8730: [1.25003, 1.75, 0, 0, 1],
            8968: [1.25003, 1.75, 0, 0, 0.63889],
            8969: [1.25003, 1.75, 0, 0, 0.63889],
            8970: [1.25003, 1.75, 0, 0, 0.63889],
            8971: [1.25003, 1.75, 0, 0, 0.63889],
            9115: [0.64502, 1.155, 0, 0, 0.875],
            9116: [1e-5, 0.6, 0, 0, 0.875],
            9117: [0.64502, 1.155, 0, 0, 0.875],
            9118: [0.64502, 1.155, 0, 0, 0.875],
            9119: [1e-5, 0.6, 0, 0, 0.875],
            9120: [0.64502, 1.155, 0, 0, 0.875],
            9121: [0.64502, 1.155, 0, 0, 0.66667],
            9122: [-99e-5, 0.601, 0, 0, 0.66667],
            9123: [0.64502, 1.155, 0, 0, 0.66667],
            9124: [0.64502, 1.155, 0, 0, 0.66667],
            9125: [-99e-5, 0.601, 0, 0, 0.66667],
            9126: [0.64502, 1.155, 0, 0, 0.66667],
            9127: [1e-5, 0.9, 0, 0, 0.88889],
            9128: [0.65002, 1.15, 0, 0, 0.88889],
            9129: [0.90001, 0, 0, 0, 0.88889],
            9130: [0, 0.3, 0, 0, 0.88889],
            9131: [1e-5, 0.9, 0, 0, 0.88889],
            9132: [0.65002, 1.15, 0, 0, 0.88889],
            9133: [0.90001, 0, 0, 0, 0.88889],
            9143: [0.88502, 0.915, 0, 0, 1.05556],
            10216: [1.25003, 1.75, 0, 0, 0.80556],
            10217: [1.25003, 1.75, 0, 0, 0.80556],
            57344: [-0.00499, 0.605, 0, 0, 1.05556],
            57345: [-0.00499, 0.605, 0, 0, 1.05556],
            57680: [0, 0.12, 0, 0, 0.45],
            57681: [0, 0.12, 0, 0, 0.45],
            57682: [0, 0.12, 0, 0, 0.45],
            57683: [0, 0.12, 0, 0, 0.45],
          },
          "Typewriter-Regular": {
            32: [0, 0, 0, 0, 0.525],
            33: [0, 0.61111, 0, 0, 0.525],
            34: [0, 0.61111, 0, 0, 0.525],
            35: [0, 0.61111, 0, 0, 0.525],
            36: [0.08333, 0.69444, 0, 0, 0.525],
            37: [0.08333, 0.69444, 0, 0, 0.525],
            38: [0, 0.61111, 0, 0, 0.525],
            39: [0, 0.61111, 0, 0, 0.525],
            40: [0.08333, 0.69444, 0, 0, 0.525],
            41: [0.08333, 0.69444, 0, 0, 0.525],
            42: [0, 0.52083, 0, 0, 0.525],
            43: [-0.08056, 0.53055, 0, 0, 0.525],
            44: [0.13889, 0.125, 0, 0, 0.525],
            45: [-0.08056, 0.53055, 0, 0, 0.525],
            46: [0, 0.125, 0, 0, 0.525],
            47: [0.08333, 0.69444, 0, 0, 0.525],
            48: [0, 0.61111, 0, 0, 0.525],
            49: [0, 0.61111, 0, 0, 0.525],
            50: [0, 0.61111, 0, 0, 0.525],
            51: [0, 0.61111, 0, 0, 0.525],
            52: [0, 0.61111, 0, 0, 0.525],
            53: [0, 0.61111, 0, 0, 0.525],
            54: [0, 0.61111, 0, 0, 0.525],
            55: [0, 0.61111, 0, 0, 0.525],
            56: [0, 0.61111, 0, 0, 0.525],
            57: [0, 0.61111, 0, 0, 0.525],
            58: [0, 0.43056, 0, 0, 0.525],
            59: [0.13889, 0.43056, 0, 0, 0.525],
            60: [-0.05556, 0.55556, 0, 0, 0.525],
            61: [-0.19549, 0.41562, 0, 0, 0.525],
            62: [-0.05556, 0.55556, 0, 0, 0.525],
            63: [0, 0.61111, 0, 0, 0.525],
            64: [0, 0.61111, 0, 0, 0.525],
            65: [0, 0.61111, 0, 0, 0.525],
            66: [0, 0.61111, 0, 0, 0.525],
            67: [0, 0.61111, 0, 0, 0.525],
            68: [0, 0.61111, 0, 0, 0.525],
            69: [0, 0.61111, 0, 0, 0.525],
            70: [0, 0.61111, 0, 0, 0.525],
            71: [0, 0.61111, 0, 0, 0.525],
            72: [0, 0.61111, 0, 0, 0.525],
            73: [0, 0.61111, 0, 0, 0.525],
            74: [0, 0.61111, 0, 0, 0.525],
            75: [0, 0.61111, 0, 0, 0.525],
            76: [0, 0.61111, 0, 0, 0.525],
            77: [0, 0.61111, 0, 0, 0.525],
            78: [0, 0.61111, 0, 0, 0.525],
            79: [0, 0.61111, 0, 0, 0.525],
            80: [0, 0.61111, 0, 0, 0.525],
            81: [0.13889, 0.61111, 0, 0, 0.525],
            82: [0, 0.61111, 0, 0, 0.525],
            83: [0, 0.61111, 0, 0, 0.525],
            84: [0, 0.61111, 0, 0, 0.525],
            85: [0, 0.61111, 0, 0, 0.525],
            86: [0, 0.61111, 0, 0, 0.525],
            87: [0, 0.61111, 0, 0, 0.525],
            88: [0, 0.61111, 0, 0, 0.525],
            89: [0, 0.61111, 0, 0, 0.525],
            90: [0, 0.61111, 0, 0, 0.525],
            91: [0.08333, 0.69444, 0, 0, 0.525],
            92: [0.08333, 0.69444, 0, 0, 0.525],
            93: [0.08333, 0.69444, 0, 0, 0.525],
            94: [0, 0.61111, 0, 0, 0.525],
            95: [0.09514, 0, 0, 0, 0.525],
            96: [0, 0.61111, 0, 0, 0.525],
            97: [0, 0.43056, 0, 0, 0.525],
            98: [0, 0.61111, 0, 0, 0.525],
            99: [0, 0.43056, 0, 0, 0.525],
            100: [0, 0.61111, 0, 0, 0.525],
            101: [0, 0.43056, 0, 0, 0.525],
            102: [0, 0.61111, 0, 0, 0.525],
            103: [0.22222, 0.43056, 0, 0, 0.525],
            104: [0, 0.61111, 0, 0, 0.525],
            105: [0, 0.61111, 0, 0, 0.525],
            106: [0.22222, 0.61111, 0, 0, 0.525],
            107: [0, 0.61111, 0, 0, 0.525],
            108: [0, 0.61111, 0, 0, 0.525],
            109: [0, 0.43056, 0, 0, 0.525],
            110: [0, 0.43056, 0, 0, 0.525],
            111: [0, 0.43056, 0, 0, 0.525],
            112: [0.22222, 0.43056, 0, 0, 0.525],
            113: [0.22222, 0.43056, 0, 0, 0.525],
            114: [0, 0.43056, 0, 0, 0.525],
            115: [0, 0.43056, 0, 0, 0.525],
            116: [0, 0.55358, 0, 0, 0.525],
            117: [0, 0.43056, 0, 0, 0.525],
            118: [0, 0.43056, 0, 0, 0.525],
            119: [0, 0.43056, 0, 0, 0.525],
            120: [0, 0.43056, 0, 0, 0.525],
            121: [0.22222, 0.43056, 0, 0, 0.525],
            122: [0, 0.43056, 0, 0, 0.525],
            123: [0.08333, 0.69444, 0, 0, 0.525],
            124: [0.08333, 0.69444, 0, 0, 0.525],
            125: [0.08333, 0.69444, 0, 0, 0.525],
            126: [0, 0.61111, 0, 0, 0.525],
            127: [0, 0.61111, 0, 0, 0.525],
            160: [0, 0, 0, 0, 0.525],
            176: [0, 0.61111, 0, 0, 0.525],
            184: [0.19445, 0, 0, 0, 0.525],
            305: [0, 0.43056, 0, 0, 0.525],
            567: [0.22222, 0.43056, 0, 0, 0.525],
            711: [0, 0.56597, 0, 0, 0.525],
            713: [0, 0.56555, 0, 0, 0.525],
            714: [0, 0.61111, 0, 0, 0.525],
            715: [0, 0.61111, 0, 0, 0.525],
            728: [0, 0.61111, 0, 0, 0.525],
            730: [0, 0.61111, 0, 0, 0.525],
            770: [0, 0.61111, 0, 0, 0.525],
            771: [0, 0.61111, 0, 0, 0.525],
            776: [0, 0.61111, 0, 0, 0.525],
            915: [0, 0.61111, 0, 0, 0.525],
            916: [0, 0.61111, 0, 0, 0.525],
            920: [0, 0.61111, 0, 0, 0.525],
            923: [0, 0.61111, 0, 0, 0.525],
            926: [0, 0.61111, 0, 0, 0.525],
            928: [0, 0.61111, 0, 0, 0.525],
            931: [0, 0.61111, 0, 0, 0.525],
            933: [0, 0.61111, 0, 0, 0.525],
            934: [0, 0.61111, 0, 0, 0.525],
            936: [0, 0.61111, 0, 0, 0.525],
            937: [0, 0.61111, 0, 0, 0.525],
            8216: [0, 0.61111, 0, 0, 0.525],
            8217: [0, 0.61111, 0, 0, 0.525],
            8242: [0, 0.61111, 0, 0, 0.525],
            9251: [0.11111, 0.21944, 0, 0, 0.525],
          },
        },
        V = {
          slant: [0.25, 0.25, 0.25],
          space: [0, 0, 0],
          stretch: [0, 0, 0],
          shrink: [0, 0, 0],
          xHeight: [0.431, 0.431, 0.431],
          quad: [1, 1.171, 1.472],
          extraSpace: [0, 0, 0],
          num1: [0.677, 0.732, 0.925],
          num2: [0.394, 0.384, 0.387],
          num3: [0.444, 0.471, 0.504],
          denom1: [0.686, 0.752, 1.025],
          denom2: [0.345, 0.344, 0.532],
          sup1: [0.413, 0.503, 0.504],
          sup2: [0.363, 0.431, 0.404],
          sup3: [0.289, 0.286, 0.294],
          sub1: [0.15, 0.143, 0.2],
          sub2: [0.247, 0.286, 0.4],
          supDrop: [0.386, 0.353, 0.494],
          subDrop: [0.05, 0.071, 0.1],
          delim1: [2.39, 1.7, 1.98],
          delim2: [1.01, 1.157, 1.42],
          axisHeight: [0.25, 0.25, 0.25],
          defaultRuleThickness: [0.04, 0.049, 0.049],
          bigOpSpacing1: [0.111, 0.111, 0.111],
          bigOpSpacing2: [0.166, 0.166, 0.166],
          bigOpSpacing3: [0.2, 0.2, 0.2],
          bigOpSpacing4: [0.6, 0.611, 0.611],
          bigOpSpacing5: [0.1, 0.143, 0.143],
          sqrtRuleThickness: [0.04, 0.04, 0.04],
          ptPerEm: [10, 10, 10],
          doubleRuleSep: [0.2, 0.2, 0.2],
          arrayRuleWidth: [0.04, 0.04, 0.04],
          fboxsep: [0.3, 0.3, 0.3],
          fboxrule: [0.04, 0.04, 0.04],
        },
        U = {
          "\xc5": "A",
          "\xc7": "C",
          "\xd0": "D",
          "\xde": "o",
          "\xe5": "a",
          "\xe7": "c",
          "\xf0": "d",
          "\xfe": "o",
          "\u0410": "A",
          "\u0411": "B",
          "\u0412": "B",
          "\u0413": "F",
          "\u0414": "A",
          "\u0415": "E",
          "\u0416": "K",
          "\u0417": "3",
          "\u0418": "N",
          "\u0419": "N",
          "\u041a": "K",
          "\u041b": "N",
          "\u041c": "M",
          "\u041d": "H",
          "\u041e": "O",
          "\u041f": "N",
          "\u0420": "P",
          "\u0421": "C",
          "\u0422": "T",
          "\u0423": "y",
          "\u0424": "O",
          "\u0425": "X",
          "\u0426": "U",
          "\u0427": "h",
          "\u0428": "W",
          "\u0429": "W",
          "\u042a": "B",
          "\u042b": "X",
          "\u042c": "B",
          "\u042d": "3",
          "\u042e": "X",
          "\u042f": "R",
          "\u0430": "a",
          "\u0431": "b",
          "\u0432": "a",
          "\u0433": "r",
          "\u0434": "y",
          "\u0435": "e",
          "\u0436": "m",
          "\u0437": "e",
          "\u0438": "n",
          "\u0439": "n",
          "\u043a": "n",
          "\u043b": "n",
          "\u043c": "m",
          "\u043d": "n",
          "\u043e": "o",
          "\u043f": "n",
          "\u0440": "p",
          "\u0441": "c",
          "\u0442": "o",
          "\u0443": "y",
          "\u0444": "b",
          "\u0445": "x",
          "\u0446": "n",
          "\u0447": "n",
          "\u0448": "w",
          "\u0449": "w",
          "\u044a": "a",
          "\u044b": "m",
          "\u044c": "a",
          "\u044d": "e",
          "\u044e": "m",
          "\u044f": "r",
        };
      function G(t, e, r) {
        if (!F[e])
          throw new Error("Font metrics not found for font: " + e + ".");
        var a = t.charCodeAt(0),
          n = F[e][a];
        if (
          (!n && t[0] in U && ((a = U[t[0]].charCodeAt(0)), (n = F[e][a])),
          n || "text" !== r || (M(a) && (n = F[e][77])),
          n)
        )
          return {
            depth: n[0],
            height: n[1],
            italic: n[2],
            skew: n[3],
            width: n[4],
          };
      }
      var Y = {};
      var W = { bin: 1, close: 1, inner: 1, open: 1, punct: 1, rel: 1 },
        X = {
          "accent-token": 1,
          mathord: 1,
          "op-token": 1,
          spacing: 1,
          textord: 1,
        },
        _ = { math: {}, text: {} },
        j = _;
      function $(t, e, r, a, n, i) {
        (_[t][n] = { font: e, group: r, replace: a }),
          i && a && (_[t][a] = _[t][n]);
      }
      var Z = "main",
        K = "ams",
        J = "bin",
        Q = "mathord",
        tt = "op-token",
        et = "rel";
      $("math", Z, et, "\u2261", "\\equiv", !0),
        $("math", Z, et, "\u227a", "\\prec", !0),
        $("math", Z, et, "\u227b", "\\succ", !0),
        $("math", Z, et, "\u223c", "\\sim", !0),
        $("math", Z, et, "\u22a5", "\\perp"),
        $("math", Z, et, "\u2aaf", "\\preceq", !0),
        $("math", Z, et, "\u2ab0", "\\succeq", !0),
        $("math", Z, et, "\u2243", "\\simeq", !0),
        $("math", Z, et, "\u2223", "\\mid", !0),
        $("math", Z, et, "\u226a", "\\ll", !0),
        $("math", Z, et, "\u226b", "\\gg", !0),
        $("math", Z, et, "\u224d", "\\asymp", !0),
        $("math", Z, et, "\u2225", "\\parallel"),
        $("math", Z, et, "\u22c8", "\\bowtie", !0),
        $("math", Z, et, "\u2323", "\\smile", !0),
        $("math", Z, et, "\u2291", "\\sqsubseteq", !0),
        $("math", Z, et, "\u2292", "\\sqsupseteq", !0),
        $("math", Z, et, "\u2250", "\\doteq", !0),
        $("math", Z, et, "\u2322", "\\frown", !0),
        $("math", Z, et, "\u220b", "\\ni", !0),
        $("math", Z, et, "\u221d", "\\propto", !0),
        $("math", Z, et, "\u22a2", "\\vdash", !0),
        $("math", Z, et, "\u22a3", "\\dashv", !0),
        $("math", Z, et, "\u220b", "\\owns"),
        $("math", Z, "punct", ".", "\\ldotp"),
        $("math", Z, "punct", "\u22c5", "\\cdotp"),
        $("math", Z, "textord", "#", "\\#"),
        $("text", Z, "textord", "#", "\\#"),
        $("math", Z, "textord", "&", "\\&"),
        $("text", Z, "textord", "&", "\\&"),
        $("math", Z, "textord", "\u2135", "\\aleph", !0),
        $("math", Z, "textord", "\u2200", "\\forall", !0),
        $("math", Z, "textord", "\u210f", "\\hbar", !0),
        $("math", Z, "textord", "\u2203", "\\exists", !0),
        $("math", Z, "textord", "\u2207", "\\nabla", !0),
        $("math", Z, "textord", "\u266d", "\\flat", !0),
        $("math", Z, "textord", "\u2113", "\\ell", !0),
        $("math", Z, "textord", "\u266e", "\\natural", !0),
        $("math", Z, "textord", "\u2663", "\\clubsuit", !0),
        $("math", Z, "textord", "\u2118", "\\wp", !0),
        $("math", Z, "textord", "\u266f", "\\sharp", !0),
        $("math", Z, "textord", "\u2662", "\\diamondsuit", !0),
        $("math", Z, "textord", "\u211c", "\\Re", !0),
        $("math", Z, "textord", "\u2661", "\\heartsuit", !0),
        $("math", Z, "textord", "\u2111", "\\Im", !0),
        $("math", Z, "textord", "\u2660", "\\spadesuit", !0),
        $("text", Z, "textord", "\xa7", "\\S", !0),
        $("text", Z, "textord", "\xb6", "\\P", !0),
        $("math", Z, "textord", "\u2020", "\\dag"),
        $("text", Z, "textord", "\u2020", "\\dag"),
        $("text", Z, "textord", "\u2020", "\\textdagger"),
        $("math", Z, "textord", "\u2021", "\\ddag"),
        $("text", Z, "textord", "\u2021", "\\ddag"),
        $("text", Z, "textord", "\u2021", "\\textdaggerdbl"),
        $("math", Z, "close", "\u23b1", "\\rmoustache", !0),
        $("math", Z, "open", "\u23b0", "\\lmoustache", !0),
        $("math", Z, "close", "\u27ef", "\\rgroup", !0),
        $("math", Z, "open", "\u27ee", "\\lgroup", !0),
        $("math", Z, J, "\u2213", "\\mp", !0),
        $("math", Z, J, "\u2296", "\\ominus", !0),
        $("math", Z, J, "\u228e", "\\uplus", !0),
        $("math", Z, J, "\u2293", "\\sqcap", !0),
        $("math", Z, J, "\u2217", "\\ast"),
        $("math", Z, J, "\u2294", "\\sqcup", !0),
        $("math", Z, J, "\u25ef", "\\bigcirc"),
        $("math", Z, J, "\u2219", "\\bullet"),
        $("math", Z, J, "\u2021", "\\ddagger"),
        $("math", Z, J, "\u2240", "\\wr", !0),
        $("math", Z, J, "\u2a3f", "\\amalg"),
        $("math", Z, J, "&", "\\And"),
        $("math", Z, et, "\u27f5", "\\longleftarrow", !0),
        $("math", Z, et, "\u21d0", "\\Leftarrow", !0),
        $("math", Z, et, "\u27f8", "\\Longleftarrow", !0),
        $("math", Z, et, "\u27f6", "\\longrightarrow", !0),
        $("math", Z, et, "\u21d2", "\\Rightarrow", !0),
        $("math", Z, et, "\u27f9", "\\Longrightarrow", !0),
        $("math", Z, et, "\u2194", "\\leftrightarrow", !0),
        $("math", Z, et, "\u27f7", "\\longleftrightarrow", !0),
        $("math", Z, et, "\u21d4", "\\Leftrightarrow", !0),
        $("math", Z, et, "\u27fa", "\\Longleftrightarrow", !0),
        $("math", Z, et, "\u21a6", "\\mapsto", !0),
        $("math", Z, et, "\u27fc", "\\longmapsto", !0),
        $("math", Z, et, "\u2197", "\\nearrow", !0),
        $("math", Z, et, "\u21a9", "\\hookleftarrow", !0),
        $("math", Z, et, "\u21aa", "\\hookrightarrow", !0),
        $("math", Z, et, "\u2198", "\\searrow", !0),
        $("math", Z, et, "\u21bc", "\\leftharpoonup", !0),
        $("math", Z, et, "\u21c0", "\\rightharpoonup", !0),
        $("math", Z, et, "\u2199", "\\swarrow", !0),
        $("math", Z, et, "\u21bd", "\\leftharpoondown", !0),
        $("math", Z, et, "\u21c1", "\\rightharpoondown", !0),
        $("math", Z, et, "\u2196", "\\nwarrow", !0),
        $("math", Z, et, "\u21cc", "\\rightleftharpoons", !0),
        $("math", K, et, "\u226e", "\\nless", !0),
        $("math", K, et, "\ue010", "\\@nleqslant"),
        $("math", K, et, "\ue011", "\\@nleqq"),
        $("math", K, et, "\u2a87", "\\lneq", !0),
        $("math", K, et, "\u2268", "\\lneqq", !0),
        $("math", K, et, "\ue00c", "\\@lvertneqq"),
        $("math", K, et, "\u22e6", "\\lnsim", !0),
        $("math", K, et, "\u2a89", "\\lnapprox", !0),
        $("math", K, et, "\u2280", "\\nprec", !0),
        $("math", K, et, "\u22e0", "\\npreceq", !0),
        $("math", K, et, "\u22e8", "\\precnsim", !0),
        $("math", K, et, "\u2ab9", "\\precnapprox", !0),
        $("math", K, et, "\u2241", "\\nsim", !0),
        $("math", K, et, "\ue006", "\\@nshortmid"),
        $("math", K, et, "\u2224", "\\nmid", !0),
        $("math", K, et, "\u22ac", "\\nvdash", !0),
        $("math", K, et, "\u22ad", "\\nvDash", !0),
        $("math", K, et, "\u22ea", "\\ntriangleleft"),
        $("math", K, et, "\u22ec", "\\ntrianglelefteq", !0),
        $("math", K, et, "\u228a", "\\subsetneq", !0),
        $("math", K, et, "\ue01a", "\\@varsubsetneq"),
        $("math", K, et, "\u2acb", "\\subsetneqq", !0),
        $("math", K, et, "\ue017", "\\@varsubsetneqq"),
        $("math", K, et, "\u226f", "\\ngtr", !0),
        $("math", K, et, "\ue00f", "\\@ngeqslant"),
        $("math", K, et, "\ue00e", "\\@ngeqq"),
        $("math", K, et, "\u2a88", "\\gneq", !0),
        $("math", K, et, "\u2269", "\\gneqq", !0),
        $("math", K, et, "\ue00d", "\\@gvertneqq"),
        $("math", K, et, "\u22e7", "\\gnsim", !0),
        $("math", K, et, "\u2a8a", "\\gnapprox", !0),
        $("math", K, et, "\u2281", "\\nsucc", !0),
        $("math", K, et, "\u22e1", "\\nsucceq", !0),
        $("math", K, et, "\u22e9", "\\succnsim", !0),
        $("math", K, et, "\u2aba", "\\succnapprox", !0),
        $("math", K, et, "\u2246", "\\ncong", !0),
        $("math", K, et, "\ue007", "\\@nshortparallel"),
        $("math", K, et, "\u2226", "\\nparallel", !0),
        $("math", K, et, "\u22af", "\\nVDash", !0),
        $("math", K, et, "\u22eb", "\\ntriangleright"),
        $("math", K, et, "\u22ed", "\\ntrianglerighteq", !0),
        $("math", K, et, "\ue018", "\\@nsupseteqq"),
        $("math", K, et, "\u228b", "\\supsetneq", !0),
        $("math", K, et, "\ue01b", "\\@varsupsetneq"),
        $("math", K, et, "\u2acc", "\\supsetneqq", !0),
        $("math", K, et, "\ue019", "\\@varsupsetneqq"),
        $("math", K, et, "\u22ae", "\\nVdash", !0),
        $("math", K, et, "\u2ab5", "\\precneqq", !0),
        $("math", K, et, "\u2ab6", "\\succneqq", !0),
        $("math", K, et, "\ue016", "\\@nsubseteqq"),
        $("math", K, J, "\u22b4", "\\unlhd"),
        $("math", K, J, "\u22b5", "\\unrhd"),
        $("math", K, et, "\u219a", "\\nleftarrow", !0),
        $("math", K, et, "\u219b", "\\nrightarrow", !0),
        $("math", K, et, "\u21cd", "\\nLeftarrow", !0),
        $("math", K, et, "\u21cf", "\\nRightarrow", !0),
        $("math", K, et, "\u21ae", "\\nleftrightarrow", !0),
        $("math", K, et, "\u21ce", "\\nLeftrightarrow", !0),
        $("math", K, et, "\u25b3", "\\vartriangle"),
        $("math", K, "textord", "\u210f", "\\hslash"),
        $("math", K, "textord", "\u25bd", "\\triangledown"),
        $("math", K, "textord", "\u25ca", "\\lozenge"),
        $("math", K, "textord", "\u24c8", "\\circledS"),
        $("math", K, "textord", "\xae", "\\circledR"),
        $("text", K, "textord", "\xae", "\\circledR"),
        $("math", K, "textord", "\u2221", "\\measuredangle", !0),
        $("math", K, "textord", "\u2204", "\\nexists"),
        $("math", K, "textord", "\u2127", "\\mho"),
        $("math", K, "textord", "\u2132", "\\Finv", !0),
        $("math", K, "textord", "\u2141", "\\Game", !0),
        $("math", K, "textord", "\u2035", "\\backprime"),
        $("math", K, "textord", "\u25b2", "\\blacktriangle"),
        $("math", K, "textord", "\u25bc", "\\blacktriangledown"),
        $("math", K, "textord", "\u25a0", "\\blacksquare"),
        $("math", K, "textord", "\u29eb", "\\blacklozenge"),
        $("math", K, "textord", "\u2605", "\\bigstar"),
        $("math", K, "textord", "\u2222", "\\sphericalangle", !0),
        $("math", K, "textord", "\u2201", "\\complement", !0),
        $("math", K, "textord", "\xf0", "\\eth", !0),
        $("text", Z, "textord", "\xf0", "\xf0"),
        $("math", K, "textord", "\u2571", "\\diagup"),
        $("math", K, "textord", "\u2572", "\\diagdown"),
        $("math", K, "textord", "\u25a1", "\\square"),
        $("math", K, "textord", "\u25a1", "\\Box"),
        $("math", K, "textord", "\u25ca", "\\Diamond"),
        $("math", K, "textord", "\xa5", "\\yen", !0),
        $("text", K, "textord", "\xa5", "\\yen", !0),
        $("math", K, "textord", "\u2713", "\\checkmark", !0),
        $("text", K, "textord", "\u2713", "\\checkmark"),
        $("math", K, "textord", "\u2136", "\\beth", !0),
        $("math", K, "textord", "\u2138", "\\daleth", !0),
        $("math", K, "textord", "\u2137", "\\gimel", !0),
        $("math", K, "textord", "\u03dd", "\\digamma", !0),
        $("math", K, "textord", "\u03f0", "\\varkappa"),
        $("math", K, "open", "\u250c", "\\@ulcorner", !0),
        $("math", K, "close", "\u2510", "\\@urcorner", !0),
        $("math", K, "open", "\u2514", "\\@llcorner", !0),
        $("math", K, "close", "\u2518", "\\@lrcorner", !0),
        $("math", K, et, "\u2266", "\\leqq", !0),
        $("math", K, et, "\u2a7d", "\\leqslant", !0),
        $("math", K, et, "\u2a95", "\\eqslantless", !0),
        $("math", K, et, "\u2272", "\\lesssim", !0),
        $("math", K, et, "\u2a85", "\\lessapprox", !0),
        $("math", K, et, "\u224a", "\\approxeq", !0),
        $("math", K, J, "\u22d6", "\\lessdot"),
        $("math", K, et, "\u22d8", "\\lll", !0),
        $("math", K, et, "\u2276", "\\lessgtr", !0),
        $("math", K, et, "\u22da", "\\lesseqgtr", !0),
        $("math", K, et, "\u2a8b", "\\lesseqqgtr", !0),
        $("math", K, et, "\u2251", "\\doteqdot"),
        $("math", K, et, "\u2253", "\\risingdotseq", !0),
        $("math", K, et, "\u2252", "\\fallingdotseq", !0),
        $("math", K, et, "\u223d", "\\backsim", !0),
        $("math", K, et, "\u22cd", "\\backsimeq", !0),
        $("math", K, et, "\u2ac5", "\\subseteqq", !0),
        $("math", K, et, "\u22d0", "\\Subset", !0),
        $("math", K, et, "\u228f", "\\sqsubset", !0),
        $("math", K, et, "\u227c", "\\preccurlyeq", !0),
        $("math", K, et, "\u22de", "\\curlyeqprec", !0),
        $("math", K, et, "\u227e", "\\precsim", !0),
        $("math", K, et, "\u2ab7", "\\precapprox", !0),
        $("math", K, et, "\u22b2", "\\vartriangleleft"),
        $("math", K, et, "\u22b4", "\\trianglelefteq"),
        $("math", K, et, "\u22a8", "\\vDash", !0),
        $("math", K, et, "\u22aa", "\\Vvdash", !0),
        $("math", K, et, "\u2323", "\\smallsmile"),
        $("math", K, et, "\u2322", "\\smallfrown"),
        $("math", K, et, "\u224f", "\\bumpeq", !0),
        $("math", K, et, "\u224e", "\\Bumpeq", !0),
        $("math", K, et, "\u2267", "\\geqq", !0),
        $("math", K, et, "\u2a7e", "\\geqslant", !0),
        $("math", K, et, "\u2a96", "\\eqslantgtr", !0),
        $("math", K, et, "\u2273", "\\gtrsim", !0),
        $("math", K, et, "\u2a86", "\\gtrapprox", !0),
        $("math", K, J, "\u22d7", "\\gtrdot"),
        $("math", K, et, "\u22d9", "\\ggg", !0),
        $("math", K, et, "\u2277", "\\gtrless", !0),
        $("math", K, et, "\u22db", "\\gtreqless", !0),
        $("math", K, et, "\u2a8c", "\\gtreqqless", !0),
        $("math", K, et, "\u2256", "\\eqcirc", !0),
        $("math", K, et, "\u2257", "\\circeq", !0),
        $("math", K, et, "\u225c", "\\triangleq", !0),
        $("math", K, et, "\u223c", "\\thicksim"),
        $("math", K, et, "\u2248", "\\thickapprox"),
        $("math", K, et, "\u2ac6", "\\supseteqq", !0),
        $("math", K, et, "\u22d1", "\\Supset", !0),
        $("math", K, et, "\u2290", "\\sqsupset", !0),
        $("math", K, et, "\u227d", "\\succcurlyeq", !0),
        $("math", K, et, "\u22df", "\\curlyeqsucc", !0),
        $("math", K, et, "\u227f", "\\succsim", !0),
        $("math", K, et, "\u2ab8", "\\succapprox", !0),
        $("math", K, et, "\u22b3", "\\vartriangleright"),
        $("math", K, et, "\u22b5", "\\trianglerighteq"),
        $("math", K, et, "\u22a9", "\\Vdash", !0),
        $("math", K, et, "\u2223", "\\shortmid"),
        $("math", K, et, "\u2225", "\\shortparallel"),
        $("math", K, et, "\u226c", "\\between", !0),
        $("math", K, et, "\u22d4", "\\pitchfork", !0),
        $("math", K, et, "\u221d", "\\varpropto"),
        $("math", K, et, "\u25c0", "\\blacktriangleleft"),
        $("math", K, et, "\u2234", "\\therefore", !0),
        $("math", K, et, "\u220d", "\\backepsilon"),
        $("math", K, et, "\u25b6", "\\blacktriangleright"),
        $("math", K, et, "\u2235", "\\because", !0),
        $("math", K, et, "\u22d8", "\\llless"),
        $("math", K, et, "\u22d9", "\\gggtr"),
        $("math", K, J, "\u22b2", "\\lhd"),
        $("math", K, J, "\u22b3", "\\rhd"),
        $("math", K, et, "\u2242", "\\eqsim", !0),
        $("math", Z, et, "\u22c8", "\\Join"),
        $("math", K, et, "\u2251", "\\Doteq", !0),
        $("math", K, J, "\u2214", "\\dotplus", !0),
        $("math", K, J, "\u2216", "\\smallsetminus"),
        $("math", K, J, "\u22d2", "\\Cap", !0),
        $("math", K, J, "\u22d3", "\\Cup", !0),
        $("math", K, J, "\u2a5e", "\\doublebarwedge", !0),
        $("math", K, J, "\u229f", "\\boxminus", !0),
        $("math", K, J, "\u229e", "\\boxplus", !0),
        $("math", K, J, "\u22c7", "\\divideontimes", !0),
        $("math", K, J, "\u22c9", "\\ltimes", !0),
        $("math", K, J, "\u22ca", "\\rtimes", !0),
        $("math", K, J, "\u22cb", "\\leftthreetimes", !0),
        $("math", K, J, "\u22cc", "\\rightthreetimes", !0),
        $("math", K, J, "\u22cf", "\\curlywedge", !0),
        $("math", K, J, "\u22ce", "\\curlyvee", !0),
        $("math", K, J, "\u229d", "\\circleddash", !0),
        $("math", K, J, "\u229b", "\\circledast", !0),
        $("math", K, J, "\u22c5", "\\centerdot"),
        $("math", K, J, "\u22ba", "\\intercal", !0),
        $("math", K, J, "\u22d2", "\\doublecap"),
        $("math", K, J, "\u22d3", "\\doublecup"),
        $("math", K, J, "\u22a0", "\\boxtimes", !0),
        $("math", K, et, "\u21e2", "\\dashrightarrow", !0),
        $("math", K, et, "\u21e0", "\\dashleftarrow", !0),
        $("math", K, et, "\u21c7", "\\leftleftarrows", !0),
        $("math", K, et, "\u21c6", "\\leftrightarrows", !0),
        $("math", K, et, "\u21da", "\\Lleftarrow", !0),
        $("math", K, et, "\u219e", "\\twoheadleftarrow", !0),
        $("math", K, et, "\u21a2", "\\leftarrowtail", !0),
        $("math", K, et, "\u21ab", "\\looparrowleft", !0),
        $("math", K, et, "\u21cb", "\\leftrightharpoons", !0),
        $("math", K, et, "\u21b6", "\\curvearrowleft", !0),
        $("math", K, et, "\u21ba", "\\circlearrowleft", !0),
        $("math", K, et, "\u21b0", "\\Lsh", !0),
        $("math", K, et, "\u21c8", "\\upuparrows", !0),
        $("math", K, et, "\u21bf", "\\upharpoonleft", !0),
        $("math", K, et, "\u21c3", "\\downharpoonleft", !0),
        $("math", K, et, "\u22b8", "\\multimap", !0),
        $("math", K, et, "\u21ad", "\\leftrightsquigarrow", !0),
        $("math", K, et, "\u21c9", "\\rightrightarrows", !0),
        $("math", K, et, "\u21c4", "\\rightleftarrows", !0),
        $("math", K, et, "\u21a0", "\\twoheadrightarrow", !0),
        $("math", K, et, "\u21a3", "\\rightarrowtail", !0),
        $("math", K, et, "\u21ac", "\\looparrowright", !0),
        $("math", K, et, "\u21b7", "\\curvearrowright", !0),
        $("math", K, et, "\u21bb", "\\circlearrowright", !0),
        $("math", K, et, "\u21b1", "\\Rsh", !0),
        $("math", K, et, "\u21ca", "\\downdownarrows", !0),
        $("math", K, et, "\u21be", "\\upharpoonright", !0),
        $("math", K, et, "\u21c2", "\\downharpoonright", !0),
        $("math", K, et, "\u21dd", "\\rightsquigarrow", !0),
        $("math", K, et, "\u21dd", "\\leadsto"),
        $("math", K, et, "\u21db", "\\Rrightarrow", !0),
        $("math", K, et, "\u21be", "\\restriction"),
        $("math", Z, "textord", "\u2018", "`"),
        $("math", Z, "textord", "$", "\\$"),
        $("text", Z, "textord", "$", "\\$"),
        $("text", Z, "textord", "$", "\\textdollar"),
        $("math", Z, "textord", "%", "\\%"),
        $("text", Z, "textord", "%", "\\%"),
        $("math", Z, "textord", "_", "\\_"),
        $("text", Z, "textord", "_", "\\_"),
        $("text", Z, "textord", "_", "\\textunderscore"),
        $("math", Z, "textord", "\u2220", "\\angle", !0),
        $("math", Z, "textord", "\u221e", "\\infty", !0),
        $("math", Z, "textord", "\u2032", "\\prime"),
        $("math", Z, "textord", "\u25b3", "\\triangle"),
        $("math", Z, "textord", "\u0393", "\\Gamma", !0),
        $("math", Z, "textord", "\u0394", "\\Delta", !0),
        $("math", Z, "textord", "\u0398", "\\Theta", !0),
        $("math", Z, "textord", "\u039b", "\\Lambda", !0),
        $("math", Z, "textord", "\u039e", "\\Xi", !0),
        $("math", Z, "textord", "\u03a0", "\\Pi", !0),
        $("math", Z, "textord", "\u03a3", "\\Sigma", !0),
        $("math", Z, "textord", "\u03a5", "\\Upsilon", !0),
        $("math", Z, "textord", "\u03a6", "\\Phi", !0),
        $("math", Z, "textord", "\u03a8", "\\Psi", !0),
        $("math", Z, "textord", "\u03a9", "\\Omega", !0),
        $("math", Z, "textord", "A", "\u0391"),
        $("math", Z, "textord", "B", "\u0392"),
        $("math", Z, "textord", "E", "\u0395"),
        $("math", Z, "textord", "Z", "\u0396"),
        $("math", Z, "textord", "H", "\u0397"),
        $("math", Z, "textord", "I", "\u0399"),
        $("math", Z, "textord", "K", "\u039a"),
        $("math", Z, "textord", "M", "\u039c"),
        $("math", Z, "textord", "N", "\u039d"),
        $("math", Z, "textord", "O", "\u039f"),
        $("math", Z, "textord", "P", "\u03a1"),
        $("math", Z, "textord", "T", "\u03a4"),
        $("math", Z, "textord", "X", "\u03a7"),
        $("math", Z, "textord", "\xac", "\\neg", !0),
        $("math", Z, "textord", "\xac", "\\lnot"),
        $("math", Z, "textord", "\u22a4", "\\top"),
        $("math", Z, "textord", "\u22a5", "\\bot"),
        $("math", Z, "textord", "\u2205", "\\emptyset"),
        $("math", K, "textord", "\u2205", "\\varnothing"),
        $("math", Z, Q, "\u03b1", "\\alpha", !0),
        $("math", Z, Q, "\u03b2", "\\beta", !0),
        $("math", Z, Q, "\u03b3", "\\gamma", !0),
        $("math", Z, Q, "\u03b4", "\\delta", !0),
        $("math", Z, Q, "\u03f5", "\\epsilon", !0),
        $("math", Z, Q, "\u03b6", "\\zeta", !0),
        $("math", Z, Q, "\u03b7", "\\eta", !0),
        $("math", Z, Q, "\u03b8", "\\theta", !0),
        $("math", Z, Q, "\u03b9", "\\iota", !0),
        $("math", Z, Q, "\u03ba", "\\kappa", !0),
        $("math", Z, Q, "\u03bb", "\\lambda", !0),
        $("math", Z, Q, "\u03bc", "\\mu", !0),
        $("math", Z, Q, "\u03bd", "\\nu", !0),
        $("math", Z, Q, "\u03be", "\\xi", !0),
        $("math", Z, Q, "\u03bf", "\\omicron", !0),
        $("math", Z, Q, "\u03c0", "\\pi", !0),
        $("math", Z, Q, "\u03c1", "\\rho", !0),
        $("math", Z, Q, "\u03c3", "\\sigma", !0),
        $("math", Z, Q, "\u03c4", "\\tau", !0),
        $("math", Z, Q, "\u03c5", "\\upsilon", !0),
        $("math", Z, Q, "\u03d5", "\\phi", !0),
        $("math", Z, Q, "\u03c7", "\\chi", !0),
        $("math", Z, Q, "\u03c8", "\\psi", !0),
        $("math", Z, Q, "\u03c9", "\\omega", !0),
        $("math", Z, Q, "\u03b5", "\\varepsilon", !0),
        $("math", Z, Q, "\u03d1", "\\vartheta", !0),
        $("math", Z, Q, "\u03d6", "\\varpi", !0),
        $("math", Z, Q, "\u03f1", "\\varrho", !0),
        $("math", Z, Q, "\u03c2", "\\varsigma", !0),
        $("math", Z, Q, "\u03c6", "\\varphi", !0),
        $("math", Z, J, "\u2217", "*"),
        $("math", Z, J, "+", "+"),
        $("math", Z, J, "\u2212", "-"),
        $("math", Z, J, "\u22c5", "\\cdot", !0),
        $("math", Z, J, "\u2218", "\\circ"),
        $("math", Z, J, "\xf7", "\\div", !0),
        $("math", Z, J, "\xb1", "\\pm", !0),
        $("math", Z, J, "\xd7", "\\times", !0),
        $("math", Z, J, "\u2229", "\\cap", !0),
        $("math", Z, J, "\u222a", "\\cup", !0),
        $("math", Z, J, "\u2216", "\\setminus"),
        $("math", Z, J, "\u2227", "\\land"),
        $("math", Z, J, "\u2228", "\\lor"),
        $("math", Z, J, "\u2227", "\\wedge", !0),
        $("math", Z, J, "\u2228", "\\vee", !0),
        $("math", Z, "textord", "\u221a", "\\surd"),
        $("math", Z, "open", "\u27e8", "\\langle", !0),
        $("math", Z, "open", "\u2223", "\\lvert"),
        $("math", Z, "open", "\u2225", "\\lVert"),
        $("math", Z, "close", "?", "?"),
        $("math", Z, "close", "!", "!"),
        $("math", Z, "close", "\u27e9", "\\rangle", !0),
        $("math", Z, "close", "\u2223", "\\rvert"),
        $("math", Z, "close", "\u2225", "\\rVert"),
        $("math", Z, et, "=", "="),
        $("math", Z, et, ":", ":"),
        $("math", Z, et, "\u2248", "\\approx", !0),
        $("math", Z, et, "\u2245", "\\cong", !0),
        $("math", Z, et, "\u2265", "\\ge"),
        $("math", Z, et, "\u2265", "\\geq", !0),
        $("math", Z, et, "\u2190", "\\gets"),
        $("math", Z, et, ">", "\\gt", !0),
        $("math", Z, et, "\u2208", "\\in", !0),
        $("math", Z, et, "\ue020", "\\@not"),
        $("math", Z, et, "\u2282", "\\subset", !0),
        $("math", Z, et, "\u2283", "\\supset", !0),
        $("math", Z, et, "\u2286", "\\subseteq", !0),
        $("math", Z, et, "\u2287", "\\supseteq", !0),
        $("math", K, et, "\u2288", "\\nsubseteq", !0),
        $("math", K, et, "\u2289", "\\nsupseteq", !0),
        $("math", Z, et, "\u22a8", "\\models"),
        $("math", Z, et, "\u2190", "\\leftarrow", !0),
        $("math", Z, et, "\u2264", "\\le"),
        $("math", Z, et, "\u2264", "\\leq", !0),
        $("math", Z, et, "<", "\\lt", !0),
        $("math", Z, et, "\u2192", "\\rightarrow", !0),
        $("math", Z, et, "\u2192", "\\to"),
        $("math", K, et, "\u2271", "\\ngeq", !0),
        $("math", K, et, "\u2270", "\\nleq", !0),
        $("math", Z, "spacing", "\xa0", "\\ "),
        $("math", Z, "spacing", "\xa0", "~"),
        $("math", Z, "spacing", "\xa0", "\\space"),
        $("math", Z, "spacing", "\xa0", "\\nobreakspace"),
        $("text", Z, "spacing", "\xa0", "\\ "),
        $("text", Z, "spacing", "\xa0", " "),
        $("text", Z, "spacing", "\xa0", "~"),
        $("text", Z, "spacing", "\xa0", "\\space"),
        $("text", Z, "spacing", "\xa0", "\\nobreakspace"),
        $("math", Z, "spacing", null, "\\nobreak"),
        $("math", Z, "spacing", null, "\\allowbreak"),
        $("math", Z, "punct", ",", ","),
        $("math", Z, "punct", ";", ";"),
        $("math", K, J, "\u22bc", "\\barwedge", !0),
        $("math", K, J, "\u22bb", "\\veebar", !0),
        $("math", Z, J, "\u2299", "\\odot", !0),
        $("math", Z, J, "\u2295", "\\oplus", !0),
        $("math", Z, J, "\u2297", "\\otimes", !0),
        $("math", Z, "textord", "\u2202", "\\partial", !0),
        $("math", Z, J, "\u2298", "\\oslash", !0),
        $("math", K, J, "\u229a", "\\circledcirc", !0),
        $("math", K, J, "\u22a1", "\\boxdot", !0),
        $("math", Z, J, "\u25b3", "\\bigtriangleup"),
        $("math", Z, J, "\u25bd", "\\bigtriangledown"),
        $("math", Z, J, "\u2020", "\\dagger"),
        $("math", Z, J, "\u22c4", "\\diamond"),
        $("math", Z, J, "\u22c6", "\\star"),
        $("math", Z, J, "\u25c3", "\\triangleleft"),
        $("math", Z, J, "\u25b9", "\\triangleright"),
        $("math", Z, "open", "{", "\\{"),
        $("text", Z, "textord", "{", "\\{"),
        $("text", Z, "textord", "{", "\\textbraceleft"),
        $("math", Z, "close", "}", "\\}"),
        $("text", Z, "textord", "}", "\\}"),
        $("text", Z, "textord", "}", "\\textbraceright"),
        $("math", Z, "open", "{", "\\lbrace"),
        $("math", Z, "close", "}", "\\rbrace"),
        $("math", Z, "open", "[", "\\lbrack", !0),
        $("text", Z, "textord", "[", "\\lbrack", !0),
        $("math", Z, "close", "]", "\\rbrack", !0),
        $("text", Z, "textord", "]", "\\rbrack", !0),
        $("math", Z, "open", "(", "\\lparen", !0),
        $("math", Z, "close", ")", "\\rparen", !0),
        $("text", Z, "textord", "<", "\\textless", !0),
        $("text", Z, "textord", ">", "\\textgreater", !0),
        $("math", Z, "open", "\u230a", "\\lfloor", !0),
        $("math", Z, "close", "\u230b", "\\rfloor", !0),
        $("math", Z, "open", "\u2308", "\\lceil", !0),
        $("math", Z, "close", "\u2309", "\\rceil", !0),
        $("math", Z, "textord", "\\", "\\backslash"),
        $("math", Z, "textord", "\u2223", "|"),
        $("math", Z, "textord", "\u2223", "\\vert"),
        $("text", Z, "textord", "|", "\\textbar", !0),
        $("math", Z, "textord", "\u2225", "\\|"),
        $("math", Z, "textord", "\u2225", "\\Vert"),
        $("text", Z, "textord", "\u2225", "\\textbardbl"),
        $("text", Z, "textord", "~", "\\textasciitilde"),
        $("text", Z, "textord", "\\", "\\textbackslash"),
        $("text", Z, "textord", "^", "\\textasciicircum"),
        $("math", Z, et, "\u2191", "\\uparrow", !0),
        $("math", Z, et, "\u21d1", "\\Uparrow", !0),
        $("math", Z, et, "\u2193", "\\downarrow", !0),
        $("math", Z, et, "\u21d3", "\\Downarrow", !0),
        $("math", Z, et, "\u2195", "\\updownarrow", !0),
        $("math", Z, et, "\u21d5", "\\Updownarrow", !0),
        $("math", Z, tt, "\u2210", "\\coprod"),
        $("math", Z, tt, "\u22c1", "\\bigvee"),
        $("math", Z, tt, "\u22c0", "\\bigwedge"),
        $("math", Z, tt, "\u2a04", "\\biguplus"),
        $("math", Z, tt, "\u22c2", "\\bigcap"),
        $("math", Z, tt, "\u22c3", "\\bigcup"),
        $("math", Z, tt, "\u222b", "\\int"),
        $("math", Z, tt, "\u222b", "\\intop"),
        $("math", Z, tt, "\u222c", "\\iint"),
        $("math", Z, tt, "\u222d", "\\iiint"),
        $("math", Z, tt, "\u220f", "\\prod"),
        $("math", Z, tt, "\u2211", "\\sum"),
        $("math", Z, tt, "\u2a02", "\\bigotimes"),
        $("math", Z, tt, "\u2a01", "\\bigoplus"),
        $("math", Z, tt, "\u2a00", "\\bigodot"),
        $("math", Z, tt, "\u222e", "\\oint"),
        $("math", Z, tt, "\u2a06", "\\bigsqcup"),
        $("math", Z, tt, "\u222b", "\\smallint"),
        $("text", Z, "inner", "\u2026", "\\textellipsis"),
        $("math", Z, "inner", "\u2026", "\\mathellipsis"),
        $("text", Z, "inner", "\u2026", "\\ldots", !0),
        $("math", Z, "inner", "\u2026", "\\ldots", !0),
        $("math", Z, "inner", "\u22ef", "\\@cdots", !0),
        $("math", Z, "inner", "\u22f1", "\\ddots", !0),
        $("math", Z, "textord", "\u22ee", "\\varvdots"),
        $("math", Z, "accent-token", "\u02ca", "\\acute"),
        $("math", Z, "accent-token", "\u02cb", "\\grave"),
        $("math", Z, "accent-token", "\xa8", "\\ddot"),
        $("math", Z, "accent-token", "~", "\\tilde"),
        $("math", Z, "accent-token", "\u02c9", "\\bar"),
        $("math", Z, "accent-token", "\u02d8", "\\breve"),
        $("math", Z, "accent-token", "\u02c7", "\\check"),
        $("math", Z, "accent-token", "^", "\\hat"),
        $("math", Z, "accent-token", "\u20d7", "\\vec"),
        $("math", Z, "accent-token", "\u02d9", "\\dot"),
        $("math", Z, "accent-token", "\u02da", "\\mathring"),
        $("math", Z, Q, "\ue131", "\\@imath"),
        $("math", Z, Q, "\ue237", "\\@jmath"),
        $("math", Z, "textord", "\u0131", "\u0131"),
        $("math", Z, "textord", "\u0237", "\u0237"),
        $("text", Z, "textord", "\u0131", "\\i", !0),
        $("text", Z, "textord", "\u0237", "\\j", !0),
        $("text", Z, "textord", "\xdf", "\\ss", !0),
        $("text", Z, "textord", "\xe6", "\\ae", !0),
        $("text", Z, "textord", "\u0153", "\\oe", !0),
        $("text", Z, "textord", "\xf8", "\\o", !0),
        $("text", Z, "textord", "\xc6", "\\AE", !0),
        $("text", Z, "textord", "\u0152", "\\OE", !0),
        $("text", Z, "textord", "\xd8", "\\O", !0),
        $("text", Z, "accent-token", "\u02ca", "\\'"),
        $("text", Z, "accent-token", "\u02cb", "\\`"),
        $("text", Z, "accent-token", "\u02c6", "\\^"),
        $("text", Z, "accent-token", "\u02dc", "\\~"),
        $("text", Z, "accent-token", "\u02c9", "\\="),
        $("text", Z, "accent-token", "\u02d8", "\\u"),
        $("text", Z, "accent-token", "\u02d9", "\\."),
        $("text", Z, "accent-token", "\u02da", "\\r"),
        $("text", Z, "accent-token", "\u02c7", "\\v"),
        $("text", Z, "accent-token", "\xa8", '\\"'),
        $("text", Z, "accent-token", "\u02dd", "\\H"),
        $("text", Z, "accent-token", "\u25ef", "\\textcircled");
      var rt = { "--": !0, "---": !0, "``": !0, "''": !0 };
      $("text", Z, "textord", "\u2013", "--", !0),
        $("text", Z, "textord", "\u2013", "\\textendash"),
        $("text", Z, "textord", "\u2014", "---", !0),
        $("text", Z, "textord", "\u2014", "\\textemdash"),
        $("text", Z, "textord", "\u2018", "`", !0),
        $("text", Z, "textord", "\u2018", "\\textquoteleft"),
        $("text", Z, "textord", "\u2019", "'", !0),
        $("text", Z, "textord", "\u2019", "\\textquoteright"),
        $("text", Z, "textord", "\u201c", "``", !0),
        $("text", Z, "textord", "\u201c", "\\textquotedblleft"),
        $("text", Z, "textord", "\u201d", "''", !0),
        $("text", Z, "textord", "\u201d", "\\textquotedblright"),
        $("math", Z, "textord", "\xb0", "\\degree", !0),
        $("text", Z, "textord", "\xb0", "\\degree"),
        $("text", Z, "textord", "\xb0", "\\textdegree", !0),
        $("math", Z, "textord", "\xa3", "\\pounds"),
        $("math", Z, "textord", "\xa3", "\\mathsterling", !0),
        $("text", Z, "textord", "\xa3", "\\pounds"),
        $("text", Z, "textord", "\xa3", "\\textsterling", !0),
        $("math", K, "textord", "\u2720", "\\maltese"),
        $("text", K, "textord", "\u2720", "\\maltese");
      for (var at = 0; at < '0123456789/@."'.length; at++) {
        var nt = '0123456789/@."'.charAt(at);
        $("math", Z, "textord", nt, nt);
      }
      for (var it = 0; it < '0123456789!@*()-=+";:?/.,'.length; it++) {
        var ot = '0123456789!@*()-=+";:?/.,'.charAt(it);
        $("text", Z, "textord", ot, ot);
      }
      for (
        var st = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", lt = 0;
        lt < st.length;
        lt++
      ) {
        var ht = st.charAt(lt);
        $("math", Z, Q, ht, ht), $("text", Z, "textord", ht, ht);
      }
      $("math", K, "textord", "C", "\u2102"),
        $("text", K, "textord", "C", "\u2102"),
        $("math", K, "textord", "H", "\u210d"),
        $("text", K, "textord", "H", "\u210d"),
        $("math", K, "textord", "N", "\u2115"),
        $("text", K, "textord", "N", "\u2115"),
        $("math", K, "textord", "P", "\u2119"),
        $("text", K, "textord", "P", "\u2119"),
        $("math", K, "textord", "Q", "\u211a"),
        $("text", K, "textord", "Q", "\u211a"),
        $("math", K, "textord", "R", "\u211d"),
        $("text", K, "textord", "R", "\u211d"),
        $("math", K, "textord", "Z", "\u2124"),
        $("text", K, "textord", "Z", "\u2124"),
        $("math", Z, Q, "h", "\u210e"),
        $("text", Z, Q, "h", "\u210e");
      for (var mt = "", ct = 0; ct < st.length; ct++) {
        var ut = st.charAt(ct);
        $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56320 + ct))),
          $("text", Z, "textord", ut, mt),
          $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56372 + ct))),
          $("text", Z, "textord", ut, mt),
          $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56424 + ct))),
          $("text", Z, "textord", ut, mt),
          $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56580 + ct))),
          $("text", Z, "textord", ut, mt),
          $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56736 + ct))),
          $("text", Z, "textord", ut, mt),
          $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56788 + ct))),
          $("text", Z, "textord", ut, mt),
          $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56840 + ct))),
          $("text", Z, "textord", ut, mt),
          $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56944 + ct))),
          $("text", Z, "textord", ut, mt),
          ct < 26 &&
            ($("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56632 + ct))),
            $("text", Z, "textord", ut, mt),
            $("math", Z, Q, ut, (mt = String.fromCharCode(55349, 56476 + ct))),
            $("text", Z, "textord", ut, mt));
      }
      $("math", Z, Q, "k", (mt = String.fromCharCode(55349, 56668))),
        $("text", Z, "textord", "k", mt);
      for (var pt = 0; pt < 10; pt++) {
        var dt = pt.toString();
        $("math", Z, Q, dt, (mt = String.fromCharCode(55349, 57294 + pt))),
          $("text", Z, "textord", dt, mt),
          $("math", Z, Q, dt, (mt = String.fromCharCode(55349, 57314 + pt))),
          $("text", Z, "textord", dt, mt),
          $("math", Z, Q, dt, (mt = String.fromCharCode(55349, 57324 + pt))),
          $("text", Z, "textord", dt, mt),
          $("math", Z, Q, dt, (mt = String.fromCharCode(55349, 57334 + pt))),
          $("text", Z, "textord", dt, mt);
      }
      for (var ft = 0; ft < "\xc7\xd0\xde\xe7\xfe".length; ft++) {
        var gt = "\xc7\xd0\xde\xe7\xfe".charAt(ft);
        $("math", Z, Q, gt, gt), $("text", Z, "textord", gt, gt);
      }
      var xt = [
          ["mathbf", "textbf", "Main-Bold"],
          ["mathbf", "textbf", "Main-Bold"],
          ["mathnormal", "textit", "Math-Italic"],
          ["mathnormal", "textit", "Math-Italic"],
          ["boldsymbol", "boldsymbol", "Main-BoldItalic"],
          ["boldsymbol", "boldsymbol", "Main-BoldItalic"],
          ["mathscr", "textscr", "Script-Regular"],
          ["", "", ""],
          ["", "", ""],
          ["", "", ""],
          ["mathfrak", "textfrak", "Fraktur-Regular"],
          ["mathfrak", "textfrak", "Fraktur-Regular"],
          ["mathbb", "textbb", "AMS-Regular"],
          ["mathbb", "textbb", "AMS-Regular"],
          ["", "", ""],
          ["", "", ""],
          ["mathsf", "textsf", "SansSerif-Regular"],
          ["mathsf", "textsf", "SansSerif-Regular"],
          ["mathboldsf", "textboldsf", "SansSerif-Bold"],
          ["mathboldsf", "textboldsf", "SansSerif-Bold"],
          ["mathitsf", "textitsf", "SansSerif-Italic"],
          ["mathitsf", "textitsf", "SansSerif-Italic"],
          ["", "", ""],
          ["", "", ""],
          ["mathtt", "texttt", "Typewriter-Regular"],
          ["mathtt", "texttt", "Typewriter-Regular"],
        ],
        vt = [
          ["mathbf", "textbf", "Main-Bold"],
          ["", "", ""],
          ["mathsf", "textsf", "SansSerif-Regular"],
          ["mathboldsf", "textboldsf", "SansSerif-Bold"],
          ["mathtt", "texttt", "Typewriter-Regular"],
        ],
        bt = [
          [1, 1, 1],
          [2, 1, 1],
          [3, 1, 1],
          [4, 2, 1],
          [5, 2, 1],
          [6, 3, 1],
          [7, 4, 2],
          [8, 6, 3],
          [9, 7, 6],
          [10, 8, 7],
          [11, 10, 9],
        ],
        yt = [0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.2, 1.44, 1.728, 2.074, 2.488],
        wt = function (t, e) {
          return e.size < 2 ? t : bt[t - 1][e.size - 1];
        },
        kt = (function () {
          function t(e) {
            (this.style = void 0),
              (this.color = void 0),
              (this.size = void 0),
              (this.textSize = void 0),
              (this.phantom = void 0),
              (this.font = void 0),
              (this.fontFamily = void 0),
              (this.fontWeight = void 0),
              (this.fontShape = void 0),
              (this.sizeMultiplier = void 0),
              (this.maxSize = void 0),
              (this.minRuleThickness = void 0),
              (this._fontMetrics = void 0),
              (this.style = e.style),
              (this.color = e.color),
              (this.size = e.size || t.BASESIZE),
              (this.textSize = e.textSize || this.size),
              (this.phantom = !!e.phantom),
              (this.font = e.font || ""),
              (this.fontFamily = e.fontFamily || ""),
              (this.fontWeight = e.fontWeight || ""),
              (this.fontShape = e.fontShape || ""),
              (this.sizeMultiplier = yt[this.size - 1]),
              (this.maxSize = e.maxSize),
              (this.minRuleThickness = e.minRuleThickness),
              (this._fontMetrics = void 0);
          }
          var e = t.prototype;
          return (
            (e.extend = function (e) {
              var r = {
                style: this.style,
                size: this.size,
                textSize: this.textSize,
                color: this.color,
                phantom: this.phantom,
                font: this.font,
                fontFamily: this.fontFamily,
                fontWeight: this.fontWeight,
                fontShape: this.fontShape,
                maxSize: this.maxSize,
                minRuleThickness: this.minRuleThickness,
              };
              for (var a in e) e.hasOwnProperty(a) && (r[a] = e[a]);
              return new t(r);
            }),
            (e.havingStyle = function (t) {
              return this.style === t
                ? this
                : this.extend({ style: t, size: wt(this.textSize, t) });
            }),
            (e.havingCrampedStyle = function () {
              return this.havingStyle(this.style.cramp());
            }),
            (e.havingSize = function (t) {
              return this.size === t && this.textSize === t
                ? this
                : this.extend({
                    style: this.style.text(),
                    size: t,
                    textSize: t,
                    sizeMultiplier: yt[t - 1],
                  });
            }),
            (e.havingBaseStyle = function (e) {
              e = e || this.style.text();
              var r = wt(t.BASESIZE, e);
              return this.size === r &&
                this.textSize === t.BASESIZE &&
                this.style === e
                ? this
                : this.extend({ style: e, size: r });
            }),
            (e.havingBaseSizing = function () {
              var t;
              switch (this.style.id) {
                case 4:
                case 5:
                  t = 3;
                  break;
                case 6:
                case 7:
                  t = 1;
                  break;
                default:
                  t = 6;
              }
              return this.extend({ style: this.style.text(), size: t });
            }),
            (e.withColor = function (t) {
              return this.extend({ color: t });
            }),
            (e.withPhantom = function () {
              return this.extend({ phantom: !0 });
            }),
            (e.withFont = function (t) {
              return this.extend({ font: t });
            }),
            (e.withTextFontFamily = function (t) {
              return this.extend({ fontFamily: t, font: "" });
            }),
            (e.withTextFontWeight = function (t) {
              return this.extend({ fontWeight: t, font: "" });
            }),
            (e.withTextFontShape = function (t) {
              return this.extend({ fontShape: t, font: "" });
            }),
            (e.sizingClasses = function (t) {
              return t.size !== this.size
                ? ["sizing", "reset-size" + t.size, "size" + this.size]
                : [];
            }),
            (e.baseSizingClasses = function () {
              return this.size !== t.BASESIZE
                ? ["sizing", "reset-size" + this.size, "size" + t.BASESIZE]
                : [];
            }),
            (e.fontMetrics = function () {
              return (
                this._fontMetrics ||
                  (this._fontMetrics = (function (t) {
                    var e;
                    if (!Y[(e = t >= 5 ? 0 : t >= 3 ? 1 : 2)]) {
                      var r = (Y[e] = { cssEmPerMu: V.quad[e] / 18 });
                      for (var a in V) V.hasOwnProperty(a) && (r[a] = V[a][e]);
                    }
                    return Y[e];
                  })(this.size)),
                this._fontMetrics
              );
            }),
            (e.getColor = function () {
              return this.phantom ? "transparent" : this.color;
            }),
            t
          );
        })();
      kt.BASESIZE = 6;
      var St = kt,
        Mt = {
          pt: 1,
          mm: 7227 / 2540,
          cm: 7227 / 254,
          in: 72.27,
          bp: 1.00375,
          pc: 12,
          dd: 1238 / 1157,
          cc: 14856 / 1157,
          nd: 685 / 642,
          nc: 1370 / 107,
          sp: 1 / 65536,
          px: 1.00375,
        },
        zt = { ex: !0, em: !0, mu: !0 },
        At = function (t) {
          return (
            "string" != typeof t && (t = t.unit),
            t in Mt || t in zt || "ex" === t
          );
        },
        Tt = function (t, e) {
          var r;
          if (t.unit in Mt)
            r = Mt[t.unit] / e.fontMetrics().ptPerEm / e.sizeMultiplier;
          else if ("mu" === t.unit) r = e.fontMetrics().cssEmPerMu;
          else {
            var a;
            if (
              ((a = e.style.isTight() ? e.havingStyle(e.style.text()) : e),
              "ex" === t.unit)
            )
              r = a.fontMetrics().xHeight;
            else {
              if ("em" !== t.unit)
                throw new o("Invalid unit: '" + t.unit + "'");
              r = a.fontMetrics().quad;
            }
            a !== e && (r *= a.sizeMultiplier / e.sizeMultiplier);
          }
          return Math.min(t.number * r, e.maxSize);
        },
        Bt = function (t, e, r) {
          return (
            j[r][t] && j[r][t].replace && (t = j[r][t].replace),
            { value: t, metrics: G(t, e, r) }
          );
        },
        Ct = function (t, e, r, a, n) {
          var i,
            o = Bt(t, e, r),
            s = o.metrics;
          if (((t = o.value), s)) {
            var l = s.italic;
            ("text" === r || (a && "mathit" === a.font)) && (l = 0),
              (i = new E(t, s.height, s.depth, l, s.skew, s.width, n));
          } else
            "undefined" != typeof console &&
              console.warn(
                "No character metrics for '" +
                  t +
                  "' in style '" +
                  e +
                  "' and mode '" +
                  r +
                  "'",
              ),
              (i = new E(t, 0, 0, 0, 0, 0, n));
          if (a) {
            (i.maxFontSize = a.sizeMultiplier),
              a.style.isTight() && i.classes.push("mtight");
            var h = a.getColor();
            h && (i.style.color = h);
          }
          return i;
        },
        qt = function (t, e) {
          if (
            T(t.classes) !== T(e.classes) ||
            t.skew !== e.skew ||
            t.maxFontSize !== e.maxFontSize
          )
            return !1;
          for (var r in t.style)
            if (t.style.hasOwnProperty(r) && t.style[r] !== e.style[r])
              return !1;
          for (var a in e.style)
            if (e.style.hasOwnProperty(a) && t.style[a] !== e.style[a])
              return !1;
          return !0;
        },
        Nt = function (t) {
          for (var e = 0, r = 0, a = 0, n = 0; n < t.children.length; n++) {
            var i = t.children[n];
            i.height > e && (e = i.height),
              i.depth > r && (r = i.depth),
              i.maxFontSize > a && (a = i.maxFontSize);
          }
          (t.height = e), (t.depth = r), (t.maxFontSize = a);
        },
        It = function (t, e, r, a) {
          var n = new N(t, e, r, a);
          return Nt(n), n;
        },
        Ot = function (t, e, r, a) {
          return new N(t, e, r, a);
        },
        Rt = function (t) {
          var e = new A(t);
          return Nt(e), e;
        },
        Et = function (t, e, r) {
          var a = "";
          switch (t) {
            case "amsrm":
              a = "AMS";
              break;
            case "textrm":
              a = "Main";
              break;
            case "textsf":
              a = "SansSerif";
              break;
            case "texttt":
              a = "Typewriter";
              break;
            default:
              a = t;
          }
          return (
            a +
            "-" +
            ("textbf" === e && "textit" === r
              ? "BoldItalic"
              : "textbf" === e
                ? "Bold"
                : "textit" === e
                  ? "Italic"
                  : "Regular")
          );
        },
        Lt = {
          mathbf: { variant: "bold", fontName: "Main-Bold" },
          mathrm: { variant: "normal", fontName: "Main-Regular" },
          textit: { variant: "italic", fontName: "Main-Italic" },
          mathit: { variant: "italic", fontName: "Main-Italic" },
          mathnormal: { variant: "italic", fontName: "Math-Italic" },
          mathbb: { variant: "double-struck", fontName: "AMS-Regular" },
          mathcal: { variant: "script", fontName: "Caligraphic-Regular" },
          mathfrak: { variant: "fraktur", fontName: "Fraktur-Regular" },
          mathscr: { variant: "script", fontName: "Script-Regular" },
          mathsf: { variant: "sans-serif", fontName: "SansSerif-Regular" },
          mathtt: { variant: "monospace", fontName: "Typewriter-Regular" },
        },
        Pt = {
          vec: ["vec", 0.471, 0.714],
          oiintSize1: ["oiintSize1", 0.957, 0.499],
          oiintSize2: ["oiintSize2", 1.472, 0.659],
          oiiintSize1: ["oiiintSize1", 1.304, 0.499],
          oiiintSize2: ["oiiintSize2", 1.98, 0.659],
          leftParenInner: ["leftParenInner", 0.875, 0.3],
          rightParenInner: ["rightParenInner", 0.875, 0.3],
        },
        Dt = {
          fontMap: Lt,
          makeSymbol: Ct,
          mathsym: function (t, e, r, a) {
            return (
              void 0 === a && (a = []),
              "boldsymbol" === r.font && Bt(t, "Main-Bold", e).metrics
                ? Ct(t, "Main-Bold", e, r, a.concat(["mathbf"]))
                : "\\" === t || "main" === j[e][t].font
                  ? Ct(t, "Main-Regular", e, r, a)
                  : Ct(t, "AMS-Regular", e, r, a.concat(["amsrm"]))
            );
          },
          makeSpan: It,
          makeSvgSpan: Ot,
          makeLineSpan: function (t, e, r) {
            var a = It([t], [], e);
            return (
              (a.height = Math.max(
                r || e.fontMetrics().defaultRuleThickness,
                e.minRuleThickness,
              )),
              (a.style.borderBottomWidth = a.height + "em"),
              (a.maxFontSize = 1),
              a
            );
          },
          makeAnchor: function (t, e, r, a) {
            var n = new I(t, e, r, a);
            return Nt(n), n;
          },
          makeFragment: Rt,
          wrapFragment: function (t, e) {
            return t instanceof A ? It([], [t], e) : t;
          },
          makeVList: function (t, e) {
            for (
              var r = (function (t) {
                  if ("individualShift" === t.positionType) {
                    for (
                      var e = t.children,
                        r = [e[0]],
                        a = -e[0].shift - e[0].elem.depth,
                        n = a,
                        i = 1;
                      i < e.length;
                      i++
                    ) {
                      var o = -e[i].shift - n - e[i].elem.depth,
                        s = o - (e[i - 1].elem.height + e[i - 1].elem.depth);
                      (n += o), r.push({ type: "kern", size: s }), r.push(e[i]);
                    }
                    return { children: r, depth: a };
                  }
                  var l;
                  if ("top" === t.positionType) {
                    for (
                      var h = t.positionData, m = 0;
                      m < t.children.length;
                      m++
                    ) {
                      var c = t.children[m];
                      h -=
                        "kern" === c.type
                          ? c.size
                          : c.elem.height + c.elem.depth;
                    }
                    l = h;
                  } else if ("bottom" === t.positionType) l = -t.positionData;
                  else {
                    var u = t.children[0];
                    if ("elem" !== u.type)
                      throw new Error('First child must have type "elem".');
                    if ("shift" === t.positionType)
                      l = -u.elem.depth - t.positionData;
                    else {
                      if ("firstBaseline" !== t.positionType)
                        throw new Error(
                          "Invalid positionType " + t.positionType + ".",
                        );
                      l = -u.elem.depth;
                    }
                  }
                  return { children: t.children, depth: l };
                })(t),
                a = r.children,
                n = r.depth,
                i = 0,
                o = 0;
              o < a.length;
              o++
            ) {
              var s = a[o];
              if ("elem" === s.type) {
                var l = s.elem;
                i = Math.max(i, l.maxFontSize, l.height);
              }
            }
            i += 2;
            var h = It(["pstrut"], []);
            h.style.height = i + "em";
            for (var m = [], c = n, u = n, p = n, d = 0; d < a.length; d++) {
              var f = a[d];
              if ("kern" === f.type) p += f.size;
              else {
                var g = f.elem,
                  x = f.wrapperClasses || [],
                  v = f.wrapperStyle || {},
                  b = It(x, [h, g], void 0, v);
                (b.style.top = -i - p - g.depth + "em"),
                  f.marginLeft && (b.style.marginLeft = f.marginLeft),
                  f.marginRight && (b.style.marginRight = f.marginRight),
                  m.push(b),
                  (p += g.height + g.depth);
              }
              (c = Math.min(c, p)), (u = Math.max(u, p));
            }
            var y,
              w = It(["vlist"], m);
            if (((w.style.height = u + "em"), c < 0)) {
              var k = It([], []),
                S = It(["vlist"], [k]);
              S.style.height = -c + "em";
              var M = It(["vlist-s"], [new E("\u200b")]);
              y = [It(["vlist-r"], [w, M]), It(["vlist-r"], [S])];
            } else y = [It(["vlist-r"], [w])];
            var z = It(["vlist-t"], y);
            return (
              2 === y.length && z.classes.push("vlist-t2"),
              (z.height = u),
              (z.depth = -c),
              z
            );
          },
          makeOrd: function (t, e, r) {
            var a = t.mode,
              n = t.text,
              i = ["mord"],
              s = "math" === a || ("text" === a && e.font),
              l = s ? e.font : e.fontFamily;
            if (55349 === n.charCodeAt(0)) {
              var h = (function (t, e) {
                  var r =
                      1024 * (t.charCodeAt(0) - 55296) +
                      (t.charCodeAt(1) - 56320) +
                      65536,
                    a = "math" === e ? 0 : 1;
                  if (119808 <= r && r < 120484) {
                    var n = Math.floor((r - 119808) / 26);
                    return [xt[n][2], xt[n][a]];
                  }
                  if (120782 <= r && r <= 120831) {
                    var i = Math.floor((r - 120782) / 10);
                    return [vt[i][2], vt[i][a]];
                  }
                  if (120485 === r || 120486 === r) return [xt[0][2], xt[0][a]];
                  if (120486 < r && r < 120782) return ["", ""];
                  throw new o("Unsupported character: " + t);
                })(n, a),
                m = h[0],
                c = h[1];
              return Ct(n, m, a, e, i.concat(c));
            }
            if (l) {
              var u, p;
              if ("boldsymbol" === l) {
                var d = (function (t, e, r, a, n) {
                  return "textord" !== n && Bt(t, "Math-BoldItalic", e).metrics
                    ? { fontName: "Math-BoldItalic", fontClass: "boldsymbol" }
                    : { fontName: "Main-Bold", fontClass: "mathbf" };
                })(n, a, 0, 0, r);
                (u = d.fontName), (p = [d.fontClass]);
              } else
                s
                  ? ((u = Lt[l].fontName), (p = [l]))
                  : ((u = Et(l, e.fontWeight, e.fontShape)),
                    (p = [l, e.fontWeight, e.fontShape]));
              if (Bt(n, u, a).metrics) return Ct(n, u, a, e, i.concat(p));
              if (rt.hasOwnProperty(n) && "Typewriter" === u.substr(0, 10)) {
                for (var f = [], g = 0; g < n.length; g++)
                  f.push(Ct(n[g], u, a, e, i.concat(p)));
                return Rt(f);
              }
            }
            if ("mathord" === r)
              return Ct(n, "Math-Italic", a, e, i.concat(["mathnormal"]));
            if ("textord" === r) {
              var x = j[a][n] && j[a][n].font;
              if ("ams" === x) {
                var v = Et("amsrm", e.fontWeight, e.fontShape);
                return Ct(
                  n,
                  v,
                  a,
                  e,
                  i.concat("amsrm", e.fontWeight, e.fontShape),
                );
              }
              if ("main" !== x && x) {
                var b = Et(x, e.fontWeight, e.fontShape);
                return Ct(n, b, a, e, i.concat(b, e.fontWeight, e.fontShape));
              }
              var y = Et("textrm", e.fontWeight, e.fontShape);
              return Ct(n, y, a, e, i.concat(e.fontWeight, e.fontShape));
            }
            throw new Error("unexpected type: " + r + " in makeOrd");
          },
          makeGlue: function (t, e) {
            var r = It(["mspace"], [], e),
              a = Tt(t, e);
            return (r.style.marginRight = a + "em"), r;
          },
          staticSvg: function (t, e) {
            var r = Pt[t],
              a = r[0],
              n = r[1],
              i = r[2],
              o = new P(a),
              s = new L([o], {
                width: n + "em",
                height: i + "em",
                style: "width:" + n + "em",
                viewBox: "0 0 " + 1e3 * n + " " + 1e3 * i,
                preserveAspectRatio: "xMinYMin",
              }),
              l = Ot(["overlay"], [s], e);
            return (
              (l.height = i),
              (l.style.height = i + "em"),
              (l.style.width = n + "em"),
              l
            );
          },
          svgData: Pt,
          tryCombineChars: function (t) {
            for (var e = 0; e < t.length - 1; e++) {
              var r = t[e],
                a = t[e + 1];
              r instanceof E &&
                a instanceof E &&
                qt(r, a) &&
                ((r.text += a.text),
                (r.height = Math.max(r.height, a.height)),
                (r.depth = Math.max(r.depth, a.depth)),
                (r.italic = a.italic),
                t.splice(e + 1, 1),
                e--);
            }
            return t;
          },
        },
        Ht = { number: 3, unit: "mu" },
        Ft = { number: 4, unit: "mu" },
        Vt = { number: 5, unit: "mu" },
        Ut = {
          mord: { mop: Ht, mbin: Ft, mrel: Vt, minner: Ht },
          mop: { mord: Ht, mop: Ht, mrel: Vt, minner: Ht },
          mbin: { mord: Ft, mop: Ft, mopen: Ft, minner: Ft },
          mrel: { mord: Vt, mop: Vt, mopen: Vt, minner: Vt },
          mopen: {},
          mclose: { mop: Ht, mbin: Ft, mrel: Vt, minner: Ht },
          mpunct: {
            mord: Ht,
            mop: Ht,
            mrel: Vt,
            mopen: Ht,
            mclose: Ht,
            mpunct: Ht,
            minner: Ht,
          },
          minner: {
            mord: Ht,
            mop: Ht,
            mbin: Ft,
            mrel: Vt,
            mopen: Ht,
            mpunct: Ht,
            minner: Ht,
          },
        },
        Gt = {
          mord: { mop: Ht },
          mop: { mord: Ht, mop: Ht },
          mbin: {},
          mrel: {},
          mopen: {},
          mclose: { mop: Ht },
          mpunct: {},
          minner: { mop: Ht },
        },
        Yt = {},
        Wt = {},
        Xt = {};
      function _t(t) {
        for (
          var e = t.type,
            r = t.names,
            a = t.props,
            n = t.handler,
            i = t.htmlBuilder,
            o = t.mathmlBuilder,
            s = {
              type: e,
              numArgs: a.numArgs,
              argTypes: a.argTypes,
              greediness: void 0 === a.greediness ? 1 : a.greediness,
              allowedInText: !!a.allowedInText,
              allowedInMath: void 0 === a.allowedInMath || a.allowedInMath,
              numOptionalArgs: a.numOptionalArgs || 0,
              infix: !!a.infix,
              handler: n,
            },
            l = 0;
          l < r.length;
          ++l
        )
          Yt[r[l]] = s;
        e && (i && (Wt[e] = i), o && (Xt[e] = o));
      }
      function jt(t) {
        _t({
          type: t.type,
          names: [],
          props: { numArgs: 0 },
          handler: function () {
            throw new Error("Should never be called.");
          },
          htmlBuilder: t.htmlBuilder,
          mathmlBuilder: t.mathmlBuilder,
        });
      }
      var $t = function (t) {
          return "ordgroup" === t.type ? t.body : [t];
        },
        Zt = Dt.makeSpan,
        Kt = ["leftmost", "mbin", "mopen", "mrel", "mop", "mpunct"],
        Jt = ["rightmost", "mrel", "mclose", "mpunct"],
        Qt = {
          display: w.DISPLAY,
          text: w.TEXT,
          script: w.SCRIPT,
          scriptscript: w.SCRIPTSCRIPT,
        },
        te = {
          mord: "mord",
          mop: "mop",
          mbin: "mbin",
          mrel: "mrel",
          mopen: "mopen",
          mclose: "mclose",
          mpunct: "mpunct",
          minner: "minner",
        },
        ee = function (t, e, r, a) {
          void 0 === a && (a = [null, null]);
          for (var n = [], i = 0; i < t.length; i++) {
            var o = oe(t[i], e);
            if (o instanceof A) {
              var s = o.children;
              n.push.apply(n, s);
            } else n.push(o);
          }
          if (!r) return n;
          var l = e;
          if (1 === t.length) {
            var h = t[0];
            "sizing" === h.type
              ? (l = e.havingSize(h.size))
              : "styling" === h.type && (l = e.havingStyle(Qt[h.style]));
          }
          var m = Zt([a[0] || "leftmost"], [], e),
            u = Zt([a[1] || "rightmost"], [], e),
            p = "root" === r;
          return (
            re(
              n,
              function (t, e) {
                var r = e.classes[0],
                  a = t.classes[0];
                "mbin" === r && c.contains(Jt, a)
                  ? (e.classes[0] = "mord")
                  : "mbin" === a &&
                    c.contains(Kt, r) &&
                    (t.classes[0] = "mord");
              },
              { node: m },
              u,
              p,
            ),
            re(
              n,
              function (t, e) {
                var r = ne(e),
                  a = ne(t),
                  n =
                    r && a
                      ? t.hasClass("mtight")
                        ? Gt[r][a]
                        : Ut[r][a]
                      : null;
                if (n) return Dt.makeGlue(n, l);
              },
              { node: m },
              u,
              p,
            ),
            n
          );
        },
        re = function t(e, r, a, n, i) {
          n && e.push(n);
          for (var o = 0; o < e.length; o++) {
            var s = e[o],
              l = ae(s);
            if (l) t(l.children, r, a, null, i);
            else {
              var h = !s.hasClass("mspace");
              if (h) {
                var m = r(s, a.node);
                m && (a.insertAfter ? a.insertAfter(m) : (e.unshift(m), o++));
              }
              h
                ? (a.node = s)
                : i && s.hasClass("newline") && (a.node = Zt(["leftmost"])),
                (a.insertAfter = (function (t) {
                  return function (r) {
                    e.splice(t + 1, 0, r), o++;
                  };
                })(o));
            }
          }
          n && e.pop();
        },
        ae = function (t) {
          return t instanceof A ||
            t instanceof I ||
            (t instanceof N && t.hasClass("enclosing"))
            ? t
            : null;
        },
        ne = function (t, e) {
          return t
            ? (e &&
                (t = (function t(e, r) {
                  var a = ae(e);
                  if (a) {
                    var n = a.children;
                    if (n.length) {
                      if ("right" === r) return t(n[n.length - 1], "right");
                      if ("left" === r) return t(n[0], "left");
                    }
                  }
                  return e;
                })(t, e)),
              te[t.classes[0]] || null)
            : null;
        },
        ie = function (t, e) {
          var r = ["nulldelimiter"].concat(t.baseSizingClasses());
          return Zt(e.concat(r));
        },
        oe = function (t, e, r) {
          if (!t) return Zt();
          if (Wt[t.type]) {
            var a = Wt[t.type](t, e);
            if (r && e.size !== r.size) {
              a = Zt(e.sizingClasses(r), [a], e);
              var n = e.sizeMultiplier / r.sizeMultiplier;
              (a.height *= n), (a.depth *= n);
            }
            return a;
          }
          throw new o("Got group of unknown type: '" + t.type + "'");
        };
      function se(t, e) {
        var r = Zt(["base"], t, e),
          a = Zt(["strut"]);
        return (
          (a.style.height = r.height + r.depth + "em"),
          (a.style.verticalAlign = -r.depth + "em"),
          r.children.unshift(a),
          r
        );
      }
      function le(t, e) {
        var r = null;
        1 === t.length &&
          "tag" === t[0].type &&
          ((r = t[0].tag), (t = t[0].body));
        for (
          var a, n = ee(t, e, "root"), i = [], o = [], s = 0;
          s < n.length;
          s++
        )
          if (
            (o.push(n[s]),
            n[s].hasClass("mbin") ||
              n[s].hasClass("mrel") ||
              n[s].hasClass("allowbreak"))
          ) {
            for (
              var l = !1;
              s < n.length - 1 &&
              n[s + 1].hasClass("mspace") &&
              !n[s + 1].hasClass("newline");

            )
              s++, o.push(n[s]), n[s].hasClass("nobreak") && (l = !0);
            l || (i.push(se(o, e)), (o = []));
          } else
            n[s].hasClass("newline") &&
              (o.pop(),
              o.length > 0 && (i.push(se(o, e)), (o = [])),
              i.push(n[s]));
        o.length > 0 && i.push(se(o, e)),
          r && (((a = se(ee(r, e, !0))).classes = ["tag"]), i.push(a));
        var h = Zt(["katex-html"], i);
        if ((h.setAttribute("aria-hidden", "true"), a)) {
          var m = a.children[0];
          (m.style.height = h.height + h.depth + "em"),
            (m.style.verticalAlign = -h.depth + "em");
        }
        return h;
      }
      function he(t) {
        return new A(t);
      }
      var me = (function () {
          function t(t, e) {
            (this.type = void 0),
              (this.attributes = void 0),
              (this.children = void 0),
              (this.type = t),
              (this.attributes = {}),
              (this.children = e || []);
          }
          var e = t.prototype;
          return (
            (e.setAttribute = function (t, e) {
              this.attributes[t] = e;
            }),
            (e.getAttribute = function (t) {
              return this.attributes[t];
            }),
            (e.toNode = function () {
              var t = document.createElementNS(
                "http://www.w3.org/1998/Math/MathML",
                this.type,
              );
              for (var e in this.attributes)
                Object.prototype.hasOwnProperty.call(this.attributes, e) &&
                  t.setAttribute(e, this.attributes[e]);
              for (var r = 0; r < this.children.length; r++)
                t.appendChild(this.children[r].toNode());
              return t;
            }),
            (e.toMarkup = function () {
              var t = "<" + this.type;
              for (var e in this.attributes)
                Object.prototype.hasOwnProperty.call(this.attributes, e) &&
                  ((t += " " + e + '="'),
                  (t += c.escape(this.attributes[e])),
                  (t += '"'));
              t += ">";
              for (var r = 0; r < this.children.length; r++)
                t += this.children[r].toMarkup();
              return (t += "</" + this.type + ">");
            }),
            (e.toText = function () {
              return this.children
                .map(function (t) {
                  return t.toText();
                })
                .join("");
            }),
            t
          );
        })(),
        ce = (function () {
          function t(t) {
            (this.text = void 0), (this.text = t);
          }
          var e = t.prototype;
          return (
            (e.toNode = function () {
              return document.createTextNode(this.text);
            }),
            (e.toMarkup = function () {
              return c.escape(this.toText());
            }),
            (e.toText = function () {
              return this.text;
            }),
            t
          );
        })(),
        ue = {
          MathNode: me,
          TextNode: ce,
          SpaceNode: (function () {
            function t(t) {
              (this.width = void 0),
                (this.character = void 0),
                (this.width = t),
                (this.character =
                  t >= 0.05555 && t <= 0.05556
                    ? "\u200a"
                    : t >= 0.1666 && t <= 0.1667
                      ? "\u2009"
                      : t >= 0.2222 && t <= 0.2223
                        ? "\u2005"
                        : t >= 0.2777 && t <= 0.2778
                          ? "\u2005\u200a"
                          : t >= -0.05556 && t <= -0.05555
                            ? "\u200a\u2063"
                            : t >= -0.1667 && t <= -0.1666
                              ? "\u2009\u2063"
                              : t >= -0.2223 && t <= -0.2222
                                ? "\u205f\u2063"
                                : t >= -0.2778 && t <= -0.2777
                                  ? "\u2005\u2063"
                                  : null);
            }
            var e = t.prototype;
            return (
              (e.toNode = function () {
                if (this.character)
                  return document.createTextNode(this.character);
                var t = document.createElementNS(
                  "http://www.w3.org/1998/Math/MathML",
                  "mspace",
                );
                return t.setAttribute("width", this.width + "em"), t;
              }),
              (e.toMarkup = function () {
                return this.character
                  ? "<mtext>" + this.character + "</mtext>"
                  : '<mspace width="' + this.width + 'em"/>';
              }),
              (e.toText = function () {
                return this.character ? this.character : " ";
              }),
              t
            );
          })(),
          newDocumentFragment: he,
        },
        pe = function (t, e, r) {
          return (
            !j[e][t] ||
              !j[e][t].replace ||
              55349 === t.charCodeAt(0) ||
              (rt.hasOwnProperty(t) &&
                r &&
                ((r.fontFamily && "tt" === r.fontFamily.substr(4, 2)) ||
                  (r.font && "tt" === r.font.substr(4, 2)))) ||
              (t = j[e][t].replace),
            new ue.TextNode(t)
          );
        },
        de = function (t) {
          return 1 === t.length ? t[0] : new ue.MathNode("mrow", t);
        },
        fe = function (t, e) {
          if ("texttt" === e.fontFamily) return "monospace";
          if ("textsf" === e.fontFamily)
            return "textit" === e.fontShape && "textbf" === e.fontWeight
              ? "sans-serif-bold-italic"
              : "textit" === e.fontShape
                ? "sans-serif-italic"
                : "textbf" === e.fontWeight
                  ? "bold-sans-serif"
                  : "sans-serif";
          if ("textit" === e.fontShape && "textbf" === e.fontWeight)
            return "bold-italic";
          if ("textit" === e.fontShape) return "italic";
          if ("textbf" === e.fontWeight) return "bold";
          var r = e.font;
          if (!r || "mathnormal" === r) return null;
          var a = t.mode;
          if ("mathit" === r) return "italic";
          if ("boldsymbol" === r)
            return "textord" === t.type ? "bold" : "bold-italic";
          if ("mathbf" === r) return "bold";
          if ("mathbb" === r) return "double-struck";
          if ("mathfrak" === r) return "fraktur";
          if ("mathscr" === r || "mathcal" === r) return "script";
          if ("mathsf" === r) return "sans-serif";
          if ("mathtt" === r) return "monospace";
          var n = t.text;
          return c.contains(["\\imath", "\\jmath"], n)
            ? null
            : (j[a][n] && j[a][n].replace && (n = j[a][n].replace),
              G(n, Dt.fontMap[r].fontName, a) ? Dt.fontMap[r].variant : null);
        },
        ge = function (t, e, r) {
          if (1 === t.length) {
            var a = ve(t[0], e);
            return (
              r &&
                a instanceof me &&
                "mo" === a.type &&
                (a.setAttribute("lspace", "0em"),
                a.setAttribute("rspace", "0em")),
              [a]
            );
          }
          for (var n, i = [], o = 0; o < t.length; o++) {
            var s = ve(t[o], e);
            if (s instanceof me && n instanceof me) {
              if (
                "mtext" === s.type &&
                "mtext" === n.type &&
                s.getAttribute("mathvariant") === n.getAttribute("mathvariant")
              ) {
                var l;
                (l = n.children).push.apply(l, s.children);
                continue;
              }
              if ("mn" === s.type && "mn" === n.type) {
                var h;
                (h = n.children).push.apply(h, s.children);
                continue;
              }
              if (
                "mi" === s.type &&
                1 === s.children.length &&
                "mn" === n.type
              ) {
                var m = s.children[0];
                if (m instanceof ce && "." === m.text) {
                  var c;
                  (c = n.children).push.apply(c, s.children);
                  continue;
                }
              } else if ("mi" === n.type && 1 === n.children.length) {
                var u = n.children[0];
                if (
                  u instanceof ce &&
                  "\u0338" === u.text &&
                  ("mo" === s.type || "mi" === s.type || "mn" === s.type)
                ) {
                  var p = s.children[0];
                  p instanceof ce &&
                    p.text.length > 0 &&
                    ((p.text = p.text.slice(0, 1) + "\u0338" + p.text.slice(1)),
                    i.pop());
                }
              }
            }
            i.push(s), (n = s);
          }
          return i;
        },
        xe = function (t, e, r) {
          return de(ge(t, e, r));
        },
        ve = function (t, e) {
          if (!t) return new ue.MathNode("mrow");
          if (Xt[t.type]) return Xt[t.type](t, e);
          throw new o("Got group of unknown type: '" + t.type + "'");
        };
      function be(t, e, r, a, n) {
        var i,
          o = ge(t, r);
        i =
          1 === o.length &&
          o[0] instanceof me &&
          c.contains(["mrow", "mtable"], o[0].type)
            ? o[0]
            : new ue.MathNode("mrow", o);
        var s = new ue.MathNode("annotation", [new ue.TextNode(e)]);
        s.setAttribute("encoding", "application/x-tex");
        var l = new ue.MathNode("semantics", [i, s]),
          h = new ue.MathNode("math", [l]);
        h.setAttribute("xmlns", "http://www.w3.org/1998/Math/MathML"),
          a && h.setAttribute("display", "block");
        var m = n ? "katex" : "katex-mathml";
        return Dt.makeSpan([m], [h]);
      }
      var ye = function (t) {
          return new St({
            style: t.displayMode ? w.DISPLAY : w.TEXT,
            maxSize: t.maxSize,
            minRuleThickness: t.minRuleThickness,
          });
        },
        we = function (t, e) {
          if (e.displayMode) {
            var r = ["katex-display"];
            e.leqno && r.push("leqno"),
              e.fleqn && r.push("fleqn"),
              (t = Dt.makeSpan(r, [t]));
          }
          return t;
        },
        ke = function (t, e, r) {
          var a,
            n = ye(r);
          if ("mathml" === r.output) return be(t, e, n, r.displayMode, !0);
          if ("html" === r.output) {
            var i = le(t, n);
            a = Dt.makeSpan(["katex"], [i]);
          } else {
            var o = be(t, e, n, r.displayMode, !1),
              s = le(t, n);
            a = Dt.makeSpan(["katex"], [o, s]);
          }
          return we(a, r);
        },
        Se = {
          widehat: "^",
          widecheck: "\u02c7",
          widetilde: "~",
          utilde: "~",
          overleftarrow: "\u2190",
          underleftarrow: "\u2190",
          xleftarrow: "\u2190",
          overrightarrow: "\u2192",
          underrightarrow: "\u2192",
          xrightarrow: "\u2192",
          underbrace: "\u23df",
          overbrace: "\u23de",
          overgroup: "\u23e0",
          undergroup: "\u23e1",
          overleftrightarrow: "\u2194",
          underleftrightarrow: "\u2194",
          xleftrightarrow: "\u2194",
          Overrightarrow: "\u21d2",
          xRightarrow: "\u21d2",
          overleftharpoon: "\u21bc",
          xleftharpoonup: "\u21bc",
          overrightharpoon: "\u21c0",
          xrightharpoonup: "\u21c0",
          xLeftarrow: "\u21d0",
          xLeftrightarrow: "\u21d4",
          xhookleftarrow: "\u21a9",
          xhookrightarrow: "\u21aa",
          xmapsto: "\u21a6",
          xrightharpoondown: "\u21c1",
          xleftharpoondown: "\u21bd",
          xrightleftharpoons: "\u21cc",
          xleftrightharpoons: "\u21cb",
          xtwoheadleftarrow: "\u219e",
          xtwoheadrightarrow: "\u21a0",
          xlongequal: "=",
          xtofrom: "\u21c4",
          xrightleftarrows: "\u21c4",
          xrightequilibrium: "\u21cc",
          xleftequilibrium: "\u21cb",
        },
        Me = {
          overrightarrow: [["rightarrow"], 0.888, 522, "xMaxYMin"],
          overleftarrow: [["leftarrow"], 0.888, 522, "xMinYMin"],
          underrightarrow: [["rightarrow"], 0.888, 522, "xMaxYMin"],
          underleftarrow: [["leftarrow"], 0.888, 522, "xMinYMin"],
          xrightarrow: [["rightarrow"], 1.469, 522, "xMaxYMin"],
          xleftarrow: [["leftarrow"], 1.469, 522, "xMinYMin"],
          Overrightarrow: [["doublerightarrow"], 0.888, 560, "xMaxYMin"],
          xRightarrow: [["doublerightarrow"], 1.526, 560, "xMaxYMin"],
          xLeftarrow: [["doubleleftarrow"], 1.526, 560, "xMinYMin"],
          overleftharpoon: [["leftharpoon"], 0.888, 522, "xMinYMin"],
          xleftharpoonup: [["leftharpoon"], 0.888, 522, "xMinYMin"],
          xleftharpoondown: [["leftharpoondown"], 0.888, 522, "xMinYMin"],
          overrightharpoon: [["rightharpoon"], 0.888, 522, "xMaxYMin"],
          xrightharpoonup: [["rightharpoon"], 0.888, 522, "xMaxYMin"],
          xrightharpoondown: [["rightharpoondown"], 0.888, 522, "xMaxYMin"],
          xlongequal: [["longequal"], 0.888, 334, "xMinYMin"],
          xtwoheadleftarrow: [["twoheadleftarrow"], 0.888, 334, "xMinYMin"],
          xtwoheadrightarrow: [["twoheadrightarrow"], 0.888, 334, "xMaxYMin"],
          overleftrightarrow: [["leftarrow", "rightarrow"], 0.888, 522],
          overbrace: [["leftbrace", "midbrace", "rightbrace"], 1.6, 548],
          underbrace: [
            ["leftbraceunder", "midbraceunder", "rightbraceunder"],
            1.6,
            548,
          ],
          underleftrightarrow: [["leftarrow", "rightarrow"], 0.888, 522],
          xleftrightarrow: [["leftarrow", "rightarrow"], 1.75, 522],
          xLeftrightarrow: [["doubleleftarrow", "doublerightarrow"], 1.75, 560],
          xrightleftharpoons: [
            ["leftharpoondownplus", "rightharpoonplus"],
            1.75,
            716,
          ],
          xleftrightharpoons: [
            ["leftharpoonplus", "rightharpoondownplus"],
            1.75,
            716,
          ],
          xhookleftarrow: [["leftarrow", "righthook"], 1.08, 522],
          xhookrightarrow: [["lefthook", "rightarrow"], 1.08, 522],
          overlinesegment: [
            ["leftlinesegment", "rightlinesegment"],
            0.888,
            522,
          ],
          underlinesegment: [
            ["leftlinesegment", "rightlinesegment"],
            0.888,
            522,
          ],
          overgroup: [["leftgroup", "rightgroup"], 0.888, 342],
          undergroup: [["leftgroupunder", "rightgroupunder"], 0.888, 342],
          xmapsto: [["leftmapsto", "rightarrow"], 1.5, 522],
          xtofrom: [["leftToFrom", "rightToFrom"], 1.75, 528],
          xrightleftarrows: [
            ["baraboveleftarrow", "rightarrowabovebar"],
            1.75,
            901,
          ],
          xrightequilibrium: [
            ["baraboveshortleftharpoon", "rightharpoonaboveshortbar"],
            1.75,
            716,
          ],
          xleftequilibrium: [
            ["shortbaraboveleftharpoon", "shortrightharpoonabovebar"],
            1.75,
            716,
          ],
        },
        ze = function (t) {
          return "ordgroup" === t.type ? t.body.length : 1;
        },
        Ae = function (t, e, r, a) {
          var n,
            i = t.height + t.depth + 2 * r;
          if (/fbox|color/.test(e)) {
            if (((n = Dt.makeSpan(["stretchy", e], [], a)), "fbox" === e)) {
              var o = a.color && a.getColor();
              o && (n.style.borderColor = o);
            }
          } else {
            var s = [];
            /^[bx]cancel$/.test(e) &&
              s.push(
                new D({
                  x1: "0",
                  y1: "0",
                  x2: "100%",
                  y2: "100%",
                  "stroke-width": "0.046em",
                }),
              ),
              /^x?cancel$/.test(e) &&
                s.push(
                  new D({
                    x1: "0",
                    y1: "100%",
                    x2: "100%",
                    y2: "0",
                    "stroke-width": "0.046em",
                  }),
                );
            var l = new L(s, { width: "100%", height: i + "em" });
            n = Dt.makeSvgSpan([], [l], a);
          }
          return (n.height = i), (n.style.height = i + "em"), n;
        },
        Te = function (t) {
          var e = new ue.MathNode("mo", [new ue.TextNode(Se[t.substr(1)])]);
          return e.setAttribute("stretchy", "true"), e;
        },
        Be = function (t, e) {
          var r = (function () {
              var r = 4e5,
                a = t.label.substr(1);
              if (
                c.contains(["widehat", "widecheck", "widetilde", "utilde"], a)
              ) {
                var n,
                  i,
                  o,
                  s = ze(t.base);
                if (s > 5)
                  "widehat" === a || "widecheck" === a
                    ? ((n = 420), (r = 2364), (o = 0.42), (i = a + "4"))
                    : ((n = 312), (r = 2340), (o = 0.34), (i = "tilde4"));
                else {
                  var l = [1, 1, 2, 2, 3, 3][s];
                  "widehat" === a || "widecheck" === a
                    ? ((r = [0, 1062, 2364, 2364, 2364][l]),
                      (n = [0, 239, 300, 360, 420][l]),
                      (o = [0, 0.24, 0.3, 0.3, 0.36, 0.42][l]),
                      (i = a + l))
                    : ((r = [0, 600, 1033, 2339, 2340][l]),
                      (n = [0, 260, 286, 306, 312][l]),
                      (o = [0, 0.26, 0.286, 0.3, 0.306, 0.34][l]),
                      (i = "tilde" + l));
                }
                var h = new P(i),
                  m = new L([h], {
                    width: "100%",
                    height: o + "em",
                    viewBox: "0 0 " + r + " " + n,
                    preserveAspectRatio: "none",
                  });
                return {
                  span: Dt.makeSvgSpan([], [m], e),
                  minWidth: 0,
                  height: o,
                };
              }
              var u,
                p,
                d = [],
                f = Me[a],
                g = f[0],
                x = f[1],
                v = f[2],
                b = v / 1e3,
                y = g.length;
              if (1 === y) (u = ["hide-tail"]), (p = [f[3]]);
              else if (2 === y)
                (u = ["halfarrow-left", "halfarrow-right"]),
                  (p = ["xMinYMin", "xMaxYMin"]);
              else {
                if (3 !== y)
                  throw new Error(
                    "Correct katexImagesData or update code here to support\n                    " +
                      y +
                      " children.",
                  );
                (u = ["brace-left", "brace-center", "brace-right"]),
                  (p = ["xMinYMin", "xMidYMin", "xMaxYMin"]);
              }
              for (var w = 0; w < y; w++) {
                var k = new P(g[w]),
                  S = new L([k], {
                    width: "400em",
                    height: b + "em",
                    viewBox: "0 0 " + r + " " + v,
                    preserveAspectRatio: p[w] + " slice",
                  }),
                  M = Dt.makeSvgSpan([u[w]], [S], e);
                if (1 === y) return { span: M, minWidth: x, height: b };
                (M.style.height = b + "em"), d.push(M);
              }
              return {
                span: Dt.makeSpan(["stretchy"], d, e),
                minWidth: x,
                height: b,
              };
            })(),
            a = r.span,
            n = r.minWidth,
            i = r.height;
          return (
            (a.height = i),
            (a.style.height = i + "em"),
            n > 0 && (a.style.minWidth = n + "em"),
            a
          );
        };
      function Ce(t, e) {
        if (!t || t.type !== e)
          throw new Error(
            "Expected node of type " +
              e +
              ", but got " +
              (t ? "node of type " + t.type : String(t)),
          );
        return t;
      }
      function qe(t) {
        var e = Ne(t);
        if (!e)
          throw new Error(
            "Expected node of symbol group type, but got " +
              (t ? "node of type " + t.type : String(t)),
          );
        return e;
      }
      function Ne(t) {
        return t && ("atom" === t.type || X.hasOwnProperty(t.type)) ? t : null;
      }
      var Ie = function (t, e) {
          var r, a, n;
          t && "supsub" === t.type
            ? ((r = (a = Ce(t.base, "accent")).base),
              (t.base = r),
              (n = (function (t) {
                if (t instanceof N) return t;
                throw new Error(
                  "Expected span<HtmlDomNode> but got " + String(t) + ".",
                );
              })(oe(t, e))),
              (t.base = a))
            : (r = (a = Ce(t, "accent")).base);
          var i = oe(r, e.havingCrampedStyle()),
            o = 0;
          if (a.isShifty && c.isCharacterBox(r)) {
            var s = c.getBaseElem(r);
            o = H(oe(s, e.havingCrampedStyle())).skew;
          }
          var l,
            h = Math.min(i.height, e.fontMetrics().xHeight);
          if (a.isStretchy)
            (l = Be(a, e)),
              (l = Dt.makeVList(
                {
                  positionType: "firstBaseline",
                  children: [
                    { type: "elem", elem: i },
                    {
                      type: "elem",
                      elem: l,
                      wrapperClasses: ["svg-align"],
                      wrapperStyle:
                        o > 0
                          ? {
                              width: "calc(100% - " + 2 * o + "em)",
                              marginLeft: 2 * o + "em",
                            }
                          : void 0,
                    },
                  ],
                },
                e,
              ));
          else {
            var m, u;
            "\\vec" === a.label
              ? ((m = Dt.staticSvg("vec", e)), (u = Dt.svgData.vec[1]))
              : (((m = H(
                  (m = Dt.makeOrd(
                    { mode: a.mode, text: a.label },
                    e,
                    "textord",
                  )),
                )).italic = 0),
                (u = m.width)),
              (l = Dt.makeSpan(["accent-body"], [m]));
            var p = "\\textcircled" === a.label;
            p && (l.classes.push("accent-full"), (h = i.height));
            var d = o;
            p || (d -= u / 2),
              (l.style.left = d + "em"),
              "\\textcircled" === a.label && (l.style.top = ".2em"),
              (l = Dt.makeVList(
                {
                  positionType: "firstBaseline",
                  children: [
                    { type: "elem", elem: i },
                    { type: "kern", size: -h },
                    { type: "elem", elem: l },
                  ],
                },
                e,
              ));
          }
          var f = Dt.makeSpan(["mord", "accent"], [l], e);
          return n
            ? ((n.children[0] = f),
              (n.height = Math.max(f.height, n.height)),
              (n.classes[0] = "mord"),
              n)
            : f;
        },
        Oe = function (t, e) {
          var r = t.isStretchy
              ? Te(t.label)
              : new ue.MathNode("mo", [pe(t.label, t.mode)]),
            a = new ue.MathNode("mover", [ve(t.base, e), r]);
          return a.setAttribute("accent", "true"), a;
        },
        Re = new RegExp(
          [
            "\\acute",
            "\\grave",
            "\\ddot",
            "\\tilde",
            "\\bar",
            "\\breve",
            "\\check",
            "\\hat",
            "\\vec",
            "\\dot",
            "\\mathring",
          ]
            .map(function (t) {
              return "\\" + t;
            })
            .join("|"),
        );
      _t({
        type: "accent",
        names: [
          "\\acute",
          "\\grave",
          "\\ddot",
          "\\tilde",
          "\\bar",
          "\\breve",
          "\\check",
          "\\hat",
          "\\vec",
          "\\dot",
          "\\mathring",
          "\\widecheck",
          "\\widehat",
          "\\widetilde",
          "\\overrightarrow",
          "\\overleftarrow",
          "\\Overrightarrow",
          "\\overleftrightarrow",
          "\\overgroup",
          "\\overlinesegment",
          "\\overleftharpoon",
          "\\overrightharpoon",
        ],
        props: { numArgs: 1 },
        handler: function (t, e) {
          var r = e[0],
            a = !Re.test(t.funcName),
            n =
              !a ||
              "\\widehat" === t.funcName ||
              "\\widetilde" === t.funcName ||
              "\\widecheck" === t.funcName;
          return {
            type: "accent",
            mode: t.parser.mode,
            label: t.funcName,
            isStretchy: a,
            isShifty: n,
            base: r,
          };
        },
        htmlBuilder: Ie,
        mathmlBuilder: Oe,
      }),
        _t({
          type: "accent",
          names: [
            "\\'",
            "\\`",
            "\\^",
            "\\~",
            "\\=",
            "\\u",
            "\\.",
            '\\"',
            "\\r",
            "\\H",
            "\\v",
            "\\textcircled",
          ],
          props: { numArgs: 1, allowedInText: !0, allowedInMath: !1 },
          handler: function (t, e) {
            var r = e[0];
            return {
              type: "accent",
              mode: t.parser.mode,
              label: t.funcName,
              isStretchy: !1,
              isShifty: !0,
              base: r,
            };
          },
          htmlBuilder: Ie,
          mathmlBuilder: Oe,
        }),
        _t({
          type: "accentUnder",
          names: [
            "\\underleftarrow",
            "\\underrightarrow",
            "\\underleftrightarrow",
            "\\undergroup",
            "\\underlinesegment",
            "\\utilde",
          ],
          props: { numArgs: 1 },
          handler: function (t, e) {
            var r = t.parser,
              a = t.funcName,
              n = e[0];
            return { type: "accentUnder", mode: r.mode, label: a, base: n };
          },
          htmlBuilder: function (t, e) {
            var r = oe(t.base, e),
              a = Be(t, e),
              n = "\\utilde" === t.label ? 0.12 : 0,
              i = Dt.makeVList(
                {
                  positionType: "top",
                  positionData: r.height,
                  children: [
                    { type: "elem", elem: a, wrapperClasses: ["svg-align"] },
                    { type: "kern", size: n },
                    { type: "elem", elem: r },
                  ],
                },
                e,
              );
            return Dt.makeSpan(["mord", "accentunder"], [i], e);
          },
          mathmlBuilder: function (t, e) {
            var r = Te(t.label),
              a = new ue.MathNode("munder", [ve(t.base, e), r]);
            return a.setAttribute("accentunder", "true"), a;
          },
        });
      var Ee = function (t) {
        var e = new ue.MathNode("mpadded", t ? [t] : []);
        return (
          e.setAttribute("width", "+0.6em"),
          e.setAttribute("lspace", "0.3em"),
          e
        );
      };
      _t({
        type: "xArrow",
        names: [
          "\\xleftarrow",
          "\\xrightarrow",
          "\\xLeftarrow",
          "\\xRightarrow",
          "\\xleftrightarrow",
          "\\xLeftrightarrow",
          "\\xhookleftarrow",
          "\\xhookrightarrow",
          "\\xmapsto",
          "\\xrightharpoondown",
          "\\xrightharpoonup",
          "\\xleftharpoondown",
          "\\xleftharpoonup",
          "\\xrightleftharpoons",
          "\\xleftrightharpoons",
          "\\xlongequal",
          "\\xtwoheadrightarrow",
          "\\xtwoheadleftarrow",
          "\\xtofrom",
          "\\xrightleftarrows",
          "\\xrightequilibrium",
          "\\xleftequilibrium",
        ],
        props: { numArgs: 1, numOptionalArgs: 1 },
        handler: function (t, e, r) {
          var a = t.parser,
            n = t.funcName;
          return {
            type: "xArrow",
            mode: a.mode,
            label: n,
            body: e[0],
            below: r[0],
          };
        },
        htmlBuilder: function (t, e) {
          var r,
            a = e.style,
            n = e.havingStyle(a.sup()),
            i = Dt.wrapFragment(oe(t.body, n, e), e);
          i.classes.push("x-arrow-pad"),
            t.below &&
              ((n = e.havingStyle(a.sub())),
              (r = Dt.wrapFragment(oe(t.below, n, e), e)).classes.push(
                "x-arrow-pad",
              ));
          var o,
            s = Be(t, e),
            l = -e.fontMetrics().axisHeight + 0.5 * s.height,
            h = -e.fontMetrics().axisHeight - 0.5 * s.height - 0.111;
          if (
            ((i.depth > 0.25 || "\\xleftequilibrium" === t.label) &&
              (h -= i.depth),
            r)
          ) {
            var m =
              -e.fontMetrics().axisHeight + r.height + 0.5 * s.height + 0.111;
            o = Dt.makeVList(
              {
                positionType: "individualShift",
                children: [
                  { type: "elem", elem: i, shift: h },
                  { type: "elem", elem: s, shift: l },
                  { type: "elem", elem: r, shift: m },
                ],
              },
              e,
            );
          } else
            o = Dt.makeVList(
              {
                positionType: "individualShift",
                children: [
                  { type: "elem", elem: i, shift: h },
                  { type: "elem", elem: s, shift: l },
                ],
              },
              e,
            );
          return (
            o.children[0].children[0].children[1].classes.push("svg-align"),
            Dt.makeSpan(["mrel", "x-arrow"], [o], e)
          );
        },
        mathmlBuilder: function (t, e) {
          var r,
            a = Te(t.label);
          if (t.body) {
            var n = Ee(ve(t.body, e));
            if (t.below) {
              var i = Ee(ve(t.below, e));
              r = new ue.MathNode("munderover", [a, i, n]);
            } else r = new ue.MathNode("mover", [a, n]);
          } else if (t.below) {
            var o = Ee(ve(t.below, e));
            r = new ue.MathNode("munder", [a, o]);
          } else (r = Ee()), (r = new ue.MathNode("mover", [a, r]));
          return r;
        },
      }),
        _t({
          type: "textord",
          names: ["\\@char"],
          props: { numArgs: 1, allowedInText: !0 },
          handler: function (t, e) {
            for (
              var r = t.parser, a = Ce(e[0], "ordgroup").body, n = "", i = 0;
              i < a.length;
              i++
            ) {
              n += Ce(a[i], "textord").text;
            }
            var s = parseInt(n);
            if (isNaN(s)) throw new o("\\@char has non-numeric argument " + n);
            return {
              type: "textord",
              mode: r.mode,
              text: String.fromCharCode(s),
            };
          },
        });
      var Le = function (t, e) {
          var r = ee(t.body, e.withColor(t.color), !1);
          return Dt.makeFragment(r);
        },
        Pe = function (t, e) {
          var r = ge(t.body, e.withColor(t.color)),
            a = new ue.MathNode("mstyle", r);
          return a.setAttribute("mathcolor", t.color), a;
        };
      _t({
        type: "color",
        names: ["\\textcolor"],
        props: {
          numArgs: 2,
          allowedInText: !0,
          greediness: 3,
          argTypes: ["color", "original"],
        },
        handler: function (t, e) {
          var r = t.parser,
            a = Ce(e[0], "color-token").color,
            n = e[1];
          return { type: "color", mode: r.mode, color: a, body: $t(n) };
        },
        htmlBuilder: Le,
        mathmlBuilder: Pe,
      }),
        _t({
          type: "color",
          names: ["\\color"],
          props: {
            numArgs: 1,
            allowedInText: !0,
            greediness: 3,
            argTypes: ["color"],
          },
          handler: function (t, e) {
            var r = t.parser,
              a = t.breakOnTokenText,
              n = Ce(e[0], "color-token").color;
            r.gullet.macros.set("\\current@color", n);
            var i = r.parseExpression(!0, a);
            return { type: "color", mode: r.mode, color: n, body: i };
          },
          htmlBuilder: Le,
          mathmlBuilder: Pe,
        }),
        _t({
          type: "cr",
          names: ["\\cr", "\\newline"],
          props: {
            numArgs: 0,
            numOptionalArgs: 1,
            argTypes: ["size"],
            allowedInText: !0,
          },
          handler: function (t, e, r) {
            var a = t.parser,
              n = t.funcName,
              i = r[0],
              o = "\\cr" === n,
              s = !1;
            return (
              o ||
                (s =
                  !a.settings.displayMode ||
                  !a.settings.useStrictBehavior(
                    "newLineInDisplayMode",
                    "In LaTeX, \\\\ or \\newline does nothing in display mode",
                  )),
              {
                type: "cr",
                mode: a.mode,
                newLine: s,
                newRow: o,
                size: i && Ce(i, "size").value,
              }
            );
          },
          htmlBuilder: function (t, e) {
            if (t.newRow)
              throw new o("\\cr valid only within a tabular/array environment");
            var r = Dt.makeSpan(["mspace"], [], e);
            return (
              t.newLine &&
                (r.classes.push("newline"),
                t.size && (r.style.marginTop = Tt(t.size, e) + "em")),
              r
            );
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.MathNode("mspace");
            return (
              t.newLine &&
                (r.setAttribute("linebreak", "newline"),
                t.size && r.setAttribute("height", Tt(t.size, e) + "em")),
              r
            );
          },
        });
      var De = {
          "\\global": "\\global",
          "\\long": "\\\\globallong",
          "\\\\globallong": "\\\\globallong",
          "\\def": "\\gdef",
          "\\gdef": "\\gdef",
          "\\edef": "\\xdef",
          "\\xdef": "\\xdef",
          "\\let": "\\\\globallet",
          "\\futurelet": "\\\\globalfuture",
        },
        He = function (t) {
          var e = t.text;
          if (/^(?:[\\{}$&#^_]|EOF)$/.test(e))
            throw new o("Expected a control sequence", t);
          return e;
        },
        Fe = function (t, e, r, a) {
          var n = t.gullet.macros.get(r.text);
          null == n &&
            ((r.noexpand = !0),
            (n = {
              tokens: [r],
              numArgs: 0,
              unexpandable: !t.gullet.isExpandable(r.text),
            })),
            t.gullet.macros.set(e, n, a);
        };
      _t({
        type: "internal",
        names: ["\\global", "\\long", "\\\\globallong"],
        props: { numArgs: 0, allowedInText: !0 },
        handler: function (t) {
          var e = t.parser,
            r = t.funcName;
          e.consumeSpaces();
          var a = e.fetch();
          if (De[a.text])
            return (
              ("\\global" !== r && "\\\\globallong" !== r) ||
                (a.text = De[a.text]),
              Ce(e.parseFunction(), "internal")
            );
          throw new o("Invalid token after macro prefix", a);
        },
      }),
        _t({
          type: "internal",
          names: ["\\def", "\\gdef", "\\edef", "\\xdef"],
          props: { numArgs: 0, allowedInText: !0 },
          handler: function (t) {
            var e = t.parser,
              r = t.funcName,
              a = e.gullet.consumeArgs(1)[0];
            if (1 !== a.length)
              throw new o("\\gdef's first argument must be a macro name");
            var n = a[0].text,
              i = 0;
            for (
              a = e.gullet.consumeArgs(1)[0];
              1 === a.length && "#" === a[0].text;

            ) {
              if (1 !== (a = e.gullet.consumeArgs(1)[0]).length)
                throw new o(
                  'Invalid argument number length "' + a.length + '"',
                );
              if (!/^[1-9]$/.test(a[0].text))
                throw new o('Invalid argument number "' + a[0].text + '"');
              if ((i++, parseInt(a[0].text) !== i))
                throw new o('Argument number "' + a[0].text + '" out of order');
              a = e.gullet.consumeArgs(1)[0];
            }
            return (
              ("\\edef" !== r && "\\xdef" !== r) ||
                (a = e.gullet.expandTokens(a)).reverse(),
              e.gullet.macros.set(n, { tokens: a, numArgs: i }, r === De[r]),
              { type: "internal", mode: e.mode }
            );
          },
        }),
        _t({
          type: "internal",
          names: ["\\let", "\\\\globallet"],
          props: { numArgs: 0, allowedInText: !0 },
          handler: function (t) {
            var e = t.parser,
              r = t.funcName,
              a = He(e.gullet.popToken());
            e.gullet.consumeSpaces();
            var n = (function (t) {
              var e = t.gullet.popToken();
              return (
                "=" === e.text &&
                  " " === (e = t.gullet.popToken()).text &&
                  (e = t.gullet.popToken()),
                e
              );
            })(e);
            return (
              Fe(e, a, n, "\\\\globallet" === r),
              { type: "internal", mode: e.mode }
            );
          },
        }),
        _t({
          type: "internal",
          names: ["\\futurelet", "\\\\globalfuture"],
          props: { numArgs: 0, allowedInText: !0 },
          handler: function (t) {
            var e = t.parser,
              r = t.funcName,
              a = He(e.gullet.popToken()),
              n = e.gullet.popToken(),
              i = e.gullet.popToken();
            return (
              Fe(e, a, i, "\\\\globalfuture" === r),
              e.gullet.pushToken(i),
              e.gullet.pushToken(n),
              { type: "internal", mode: e.mode }
            );
          },
        });
      var Ve = function (t, e, r) {
          var a = G((j.math[t] && j.math[t].replace) || t, e, r);
          if (!a)
            throw new Error(
              "Unsupported symbol " + t + " and font size " + e + ".",
            );
          return a;
        },
        Ue = function (t, e, r, a) {
          var n = r.havingBaseStyle(e),
            i = Dt.makeSpan(a.concat(n.sizingClasses(r)), [t], r),
            o = n.sizeMultiplier / r.sizeMultiplier;
          return (
            (i.height *= o),
            (i.depth *= o),
            (i.maxFontSize = n.sizeMultiplier),
            i
          );
        },
        Ge = function (t, e, r) {
          var a = e.havingBaseStyle(r),
            n =
              (1 - e.sizeMultiplier / a.sizeMultiplier) *
              e.fontMetrics().axisHeight;
          t.classes.push("delimcenter"),
            (t.style.top = n + "em"),
            (t.height -= n),
            (t.depth += n);
        },
        Ye = function (t, e, r, a, n, i) {
          var o = (function (t, e, r, a) {
              return Dt.makeSymbol(t, "Size" + e + "-Regular", r, a);
            })(t, e, n, a),
            s = Ue(
              Dt.makeSpan(["delimsizing", "size" + e], [o], a),
              w.TEXT,
              a,
              i,
            );
          return r && Ge(s, a, w.TEXT), s;
        },
        We = function (t, e, r) {
          var a;
          return (
            (a = "Size1-Regular" === e ? "delim-size1" : "delim-size4"),
            {
              type: "elem",
              elem: Dt.makeSpan(
                ["delimsizinginner", a],
                [Dt.makeSpan([], [Dt.makeSymbol(t, e, r)])],
              ),
            }
          );
        },
        Xe = { type: "kern", size: -0.005 },
        _e = function (t, e, r, a, n, i) {
          var o, s, l, h;
          (o = l = h = t), (s = null);
          var m = "Size1-Regular";
          "\\uparrow" === t
            ? (l = h = "\u23d0")
            : "\\Uparrow" === t
              ? (l = h = "\u2016")
              : "\\downarrow" === t
                ? (o = l = "\u23d0")
                : "\\Downarrow" === t
                  ? (o = l = "\u2016")
                  : "\\updownarrow" === t
                    ? ((o = "\\uparrow"), (l = "\u23d0"), (h = "\\downarrow"))
                    : "\\Updownarrow" === t
                      ? ((o = "\\Uparrow"), (l = "\u2016"), (h = "\\Downarrow"))
                      : "[" === t || "\\lbrack" === t
                        ? ((o = "\u23a1"),
                          (l = "\u23a2"),
                          (h = "\u23a3"),
                          (m = "Size4-Regular"))
                        : "]" === t || "\\rbrack" === t
                          ? ((o = "\u23a4"),
                            (l = "\u23a5"),
                            (h = "\u23a6"),
                            (m = "Size4-Regular"))
                          : "\\lfloor" === t || "\u230a" === t
                            ? ((l = o = "\u23a2"),
                              (h = "\u23a3"),
                              (m = "Size4-Regular"))
                            : "\\lceil" === t || "\u2308" === t
                              ? ((o = "\u23a1"),
                                (l = h = "\u23a2"),
                                (m = "Size4-Regular"))
                              : "\\rfloor" === t || "\u230b" === t
                                ? ((l = o = "\u23a5"),
                                  (h = "\u23a6"),
                                  (m = "Size4-Regular"))
                                : "\\rceil" === t || "\u2309" === t
                                  ? ((o = "\u23a4"),
                                    (l = h = "\u23a5"),
                                    (m = "Size4-Regular"))
                                  : "(" === t || "\\lparen" === t
                                    ? ((o = "\u239b"),
                                      (l = "\u239c"),
                                      (h = "\u239d"),
                                      (m = "Size4-Regular"))
                                    : ")" === t || "\\rparen" === t
                                      ? ((o = "\u239e"),
                                        (l = "\u239f"),
                                        (h = "\u23a0"),
                                        (m = "Size4-Regular"))
                                      : "\\{" === t || "\\lbrace" === t
                                        ? ((o = "\u23a7"),
                                          (s = "\u23a8"),
                                          (h = "\u23a9"),
                                          (l = "\u23aa"),
                                          (m = "Size4-Regular"))
                                        : "\\}" === t || "\\rbrace" === t
                                          ? ((o = "\u23ab"),
                                            (s = "\u23ac"),
                                            (h = "\u23ad"),
                                            (l = "\u23aa"),
                                            (m = "Size4-Regular"))
                                          : "\\lgroup" === t || "\u27ee" === t
                                            ? ((o = "\u23a7"),
                                              (h = "\u23a9"),
                                              (l = "\u23aa"),
                                              (m = "Size4-Regular"))
                                            : "\\rgroup" === t || "\u27ef" === t
                                              ? ((o = "\u23ab"),
                                                (h = "\u23ad"),
                                                (l = "\u23aa"),
                                                (m = "Size4-Regular"))
                                              : "\\lmoustache" === t ||
                                                  "\u23b0" === t
                                                ? ((o = "\u23a7"),
                                                  (h = "\u23ad"),
                                                  (l = "\u23aa"),
                                                  (m = "Size4-Regular"))
                                                : ("\\rmoustache" !== t &&
                                                    "\u23b1" !== t) ||
                                                  ((o = "\u23ab"),
                                                  (h = "\u23a9"),
                                                  (l = "\u23aa"),
                                                  (m = "Size4-Regular"));
          var c = Ve(o, m, n),
            u = c.height + c.depth,
            p = Ve(l, m, n),
            d = p.height + p.depth,
            f = Ve(h, m, n),
            g = f.height + f.depth,
            x = 0,
            v = 1;
          if (null !== s) {
            var b = Ve(s, m, n);
            (x = b.height + b.depth), (v = 2);
          }
          var y = u + g + x,
            k = Math.max(0, Math.ceil((e - y) / (v * d))),
            S = y + k * v * d,
            M = a.fontMetrics().axisHeight;
          r && (M *= a.sizeMultiplier);
          var z = S / 2 - M,
            A = 0.005 * (k + 1) - d,
            T = [];
          if ((T.push(We(h, m, n)), null === s))
            for (var B = 0; B < k; B++) T.push(Xe), T.push(We(l, m, n));
          else {
            for (var C = 0; C < k; C++) T.push(Xe), T.push(We(l, m, n));
            T.push({ type: "kern", size: A }),
              T.push(We(l, m, n)),
              T.push(Xe),
              T.push(We(s, m, n));
            for (var q = 0; q < k; q++) T.push(Xe), T.push(We(l, m, n));
          }
          if (("\u239c" !== l && "\u239f" !== l) || 0 !== k)
            T.push({ type: "kern", size: A }), T.push(We(l, m, n)), T.push(Xe);
          else {
            var N = Dt.svgData.leftParenInner[2] / 2;
            T.push({ type: "kern", size: -N });
            var I = "\u239c" === l ? "leftParenInner" : "rightParenInner",
              O = Dt.staticSvg(I, a);
            T.push({ type: "elem", elem: O }),
              T.push({ type: "kern", size: -N });
          }
          T.push(We(o, m, n));
          var R = a.havingBaseStyle(w.TEXT),
            E = Dt.makeVList(
              { positionType: "bottom", positionData: z, children: T },
              R,
            );
          return Ue(Dt.makeSpan(["delimsizing", "mult"], [E], R), w.TEXT, a, i);
        },
        je = function (t, e, r, a, n) {
          var i = (function (t, e, r) {
              e *= 1e3;
              var a = "";
              switch (t) {
                case "sqrtMain":
                  a = (function (t, e) {
                    return (
                      "M95," +
                      (622 + t + e) +
                      "\nc-2.7,0,-7.17,-2.7,-13.5,-8c-5.8,-5.3,-9.5,-10,-9.5,-14\nc0,-2,0.3,-3.3,1,-4c1.3,-2.7,23.83,-20.7,67.5,-54\nc44.2,-33.3,65.8,-50.3,66.5,-51c1.3,-1.3,3,-2,5,-2c4.7,0,8.7,3.3,12,10\ns173,378,173,378c0.7,0,35.3,-71,104,-213c68.7,-142,137.5,-285,206.5,-429\nc69,-144,104.5,-217.7,106.5,-221\nl" +
                      t / 2.075 +
                      " -" +
                      t +
                      "\nc5.3,-9.3,12,-14,20,-14\nH400000v" +
                      (40 + t) +
                      "H845.2724\ns-225.272,467,-225.272,467s-235,486,-235,486c-2.7,4.7,-9,7,-19,7\nc-6,0,-10,-1,-12,-3s-194,-422,-194,-422s-65,47,-65,47z\nM" +
                      (834 + t) +
                      " " +
                      e +
                      "h400000v" +
                      (40 + t) +
                      "h-400000z"
                    );
                  })(e, 80);
                  break;
                case "sqrtSize1":
                  a = (function (t, e) {
                    return (
                      "M263," +
                      (601 + t + e) +
                      "c0.7,0,18,39.7,52,119\nc34,79.3,68.167,158.7,102.5,238c34.3,79.3,51.8,119.3,52.5,120\nc340,-704.7,510.7,-1060.3,512,-1067\nl" +
                      t / 2.084 +
                      " -" +
                      t +
                      "\nc4.7,-7.3,11,-11,19,-11\nH40000v" +
                      (40 + t) +
                      "H1012.3\ns-271.3,567,-271.3,567c-38.7,80.7,-84,175,-136,283c-52,108,-89.167,185.3,-111.5,232\nc-22.3,46.7,-33.8,70.3,-34.5,71c-4.7,4.7,-12.3,7,-23,7s-12,-1,-12,-1\ns-109,-253,-109,-253c-72.7,-168,-109.3,-252,-110,-252c-10.7,8,-22,16.7,-34,26\nc-22,17.3,-33.3,26,-34,26s-26,-26,-26,-26s76,-59,76,-59s76,-60,76,-60z\nM" +
                      (1001 + t) +
                      " " +
                      e +
                      "h400000v" +
                      (40 + t) +
                      "h-400000z"
                    );
                  })(e, 80);
                  break;
                case "sqrtSize2":
                  a = (function (t, e) {
                    return (
                      "M983 " +
                      (10 + t + e) +
                      "\nl" +
                      t / 3.13 +
                      " -" +
                      t +
                      "\nc4,-6.7,10,-10,18,-10 H400000v" +
                      (40 + t) +
                      "\nH1013.1s-83.4,268,-264.1,840c-180.7,572,-277,876.3,-289,913c-4.7,4.7,-12.7,7,-24,7\ns-12,0,-12,0c-1.3,-3.3,-3.7,-11.7,-7,-25c-35.3,-125.3,-106.7,-373.3,-214,-744\nc-10,12,-21,25,-33,39s-32,39,-32,39c-6,-5.3,-15,-14,-27,-26s25,-30,25,-30\nc26.7,-32.7,52,-63,76,-91s52,-60,52,-60s208,722,208,722\nc56,-175.3,126.3,-397.3,211,-666c84.7,-268.7,153.8,-488.2,207.5,-658.5\nc53.7,-170.3,84.5,-266.8,92.5,-289.5z\nM" +
                      (1001 + t) +
                      " " +
                      e +
                      "h400000v" +
                      (40 + t) +
                      "h-400000z"
                    );
                  })(e, 80);
                  break;
                case "sqrtSize3":
                  a = (function (t, e) {
                    return (
                      "M424," +
                      (2398 + t + e) +
                      "\nc-1.3,-0.7,-38.5,-172,-111.5,-514c-73,-342,-109.8,-513.3,-110.5,-514\nc0,-2,-10.7,14.3,-32,49c-4.7,7.3,-9.8,15.7,-15.5,25c-5.7,9.3,-9.8,16,-12.5,20\ns-5,7,-5,7c-4,-3.3,-8.3,-7.7,-13,-13s-13,-13,-13,-13s76,-122,76,-122s77,-121,77,-121\ns209,968,209,968c0,-2,84.7,-361.7,254,-1079c169.3,-717.3,254.7,-1077.7,256,-1081\nl" +
                      t / 4.223 +
                      " -" +
                      t +
                      "c4,-6.7,10,-10,18,-10 H400000\nv" +
                      (40 + t) +
                      "H1014.6\ns-87.3,378.7,-272.6,1166c-185.3,787.3,-279.3,1182.3,-282,1185\nc-2,6,-10,9,-24,9\nc-8,0,-12,-0.7,-12,-2z M" +
                      (1001 + t) +
                      " " +
                      e +
                      "\nh400000v" +
                      (40 + t) +
                      "h-400000z"
                    );
                  })(e, 80);
                  break;
                case "sqrtSize4":
                  a = (function (t, e) {
                    return (
                      "M473," +
                      (2713 + t + e) +
                      "\nc339.3,-1799.3,509.3,-2700,510,-2702 l" +
                      t / 5.298 +
                      " -" +
                      t +
                      "\nc3.3,-7.3,9.3,-11,18,-11 H400000v" +
                      (40 + t) +
                      "H1017.7\ns-90.5,478,-276.2,1466c-185.7,988,-279.5,1483,-281.5,1485c-2,6,-10,9,-24,9\nc-8,0,-12,-0.7,-12,-2c0,-1.3,-5.3,-32,-16,-92c-50.7,-293.3,-119.7,-693.3,-207,-1200\nc0,-1.3,-5.3,8.7,-16,30c-10.7,21.3,-21.3,42.7,-32,64s-16,33,-16,33s-26,-26,-26,-26\ns76,-153,76,-153s77,-151,77,-151c0.7,0.7,35.7,202,105,604c67.3,400.7,102,602.7,104,\n606zM" +
                      (1001 + t) +
                      " " +
                      e +
                      "h400000v" +
                      (40 + t) +
                      "H1017.7z"
                    );
                  })(e, 80);
                  break;
                case "sqrtTall":
                  a = (function (t, e, r) {
                    return (
                      "M702 " +
                      (t + e) +
                      "H400000" +
                      (40 + t) +
                      "\nH742v" +
                      (r - 54 - e - t) +
                      "l-4 4-4 4c-.667.7 -2 1.5-4 2.5s-4.167 1.833-6.5 2.5-5.5 1-9.5 1\nh-12l-28-84c-16.667-52-96.667 -294.333-240-727l-212 -643 -85 170\nc-4-3.333-8.333-7.667-13 -13l-13-13l77-155 77-156c66 199.333 139 419.667\n219 661 l218 661zM702 " +
                      e +
                      "H400000v" +
                      (40 + t) +
                      "H742z"
                    );
                  })(e, 80, r);
              }
              return a;
            })(t, a, r),
            o = new P(t, i),
            s = new L([o], {
              width: "400em",
              height: e + "em",
              viewBox: "0 0 400000 " + r,
              preserveAspectRatio: "xMinYMin slice",
            });
          return Dt.makeSvgSpan(["hide-tail"], [s], n);
        },
        $e = [
          "(",
          "\\lparen",
          ")",
          "\\rparen",
          "[",
          "\\lbrack",
          "]",
          "\\rbrack",
          "\\{",
          "\\lbrace",
          "\\}",
          "\\rbrace",
          "\\lfloor",
          "\\rfloor",
          "\u230a",
          "\u230b",
          "\\lceil",
          "\\rceil",
          "\u2308",
          "\u2309",
          "\\surd",
        ],
        Ze = [
          "\\uparrow",
          "\\downarrow",
          "\\updownarrow",
          "\\Uparrow",
          "\\Downarrow",
          "\\Updownarrow",
          "|",
          "\\|",
          "\\vert",
          "\\Vert",
          "\\lvert",
          "\\rvert",
          "\\lVert",
          "\\rVert",
          "\\lgroup",
          "\\rgroup",
          "\u27ee",
          "\u27ef",
          "\\lmoustache",
          "\\rmoustache",
          "\u23b0",
          "\u23b1",
        ],
        Ke = [
          "<",
          ">",
          "\\langle",
          "\\rangle",
          "/",
          "\\backslash",
          "\\lt",
          "\\gt",
        ],
        Je = [0, 1.2, 1.8, 2.4, 3],
        Qe = [
          { type: "small", style: w.SCRIPTSCRIPT },
          { type: "small", style: w.SCRIPT },
          { type: "small", style: w.TEXT },
          { type: "large", size: 1 },
          { type: "large", size: 2 },
          { type: "large", size: 3 },
          { type: "large", size: 4 },
        ],
        tr = [
          { type: "small", style: w.SCRIPTSCRIPT },
          { type: "small", style: w.SCRIPT },
          { type: "small", style: w.TEXT },
          { type: "stack" },
        ],
        er = [
          { type: "small", style: w.SCRIPTSCRIPT },
          { type: "small", style: w.SCRIPT },
          { type: "small", style: w.TEXT },
          { type: "large", size: 1 },
          { type: "large", size: 2 },
          { type: "large", size: 3 },
          { type: "large", size: 4 },
          { type: "stack" },
        ],
        rr = function (t) {
          if ("small" === t.type) return "Main-Regular";
          if ("large" === t.type) return "Size" + t.size + "-Regular";
          if ("stack" === t.type) return "Size4-Regular";
          throw new Error("Add support for delim type '" + t.type + "' here.");
        },
        ar = function (t, e, r, a) {
          for (
            var n = Math.min(2, 3 - a.style.size);
            n < r.length && "stack" !== r[n].type;
            n++
          ) {
            var i = Ve(t, rr(r[n]), "math"),
              o = i.height + i.depth;
            if (
              ("small" === r[n].type &&
                (o *= a.havingBaseStyle(r[n].style).sizeMultiplier),
              o > e)
            )
              return r[n];
          }
          return r[r.length - 1];
        },
        nr = function (t, e, r, a, n, i) {
          var o;
          "<" === t || "\\lt" === t || "\u27e8" === t
            ? (t = "\\langle")
            : (">" !== t && "\\gt" !== t && "\u27e9" !== t) || (t = "\\rangle"),
            (o = c.contains(Ke, t) ? Qe : c.contains($e, t) ? er : tr);
          var s = ar(t, e, o, a);
          return "small" === s.type
            ? (function (t, e, r, a, n, i) {
                var o = Dt.makeSymbol(t, "Main-Regular", n, a),
                  s = Ue(o, e, a, i);
                return r && Ge(s, a, e), s;
              })(t, s.style, r, a, n, i)
            : "large" === s.type
              ? Ye(t, s.size, r, a, n, i)
              : _e(t, e, r, a, n, i);
        },
        ir = function (t, e) {
          var r,
            a,
            n = e.havingBaseSizing(),
            i = ar("\\surd", t * n.sizeMultiplier, er, n),
            o = n.sizeMultiplier,
            s = Math.max(
              0,
              e.minRuleThickness - e.fontMetrics().sqrtRuleThickness,
            ),
            l = 0,
            h = 0,
            m = 0;
          return (
            "small" === i.type
              ? (t < 1 ? (o = 1) : t < 1.4 && (o = 0.7),
                (h = (1 + s) / o),
                ((r = je(
                  "sqrtMain",
                  (l = (1 + s + 0.08) / o),
                  (m = 1e3 + 1e3 * s + 80),
                  s,
                  e,
                )).style.minWidth = "0.853em"),
                (a = 0.833 / o))
              : "large" === i.type
                ? ((m = 1080 * Je[i.size]),
                  (h = (Je[i.size] + s) / o),
                  (l = (Je[i.size] + s + 0.08) / o),
                  ((r = je("sqrtSize" + i.size, l, m, s, e)).style.minWidth =
                    "1.02em"),
                  (a = 1 / o))
                : ((l = t + s + 0.08),
                  (h = t + s),
                  (m = Math.floor(1e3 * t + s) + 80),
                  ((r = je("sqrtTall", l, m, s, e)).style.minWidth = "0.742em"),
                  (a = 1.056)),
            (r.height = h),
            (r.style.height = l + "em"),
            {
              span: r,
              advanceWidth: a,
              ruleWidth: (e.fontMetrics().sqrtRuleThickness + s) * o,
            }
          );
        },
        or = function (t, e, r, a, n) {
          if (
            ("<" === t || "\\lt" === t || "\u27e8" === t
              ? (t = "\\langle")
              : (">" !== t && "\\gt" !== t && "\u27e9" !== t) ||
                (t = "\\rangle"),
            c.contains($e, t) || c.contains(Ke, t))
          )
            return Ye(t, e, !1, r, a, n);
          if (c.contains(Ze, t)) return _e(t, Je[e], !1, r, a, n);
          throw new o("Illegal delimiter: '" + t + "'");
        },
        sr = nr,
        lr = function (t, e, r, a, n, i) {
          var o = a.fontMetrics().axisHeight * a.sizeMultiplier,
            s = 5 / a.fontMetrics().ptPerEm,
            l = Math.max(e - o, r + o),
            h = Math.max((l / 500) * 901, 2 * l - s);
          return nr(t, h, !0, a, n, i);
        },
        hr = {
          "\\bigl": { mclass: "mopen", size: 1 },
          "\\Bigl": { mclass: "mopen", size: 2 },
          "\\biggl": { mclass: "mopen", size: 3 },
          "\\Biggl": { mclass: "mopen", size: 4 },
          "\\bigr": { mclass: "mclose", size: 1 },
          "\\Bigr": { mclass: "mclose", size: 2 },
          "\\biggr": { mclass: "mclose", size: 3 },
          "\\Biggr": { mclass: "mclose", size: 4 },
          "\\bigm": { mclass: "mrel", size: 1 },
          "\\Bigm": { mclass: "mrel", size: 2 },
          "\\biggm": { mclass: "mrel", size: 3 },
          "\\Biggm": { mclass: "mrel", size: 4 },
          "\\big": { mclass: "mord", size: 1 },
          "\\Big": { mclass: "mord", size: 2 },
          "\\bigg": { mclass: "mord", size: 3 },
          "\\Bigg": { mclass: "mord", size: 4 },
        },
        mr = [
          "(",
          "\\lparen",
          ")",
          "\\rparen",
          "[",
          "\\lbrack",
          "]",
          "\\rbrack",
          "\\{",
          "\\lbrace",
          "\\}",
          "\\rbrace",
          "\\lfloor",
          "\\rfloor",
          "\u230a",
          "\u230b",
          "\\lceil",
          "\\rceil",
          "\u2308",
          "\u2309",
          "<",
          ">",
          "\\langle",
          "\u27e8",
          "\\rangle",
          "\u27e9",
          "\\lt",
          "\\gt",
          "\\lvert",
          "\\rvert",
          "\\lVert",
          "\\rVert",
          "\\lgroup",
          "\\rgroup",
          "\u27ee",
          "\u27ef",
          "\\lmoustache",
          "\\rmoustache",
          "\u23b0",
          "\u23b1",
          "/",
          "\\backslash",
          "|",
          "\\vert",
          "\\|",
          "\\Vert",
          "\\uparrow",
          "\\Uparrow",
          "\\downarrow",
          "\\Downarrow",
          "\\updownarrow",
          "\\Updownarrow",
          ".",
        ];
      function cr(t, e) {
        var r = Ne(t);
        if (r && c.contains(mr, r.text)) return r;
        throw new o(
          r
            ? "Invalid delimiter '" + r.text + "' after '" + e.funcName + "'"
            : "Invalid delimiter type '" + t.type + "'",
          t,
        );
      }
      function ur(t) {
        if (!t.body)
          throw new Error("Bug: The leftright ParseNode wasn't fully parsed.");
      }
      _t({
        type: "delimsizing",
        names: [
          "\\bigl",
          "\\Bigl",
          "\\biggl",
          "\\Biggl",
          "\\bigr",
          "\\Bigr",
          "\\biggr",
          "\\Biggr",
          "\\bigm",
          "\\Bigm",
          "\\biggm",
          "\\Biggm",
          "\\big",
          "\\Big",
          "\\bigg",
          "\\Bigg",
        ],
        props: { numArgs: 1 },
        handler: function (t, e) {
          var r = cr(e[0], t);
          return {
            type: "delimsizing",
            mode: t.parser.mode,
            size: hr[t.funcName].size,
            mclass: hr[t.funcName].mclass,
            delim: r.text,
          };
        },
        htmlBuilder: function (t, e) {
          return "." === t.delim
            ? Dt.makeSpan([t.mclass])
            : or(t.delim, t.size, e, t.mode, [t.mclass]);
        },
        mathmlBuilder: function (t) {
          var e = [];
          "." !== t.delim && e.push(pe(t.delim, t.mode));
          var r = new ue.MathNode("mo", e);
          return (
            "mopen" === t.mclass || "mclose" === t.mclass
              ? r.setAttribute("fence", "true")
              : r.setAttribute("fence", "false"),
            r
          );
        },
      }),
        _t({
          type: "leftright-right",
          names: ["\\right"],
          props: { numArgs: 1 },
          handler: function (t, e) {
            var r = t.parser.gullet.macros.get("\\current@color");
            if (r && "string" != typeof r)
              throw new o("\\current@color set to non-string in \\right");
            return {
              type: "leftright-right",
              mode: t.parser.mode,
              delim: cr(e[0], t).text,
              color: r,
            };
          },
        }),
        _t({
          type: "leftright",
          names: ["\\left"],
          props: { numArgs: 1 },
          handler: function (t, e) {
            var r = cr(e[0], t),
              a = t.parser;
            ++a.leftrightDepth;
            var n = a.parseExpression(!1);
            --a.leftrightDepth, a.expect("\\right", !1);
            var i = Ce(a.parseFunction(), "leftright-right");
            return {
              type: "leftright",
              mode: a.mode,
              body: n,
              left: r.text,
              right: i.delim,
              rightColor: i.color,
            };
          },
          htmlBuilder: function (t, e) {
            ur(t);
            for (
              var r,
                a,
                n = ee(t.body, e, !0, ["mopen", "mclose"]),
                i = 0,
                o = 0,
                s = !1,
                l = 0;
              l < n.length;
              l++
            )
              n[l].isMiddle
                ? (s = !0)
                : ((i = Math.max(n[l].height, i)),
                  (o = Math.max(n[l].depth, o)));
            if (
              ((i *= e.sizeMultiplier),
              (o *= e.sizeMultiplier),
              (r =
                "." === t.left
                  ? ie(e, ["mopen"])
                  : lr(t.left, i, o, e, t.mode, ["mopen"])),
              n.unshift(r),
              s)
            )
              for (var h = 1; h < n.length; h++) {
                var m = n[h].isMiddle;
                m && (n[h] = lr(m.delim, i, o, m.options, t.mode, []));
              }
            if ("." === t.right) a = ie(e, ["mclose"]);
            else {
              var c = t.rightColor ? e.withColor(t.rightColor) : e;
              a = lr(t.right, i, o, c, t.mode, ["mclose"]);
            }
            return n.push(a), Dt.makeSpan(["minner"], n, e);
          },
          mathmlBuilder: function (t, e) {
            ur(t);
            var r = ge(t.body, e);
            if ("." !== t.left) {
              var a = new ue.MathNode("mo", [pe(t.left, t.mode)]);
              a.setAttribute("fence", "true"), r.unshift(a);
            }
            if ("." !== t.right) {
              var n = new ue.MathNode("mo", [pe(t.right, t.mode)]);
              n.setAttribute("fence", "true"),
                t.rightColor && n.setAttribute("mathcolor", t.rightColor),
                r.push(n);
            }
            return de(r);
          },
        }),
        _t({
          type: "middle",
          names: ["\\middle"],
          props: { numArgs: 1 },
          handler: function (t, e) {
            var r = cr(e[0], t);
            if (!t.parser.leftrightDepth)
              throw new o("\\middle without preceding \\left", r);
            return { type: "middle", mode: t.parser.mode, delim: r.text };
          },
          htmlBuilder: function (t, e) {
            var r;
            if ("." === t.delim) r = ie(e, []);
            else {
              r = or(t.delim, 1, e, t.mode, []);
              var a = { delim: t.delim, options: e };
              r.isMiddle = a;
            }
            return r;
          },
          mathmlBuilder: function (t, e) {
            var r =
                "\\vert" === t.delim || "|" === t.delim
                  ? pe("|", "text")
                  : pe(t.delim, t.mode),
              a = new ue.MathNode("mo", [r]);
            return (
              a.setAttribute("fence", "true"),
              a.setAttribute("lspace", "0.05em"),
              a.setAttribute("rspace", "0.05em"),
              a
            );
          },
        });
      var pr = function (t, e) {
          var r,
            a,
            n = Dt.wrapFragment(oe(t.body, e), e),
            i = t.label.substr(1),
            o = e.sizeMultiplier,
            s = 0,
            l = c.isCharacterBox(t.body);
          if ("sout" === i)
            ((r = Dt.makeSpan(["stretchy", "sout"])).height =
              e.fontMetrics().defaultRuleThickness / o),
              (s = -0.5 * e.fontMetrics().xHeight);
          else {
            /cancel/.test(i)
              ? l || n.classes.push("cancel-pad")
              : n.classes.push("boxpad");
            var h = 0,
              m = 0;
            /box/.test(i)
              ? ((m = Math.max(e.fontMetrics().fboxrule, e.minRuleThickness)),
                (h = e.fontMetrics().fboxsep + ("colorbox" === i ? 0 : m)))
              : (h = l ? 0.2 : 0),
              (r = Ae(n, i, h, e)),
              /fbox|boxed|fcolorbox/.test(i) &&
                ((r.style.borderStyle = "solid"),
                (r.style.borderWidth = m + "em")),
              (s = n.depth + h),
              t.backgroundColor &&
                ((r.style.backgroundColor = t.backgroundColor),
                t.borderColor && (r.style.borderColor = t.borderColor));
          }
          return (
            (a = t.backgroundColor
              ? Dt.makeVList(
                  {
                    positionType: "individualShift",
                    children: [
                      { type: "elem", elem: r, shift: s },
                      { type: "elem", elem: n, shift: 0 },
                    ],
                  },
                  e,
                )
              : Dt.makeVList(
                  {
                    positionType: "individualShift",
                    children: [
                      { type: "elem", elem: n, shift: 0 },
                      {
                        type: "elem",
                        elem: r,
                        shift: s,
                        wrapperClasses: /cancel/.test(i) ? ["svg-align"] : [],
                      },
                    ],
                  },
                  e,
                )),
            /cancel/.test(i) && ((a.height = n.height), (a.depth = n.depth)),
            /cancel/.test(i) && !l
              ? Dt.makeSpan(["mord", "cancel-lap"], [a], e)
              : Dt.makeSpan(["mord"], [a], e)
          );
        },
        dr = function (t, e) {
          var r = 0,
            a = new ue.MathNode(
              t.label.indexOf("colorbox") > -1 ? "mpadded" : "menclose",
              [ve(t.body, e)],
            );
          switch (t.label) {
            case "\\cancel":
              a.setAttribute("notation", "updiagonalstrike");
              break;
            case "\\bcancel":
              a.setAttribute("notation", "downdiagonalstrike");
              break;
            case "\\sout":
              a.setAttribute("notation", "horizontalstrike");
              break;
            case "\\fbox":
              a.setAttribute("notation", "box");
              break;
            case "\\fcolorbox":
            case "\\colorbox":
              if (
                ((r = e.fontMetrics().fboxsep * e.fontMetrics().ptPerEm),
                a.setAttribute("width", "+" + 2 * r + "pt"),
                a.setAttribute("height", "+" + 2 * r + "pt"),
                a.setAttribute("lspace", r + "pt"),
                a.setAttribute("voffset", r + "pt"),
                "\\fcolorbox" === t.label)
              ) {
                var n = Math.max(e.fontMetrics().fboxrule, e.minRuleThickness);
                a.setAttribute(
                  "style",
                  "border: " + n + "em solid " + String(t.borderColor),
                );
              }
              break;
            case "\\xcancel":
              a.setAttribute("notation", "updiagonalstrike downdiagonalstrike");
          }
          return (
            t.backgroundColor &&
              a.setAttribute("mathbackground", t.backgroundColor),
            a
          );
        };
      _t({
        type: "enclose",
        names: ["\\colorbox"],
        props: {
          numArgs: 2,
          allowedInText: !0,
          greediness: 3,
          argTypes: ["color", "text"],
        },
        handler: function (t, e, r) {
          var a = t.parser,
            n = t.funcName,
            i = Ce(e[0], "color-token").color,
            o = e[1];
          return {
            type: "enclose",
            mode: a.mode,
            label: n,
            backgroundColor: i,
            body: o,
          };
        },
        htmlBuilder: pr,
        mathmlBuilder: dr,
      }),
        _t({
          type: "enclose",
          names: ["\\fcolorbox"],
          props: {
            numArgs: 3,
            allowedInText: !0,
            greediness: 3,
            argTypes: ["color", "color", "text"],
          },
          handler: function (t, e, r) {
            var a = t.parser,
              n = t.funcName,
              i = Ce(e[0], "color-token").color,
              o = Ce(e[1], "color-token").color,
              s = e[2];
            return {
              type: "enclose",
              mode: a.mode,
              label: n,
              backgroundColor: o,
              borderColor: i,
              body: s,
            };
          },
          htmlBuilder: pr,
          mathmlBuilder: dr,
        }),
        _t({
          type: "enclose",
          names: ["\\fbox"],
          props: { numArgs: 1, argTypes: ["hbox"], allowedInText: !0 },
          handler: function (t, e) {
            return {
              type: "enclose",
              mode: t.parser.mode,
              label: "\\fbox",
              body: e[0],
            };
          },
        }),
        _t({
          type: "enclose",
          names: ["\\cancel", "\\bcancel", "\\xcancel", "\\sout"],
          props: { numArgs: 1 },
          handler: function (t, e, r) {
            var a = t.parser,
              n = t.funcName,
              i = e[0];
            return { type: "enclose", mode: a.mode, label: n, body: i };
          },
          htmlBuilder: pr,
          mathmlBuilder: dr,
        });
      var fr = {};
      function gr(t) {
        for (
          var e = t.type,
            r = t.names,
            a = t.props,
            n = t.handler,
            i = t.htmlBuilder,
            o = t.mathmlBuilder,
            s = {
              type: e,
              numArgs: a.numArgs || 0,
              greediness: 1,
              allowedInText: !1,
              numOptionalArgs: 0,
              handler: n,
            },
            l = 0;
          l < r.length;
          ++l
        )
          fr[r[l]] = s;
        i && (Wt[e] = i), o && (Xt[e] = o);
      }
      function xr(t) {
        var e = [];
        t.consumeSpaces();
        for (var r = t.fetch().text; "\\hline" === r || "\\hdashline" === r; )
          t.consume(),
            e.push("\\hdashline" === r),
            t.consumeSpaces(),
            (r = t.fetch().text);
        return e;
      }
      function vr(t, e, r) {
        var a = e.hskipBeforeAndAfter,
          n = e.addJot,
          i = e.cols,
          s = e.arraystretch,
          l = e.colSeparationType;
        if ((t.gullet.beginGroup(), t.gullet.macros.set("\\\\", "\\cr"), !s)) {
          var h = t.gullet.expandMacroAsText("\\arraystretch");
          if (null == h) s = 1;
          else if (!(s = parseFloat(h)) || s < 0)
            throw new o("Invalid \\arraystretch: " + h);
        }
        t.gullet.beginGroup();
        var m = [],
          c = [m],
          u = [],
          p = [];
        for (p.push(xr(t)); ; ) {
          var d = t.parseExpression(!1, "\\cr");
          t.gullet.endGroup(),
            t.gullet.beginGroup(),
            (d = { type: "ordgroup", mode: t.mode, body: d }),
            r && (d = { type: "styling", mode: t.mode, style: r, body: [d] }),
            m.push(d);
          var f = t.fetch().text;
          if ("&" === f) t.consume();
          else {
            if ("\\end" === f) {
              1 === m.length &&
                "styling" === d.type &&
                0 === d.body[0].body.length &&
                c.pop(),
                p.length < c.length + 1 && p.push([]);
              break;
            }
            if ("\\cr" !== f)
              throw new o("Expected & or \\\\ or \\cr or \\end", t.nextToken);
            var g = Ce(t.parseFunction(), "cr");
            u.push(g.size), p.push(xr(t)), (m = []), c.push(m);
          }
        }
        return (
          t.gullet.endGroup(),
          t.gullet.endGroup(),
          {
            type: "array",
            mode: t.mode,
            addJot: n,
            arraystretch: s,
            body: c,
            cols: i,
            rowGaps: u,
            hskipBeforeAndAfter: a,
            hLinesBeforeRow: p,
            colSeparationType: l,
          }
        );
      }
      function br(t) {
        return "d" === t.substr(0, 1) ? "display" : "text";
      }
      var yr = function (t, e) {
          var r,
            a,
            n = t.body.length,
            i = t.hLinesBeforeRow,
            s = 0,
            l = new Array(n),
            h = [],
            m = Math.max(e.fontMetrics().arrayRuleWidth, e.minRuleThickness),
            u = 1 / e.fontMetrics().ptPerEm,
            p = 5 * u;
          t.colSeparationType &&
            "small" === t.colSeparationType &&
            (p =
              (e.havingStyle(w.SCRIPT).sizeMultiplier / e.sizeMultiplier) *
              0.2778);
          var d = 12 * u,
            f = 3 * u,
            g = t.arraystretch * d,
            x = 0.7 * g,
            v = 0.3 * g,
            b = 0;
          function y(t) {
            for (var e = 0; e < t.length; ++e)
              e > 0 && (b += 0.25), h.push({ pos: b, isDashed: t[e] });
          }
          for (y(i[0]), r = 0; r < t.body.length; ++r) {
            var k = t.body[r],
              S = x,
              M = v;
            s < k.length && (s = k.length);
            var z = new Array(k.length);
            for (a = 0; a < k.length; ++a) {
              var A = oe(k[a], e);
              M < A.depth && (M = A.depth),
                S < A.height && (S = A.height),
                (z[a] = A);
            }
            var T = t.rowGaps[r],
              B = 0;
            T && (B = Tt(T, e)) > 0 && (M < (B += v) && (M = B), (B = 0)),
              t.addJot && (M += f),
              (z.height = S),
              (z.depth = M),
              (b += S),
              (z.pos = b),
              (b += M + B),
              (l[r] = z),
              y(i[r + 1]);
          }
          var C,
            q,
            N = b / 2 + e.fontMetrics().axisHeight,
            I = t.cols || [],
            O = [];
          for (a = 0, q = 0; a < s || q < I.length; ++a, ++q) {
            for (var R = I[q] || {}, E = !0; "separator" === R.type; ) {
              if (
                (E ||
                  (((C = Dt.makeSpan(["arraycolsep"], [])).style.width =
                    e.fontMetrics().doubleRuleSep + "em"),
                  O.push(C)),
                "|" !== R.separator && ":" !== R.separator)
              )
                throw new o("Invalid separator type: " + R.separator);
              var L = "|" === R.separator ? "solid" : "dashed",
                P = Dt.makeSpan(["vertical-separator"], [], e);
              (P.style.height = b + "em"),
                (P.style.borderRightWidth = m + "em"),
                (P.style.borderRightStyle = L),
                (P.style.margin = "0 -" + m / 2 + "em"),
                (P.style.verticalAlign = -(b - N) + "em"),
                O.push(P),
                (R = I[++q] || {}),
                (E = !1);
            }
            if (!(a >= s)) {
              var D = void 0;
              (a > 0 || t.hskipBeforeAndAfter) &&
                0 !== (D = c.deflt(R.pregap, p)) &&
                (((C = Dt.makeSpan(["arraycolsep"], [])).style.width =
                  D + "em"),
                O.push(C));
              var H = [];
              for (r = 0; r < n; ++r) {
                var F = l[r],
                  V = F[a];
                if (V) {
                  var U = F.pos - N;
                  (V.depth = F.depth),
                    (V.height = F.height),
                    H.push({ type: "elem", elem: V, shift: U });
                }
              }
              (H = Dt.makeVList(
                { positionType: "individualShift", children: H },
                e,
              )),
                (H = Dt.makeSpan(["col-align-" + (R.align || "c")], [H])),
                O.push(H),
                (a < s - 1 || t.hskipBeforeAndAfter) &&
                  0 !== (D = c.deflt(R.postgap, p)) &&
                  (((C = Dt.makeSpan(["arraycolsep"], [])).style.width =
                    D + "em"),
                  O.push(C));
            }
          }
          if (((l = Dt.makeSpan(["mtable"], O)), h.length > 0)) {
            for (
              var G = Dt.makeLineSpan("hline", e, m),
                Y = Dt.makeLineSpan("hdashline", e, m),
                W = [{ type: "elem", elem: l, shift: 0 }];
              h.length > 0;

            ) {
              var X = h.pop(),
                _ = X.pos - N;
              X.isDashed
                ? W.push({ type: "elem", elem: Y, shift: _ })
                : W.push({ type: "elem", elem: G, shift: _ });
            }
            l = Dt.makeVList(
              { positionType: "individualShift", children: W },
              e,
            );
          }
          return Dt.makeSpan(["mord"], [l], e);
        },
        wr = { c: "center ", l: "left ", r: "right " },
        kr = function (t, e) {
          var r = new ue.MathNode(
              "mtable",
              t.body.map(function (t) {
                return new ue.MathNode(
                  "mtr",
                  t.map(function (t) {
                    return new ue.MathNode("mtd", [ve(t, e)]);
                  }),
                );
              }),
            ),
            a =
              0.5 === t.arraystretch
                ? 0.1
                : 0.16 + t.arraystretch - 1 + (t.addJot ? 0.09 : 0);
          r.setAttribute("rowspacing", a + "em");
          var n = "",
            i = "";
          if (t.cols && t.cols.length > 0) {
            var o = t.cols,
              s = "",
              l = !1,
              h = 0,
              m = o.length;
            "separator" === o[0].type && ((n += "top "), (h = 1)),
              "separator" === o[o.length - 1].type &&
                ((n += "bottom "), (m -= 1));
            for (var c = h; c < m; c++)
              "align" === o[c].type
                ? ((i += wr[o[c].align]), l && (s += "none "), (l = !0))
                : "separator" === o[c].type &&
                  l &&
                  ((s += "|" === o[c].separator ? "solid " : "dashed "),
                  (l = !1));
            r.setAttribute("columnalign", i.trim()),
              /[sd]/.test(s) && r.setAttribute("columnlines", s.trim());
          }
          if ("align" === t.colSeparationType) {
            for (var u = t.cols || [], p = "", d = 1; d < u.length; d++)
              p += d % 2 ? "0em " : "1em ";
            r.setAttribute("columnspacing", p.trim());
          } else
            "alignat" === t.colSeparationType
              ? r.setAttribute("columnspacing", "0em")
              : "small" === t.colSeparationType
                ? r.setAttribute("columnspacing", "0.2778em")
                : r.setAttribute("columnspacing", "1em");
          var f = "",
            g = t.hLinesBeforeRow;
          (n += g[0].length > 0 ? "left " : ""),
            (n += g[g.length - 1].length > 0 ? "right " : "");
          for (var x = 1; x < g.length - 1; x++)
            f += 0 === g[x].length ? "none " : g[x][0] ? "dashed " : "solid ";
          return (
            /[sd]/.test(f) && r.setAttribute("rowlines", f.trim()),
            "" !== n &&
              (r = new ue.MathNode("menclose", [r])).setAttribute(
                "notation",
                n.trim(),
              ),
            t.arraystretch &&
              t.arraystretch < 1 &&
              (r = new ue.MathNode("mstyle", [r])).setAttribute(
                "scriptlevel",
                "1",
              ),
            r
          );
        },
        Sr = function (t, e) {
          var r,
            a = [],
            n = vr(t.parser, { cols: a, addJot: !0 }, "display"),
            i = 0,
            s = { type: "ordgroup", mode: t.mode, body: [] };
          if (e[0] && "ordgroup" === e[0].type) {
            for (var l = "", h = 0; h < e[0].body.length; h++) {
              l += Ce(e[0].body[h], "textord").text;
            }
            (r = Number(l)), (i = 2 * r);
          }
          var m = !i;
          n.body.forEach(function (t) {
            for (var e = 1; e < t.length; e += 2) {
              var a = Ce(t[e], "styling");
              Ce(a.body[0], "ordgroup").body.unshift(s);
            }
            if (m) i < t.length && (i = t.length);
            else {
              var n = t.length / 2;
              if (r < n)
                throw new o(
                  "Too many math in a row: expected " + r + ", but got " + n,
                  t[0],
                );
            }
          });
          for (var c = 0; c < i; ++c) {
            var u = "r",
              p = 0;
            c % 2 == 1 ? (u = "l") : c > 0 && m && (p = 1),
              (a[c] = { type: "align", align: u, pregap: p, postgap: 0 });
          }
          return (n.colSeparationType = m ? "align" : "alignat"), n;
        };
      gr({
        type: "array",
        names: ["array", "darray"],
        props: { numArgs: 1 },
        handler: function (t, e) {
          var r = {
            cols: (Ne(e[0]) ? [e[0]] : Ce(e[0], "ordgroup").body).map(
              function (t) {
                var e = qe(t).text;
                if (-1 !== "lcr".indexOf(e)) return { type: "align", align: e };
                if ("|" === e) return { type: "separator", separator: "|" };
                if (":" === e) return { type: "separator", separator: ":" };
                throw new o("Unknown column alignment: " + e, t);
              },
            ),
            hskipBeforeAndAfter: !0,
          };
          return vr(t.parser, r, br(t.envName));
        },
        htmlBuilder: yr,
        mathmlBuilder: kr,
      }),
        gr({
          type: "array",
          names: [
            "matrix",
            "pmatrix",
            "bmatrix",
            "Bmatrix",
            "vmatrix",
            "Vmatrix",
          ],
          props: { numArgs: 0 },
          handler: function (t) {
            var e = {
                matrix: null,
                pmatrix: ["(", ")"],
                bmatrix: ["[", "]"],
                Bmatrix: ["\\{", "\\}"],
                vmatrix: ["|", "|"],
                Vmatrix: ["\\Vert", "\\Vert"],
              }[t.envName],
              r = vr(t.parser, { hskipBeforeAndAfter: !1 }, br(t.envName));
            return e
              ? {
                  type: "leftright",
                  mode: t.mode,
                  body: [r],
                  left: e[0],
                  right: e[1],
                  rightColor: void 0,
                }
              : r;
          },
          htmlBuilder: yr,
          mathmlBuilder: kr,
        }),
        gr({
          type: "array",
          names: ["smallmatrix"],
          props: { numArgs: 0 },
          handler: function (t) {
            var e = vr(t.parser, { arraystretch: 0.5 }, "script");
            return (e.colSeparationType = "small"), e;
          },
          htmlBuilder: yr,
          mathmlBuilder: kr,
        }),
        gr({
          type: "array",
          names: ["subarray"],
          props: { numArgs: 1 },
          handler: function (t, e) {
            var r = (Ne(e[0]) ? [e[0]] : Ce(e[0], "ordgroup").body).map(
              function (t) {
                var e = qe(t).text;
                if (-1 !== "lc".indexOf(e)) return { type: "align", align: e };
                throw new o("Unknown column alignment: " + e, t);
              },
            );
            if (r.length > 1)
              throw new o("{subarray} can contain only one column");
            var a = { cols: r, hskipBeforeAndAfter: !1, arraystretch: 0.5 };
            if (
              (a = vr(t.parser, a, "script")).body.length > 0 &&
              a.body[0].length > 1
            )
              throw new o("{subarray} can contain only one column");
            return a;
          },
          htmlBuilder: yr,
          mathmlBuilder: kr,
        }),
        gr({
          type: "array",
          names: ["cases", "dcases", "rcases", "drcases"],
          props: { numArgs: 0 },
          handler: function (t) {
            var e = vr(
              t.parser,
              {
                arraystretch: 1.2,
                cols: [
                  { type: "align", align: "l", pregap: 0, postgap: 1 },
                  { type: "align", align: "l", pregap: 0, postgap: 0 },
                ],
              },
              br(t.envName),
            );
            return {
              type: "leftright",
              mode: t.mode,
              body: [e],
              left: t.envName.indexOf("r") > -1 ? "." : "\\{",
              right: t.envName.indexOf("r") > -1 ? "\\}" : ".",
              rightColor: void 0,
            };
          },
          htmlBuilder: yr,
          mathmlBuilder: kr,
        }),
        gr({
          type: "array",
          names: ["aligned"],
          props: { numArgs: 0 },
          handler: Sr,
          htmlBuilder: yr,
          mathmlBuilder: kr,
        }),
        gr({
          type: "array",
          names: ["gathered"],
          props: { numArgs: 0 },
          handler: function (t) {
            return vr(
              t.parser,
              { cols: [{ type: "align", align: "c" }], addJot: !0 },
              "display",
            );
          },
          htmlBuilder: yr,
          mathmlBuilder: kr,
        }),
        gr({
          type: "array",
          names: ["alignedat"],
          props: { numArgs: 1 },
          handler: Sr,
          htmlBuilder: yr,
          mathmlBuilder: kr,
        }),
        _t({
          type: "text",
          names: ["\\hline", "\\hdashline"],
          props: { numArgs: 0, allowedInText: !0, allowedInMath: !0 },
          handler: function (t, e) {
            throw new o(t.funcName + " valid only within array environment");
          },
        });
      var Mr = fr;
      _t({
        type: "environment",
        names: ["\\begin", "\\end"],
        props: { numArgs: 1, argTypes: ["text"] },
        handler: function (t, e) {
          var r = t.parser,
            a = t.funcName,
            n = e[0];
          if ("ordgroup" !== n.type) throw new o("Invalid environment name", n);
          for (var i = "", s = 0; s < n.body.length; ++s)
            i += Ce(n.body[s], "textord").text;
          if ("\\begin" === a) {
            if (!Mr.hasOwnProperty(i))
              throw new o("No such environment: " + i, n);
            var l = Mr[i],
              h = r.parseArguments("\\begin{" + i + "}", l),
              m = h.args,
              c = h.optArgs,
              u = { mode: r.mode, envName: i, parser: r },
              p = l.handler(u, m, c);
            r.expect("\\end", !1);
            var d = r.nextToken,
              f = Ce(r.parseFunction(), "environment");
            if (f.name !== i)
              throw new o(
                "Mismatch: \\begin{" + i + "} matched by \\end{" + f.name + "}",
                d,
              );
            return p;
          }
          return { type: "environment", mode: r.mode, name: i, nameGroup: n };
        },
      });
      var zr = Dt.makeSpan;
      function Ar(t, e) {
        var r = ee(t.body, e, !0);
        return zr([t.mclass], r, e);
      }
      function Tr(t, e) {
        var r,
          a = ge(t.body, e);
        return "minner" === t.mclass
          ? ue.newDocumentFragment(a)
          : ("mord" === t.mclass
              ? t.isCharacterBox
                ? ((r = a[0]).type = "mi")
                : (r = new ue.MathNode("mi", a))
              : (t.isCharacterBox
                  ? ((r = a[0]).type = "mo")
                  : (r = new ue.MathNode("mo", a)),
                "mbin" === t.mclass
                  ? ((r.attributes.lspace = "0.22em"),
                    (r.attributes.rspace = "0.22em"))
                  : "mpunct" === t.mclass
                    ? ((r.attributes.lspace = "0em"),
                      (r.attributes.rspace = "0.17em"))
                    : ("mopen" !== t.mclass && "mclose" !== t.mclass) ||
                      ((r.attributes.lspace = "0em"),
                      (r.attributes.rspace = "0em"))),
            r);
      }
      _t({
        type: "mclass",
        names: [
          "\\mathord",
          "\\mathbin",
          "\\mathrel",
          "\\mathopen",
          "\\mathclose",
          "\\mathpunct",
          "\\mathinner",
        ],
        props: { numArgs: 1 },
        handler: function (t, e) {
          var r = t.parser,
            a = t.funcName,
            n = e[0];
          return {
            type: "mclass",
            mode: r.mode,
            mclass: "m" + a.substr(5),
            body: $t(n),
            isCharacterBox: c.isCharacterBox(n),
          };
        },
        htmlBuilder: Ar,
        mathmlBuilder: Tr,
      });
      var Br = function (t) {
        var e = "ordgroup" === t.type && t.body.length ? t.body[0] : t;
        return "atom" !== e.type || ("bin" !== e.family && "rel" !== e.family)
          ? "mord"
          : "m" + e.family;
      };
      _t({
        type: "mclass",
        names: ["\\@binrel"],
        props: { numArgs: 2 },
        handler: function (t, e) {
          return {
            type: "mclass",
            mode: t.parser.mode,
            mclass: Br(e[0]),
            body: [e[1]],
            isCharacterBox: c.isCharacterBox(e[1]),
          };
        },
      }),
        _t({
          type: "mclass",
          names: ["\\stackrel", "\\overset", "\\underset"],
          props: { numArgs: 2 },
          handler: function (t, e) {
            var r,
              a = t.parser,
              n = t.funcName,
              i = e[1],
              o = e[0];
            r = "\\stackrel" !== n ? Br(i) : "mrel";
            var s = {
                type: "op",
                mode: i.mode,
                limits: !0,
                alwaysHandleSupSub: !0,
                parentIsSupSub: !1,
                symbol: !1,
                suppressBaseShift: "\\stackrel" !== n,
                body: $t(i),
              },
              l = {
                type: "supsub",
                mode: o.mode,
                base: s,
                sup: "\\underset" === n ? null : o,
                sub: "\\underset" === n ? o : null,
              };
            return {
              type: "mclass",
              mode: a.mode,
              mclass: r,
              body: [l],
              isCharacterBox: c.isCharacterBox(l),
            };
          },
          htmlBuilder: Ar,
          mathmlBuilder: Tr,
        });
      var Cr = function (t, e) {
          var r = t.font,
            a = e.withFont(r);
          return oe(t.body, a);
        },
        qr = function (t, e) {
          var r = t.font,
            a = e.withFont(r);
          return ve(t.body, a);
        },
        Nr = {
          "\\Bbb": "\\mathbb",
          "\\bold": "\\mathbf",
          "\\frak": "\\mathfrak",
          "\\bm": "\\boldsymbol",
        };
      _t({
        type: "font",
        names: [
          "\\mathrm",
          "\\mathit",
          "\\mathbf",
          "\\mathnormal",
          "\\mathbb",
          "\\mathcal",
          "\\mathfrak",
          "\\mathscr",
          "\\mathsf",
          "\\mathtt",
          "\\Bbb",
          "\\bold",
          "\\frak",
        ],
        props: { numArgs: 1, greediness: 2 },
        handler: function (t, e) {
          var r = t.parser,
            a = t.funcName,
            n = e[0],
            i = a;
          return (
            i in Nr && (i = Nr[i]),
            { type: "font", mode: r.mode, font: i.slice(1), body: n }
          );
        },
        htmlBuilder: Cr,
        mathmlBuilder: qr,
      }),
        _t({
          type: "mclass",
          names: ["\\boldsymbol", "\\bm"],
          props: { numArgs: 1, greediness: 2 },
          handler: function (t, e) {
            var r = t.parser,
              a = e[0],
              n = c.isCharacterBox(a);
            return {
              type: "mclass",
              mode: r.mode,
              mclass: Br(a),
              body: [
                { type: "font", mode: r.mode, font: "boldsymbol", body: a },
              ],
              isCharacterBox: n,
            };
          },
        }),
        _t({
          type: "font",
          names: ["\\rm", "\\sf", "\\tt", "\\bf", "\\it", "\\cal"],
          props: { numArgs: 0, allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = t.funcName,
              n = t.breakOnTokenText,
              i = r.mode,
              o = r.parseExpression(!0, n);
            return {
              type: "font",
              mode: i,
              font: "math" + a.slice(1),
              body: { type: "ordgroup", mode: r.mode, body: o },
            };
          },
          htmlBuilder: Cr,
          mathmlBuilder: qr,
        });
      var Ir = function (t, e) {
          var r = e;
          return (
            "display" === t
              ? (r = r.id >= w.SCRIPT.id ? r.text() : w.DISPLAY)
              : "text" === t && r.size === w.DISPLAY.size
                ? (r = w.TEXT)
                : "script" === t
                  ? (r = w.SCRIPT)
                  : "scriptscript" === t && (r = w.SCRIPTSCRIPT),
            r
          );
        },
        Or = function (t, e) {
          var r,
            a = Ir(t.size, e.style),
            n = a.fracNum(),
            i = a.fracDen();
          r = e.havingStyle(n);
          var o = oe(t.numer, r, e);
          if (t.continued) {
            var s = 8.5 / e.fontMetrics().ptPerEm,
              l = 3.5 / e.fontMetrics().ptPerEm;
            (o.height = o.height < s ? s : o.height),
              (o.depth = o.depth < l ? l : o.depth);
          }
          r = e.havingStyle(i);
          var h,
            m,
            c,
            u,
            p,
            d,
            f,
            g,
            x,
            v,
            b = oe(t.denom, r, e);
          if (
            (t.hasBarLine
              ? (t.barSize
                  ? ((m = Tt(t.barSize, e)),
                    (h = Dt.makeLineSpan("frac-line", e, m)))
                  : (h = Dt.makeLineSpan("frac-line", e)),
                (m = h.height),
                (c = h.height))
              : ((h = null),
                (m = 0),
                (c = e.fontMetrics().defaultRuleThickness)),
            a.size === w.DISPLAY.size || "display" === t.size
              ? ((u = e.fontMetrics().num1),
                (p = m > 0 ? 3 * c : 7 * c),
                (d = e.fontMetrics().denom1))
              : (m > 0
                  ? ((u = e.fontMetrics().num2), (p = c))
                  : ((u = e.fontMetrics().num3), (p = 3 * c)),
                (d = e.fontMetrics().denom2)),
            h)
          ) {
            var y = e.fontMetrics().axisHeight;
            u - o.depth - (y + 0.5 * m) < p &&
              (u += p - (u - o.depth - (y + 0.5 * m))),
              y - 0.5 * m - (b.height - d) < p &&
                (d += p - (y - 0.5 * m - (b.height - d)));
            var k = -(y - 0.5 * m);
            f = Dt.makeVList(
              {
                positionType: "individualShift",
                children: [
                  { type: "elem", elem: b, shift: d },
                  { type: "elem", elem: h, shift: k },
                  { type: "elem", elem: o, shift: -u },
                ],
              },
              e,
            );
          } else {
            var S = u - o.depth - (b.height - d);
            S < p && ((u += 0.5 * (p - S)), (d += 0.5 * (p - S))),
              (f = Dt.makeVList(
                {
                  positionType: "individualShift",
                  children: [
                    { type: "elem", elem: b, shift: d },
                    { type: "elem", elem: o, shift: -u },
                  ],
                },
                e,
              ));
          }
          return (
            (r = e.havingStyle(a)),
            (f.height *= r.sizeMultiplier / e.sizeMultiplier),
            (f.depth *= r.sizeMultiplier / e.sizeMultiplier),
            (g =
              a.size === w.DISPLAY.size
                ? e.fontMetrics().delim1
                : e.fontMetrics().delim2),
            (x =
              null == t.leftDelim
                ? ie(e, ["mopen"])
                : sr(t.leftDelim, g, !0, e.havingStyle(a), t.mode, ["mopen"])),
            (v = t.continued
              ? Dt.makeSpan([])
              : null == t.rightDelim
                ? ie(e, ["mclose"])
                : sr(t.rightDelim, g, !0, e.havingStyle(a), t.mode, [
                    "mclose",
                  ])),
            Dt.makeSpan(
              ["mord"].concat(r.sizingClasses(e)),
              [x, Dt.makeSpan(["mfrac"], [f]), v],
              e,
            )
          );
        },
        Rr = function (t, e) {
          var r = new ue.MathNode("mfrac", [ve(t.numer, e), ve(t.denom, e)]);
          if (t.hasBarLine) {
            if (t.barSize) {
              var a = Tt(t.barSize, e);
              r.setAttribute("linethickness", a + "em");
            }
          } else r.setAttribute("linethickness", "0px");
          var n = Ir(t.size, e.style);
          if (n.size !== e.style.size) {
            r = new ue.MathNode("mstyle", [r]);
            var i = n.size === w.DISPLAY.size ? "true" : "false";
            r.setAttribute("displaystyle", i),
              r.setAttribute("scriptlevel", "0");
          }
          if (null != t.leftDelim || null != t.rightDelim) {
            var o = [];
            if (null != t.leftDelim) {
              var s = new ue.MathNode("mo", [
                new ue.TextNode(t.leftDelim.replace("\\", "")),
              ]);
              s.setAttribute("fence", "true"), o.push(s);
            }
            if ((o.push(r), null != t.rightDelim)) {
              var l = new ue.MathNode("mo", [
                new ue.TextNode(t.rightDelim.replace("\\", "")),
              ]);
              l.setAttribute("fence", "true"), o.push(l);
            }
            return de(o);
          }
          return r;
        };
      _t({
        type: "genfrac",
        names: [
          "\\cfrac",
          "\\dfrac",
          "\\frac",
          "\\tfrac",
          "\\dbinom",
          "\\binom",
          "\\tbinom",
          "\\\\atopfrac",
          "\\\\bracefrac",
          "\\\\brackfrac",
        ],
        props: { numArgs: 2, greediness: 2 },
        handler: function (t, e) {
          var r,
            a = t.parser,
            n = t.funcName,
            i = e[0],
            o = e[1],
            s = null,
            l = null,
            h = "auto";
          switch (n) {
            case "\\cfrac":
            case "\\dfrac":
            case "\\frac":
            case "\\tfrac":
              r = !0;
              break;
            case "\\\\atopfrac":
              r = !1;
              break;
            case "\\dbinom":
            case "\\binom":
            case "\\tbinom":
              (r = !1), (s = "("), (l = ")");
              break;
            case "\\\\bracefrac":
              (r = !1), (s = "\\{"), (l = "\\}");
              break;
            case "\\\\brackfrac":
              (r = !1), (s = "["), (l = "]");
              break;
            default:
              throw new Error("Unrecognized genfrac command");
          }
          switch (n) {
            case "\\cfrac":
            case "\\dfrac":
            case "\\dbinom":
              h = "display";
              break;
            case "\\tfrac":
            case "\\tbinom":
              h = "text";
          }
          return {
            type: "genfrac",
            mode: a.mode,
            continued: "\\cfrac" === n,
            numer: i,
            denom: o,
            hasBarLine: r,
            leftDelim: s,
            rightDelim: l,
            size: h,
            barSize: null,
          };
        },
        htmlBuilder: Or,
        mathmlBuilder: Rr,
      }),
        _t({
          type: "infix",
          names: ["\\over", "\\choose", "\\atop", "\\brace", "\\brack"],
          props: { numArgs: 0, infix: !0 },
          handler: function (t) {
            var e,
              r = t.parser,
              a = t.funcName,
              n = t.token;
            switch (a) {
              case "\\over":
                e = "\\frac";
                break;
              case "\\choose":
                e = "\\binom";
                break;
              case "\\atop":
                e = "\\\\atopfrac";
                break;
              case "\\brace":
                e = "\\\\bracefrac";
                break;
              case "\\brack":
                e = "\\\\brackfrac";
                break;
              default:
                throw new Error("Unrecognized infix genfrac command");
            }
            return { type: "infix", mode: r.mode, replaceWith: e, token: n };
          },
        });
      var Er = ["display", "text", "script", "scriptscript"],
        Lr = function (t) {
          var e = null;
          return t.length > 0 && (e = "." === (e = t) ? null : e), e;
        };
      _t({
        type: "genfrac",
        names: ["\\genfrac"],
        props: {
          numArgs: 6,
          greediness: 6,
          argTypes: ["math", "math", "size", "text", "math", "math"],
        },
        handler: function (t, e) {
          var r,
            a = t.parser,
            n = e[4],
            i = e[5],
            o =
              "atom" === e[0].type && "open" === e[0].family
                ? Lr(e[0].text)
                : null,
            s =
              "atom" === e[1].type && "close" === e[1].family
                ? Lr(e[1].text)
                : null,
            l = Ce(e[2], "size"),
            h = null;
          r = !!l.isBlank || (h = l.value).number > 0;
          var m = "auto",
            c = e[3];
          if ("ordgroup" === c.type) {
            if (c.body.length > 0) {
              var u = Ce(c.body[0], "textord");
              m = Er[Number(u.text)];
            }
          } else (c = Ce(c, "textord")), (m = Er[Number(c.text)]);
          return {
            type: "genfrac",
            mode: a.mode,
            numer: n,
            denom: i,
            continued: !1,
            hasBarLine: r,
            barSize: h,
            leftDelim: o,
            rightDelim: s,
            size: m,
          };
        },
        htmlBuilder: Or,
        mathmlBuilder: Rr,
      }),
        _t({
          type: "infix",
          names: ["\\above"],
          props: { numArgs: 1, argTypes: ["size"], infix: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = (t.funcName, t.token);
            return {
              type: "infix",
              mode: r.mode,
              replaceWith: "\\\\abovefrac",
              size: Ce(e[0], "size").value,
              token: a,
            };
          },
        }),
        _t({
          type: "genfrac",
          names: ["\\\\abovefrac"],
          props: { numArgs: 3, argTypes: ["math", "size", "math"] },
          handler: function (t, e) {
            var r = t.parser,
              a = (t.funcName, e[0]),
              n = (function (t) {
                if (!t)
                  throw new Error("Expected non-null, but got " + String(t));
                return t;
              })(Ce(e[1], "infix").size),
              i = e[2],
              o = n.number > 0;
            return {
              type: "genfrac",
              mode: r.mode,
              numer: a,
              denom: i,
              continued: !1,
              hasBarLine: o,
              barSize: n,
              leftDelim: null,
              rightDelim: null,
              size: "auto",
            };
          },
          htmlBuilder: Or,
          mathmlBuilder: Rr,
        });
      var Pr = function (t, e) {
        var r,
          a,
          n = e.style;
        "supsub" === t.type
          ? ((r = t.sup
              ? oe(t.sup, e.havingStyle(n.sup()), e)
              : oe(t.sub, e.havingStyle(n.sub()), e)),
            (a = Ce(t.base, "horizBrace")))
          : (a = Ce(t, "horizBrace"));
        var i,
          o = oe(a.base, e.havingBaseStyle(w.DISPLAY)),
          s = Be(a, e);
        if (
          (a.isOver
            ? (i = Dt.makeVList(
                {
                  positionType: "firstBaseline",
                  children: [
                    { type: "elem", elem: o },
                    { type: "kern", size: 0.1 },
                    { type: "elem", elem: s },
                  ],
                },
                e,
              )).children[0].children[0].children[1].classes.push("svg-align")
            : (i = Dt.makeVList(
                {
                  positionType: "bottom",
                  positionData: o.depth + 0.1 + s.height,
                  children: [
                    { type: "elem", elem: s },
                    { type: "kern", size: 0.1 },
                    { type: "elem", elem: o },
                  ],
                },
                e,
              )).children[0].children[0].children[0].classes.push("svg-align"),
          r)
        ) {
          var l = Dt.makeSpan(["mord", a.isOver ? "mover" : "munder"], [i], e);
          i = a.isOver
            ? Dt.makeVList(
                {
                  positionType: "firstBaseline",
                  children: [
                    { type: "elem", elem: l },
                    { type: "kern", size: 0.2 },
                    { type: "elem", elem: r },
                  ],
                },
                e,
              )
            : Dt.makeVList(
                {
                  positionType: "bottom",
                  positionData: l.depth + 0.2 + r.height + r.depth,
                  children: [
                    { type: "elem", elem: r },
                    { type: "kern", size: 0.2 },
                    { type: "elem", elem: l },
                  ],
                },
                e,
              );
        }
        return Dt.makeSpan(["mord", a.isOver ? "mover" : "munder"], [i], e);
      };
      _t({
        type: "horizBrace",
        names: ["\\overbrace", "\\underbrace"],
        props: { numArgs: 1 },
        handler: function (t, e) {
          var r = t.parser,
            a = t.funcName;
          return {
            type: "horizBrace",
            mode: r.mode,
            label: a,
            isOver: /^\\over/.test(a),
            base: e[0],
          };
        },
        htmlBuilder: Pr,
        mathmlBuilder: function (t, e) {
          var r = Te(t.label);
          return new ue.MathNode(t.isOver ? "mover" : "munder", [
            ve(t.base, e),
            r,
          ]);
        },
      }),
        _t({
          type: "href",
          names: ["\\href"],
          props: {
            numArgs: 2,
            argTypes: ["url", "original"],
            allowedInText: !0,
          },
          handler: function (t, e) {
            var r = t.parser,
              a = e[1],
              n = Ce(e[0], "url").url;
            return r.settings.isTrusted({ command: "\\href", url: n })
              ? { type: "href", mode: r.mode, href: n, body: $t(a) }
              : r.formatUnsupportedCmd("\\href");
          },
          htmlBuilder: function (t, e) {
            var r = ee(t.body, e, !1);
            return Dt.makeAnchor(t.href, [], r, e);
          },
          mathmlBuilder: function (t, e) {
            var r = xe(t.body, e);
            return (
              r instanceof me || (r = new me("mrow", [r])),
              r.setAttribute("href", t.href),
              r
            );
          },
        }),
        _t({
          type: "href",
          names: ["\\url"],
          props: { numArgs: 1, argTypes: ["url"], allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = Ce(e[0], "url").url;
            if (!r.settings.isTrusted({ command: "\\url", url: a }))
              return r.formatUnsupportedCmd("\\url");
            for (var n = [], i = 0; i < a.length; i++) {
              var o = a[i];
              "~" === o && (o = "\\textasciitilde"),
                n.push({ type: "textord", mode: "text", text: o });
            }
            var s = { type: "text", mode: r.mode, font: "\\texttt", body: n };
            return { type: "href", mode: r.mode, href: a, body: $t(s) };
          },
        }),
        _t({
          type: "html",
          names: ["\\htmlClass", "\\htmlId", "\\htmlStyle", "\\htmlData"],
          props: {
            numArgs: 2,
            argTypes: ["raw", "original"],
            allowedInText: !0,
          },
          handler: function (t, e) {
            var r,
              a = t.parser,
              n = t.funcName,
              i = (t.token, Ce(e[0], "raw").string),
              s = e[1];
            a.settings.strict &&
              a.settings.reportNonstrict(
                "htmlExtension",
                "HTML extension is disabled on strict mode",
              );
            var l = {};
            switch (n) {
              case "\\htmlClass":
                (l.class = i), (r = { command: "\\htmlClass", class: i });
                break;
              case "\\htmlId":
                (l.id = i), (r = { command: "\\htmlId", id: i });
                break;
              case "\\htmlStyle":
                (l.style = i), (r = { command: "\\htmlStyle", style: i });
                break;
              case "\\htmlData":
                for (var h = i.split(","), m = 0; m < h.length; m++) {
                  var c = h[m].split("=");
                  if (2 !== c.length)
                    throw new o("Error parsing key-value for \\htmlData");
                  l["data-" + c[0].trim()] = c[1].trim();
                }
                r = { command: "\\htmlData", attributes: l };
                break;
              default:
                throw new Error("Unrecognized html command");
            }
            return a.settings.isTrusted(r)
              ? { type: "html", mode: a.mode, attributes: l, body: $t(s) }
              : a.formatUnsupportedCmd(n);
          },
          htmlBuilder: function (t, e) {
            var r = ee(t.body, e, !1),
              a = ["enclosing"];
            t.attributes.class &&
              a.push.apply(a, t.attributes.class.trim().split(/\s+/));
            var n = Dt.makeSpan(a, r, e);
            for (var i in t.attributes)
              "class" !== i &&
                t.attributes.hasOwnProperty(i) &&
                n.setAttribute(i, t.attributes[i]);
            return n;
          },
          mathmlBuilder: function (t, e) {
            return xe(t.body, e);
          },
        }),
        _t({
          type: "htmlmathml",
          names: ["\\html@mathml"],
          props: { numArgs: 2, allowedInText: !0 },
          handler: function (t, e) {
            return {
              type: "htmlmathml",
              mode: t.parser.mode,
              html: $t(e[0]),
              mathml: $t(e[1]),
            };
          },
          htmlBuilder: function (t, e) {
            var r = ee(t.html, e, !1);
            return Dt.makeFragment(r);
          },
          mathmlBuilder: function (t, e) {
            return xe(t.mathml, e);
          },
        });
      var Dr = function (t) {
        if (/^[-+]? *(\d+(\.\d*)?|\.\d+)$/.test(t))
          return { number: +t, unit: "bp" };
        var e = /([-+]?) *(\d+(?:\.\d*)?|\.\d+) *([a-z]{2})/.exec(t);
        if (!e) throw new o("Invalid size: '" + t + "' in \\includegraphics");
        var r = { number: +(e[1] + e[2]), unit: e[3] };
        if (!At(r))
          throw new o("Invalid unit: '" + r.unit + "' in \\includegraphics.");
        return r;
      };
      _t({
        type: "includegraphics",
        names: ["\\includegraphics"],
        props: {
          numArgs: 1,
          numOptionalArgs: 1,
          argTypes: ["raw", "url"],
          allowedInText: !1,
        },
        handler: function (t, e, r) {
          var a = t.parser,
            n = { number: 0, unit: "em" },
            i = { number: 0.9, unit: "em" },
            s = { number: 0, unit: "em" },
            l = "";
          if (r[0])
            for (
              var h = Ce(r[0], "raw").string.split(","), m = 0;
              m < h.length;
              m++
            ) {
              var c = h[m].split("=");
              if (2 === c.length) {
                var u = c[1].trim();
                switch (c[0].trim()) {
                  case "alt":
                    l = u;
                    break;
                  case "width":
                    n = Dr(u);
                    break;
                  case "height":
                    i = Dr(u);
                    break;
                  case "totalheight":
                    s = Dr(u);
                    break;
                  default:
                    throw new o(
                      "Invalid key: '" + c[0] + "' in \\includegraphics.",
                    );
                }
              }
            }
          var p = Ce(e[0], "url").url;
          return (
            "" === l &&
              (l = (l = (l = p).replace(/^.*[\\/]/, "")).substring(
                0,
                l.lastIndexOf("."),
              )),
            a.settings.isTrusted({ command: "\\includegraphics", url: p })
              ? {
                  type: "includegraphics",
                  mode: a.mode,
                  alt: l,
                  width: n,
                  height: i,
                  totalheight: s,
                  src: p,
                }
              : a.formatUnsupportedCmd("\\includegraphics")
          );
        },
        htmlBuilder: function (t, e) {
          var r = Tt(t.height, e),
            a = 0;
          t.totalheight.number > 0 &&
            ((a = Tt(t.totalheight, e) - r), (a = Number(a.toFixed(2))));
          var n = 0;
          t.width.number > 0 && (n = Tt(t.width, e));
          var i = { height: r + a + "em" };
          n > 0 && (i.width = n + "em"), a > 0 && (i.verticalAlign = -a + "em");
          var o = new O(t.src, t.alt, i);
          return (o.height = r), (o.depth = a), o;
        },
        mathmlBuilder: function (t, e) {
          var r = new ue.MathNode("mglyph", []);
          r.setAttribute("alt", t.alt);
          var a = Tt(t.height, e),
            n = 0;
          if (
            (t.totalheight.number > 0 &&
              ((n = (n = Tt(t.totalheight, e) - a).toFixed(2)),
              r.setAttribute("valign", "-" + n + "em")),
            r.setAttribute("height", a + n + "em"),
            t.width.number > 0)
          ) {
            var i = Tt(t.width, e);
            r.setAttribute("width", i + "em");
          }
          return r.setAttribute("src", t.src), r;
        },
      }),
        _t({
          type: "kern",
          names: ["\\kern", "\\mkern", "\\hskip", "\\mskip"],
          props: { numArgs: 1, argTypes: ["size"], allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = t.funcName,
              n = Ce(e[0], "size");
            if (r.settings.strict) {
              var i = "m" === a[1],
                o = "mu" === n.value.unit;
              i
                ? (o ||
                    r.settings.reportNonstrict(
                      "mathVsTextUnits",
                      "LaTeX's " +
                        a +
                        " supports only mu units, not " +
                        n.value.unit +
                        " units",
                    ),
                  "math" !== r.mode &&
                    r.settings.reportNonstrict(
                      "mathVsTextUnits",
                      "LaTeX's " + a + " works only in math mode",
                    ))
                : o &&
                  r.settings.reportNonstrict(
                    "mathVsTextUnits",
                    "LaTeX's " + a + " doesn't support mu units",
                  );
            }
            return { type: "kern", mode: r.mode, dimension: n.value };
          },
          htmlBuilder: function (t, e) {
            return Dt.makeGlue(t.dimension, e);
          },
          mathmlBuilder: function (t, e) {
            var r = Tt(t.dimension, e);
            return new ue.SpaceNode(r);
          },
        }),
        _t({
          type: "lap",
          names: ["\\mathllap", "\\mathrlap", "\\mathclap"],
          props: { numArgs: 1, allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = t.funcName,
              n = e[0];
            return {
              type: "lap",
              mode: r.mode,
              alignment: a.slice(5),
              body: n,
            };
          },
          htmlBuilder: function (t, e) {
            var r;
            "clap" === t.alignment
              ? ((r = Dt.makeSpan([], [oe(t.body, e)])),
                (r = Dt.makeSpan(["inner"], [r], e)))
              : (r = Dt.makeSpan(["inner"], [oe(t.body, e)]));
            var a = Dt.makeSpan(["fix"], []),
              n = Dt.makeSpan([t.alignment], [r, a], e),
              i = Dt.makeSpan(["strut"]);
            return (
              (i.style.height = n.height + n.depth + "em"),
              (i.style.verticalAlign = -n.depth + "em"),
              n.children.unshift(i),
              (n = Dt.makeSpan(["thinbox"], [n], e)),
              Dt.makeSpan(["mord", "vbox"], [n], e)
            );
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.MathNode("mpadded", [ve(t.body, e)]);
            if ("rlap" !== t.alignment) {
              var a = "llap" === t.alignment ? "-1" : "-0.5";
              r.setAttribute("lspace", a + "width");
            }
            return r.setAttribute("width", "0px"), r;
          },
        }),
        _t({
          type: "styling",
          names: ["\\(", "$"],
          props: { numArgs: 0, allowedInText: !0, allowedInMath: !1 },
          handler: function (t, e) {
            var r = t.funcName,
              a = t.parser,
              n = a.mode;
            a.switchMode("math");
            var i = "\\(" === r ? "\\)" : "$",
              o = a.parseExpression(!1, i);
            return (
              a.expect(i),
              a.switchMode(n),
              { type: "styling", mode: a.mode, style: "text", body: o }
            );
          },
        }),
        _t({
          type: "text",
          names: ["\\)", "\\]"],
          props: { numArgs: 0, allowedInText: !0, allowedInMath: !1 },
          handler: function (t, e) {
            throw new o("Mismatched " + t.funcName);
          },
        });
      var Hr = function (t, e) {
        switch (e.style.size) {
          case w.DISPLAY.size:
            return t.display;
          case w.TEXT.size:
            return t.text;
          case w.SCRIPT.size:
            return t.script;
          case w.SCRIPTSCRIPT.size:
            return t.scriptscript;
          default:
            return t.text;
        }
      };
      _t({
        type: "mathchoice",
        names: ["\\mathchoice"],
        props: { numArgs: 4 },
        handler: function (t, e) {
          return {
            type: "mathchoice",
            mode: t.parser.mode,
            display: $t(e[0]),
            text: $t(e[1]),
            script: $t(e[2]),
            scriptscript: $t(e[3]),
          };
        },
        htmlBuilder: function (t, e) {
          var r = Hr(t, e),
            a = ee(r, e, !1);
          return Dt.makeFragment(a);
        },
        mathmlBuilder: function (t, e) {
          var r = Hr(t, e);
          return xe(r, e);
        },
      });
      var Fr = function (t, e, r, a, n, i, o) {
          var s, l, h;
          if (((t = Dt.makeSpan([], [t])), e)) {
            var m = oe(e, a.havingStyle(n.sup()), a);
            l = {
              elem: m,
              kern: Math.max(
                a.fontMetrics().bigOpSpacing1,
                a.fontMetrics().bigOpSpacing3 - m.depth,
              ),
            };
          }
          if (r) {
            var c = oe(r, a.havingStyle(n.sub()), a);
            s = {
              elem: c,
              kern: Math.max(
                a.fontMetrics().bigOpSpacing2,
                a.fontMetrics().bigOpSpacing4 - c.height,
              ),
            };
          }
          if (l && s) {
            var u =
              a.fontMetrics().bigOpSpacing5 +
              s.elem.height +
              s.elem.depth +
              s.kern +
              t.depth +
              o;
            h = Dt.makeVList(
              {
                positionType: "bottom",
                positionData: u,
                children: [
                  { type: "kern", size: a.fontMetrics().bigOpSpacing5 },
                  { type: "elem", elem: s.elem, marginLeft: -i + "em" },
                  { type: "kern", size: s.kern },
                  { type: "elem", elem: t },
                  { type: "kern", size: l.kern },
                  { type: "elem", elem: l.elem, marginLeft: i + "em" },
                  { type: "kern", size: a.fontMetrics().bigOpSpacing5 },
                ],
              },
              a,
            );
          } else if (s) {
            var p = t.height - o;
            h = Dt.makeVList(
              {
                positionType: "top",
                positionData: p,
                children: [
                  { type: "kern", size: a.fontMetrics().bigOpSpacing5 },
                  { type: "elem", elem: s.elem, marginLeft: -i + "em" },
                  { type: "kern", size: s.kern },
                  { type: "elem", elem: t },
                ],
              },
              a,
            );
          } else {
            if (!l) return t;
            var d = t.depth + o;
            h = Dt.makeVList(
              {
                positionType: "bottom",
                positionData: d,
                children: [
                  { type: "elem", elem: t },
                  { type: "kern", size: l.kern },
                  { type: "elem", elem: l.elem, marginLeft: i + "em" },
                  { type: "kern", size: a.fontMetrics().bigOpSpacing5 },
                ],
              },
              a,
            );
          }
          return Dt.makeSpan(["mop", "op-limits"], [h], a);
        },
        Vr = ["\\smallint"],
        Ur = function (t, e) {
          var r,
            a,
            n,
            i = !1;
          "supsub" === t.type
            ? ((r = t.sup), (a = t.sub), (n = Ce(t.base, "op")), (i = !0))
            : (n = Ce(t, "op"));
          var o,
            s = e.style,
            l = !1;
          if (
            (s.size === w.DISPLAY.size &&
              n.symbol &&
              !c.contains(Vr, n.name) &&
              (l = !0),
            n.symbol)
          ) {
            var h = l ? "Size2-Regular" : "Size1-Regular",
              m = "";
            if (
              (("\\oiint" !== n.name && "\\oiiint" !== n.name) ||
                ((m = n.name.substr(1)),
                (n.name = "oiint" === m ? "\\iint" : "\\iiint")),
              (o = Dt.makeSymbol(n.name, h, "math", e, [
                "mop",
                "op-symbol",
                l ? "large-op" : "small-op",
              ])),
              m.length > 0)
            ) {
              var u = o.italic,
                p = Dt.staticSvg(m + "Size" + (l ? "2" : "1"), e);
              (o = Dt.makeVList(
                {
                  positionType: "individualShift",
                  children: [
                    { type: "elem", elem: o, shift: 0 },
                    { type: "elem", elem: p, shift: l ? 0.08 : 0 },
                  ],
                },
                e,
              )),
                (n.name = "\\" + m),
                o.classes.unshift("mop"),
                (o.italic = u);
            }
          } else if (n.body) {
            var d = ee(n.body, e, !0);
            1 === d.length && d[0] instanceof E
              ? ((o = d[0]).classes[0] = "mop")
              : (o = Dt.makeSpan(["mop"], Dt.tryCombineChars(d), e));
          } else {
            for (var f = [], g = 1; g < n.name.length; g++)
              f.push(Dt.mathsym(n.name[g], n.mode, e));
            o = Dt.makeSpan(["mop"], f, e);
          }
          var x = 0,
            v = 0;
          return (
            (o instanceof E || "\\oiint" === n.name || "\\oiiint" === n.name) &&
              !n.suppressBaseShift &&
              ((x = (o.height - o.depth) / 2 - e.fontMetrics().axisHeight),
              (v = o.italic)),
            i
              ? Fr(o, r, a, e, s, v, x)
              : (x &&
                  ((o.style.position = "relative"), (o.style.top = x + "em")),
                o)
          );
        },
        Gr = function (t, e) {
          var r;
          if (t.symbol)
            (r = new me("mo", [pe(t.name, t.mode)])),
              c.contains(Vr, t.name) && r.setAttribute("largeop", "false");
          else if (t.body) r = new me("mo", ge(t.body, e));
          else {
            r = new me("mi", [new ce(t.name.slice(1))]);
            var a = new me("mo", [pe("\u2061", "text")]);
            r = t.parentIsSupSub ? new me("mo", [r, a]) : he([r, a]);
          }
          return r;
        },
        Yr = {
          "\u220f": "\\prod",
          "\u2210": "\\coprod",
          "\u2211": "\\sum",
          "\u22c0": "\\bigwedge",
          "\u22c1": "\\bigvee",
          "\u22c2": "\\bigcap",
          "\u22c3": "\\bigcup",
          "\u2a00": "\\bigodot",
          "\u2a01": "\\bigoplus",
          "\u2a02": "\\bigotimes",
          "\u2a04": "\\biguplus",
          "\u2a06": "\\bigsqcup",
        };
      _t({
        type: "op",
        names: [
          "\\coprod",
          "\\bigvee",
          "\\bigwedge",
          "\\biguplus",
          "\\bigcap",
          "\\bigcup",
          "\\intop",
          "\\prod",
          "\\sum",
          "\\bigotimes",
          "\\bigoplus",
          "\\bigodot",
          "\\bigsqcup",
          "\\smallint",
          "\u220f",
          "\u2210",
          "\u2211",
          "\u22c0",
          "\u22c1",
          "\u22c2",
          "\u22c3",
          "\u2a00",
          "\u2a01",
          "\u2a02",
          "\u2a04",
          "\u2a06",
        ],
        props: { numArgs: 0 },
        handler: function (t, e) {
          var r = t.parser,
            a = t.funcName;
          return (
            1 === a.length && (a = Yr[a]),
            {
              type: "op",
              mode: r.mode,
              limits: !0,
              parentIsSupSub: !1,
              symbol: !0,
              name: a,
            }
          );
        },
        htmlBuilder: Ur,
        mathmlBuilder: Gr,
      }),
        _t({
          type: "op",
          names: ["\\mathop"],
          props: { numArgs: 1 },
          handler: function (t, e) {
            var r = t.parser,
              a = e[0];
            return {
              type: "op",
              mode: r.mode,
              limits: !1,
              parentIsSupSub: !1,
              symbol: !1,
              body: $t(a),
            };
          },
          htmlBuilder: Ur,
          mathmlBuilder: Gr,
        });
      var Wr = {
        "\u222b": "\\int",
        "\u222c": "\\iint",
        "\u222d": "\\iiint",
        "\u222e": "\\oint",
        "\u222f": "\\oiint",
        "\u2230": "\\oiiint",
      };
      _t({
        type: "op",
        names: [
          "\\arcsin",
          "\\arccos",
          "\\arctan",
          "\\arctg",
          "\\arcctg",
          "\\arg",
          "\\ch",
          "\\cos",
          "\\cosec",
          "\\cosh",
          "\\cot",
          "\\cotg",
          "\\coth",
          "\\csc",
          "\\ctg",
          "\\cth",
          "\\deg",
          "\\dim",
          "\\exp",
          "\\hom",
          "\\ker",
          "\\lg",
          "\\ln",
          "\\log",
          "\\sec",
          "\\sin",
          "\\sinh",
          "\\sh",
          "\\tan",
          "\\tanh",
          "\\tg",
          "\\th",
        ],
        props: { numArgs: 0 },
        handler: function (t) {
          var e = t.parser,
            r = t.funcName;
          return {
            type: "op",
            mode: e.mode,
            limits: !1,
            parentIsSupSub: !1,
            symbol: !1,
            name: r,
          };
        },
        htmlBuilder: Ur,
        mathmlBuilder: Gr,
      }),
        _t({
          type: "op",
          names: [
            "\\det",
            "\\gcd",
            "\\inf",
            "\\lim",
            "\\max",
            "\\min",
            "\\Pr",
            "\\sup",
          ],
          props: { numArgs: 0 },
          handler: function (t) {
            var e = t.parser,
              r = t.funcName;
            return {
              type: "op",
              mode: e.mode,
              limits: !0,
              parentIsSupSub: !1,
              symbol: !1,
              name: r,
            };
          },
          htmlBuilder: Ur,
          mathmlBuilder: Gr,
        }),
        _t({
          type: "op",
          names: [
            "\\int",
            "\\iint",
            "\\iiint",
            "\\oint",
            "\\oiint",
            "\\oiiint",
            "\u222b",
            "\u222c",
            "\u222d",
            "\u222e",
            "\u222f",
            "\u2230",
          ],
          props: { numArgs: 0 },
          handler: function (t) {
            var e = t.parser,
              r = t.funcName;
            return (
              1 === r.length && (r = Wr[r]),
              {
                type: "op",
                mode: e.mode,
                limits: !1,
                parentIsSupSub: !1,
                symbol: !0,
                name: r,
              }
            );
          },
          htmlBuilder: Ur,
          mathmlBuilder: Gr,
        });
      var Xr = function (t, e) {
        var r,
          a,
          n,
          i,
          o = !1;
        if (
          ("supsub" === t.type
            ? ((r = t.sup),
              (a = t.sub),
              (n = Ce(t.base, "operatorname")),
              (o = !0))
            : (n = Ce(t, "operatorname")),
          n.body.length > 0)
        ) {
          for (
            var s = n.body.map(function (t) {
                var e = t.text;
                return "string" == typeof e
                  ? { type: "textord", mode: t.mode, text: e }
                  : t;
              }),
              l = ee(s, e.withFont("mathrm"), !0),
              h = 0;
            h < l.length;
            h++
          ) {
            var m = l[h];
            m instanceof E &&
              (m.text = m.text.replace(/\u2212/, "-").replace(/\u2217/, "*"));
          }
          i = Dt.makeSpan(["mop"], l, e);
        } else i = Dt.makeSpan(["mop"], [], e);
        return o ? Fr(i, r, a, e, e.style, 0, 0) : i;
      };
      function _r(t, e, r) {
        for (
          var a = ee(t, e, !1), n = e.sizeMultiplier / r.sizeMultiplier, i = 0;
          i < a.length;
          i++
        ) {
          var o = a[i].classes.indexOf("sizing");
          o < 0
            ? Array.prototype.push.apply(a[i].classes, e.sizingClasses(r))
            : a[i].classes[o + 1] === "reset-size" + e.size &&
              (a[i].classes[o + 1] = "reset-size" + r.size),
            (a[i].height *= n),
            (a[i].depth *= n);
        }
        return Dt.makeFragment(a);
      }
      _t({
        type: "operatorname",
        names: ["\\operatorname", "\\operatorname*"],
        props: { numArgs: 1 },
        handler: function (t, e) {
          var r = t.parser,
            a = t.funcName,
            n = e[0];
          return {
            type: "operatorname",
            mode: r.mode,
            body: $t(n),
            alwaysHandleSupSub: "\\operatorname*" === a,
            limits: !1,
            parentIsSupSub: !1,
          };
        },
        htmlBuilder: Xr,
        mathmlBuilder: function (t, e) {
          for (
            var r = ge(t.body, e.withFont("mathrm")), a = !0, n = 0;
            n < r.length;
            n++
          ) {
            var i = r[n];
            if (i instanceof ue.SpaceNode);
            else if (i instanceof ue.MathNode)
              switch (i.type) {
                case "mi":
                case "mn":
                case "ms":
                case "mspace":
                case "mtext":
                  break;
                case "mo":
                  var o = i.children[0];
                  1 === i.children.length && o instanceof ue.TextNode
                    ? (o.text = o.text
                        .replace(/\u2212/, "-")
                        .replace(/\u2217/, "*"))
                    : (a = !1);
                  break;
                default:
                  a = !1;
              }
            else a = !1;
          }
          if (a) {
            var s = r
              .map(function (t) {
                return t.toText();
              })
              .join("");
            r = [new ue.TextNode(s)];
          }
          var l = new ue.MathNode("mi", r);
          l.setAttribute("mathvariant", "normal");
          var h = new ue.MathNode("mo", [pe("\u2061", "text")]);
          return t.parentIsSupSub
            ? new ue.MathNode("mo", [l, h])
            : ue.newDocumentFragment([l, h]);
        },
      }),
        jt({
          type: "ordgroup",
          htmlBuilder: function (t, e) {
            return t.semisimple
              ? Dt.makeFragment(ee(t.body, e, !1))
              : Dt.makeSpan(["mord"], ee(t.body, e, !0), e);
          },
          mathmlBuilder: function (t, e) {
            return xe(t.body, e, !0);
          },
        }),
        _t({
          type: "overline",
          names: ["\\overline"],
          props: { numArgs: 1 },
          handler: function (t, e) {
            var r = t.parser,
              a = e[0];
            return { type: "overline", mode: r.mode, body: a };
          },
          htmlBuilder: function (t, e) {
            var r = oe(t.body, e.havingCrampedStyle()),
              a = Dt.makeLineSpan("overline-line", e),
              n = e.fontMetrics().defaultRuleThickness,
              i = Dt.makeVList(
                {
                  positionType: "firstBaseline",
                  children: [
                    { type: "elem", elem: r },
                    { type: "kern", size: 3 * n },
                    { type: "elem", elem: a },
                    { type: "kern", size: n },
                  ],
                },
                e,
              );
            return Dt.makeSpan(["mord", "overline"], [i], e);
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.MathNode("mo", [new ue.TextNode("\u203e")]);
            r.setAttribute("stretchy", "true");
            var a = new ue.MathNode("mover", [ve(t.body, e), r]);
            return a.setAttribute("accent", "true"), a;
          },
        }),
        _t({
          type: "phantom",
          names: ["\\phantom"],
          props: { numArgs: 1, allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = e[0];
            return { type: "phantom", mode: r.mode, body: $t(a) };
          },
          htmlBuilder: function (t, e) {
            var r = ee(t.body, e.withPhantom(), !1);
            return Dt.makeFragment(r);
          },
          mathmlBuilder: function (t, e) {
            var r = ge(t.body, e);
            return new ue.MathNode("mphantom", r);
          },
        }),
        _t({
          type: "hphantom",
          names: ["\\hphantom"],
          props: { numArgs: 1, allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = e[0];
            return { type: "hphantom", mode: r.mode, body: a };
          },
          htmlBuilder: function (t, e) {
            var r = Dt.makeSpan([], [oe(t.body, e.withPhantom())]);
            if (((r.height = 0), (r.depth = 0), r.children))
              for (var a = 0; a < r.children.length; a++)
                (r.children[a].height = 0), (r.children[a].depth = 0);
            return (
              (r = Dt.makeVList(
                {
                  positionType: "firstBaseline",
                  children: [{ type: "elem", elem: r }],
                },
                e,
              )),
              Dt.makeSpan(["mord"], [r], e)
            );
          },
          mathmlBuilder: function (t, e) {
            var r = ge($t(t.body), e),
              a = new ue.MathNode("mphantom", r),
              n = new ue.MathNode("mpadded", [a]);
            return (
              n.setAttribute("height", "0px"), n.setAttribute("depth", "0px"), n
            );
          },
        }),
        _t({
          type: "vphantom",
          names: ["\\vphantom"],
          props: { numArgs: 1, allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = e[0];
            return { type: "vphantom", mode: r.mode, body: a };
          },
          htmlBuilder: function (t, e) {
            var r = Dt.makeSpan(["inner"], [oe(t.body, e.withPhantom())]),
              a = Dt.makeSpan(["fix"], []);
            return Dt.makeSpan(["mord", "rlap"], [r, a], e);
          },
          mathmlBuilder: function (t, e) {
            var r = ge($t(t.body), e),
              a = new ue.MathNode("mphantom", r),
              n = new ue.MathNode("mpadded", [a]);
            return n.setAttribute("width", "0px"), n;
          },
        }),
        _t({
          type: "raisebox",
          names: ["\\raisebox"],
          props: { numArgs: 2, argTypes: ["size", "hbox"], allowedInText: !0 },
          handler: function (t, e) {
            var r = t.parser,
              a = Ce(e[0], "size").value,
              n = e[1];
            return { type: "raisebox", mode: r.mode, dy: a, body: n };
          },
          htmlBuilder: function (t, e) {
            var r = oe(t.body, e),
              a = Tt(t.dy, e);
            return Dt.makeVList(
              {
                positionType: "shift",
                positionData: -a,
                children: [{ type: "elem", elem: r }],
              },
              e,
            );
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.MathNode("mpadded", [ve(t.body, e)]),
              a = t.dy.number + t.dy.unit;
            return r.setAttribute("voffset", a), r;
          },
        }),
        _t({
          type: "rule",
          names: ["\\rule"],
          props: {
            numArgs: 2,
            numOptionalArgs: 1,
            argTypes: ["size", "size", "size"],
          },
          handler: function (t, e, r) {
            var a = t.parser,
              n = r[0],
              i = Ce(e[0], "size"),
              o = Ce(e[1], "size");
            return {
              type: "rule",
              mode: a.mode,
              shift: n && Ce(n, "size").value,
              width: i.value,
              height: o.value,
            };
          },
          htmlBuilder: function (t, e) {
            var r = Dt.makeSpan(["mord", "rule"], [], e),
              a = Tt(t.width, e),
              n = Tt(t.height, e),
              i = t.shift ? Tt(t.shift, e) : 0;
            return (
              (r.style.borderRightWidth = a + "em"),
              (r.style.borderTopWidth = n + "em"),
              (r.style.bottom = i + "em"),
              (r.width = a),
              (r.height = n + i),
              (r.depth = -i),
              (r.maxFontSize = 1.125 * n * e.sizeMultiplier),
              r
            );
          },
          mathmlBuilder: function (t, e) {
            var r = Tt(t.width, e),
              a = Tt(t.height, e),
              n = t.shift ? Tt(t.shift, e) : 0,
              i = (e.color && e.getColor()) || "black",
              o = new ue.MathNode("mspace");
            o.setAttribute("mathbackground", i),
              o.setAttribute("width", r + "em"),
              o.setAttribute("height", a + "em");
            var s = new ue.MathNode("mpadded", [o]);
            return (
              n >= 0
                ? s.setAttribute("height", "+" + n + "em")
                : (s.setAttribute("height", n + "em"),
                  s.setAttribute("depth", "+" + -n + "em")),
              s.setAttribute("voffset", n + "em"),
              s
            );
          },
        });
      var jr = [
        "\\tiny",
        "\\sixptsize",
        "\\scriptsize",
        "\\footnotesize",
        "\\small",
        "\\normalsize",
        "\\large",
        "\\Large",
        "\\LARGE",
        "\\huge",
        "\\Huge",
      ];
      _t({
        type: "sizing",
        names: jr,
        props: { numArgs: 0, allowedInText: !0 },
        handler: function (t, e) {
          var r = t.breakOnTokenText,
            a = t.funcName,
            n = t.parser,
            i = n.parseExpression(!1, r);
          return {
            type: "sizing",
            mode: n.mode,
            size: jr.indexOf(a) + 1,
            body: i,
          };
        },
        htmlBuilder: function (t, e) {
          var r = e.havingSize(t.size);
          return _r(t.body, r, e);
        },
        mathmlBuilder: function (t, e) {
          var r = e.havingSize(t.size),
            a = ge(t.body, r),
            n = new ue.MathNode("mstyle", a);
          return n.setAttribute("mathsize", r.sizeMultiplier + "em"), n;
        },
      }),
        _t({
          type: "smash",
          names: ["\\smash"],
          props: { numArgs: 1, numOptionalArgs: 1, allowedInText: !0 },
          handler: function (t, e, r) {
            var a = t.parser,
              n = !1,
              i = !1,
              o = r[0] && Ce(r[0], "ordgroup");
            if (o)
              for (var s = "", l = 0; l < o.body.length; ++l) {
                if ("t" === (s = o.body[l].text)) n = !0;
                else {
                  if ("b" !== s) {
                    (n = !1), (i = !1);
                    break;
                  }
                  i = !0;
                }
              }
            else (n = !0), (i = !0);
            var h = e[0];
            return {
              type: "smash",
              mode: a.mode,
              body: h,
              smashHeight: n,
              smashDepth: i,
            };
          },
          htmlBuilder: function (t, e) {
            var r = Dt.makeSpan([], [oe(t.body, e)]);
            if (!t.smashHeight && !t.smashDepth) return r;
            if (t.smashHeight && ((r.height = 0), r.children))
              for (var a = 0; a < r.children.length; a++)
                r.children[a].height = 0;
            if (t.smashDepth && ((r.depth = 0), r.children))
              for (var n = 0; n < r.children.length; n++)
                r.children[n].depth = 0;
            var i = Dt.makeVList(
              {
                positionType: "firstBaseline",
                children: [{ type: "elem", elem: r }],
              },
              e,
            );
            return Dt.makeSpan(["mord"], [i], e);
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.MathNode("mpadded", [ve(t.body, e)]);
            return (
              t.smashHeight && r.setAttribute("height", "0px"),
              t.smashDepth && r.setAttribute("depth", "0px"),
              r
            );
          },
        }),
        _t({
          type: "sqrt",
          names: ["\\sqrt"],
          props: { numArgs: 1, numOptionalArgs: 1 },
          handler: function (t, e, r) {
            var a = t.parser,
              n = r[0],
              i = e[0];
            return { type: "sqrt", mode: a.mode, body: i, index: n };
          },
          htmlBuilder: function (t, e) {
            var r = oe(t.body, e.havingCrampedStyle());
            0 === r.height && (r.height = e.fontMetrics().xHeight),
              (r = Dt.wrapFragment(r, e));
            var a = e.fontMetrics().defaultRuleThickness,
              n = a;
            e.style.id < w.TEXT.id && (n = e.fontMetrics().xHeight);
            var i = a + n / 4,
              o = r.height + r.depth + i + a,
              s = ir(o, e),
              l = s.span,
              h = s.ruleWidth,
              m = s.advanceWidth,
              c = l.height - h;
            c > r.height + r.depth + i &&
              (i = (i + c - r.height - r.depth) / 2);
            var u = l.height - r.height - i - h;
            r.style.paddingLeft = m + "em";
            var p = Dt.makeVList(
              {
                positionType: "firstBaseline",
                children: [
                  { type: "elem", elem: r, wrapperClasses: ["svg-align"] },
                  { type: "kern", size: -(r.height + u) },
                  { type: "elem", elem: l },
                  { type: "kern", size: h },
                ],
              },
              e,
            );
            if (t.index) {
              var d = e.havingStyle(w.SCRIPTSCRIPT),
                f = oe(t.index, d, e),
                g = 0.6 * (p.height - p.depth),
                x = Dt.makeVList(
                  {
                    positionType: "shift",
                    positionData: -g,
                    children: [{ type: "elem", elem: f }],
                  },
                  e,
                ),
                v = Dt.makeSpan(["root"], [x]);
              return Dt.makeSpan(["mord", "sqrt"], [v, p], e);
            }
            return Dt.makeSpan(["mord", "sqrt"], [p], e);
          },
          mathmlBuilder: function (t, e) {
            var r = t.body,
              a = t.index;
            return a
              ? new ue.MathNode("mroot", [ve(r, e), ve(a, e)])
              : new ue.MathNode("msqrt", [ve(r, e)]);
          },
        });
      var $r = {
        display: w.DISPLAY,
        text: w.TEXT,
        script: w.SCRIPT,
        scriptscript: w.SCRIPTSCRIPT,
      };
      _t({
        type: "styling",
        names: [
          "\\displaystyle",
          "\\textstyle",
          "\\scriptstyle",
          "\\scriptscriptstyle",
        ],
        props: { numArgs: 0, allowedInText: !0 },
        handler: function (t, e) {
          var r = t.breakOnTokenText,
            a = t.funcName,
            n = t.parser,
            i = n.parseExpression(!0, r),
            o = a.slice(1, a.length - 5);
          return { type: "styling", mode: n.mode, style: o, body: i };
        },
        htmlBuilder: function (t, e) {
          var r = $r[t.style],
            a = e.havingStyle(r).withFont("");
          return _r(t.body, a, e);
        },
        mathmlBuilder: function (t, e) {
          var r = $r[t.style],
            a = e.havingStyle(r),
            n = ge(t.body, a),
            i = new ue.MathNode("mstyle", n),
            o = {
              display: ["0", "true"],
              text: ["0", "false"],
              script: ["1", "false"],
              scriptscript: ["2", "false"],
            }[t.style];
          return (
            i.setAttribute("scriptlevel", o[0]),
            i.setAttribute("displaystyle", o[1]),
            i
          );
        },
      });
      jt({
        type: "supsub",
        htmlBuilder: function (t, e) {
          var r = (function (t, e) {
            var r = t.base;
            return r
              ? "op" === r.type
                ? r.limits &&
                  (e.style.size === w.DISPLAY.size || r.alwaysHandleSupSub)
                  ? Ur
                  : null
                : "operatorname" === r.type
                  ? r.alwaysHandleSupSub &&
                    (e.style.size === w.DISPLAY.size || r.limits)
                    ? Xr
                    : null
                  : "accent" === r.type
                    ? c.isCharacterBox(r.base)
                      ? Ie
                      : null
                    : "horizBrace" === r.type && !t.sub === r.isOver
                      ? Pr
                      : null
              : null;
          })(t, e);
          if (r) return r(t, e);
          var a,
            n,
            i,
            o = t.base,
            s = t.sup,
            l = t.sub,
            h = oe(o, e),
            m = e.fontMetrics(),
            u = 0,
            p = 0,
            d = o && c.isCharacterBox(o);
          if (s) {
            var f = e.havingStyle(e.style.sup());
            (a = oe(s, f, e)),
              d ||
                (u =
                  h.height -
                  (f.fontMetrics().supDrop * f.sizeMultiplier) /
                    e.sizeMultiplier);
          }
          if (l) {
            var g = e.havingStyle(e.style.sub());
            (n = oe(l, g, e)),
              d ||
                (p =
                  h.depth +
                  (g.fontMetrics().subDrop * g.sizeMultiplier) /
                    e.sizeMultiplier);
          }
          i =
            e.style === w.DISPLAY ? m.sup1 : e.style.cramped ? m.sup3 : m.sup2;
          var x,
            v = e.sizeMultiplier,
            b = 0.5 / m.ptPerEm / v + "em",
            y = null;
          if (n) {
            var k =
              t.base &&
              "op" === t.base.type &&
              t.base.name &&
              ("\\oiint" === t.base.name || "\\oiiint" === t.base.name);
            (h instanceof E || k) && (y = -h.italic + "em");
          }
          if (a && n) {
            (u = Math.max(u, i, a.depth + 0.25 * m.xHeight)),
              (p = Math.max(p, m.sub2));
            var S = 4 * m.defaultRuleThickness;
            if (u - a.depth - (n.height - p) < S) {
              p = S - (u - a.depth) + n.height;
              var M = 0.8 * m.xHeight - (u - a.depth);
              M > 0 && ((u += M), (p -= M));
            }
            var z = [
              {
                type: "elem",
                elem: n,
                shift: p,
                marginRight: b,
                marginLeft: y,
              },
              { type: "elem", elem: a, shift: -u, marginRight: b },
            ];
            x = Dt.makeVList(
              { positionType: "individualShift", children: z },
              e,
            );
          } else if (n) {
            p = Math.max(p, m.sub1, n.height - 0.8 * m.xHeight);
            var A = [{ type: "elem", elem: n, marginLeft: y, marginRight: b }];
            x = Dt.makeVList(
              { positionType: "shift", positionData: p, children: A },
              e,
            );
          } else {
            if (!a) throw new Error("supsub must have either sup or sub.");
            (u = Math.max(u, i, a.depth + 0.25 * m.xHeight)),
              (x = Dt.makeVList(
                {
                  positionType: "shift",
                  positionData: -u,
                  children: [{ type: "elem", elem: a, marginRight: b }],
                },
                e,
              ));
          }
          var T = ne(h, "right") || "mord";
          return Dt.makeSpan([T], [h, Dt.makeSpan(["msupsub"], [x])], e);
        },
        mathmlBuilder: function (t, e) {
          var r,
            a = !1;
          t.base &&
            "horizBrace" === t.base.type &&
            !!t.sup === t.base.isOver &&
            ((a = !0), (r = t.base.isOver)),
            !t.base ||
              ("op" !== t.base.type && "operatorname" !== t.base.type) ||
              (t.base.parentIsSupSub = !0);
          var n,
            i = [ve(t.base, e)];
          if ((t.sub && i.push(ve(t.sub, e)), t.sup && i.push(ve(t.sup, e)), a))
            n = r ? "mover" : "munder";
          else if (t.sub)
            if (t.sup) {
              var o = t.base;
              n =
                o && "op" === o.type && o.limits && e.style === w.DISPLAY
                  ? "munderover"
                  : o &&
                      "operatorname" === o.type &&
                      o.alwaysHandleSupSub &&
                      (e.style === w.DISPLAY || o.limits)
                    ? "munderover"
                    : "msubsup";
            } else {
              var s = t.base;
              n =
                s &&
                "op" === s.type &&
                s.limits &&
                (e.style === w.DISPLAY || s.alwaysHandleSupSub)
                  ? "munder"
                  : s &&
                      "operatorname" === s.type &&
                      s.alwaysHandleSupSub &&
                      (s.limits || e.style === w.DISPLAY)
                    ? "munder"
                    : "msub";
            }
          else {
            var l = t.base;
            n =
              l &&
              "op" === l.type &&
              l.limits &&
              (e.style === w.DISPLAY || l.alwaysHandleSupSub)
                ? "mover"
                : l &&
                    "operatorname" === l.type &&
                    l.alwaysHandleSupSub &&
                    (l.limits || e.style === w.DISPLAY)
                  ? "mover"
                  : "msup";
          }
          return new ue.MathNode(n, i);
        },
      }),
        jt({
          type: "atom",
          htmlBuilder: function (t, e) {
            return Dt.mathsym(t.text, t.mode, e, ["m" + t.family]);
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.MathNode("mo", [pe(t.text, t.mode)]);
            if ("bin" === t.family) {
              var a = fe(t, e);
              "bold-italic" === a && r.setAttribute("mathvariant", a);
            } else
              "punct" === t.family
                ? r.setAttribute("separator", "true")
                : ("open" !== t.family && "close" !== t.family) ||
                  r.setAttribute("stretchy", "false");
            return r;
          },
        });
      var Zr = { mi: "italic", mn: "normal", mtext: "normal" };
      jt({
        type: "mathord",
        htmlBuilder: function (t, e) {
          return Dt.makeOrd(t, e, "mathord");
        },
        mathmlBuilder: function (t, e) {
          var r = new ue.MathNode("mi", [pe(t.text, t.mode, e)]),
            a = fe(t, e) || "italic";
          return a !== Zr[r.type] && r.setAttribute("mathvariant", a), r;
        },
      }),
        jt({
          type: "textord",
          htmlBuilder: function (t, e) {
            return Dt.makeOrd(t, e, "textord");
          },
          mathmlBuilder: function (t, e) {
            var r,
              a = pe(t.text, t.mode, e),
              n = fe(t, e) || "normal";
            return (
              (r =
                "text" === t.mode
                  ? new ue.MathNode("mtext", [a])
                  : /[0-9]/.test(t.text)
                    ? new ue.MathNode("mn", [a])
                    : "\\prime" === t.text
                      ? new ue.MathNode("mo", [a])
                      : new ue.MathNode("mi", [a])),
              n !== Zr[r.type] && r.setAttribute("mathvariant", n),
              r
            );
          },
        });
      var Kr = { "\\nobreak": "nobreak", "\\allowbreak": "allowbreak" },
        Jr = {
          " ": {},
          "\\ ": {},
          "~": { className: "nobreak" },
          "\\space": {},
          "\\nobreakspace": { className: "nobreak" },
        };
      jt({
        type: "spacing",
        htmlBuilder: function (t, e) {
          if (Jr.hasOwnProperty(t.text)) {
            var r = Jr[t.text].className || "";
            if ("text" === t.mode) {
              var a = Dt.makeOrd(t, e, "textord");
              return a.classes.push(r), a;
            }
            return Dt.makeSpan(
              ["mspace", r],
              [Dt.mathsym(t.text, t.mode, e)],
              e,
            );
          }
          if (Kr.hasOwnProperty(t.text))
            return Dt.makeSpan(["mspace", Kr[t.text]], [], e);
          throw new o('Unknown type of space "' + t.text + '"');
        },
        mathmlBuilder: function (t, e) {
          if (!Jr.hasOwnProperty(t.text)) {
            if (Kr.hasOwnProperty(t.text)) return new ue.MathNode("mspace");
            throw new o('Unknown type of space "' + t.text + '"');
          }
          return new ue.MathNode("mtext", [new ue.TextNode("\xa0")]);
        },
      });
      var Qr = function () {
        var t = new ue.MathNode("mtd", []);
        return t.setAttribute("width", "50%"), t;
      };
      jt({
        type: "tag",
        mathmlBuilder: function (t, e) {
          var r = new ue.MathNode("mtable", [
            new ue.MathNode("mtr", [
              Qr(),
              new ue.MathNode("mtd", [xe(t.body, e)]),
              Qr(),
              new ue.MathNode("mtd", [xe(t.tag, e)]),
            ]),
          ]);
          return r.setAttribute("width", "100%"), r;
        },
      });
      var ta = {
          "\\text": void 0,
          "\\textrm": "textrm",
          "\\textsf": "textsf",
          "\\texttt": "texttt",
          "\\textnormal": "textrm",
        },
        ea = { "\\textbf": "textbf", "\\textmd": "textmd" },
        ra = { "\\textit": "textit", "\\textup": "textup" },
        aa = function (t, e) {
          var r = t.font;
          return r
            ? ta[r]
              ? e.withTextFontFamily(ta[r])
              : ea[r]
                ? e.withTextFontWeight(ea[r])
                : e.withTextFontShape(ra[r])
            : e;
        };
      _t({
        type: "text",
        names: [
          "\\text",
          "\\textrm",
          "\\textsf",
          "\\texttt",
          "\\textnormal",
          "\\textbf",
          "\\textmd",
          "\\textit",
          "\\textup",
        ],
        props: {
          numArgs: 1,
          argTypes: ["text"],
          greediness: 2,
          allowedInText: !0,
        },
        handler: function (t, e) {
          var r = t.parser,
            a = t.funcName,
            n = e[0];
          return { type: "text", mode: r.mode, body: $t(n), font: a };
        },
        htmlBuilder: function (t, e) {
          var r = aa(t, e),
            a = ee(t.body, r, !0);
          return Dt.makeSpan(["mord", "text"], Dt.tryCombineChars(a), r);
        },
        mathmlBuilder: function (t, e) {
          var r = aa(t, e);
          return xe(t.body, r);
        },
      }),
        _t({
          type: "underline",
          names: ["\\underline"],
          props: { numArgs: 1, allowedInText: !0 },
          handler: function (t, e) {
            return { type: "underline", mode: t.parser.mode, body: e[0] };
          },
          htmlBuilder: function (t, e) {
            var r = oe(t.body, e),
              a = Dt.makeLineSpan("underline-line", e),
              n = e.fontMetrics().defaultRuleThickness,
              i = Dt.makeVList(
                {
                  positionType: "top",
                  positionData: r.height,
                  children: [
                    { type: "kern", size: n },
                    { type: "elem", elem: a },
                    { type: "kern", size: 3 * n },
                    { type: "elem", elem: r },
                  ],
                },
                e,
              );
            return Dt.makeSpan(["mord", "underline"], [i], e);
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.MathNode("mo", [new ue.TextNode("\u203e")]);
            r.setAttribute("stretchy", "true");
            var a = new ue.MathNode("munder", [ve(t.body, e), r]);
            return a.setAttribute("accentunder", "true"), a;
          },
        }),
        _t({
          type: "verb",
          names: ["\\verb"],
          props: { numArgs: 0, allowedInText: !0 },
          handler: function (t, e, r) {
            throw new o(
              "\\verb ended by end of line instead of matching delimiter",
            );
          },
          htmlBuilder: function (t, e) {
            for (
              var r = na(t), a = [], n = e.havingStyle(e.style.text()), i = 0;
              i < r.length;
              i++
            ) {
              var o = r[i];
              "~" === o && (o = "\\textasciitilde"),
                a.push(
                  Dt.makeSymbol(o, "Typewriter-Regular", t.mode, n, [
                    "mord",
                    "texttt",
                  ]),
                );
            }
            return Dt.makeSpan(
              ["mord", "text"].concat(n.sizingClasses(e)),
              Dt.tryCombineChars(a),
              n,
            );
          },
          mathmlBuilder: function (t, e) {
            var r = new ue.TextNode(na(t)),
              a = new ue.MathNode("mtext", [r]);
            return a.setAttribute("mathvariant", "monospace"), a;
          },
        });
      var na = function (t) {
          return t.body.replace(/ /g, t.star ? "\u2423" : "\xa0");
        },
        ia = Yt,
        oa = new RegExp("^(\\\\[a-zA-Z@]+)[ \r\n\t]*$"),
        sa = new RegExp("[\u0300-\u036f]+$"),
        la =
          "([ \r\n\t]+)|([!-\\[\\]-\u2027\u202a-\ud7ff\uf900-\uffff][\u0300-\u036f]*|[\ud800-\udbff][\udc00-\udfff][\u0300-\u036f]*|\\\\verb\\*([^]).*?\\3|\\\\verb([^*a-zA-Z]).*?\\4|\\\\operatorname\\*|\\\\[a-zA-Z@]+[ \r\n\t]*|\\\\[^\ud800-\udfff])",
        ha = (function () {
          function t(t, e) {
            (this.input = void 0),
              (this.settings = void 0),
              (this.tokenRegex = void 0),
              (this.catcodes = void 0),
              (this.input = t),
              (this.settings = e),
              (this.tokenRegex = new RegExp(la, "g")),
              (this.catcodes = { "%": 14 });
          }
          var e = t.prototype;
          return (
            (e.setCatcode = function (t, e) {
              this.catcodes[t] = e;
            }),
            (e.lex = function () {
              var t = this.input,
                e = this.tokenRegex.lastIndex;
              if (e === t.length) return new n("EOF", new a(this, e, e));
              var r = this.tokenRegex.exec(t);
              if (null === r || r.index !== e)
                throw new o(
                  "Unexpected character: '" + t[e] + "'",
                  new n(t[e], new a(this, e, e + 1)),
                );
              var i = r[2] || " ";
              if (14 === this.catcodes[i]) {
                var s = t.indexOf("\n", this.tokenRegex.lastIndex);
                return (
                  -1 === s
                    ? ((this.tokenRegex.lastIndex = t.length),
                      this.settings.reportNonstrict(
                        "commentAtEnd",
                        "% comment has no terminating newline; LaTeX would fail because of commenting the end of math mode (e.g. $)",
                      ))
                    : (this.tokenRegex.lastIndex = s + 1),
                  this.lex()
                );
              }
              var l = i.match(oa);
              return (
                l && (i = l[1]),
                new n(i, new a(this, e, this.tokenRegex.lastIndex))
              );
            }),
            t
          );
        })(),
        ma = (function () {
          function t(t, e) {
            void 0 === t && (t = {}),
              void 0 === e && (e = {}),
              (this.current = void 0),
              (this.builtins = void 0),
              (this.undefStack = void 0),
              (this.current = e),
              (this.builtins = t),
              (this.undefStack = []);
          }
          var e = t.prototype;
          return (
            (e.beginGroup = function () {
              this.undefStack.push({});
            }),
            (e.endGroup = function () {
              if (0 === this.undefStack.length)
                throw new o(
                  "Unbalanced namespace destruction: attempt to pop global namespace; please report this as a bug",
                );
              var t = this.undefStack.pop();
              for (var e in t)
                t.hasOwnProperty(e) &&
                  (void 0 === t[e]
                    ? delete this.current[e]
                    : (this.current[e] = t[e]));
            }),
            (e.has = function (t) {
              return (
                this.current.hasOwnProperty(t) ||
                this.builtins.hasOwnProperty(t)
              );
            }),
            (e.get = function (t) {
              return this.current.hasOwnProperty(t)
                ? this.current[t]
                : this.builtins[t];
            }),
            (e.set = function (t, e, r) {
              if ((void 0 === r && (r = !1), r)) {
                for (var a = 0; a < this.undefStack.length; a++)
                  delete this.undefStack[a][t];
                this.undefStack.length > 0 &&
                  (this.undefStack[this.undefStack.length - 1][t] = e);
              } else {
                var n = this.undefStack[this.undefStack.length - 1];
                n && !n.hasOwnProperty(t) && (n[t] = this.current[t]);
              }
              this.current[t] = e;
            }),
            t
          );
        })(),
        ca = {},
        ua = ca;
      function pa(t, e) {
        ca[t] = e;
      }
      pa("\\noexpand", function (t) {
        var e = t.popToken();
        return (
          t.isExpandable(e.text) && ((e.noexpand = !0), (e.treatAsRelax = !0)),
          { tokens: [e], numArgs: 0 }
        );
      }),
        pa("\\expandafter", function (t) {
          var e = t.popToken();
          return t.expandOnce(!0), { tokens: [e], numArgs: 0 };
        }),
        pa("\\@firstoftwo", function (t) {
          return { tokens: t.consumeArgs(2)[0], numArgs: 0 };
        }),
        pa("\\@secondoftwo", function (t) {
          return { tokens: t.consumeArgs(2)[1], numArgs: 0 };
        }),
        pa("\\@ifnextchar", function (t) {
          var e = t.consumeArgs(3);
          t.consumeSpaces();
          var r = t.future();
          return 1 === e[0].length && e[0][0].text === r.text
            ? { tokens: e[1], numArgs: 0 }
            : { tokens: e[2], numArgs: 0 };
        }),
        pa("\\@ifstar", "\\@ifnextchar *{\\@firstoftwo{#1}}"),
        pa("\\TextOrMath", function (t) {
          var e = t.consumeArgs(2);
          return "text" === t.mode
            ? { tokens: e[0], numArgs: 0 }
            : { tokens: e[1], numArgs: 0 };
        });
      var da = {
        0: 0,
        1: 1,
        2: 2,
        3: 3,
        4: 4,
        5: 5,
        6: 6,
        7: 7,
        8: 8,
        9: 9,
        a: 10,
        A: 10,
        b: 11,
        B: 11,
        c: 12,
        C: 12,
        d: 13,
        D: 13,
        e: 14,
        E: 14,
        f: 15,
        F: 15,
      };
      pa("\\char", function (t) {
        var e,
          r = t.popToken(),
          a = "";
        if ("'" === r.text) (e = 8), (r = t.popToken());
        else if ('"' === r.text) (e = 16), (r = t.popToken());
        else if ("`" === r.text)
          if ("\\" === (r = t.popToken()).text[0]) a = r.text.charCodeAt(1);
          else {
            if ("EOF" === r.text) throw new o("\\char` missing argument");
            a = r.text.charCodeAt(0);
          }
        else e = 10;
        if (e) {
          if (null == (a = da[r.text]) || a >= e)
            throw new o("Invalid base-" + e + " digit " + r.text);
          for (var n; null != (n = da[t.future().text]) && n < e; )
            (a *= e), (a += n), t.popToken();
        }
        return "\\@char{" + a + "}";
      });
      var fa = function (t, e, r) {
        var a = t.consumeArgs(1)[0];
        if (1 !== a.length)
          throw new o("\\newcommand's first argument must be a macro name");
        var n = a[0].text,
          i = t.isDefined(n);
        if (i && !e)
          throw new o(
            "\\newcommand{" +
              n +
              "} attempting to redefine " +
              n +
              "; use \\renewcommand",
          );
        if (!i && !r)
          throw new o(
            "\\renewcommand{" +
              n +
              "} when command " +
              n +
              " does not yet exist; use \\newcommand",
          );
        var s = 0;
        if (1 === (a = t.consumeArgs(1)[0]).length && "[" === a[0].text) {
          for (
            var l = "", h = t.expandNextToken();
            "]" !== h.text && "EOF" !== h.text;

          )
            (l += h.text), (h = t.expandNextToken());
          if (!l.match(/^\s*[0-9]+\s*$/))
            throw new o("Invalid number of arguments: " + l);
          (s = parseInt(l)), (a = t.consumeArgs(1)[0]);
        }
        return t.macros.set(n, { tokens: a, numArgs: s }), "";
      };
      pa("\\newcommand", function (t) {
        return fa(t, !1, !0);
      }),
        pa("\\renewcommand", function (t) {
          return fa(t, !0, !1);
        }),
        pa("\\providecommand", function (t) {
          return fa(t, !0, !0);
        }),
        pa("\\message", function (t) {
          var e = t.consumeArgs(1)[0];
          return (
            console.log(
              e
                .reverse()
                .map(function (t) {
                  return t.text;
                })
                .join(""),
            ),
            ""
          );
        }),
        pa("\\errmessage", function (t) {
          var e = t.consumeArgs(1)[0];
          return (
            console.error(
              e
                .reverse()
                .map(function (t) {
                  return t.text;
                })
                .join(""),
            ),
            ""
          );
        }),
        pa("\\show", function (t) {
          var e = t.popToken(),
            r = e.text;
          return (
            console.log(e, t.macros.get(r), ia[r], j.math[r], j.text[r]), ""
          );
        }),
        pa("\\bgroup", "{"),
        pa("\\egroup", "}"),
        pa("\\lq", "`"),
        pa("\\rq", "'"),
        pa("\\aa", "\\r a"),
        pa("\\AA", "\\r A"),
        pa("\\textcopyright", "\\html@mathml{\\textcircled{c}}{\\char`\xa9}"),
        pa(
          "\\copyright",
          "\\TextOrMath{\\textcopyright}{\\text{\\textcopyright}}",
        ),
        pa(
          "\\textregistered",
          "\\html@mathml{\\textcircled{\\scriptsize R}}{\\char`\xae}",
        ),
        pa("\u212c", "\\mathscr{B}"),
        pa("\u2130", "\\mathscr{E}"),
        pa("\u2131", "\\mathscr{F}"),
        pa("\u210b", "\\mathscr{H}"),
        pa("\u2110", "\\mathscr{I}"),
        pa("\u2112", "\\mathscr{L}"),
        pa("\u2133", "\\mathscr{M}"),
        pa("\u211b", "\\mathscr{R}"),
        pa("\u212d", "\\mathfrak{C}"),
        pa("\u210c", "\\mathfrak{H}"),
        pa("\u2128", "\\mathfrak{Z}"),
        pa("\\Bbbk", "\\Bbb{k}"),
        pa("\xb7", "\\cdotp"),
        pa("\\llap", "\\mathllap{\\textrm{#1}}"),
        pa("\\rlap", "\\mathrlap{\\textrm{#1}}"),
        pa("\\clap", "\\mathclap{\\textrm{#1}}"),
        pa("\\not", '\\html@mathml{\\mathrel{\\mathrlap\\@not}}{\\char"338}'),
        pa(
          "\\neq",
          "\\html@mathml{\\mathrel{\\not=}}{\\mathrel{\\char`\u2260}}",
        ),
        pa("\\ne", "\\neq"),
        pa("\u2260", "\\neq"),
        pa(
          "\\notin",
          "\\html@mathml{\\mathrel{{\\in}\\mathllap{/\\mskip1mu}}}{\\mathrel{\\char`\u2209}}",
        ),
        pa("\u2209", "\\notin"),
        pa(
          "\u2258",
          "\\html@mathml{\\mathrel{=\\kern{-1em}\\raisebox{0.4em}{$\\scriptsize\\frown$}}}{\\mathrel{\\char`\u2258}}",
        ),
        pa(
          "\u2259",
          "\\html@mathml{\\stackrel{\\tiny\\wedge}{=}}{\\mathrel{\\char`\u2258}}",
        ),
        pa(
          "\u225a",
          "\\html@mathml{\\stackrel{\\tiny\\vee}{=}}{\\mathrel{\\char`\u225a}}",
        ),
        pa(
          "\u225b",
          "\\html@mathml{\\stackrel{\\scriptsize\\star}{=}}{\\mathrel{\\char`\u225b}}",
        ),
        pa(
          "\u225d",
          "\\html@mathml{\\stackrel{\\tiny\\mathrm{def}}{=}}{\\mathrel{\\char`\u225d}}",
        ),
        pa(
          "\u225e",
          "\\html@mathml{\\stackrel{\\tiny\\mathrm{m}}{=}}{\\mathrel{\\char`\u225e}}",
        ),
        pa(
          "\u225f",
          "\\html@mathml{\\stackrel{\\tiny?}{=}}{\\mathrel{\\char`\u225f}}",
        ),
        pa("\u27c2", "\\perp"),
        pa("\u203c", "\\mathclose{!\\mkern-0.8mu!}"),
        pa("\u220c", "\\notni"),
        pa("\u231c", "\\ulcorner"),
        pa("\u231d", "\\urcorner"),
        pa("\u231e", "\\llcorner"),
        pa("\u231f", "\\lrcorner"),
        pa("\xa9", "\\copyright"),
        pa("\xae", "\\textregistered"),
        pa("\ufe0f", "\\textregistered"),
        pa("\\ulcorner", '\\html@mathml{\\@ulcorner}{\\mathop{\\char"231c}}'),
        pa("\\urcorner", '\\html@mathml{\\@urcorner}{\\mathop{\\char"231d}}'),
        pa("\\llcorner", '\\html@mathml{\\@llcorner}{\\mathop{\\char"231e}}'),
        pa("\\lrcorner", '\\html@mathml{\\@lrcorner}{\\mathop{\\char"231f}}'),
        pa("\\vdots", "\\mathord{\\varvdots\\rule{0pt}{15pt}}"),
        pa("\u22ee", "\\vdots"),
        pa("\\varGamma", "\\mathit{\\Gamma}"),
        pa("\\varDelta", "\\mathit{\\Delta}"),
        pa("\\varTheta", "\\mathit{\\Theta}"),
        pa("\\varLambda", "\\mathit{\\Lambda}"),
        pa("\\varXi", "\\mathit{\\Xi}"),
        pa("\\varPi", "\\mathit{\\Pi}"),
        pa("\\varSigma", "\\mathit{\\Sigma}"),
        pa("\\varUpsilon", "\\mathit{\\Upsilon}"),
        pa("\\varPhi", "\\mathit{\\Phi}"),
        pa("\\varPsi", "\\mathit{\\Psi}"),
        pa("\\varOmega", "\\mathit{\\Omega}"),
        pa("\\substack", "\\begin{subarray}{c}#1\\end{subarray}"),
        pa(
          "\\colon",
          "\\nobreak\\mskip2mu\\mathpunct{}\\mathchoice{\\mkern-3mu}{\\mkern-3mu}{}{}{:}\\mskip6mu",
        ),
        pa("\\boxed", "\\fbox{$\\displaystyle{#1}$}"),
        pa("\\iff", "\\DOTSB\\;\\Longleftrightarrow\\;"),
        pa("\\implies", "\\DOTSB\\;\\Longrightarrow\\;"),
        pa("\\impliedby", "\\DOTSB\\;\\Longleftarrow\\;");
      var ga = {
        ",": "\\dotsc",
        "\\not": "\\dotsb",
        "+": "\\dotsb",
        "=": "\\dotsb",
        "<": "\\dotsb",
        ">": "\\dotsb",
        "-": "\\dotsb",
        "*": "\\dotsb",
        ":": "\\dotsb",
        "\\DOTSB": "\\dotsb",
        "\\coprod": "\\dotsb",
        "\\bigvee": "\\dotsb",
        "\\bigwedge": "\\dotsb",
        "\\biguplus": "\\dotsb",
        "\\bigcap": "\\dotsb",
        "\\bigcup": "\\dotsb",
        "\\prod": "\\dotsb",
        "\\sum": "\\dotsb",
        "\\bigotimes": "\\dotsb",
        "\\bigoplus": "\\dotsb",
        "\\bigodot": "\\dotsb",
        "\\bigsqcup": "\\dotsb",
        "\\And": "\\dotsb",
        "\\longrightarrow": "\\dotsb",
        "\\Longrightarrow": "\\dotsb",
        "\\longleftarrow": "\\dotsb",
        "\\Longleftarrow": "\\dotsb",
        "\\longleftrightarrow": "\\dotsb",
        "\\Longleftrightarrow": "\\dotsb",
        "\\mapsto": "\\dotsb",
        "\\longmapsto": "\\dotsb",
        "\\hookrightarrow": "\\dotsb",
        "\\doteq": "\\dotsb",
        "\\mathbin": "\\dotsb",
        "\\mathrel": "\\dotsb",
        "\\relbar": "\\dotsb",
        "\\Relbar": "\\dotsb",
        "\\xrightarrow": "\\dotsb",
        "\\xleftarrow": "\\dotsb",
        "\\DOTSI": "\\dotsi",
        "\\int": "\\dotsi",
        "\\oint": "\\dotsi",
        "\\iint": "\\dotsi",
        "\\iiint": "\\dotsi",
        "\\iiiint": "\\dotsi",
        "\\idotsint": "\\dotsi",
        "\\DOTSX": "\\dotsx",
      };
      pa("\\dots", function (t) {
        var e = "\\dotso",
          r = t.expandAfterFuture().text;
        return (
          r in ga
            ? (e = ga[r])
            : "\\not" === r.substr(0, 4)
              ? (e = "\\dotsb")
              : r in j.math &&
                c.contains(["bin", "rel"], j.math[r].group) &&
                (e = "\\dotsb"),
          e
        );
      });
      var xa = {
        ")": !0,
        "]": !0,
        "\\rbrack": !0,
        "\\}": !0,
        "\\rbrace": !0,
        "\\rangle": !0,
        "\\rceil": !0,
        "\\rfloor": !0,
        "\\rgroup": !0,
        "\\rmoustache": !0,
        "\\right": !0,
        "\\bigr": !0,
        "\\biggr": !0,
        "\\Bigr": !0,
        "\\Biggr": !0,
        $: !0,
        ";": !0,
        ".": !0,
        ",": !0,
      };
      pa("\\dotso", function (t) {
        return t.future().text in xa ? "\\ldots\\," : "\\ldots";
      }),
        pa("\\dotsc", function (t) {
          var e = t.future().text;
          return e in xa && "," !== e ? "\\ldots\\," : "\\ldots";
        }),
        pa("\\cdots", function (t) {
          return t.future().text in xa ? "\\@cdots\\," : "\\@cdots";
        }),
        pa("\\dotsb", "\\cdots"),
        pa("\\dotsm", "\\cdots"),
        pa("\\dotsi", "\\!\\cdots"),
        pa("\\dotsx", "\\ldots\\,"),
        pa("\\DOTSI", "\\relax"),
        pa("\\DOTSB", "\\relax"),
        pa("\\DOTSX", "\\relax"),
        pa("\\tmspace", "\\TextOrMath{\\kern#1#3}{\\mskip#1#2}\\relax"),
        pa("\\,", "\\tmspace+{3mu}{.1667em}"),
        pa("\\thinspace", "\\,"),
        pa("\\>", "\\mskip{4mu}"),
        pa("\\:", "\\tmspace+{4mu}{.2222em}"),
        pa("\\medspace", "\\:"),
        pa("\\;", "\\tmspace+{5mu}{.2777em}"),
        pa("\\thickspace", "\\;"),
        pa("\\!", "\\tmspace-{3mu}{.1667em}"),
        pa("\\negthinspace", "\\!"),
        pa("\\negmedspace", "\\tmspace-{4mu}{.2222em}"),
        pa("\\negthickspace", "\\tmspace-{5mu}{.277em}"),
        pa("\\enspace", "\\kern.5em "),
        pa("\\enskip", "\\hskip.5em\\relax"),
        pa("\\quad", "\\hskip1em\\relax"),
        pa("\\qquad", "\\hskip2em\\relax"),
        pa("\\tag", "\\@ifstar\\tag@literal\\tag@paren"),
        pa("\\tag@paren", "\\tag@literal{({#1})}"),
        pa("\\tag@literal", function (t) {
          if (t.macros.get("\\df@tag")) throw new o("Multiple \\tag");
          return "\\gdef\\df@tag{\\text{#1}}";
        }),
        pa(
          "\\bmod",
          "\\mathchoice{\\mskip1mu}{\\mskip1mu}{\\mskip5mu}{\\mskip5mu}\\mathbin{\\rm mod}\\mathchoice{\\mskip1mu}{\\mskip1mu}{\\mskip5mu}{\\mskip5mu}",
        ),
        pa(
          "\\pod",
          "\\allowbreak\\mathchoice{\\mkern18mu}{\\mkern8mu}{\\mkern8mu}{\\mkern8mu}(#1)",
        ),
        pa("\\pmod", "\\pod{{\\rm mod}\\mkern6mu#1}"),
        pa(
          "\\mod",
          "\\allowbreak\\mathchoice{\\mkern18mu}{\\mkern12mu}{\\mkern12mu}{\\mkern12mu}{\\rm mod}\\,\\,#1",
        ),
        pa(
          "\\pmb",
          "\\html@mathml{\\@binrel{#1}{\\mathrlap{#1}\\kern0.5px#1}}{\\mathbf{#1}}",
        ),
        pa("\\\\", "\\newline"),
        pa(
          "\\TeX",
          "\\textrm{\\html@mathml{T\\kern-.1667em\\raisebox{-.5ex}{E}\\kern-.125emX}{TeX}}",
        );
      var va =
        F["Main-Regular"]["T".charCodeAt(0)][1] -
        0.7 * F["Main-Regular"]["A".charCodeAt(0)][1] +
        "em";
      pa(
        "\\LaTeX",
        "\\textrm{\\html@mathml{L\\kern-.36em\\raisebox{" +
          va +
          "}{\\scriptstyle A}\\kern-.15em\\TeX}{LaTeX}}",
      ),
        pa(
          "\\KaTeX",
          "\\textrm{\\html@mathml{K\\kern-.17em\\raisebox{" +
            va +
            "}{\\scriptstyle A}\\kern-.15em\\TeX}{KaTeX}}",
        ),
        pa("\\hspace", "\\@ifstar\\@hspacer\\@hspace"),
        pa("\\@hspace", "\\hskip #1\\relax"),
        pa("\\@hspacer", "\\rule{0pt}{0pt}\\hskip #1\\relax"),
        pa("\\ordinarycolon", ":"),
        pa("\\vcentcolon", "\\mathrel{\\mathop\\ordinarycolon}"),
        pa(
          "\\dblcolon",
          '\\html@mathml{\\mathrel{\\vcentcolon\\mathrel{\\mkern-.9mu}\\vcentcolon}}{\\mathop{\\char"2237}}',
        ),
        pa(
          "\\coloneqq",
          '\\html@mathml{\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}=}}{\\mathop{\\char"2254}}',
        ),
        pa(
          "\\Coloneqq",
          '\\html@mathml{\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}=}}{\\mathop{\\char"2237\\char"3d}}',
        ),
        pa(
          "\\coloneq",
          '\\html@mathml{\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}\\mathrel{-}}}{\\mathop{\\char"3a\\char"2212}}',
        ),
        pa(
          "\\Coloneq",
          '\\html@mathml{\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}\\mathrel{-}}}{\\mathop{\\char"2237\\char"2212}}',
        ),
        pa(
          "\\eqqcolon",
          '\\html@mathml{\\mathrel{=\\mathrel{\\mkern-1.2mu}\\vcentcolon}}{\\mathop{\\char"2255}}',
        ),
        pa(
          "\\Eqqcolon",
          '\\html@mathml{\\mathrel{=\\mathrel{\\mkern-1.2mu}\\dblcolon}}{\\mathop{\\char"3d\\char"2237}}',
        ),
        pa(
          "\\eqcolon",
          '\\html@mathml{\\mathrel{\\mathrel{-}\\mathrel{\\mkern-1.2mu}\\vcentcolon}}{\\mathop{\\char"2239}}',
        ),
        pa(
          "\\Eqcolon",
          '\\html@mathml{\\mathrel{\\mathrel{-}\\mathrel{\\mkern-1.2mu}\\dblcolon}}{\\mathop{\\char"2212\\char"2237}}',
        ),
        pa(
          "\\colonapprox",
          '\\html@mathml{\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}\\approx}}{\\mathop{\\char"3a\\char"2248}}',
        ),
        pa(
          "\\Colonapprox",
          '\\html@mathml{\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}\\approx}}{\\mathop{\\char"2237\\char"2248}}',
        ),
        pa(
          "\\colonsim",
          '\\html@mathml{\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}\\sim}}{\\mathop{\\char"3a\\char"223c}}',
        ),
        pa(
          "\\Colonsim",
          '\\html@mathml{\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}\\sim}}{\\mathop{\\char"2237\\char"223c}}',
        ),
        pa("\u2237", "\\dblcolon"),
        pa("\u2239", "\\eqcolon"),
        pa("\u2254", "\\coloneqq"),
        pa("\u2255", "\\eqqcolon"),
        pa("\u2a74", "\\Coloneqq"),
        pa("\\ratio", "\\vcentcolon"),
        pa("\\coloncolon", "\\dblcolon"),
        pa("\\colonequals", "\\coloneqq"),
        pa("\\coloncolonequals", "\\Coloneqq"),
        pa("\\equalscolon", "\\eqqcolon"),
        pa("\\equalscoloncolon", "\\Eqqcolon"),
        pa("\\colonminus", "\\coloneq"),
        pa("\\coloncolonminus", "\\Coloneq"),
        pa("\\minuscolon", "\\eqcolon"),
        pa("\\minuscoloncolon", "\\Eqcolon"),
        pa("\\coloncolonapprox", "\\Colonapprox"),
        pa("\\coloncolonsim", "\\Colonsim"),
        pa(
          "\\simcolon",
          "\\mathrel{\\sim\\mathrel{\\mkern-1.2mu}\\vcentcolon}",
        ),
        pa(
          "\\simcoloncolon",
          "\\mathrel{\\sim\\mathrel{\\mkern-1.2mu}\\dblcolon}",
        ),
        pa(
          "\\approxcolon",
          "\\mathrel{\\approx\\mathrel{\\mkern-1.2mu}\\vcentcolon}",
        ),
        pa(
          "\\approxcoloncolon",
          "\\mathrel{\\approx\\mathrel{\\mkern-1.2mu}\\dblcolon}",
        ),
        pa("\\notni", "\\html@mathml{\\not\\ni}{\\mathrel{\\char`\u220c}}"),
        pa("\\limsup", "\\DOTSB\\operatorname*{lim\\,sup}"),
        pa("\\liminf", "\\DOTSB\\operatorname*{lim\\,inf}"),
        pa("\\gvertneqq", "\\html@mathml{\\@gvertneqq}{\u2269}"),
        pa("\\lvertneqq", "\\html@mathml{\\@lvertneqq}{\u2268}"),
        pa("\\ngeqq", "\\html@mathml{\\@ngeqq}{\u2271}"),
        pa("\\ngeqslant", "\\html@mathml{\\@ngeqslant}{\u2271}"),
        pa("\\nleqq", "\\html@mathml{\\@nleqq}{\u2270}"),
        pa("\\nleqslant", "\\html@mathml{\\@nleqslant}{\u2270}"),
        pa("\\nshortmid", "\\html@mathml{\\@nshortmid}{\u2224}"),
        pa("\\nshortparallel", "\\html@mathml{\\@nshortparallel}{\u2226}"),
        pa("\\nsubseteqq", "\\html@mathml{\\@nsubseteqq}{\u2288}"),
        pa("\\nsupseteqq", "\\html@mathml{\\@nsupseteqq}{\u2289}"),
        pa("\\varsubsetneq", "\\html@mathml{\\@varsubsetneq}{\u228a}"),
        pa("\\varsubsetneqq", "\\html@mathml{\\@varsubsetneqq}{\u2acb}"),
        pa("\\varsupsetneq", "\\html@mathml{\\@varsupsetneq}{\u228b}"),
        pa("\\varsupsetneqq", "\\html@mathml{\\@varsupsetneqq}{\u2acc}"),
        pa("\\imath", "\\html@mathml{\\@imath}{\u0131}"),
        pa("\\jmath", "\\html@mathml{\\@jmath}{\u0237}"),
        pa(
          "\\llbracket",
          "\\html@mathml{\\mathopen{[\\mkern-3.2mu[}}{\\mathopen{\\char`\u27e6}}",
        ),
        pa(
          "\\rrbracket",
          "\\html@mathml{\\mathclose{]\\mkern-3.2mu]}}{\\mathclose{\\char`\u27e7}}",
        ),
        pa("\u27e6", "\\llbracket"),
        pa("\u27e7", "\\rrbracket"),
        pa(
          "\\lBrace",
          "\\html@mathml{\\mathopen{\\{\\mkern-3.2mu[}}{\\mathopen{\\char`\u2983}}",
        ),
        pa(
          "\\rBrace",
          "\\html@mathml{\\mathclose{]\\mkern-3.2mu\\}}}{\\mathclose{\\char`\u2984}}",
        ),
        pa("\u2983", "\\lBrace"),
        pa("\u2984", "\\rBrace"),
        pa(
          "\\minuso",
          "\\mathbin{\\html@mathml{{\\mathrlap{\\mathchoice{\\kern{0.145em}}{\\kern{0.145em}}{\\kern{0.1015em}}{\\kern{0.0725em}}\\circ}{-}}}{\\char`\u29b5}}",
        ),
        pa("\u29b5", "\\minuso"),
        pa("\\darr", "\\downarrow"),
        pa("\\dArr", "\\Downarrow"),
        pa("\\Darr", "\\Downarrow"),
        pa("\\lang", "\\langle"),
        pa("\\rang", "\\rangle"),
        pa("\\uarr", "\\uparrow"),
        pa("\\uArr", "\\Uparrow"),
        pa("\\Uarr", "\\Uparrow"),
        pa("\\N", "\\mathbb{N}"),
        pa("\\R", "\\mathbb{R}"),
        pa("\\Z", "\\mathbb{Z}"),
        pa("\\alef", "\\aleph"),
        pa("\\alefsym", "\\aleph"),
        pa("\\Alpha", "\\mathrm{A}"),
        pa("\\Beta", "\\mathrm{B}"),
        pa("\\bull", "\\bullet"),
        pa("\\Chi", "\\mathrm{X}"),
        pa("\\clubs", "\\clubsuit"),
        pa("\\cnums", "\\mathbb{C}"),
        pa("\\Complex", "\\mathbb{C}"),
        pa("\\Dagger", "\\ddagger"),
        pa("\\diamonds", "\\diamondsuit"),
        pa("\\empty", "\\emptyset"),
        pa("\\Epsilon", "\\mathrm{E}"),
        pa("\\Eta", "\\mathrm{H}"),
        pa("\\exist", "\\exists"),
        pa("\\harr", "\\leftrightarrow"),
        pa("\\hArr", "\\Leftrightarrow"),
        pa("\\Harr", "\\Leftrightarrow"),
        pa("\\hearts", "\\heartsuit"),
        pa("\\image", "\\Im"),
        pa("\\infin", "\\infty"),
        pa("\\Iota", "\\mathrm{I}"),
        pa("\\isin", "\\in"),
        pa("\\Kappa", "\\mathrm{K}"),
        pa("\\larr", "\\leftarrow"),
        pa("\\lArr", "\\Leftarrow"),
        pa("\\Larr", "\\Leftarrow"),
        pa("\\lrarr", "\\leftrightarrow"),
        pa("\\lrArr", "\\Leftrightarrow"),
        pa("\\Lrarr", "\\Leftrightarrow"),
        pa("\\Mu", "\\mathrm{M}"),
        pa("\\natnums", "\\mathbb{N}"),
        pa("\\Nu", "\\mathrm{N}"),
        pa("\\Omicron", "\\mathrm{O}"),
        pa("\\plusmn", "\\pm"),
        pa("\\rarr", "\\rightarrow"),
        pa("\\rArr", "\\Rightarrow"),
        pa("\\Rarr", "\\Rightarrow"),
        pa("\\real", "\\Re"),
        pa("\\reals", "\\mathbb{R}"),
        pa("\\Reals", "\\mathbb{R}"),
        pa("\\Rho", "\\mathrm{P}"),
        pa("\\sdot", "\\cdot"),
        pa("\\sect", "\\S"),
        pa("\\spades", "\\spadesuit"),
        pa("\\sub", "\\subset"),
        pa("\\sube", "\\subseteq"),
        pa("\\supe", "\\supseteq"),
        pa("\\Tau", "\\mathrm{T}"),
        pa("\\thetasym", "\\vartheta"),
        pa("\\weierp", "\\wp"),
        pa("\\Zeta", "\\mathrm{Z}"),
        pa("\\argmin", "\\DOTSB\\operatorname*{arg\\,min}"),
        pa("\\argmax", "\\DOTSB\\operatorname*{arg\\,max}"),
        pa("\\plim", "\\DOTSB\\mathop{\\operatorname{plim}}\\limits"),
        pa("\\bra", "\\mathinner{\\langle{#1}|}"),
        pa("\\ket", "\\mathinner{|{#1}\\rangle}"),
        pa("\\braket", "\\mathinner{\\langle{#1}\\rangle}"),
        pa("\\Bra", "\\left\\langle#1\\right|"),
        pa("\\Ket", "\\left|#1\\right\\rangle"),
        pa("\\blue", "\\textcolor{##6495ed}{#1}"),
        pa("\\orange", "\\textcolor{##ffa500}{#1}"),
        pa("\\pink", "\\textcolor{##ff00af}{#1}"),
        pa("\\red", "\\textcolor{##df0030}{#1}"),
        pa("\\green", "\\textcolor{##28ae7b}{#1}"),
        pa("\\gray", "\\textcolor{gray}{#1}"),
        pa("\\purple", "\\textcolor{##9d38bd}{#1}"),
        pa("\\blueA", "\\textcolor{##ccfaff}{#1}"),
        pa("\\blueB", "\\textcolor{##80f6ff}{#1}"),
        pa("\\blueC", "\\textcolor{##63d9ea}{#1}"),
        pa("\\blueD", "\\textcolor{##11accd}{#1}"),
        pa("\\blueE", "\\textcolor{##0c7f99}{#1}"),
        pa("\\tealA", "\\textcolor{##94fff5}{#1}"),
        pa("\\tealB", "\\textcolor{##26edd5}{#1}"),
        pa("\\tealC", "\\textcolor{##01d1c1}{#1}"),
        pa("\\tealD", "\\textcolor{##01a995}{#1}"),
        pa("\\tealE", "\\textcolor{##208170}{#1}"),
        pa("\\greenA", "\\textcolor{##b6ffb0}{#1}"),
        pa("\\greenB", "\\textcolor{##8af281}{#1}"),
        pa("\\greenC", "\\textcolor{##74cf70}{#1}"),
        pa("\\greenD", "\\textcolor{##1fab54}{#1}"),
        pa("\\greenE", "\\textcolor{##0d923f}{#1}"),
        pa("\\goldA", "\\textcolor{##ffd0a9}{#1}"),
        pa("\\goldB", "\\textcolor{##ffbb71}{#1}"),
        pa("\\goldC", "\\textcolor{##ff9c39}{#1}"),
        pa("\\goldD", "\\textcolor{##e07d10}{#1}"),
        pa("\\goldE", "\\textcolor{##a75a05}{#1}"),
        pa("\\redA", "\\textcolor{##fca9a9}{#1}"),
        pa("\\redB", "\\textcolor{##ff8482}{#1}"),
        pa("\\redC", "\\textcolor{##f9685d}{#1}"),
        pa("\\redD", "\\textcolor{##e84d39}{#1}"),
        pa("\\redE", "\\textcolor{##bc2612}{#1}"),
        pa("\\maroonA", "\\textcolor{##ffbde0}{#1}"),
        pa("\\maroonB", "\\textcolor{##ff92c6}{#1}"),
        pa("\\maroonC", "\\textcolor{##ed5fa6}{#1}"),
        pa("\\maroonD", "\\textcolor{##ca337c}{#1}"),
        pa("\\maroonE", "\\textcolor{##9e034e}{#1}"),
        pa("\\purpleA", "\\textcolor{##ddd7ff}{#1}"),
        pa("\\purpleB", "\\textcolor{##c6b9fc}{#1}"),
        pa("\\purpleC", "\\textcolor{##aa87ff}{#1}"),
        pa("\\purpleD", "\\textcolor{##7854ab}{#1}"),
        pa("\\purpleE", "\\textcolor{##543b78}{#1}"),
        pa("\\mintA", "\\textcolor{##f5f9e8}{#1}"),
        pa("\\mintB", "\\textcolor{##edf2df}{#1}"),
        pa("\\mintC", "\\textcolor{##e0e5cc}{#1}"),
        pa("\\grayA", "\\textcolor{##f6f7f7}{#1}"),
        pa("\\grayB", "\\textcolor{##f0f1f2}{#1}"),
        pa("\\grayC", "\\textcolor{##e3e5e6}{#1}"),
        pa("\\grayD", "\\textcolor{##d6d8da}{#1}"),
        pa("\\grayE", "\\textcolor{##babec2}{#1}"),
        pa("\\grayF", "\\textcolor{##888d93}{#1}"),
        pa("\\grayG", "\\textcolor{##626569}{#1}"),
        pa("\\grayH", "\\textcolor{##3b3e40}{#1}"),
        pa("\\grayI", "\\textcolor{##21242c}{#1}"),
        pa("\\kaBlue", "\\textcolor{##314453}{#1}"),
        pa("\\kaGreen", "\\textcolor{##71B307}{#1}");
      var ba = {
          "\\relax": !0,
          "^": !0,
          _: !0,
          "\\limits": !0,
          "\\nolimits": !0,
        },
        ya = (function () {
          function t(t, e, r) {
            (this.settings = void 0),
              (this.expansionCount = void 0),
              (this.lexer = void 0),
              (this.macros = void 0),
              (this.stack = void 0),
              (this.mode = void 0),
              (this.settings = e),
              (this.expansionCount = 0),
              this.feed(t),
              (this.macros = new ma(ua, e.macros)),
              (this.mode = r),
              (this.stack = []);
          }
          var e = t.prototype;
          return (
            (e.feed = function (t) {
              this.lexer = new ha(t, this.settings);
            }),
            (e.switchMode = function (t) {
              this.mode = t;
            }),
            (e.beginGroup = function () {
              this.macros.beginGroup();
            }),
            (e.endGroup = function () {
              this.macros.endGroup();
            }),
            (e.future = function () {
              return (
                0 === this.stack.length && this.pushToken(this.lexer.lex()),
                this.stack[this.stack.length - 1]
              );
            }),
            (e.popToken = function () {
              return this.future(), this.stack.pop();
            }),
            (e.pushToken = function (t) {
              this.stack.push(t);
            }),
            (e.pushTokens = function (t) {
              var e;
              (e = this.stack).push.apply(e, t);
            }),
            (e.consumeSpaces = function () {
              for (;;) {
                if (" " !== this.future().text) break;
                this.stack.pop();
              }
            }),
            (e.consumeArgs = function (t) {
              for (var e = [], r = 0; r < t; ++r) {
                this.consumeSpaces();
                var a = this.popToken();
                if ("{" === a.text) {
                  for (var n = [], i = 1; 0 !== i; ) {
                    var s = this.popToken();
                    if ((n.push(s), "{" === s.text)) ++i;
                    else if ("}" === s.text) --i;
                    else if ("EOF" === s.text)
                      throw new o("End of input in macro argument", a);
                  }
                  n.pop(), n.reverse(), (e[r] = n);
                } else {
                  if ("EOF" === a.text)
                    throw new o("End of input expecting macro argument");
                  e[r] = [a];
                }
              }
              return e;
            }),
            (e.expandOnce = function (t) {
              var e = this.popToken(),
                r = e.text,
                a = e.noexpand ? null : this._getExpansion(r);
              if (null == a || (t && a.unexpandable)) {
                if (t && null == a && "\\" === r[0] && !this.isDefined(r))
                  throw new o("Undefined control sequence: " + r);
                return this.pushToken(e), e;
              }
              if (
                (this.expansionCount++,
                this.expansionCount > this.settings.maxExpand)
              )
                throw new o(
                  "Too many expansions: infinite loop or need to increase maxExpand setting",
                );
              var n = a.tokens;
              if (a.numArgs)
                for (
                  var i = this.consumeArgs(a.numArgs),
                    s = (n = n.slice()).length - 1;
                  s >= 0;
                  --s
                ) {
                  var l = n[s];
                  if ("#" === l.text) {
                    if (0 === s)
                      throw new o(
                        "Incomplete placeholder at end of macro body",
                        l,
                      );
                    if ("#" === (l = n[--s]).text) n.splice(s + 1, 1);
                    else {
                      if (!/^[1-9]$/.test(l.text))
                        throw new o("Not a valid argument number", l);
                      var h;
                      (h = n).splice.apply(h, [s, 2].concat(i[+l.text - 1]));
                    }
                  }
                }
              return this.pushTokens(n), n;
            }),
            (e.expandAfterFuture = function () {
              return this.expandOnce(), this.future();
            }),
            (e.expandNextToken = function () {
              for (;;) {
                var t = this.expandOnce();
                if (t instanceof n) {
                  if ("\\relax" !== t.text && !t.treatAsRelax)
                    return this.stack.pop();
                  this.stack.pop();
                }
              }
              throw new Error();
            }),
            (e.expandMacro = function (t) {
              return this.macros.has(t)
                ? this.expandTokens([new n(t)])
                : void 0;
            }),
            (e.expandTokens = function (t) {
              var e = [],
                r = this.stack.length;
              for (this.pushTokens(t); this.stack.length > r; ) {
                var a = this.expandOnce(!0);
                a instanceof n &&
                  (a.treatAsRelax && ((a.noexpand = !1), (a.treatAsRelax = !1)),
                  e.push(this.stack.pop()));
              }
              return e;
            }),
            (e.expandMacroAsText = function (t) {
              var e = this.expandMacro(t);
              return e
                ? e
                    .map(function (t) {
                      return t.text;
                    })
                    .join("")
                : e;
            }),
            (e._getExpansion = function (t) {
              var e = this.macros.get(t);
              if (null == e) return e;
              var r = "function" == typeof e ? e(this) : e;
              if ("string" == typeof r) {
                var a = 0;
                if (-1 !== r.indexOf("#"))
                  for (
                    var n = r.replace(/##/g, "");
                    -1 !== n.indexOf("#" + (a + 1));

                  )
                    ++a;
                for (
                  var i = new ha(r, this.settings), o = [], s = i.lex();
                  "EOF" !== s.text;

                )
                  o.push(s), (s = i.lex());
                return o.reverse(), { tokens: o, numArgs: a };
              }
              return r;
            }),
            (e.isDefined = function (t) {
              return (
                this.macros.has(t) ||
                ia.hasOwnProperty(t) ||
                j.math.hasOwnProperty(t) ||
                j.text.hasOwnProperty(t) ||
                ba.hasOwnProperty(t)
              );
            }),
            (e.isExpandable = function (t) {
              var e = this.macros.get(t);
              return null != e
                ? "string" == typeof e ||
                    "function" == typeof e ||
                    !e.unexpandable
                : ia.hasOwnProperty(t);
            }),
            t
          );
        })(),
        wa = {
          "\u0301": { text: "\\'", math: "\\acute" },
          "\u0300": { text: "\\`", math: "\\grave" },
          "\u0308": { text: '\\"', math: "\\ddot" },
          "\u0303": { text: "\\~", math: "\\tilde" },
          "\u0304": { text: "\\=", math: "\\bar" },
          "\u0306": { text: "\\u", math: "\\breve" },
          "\u030c": { text: "\\v", math: "\\check" },
          "\u0302": { text: "\\^", math: "\\hat" },
          "\u0307": { text: "\\.", math: "\\dot" },
          "\u030a": { text: "\\r", math: "\\mathring" },
          "\u030b": { text: "\\H" },
        },
        ka = {
          "\xe1": "a\u0301",
          "\xe0": "a\u0300",
          "\xe4": "a\u0308",
          "\u01df": "a\u0308\u0304",
          "\xe3": "a\u0303",
          "\u0101": "a\u0304",
          "\u0103": "a\u0306",
          "\u1eaf": "a\u0306\u0301",
          "\u1eb1": "a\u0306\u0300",
          "\u1eb5": "a\u0306\u0303",
          "\u01ce": "a\u030c",
          "\xe2": "a\u0302",
          "\u1ea5": "a\u0302\u0301",
          "\u1ea7": "a\u0302\u0300",
          "\u1eab": "a\u0302\u0303",
          "\u0227": "a\u0307",
          "\u01e1": "a\u0307\u0304",
          "\xe5": "a\u030a",
          "\u01fb": "a\u030a\u0301",
          "\u1e03": "b\u0307",
          "\u0107": "c\u0301",
          "\u010d": "c\u030c",
          "\u0109": "c\u0302",
          "\u010b": "c\u0307",
          "\u010f": "d\u030c",
          "\u1e0b": "d\u0307",
          "\xe9": "e\u0301",
          "\xe8": "e\u0300",
          "\xeb": "e\u0308",
          "\u1ebd": "e\u0303",
          "\u0113": "e\u0304",
          "\u1e17": "e\u0304\u0301",
          "\u1e15": "e\u0304\u0300",
          "\u0115": "e\u0306",
          "\u011b": "e\u030c",
          "\xea": "e\u0302",
          "\u1ebf": "e\u0302\u0301",
          "\u1ec1": "e\u0302\u0300",
          "\u1ec5": "e\u0302\u0303",
          "\u0117": "e\u0307",
          "\u1e1f": "f\u0307",
          "\u01f5": "g\u0301",
          "\u1e21": "g\u0304",
          "\u011f": "g\u0306",
          "\u01e7": "g\u030c",
          "\u011d": "g\u0302",
          "\u0121": "g\u0307",
          "\u1e27": "h\u0308",
          "\u021f": "h\u030c",
          "\u0125": "h\u0302",
          "\u1e23": "h\u0307",
          "\xed": "i\u0301",
          "\xec": "i\u0300",
          "\xef": "i\u0308",
          "\u1e2f": "i\u0308\u0301",
          "\u0129": "i\u0303",
          "\u012b": "i\u0304",
          "\u012d": "i\u0306",
          "\u01d0": "i\u030c",
          "\xee": "i\u0302",
          "\u01f0": "j\u030c",
          "\u0135": "j\u0302",
          "\u1e31": "k\u0301",
          "\u01e9": "k\u030c",
          "\u013a": "l\u0301",
          "\u013e": "l\u030c",
          "\u1e3f": "m\u0301",
          "\u1e41": "m\u0307",
          "\u0144": "n\u0301",
          "\u01f9": "n\u0300",
          "\xf1": "n\u0303",
          "\u0148": "n\u030c",
          "\u1e45": "n\u0307",
          "\xf3": "o\u0301",
          "\xf2": "o\u0300",
          "\xf6": "o\u0308",
          "\u022b": "o\u0308\u0304",
          "\xf5": "o\u0303",
          "\u1e4d": "o\u0303\u0301",
          "\u1e4f": "o\u0303\u0308",
          "\u022d": "o\u0303\u0304",
          "\u014d": "o\u0304",
          "\u1e53": "o\u0304\u0301",
          "\u1e51": "o\u0304\u0300",
          "\u014f": "o\u0306",
          "\u01d2": "o\u030c",
          "\xf4": "o\u0302",
          "\u1ed1": "o\u0302\u0301",
          "\u1ed3": "o\u0302\u0300",
          "\u1ed7": "o\u0302\u0303",
          "\u022f": "o\u0307",
          "\u0231": "o\u0307\u0304",
          "\u0151": "o\u030b",
          "\u1e55": "p\u0301",
          "\u1e57": "p\u0307",
          "\u0155": "r\u0301",
          "\u0159": "r\u030c",
          "\u1e59": "r\u0307",
          "\u015b": "s\u0301",
          "\u1e65": "s\u0301\u0307",
          "\u0161": "s\u030c",
          "\u1e67": "s\u030c\u0307",
          "\u015d": "s\u0302",
          "\u1e61": "s\u0307",
          "\u1e97": "t\u0308",
          "\u0165": "t\u030c",
          "\u1e6b": "t\u0307",
          "\xfa": "u\u0301",
          "\xf9": "u\u0300",
          "\xfc": "u\u0308",
          "\u01d8": "u\u0308\u0301",
          "\u01dc": "u\u0308\u0300",
          "\u01d6": "u\u0308\u0304",
          "\u01da": "u\u0308\u030c",
          "\u0169": "u\u0303",
          "\u1e79": "u\u0303\u0301",
          "\u016b": "u\u0304",
          "\u1e7b": "u\u0304\u0308",
          "\u016d": "u\u0306",
          "\u01d4": "u\u030c",
          "\xfb": "u\u0302",
          "\u016f": "u\u030a",
          "\u0171": "u\u030b",
          "\u1e7d": "v\u0303",
          "\u1e83": "w\u0301",
          "\u1e81": "w\u0300",
          "\u1e85": "w\u0308",
          "\u0175": "w\u0302",
          "\u1e87": "w\u0307",
          "\u1e98": "w\u030a",
          "\u1e8d": "x\u0308",
          "\u1e8b": "x\u0307",
          "\xfd": "y\u0301",
          "\u1ef3": "y\u0300",
          "\xff": "y\u0308",
          "\u1ef9": "y\u0303",
          "\u0233": "y\u0304",
          "\u0177": "y\u0302",
          "\u1e8f": "y\u0307",
          "\u1e99": "y\u030a",
          "\u017a": "z\u0301",
          "\u017e": "z\u030c",
          "\u1e91": "z\u0302",
          "\u017c": "z\u0307",
          "\xc1": "A\u0301",
          "\xc0": "A\u0300",
          "\xc4": "A\u0308",
          "\u01de": "A\u0308\u0304",
          "\xc3": "A\u0303",
          "\u0100": "A\u0304",
          "\u0102": "A\u0306",
          "\u1eae": "A\u0306\u0301",
          "\u1eb0": "A\u0306\u0300",
          "\u1eb4": "A\u0306\u0303",
          "\u01cd": "A\u030c",
          "\xc2": "A\u0302",
          "\u1ea4": "A\u0302\u0301",
          "\u1ea6": "A\u0302\u0300",
          "\u1eaa": "A\u0302\u0303",
          "\u0226": "A\u0307",
          "\u01e0": "A\u0307\u0304",
          "\xc5": "A\u030a",
          "\u01fa": "A\u030a\u0301",
          "\u1e02": "B\u0307",
          "\u0106": "C\u0301",
          "\u010c": "C\u030c",
          "\u0108": "C\u0302",
          "\u010a": "C\u0307",
          "\u010e": "D\u030c",
          "\u1e0a": "D\u0307",
          "\xc9": "E\u0301",
          "\xc8": "E\u0300",
          "\xcb": "E\u0308",
          "\u1ebc": "E\u0303",
          "\u0112": "E\u0304",
          "\u1e16": "E\u0304\u0301",
          "\u1e14": "E\u0304\u0300",
          "\u0114": "E\u0306",
          "\u011a": "E\u030c",
          "\xca": "E\u0302",
          "\u1ebe": "E\u0302\u0301",
          "\u1ec0": "E\u0302\u0300",
          "\u1ec4": "E\u0302\u0303",
          "\u0116": "E\u0307",
          "\u1e1e": "F\u0307",
          "\u01f4": "G\u0301",
          "\u1e20": "G\u0304",
          "\u011e": "G\u0306",
          "\u01e6": "G\u030c",
          "\u011c": "G\u0302",
          "\u0120": "G\u0307",
          "\u1e26": "H\u0308",
          "\u021e": "H\u030c",
          "\u0124": "H\u0302",
          "\u1e22": "H\u0307",
          "\xcd": "I\u0301",
          "\xcc": "I\u0300",
          "\xcf": "I\u0308",
          "\u1e2e": "I\u0308\u0301",
          "\u0128": "I\u0303",
          "\u012a": "I\u0304",
          "\u012c": "I\u0306",
          "\u01cf": "I\u030c",
          "\xce": "I\u0302",
          "\u0130": "I\u0307",
          "\u0134": "J\u0302",
          "\u1e30": "K\u0301",
          "\u01e8": "K\u030c",
          "\u0139": "L\u0301",
          "\u013d": "L\u030c",
          "\u1e3e": "M\u0301",
          "\u1e40": "M\u0307",
          "\u0143": "N\u0301",
          "\u01f8": "N\u0300",
          "\xd1": "N\u0303",
          "\u0147": "N\u030c",
          "\u1e44": "N\u0307",
          "\xd3": "O\u0301",
          "\xd2": "O\u0300",
          "\xd6": "O\u0308",
          "\u022a": "O\u0308\u0304",
          "\xd5": "O\u0303",
          "\u1e4c": "O\u0303\u0301",
          "\u1e4e": "O\u0303\u0308",
          "\u022c": "O\u0303\u0304",
          "\u014c": "O\u0304",
          "\u1e52": "O\u0304\u0301",
          "\u1e50": "O\u0304\u0300",
          "\u014e": "O\u0306",
          "\u01d1": "O\u030c",
          "\xd4": "O\u0302",
          "\u1ed0": "O\u0302\u0301",
          "\u1ed2": "O\u0302\u0300",
          "\u1ed6": "O\u0302\u0303",
          "\u022e": "O\u0307",
          "\u0230": "O\u0307\u0304",
          "\u0150": "O\u030b",
          "\u1e54": "P\u0301",
          "\u1e56": "P\u0307",
          "\u0154": "R\u0301",
          "\u0158": "R\u030c",
          "\u1e58": "R\u0307",
          "\u015a": "S\u0301",
          "\u1e64": "S\u0301\u0307",
          "\u0160": "S\u030c",
          "\u1e66": "S\u030c\u0307",
          "\u015c": "S\u0302",
          "\u1e60": "S\u0307",
          "\u0164": "T\u030c",
          "\u1e6a": "T\u0307",
          "\xda": "U\u0301",
          "\xd9": "U\u0300",
          "\xdc": "U\u0308",
          "\u01d7": "U\u0308\u0301",
          "\u01db": "U\u0308\u0300",
          "\u01d5": "U\u0308\u0304",
          "\u01d9": "U\u0308\u030c",
          "\u0168": "U\u0303",
          "\u1e78": "U\u0303\u0301",
          "\u016a": "U\u0304",
          "\u1e7a": "U\u0304\u0308",
          "\u016c": "U\u0306",
          "\u01d3": "U\u030c",
          "\xdb": "U\u0302",
          "\u016e": "U\u030a",
          "\u0170": "U\u030b",
          "\u1e7c": "V\u0303",
          "\u1e82": "W\u0301",
          "\u1e80": "W\u0300",
          "\u1e84": "W\u0308",
          "\u0174": "W\u0302",
          "\u1e86": "W\u0307",
          "\u1e8c": "X\u0308",
          "\u1e8a": "X\u0307",
          "\xdd": "Y\u0301",
          "\u1ef2": "Y\u0300",
          "\u0178": "Y\u0308",
          "\u1ef8": "Y\u0303",
          "\u0232": "Y\u0304",
          "\u0176": "Y\u0302",
          "\u1e8e": "Y\u0307",
          "\u0179": "Z\u0301",
          "\u017d": "Z\u030c",
          "\u1e90": "Z\u0302",
          "\u017b": "Z\u0307",
          "\u03ac": "\u03b1\u0301",
          "\u1f70": "\u03b1\u0300",
          "\u1fb1": "\u03b1\u0304",
          "\u1fb0": "\u03b1\u0306",
          "\u03ad": "\u03b5\u0301",
          "\u1f72": "\u03b5\u0300",
          "\u03ae": "\u03b7\u0301",
          "\u1f74": "\u03b7\u0300",
          "\u03af": "\u03b9\u0301",
          "\u1f76": "\u03b9\u0300",
          "\u03ca": "\u03b9\u0308",
          "\u0390": "\u03b9\u0308\u0301",
          "\u1fd2": "\u03b9\u0308\u0300",
          "\u1fd1": "\u03b9\u0304",
          "\u1fd0": "\u03b9\u0306",
          "\u03cc": "\u03bf\u0301",
          "\u1f78": "\u03bf\u0300",
          "\u03cd": "\u03c5\u0301",
          "\u1f7a": "\u03c5\u0300",
          "\u03cb": "\u03c5\u0308",
          "\u03b0": "\u03c5\u0308\u0301",
          "\u1fe2": "\u03c5\u0308\u0300",
          "\u1fe1": "\u03c5\u0304",
          "\u1fe0": "\u03c5\u0306",
          "\u03ce": "\u03c9\u0301",
          "\u1f7c": "\u03c9\u0300",
          "\u038e": "\u03a5\u0301",
          "\u1fea": "\u03a5\u0300",
          "\u03ab": "\u03a5\u0308",
          "\u1fe9": "\u03a5\u0304",
          "\u1fe8": "\u03a5\u0306",
          "\u038f": "\u03a9\u0301",
          "\u1ffa": "\u03a9\u0300",
        },
        Sa = (function () {
          function t(t, e) {
            (this.mode = void 0),
              (this.gullet = void 0),
              (this.settings = void 0),
              (this.leftrightDepth = void 0),
              (this.nextToken = void 0),
              (this.mode = "math"),
              (this.gullet = new ya(t, e, this.mode)),
              (this.settings = e),
              (this.leftrightDepth = 0);
          }
          var e = t.prototype;
          return (
            (e.expect = function (t, e) {
              if ((void 0 === e && (e = !0), this.fetch().text !== t))
                throw new o(
                  "Expected '" + t + "', got '" + this.fetch().text + "'",
                  this.fetch(),
                );
              e && this.consume();
            }),
            (e.consume = function () {
              this.nextToken = null;
            }),
            (e.fetch = function () {
              return (
                null == this.nextToken &&
                  (this.nextToken = this.gullet.expandNextToken()),
                this.nextToken
              );
            }),
            (e.switchMode = function (t) {
              (this.mode = t), this.gullet.switchMode(t);
            }),
            (e.parse = function () {
              this.settings.globalGroup || this.gullet.beginGroup(),
                this.settings.colorIsTextColor &&
                  this.gullet.macros.set("\\color", "\\textcolor");
              var t = this.parseExpression(!1);
              return (
                this.expect("EOF"),
                this.settings.globalGroup || this.gullet.endGroup(),
                t
              );
            }),
            (e.parseExpression = function (e, r) {
              for (var a = []; ; ) {
                "math" === this.mode && this.consumeSpaces();
                var n = this.fetch();
                if (-1 !== t.endOfExpression.indexOf(n.text)) break;
                if (r && n.text === r) break;
                if (e && ia[n.text] && ia[n.text].infix) break;
                var i = this.parseAtom(r);
                if (!i) break;
                "internal" !== i.type && a.push(i);
              }
              return (
                "text" === this.mode && this.formLigatures(a),
                this.handleInfixNodes(a)
              );
            }),
            (e.handleInfixNodes = function (t) {
              for (var e, r = -1, a = 0; a < t.length; a++)
                if ("infix" === t[a].type) {
                  if (-1 !== r)
                    throw new o(
                      "only one infix operator per group",
                      t[a].token,
                    );
                  (r = a), (e = t[a].replaceWith);
                }
              if (-1 !== r && e) {
                var n,
                  i,
                  s = t.slice(0, r),
                  l = t.slice(r + 1);
                return (
                  (n =
                    1 === s.length && "ordgroup" === s[0].type
                      ? s[0]
                      : { type: "ordgroup", mode: this.mode, body: s }),
                  (i =
                    1 === l.length && "ordgroup" === l[0].type
                      ? l[0]
                      : { type: "ordgroup", mode: this.mode, body: l }),
                  [
                    "\\\\abovefrac" === e
                      ? this.callFunction(e, [n, t[r], i], [])
                      : this.callFunction(e, [n, i], []),
                  ]
                );
              }
              return t;
            }),
            (e.handleSupSubscript = function (e) {
              var r = this.fetch(),
                a = r.text;
              this.consume();
              var n = this.parseGroup(
                e,
                !1,
                t.SUPSUB_GREEDINESS,
                void 0,
                void 0,
                !0,
              );
              if (!n) throw new o("Expected group after '" + a + "'", r);
              return n;
            }),
            (e.formatUnsupportedCmd = function (t) {
              for (var e = [], r = 0; r < t.length; r++)
                e.push({ type: "textord", mode: "text", text: t[r] });
              var a = { type: "text", mode: this.mode, body: e };
              return {
                type: "color",
                mode: this.mode,
                color: this.settings.errorColor,
                body: [a],
              };
            }),
            (e.parseAtom = function (t) {
              var e,
                r,
                a = this.parseGroup("atom", !1, null, t);
              if ("text" === this.mode) return a;
              for (;;) {
                this.consumeSpaces();
                var n = this.fetch();
                if ("\\limits" === n.text || "\\nolimits" === n.text) {
                  if (a && "op" === a.type) {
                    var i = "\\limits" === n.text;
                    (a.limits = i), (a.alwaysHandleSupSub = !0);
                  } else {
                    if (
                      !a ||
                      "operatorname" !== a.type ||
                      !a.alwaysHandleSupSub
                    )
                      throw new o(
                        "Limit controls must follow a math operator",
                        n,
                      );
                    var s = "\\limits" === n.text;
                    a.limits = s;
                  }
                  this.consume();
                } else if ("^" === n.text) {
                  if (e) throw new o("Double superscript", n);
                  e = this.handleSupSubscript("superscript");
                } else if ("_" === n.text) {
                  if (r) throw new o("Double subscript", n);
                  r = this.handleSupSubscript("subscript");
                } else {
                  if ("'" !== n.text) break;
                  if (e) throw new o("Double superscript", n);
                  var l = { type: "textord", mode: this.mode, text: "\\prime" },
                    h = [l];
                  for (this.consume(); "'" === this.fetch().text; )
                    h.push(l), this.consume();
                  "^" === this.fetch().text &&
                    h.push(this.handleSupSubscript("superscript")),
                    (e = { type: "ordgroup", mode: this.mode, body: h });
                }
              }
              return e || r
                ? { type: "supsub", mode: this.mode, base: a, sup: e, sub: r }
                : a;
            }),
            (e.parseFunction = function (t, e, r) {
              var a = this.fetch(),
                n = a.text,
                i = ia[n];
              if (!i) return null;
              if ((this.consume(), null != r && i.greediness <= r))
                throw new o(
                  "Got function '" +
                    n +
                    "' with no arguments" +
                    (e ? " as " + e : ""),
                  a,
                );
              if ("text" === this.mode && !i.allowedInText)
                throw new o("Can't use function '" + n + "' in text mode", a);
              if ("math" === this.mode && !1 === i.allowedInMath)
                throw new o("Can't use function '" + n + "' in math mode", a);
              var s = this.parseArguments(n, i),
                l = s.args,
                h = s.optArgs;
              return this.callFunction(n, l, h, a, t);
            }),
            (e.callFunction = function (t, e, r, a, n) {
              var i = {
                  funcName: t,
                  parser: this,
                  token: a,
                  breakOnTokenText: n,
                },
                s = ia[t];
              if (s && s.handler) return s.handler(i, e, r);
              throw new o("No function handler for " + t);
            }),
            (e.parseArguments = function (t, e) {
              var r = e.numArgs + e.numOptionalArgs;
              if (0 === r) return { args: [], optArgs: [] };
              for (var a = e.greediness, n = [], i = [], s = 0; s < r; s++) {
                var l = e.argTypes && e.argTypes[s],
                  h = s < e.numOptionalArgs,
                  m = (s > 0 && !h) || (0 === s && !h && "math" === this.mode),
                  c = this.parseGroupOfType(
                    "argument to '" + t + "'",
                    l,
                    h,
                    a,
                    m,
                  );
                if (!c) {
                  if (h) {
                    i.push(null);
                    continue;
                  }
                  throw new o("Expected group after '" + t + "'", this.fetch());
                }
                (h ? i : n).push(c);
              }
              return { args: n, optArgs: i };
            }),
            (e.parseGroupOfType = function (t, e, r, a, n) {
              switch (e) {
                case "color":
                  return n && this.consumeSpaces(), this.parseColorGroup(r);
                case "size":
                  return n && this.consumeSpaces(), this.parseSizeGroup(r);
                case "url":
                  return this.parseUrlGroup(r, n);
                case "math":
                case "text":
                  return this.parseGroup(t, r, a, void 0, e, n);
                case "hbox":
                  var i = this.parseGroup(t, r, a, void 0, "text", n);
                  return i
                    ? {
                        type: "styling",
                        mode: i.mode,
                        body: [i],
                        style: "text",
                      }
                    : i;
                case "raw":
                  if (
                    (n && this.consumeSpaces(), r && "{" === this.fetch().text)
                  )
                    return null;
                  var s = this.parseStringGroup("raw", r, !0);
                  if (s) return { type: "raw", mode: "text", string: s.text };
                  throw new o("Expected raw group", this.fetch());
                case "original":
                case null:
                case void 0:
                  return this.parseGroup(t, r, a, void 0, void 0, n);
                default:
                  throw new o("Unknown group type as " + t, this.fetch());
              }
            }),
            (e.consumeSpaces = function () {
              for (; " " === this.fetch().text; ) this.consume();
            }),
            (e.parseStringGroup = function (t, e, r) {
              var a = e ? "[" : "{",
                n = e ? "]" : "}",
                i = this.fetch();
              if (i.text !== a) {
                if (e) return null;
                if (r && "EOF" !== i.text && /[^{}[\]]/.test(i.text))
                  return this.consume(), i;
              }
              var s = this.mode;
              (this.mode = "text"), this.expect(a);
              for (
                var l, h = "", m = this.fetch(), c = 0, u = m;
                (l = this.fetch()).text !== n || (r && c > 0);

              ) {
                switch (l.text) {
                  case "EOF":
                    throw new o(
                      "Unexpected end of input in " + t,
                      m.range(u, h),
                    );
                  case a:
                    c++;
                    break;
                  case n:
                    c--;
                }
                (h += (u = l).text), this.consume();
              }
              return this.expect(n), (this.mode = s), m.range(u, h);
            }),
            (e.parseRegexGroup = function (t, e) {
              var r = this.mode;
              this.mode = "text";
              for (
                var a, n = this.fetch(), i = n, s = "";
                "EOF" !== (a = this.fetch()).text && t.test(s + a.text);

              )
                (s += (i = a).text), this.consume();
              if ("" === s)
                throw new o("Invalid " + e + ": '" + n.text + "'", n);
              return (this.mode = r), n.range(i, s);
            }),
            (e.parseColorGroup = function (t) {
              var e = this.parseStringGroup("color", t);
              if (!e) return null;
              var r = /^(#[a-f0-9]{3}|#?[a-f0-9]{6}|[a-z]+)$/i.exec(e.text);
              if (!r) throw new o("Invalid color: '" + e.text + "'", e);
              var a = r[0];
              return (
                /^[0-9a-f]{6}$/i.test(a) && (a = "#" + a),
                { type: "color-token", mode: this.mode, color: a }
              );
            }),
            (e.parseSizeGroup = function (t) {
              var e,
                r = !1;
              if (
                !(e =
                  t || "{" === this.fetch().text
                    ? this.parseStringGroup("size", t)
                    : this.parseRegexGroup(
                        /^[-+]? *(?:$|\d+|\d+\.\d*|\.\d*) *[a-z]{0,2} *$/,
                        "size",
                      ))
              )
                return null;
              t || 0 !== e.text.length || ((e.text = "0pt"), (r = !0));
              var a = /([-+]?) *(\d+(?:\.\d*)?|\.\d+) *([a-z]{2})/.exec(e.text);
              if (!a) throw new o("Invalid size: '" + e.text + "'", e);
              var n = { number: +(a[1] + a[2]), unit: a[3] };
              if (!At(n)) throw new o("Invalid unit: '" + n.unit + "'", e);
              return { type: "size", mode: this.mode, value: n, isBlank: r };
            }),
            (e.parseUrlGroup = function (t, e) {
              this.gullet.lexer.setCatcode("%", 13);
              var r = this.parseStringGroup("url", t, !0);
              if ((this.gullet.lexer.setCatcode("%", 14), !r)) return null;
              var a = r.text.replace(/\\([#$%&~_^{}])/g, "$1");
              return { type: "url", mode: this.mode, url: a };
            }),
            (e.parseGroup = function (e, r, n, i, s, l) {
              var h = this.mode;
              s && this.switchMode(s), l && this.consumeSpaces();
              var m,
                c = this.fetch(),
                u = c.text;
              if (r ? "[" === u : "{" === u || "\\begingroup" === u) {
                this.consume();
                var p = t.endOfGroup[u];
                this.gullet.beginGroup();
                var d = this.parseExpression(!1, p),
                  f = this.fetch();
                this.expect(p),
                  this.gullet.endGroup(),
                  (m = {
                    type: "ordgroup",
                    mode: this.mode,
                    loc: a.range(c, f),
                    body: d,
                    semisimple: "\\begingroup" === u || void 0,
                  });
              } else if (r) m = null;
              else if (
                null ==
                  (m = this.parseFunction(i, e, n) || this.parseSymbol()) &&
                "\\" === u[0] &&
                !ba.hasOwnProperty(u)
              ) {
                if (this.settings.throwOnError)
                  throw new o("Undefined control sequence: " + u, c);
                (m = this.formatUnsupportedCmd(u)), this.consume();
              }
              return s && this.switchMode(h), m;
            }),
            (e.formLigatures = function (t) {
              for (var e = t.length - 1, r = 0; r < e; ++r) {
                var n = t[r],
                  i = n.text;
                "-" === i &&
                  "-" === t[r + 1].text &&
                  (r + 1 < e && "-" === t[r + 2].text
                    ? (t.splice(r, 3, {
                        type: "textord",
                        mode: "text",
                        loc: a.range(n, t[r + 2]),
                        text: "---",
                      }),
                      (e -= 2))
                    : (t.splice(r, 2, {
                        type: "textord",
                        mode: "text",
                        loc: a.range(n, t[r + 1]),
                        text: "--",
                      }),
                      (e -= 1))),
                  ("'" !== i && "`" !== i) ||
                    t[r + 1].text !== i ||
                    (t.splice(r, 2, {
                      type: "textord",
                      mode: "text",
                      loc: a.range(n, t[r + 1]),
                      text: i + i,
                    }),
                    (e -= 1));
              }
            }),
            (e.parseSymbol = function () {
              var t = this.fetch(),
                e = t.text;
              if (/^\\verb[^a-zA-Z]/.test(e)) {
                this.consume();
                var r = e.slice(5),
                  n = "*" === r.charAt(0);
                if (
                  (n && (r = r.slice(1)),
                  r.length < 2 || r.charAt(0) !== r.slice(-1))
                )
                  throw new o(
                    "\\verb assertion failed --\n                    please report what input caused this bug",
                  );
                return {
                  type: "verb",
                  mode: "text",
                  body: (r = r.slice(1, -1)),
                  star: n,
                };
              }
              ka.hasOwnProperty(e[0]) &&
                !j[this.mode][e[0]] &&
                (this.settings.strict &&
                  "math" === this.mode &&
                  this.settings.reportNonstrict(
                    "unicodeTextInMathMode",
                    'Accented Unicode text character "' +
                      e[0] +
                      '" used in math mode',
                    t,
                  ),
                (e = ka[e[0]] + e.substr(1)));
              var i,
                s = sa.exec(e);
              if (
                (s &&
                  ("i" === (e = e.substring(0, s.index))
                    ? (e = "\u0131")
                    : "j" === e && (e = "\u0237")),
                j[this.mode][e])
              ) {
                this.settings.strict &&
                  "math" === this.mode &&
                  "\xc7\xd0\xde\xe7\xfe".indexOf(e) >= 0 &&
                  this.settings.reportNonstrict(
                    "unicodeTextInMathMode",
                    'Latin-1/Unicode text character "' +
                      e[0] +
                      '" used in math mode',
                    t,
                  );
                var l,
                  h = j[this.mode][e].group,
                  m = a.range(t);
                if (W.hasOwnProperty(h)) {
                  var c = h;
                  l = {
                    type: "atom",
                    mode: this.mode,
                    family: c,
                    loc: m,
                    text: e,
                  };
                } else l = { type: h, mode: this.mode, loc: m, text: e };
                i = l;
              } else {
                if (!(e.charCodeAt(0) >= 128)) return null;
                this.settings.strict &&
                  (M(e.charCodeAt(0))
                    ? "math" === this.mode &&
                      this.settings.reportNonstrict(
                        "unicodeTextInMathMode",
                        'Unicode text character "' +
                          e[0] +
                          '" used in math mode',
                        t,
                      )
                    : this.settings.reportNonstrict(
                        "unknownSymbol",
                        'Unrecognized Unicode character "' +
                          e[0] +
                          '" (' +
                          e.charCodeAt(0) +
                          ")",
                        t,
                      )),
                  (i = {
                    type: "textord",
                    mode: "text",
                    loc: a.range(t),
                    text: e,
                  });
              }
              if ((this.consume(), s))
                for (var u = 0; u < s[0].length; u++) {
                  var p = s[0][u];
                  if (!wa[p]) throw new o("Unknown accent ' " + p + "'", t);
                  var d = wa[p][this.mode];
                  if (!d)
                    throw new o(
                      "Accent " + p + " unsupported in " + this.mode + " mode",
                      t,
                    );
                  i = {
                    type: "accent",
                    mode: this.mode,
                    loc: a.range(t),
                    label: d,
                    isStretchy: !1,
                    isShifty: !0,
                    base: i,
                  };
                }
              return i;
            }),
            t
          );
        })();
      (Sa.endOfExpression = ["}", "\\endgroup", "\\end", "\\right", "&"]),
        (Sa.endOfGroup = { "[": "]", "{": "}", "\\begingroup": "\\endgroup" }),
        (Sa.SUPSUB_GREEDINESS = 1);
      var Ma = function (t, e) {
          if (!("string" == typeof t || t instanceof String))
            throw new TypeError("KaTeX can only parse string typed expression");
          var r = new Sa(t, e);
          delete r.gullet.macros.current["\\df@tag"];
          var a = r.parse();
          if (r.gullet.macros.get("\\df@tag")) {
            if (!e.displayMode)
              throw new o("\\tag works only in display equations");
            r.gullet.feed("\\df@tag"),
              (a = [{ type: "tag", mode: "text", body: a, tag: r.parse() }]);
          }
          return a;
        },
        za = function (t, e, r) {
          e.textContent = "";
          var a = Ta(t, r).toNode();
          e.appendChild(a);
        };
      "undefined" != typeof document &&
        "CSS1Compat" !== document.compatMode &&
        ("undefined" != typeof console &&
          console.warn(
            "Warning: KaTeX doesn't work in quirks mode. Make sure your website has a suitable doctype.",
          ),
        (za = function () {
          throw new o("KaTeX doesn't work in quirks mode.");
        }));
      var Aa = function (t, e, r) {
          if (r.throwOnError || !(t instanceof o)) throw t;
          var a = Dt.makeSpan(["katex-error"], [new E(e)]);
          return (
            a.setAttribute("title", t.toString()),
            a.setAttribute("style", "color:" + r.errorColor),
            a
          );
        },
        Ta = function (t, e) {
          var r = new u(e);
          try {
            var a = Ma(t, r);
            return ke(a, t, r);
          } catch (e) {
            return Aa(e, t, r);
          }
        },
        Ba = {
          version: "0.12.0",
          render: za,
          renderToString: function (t, e) {
            return Ta(t, e).toMarkup();
          },
          ParseError: o,
          __parse: function (t, e) {
            var r = new u(e);
            return Ma(t, r);
          },
          __renderToDomTree: Ta,
          __renderToHTMLTree: function (t, e) {
            var r = new u(e);
            try {
              return (function (t, e, r) {
                var a = le(t, ye(r)),
                  n = Dt.makeSpan(["katex"], [a]);
                return we(n, r);
              })(Ma(t, r), 0, r);
            } catch (e) {
              return Aa(e, t, r);
            }
          },
          __setFontMetrics: function (t, e) {
            F[t] = e;
          },
          __defineSymbol: $,
          __defineMacro: pa,
          __domTree: {
            Span: N,
            Anchor: I,
            SymbolNode: E,
            SvgNode: L,
            PathNode: P,
            LineNode: D,
          },
        };
      e.default = Ba;
    },
  ]).default;
});
