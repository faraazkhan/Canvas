(function() {
  var $;
  $ = jQuery;
  $.fn.kyleMenu = function(options) {
    return this.each(function() {
      var $menu, opts;
      opts = $.extend(true, {}, $.fn.kyleMenu.defaults, options);
      if (!opts.noButton) {
        $(this).button(opts.buttonOpts);
      }
      $menu = $(this).next().menu(opts.menuOpts).popup(opts.popupOpts).addClass("ui-kyle-menu use-css-transitions-for-show-hide");
      return $menu.bind("menuselect", function() {
        return $(this).popup('close').removeClass("ui-state-open");
      });
    });
  };
  $.fn.kyleMenu.defaults = {
    popupOpts: {
      position: {
        my: 'center top',
        at: 'center bottom',
        offset: '0 10px',
        within: '#main',
        collision: 'fit'
      },
      open: function(event) {
        var $trigger, actualOffset, caratOffset, differenceInOffset, triggerWidth;
        $(this).find(".ui-menu-carat").remove();
        $trigger = $(this).popup("option", "trigger");
        triggerWidth = $trigger.width();
        differenceInOffset = $trigger.offset().left - $(this).offset().left;
        actualOffset = event.pageX - $trigger.offset().left;
        caratOffset = Math.min(Math.max(20, actualOffset), triggerWidth - 20) + differenceInOffset;
        $('<span class="ui-menu-carat"><span /></span>').css('left', caratOffset).prependTo(this);
        return $(this).css('-webkit-transform-origin-x', caratOffset + 'px').addClass('ui-state-open');
      },
      close: function() {
        return $(this).removeClass("ui-state-open");
      }
    },
    buttonOpts: {
      icons: {
        primary: "ui-icon-home",
        secondary: "ui-icon-droparrow"
      }
    }
  };
}).call(this);
