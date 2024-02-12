import { Controller } from "@hotwired/stimulus"

import wNumb from "wnumb"
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)

function hexToRGB(hex, alpha) {
  var r = parseInt(hex.slice(1, 3), 16)
  var g = parseInt(hex.slice(3, 5), 16)
  var b = parseInt(hex.slice(5, 7), 16)

  if (alpha) {
    return "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")"
  } else {
    return "rgb(" + r + ", " + g + ", " + b + ")"
  }
}

export default class extends Controller {
  static targets = [ "labels", "data" ]

  connect() {
    var positiveColour = "#7EC9A8"
    var negativeColour = "#F44336"
    var lineChart = this.element
  
    var yAxeFormat = wNumb({
      mark: lineChart.dataset.mark,
      thousand: lineChart.dataset.thousand,
      suffix: lineChart.dataset.suffix
    })
  
    var tooltipFormat = wNumb({
      decimals: lineChart.dataset.decimals,
      mark: lineChart.dataset.mark,
      thousand: lineChart.dataset.thousand,
      suffix: lineChart.dataset.suffix
    })
  
    new Chart(lineChart, {
      type: "line",
      data: {
        labels: this.labelsTarget.value.split(";"),
        datasets: [{
          label: lineChart.dataset.label,
          data: this.dataTarget.value.split(";"),
          fill: {
            target: "origin",
            above: hexToRGB(positiveColour, 0.5),
            below: hexToRGB(negativeColour, 0.5)
          },
          borderColor: hexToRGB("#D7D7D7"),
          tension: 0.2
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value, index, values) {
                return yAxeFormat.to(value)
              }
            }
          }
        },
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            displayColors: false,
            callbacks: {
              label: function(context) {
                var label = context.dataset.label || ''
                if (label) {
                  label += ': '
                }
                if (context.parsed.y !== null) {
                  label += tooltipFormat.to(context.parsed.y)
                }
                return label
              }
            }
          }
        }
      }
    })
  }
}
