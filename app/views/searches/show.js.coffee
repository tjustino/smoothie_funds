html = "<%= escape_javascript(render partial: 'transaction', 
                                    locals: { transactions: @transactions,
                                              account:      t('.account'),
                                              date:         t('.date'),
                                              category:     t('.category'),
                                              debit:        t('.debit'),
                                              credit:       t('.credit'),
                                              comment:      t('.comment') }) %>"
$("#listing").append(html)
