html = "<%= escape_javascript(render partial: 'transaction', 
                                    locals: { transactions: @transactions, \
                                              date:         t('.date'), \
                                              category:     t('.category'),\
                                              debit:        t('.debit'), \
                                              credit:       t('.credit'), \
                                              balance:      t('.balance'), \
                                              comment:      t('.comment') }) %>"
$("#listing").append(html)