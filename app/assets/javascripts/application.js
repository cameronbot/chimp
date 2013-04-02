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
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$(document).ready(function () {
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


if (typeof String.prototype.trim != 'function') { // detect native implementation
  String.prototype.trim = function () {
    return this.replace(/^\s+/, '').replace(/\s+$/, '');
  };
}
