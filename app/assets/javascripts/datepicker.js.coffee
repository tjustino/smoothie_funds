//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.fr.js

$ ->
  $(".datepicker").datepicker
    language:               "fr"
    todayBtn:               "linked"
    autoclose:              true
    # todayHighlight:         true
    # daysOfWeekHighlighted:  "0,6"
