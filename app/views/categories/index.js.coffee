html = "<%= escape_javascript(render partial: 'category', 
                                          locals: { categories: @categories,
                                                    name:       t('.name'),
                                                    use:        t('.use') }) %>"
$("#listing").append(html)