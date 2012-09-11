(function(Crystal){
 (function() {
  var Attributes, Color, Dialogs, Logging, MVC, Mediator, Types, Unit, Utils, css, i18n, key, method, methods, methods_element, methods_node, prefixes, properties, types, value, _find, _parseName, _ref, _ref1, _ref2, _wrap,
    __hasProp = {}.hasOwnProperty,
    __slice = [].slice,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MVC = {};

  Logging = {};

  Utils = {};

  /*
  --------------- /home/gdot/github/crystal/source/dom/node-list.coffee--------------
  */


  Object.defineProperties(NodeList.prototype, {
    forEach: {
      value: function(fn, bound) {
        var i, node, _i, _len;
        if (bound == null) {
          bound = this;
        }
        for (i = _i = 0, _len = this.length; _i < _len; i = ++_i) {
          node = this[i];
          fn.call(bound, node, i);
        }
        return this;
      }
    },
    map: {
      value: function(fn, bound) {
        var node, _i, _len, _results;
        if (bound == null) {
          bound = this;
        }
        _results = [];
        for (_i = 0, _len = this.length; _i < _len; _i++) {
          node = this[_i];
          _results.push(fn.call(bound, node));
        }
        return _results;
      }
    },
    pluck: {
      value: function(property) {
        var node, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = this.length; _i < _len; _i++) {
          node = this[_i];
          _results.push(node[property]);
        }
        return _results;
      }
    },
    include: {
      value: function(el) {
        var node, _i, _len;
        for (_i = 0, _len = this.length; _i < _len; _i++) {
          node = this[_i];
          if (node === el) {
            return true;
          }
        }
        return false;
      }
    },
    first: {
      get: function() {
        return this[0];
      }
    },
    last: {
      get: function() {
        return this[this.length - 1];
      }
    }
  });

  /*
  --------------- /home/gdot/github/crystal/source/types/object.coffee--------------
  */


  Object.defineProperties(Object.prototype, {
    toFormData: {
      value: function() {
        var key, ret, value;
        ret = new FormData();
        for (key in this) {
          if (!__hasProp.call(this, key)) continue;
          value = this[key];
          ret.append(key, value);
        }
        return ret;
      }
    },
    toQueryString: {
      value: function() {
        var key, value;
        return ((function() {
          var _results;
          _results = [];
          for (key in this) {
            if (!__hasProp.call(this, key)) continue;
            value = this[key];
            _results.push("" + key + "=" + (value.toString()));
          }
          return _results;
        }).call(this)).join("&");
      }
    }
  });

  Object.each = function(object, fn) {
    var key, value, _results;
    _results = [];
    for (key in object) {
      if (!__hasProp.call(object, key)) continue;
      value = object[key];
      _results.push(fn.call(object, key, value));
    }
    return _results;
  };

  Object.pluck = function(object, prop) {
    var key, value, _results;
    _results = [];
    for (key in object) {
      if (!__hasProp.call(object, key)) continue;
      value = object[key];
      _results.push(value[prop]);
    }
    return _results;
  };

  Object.values = function(object) {
    var key, value, _results;
    _results = [];
    for (key in object) {
      if (!__hasProp.call(object, key)) continue;
      value = object[key];
      _results.push(value);
    }
    return _results;
  };

  Object.canRespondTo = function() {
    var arg, args, object, ret, _i, _len;
    object = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    ret = true;
    for (_i = 0, _len = args.length; _i < _len; _i++) {
      arg = args[_i];
      if (typeof object[arg] !== 'function') {
        ret = false;
      }
    }
    return ret;
  };

  /*
  --------------- /home/gdot/github/crystal/source/types/array.coffee--------------
  */


  methods = {
    remove: function(item) {
      var b, index;
      b = this.dup();
      if ((index = b.indexOf(item)) !== -1) {
        b.splice(index, 1);
      }
      return b;
    },
    removeAll: function(item) {
      var b, index;
      b = this.dup();
      while ((index = b.indexOf(item)) !== -1) {
        b.splice(index, 1);
      }
      return b;
    },
    uniq: function() {
      var b;
      b = new this.__proto__.constructor;
      this.filter(function(item) {
        if (!b.include(item)) {
          return b.push(item);
        }
      });
      return b;
    },
    shuffle: function() {
      var shuffled;
      shuffled = [];
      this.forEach(function(value, index) {
        var rand;
        rand = Math.floor(Math.random() * (index + 1));
        shuffled[index] = shuffled[rand];
        return shuffled[rand] = value;
      });
      return shuffled;
    },
    compact: function() {
      return this.filter(function(item) {
        return !!item;
      });
    },
    dup: function(item) {
      return this.filter(function() {
        return true;
      });
    },
    pluck: function(property) {
      return this.map(function(item) {
        return item[property];
      });
    },
    include: function(item) {
      return this.indexOf(item) !== -1;
    }
  };

  for (key in methods) {
    method = methods[key];
    Object.defineProperty(Array.prototype, key, {
      value: method
    });
  }

  Object.defineProperties(Array.prototype, {
    sample: {
      get: function() {
        return this[Math.floor(Math.random() * this.length)];
      }
    },
    first: {
      get: function() {
        return this[0];
      }
    },
    last: {
      get: function() {
        return this[this.length - 1];
      }
    }
  });

  /*
  --------------- /home/gdot/github/crystal/source/dom/element.coffee--------------
  */


  Attributes = {
    title: {
      prefix: "!",
      unique: true
    },
    name: {
      prefix: "&",
      unique: true
    },
    type: {
      prefix: "%",
      unique: true
    },
    id: {
      prefix: "#",
      unique: true
    },
    "class": {
      prefix: "\\.",
      unique: false
    },
    role: {
      prefix: "~",
      unique: true
    }
  };

  prefixes = Object.pluck(Attributes, 'prefix').concat("$").join("|");

  Object.each(Attributes, function(key, value) {
    return value.regexp = new RegExp(value.prefix + ("(.*?)(?=" + prefixes + ")"), "g");
  });

  _wrap = function(fn) {
    return function() {
      var args, el, _i, _len, _results;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _results = [];
      for (_i = 0, _len = this.length; _i < _len; _i++) {
        el = this[_i];
        _results.push(fn.apply(el, args));
      }
      return _results;
    };
  };

  _find = function(property, selector, el) {
    var elements;
    elements = document.querySelectorAll(selector);
    while (el = el[property]) {
      if (el instanceof Element) {
        if (elements.include(el)) {
          return el;
        }
      }
    }
  };

  _parseName = function(name, atts) {
    var ret;
    if (atts == null) {
      atts = {};
    }
    ret = {
      tag: name.match(new RegExp("^.*?(?=" + prefixes + ")"))[0] || 'div',
      attributes: {}
    };
    Object.each(Attributes, function(key, value) {
      var m, map;
      if ((m = name.match(value.regexp)) !== null) {
        name = name.replace(value.regexp, "");
        if (value.unique) {
          if (atts[key]) {
            if (atts[key] !== null && atts[key] !== void 0) {
              return ret.attributes[key] = atts[key];
            }
          } else {
            return ret.attributes[key] = m.pop().slice(1);
          }
        } else {
          map = m.map(function(item) {
            return item.slice(1);
          });
          if (atts[key]) {
            if (typeof atts[key] === 'string') {
              map = map.concat(atts[key].split(" "));
            } else {
              map = map.concat(atts[key]);
            }
          }
          return ret.attributes[key] = map.compact().join(" ");
        }
      } else {
        if (atts[key] !== null && atts[key] !== void 0) {
          return ret.attributes[key] = atts[key];
        }
      }
    });
    return ret;
  };

  methods_node = {
    append: function() {
      var el, elements, _i, _len, _results;
      elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _results = [];
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        el = elements[_i];
        _results.push(this.appendChild(el));
      }
      return _results;
    },
    first: function(selector) {
      if (selector == null) {
        selector = "*";
      }
      return this.querySelector(selector);
    },
    last: function(selector) {
      if (selector == null) {
        selector = "*";
      }
      return this.querySelectorAll(selector).last();
    },
    all: function(selector) {
      if (selector == null) {
        selector = "*";
      }
      return this.querySelectorAll(selector);
    },
    empty: function() {
      return this.querySelectorAll("*").dispose();
    }
  };

  methods_element = {
    dispose: function() {
      var _ref;
      return (_ref = this.parent) != null ? _ref.removeChild(this) : void 0;
    },
    ancestor: function(selector) {
      if (selector == null) {
        selector = "*";
      }
      return _find('parentElement', selector, this);
    },
    next: function(selector) {
      if (selector == null) {
        selector = "*";
      }
      return _find('nextSibling', selector, this);
    },
    prev: function(selector) {
      if (selector == null) {
        selector = "*";
      }
      return _find('previousSibling', selector, this);
    },
    css: function() {
      var args, property, value;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      property = args[0];
      if (args.length === 1) {
        if (this.currentStyle) {
          value = this.currentStyle[property];
        } else {
          value = window.getComputedStyle(this)[property];
        }
        return value;
      }
      if (args.length === 2) {
        value = args[1];
        return this.style[property] = value;
      }
    }
  };

  for (key in methods_node) {
    method = methods_node[key];
    Object.defineProperty(Node.prototype, key, {
      value: method
    });
  }

  for (key in methods_element) {
    method = methods_element[key];
    Object.defineProperty(NodeList.prototype, key, {
      value: _wrap(method)
    });
    Object.defineProperty(HTMLElement.prototype, key, {
      value: method
    });
  }

  Object.defineProperty(HTMLSelectElement.prototype, 'selectedOption', {
    get: function() {
      if (this.children) {
        return this.children[this.selectedIndex];
      }
    },
    set: function(el) {
      if (this.chidren.include(el)) {
        return this.selectedIndex = this.children.indexOf(el);
      }
    }
  });

  properties = {
    tag: {
      get: function() {
        return this.tagName.toLowerCase();
      }
    },
    parent: {
      get: function() {
        return this.parentElement;
      },
      set: function(el) {
        if (!(el instanceof HTMLElement)) {
          return;
        }
        return el.append(this);
      }
    },
    text: {
      get: function() {
        return this.textContent;
      },
      set: function(value) {
        return this.textContent = value;
      }
    },
    html: {
      get: function() {
        return this.innerHTML;
      },
      set: function(value) {
        return this.innerHTML = value;
      }
    },
    "class": {
      get: function() {
        return this.getAttribute('class');
      },
      set: function(value) {
        return this.setAttribute('class', value);
      }
    }
  };

  Object.defineProperties(HTMLElement.prototype, properties);

  Object.defineProperty(Node.prototype, 'delegateEventListener', {
    value: function(event, listener, useCapture) {
      var baseEvent, selector, _ref;
      _ref = event.split(':'), baseEvent = _ref[0], selector = _ref[1];
      return this.addEventListener(baseEvent, function(e) {
        if (e.target.webkitMatchesSelector(selector)) {
          return listener(e);
        }
      });
    }
  });

  ['addEventListener', 'removeEventListener', 'delegateEventListener'].forEach(function(prop) {
    Object.defineProperty(Node.prototype, prop.replace("Listener", ''), {
      value: Node.prototype[prop]
    });
    return Object.defineProperty(window, prop.replace("Listener", ''), {
      value: window[prop]
    });
  });

  Element.create = function(node, atts) {
    var attributes, desc, tag, value, _ref;
    if (atts == null) {
      atts = {};
    }
    if (node instanceof Node) {
      return node;
    }
    switch (typeof node) {
      case 'string':
        _ref = _parseName(node, atts), tag = _ref.tag, attributes = _ref.attributes;
        node = document.createElement(tag);
        for (key in attributes) {
          value = attributes[key];
          if ((desc = properties[key])) {
            node[key] = value;
            continue;
          }
          node.setAttribute(key, value);
        }
        break;
      default:
        node = document.createElement('div');
    }
    return node;
  };

  Node;


  /*
  --------------- /home/gdot/github/crystal/source/dom/document-fragment.coffee--------------
  */


  Object.defineProperties(DocumentFragment.prototype, {
    children: {
      get: function() {
        return this.childNodes;
      }
    },
    remove: {
      value: function(el) {
        var node, _i, _len, _ref;
        _ref = this.childNodes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          node = _ref[_i];
          if (node === el) {
            this.removeChild(el);
          }
        }
        return this;
      }
    }
  });

  DocumentFragment.create = function() {
    return document.createDocumentFragment();
  };

  /*
  --------------- /home/gdot/github/crystal/source/mvc/collectionElement.coffee--------------
  */


  Object.defineProperty(Node.prototype, 'context', {
    set: function(value) {
      this.templates = Array.prototype.slice.call(this.children);
      this.emtpy();
      if (value instanceof Collection) {
        value.on('add', function(item) {});
        value.on('remove');
        return value.on('change');
      }
    }
  });

  /*
  --------------- /home/gdot/github/crystal/source/utils/evented.coffee--------------
  */


  Mediator = {
    events: {},
    listeners: {},
    fireEvent: function(type, event) {
      if (this.listeners[type]) {
        return this.listeners[type].apply(this, event);
      }
    },
    addListener: function(type, callback) {
      return this.listeners[type] = callback;
    },
    removeListener: function(type) {
      return delete this.listeners[type];
    }
  };

  Utils.Event = (function() {

    function Event(type, target) {
      this.cancelled = false;
      this.target = target;
      this.type = type;
    }

    Event.prototype.destroy = function() {
      var value, _results;
      _results = [];
      for (key in this) {
        value = this[key];
        _results.push(this[key] = null);
      }
      return _results;
    };

    Event.prototype.stop = function() {
      return this.cancelled = true;
    };

    return Event;

  })();

  Utils.Evented = (function() {

    function Evented() {}

    Evented.prototype.publish = function() {
      var args, event, type;
      type = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      this.trigger.apply(this, Array.prototype.slice(arguments));
      event = new Event(type, this);
      args.push(event);
      return Mediator.fireEvent(type, args);
    };

    Evented.prototype.trigger = function() {
      var args, callback, event, type, _i, _len, _ref, _results;
      type = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      this.ensureEvents();
      event = new Event(type, this);
      args.push(event);
      if (this.__events__[type]) {
        _ref = this.__events__[type];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          callback = _ref[_i];
          _results.push(callback.apply(this, args));
        }
        return _results;
      }
    };

    Evented.prototype.ensureEvents = function() {
      if (!this.__events__) {
        return Object.defineProperty(this, '__events__', {
          value: {}
        });
      }
    };

    Evented.prototype.on = function(type, callback, bind) {
      var _base, _ref;
      this.ensureEvents();
      if ((_ref = (_base = this.__events__)[type]) == null) {
        _base[type] = [];
      }
      if (bind) {
        callback = callback.bind(bind);
      }
      return this.__events__[type].push(callback);
    };

    Evented.prototype.off = function(type, callback) {
      this.ensureEvents();
      if (this.__events__[type]) {
        if (this.__events__[type].include(callback)) {
          return this.__events__[type].remove(callback);
        }
      }
    };

    Evented.prototype.subscribe = function(type, callback) {
      if (!Mediator.events[type]) {
        Mediator.addListener(type, function(event) {
          var cb, _i, _len, _ref;
          _ref = Mediator.events[event.type];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            cb = _ref[_i];
            if (event.cancelled) {
              break;
            }
            cb(event);
          }
          return event.destroy();
        });
        Mediator.events[type] = [];
      }
      return Mediator.events[type].push(callback);
    };

    Evented.prototype.unsubscribe = function(type, callback) {
      if (Mediator.events[type] === void 0) {
        console.error("No channel '" + type + "' exists");
        return false;
      }
      if (Mediator.events[type].include(callback)) {
        Mediator.events[type].remove(callback);
      }
      if (Mediator.events[type].length === 0) {
        delete Mediator.events[type];
        return Mediator.removeListener(type);
      }
    };

    return Evented;

  })();

  window.Evented = Utils.Evented;

  /*
  --------------- /home/gdot/github/crystal/source/mvc/collection.coffee--------------
  */


  window.Collection = MVC.Collection = (function(_super) {

    __extends(Collection, _super);

    function Collection() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      Collection.__super__.constructor.apply(this, arguments);
      this.push.apply(this, args);
      this;

    }

    Collection.prototype.pop = function() {
      var item;
      item = Collection.__super__.pop.apply(this, arguments);
      this.trigger('remove', item);
      this.trigger('change');
      return item;
    };

    Collection.prototype.push = function() {
      var item, l, oldl, _i, _len;
      oldl = this.length;
      l = Collection.__super__.push.apply(this, arguments);
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        item = arguments[_i];
        this.trigger('add', item);
        this.trigger('change');
      }
      return l;
    };

    Collection.prototype.shift = function() {
      var item;
      item = Collection.__super__.shift.apply(this, arguments);
      this.trigger('remove', item);
      this.trigger('change');
      return item;
    };

    Collection.prototype.reverse = function() {
      var r;
      r = Collection.__super__.reverse.apply(this, arguments);
      this.trigger('change');
      return r;
    };

    Collection.prototype.sort = function() {
      var r;
      r = Collection.__super__.sort.apply(this, arguments);
      this.trigger('change');
      return r;
    };

    Collection.prototype.splice = function() {
      var a, args, i, index, item, length, r, _i, _j, _len, _len1;
      index = arguments[0], length = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      a = (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = index, _ref = index + length - 1; index <= _ref ? _i <= _ref : _i >= _ref; i = index <= _ref ? ++_i : --_i) {
          _results.push(this[i]);
        }
        return _results;
      }).call(this);
      r = Collection.__super__.splice.apply(this, arguments);
      for (_i = 0, _len = a.length; _i < _len; _i++) {
        item = a[_i];
        if (item) {
          this.trigger('remove', item);
        }
      }
      for (_j = 0, _len1 = args.length; _j < _len1; _j++) {
        item = args[_j];
        this.trigger('add', item);
      }
      return r;
    };

    Collection.prototype.unshift = function() {
      var item, l, _i, _len;
      l = Collection.__super__.unshift.apply(this, arguments);
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        item = arguments[_i];
        this.trigger('add', item);
        this.trigger('change');
      }
      return l;
    };

    return Collection;

  })(Array);

  _ref = Evented.prototype;
  for (key in _ref) {
    value = _ref[key];
    Collection.prototype[key] = value;
  }

  Collection;


  /*
  --------------- /home/gdot/github/crystal/source/nw/file.coffee--------------
  */


  if (require) {
    if ((_ref1 = window.NW) == null) {
      window.NW = {};
    }
    window.NW.File = NW.File = (function() {

      function File(path) {
        this.path = path;
        this.fs = window.fs || require('fs');
      }

      File.prototype.read = function() {
        return this.fs.readFileSync(this.path, 'UTF-8');
      };

      File.prototype.write = function(data) {
        return this.fs.writeFileSync(this.path, data.toString(), 'UTF-8');
      };

      return File;

    })();
  }

  /*
  --------------- /home/gdot/github/crystal/source/nw/dialogs.coffee--------------
  */


  if (require) {
    if ((_ref2 = window.NW) == null) {
      window.NW = {};
    }
    window.NW.Dialogs = new (Dialogs = (function() {

      function Dialogs() {
        var _this = this;
        this.input = Element.create('input');
        this.input.setAttribute('type', 'file');
        this.input.addEventListener('change', function() {
          var file;
          switch (_this.type) {
            case 'open':
              if (_this.input.files.length > 0) {
                file = new NW.File(_this.input.files[0].path);
                return _this.callback(file);
              }
              break;
            case 'save':
              if (_this.input.files.length > 0) {
                file = new NW.File(_this.input.files[0].path);
                file.write(_this.data);
                return _this.callback();
              }
          }
        });
      }

      Dialogs.prototype.open = function(callback) {
        if (callback == null) {
          callback = function() {};
        }
        this.input.removeAttribute('nwsaveas');
        this.input.click();
        this.type = "open";
        return this.callback = callback;
      };

      Dialogs.prototype.save = function(data, callback) {
        if (callback == null) {
          callback = function() {};
        }
        this.input.setAttribute('nwsaveas', 'true');
        this.data = data;
        this.callback = callback;
        this.type = "save";
        return this.input.click();
      };

      return Dialogs;

    })());
  }

  /*
  --------------- /home/gdot/github/crystal/source/utils/base64.coffee--------------
  */


  Utils.Base64 = (function() {

    function Base64() {}

    Base64.prototype._keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    Base64.prototype.encode = function(input) {
      var chr1, chr2, chr3, enc1, enc2, enc3, enc4, i, output;
      output = "";
      i = 0;
      input = Base64.UTF8Encode(input);
      while (i < input.length) {
        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);
        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;
        if (isNaN(chr2)) {
          enc3 = enc4 = 64;
        } else {
          if (isNaN(chr3)) {
            enc4 = 64;
          }
        }
        output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
      }
      return output;
    };

    Base64.prototype.decode = function(input) {
      var chr1, chr2, chr3, enc1, enc2, enc3, enc4, i, output;
      output = "";
      i = 0;
      input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
      while (i < input.length) {
        enc1 = this._keyStr.indexOf(input.charAt(i++));
        enc2 = this._keyStr.indexOf(input.charAt(i++));
        enc3 = this._keyStr.indexOf(input.charAt(i++));
        enc4 = this._keyStr.indexOf(input.charAt(i++));
        chr1 = (enc1 << 2) | (enc2 >> 4);
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
        chr3 = ((enc3 & 3) << 6) | enc4;
        output = output + String.fromCharCode(chr1);
        if (enc3 !== 64) {
          output = output + String.fromCharCode(chr2);
        }
        if (enc4 !== 64) {
          output = output + String.fromCharCode(chr3);
        }
      }
      output = Base64.UTF8Decode(output);
      return output;
    };

    Base64.prototype.UTF8Encode = function(string) {
      var c, n, utftext;
      string = string.replace(/\r\n/g, "\n");
      utftext = "";
      n = 0;
      while (n < string.length) {
        c = string.charCodeAt(n);
        if (c < 128) {
          utftext += String.fromCharCode(c);
        } else if ((c > 127) && (c < 2048)) {
          utftext += String.fromCharCode((c >> 6) | 192);
          utftext += String.fromCharCode((c & 63) | 128);
        } else {
          utftext += String.fromCharCode((c >> 12) | 224);
          utftext += String.fromCharCode(((c >> 6) & 63) | 128);
          utftext += String.fromCharCode((c & 63) | 128);
        }
        n++;
      }
      return utftext;
    };

    Base64.prototype.UTF8Decode = function(utftext) {
      var c, c1, c2, c3, i, string;
      string = "";
      i = 0;
      c = c1 = c2 = 0;
      while (i < utftext.length) {
        c = utftext.charCodeAt(i);
        if (c < 128) {
          string += String.fromCharCode(c);
          i++;
        } else if ((c > 191) && (c < 224)) {
          c2 = utftext.charCodeAt(i + 1);
          string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
          i += 2;
        } else {
          c2 = utftext.charCodeAt(i + 1);
          c3 = utftext.charCodeAt(i + 2);
          string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
          i += 3;
        }
      }
      return string;
    };

    return Base64;

  })();

  /*
  --------------- /home/gdot/github/crystal/source/utils/uri.coffee--------------
  */


  window.URI = Utils.URI = (function() {

    function URI(uri) {
      var m, parser, _ref3, _ref4;
      if (uri == null) {
        uri = '';
      }
      parser = document.createElement('a');
      parser.href = uri;
      if (!!(m = uri.match(/\/\/(.*?):(.*?)@/))) {
        _ref3 = m, m = _ref3[0], this.user = _ref3[1], this.password = _ref3[2];
      }
      this.host = parser.hostname;
      this.protocol = parser.protocol.replace(/:$/, '');
      if (parser.port === "0") {
        this.port = 80;
      } else {
        this.port = parser.port || 80;
      }
      this.hash = parser.hash.replace(/^#/, '');
      this.query = ((_ref4 = uri.match(/\?(.*?)(?:#|$)/)) != null ? _ref4[1].parseQueryString() : void 0) || {};
      this.path = parser.pathname.replace(/^\//, '');
      this.parser = parser;
      this;

    }

    URI.prototype.toString = function() {
      var uri;
      uri = this.protocol;
      uri += "://";
      if (this.user && this.password) {
        uri += this.user.toString() + ":" + this.password.toString() + "@";
      }
      uri += this.host;
      if (this.port !== 80) {
        uri += ":" + this.port;
      }
      if (this.path !== "") {
        uri += "/" + this.path;
      }
      if (Object.keys(this.query).length > 0) {
        uri += "?" + this.query.toQueryString();
      }
      if (this.hash !== "") {
        uri += "#" + this.hash;
      }
      return uri;
    };

    return URI;

  })();

  /*
  --------------- /home/gdot/github/crystal/source/utils/i18n.coffee--------------
  */


  i18n = (function() {

    function i18n() {}

    i18n.locales = {};

    i18n.t = function(path) {
      var arg, locale, params, str, _path;
      if (arguments.length === 2) {
        if ((arg = arguments[1]) instanceof Object) {
          params = arg;
        } else {
          locale = arg;
        }
      }
      if (arguments.length === 3) {
        locale = arguments[2];
        params = arguments[1];
      }
      if (locale == null) {
        locale = document.querySelector('html').getAttribute('lang') || 'en';
      }
      _path = new Path(this.locales[locale]);
      str = _path.lookup(path);
      if (!str) {
        console.warn("No translation found for '" + path + "' for locale '" + locale + "'");
        return path;
      }
      return str.replace(/\{\{(.*?)\}\}/g, function(m, prop) {
        if (params[prop] !== void 0) {
          return params[prop].toString();
        } else {
          return '';
        }
      });
    };

    return i18n;

  })();

  window.i18n = i18n;

  /*
  --------------- /home/gdot/github/crystal/source/utils/path.coffee--------------
  */


  window.Path = Utils.Path = (function() {

    function Path(context) {
      this.context = context != null ? context : {};
    }

    Path.prototype.create = function(path, value) {
      var last, prop, segment, _i, _len;
      path = path.toString();
      last = this.context;
      prop = (path = path.split(/\./)).pop();
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        segment = path[_i];
        if (!last.hasOwnProperty(segment)) {
          last[segment] = {};
        }
        last = last[segment];
      }
      return last[prop] = value;
    };

    Path.prototype.exists = function(path) {
      return this.lookup(path) !== void 0;
    };

    Path.prototype.lookup = function(path) {
      var end, last, segment, _i, _len;
      end = (path = path.split(/\./)).pop();
      if (path.length === 0 && !this.context.hasOwnProperty(end)) {
        return void 0;
      }
      last = this.context;
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        segment = path[_i];
        if (last.hasOwnProperty(segment)) {
          last = last[segment];
        } else {
          return void 0;
        }
      }
      if (last.hasOwnProperty(end)) {
        return last[end];
      }
      return void 0;
    };

    return Path;

  })();

  /*
  --------------- /home/gdot/github/crystal/source/utils/history.coffee--------------
  */


  window.History = Utils.History = (function(_super) {

    __extends(History, _super);

    function History() {
      var _this = this;
      this._type = 'pushState' in history ? 'popstate' : 'hashchange';
      window.addEventListener(this._type, function(event) {
        var url;
        url = (function() {
          switch (this._type) {
            case 'popstate':
              return window.location.pathname;
            case 'hashchange':
              return window.location.hash;
          }
        }).call(_this);
        return _this.trigger('change', url);
      });
      this.stateid = 0;
    }

    History.prototype.push = function(url) {
      switch (this._type) {
        case 'popstate':
          return history.pushState({}, this.stateid++, url);
        case 'hashchange':
          return window.location.hash = url;
      }
    };

    return History;

  })(Evented);

  /*
  --------------- /home/gdot/github/crystal/source/types/number.coffee--------------
  */


  Object.defineProperties(Number.prototype, {
    seconds: {
      get: function() {
        return this.valueOf() * 1000;
      }
    },
    minutes: {
      get: function() {
        return this.seconds * 60;
      }
    },
    hours: {
      get: function() {
        return this.minutes * 60;
      }
    },
    days: {
      get: function() {
        return this.hours * 24;
      }
    },
    upto: {
      value: function(limit, func, bound) {
        var i, _results;
        if (bound == null) {
          bound = this;
        }
        i = parseInt(this);
        _results = [];
        while (i <= limit) {
          func.call(bound, i);
          _results.push(i++);
        }
        return _results;
      }
    },
    downto: {
      value: function(limit, func, bound) {
        var i, _results;
        if (bound == null) {
          bound = this;
        }
        i = parseInt(this);
        _results = [];
        while (i >= limit) {
          func.call(bound, i);
          _results.push(i--);
        }
        return _results;
      }
    },
    times: {
      value: function(func, bound) {
        var i, _i, _ref3, _results;
        if (bound == null) {
          bound = this;
        }
        _results = [];
        for (i = _i = 1, _ref3 = parseInt(this); 1 <= _ref3 ? _i <= _ref3 : _i >= _ref3; i = 1 <= _ref3 ? ++_i : --_i) {
          _results.push(func.call(bound, i));
        }
        return _results;
      }
    },
    clamp: {
      value: function(min, max) {
        var val;
        min = parseFloat(min);
        max = parseFloat(max);
        val = this.valueOf();
        if (val > max) {
          return max;
        } else if (val < min) {
          return min;
        } else {
          return val;
        }
      }
    },
    clampRange: {
      value: function(min, max) {
        var val;
        min = parseFloat(min);
        max = parseFloat(max);
        val = this.valueOf();
        if (val > max) {
          return val % max;
        } else if (val < min) {
          return max - val % max;
        } else {
          return val;
        }
      }
    }
  });

  /*
  --------------- /home/gdot/github/crystal/source/types/string.coffee--------------
  */


  Object.defineProperties(String.prototype, {
    compact: {
      value: function() {
        var s;
        s = this.valueOf().trim();
        return s.replace(/\s+/g, ' ');
      }
    },
    camelCase: {
      value: function() {
        return this.replace(/[- _](\w)/g, function(matches) {
          return matches[1].toUpperCase();
        });
      }
    },
    hyphenate: {
      value: function() {
        return this.replace(/[A-Z]/g, function(match) {
          return "-" + match.toLowerCase();
        });
      }
    },
    capitalize: {
      value: function() {
        return this.replace(/^\w|\s\w/g, function(match) {
          return match.toUpperCase();
        });
      }
    },
    indent: {
      value: function(spaces) {
        var s;
        if (spaces == null) {
          spaces = 2;
        }
        s = '';
        spaces = spaces.times(function() {
          return s += " ";
        });
        return this.replace(/^/gm, s);
      }
    },
    outdent: {
      value: function(spaces) {
        if (spaces == null) {
          spaces = 2;
        }
        return this.replace(new RegExp("^\\s{" + spaces + "}", "gm"), "");
      }
    },
    entities: {
      value: function() {
        return this.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
      }
    },
    parseQueryString: {
      value: function() {
        var match, regexp, ret;
        ret = {};
        regexp = /([^&=]+)=([^&]*)/g;
        while (match = regexp.exec(this)) {
          ret[decodeURIComponent(match[1])] = decodeURIComponent(match[2]);
        }
        return ret;
      }
    }
  });

  String.random = function(length) {
    var chars, i, str, _i;
    chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('');
    if (!length) {
      length = Math.floor(Math.random() * chars.length);
    }
    str = '';
    for (i = _i = 0; 0 <= length ? _i <= length : _i >= length; i = 0 <= length ? ++_i : --_i) {
      str += chars.sample;
    }
    return str;
  };

  /*
  --------------- /home/gdot/github/crystal/source/utils/request.coffee--------------
  */


  window.Response = Utils.Response = (function() {

    function Response(headers, body, status) {
      var df, div, node;
      this.headers = headers;
      this.raw = body;
      this.status = status;
      this.body = (function() {
        var _i, _len, _ref3;
        switch (this.headers['Content-Type']) {
          case "text/html":
            div = document.createElement('div');
            div.innerHTML = body;
            df = document.createDocumentFragment();
            _ref3 = div.childNodes;
            for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
              node = _ref3[_i];
              df.appendChild(node);
            }
            return df;
          case "text/json":
          case "application/json":
            try {
              return JSON.parse(body);
            } catch (e) {
              return body;
            }
            break;
          default:
            return body;
        }
      }).call(this);
    }

    return Response;

  })();

  types = {
    script: ['text/javascript'],
    html: ['text/html'],
    JSON: ['text/json', 'application/json'],
    XML: ['text/xml']
  };

  Object.each(types, function(key, value) {
    return Object.defineProperty(Response.prototype, 'is' + key.capitalize(), {
      value: function() {
        var _this = this;
        return value.map(function(type) {
          return _this.headers['Content-Type'] === type;
        }).compact().length > 0;
      }
    });
  });

  window.Request = Utils.Request = (function() {

    function Request(url, headers) {
      if (headers == null) {
        headers = {};
      }
      this.handleStateChange = __bind(this.handleStateChange, this);

      this.uri = url;
      this.headers = headers;
      this._request = new XMLHttpRequest();
      this._request.onreadystatechange = this.handleStateChange;
    }

    Request.prototype.request = function(method, data, callback) {
      var _ref3;
      if (method == null) {
        method = 'GET';
      }
      if ((this._request.readyState === 4) || (this._request.readyState === 0)) {
        if (method.toUpperCase() === 'GET' && data !== void 0 && data !== null) {
          this._request.open(method, this.uri + "?" + data.toQueryString());
        } else {
          this._request.open(method, this.uri);
        }
        _ref3 = this.headers;
        for (key in _ref3) {
          if (!__hasProp.call(_ref3, key)) continue;
          value = _ref3[key];
          this._request.setRequestHeader(key.toString(), value.toString());
        }
        this._callback = callback;
        return this._request.send(data != null ? data.toFormData() : void 0);
      }
    };

    Request.prototype.parseResponseHeaders = function() {
      var r;
      r = {};
      this._request.getAllResponseHeaders().split(/\n/).compact().forEach(function(header) {
        var _ref3;
        _ref3 = header.split(/:\s/), key = _ref3[0], value = _ref3[1];
        return r[key.trim()] = value.trim();
      });
      return r;
    };

    Request.prototype.handleStateChange = function() {
      var body, headers, status;
      if (this._request.readyState === 4) {
        headers = this.parseResponseHeaders();
        body = this._request.response;
        status = this._request.status;
        this._callback(new Response(headers, body, status));
        return this._request.responseText;
      }
    };

    return Request;

  })();

  ['get', 'post', 'put', 'delete', 'patch'].forEach(function(type) {
    return Request.prototype[type] = function() {
      var callback, data;
      if (arguments.length === 2) {
        data = arguments[0];
        callback = arguments[1];
      } else {
        callback = arguments[0];
      }
      return this.request(type.toUpperCase(), data, callback);
    };
  });

  /*
  --------------- /home/gdot/github/crystal/source/crystal.coffee--------------
  */


  Types = {};

  /*
  --------------- /home/gdot/github/crystal/source/types/color.coffee--------------
  */


  window.Color = Color = (function() {

    function Color(color) {
      var hex, match;
      if (color == null) {
        color = "FFFFFF";
      }
      if ((match = color.match(/^#?([0-9a-f]{3}|[0-9a-f]{6})$/i))) {
        if (color.match(/^#/)) {
          hex = color.slice(1);
        } else {
          hex = color;
        }
        if (hex.length === 3) {
          hex = hex.replace(/([0-9a-f])/gi, '$1$1');
        }
        this.type = 'hex';
        this._hex = hex;
        this._alpha = 100;
        this._update('hex');
      } else if ((match = color.match(/^hsla?\((\d{0,3}),\s*(\d{1,3})%,\s*(\d{1,3})%(,\s*([01]?\.?\d*))?\)$/)) != null) {
        this.type = 'hsl';
        this._hue = parseInt(match[1]).clamp(0, 360);
        this._saturation = parseInt(match[2]).clamp(0, 100);
        this._lightness = parseInt(match[3]).clamp(0, 100);
        this._alpha = parseInt(parseFloat(match[5]) * 100) || 100;
        this._alpha = this._alpha.clamp(0, 100);
        this.type += match[5] ? "a" : "";
        this._update('hsl');
      } else if ((match = color.match(/^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})(,\s*([01]?\.?\d*))?\)$/)) != null) {
        this.type = 'rgb';
        this._red = parseInt(match[1]).clamp(0, 255);
        this._green = parseInt(match[2]).clamp(0, 255);
        this._blue = parseInt(match[3]).clamp(0, 255);
        this._alpha = parseInt(parseFloat(match[5]) * 100) || 100;
        this._alpha = this._alpha.clamp(0, 100);
        this.type += match[5] ? "a" : "";
        this._update('rgb');
      } else {
        throw 'Wrong color format!';
      }
    }

    Color.prototype.invert = function() {
      this._red = 255 - this._red;
      this._green = 255 - this._green;
      this._blue = 255 - this._blue;
      this._update('rgb');
      return this;
    };

    /*
      TODO refactor
      mix: (color2, alpha) ->
        for item in [0,1,2]
          @rgb[item] = Utils.clamp(((@rgb[item] / 100 * (100 - alpha))+(color2.rgb[item] / 100 * alpha)), 0, 255)
        @_update 'rgb'
        @
    */


    Color.prototype._hsl2rgb = function() {
      var h, i, l, rgb, s, t1, t2, t3, val;
      h = this._hue / 360;
      s = this._saturation / 100;
      l = this._lightness / 100;
      if (s === 0) {
        val = l * 255;
        return [val, val, val];
      }
      if (l < 0.5) {
        t2 = l * (1 + s);
      } else {
        t2 = l + s - l * s;
      }
      t1 = 2 * l - t2;
      rgb = [0, 0, 0];
      i = 0;
      while (i < 3) {
        t3 = h + 1 / 3 * -(i - 1);
        t3 < 0 && t3++;
        t3 > 1 && t3--;
        if (6 * t3 < 1) {
          val = t1 + (t2 - t1) * 6 * t3;
        } else if (2 * t3 < 1) {
          val = t2;
        } else if (3 * t3 < 2) {
          val = t1 + (t2 - t1) * (2 / 3 - t3) * 6;
        } else {
          val = t1;
        }
        rgb[i] = val * 255;
        i++;
      }
      this._red = rgb[0];
      this._green = rgb[1];
      return this._blue = rgb[2];
    };

    Color.prototype._hex2rgb = function() {
      value = parseInt(this._hex, 16);
      this._red = value >> 16;
      this._green = (value >> 8) & 0xFF;
      return this._blue = value & 0xFF;
    };

    Color.prototype._rgb2hex = function() {
      var x;
      value = this._red << 16 | (this._green << 8) & 0xffff | this._blue;
      x = value.toString(16);
      x = '000000'.substr(0, 6 - x.length) + x;
      return this._hex = x.toUpperCase();
    };

    Color.prototype._rgb2hsl = function() {
      var b, delta, g, h, l, max, min, r, s;
      r = this._red / 255;
      g = this._green / 255;
      b = this._blue / 255;
      min = Math.min(r, g, b);
      max = Math.max(r, g, b);
      delta = max - min;
      if (max === min) {
        h = 0;
      } else if (r === max) {
        h = (g - b) / delta;
      } else if (g === max) {
        h = 2 + (b - r) / delta;
      } else {
        if (b === max) {
          h = 4 + (r - g) / delta;
        }
      }
      h = Math.min(h * 60, 360);
      if (h < 0) {
        h += 360;
      }
      l = (min + max) / 2;
      if (max === min) {
        s = 0;
      } else if (l <= 0.5) {
        s = delta / (max + min);
      } else {
        s = delta / (2 - max - min);
      }
      this._hue = h;
      this._saturation = s * 100;
      return this._lightness = l * 100;
    };

    Color.prototype._update = function(type) {
      switch (type) {
        case 'rgb':
          this._rgb2hsl();
          return this._rgb2hex();
        case 'hsl':
          this._hsl2rgb();
          return this._rgb2hex();
        case 'hex':
          this._hex2rgb();
          return this._rgb2hsl();
      }
    };

    Color.prototype.toString = function(type) {
      if (type == null) {
        type = 'hex';
      }
      switch (type) {
        case "rgb":
          return "rgb(" + this._red + ", " + this._green + ", " + this._blue + ")";
        case "rgba":
          return "rgba(" + this._red + ", " + this._green + ", " + this._blue + ", " + (this.alpha / 100) + ")";
        case "hsl":
          return "hsl(" + this._hue + ", " + (Math.round(this._saturation)) + "%, " + (Math.round(this._lightness)) + "%)";
        case "hsla":
          return "hsla(" + this._hue + ", " + (Math.round(this._saturation)) + "%, " + (Math.round(this._lightness)) + "%, " + (this.alpha / 100) + ")";
        case "hex":
          return this.hex;
      }
    };

    return Color;

  })();

  ['red', 'green', 'blue'].forEach(function(item) {
    return Object.defineProperty(Color.prototype, item, {
      get: function() {
        return this["_" + item];
      },
      set: function(value) {
        this["_" + item] = parseInt(value).clamp(0, 255);
        return this._update('rgb');
      }
    });
  });

  ['lightness', 'saturation'].forEach(function(item) {
    return Object.defineProperty(Color.prototype, item, {
      get: function() {
        return this["_" + item];
      },
      set: function(value) {
        this["_" + item] = parseInt(value).clamp(0, 100);
        return this._update('hsl');
      }
    });
  });

  ['rgba', 'rgb', 'hsla', 'hsl'].forEach(function(item) {
    return Object.defineProperty(Color.prototype, item, {
      get: function() {
        return this.toString(item);
      }
    });
  });

  Object.defineProperties(Color.prototype, {
    hex: {
      get: function() {
        return this._hex;
      },
      set: function(value) {
        this._hex = value;
        return this._update('hex');
      }
    },
    hue: {
      get: function() {
        return this._hue;
      },
      set: function(value) {
        this._hue = parseInt(value).clamp(0, 360);
        return this._update('hsl');
      }
    },
    alpha: {
      get: function() {
        return this._alpha;
      },
      set: function(value) {
        return this._alpha = parseInt(value).clamp(0, 100);
      }
    }
  });

  /*
  --------------- /home/gdot/github/crystal/source/types/unit.coffee--------------
  */


  Unit = (function() {

    Unit.UNITS = {
      px: 0,
      em: 1,
      pt: 2
    };

    Unit.TABLE = [1, 16, 16 / 12];

    function Unit(value) {
      if (value == null) {
        value = "0px";
      }
      this.set(value);
    }

    Unit.prototype.toString = function(type) {
      if (type == null) {
        type = "px";
      }
      if (!(type in Unit.UNITS)) {
        return this._value + "px";
      }
      return Math.round(this._value / Unit.TABLE[Unit.UNITS[type]] * 100) / 100 + type;
    };

    Unit.prototype.set = function(value) {
      var factor, m, v;
      if ((m = value.match(/(\d+)(\w{2,5})$/))) {
        v = parseInt(m[1]) || 0;
        factor = Unit.TABLE[Unit.UNITS[m[2]]];
        if (isNaN(v) || factor === void 0) {
          throw 'Wrong Unit format!';
        }
      } else {
        v = 0;
        factor = 0;
      }
      return this._value = v * factor;
    };

    return Unit;

  })();

  ['px', 'em', 'pt'].forEach(function(type) {
    return Object.defineProperty(Unit.prototype, type, {
      get: function() {
        return this.toString(type);
      }
    });
  });

  /*
  --------------- /home/gdot/github/crystal/source/types/function.coffee--------------
  */


  Object.defineProperties(Function.prototype, {
    delay: {
      value: function() {
        var args, bind, id, ms;
        ms = arguments[0], bind = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
        if (bind == null) {
          bind = this;
        }
        return id = setTimeout(ms, function() {
          clearTimeout(id);
          return this.apply(bind, args);
        });
      }
    },
    periodical: {
      value: function() {
        var args, bind, ms;
        ms = arguments[0], bind = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
        if (bind == null) {
          bind = this;
        }
        return setInterval(ms, function() {
          return this.apply(bind, args);
        });
      }
    }
  });

  /*
  --------------- /home/gdot/github/crystal/source/types/date.coffee--------------
  */


  Date.Locale = {
    ago: {
      seconds: " seconds ago",
      minutes: " minutes ago",
      hours: " hours ago",
      days: " days ago",
      now: "just no"
    },
    format: "%Y-%M-%D"
  };

  Object.defineProperties(Date.prototype, {
    ago: {
      get: function() {
        var diff;
        diff = +new Date() - this;
        if (diff < 1..seconds) {
          return "just now";
        } else if (diff < 1..minutes) {
          return Math.round(diff / 1000) + Date.Locale.ago.seconds;
        } else if (diff < 1..seconds) {
          return Math.round(diff / 1..minutes) + Date.Locale.ago.minues;
        } else if (diff < 1..days) {
          return Math.round(diff / 1..hours) + Date.Locale.ago.hours;
        } else if (diff < 30..days) {
          return Math.round(diff / 1..days) + Date.Locale.ago.days;
        } else {
          return this.format(Date.Locale.format);
        }
      }
    },
    format: {
      value: function(str) {
        var _this = this;
        if (str == null) {
          str = Date.Locale.format;
        }
        return str.replace(/%([a-zA-z])/g, function($0, $1) {
          switch ($1) {
            case 'D':
              return _this.getDate().toString().replace(/^\d$/, "0$&");
            case 'd':
              return _this.getDate();
            case 'Y':
              return _this.getFullYear();
            case 'h':
              return _this.getHours();
            case 'H':
              return _this.getHours().toString().replace(/^\d$/, "0$&");
            case 'M':
              return (_this.getMonth() + 1).toString().replace(/^\d$/, "0$&");
            case 'm':
              return _this.getMonth() + 1;
            case "T":
              return _this.getMinutes().toString().replace(/^\d$/, "0$&");
            case "t":
              return _this.getMinutes();
            default:
              return "";
          }
        });
      }
    }
  });

  ['day:Date', 'year:FullYear', 'hours:Hours', 'minutes:Minutes', 'seconds:Seconds'].forEach(function(item) {
    var meth, prop, _ref3;
    _ref3 = item.split(/:/), prop = _ref3[0], meth = _ref3[1];
    return Object.defineProperty(Date.prototype, prop, {
      get: function() {
        return this["get" + meth]();
      },
      set: function(value) {
        return this["set" + meth](parseInt(value));
      }
    });
  });

  Object.defineProperty(Date.prototype, 'month', {
    get: function() {
      return this.getMonth() + 1;
    },
    set: function(value) {
      return this.setMonth(value - 1);
    }
  });

  /*
  --------------- /home/gdot/github/crystal/source/logger/logger.coffee--------------
  */


  window.Logger = Logging.Logger = (function() {

    Logger.DEBUG = 4;

    Logger.INFO = 3;

    Logger.WARN = 2;

    Logger.ERROR = 1;

    Logger.FATAL = 0;

    Logger.LOG = 4;

    function Logger(level) {
      if (level == null) {
        level = 4;
      }
      if (isNaN(parseInt(level))) {
        throw "Level must be Number";
      }
      this._level = parseInt(level).clamp(0, 4);
      this._timestamp = true;
    }

    Logger.prototype._format = function() {
      var args, line;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      line = "";
      if (this.timestamp) {
        line += "[" + new Date().format("%Y-%M-%D %H:%T") + "] ";
      }
      return line += args.map(function(arg) {
        return args.toString();
      }).join(",");
    };

    return Logger;

  })();

  Object.defineProperties(Logger.prototype, {
    timestamp: {
      set: function(value) {
        return this._timestamp = !!value;
      },
      get: function() {
        return this._timestamp;
      }
    },
    level: {
      set: function(value) {
        return this._level = parseInt(value).clamp(0, 4);
      },
      get: function() {
        return this._level;
      }
    }
  });

  ['debug', 'log', 'error', 'fatal', 'info', 'warn'].forEach(function(type) {
    Logger.prototype["_" + type] = function() {};
    return Logger.prototype[type] = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (this.level >= Logger[type.toUpperCase()]) {
        return this["_" + type](this._format(args));
      }
    };
  });

  /*
  --------------- /home/gdot/github/crystal/source/logger/html-logger.coffee--------------
  */


  css = {
    error: {
      color: 'orangered'
    },
    info: {
      color: 'blue'
    },
    warn: {
      color: 'orange'
    },
    fatal: {
      color: 'red',
      'font-weight': 'bold'
    },
    debug: {
      color: 'black'
    },
    log: {
      color: 'black'
    }
  };

  window.HTMLLogger = Logging.HTMLLogger = (function(_super) {

    __extends(HTMLLogger, _super);

    function HTMLLogger(el, level) {
      if (!(el instanceof HTMLElement)) {
        throw "Base Element must be HTMLElement";
      }
      HTMLLogger.__super__.constructor.call(this, level);
      this.el = el;
    }

    return HTMLLogger;

  })(Logging.Logger);

  ['debug', 'error', 'fatal', 'info', 'warn', 'log'].forEach(function(type) {
    return HTMLLogger.prototype["_" + type] = function(text) {
      var el, prop, _ref3;
      el = Element.create('div.' + type);
      _ref3 = css[type];
      for (prop in _ref3) {
        value = _ref3[prop];
        el.css(prop, value);
      }
      el.text = text;
      this.el.append(el);
      return el;
    };
  });

  /*
  --------------- /home/gdot/github/crystal/source/logger/console-logger.coffee--------------
  */


  window.ConsoleLogger = Logging.ConsoleLogger = (function(_super) {

    __extends(ConsoleLogger, _super);

    function ConsoleLogger() {
      return ConsoleLogger.__super__.constructor.apply(this, arguments);
    }

    return ConsoleLogger;

  })(Logging.Logger);

  ({
    constructor: function() {
      return constructor.__super__.constructor.apply(this, arguments);
    }
  });

  ['debug', 'error', 'fatal', 'info', 'warn'].forEach(function(type) {
    return ConsoleLogger.prototype["_" + type] = function(text) {
      if (type === 'debug') {
        type = 'log';
      }
      if (type === 'fatal') {
        type = 'error';
      }
      return console[type](text);
    };
  });

  /*
  --------------- /home/gdot/github/crystal/source/logger/flash-logger.coffee--------------
  */


  window.FlashLogger = Logging.FlashLogger = (function(_super) {

    __extends(FlashLogger, _super);

    function FlashLogger(el, level) {
      if (!(el instanceof HTMLElement)) {
        throw "Base Element must be HTMLElement";
      }
      FlashLogger.__super__.constructor.call(this, level);
      this.visible = false;
      this.el = el;
    }

    FlashLogger.prototype.hide = function() {
      var _this = this;
      clearTimeout(this.id);
      return this.id = setTimeout(function() {
        _this.visible = false;
        _this.el.classList.toggle('hidden');
        return _this.el.classList.toggle('visible');
      }, 2000);
    };

    return FlashLogger;

  })(Logging.Logger);

  ['debug', 'error', 'fatal', 'info', 'warn', 'log'].forEach(function(type) {
    return FlashLogger.prototype["_" + type] = function(text) {
      if (this.visible) {
        this.el.html += "</br>" + text;
        return this.hide();
      } else {
        this.el.text = text;
        this.el.classList.toggle('hidden');
        this.el.classList.toggle('visible');
        this.visible = true;
        return this.hide();
      }
    };
  });

}).call(this);
 
 })(window.Crystal={Utils:{}})