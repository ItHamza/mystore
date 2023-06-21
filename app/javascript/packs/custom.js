import $ from 'jquery'
$(document).on('turbolinks:load', function () {
  window.addEventListener('DOMContentLoaded', function () {
    // Random monthly revenue data
    var revenueData = [
      { month: 'January', revenue: Math.floor(Math.random() * 1000) },
      { month: 'February', revenue: Math.floor(Math.random() * 1000) },
      { month: 'March', revenue: Math.floor(Math.random() * 1000) },
      { month: 'April', revenue: Math.floor(Math.random() * 1000) },
      { month: 'May', revenue: Math.floor(Math.random() * 1000) },
      { month: 'June', revenue: Math.floor(Math.random() * 1000) }
    ];

    var chartContainer = document.getElementById('chart');
    var chartWidth = chartContainer.clientWidth;
    var chartHeight = chartContainer.clientHeight;

    // Set chart dimensions
    chartContainer.setAttribute('width', chartWidth);
    chartContainer.setAttribute('height', chartHeight);

    // Calculate maximum revenue value
    var maxRevenue = Math.max(...revenueData.map(item => item.revenue));

    // Calculate bar width
    var barWidth = chartWidth / revenueData.length;

    // Create the bars
    revenueData.forEach(function (item, index) {
      var barHeight = (item.revenue / maxRevenue) * chartHeight;
      var x = index * barWidth;
      var y = chartHeight - barHeight;

      var rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      rect.setAttribute('x', x);
      rect.setAttribute('y', y);
      rect.setAttribute('width', barWidth);
      rect.setAttribute('height', barHeight);
      rect.classList.add('bar');

      chartContainer.appendChild(rect);
    });
  });

});

// Preloader JS
$(window).on('turbolinks:load', function () {
  $('.preloader').fadeOut();
});

$(document).on('turbolinks:click', function () {
  $('.cover-spin, .loading').removeClass('d-none')
});

$(document).on('turbolinks:load', function () {
  $('.cover-spin, .loading').addClass('d-none')
});

$(document).on('turbolinks:render', function () {
  $('.cover-spin, .loading').addClass('d-none')
});