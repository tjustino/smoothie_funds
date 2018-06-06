html = "<%= escape_javascript(render partial: 'account', 
                                     locals: { accounts: @accounts,
                                               name:     t('.name'),
                                               init_bal: t('.initial_balance'),
                                               share:    t('.share') }) %>"
$("#listing").append(html)
