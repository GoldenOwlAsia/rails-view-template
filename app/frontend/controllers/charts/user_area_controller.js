import { Controller } from '@hotwired/stimulus';
import ApexCharts from 'apexcharts';
import { generateColorList, generateAreaChartOptions } from '@/utils/chartBase';

export default class extends Controller {
  static values = {
    stats: {
      type: Array,
      default: [],
    },
  };

  static targets = ['render', 'input'];

  initialize() {
    this.chart = null;
  }

  connect() {
    this.renderChart();
  }

  disconnect() {
    this.destroyChart();
  }

  renderChart() {
    this.destroyChart();
    const series = [
      {
        name: 'Amount',
        data: this.statsValue,
      },
    ];

    const colors = generateColorList(1);
    const options = generateAreaChartOptions({
      series,
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      colors,
      yaxis: {
        labels: {
          show: false,
        },
      },
      chart: {
        height: 180,
        width: '100%',
        sparkline: {
          enabled: false,
        },
        offsetY: 10,
        zoom: {
          enabled: false,
        },
        toolbar: {
          show: false,
        },
      },
      responsive: [
        {
          breakpoint: 10000,
          options: {
            chart: {
              width: '100%',
            },
          },
        },
      ],
      dataLabels: {
        enabled: true,
        offsetY: -8,
        style: {
          fontSize: '9px',
          fontWeight: '500',
          colors: ['#6366F1'],
        },
        background: {
          enabled: true,
          foreColor: '#FFFFFF',
          borderRadius: 6,
          borderWidth: 0,
          borderColor: 'transparent',
          opacity: 0.95,
          dropShadow: {
            enabled: true,
            top: 2,
            left: 2,
            blur: 4,
            color: '#6366F1',
            opacity: 0.15,
          },
        },
        formatter: function (val) {
          return val > 0 ? val : '';
        },
      },
      tooltip: {
        enabled: true,
        theme: 'light',
        style: {
          fontSize: '12px',
          fontFamily: 'Inter, sans-serif',
        },
        marker: {
          show: true,
          fillColors: ['#6366F1'],
        },
      },
      xaxis: {
        labels: {
          show: true,
          style: {
            fontSize: '10px',
            fontWeight: '400',
            colors: '#9CA3AF',
          },
          offsetY: 5,
        },
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
        crosshairs: {
          show: false,
        },
      },
      grid: {
        show: true,
        borderColor: '#F1F5F9',
        strokeDashArray: 2,
        position: 'back',
        xaxis: {
          lines: {
            show: false,
          },
        },
        yaxis: {
          lines: {
            show: true,
          },
        },
        padding: {
          top: 0,
          bottom: 5,
          left: 0,
          right: 0,
        },
      },
      fill: {
        type: 'gradient',
        gradient: {
          shade: 'light',
          type: 'vertical',
          shadeIntensity: 0.25,
          gradientToColors: ['#A5B4FC'],
          inverseColors: false,
          opacityFrom: 0.6,
          opacityTo: 0.1,
        },
      },
    });

    this.chart = new ApexCharts(this.renderTarget, options);
    this.chart.render();
  }

  destroyChart() {
    if (this.chart) {
      this.chart.destroy();
      this.chart = null;
    }
  }
}
