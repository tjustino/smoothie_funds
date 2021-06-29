once_ready(function(){
  if (document.getElementById("amount-slider") !== null ) {
    var amountSlider = document.getElementById("amount-slider");
    var amountSliderDataset = amountSlider.dataset;

    noUiSlider.create(amountSlider, {
      connect: true,
      tooltips: [true, true],
      start: [parseFloat(amountSliderDataset.minAmount), parseFloat(amountSliderDataset.maxAmount)],
      range: {
        'min': [parseFloat(amountSliderDataset.minAmount)],
        'max': [parseFloat(amountSliderDataset.maxAmount)]
      },
      format: wNumb({
        suffix: amountSliderDataset.suffixAmount,
        decimals: amountSliderDataset.decimalsAmount,
        mark: amountSliderDataset.markAmount,
        thousand: amountSliderDataset.thousandAmount
      })
    });

    amountSlider.noUiSlider.on('change', function() {
      amounts = amountSlider.noUiSlider.get(true);
      document.getElementById("min-amount").value = amounts[0];
      document.getElementById("max-amount").value = amounts[amounts.length - 1];
    });
  }
});