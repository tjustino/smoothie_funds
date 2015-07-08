html = "<%= escape_javascript(render partial: 'account', locals: { accounts: @accounts }) %>"
$("tbody").append(html)
