$("#check_<%= @transaction.id %> > i").toggleClass("fa-square-o fa-check-square-o")

html = "<%= escape_javascript(render partial: 'sum_checked', locals: { sum_checked: @sum_checked }) %>"
$("p#sum_checked").replaceWith(html)