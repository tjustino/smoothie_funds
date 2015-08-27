html = "<%= escape_javascript(render partial: 'transaction', locals: { transactions: @transactions }) %>"
$("tbody").append(html)