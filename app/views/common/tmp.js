/ expects "function" as a local variable which is the PeriodicFunction object
$(function () {
  $('##{function.id}').highcharts({
    title: {
      text: '#{function.class.name} #{function.id}',
      x: -20 //center
    },
    series: [{data: [#{function.data.to_json}]}]
  });
});
