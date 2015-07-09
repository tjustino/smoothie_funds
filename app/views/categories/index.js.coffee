html = "<%= escape_javascript(render partial: 'category', locals: { categories: @categories }) %>"
$("tbody").append(html)