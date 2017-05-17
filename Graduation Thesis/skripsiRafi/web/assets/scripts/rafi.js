var $jq = jQuery.noConflict();
var lastData = 0;

var chartEcg;

function cekData() {
	$jq.ajax({
		url : 'http://localhost/ta/get/id/',
		success : function(point) {
			var now = parseInt(point[0]);
			if ((now > lastData)){
				lastData = now;
				requestEcg();
			}

			setTimeout(cekData, 100);
		},
		cache : false
	});
}

function requestEcg() {
	$jq.ajax({
		url : 'http://localhost/ta/get/rawPulse/',
		success : function(point) {

			var series = chartEcg.series[0],
			    shift = series.data.length > 25;

			var x = (new Date()).getTime(), // current time
			    y = parseInt(point[0]);

			chartEcg.series[0].addPoint([x, y], true, shift);
		},
		cache : false
	});
}


$jq(document).ready(function() {

	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});

	cekData();

	chartEcg = new Highcharts.Chart({
		chart : {
			renderTo : 'ecgChart',
			type : 'spline',
			animation : Highcharts.svg, // don't animate in old IE
			marginRight : 10,
			events : {}
		},
		title : {
			text : 'ECG'
		},
		subtitle : {
			text : 'Rafi Kurnia Putra'
		},
		xAxis : {
			type : 'datetime',
			tickPixelInterval : 100
		},
		yAxis : {
			//min : 0,
			//max : 4095,
			tickInterval: 200,
			title : {
				text : 'ECG'
			},
			labels : {
				formatter : function() {
					return this.value;
				}
			},
			plotLines : [{
				value : 0,
				width : 1,
				color : '#808080'
			}]
		},
		tooltip : {
			formatter : function() {
				return '<b>' + Highcharts.numberFormat(this.y, 2) + '</b><br/>' + Highcharts.dateFormat('%H:%M:%S', this.x) + '<br>' + Highcharts.dateFormat('%d-%m-%Y', this.x);
			}
		},
		legend : {
			enabled : false
		},
		exporting : {
			enabled : false
		},
		series : [{
			name : 'ECG',
			color : 'white',
			data : []
		}]
	});
});
