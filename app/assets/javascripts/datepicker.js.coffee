//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.fr.js

$ ->
  $(".datepicker").datepicker
    todayBtn:       "linked",
    language:       "fr",
    autoclose:      true,
    # daysOfWeekHighlighted: "0,6",
    todayHighlight: true
