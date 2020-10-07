! function(e) {
    var t = {};

    function n(r) {
        if (t[r]) return t[r].exports;
        var o = t[r] = {
            i: r,
            l: !1,
            exports: {}
        };
        return e[r].call(o.exports, o, o.exports, n), o.l = !0, o.exports
    }
    n.m = e, n.c = t, n.d = function(e, t, r) {
        n.o(e, t) || Object.defineProperty(e, t, {
            enumerable: !0,
            get: r
        })
    }, n.r = function(e) {
        "undefined" != typeof Symbol && Symbol.toStringTag && Object.defineProperty(e, Symbol.toStringTag, {
            value: "Module"
        }), Object.defineProperty(e, "__esModule", {
            value: !0
        })
    }, n.t = function(e, t) {
        if (1 & t && (e = n(e)), 8 & t) return e;
        if (4 & t && "object" == typeof e && e && e.__esModule) return e;
        var r = Object.create(null);
        if (n.r(r), Object.defineProperty(r, "default", {
                enumerable: !0,
                value: e
            }), 2 & t && "string" != typeof e)
            for (var o in e) n.d(r, o, function(t) {
                return e[t]
            }.bind(null, o));
        return r
    }, n.n = function(e) {
        var t = e && e.__esModule ? function() {
            return e.default
        } : function() {
            return e
        };
        return n.d(t, "a", t), t
    }, n.o = function(e, t) {
        return Object.prototype.hasOwnProperty.call(e, t)
    }, n.p = "/", n(n.s = 4)
}([function(e, t, n) {
    "use strict";
    Object.defineProperty(t, "__esModule", {
        value: !0
    });
    var r = t.TOGGLE_MENU = "TOGGLE_MENU",
        o = (t.toggleMenu = function() {
            var e = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : -1;
            return {
                type: r,
                toggle: e
            }
        }, t.SCROLL_DOCUMENT = "SCROLL_DOCUMENT"),
        i = (t.scrollDocument = function() {
            var e = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : 0;
            return {
                type: o,
                scrollTop: e
            }
        }, t.TOGGLE_BIG_SCREEN = "TOGGLE_BIG_SCREEN");
    t.toggleBigScreen = function() {
        var e = arguments.length > 0 && void 0 !== arguments[0] && arguments[0];
        return {
            type: i,
            bigScreen: e
        }
    }
}, function(e, t, n) {
    "use strict";
    (function(e, r) {
        var o, i = n(3);
        o = "undefined" != typeof self ? self : "undefined" != typeof window ? window : void 0 !== e ? e : r;
        var a = Object(i.a)(o);
        t.a = a
    }).call(this, n(11), n(12)(e))
}, function(e, t, n) {
    "use strict";
    n.r(t), n.d(t, "createStore", function() {
        return c
    }), n.d(t, "combineReducers", function() {
        return s
    }), n.d(t, "bindActionCreators", function() {
        return l
    }), n.d(t, "applyMiddleware", function() {
        return h
    }), n.d(t, "compose", function() {
        return p
    }), n.d(t, "__DO_NOT_USE__ActionTypes", function() {
        return i
    });
    var r = n(1),
        o = function() {
            return Math.random().toString(36).substring(7).split("").join(".")
        },
        i = {
            INIT: "@@redux/INIT" + o(),
            REPLACE: "@@redux/REPLACE" + o(),
            PROBE_UNKNOWN_ACTION: function() {
                return "@@redux/PROBE_UNKNOWN_ACTION" + o()
            }
        };

    function a(e) {
        if ("object" != typeof e || null === e) return !1;
        for (var t = e; null !== Object.getPrototypeOf(t);) t = Object.getPrototypeOf(t);
        return Object.getPrototypeOf(e) === t
    }

    function c(e, t, n) {
        var o;
        if ("function" == typeof t && "function" == typeof n || "function" == typeof n && "function" == typeof arguments[3]) throw new Error("It looks like you are passing several store enhancers to createStore(). This is not supported. Instead, compose them together to a single function");
        if ("function" == typeof t && void 0 === n && (n = t, t = void 0), void 0 !== n) {
            if ("function" != typeof n) throw new Error("Expected the enhancer to be a function.");
            return n(c)(e, t)
        }
        if ("function" != typeof e) throw new Error("Expected the reducer to be a function.");
        var u = e,
            s = t,
            f = [],
            l = f,
            d = !1;

        function p() {
            l === f && (l = f.slice())
        }

        function h() {
            if (d) throw new Error("You may not call store.getState() while the reducer is executing. The reducer has already received the state as an argument. Pass it down from the top reducer instead of reading it from the store.");
            return s
        }

        function y(e) {
            if ("function" != typeof e) throw new Error("Expected the listener to be a function.");
            if (d) throw new Error("You may not call store.subscribe() while the reducer is executing. If you would like to be notified after the store has been updated, subscribe from a component and invoke store.getState() in the callback to access the latest state. See https://redux.js.org/api-reference/store#subscribe(listener) for more details.");
            var t = !0;
            return p(), l.push(e),
                function() {
                    if (t) {
                        if (d) throw new Error("You may not unsubscribe from a store listener while the reducer is executing. See https://redux.js.org/api-reference/store#subscribe(listener) for more details.");
                        t = !1, p();
                        var n = l.indexOf(e);
                        l.splice(n, 1)
                    }
                }
        }

        function v(e) {
            if (!a(e)) throw new Error("Actions must be plain objects. Use custom middleware for async actions.");
            if (void 0 === e.type) throw new Error('Actions may not have an undefined "type" property. Have you misspelled a constant?');
            if (d) throw new Error("Reducers may not dispatch actions.");
            try {
                d = !0, s = u(s, e)
            } finally {
                d = !1
            }
            for (var t = f = l, n = 0; n < t.length; n++) {
                (0, t[n])()
            }
            return e
        }
        return v({
            type: i.INIT
        }), (o = {
            dispatch: v,
            subscribe: y,
            getState: h,
            replaceReducer: function(e) {
                if ("function" != typeof e) throw new Error("Expected the nextReducer to be a function.");
                u = e, v({
                    type: i.REPLACE
                })
            }
        })[r.a] = function() {
            var e, t = y;
            return (e = {
                subscribe: function(e) {
                    if ("object" != typeof e || null === e) throw new TypeError("Expected the observer to be an object.");

                    function n() {
                        e.next && e.next(h())
                    }
                    return n(), {
                        unsubscribe: t(n)
                    }
                }
            })[r.a] = function() {
                return this
            }, e
        }, o
    }

    function u(e, t) {
        var n = t && t.type;
        return "Given " + (n && 'action "' + String(n) + '"' || "an action") + ', reducer "' + e + '" returned undefined. To ignore an action, you must explicitly return the previous state. If you want this reducer to hold no value, you can return null instead of undefined.'
    }

    function s(e) {
        for (var t = Object.keys(e), n = {}, r = 0; r < t.length; r++) {
            var o = t[r];
            0, "function" == typeof e[o] && (n[o] = e[o])
        }
        var a, c = Object.keys(n);
        try {
            ! function(e) {
                Object.keys(e).forEach(function(t) {
                    var n = e[t];
                    if (void 0 === n(void 0, {
                            type: i.INIT
                        })) throw new Error('Reducer "' + t + "\" returned undefined during initialization. If the state passed to the reducer is undefined, you must explicitly return the initial state. The initial state may not be undefined. If you don't want to set a value for this reducer, you can use null instead of undefined.");
                    if (void 0 === n(void 0, {
                            type: i.PROBE_UNKNOWN_ACTION()
                        })) throw new Error('Reducer "' + t + "\" returned undefined when probed with a random type. Don't try to handle " + i.INIT + ' or other actions in "redux/*" namespace. They are considered private. Instead, you must return the current state for any unknown actions, unless it is undefined, in which case you must return the initial state, regardless of the action type. The initial state may not be undefined, but can be null.')
                })
            }(n)
        } catch (e) {
            a = e
        }
        return function(e, t) {
            if (void 0 === e && (e = {}), a) throw a;
            for (var r = !1, o = {}, i = 0; i < c.length; i++) {
                var s = c[i],
                    f = n[s],
                    l = e[s],
                    d = f(l, t);
                if (void 0 === d) {
                    var p = u(s, t);
                    throw new Error(p)
                }
                o[s] = d, r = r || d !== l
            }
            return r ? o : e
        }
    }

    function f(e, t) {
        return function() {
            return t(e.apply(this, arguments))
        }
    }

    function l(e, t) {
        if ("function" == typeof e) return f(e, t);
        if ("object" != typeof e || null === e) throw new Error("bindActionCreators expected an object or a function, instead received " + (null === e ? "null" : typeof e) + '. Did you write "import ActionCreators from" instead of "import * as ActionCreators from"?');
        for (var n = Object.keys(e), r = {}, o = 0; o < n.length; o++) {
            var i = n[o],
                a = e[i];
            "function" == typeof a && (r[i] = f(a, t))
        }
        return r
    }

    function d(e, t, n) {
        return t in e ? Object.defineProperty(e, t, {
            value: n,
            enumerable: !0,
            configurable: !0,
            writable: !0
        }) : e[t] = n, e
    }

    function p() {
        for (var e = arguments.length, t = new Array(e), n = 0; n < e; n++) t[n] = arguments[n];
        return 0 === t.length ? function(e) {
            return e
        } : 1 === t.length ? t[0] : t.reduce(function(e, t) {
            return function() {
                return e(t.apply(void 0, arguments))
            }
        })
    }

    function h() {
        for (var e = arguments.length, t = new Array(e), n = 0; n < e; n++) t[n] = arguments[n];
        return function(e) {
            return function() {
                var n = e.apply(void 0, arguments),
                    r = function() {
                        throw new Error("Dispatching while constructing your middleware is not allowed. Other middleware would not be applied to this dispatch.")
                    },
                    o = {
                        getState: n.getState,
                        dispatch: function() {
                            return r.apply(void 0, arguments)
                        }
                    },
                    i = t.map(function(e) {
                        return e(o)
                    });
                return function(e) {
                    for (var t = 1; t < arguments.length; t++) {
                        var n = null != arguments[t] ? arguments[t] : {},
                            r = Object.keys(n);
                        "function" == typeof Object.getOwnPropertySymbols && (r = r.concat(Object.getOwnPropertySymbols(n).filter(function(e) {
                            return Object.getOwnPropertyDescriptor(n, e).enumerable
                        }))), r.forEach(function(t) {
                            d(e, t, n[t])
                        })
                    }
                    return e
                }({}, n, {
                    dispatch: r = p.apply(void 0, i)(n.dispatch)
                })
            }
        }
    }
}, function(e, t, n) {
    "use strict";

    function r(e) {
        var t, n = e.Symbol;
        return "function" == typeof n ? n.observable ? t = n.observable : (t = n("observable"), n.observable = t) : t = "@@observable", t
    }
    n.d(t, "a", function() {
        return r
    })
}, function(e, t, n) {
    "use strict";
    n(15), n(5);
    var r = n(0),
        o = c(n(10)),
        i = n(2),
        a = c(n(13));

    function c(e) {
        return e && e.__esModule ? e : {
            default: e
        }
    }
    var u = (0, i.createStore)(o.default);
    window.__STORE__ = u, window.__scrollWatcher__.addWatch({
        matchCondition: function(e) {
            return e > 0
        },
        onmatchchange: function(e) {
            u.dispatch((0, r.scrollDocument)(e))
        }
    });
    var s = document.getElementById("header");
    if (s && new a.default({
            stickyContainer: s.querySelector(".sticky__container"),
            veil: s.querySelector(".header__nav-veil"),
            toggleButton: s.querySelector(".header__nav-toggler"),
            navBar: s.querySelector(".header__nav-bar"),
            loginButton: s.querySelector(".header__login")
        }), document.body.classList.contains("page-home")) {
        var f = function(e) {
                if (!g) {
                    g = !0;
                    var t = b;
                    b = e, m.forEach(function(e, n) {
                        n === t ? (e.classList.add("old"), y[n] && (y[n].classList.add("old"), setTimeout(function() {
                            y[n].classList.remove("old")
                        }, 1e3))) : e.classList.remove("old"), n === b ? (setTimeout(function() {
                            v.style.left = -100 * b + "%", e.classList.add("active")
                        }, 350), y[n] && y[n].classList.add("active")) : (e.classList.remove("active"), y[n] && y[n].classList.remove("active"))
                    }), setTimeout(function() {
                        g = !1
                    }, 1e3)
                }
            },
            l = document.querySelector(".home-intro"),
            d = Array.prototype.slice.apply(l.querySelectorAll(".home-intro__slider-image")),
            p = 0;
        setInterval(function() {
            var e = p;
            p = (p + 1) % d.length, d.forEach(function(t, n) {
                n === e && (t.classList.add("old"), setTimeout(function() {
                    t.classList.remove("old")
                }, 2e3)), n === p ? t.classList.add("active") : t.classList.remove("active")
            })
        }, 5e3);
        var h = document.querySelector(".home-use-cases"),
            y = Array.prototype.slice.apply(h.querySelectorAll(".home-use-cases__image")),
            v = h.querySelector(".home-use-cases__text-list"),
            m = Array.prototype.slice.apply(h.querySelectorAll(".home-use-cases__text")),
            b = 0,
            g = !1;
        h.querySelector(".home-use-cases__arrow-right").addEventListener("click", function() {
            f((b + 1) % m.length)
        }), h.querySelector(".home-use-cases__arrow-left").addEventListener("click", function() {
            f((b + m.length - 1) % m.length)
        })
    }
}, function(e, t, n) {
    "use strict";
    var r, o = n(6),
        i = (r = o) && r.__esModule ? r : {
            default: r
        };
    if ("undefined" != typeof window) {
        var a = window;
        a.__scrollWatcher__ = a.__scrollWatcher__ || new i.default(function() {
            return a.pageYOffset
        }), a.__dimensionWatcher__ = a.__dimensionWatcher__ || new i.default(function() {
            return a.innerWidth
        })
    }
}, function(e, t, n) {
    "use strict";
    var r = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(e) {
        return typeof e
    } : function(e) {
        return e && "function" == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype ? "symbol" : typeof e
    };
    Object.defineProperty(t, "__esModule", {
        value: !0
    });
    var o = "function" == typeof Symbol && "symbol" === r(Symbol.iterator) ? function(e) {
        return void 0 === e ? "undefined" : r(e)
    } : function(e) {
        return e && "function" == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype ? "symbol" : void 0 === e ? "undefined" : r(e)
    };
    t.default = function(e) {
        var t = this;
        this.watches = {}, this.namespaces = {}, this.paused = !1;
        var n = void 0,
            r = void 0,
            i = function() {
                var n = e();
                if (! function(e, t) {
                        var n = void 0 === e ? "undefined" : o(e);
                        e instanceof Array && (n = "array");
                        switch (n) {
                            case "string":
                            case "number":
                                return e === t;
                            case "array":
                                if (!(t instanceof Array) || e.length != t.length) return !1;
                                for (var r = 0, i = e.length; r < i; r++)
                                    if (e[r] !== t[r]) return !1;
                                return !0;
                            default:
                                return !1
                        }
                    }(r, n)) {
                    for (var i in t.watches) {
                        var a = t.watches[i];
                        if (a.onchange && a.onchange(n), a.isMatch) {
                            var c = a.isMatch(n);
                            c ? (a.onmatch && a.onmatch(n), c != a.matchState && (a.onappear && a.onappear(n), a.onmatchchange && a.onmatchchange(c, n))) : (a.ondismatch && a.ondismatch(n), c != a.matchState && (a.ondisappear && a.ondisappear(n), a.onmatchchange && a.onmatchchange(c, n))), a.matchState = c
                        }
                    }
                    r = n
                }
            },
            a = ["onchange", "onappear", "ondisappear", "onmatch", "ondismatch", "onmatchchange"];
        this.addWatch = function() {
            for (var e = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}, n = {}, o = (0, c.default)(), u = !1, s = "function" == typeof e.matchCondition, f = 0, l = a.length; f < l; f++)
                if ("function" == typeof e[a[f]]) {
                    if ("onchange" !== a[f]) {
                        if (!s) continue;
                        u = !0
                    }
                    n[a[f]] = e[a[f]]
                }
            return u && (n.isMatch = e.matchCondition, n.matchState = void 0), n.id = o, e.namespace && (n.namespace = e.namespace, t.namespaces.hasOwnProperty(e.namespace) || (t.namespaces[e.namespace] = []), t.namespaces[e.namespace].push(o)), t.watches[o] = n, r = void 0, t.paused || i(), o
        }, this.removeWatch = function(e) {
            t.watches.hasOwnProperty(e) && delete t.watches[e]
        }, this.removeNamespace = function(e) {
            if (t.namespaces.hasOwnProperty(e)) {
                for (var n = 0, r = t.namespaces[e].length; n < r; n++) t.removeWatch(t.namespaces[e][n]);
                delete t.namespaces[e]
            }
        }, this.play = function() {
            r = void 0, t.paused = !1, i()
        }, this.pause = function() {
            t.paused = !0
        }, this.playPause = function() {
            t.paused ? t.play() : t.pause()
        };
        this.kill = function() {
                n && cancelAnimationFrame(n)
            },
            function() {
                if ("function" != typeof e) return !1;
                ! function e() {
                    n = requestAnimationFrame(e), t.paused || i()
                }()
            }()
    };
    var i, a = n(7),
        c = (i = a) && i.__esModule ? i : {
            default: i
        }
}, function(e, t, n) {
    var r, o, i = n(8),
        a = n(9),
        c = 0,
        u = 0;
    e.exports = function(e, t, n) {
        var s = t && n || 0,
            f = t || [],
            l = (e = e || {}).node || r,
            d = void 0 !== e.clockseq ? e.clockseq : o;
        if (null == l || null == d) {
            var p = i();
            null == l && (l = r = [1 | p[0], p[1], p[2], p[3], p[4], p[5]]), null == d && (d = o = 16383 & (p[6] << 8 | p[7]))
        }
        var h = void 0 !== e.msecs ? e.msecs : (new Date).getTime(),
            y = void 0 !== e.nsecs ? e.nsecs : u + 1,
            v = h - c + (y - u) / 1e4;
        if (v < 0 && void 0 === e.clockseq && (d = d + 1 & 16383), (v < 0 || h > c) && void 0 === e.nsecs && (y = 0), y >= 1e4) throw new Error("uuid.v1(): Can't create more than 10M uuids/sec");
        c = h, u = y, o = d;
        var m = (1e4 * (268435455 & (h += 122192928e5)) + y) % 4294967296;
        f[s++] = m >>> 24 & 255, f[s++] = m >>> 16 & 255, f[s++] = m >>> 8 & 255, f[s++] = 255 & m;
        var b = h / 4294967296 * 1e4 & 268435455;
        f[s++] = b >>> 8 & 255, f[s++] = 255 & b, f[s++] = b >>> 24 & 15 | 16, f[s++] = b >>> 16 & 255, f[s++] = d >>> 8 | 128, f[s++] = 255 & d;
        for (var g = 0; g < 6; ++g) f[s + g] = l[g];
        return t || a(f)
    }
}, function(e, t) {
    var n = "undefined" != typeof crypto && crypto.getRandomValues && crypto.getRandomValues.bind(crypto) || "undefined" != typeof msCrypto && "function" == typeof window.msCrypto.getRandomValues && msCrypto.getRandomValues.bind(msCrypto);
    if (n) {
        var r = new Uint8Array(16);
        e.exports = function() {
            return n(r), r
        }
    } else {
        var o = new Array(16);
        e.exports = function() {
            for (var e, t = 0; t < 16; t++) 0 == (3 & t) && (e = 4294967296 * Math.random()), o[t] = e >>> ((3 & t) << 3) & 255;
            return o
        }
    }
}, function(e, t) {
    for (var n = [], r = 0; r < 256; ++r) n[r] = (r + 256).toString(16).substr(1);
    e.exports = function(e, t) {
        var r = t || 0,
            o = n;
        return [o[e[r++]], o[e[r++]], o[e[r++]], o[e[r++]], "-", o[e[r++]], o[e[r++]], "-", o[e[r++]], o[e[r++]], "-", o[e[r++]], o[e[r++]], "-", o[e[r++]], o[e[r++]], o[e[r++]], o[e[r++]], o[e[r++]], o[e[r++]]].join("")
    }
}, function(e, t, n) {
    "use strict";
    Object.defineProperty(t, "__esModule", {
        value: !0
    });
    var r = Object.assign || function(e) {
            for (var t = 1; t < arguments.length; t++) {
                var n = arguments[t];
                for (var r in n) Object.prototype.hasOwnProperty.call(n, r) && (e[r] = n[r])
            }
            return e
        },
        o = function(e) {
            if (e && e.__esModule) return e;
            var t = {};
            if (null != e)
                for (var n in e) Object.prototype.hasOwnProperty.call(e, n) && (t[n] = e[n]);
            return t.default = e, t
        }(n(0));
    var i = (0, n(2).combineReducers)({
        menu: function() {
            var e = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {
                    open: !1
                },
                t = arguments[1];
            switch (t.type) {
                case o.TOGGLE_MENU:
                    var n = e.open,
                        i = t.toggle;
                    return r({}, e, {
                        open: n = -1 === i ? !n : i
                    });
                default:
                    return e
            }
        },
        document: function() {
            var e = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {
                    scrolled: !1,
                    bigScreen: !1
                },
                t = arguments[1];
            switch (t.type) {
                case o.SCROLL_DOCUMENT:
                    var n = t.scrollTop;
                    return r({}, e, {
                        scrolled: !!n
                    });
                case o.TOGGLE_BIG_SCREEN:
                    var i = t.bigScreen;
                    return r({}, e, {
                        bigScreen: i
                    });
                default:
                    return e
            }
        }
    });
    t.default = i
}, function(e, t) {
    var n;
    n = function() {
        return this
    }();
    try {
        n = n || new Function("return this")()
    } catch (e) {
        "object" == typeof window && (n = window)
    }
    e.exports = n
}, function(e, t) {
    e.exports = function(e) {
        if (!e.webpackPolyfill) {
            var t = Object.create(e);
            t.children || (t.children = []), Object.defineProperty(t, "loaded", {
                enumerable: !0,
                get: function() {
                    return t.l
                }
            }), Object.defineProperty(t, "id", {
                enumerable: !0,
                get: function() {
                    return t.i
                }
            }), Object.defineProperty(t, "exports", {
                enumerable: !0
            }), t.webpackPolyfill = 1
        }
        return t
    }
}, function(e, t, n) {
    "use strict";
    Object.defineProperty(t, "__esModule", {
        value: !0
    });
    var r, o = Object.assign || function(e) {
            for (var t = 1; t < arguments.length; t++) {
                var n = arguments[t];
                for (var r in n) Object.prototype.hasOwnProperty.call(n, r) && (e[r] = n[r])
            }
            return e
        },
        i = function() {
            function e(e, t) {
                for (var n = 0; n < t.length; n++) {
                    var r = t[n];
                    r.enumerable = r.enumerable || !1, r.configurable = !0, "value" in r && (r.writable = !0), Object.defineProperty(e, r.key, r)
                }
            }
            return function(t, n, r) {
                return n && e(t.prototype, n), r && e(t, r), t
            }
        }(),
        a = n(14),
        c = (r = a) && r.__esModule ? r : {
            default: r
        },
        u = n(0);
    var s = function() {
        function e(t) {
            ! function(e, t) {
                if (!(e instanceof t)) throw new TypeError("Cannot call a class as a function")
            }(this, e);
            var n = this;

            function r() {
                return n.props.stickyContainer.getBoundingClientRect().top + window.pageYOffset
            }
            this.props = o({}, t), this.store = window.__STORE__, this.toggleMenu = this.toggleMenu.bind(this), this.closeMenu = this.closeMenu.bind(this), this.render = this.render.bind(this);
            var i = r();
            t.toggleButton.addEventListener("click", this.toggleMenu), this.store.subscribe(this.render), window.__dimensionWatcher__.addWatch({
                matchCondition: function(e) {
                    return e > 991
                },
                onappear: function() {
                    n.store.dispatch((0, u.toggleBigScreen)(!0))
                },
                ondisappear: function() {
                    n.store.dispatch((0, u.toggleBigScreen)(!1))
                }
            }), window.__dimensionWatcher__.addWatch({
                onchange: function() {
                    i = r()
                }
            }), new c.default({
                container: n.props.stickyContainer,
                preserveHeight: !0,
                condition: function(e) {
                    return e > i && n.store.getState().document.bigScreen
                }
            })
        }
        return i(e, [{
            key: "toggleMenu",
            value: function(e) {
                e && e.preventDefault && e.preventDefault();
                var t = void 0;
                !0 !== e && !1 !== e || (t = e), this.store.dispatch((0, u.toggleMenu)(t))
            }
        }, {
            key: "closeMenu",
            value: function() {
                this.toggleMenu(!1)
            }
        }, {
            key: "render",
            value: function() {
                var e = this.props,
                    t = e.veil,
                    n = e.toggleButton,
                    r = e.navBar,
                    o = e.loginButton,
                    i = this.store.getState(),
                    a = i.menu.open,
                    c = i.document.bigScreen;
                [n, t, r, o].forEach(a && !c ? function(e) {
                    return e.classList.add("show")
                } : function(e) {
                    return e.classList.remove("show")
                })
            }
        }]), e
    }();
    t.default = s
}, function(e, t, n) {
    "use strict";
    Object.defineProperty(t, "__esModule", {
        value: !0
    });
    var r = function() {
        function e(e, t) {
            for (var n = 0; n < t.length; n++) {
                var r = t[n];
                r.enumerable = r.enumerable || !1, r.configurable = !0, "value" in r && (r.writable = !0), Object.defineProperty(e, r.key, r)
            }
        }
        return function(t, n, r) {
            return n && e(t.prototype, n), r && e(t, r), t
        }
    }();
    var o = function() {
        function e(t) {
            ! function(e, t) {
                if (!(e instanceof t)) throw new TypeError("Cannot call a class as a function")
            }(this, e), this.props = t, this.bar = this.props.container.children[0], this.oldPositionStyle = window.getComputedStyle(this.bar).getPropertyValue("position"), this.initialize = this.initialize.bind(this), this.refresh = this.refresh.bind(this), this.initialize()
        }
        return r(e, [{
            key: "initialize",
            value: function() {
                var e = this,
                    t = this.props.condition;
                this.refresh(), window.__scrollWatcher__.addWatch({
                    matchCondition: t,
                    onappear: function(t) {
                        e.bar.style.position = "fixed", e.bar.classList.add("fixed")
                    },
                    ondisappear: function(t) {
                        e.bar.style.position = e.oldPositionStyle, e.bar.classList.remove("fixed")
                    }
                }), window.__dimensionWatcher__.addWatch({
                    onchange: e.refresh
                })
            }
        }, {
            key: "refresh",
            value: function() {
                var e = this.props,
                    t = e.preserveHeight,
                    n = e.container;
                t && (n.style.height = this.bar.offsetHeight + "px"), this.bar.style.width = n.offsetWidth + "px"
            }
        }]), e
    }();
    t.default = o
}, function(e, t) {}]);
