html = "<%= escape_javascript(render partial: 'schedule', 
                                      locals: { schedules:  @schedules,
                                                next_time:  t('.next_time'),
                                                frequency:  t('.frequency'),
                                                category:   t('.category'),
                                                amount:     t('.amount'),
                                                comment:    t('.comment') }) %>"
$("#listing").append(html)