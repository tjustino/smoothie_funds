import Chart from "chart.js/auto";
import wNumb from "wnumb";

function hexToRGB(hex, alpha) {
  var r = parseInt(hex.slice(1, 3), 16);
  var g = parseInt(hex.slice(3, 5), 16);
  var b = parseInt(hex.slice(5, 7), 16);

  if (alpha) {
    return "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")";
  } else {
    return "rgb(" + r + ", " + g + ", " + b + ")";
  }
}

if (document.querySelectorAll(".accordion-item.line-chart") !== null ) {
  var successColor = getComputedStyle(document.querySelector(":root")).getPropertyValue("--bs-success").replace(" ", "");
  var lineCharts = document.querySelectorAll(".accordion-item.line-chart");

  for (var index = 0; index < lineCharts.length; index++) {
    var lineChart = document.getElementById("lineChart" + index)

    var yAxeFormat = wNumb({
      mark: lineChart.dataset.mark,
      thousand: lineChart.dataset.thousand,
      suffix: lineChart.dataset.suffix
    });

    var tooltipFormat = wNumb({
      decimals: lineChart.dataset.decimals,
      mark: lineChart.dataset.mark,
      thousand: lineChart.dataset.thousand,
      suffix: lineChart.dataset.suffix
    });

    // const below_zero = (ctx, value) => ctx.p1.parsed.y < 0 ? value : undefined;

    new Chart(lineChart, {
      type: "line",
      data: {
        labels: document.getElementById("labels" + index).value.split(","),
        datasets: [{
          label: lineChart.dataset.label,
          data: document.getElementById("data" + index).value.split(","),
          fill: true,
          backgroundColor: hexToRGB(successColor, 0.4),
          borderColor: hexToRGB(successColor),
          // segment: {
          //   borderColor: lineChart => below_zero(lineChart, '#f44336'),
          //   backgroundColor: lineChart => below_zero(lineChart, '#f44336')
          // }
        }]
      },
      options: {
        plugins: {
          legend: {
            position: 'bottom'
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                var label = context.dataset.label || '';
                if (label) {
                  label += ': ';
                }
                if (context.parsed.y !== null) {
                  label += tooltipFormat.to(context.parsed.y);
                }
                return label;
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value, index, values) {
                return yAxeFormat.to(value);
              }
            }
          }
        }
      }
    });
  }
};
