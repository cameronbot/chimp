$(document).ready(function() {
  renderTags();

  $('#report')
    .sortable({
      axis: 'y',
      update: function() {
        $.post($(this).data('sort-update-url'), $(this).sortable('serialize'));
        renderTags();
      }
    })
    .on("mousedown", ".article", function(e) {
      $(this).css({
        'box-shadow': '4px 4px 4px #a5a5a5',
        'background': '#fff'
      });
    })
    .on("mouseup", ".article", function(e) {
      $(this).css({ 'box-shadow': '', 'background': '' });
    })

});

function renderTags() {
  var prevTags = "";

  $('.article').each(function() {
    var $tagEl = $(this).find('.tag');

    if(!prevTags) {
      $tagEl.show();
      prevTags = $tagEl.text();
      return;
    }

    if(prevTags == $tagEl.text()) {
      $tagEl.hide();
    } else {
      prevTags = $tagEl.text();
    }
  });
}
