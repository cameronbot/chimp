// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$(document).ready(function () {
  $('#articles')
    .on("click", "tbody tr", function(e) {
      $(this).find('input[type=checkbox]').each(function() {
        if($(this).is(":checked")) {
          $(this).prop("checked", false);
        } else {
          $(this).prop("checked", true);
        }
      });
    })
    .on("click", "input[type=checkbox]", function(e) {
      e.stopPropagation();
    })
    .on("click", "a", function(e) {
      e.stopPropagation();
    })
    .on("mouseup", "#select-all", function(e) {
      var checked = $(this).is(':checked') ? false : true;

      $("#articles tbody").find('input[type=checkbox]').prop("checked", checked);
    });

  $('#open-iframe').on('click', function(e) {
    e.preventDefault();

    $('body').append('<iframe id="article-iframe" src="' + $(this).data('url') + '"></iframe>');
    $('#article-form').toggleClass('article-form').draggable();
  });

  $('#article-form').toggleClass('article-form').draggable();

  $('#article-form')
    .on('focus', 'input', function(e) {

      var $this = $(this);

      $('.auto-format', '#article-form').hide();
      if($this.siblings('.auto-format').length) {
        $this.css('display','block').next('.auto-format').show();
      }

    })
    .on('blur', 'input', function(e) {
      $(this).css('display','');
    })
    .on('click', '.auto-format', function(e) {
      e.preventDefault();
      var target = $(this).data('target'),
          value = $(target).val();

      $(target).val(value.toSentenceCase()).trigger('focus');
    })
    .find('.references span').each(function(index) {
      $(this).delay((index+1) * 400).fadeIn();
    });

  $("[data-toggle=popover]").popover();
  $('#article-tag-list').typeahead({
    source: function (query, process) {
      var index = query.lastIndexOf(','),
          temp = query;
      temp = (index > 1) ? temp.substring(index+1).trim() : query;
      query = (temp.length > 0) ? temp : query;
      return $.get('/tags?context=tags', { query: query }, function (data) {
          return process(data);
      });
    },
    matcher: function(item) {
      var index = this.query.lastIndexOf(','),
          temp = this.query,
          this_query = this.query;

      this.stash = temp.substring(0, index);

      temp = (index > 1) ? temp.substring(index+1).trim() : this_query;
      this_query = (temp.length > 0) ? temp : this_query;

      console.log(item, this_query);

      return ~item.toLowerCase().indexOf(this_query.toLowerCase())
    },
    updater: function(item) {
      if(this.stash && this.stash.length > 0) {
        this.stash += ", ";
      }
      this.stash += item;
      return this.stash;
    }
  });
});


if (typeof String.prototype.trim != 'function') {
  String.prototype.trim = function () {
    return this.replace(/^\s+/, '').replace(/\s+$/, '');
  };
}

if (typeof String.prototype.toSentenceCase != 'function') {
  String.prototype.toSentenceCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
  };
}
