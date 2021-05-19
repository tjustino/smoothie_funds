import { once_ready } from "./once_ready";
import Chart from "chart.js";

once_ready(function(){
  var ctx=document.getElementById("lineChart#{index}").getContext("2d");
  var options= { responsive: true, maintainAspectRatio: false };
  new Chart(ctx, {
    type: "line",
    data: {
      labels: #{ raw dates_before_past_time(account, @transactions) },
      datasets: [ {
        label: "#{ t('.balance') }",
        fill: true,
        backgroundColor: "rgba(75,192,192,0.4)",
        borderColor: "rgba(75,192,192,1)",
        data: #{ raw past_data(account, @transactions) }}]},
    options: { scales: { yAxes: [ { ticks: { beginAtZero:true }}]}}
  });
});
