//= require jquery-ui/datepicker
//= require jquery-ui/datepicker-fr

$ ->
  $(".datepicker").datepicker
    changeMonth:        true
    changeYear:         true
    showOtherMonths:    true
    selectOtherMonths:  true
    showButtonPanel:    true
  return