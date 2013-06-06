bone.modules.textsearch = function(options) {
  var module;

  module = {};
  module.IO = bone.io('textsearch', {
    inbound: {
      results: function(data, context) {
        return module.View(context.view.id).render(data);
      }
    },
    outbound: {
      shortcuts: ['search']
    }
  });
  module.View = bone.view('[data-ui="textsearch"]', {
    events: {
      'focus': 'focus',
      'blur': 'blur',
      'keypress': 'keypress',
      'keyup': 'keyup',
      'keydown': 'keydown'
    },
    defaults: {
      menu: '<ul class="typeahead dropdown-menu"></ul>',
      item: '<li><a href="#"></a></li>',
      minLength: 1,
      items: 8
    },
    initialize: function() {
      this.options = $.extend({}, this.defaults);
      this.$menu = $(this.options.menu);
      this.shown = false;
      return this.$menu.on('click', $.proxy(this.click, this)).on('mouseenter', 'li', $.proxy(this.mouseenter, this)).on('mouseleave', 'li', $.proxy(this.mouseleave, this));
    },
    move: function(event) {
      if (!this.shown) {
        return;
      }
      switch (event.keyCode) {
        case 9:
        case 13:
        case 27:
          return event.preventDefault();
        case 38:
          event.preventDefault();
          return this.prev();
        case 40:
          event.preventDefault();
          return this.next();
      }
    },
    lookup: function() {
      this.lookupData = this.query = this.$el.val();
      if (this.options.lookup != null) {
        this.lookupData = this.options.lookup();
      }
      return module.IO.search(this.lookupData, {
        view: this
      });
    },
    keydown: function(event) {
      this.suppressKeyPressRepeat = ~$.inArray(event.keyCode, [40, 38, 9, 13, 27]);
      return this.move(event);
    },
    keypress: function(event) {
      if (this.supressKeyPressRepeat) {
        return;
      }
      return this.move(event);
    },
    keyup: function(event) {
      switch (event.keyCode) {
        case 40:
        case 38:
        case 16:
        case 17:
        case 18:
          break;
        case 9:
        case 13:
          if (!this.shown) {
            return;
          }
          this.select();
          break;
        case 27:
          if (!this.shown) {
            return;
          }
          break;
        default:
          this.lookup();
      }
      event.stopPropagation();
      return event.preventDefault();
    },
    focus: function(event) {
      return this.focused = true;
    },
    blur: function(event) {
      this.focused = false;
      if (!this.mousedover && this.shown) {
        return this.hide();
      }
    },
    click: function(event) {
      event.stopPropagation();
      event.preventDefault();
      this.select();
      return this.$el.focus();
    },
    mouseenter: function(event) {
      this.mousedover = true;
      this.$menu.find('.active').removeClass('active');
      return $(event.currentTarget).addClass('active');
    },
    mouseleave: function(event) {
      this.mousedover = false;
      if (!this.focused && this.shown) {
        return this.hide();
      }
    },
    show: function() {
      var pos;

      pos = $.extend({}, this.$el.position(), {
        height: this.$el[0].offsetHeight
      });
      this.$menu.insertAfter(this.$el).css({
        top: pos.top + pos.height,
        left: pos.left
      }).show();
      this.shown = true;
      return this;
    },
    select: function() {
      var val;

      val = this.$menu.find('.active').attr('data-value');
      this.$el.val(val).change();
      return this.hide();
    },
    hide: function() {
      this.$menu.hide();
      return this.shown = false;
    },
    highlighter: function(item) {
      var query;

      query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&");
      return item.replace(new RegExp("(" + query + ")", "ig"), function($1, match) {
        return "<strong>" + match + "</strong>";
      });
    },
    render: function(items) {
      var that,
        _this = this;

      items = items.slice(0, this.options.items);
      that = this;
      items = $(items).map(function(i, item) {
        i = $(_this.options.item).attr("data-value", item);
        i.find("a").html(_this.highlighter(item));
        return i[0];
      });
      items.first().addClass("active");
      this.$menu.html(items);
      return this.show();
    },
    next: function(event) {
      var active, next;

      active = this.$menu.find('.active').removeClass('active');
      next = active.next();
      if (!next.length) {
        next = $(this.$menu.find('li')[0]);
      }
      return next.addClass('active');
    },
    prev: function(event) {
      var active, prev;

      active = this.$menu.find('.active').removeClass('active');
      prev = active.prev();
      if (!prev.length) {
        prev = this.$menu.find('li').last();
      }
      return prev.addClass('active');
    }
  });
  return module;
};
