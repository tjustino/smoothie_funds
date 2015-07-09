html = "<%= escape_javascript(render partial: 'schedule', locals: { schedules: @schedules }) %>"
$("tbody").append(html)