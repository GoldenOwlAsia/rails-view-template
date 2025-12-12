import merge from 'lodash/merge';
import randomColor from 'randomcolor';

export const colorThemes = {
  default: ['#6C27F8', '#C1C3A4', '#121113'],
};

export const generateColorList = (count, theme = 'default') => {
  const colorTheme = colorThemes[theme];
  const mainColorCount = colorTheme.length;

  if (count <= mainColorCount) {
    return colorTheme.slice(0, count);
  }

  return [
    ...colorTheme,
    ...randomColor({
      alpha: 0.85,
      format: 'rgba',
      count: count - mainColorCount,
      hue: 'blue',
    }),
  ];
};

export const generateBarChartOptions = (options = {}) => {
  return merge(
    {
      chart: {
        type: 'bar',
        height: 250,
        fontFamily: 'DM Sans, sans-serif',
        animations: {
          enabled: true,
          easing: 'easeinout',
          speed: 350,
          animateGradually: {
            enabled: true,
            delay: 150,
          },
          dynamicAnimation: {
            enabled: true,
            speed: 350,
          },
        },
        toolbar: {
          show: false,
        },
        zoom: {
          enabled: false,
        },
      },
      plotOptions: {
        bar: {
          columnWidth: '100%',
          distributed: true,
        },
      },
      dataLabels: {
        enabled: false,
      },
      tooltip: {
        enabled: false,
      },
      grid: {
        strokeDashArray: 4,
      },
      xaxis: {
        labels: {
          show: false,
        },
        tooltip: {
          enabled: false,
        },
        axisBorder: {
          show: false,
        },
      },
      yaxis: {
        opposite: false,
        labels: {
          padding: 4,
          show: true,
          formatter: function (val) {
            return val >= 1000 ? val / 1000 + 'k' : val;
          },
          style: {
            colors: '#6C6A6F',
            fontSize: '12px',
            fontFamily: 'DM Sans, sans-serif',
          },
        },
        forceNiceScale: false,
      },
      legend: {
        show: false,
      },
    },
    options,
  );
};

export const generateStackedBarChartOptions = (options = {}) => {
  return merge(
    {
      chart: {
        type: 'bar',
        height: 280,
        stacked: true,
        stackType: '100%',
        toolbar: {
          show: false,
        },
        zoom: {
          enabled: false,
        },
      },
      plotOptions: {
        bar: {
          horizontal: false,
          columnWidth: '80%',
          borderRadius: 2,
          borderRadiusApplication: 'end',
        },
      },
      dataLabels: {
        enabled: false,
      },
      grid: {
        borderColor: '#E8EAF1',
        strokeDashArray: 4,
        xaxis: {
          lines: {
            show: false,
          },
        },
      },
      xaxis: {
        labels: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
      },
      yaxis: {
        labels: {
          formatter: function (val) {
            return val + '%';
          },
          style: {
            colors: '#6C6A6F',
            fontSize: '12px',
            fontFamily: 'DM Sans',
          },
        },
      },
      legend: {
        show: false,
      },
      tooltip: {
        theme: 'light',
        style: {
          fontSize: '12px',
          fontFamily: 'DM Sans',
        },
        y: {
          formatter: function (val) {
            return val + '%';
          },
        },
      },
    },
    options,
  );
};

export const generateDonutChartOptions = (options = {}) => {
  return merge(
    {
      chart: {
        type: 'donut',
        height: 250,
        fontFamily: 'DM Sans, sans-serif',
        animations: {
          enabled: true,
          easing: 'easeinout',
          speed: 350,
          animateGradually: {
            enabled: true,
            delay: 150,
          },
          dynamicAnimation: {
            enabled: true,
            speed: 350,
          },
        },
      },
      stroke: {
        width: 0,
      },
      plotOptions: {
        pie: {
          donut: {
            size: '70%',
          },
          expandOnClick: true,
        },
      },
      dataLabels: {
        enabled: false,
      },
      legend: {
        show: false,
      },
      tooltip: {
        show: false,
      },
    },
    options,
  );
};

export const generateLineChartOptions = (options = {}) => {
  return merge(
    {
      chart: {
        height: 250,
        type: 'line',
        toolbar: {
          show: false,
        },
        zoom: {
          enabled: false,
        },
      },
      dataLabels: {
        enabled: false,
      },
      stroke: {
        curve: 'smooth',
        width: 2,
      },
      grid: {
        borderColor: '#E8EAF1',
        strokeDashArray: 4,
        xaxis: {
          lines: {
            show: false,
          },
        },
      },
      xaxis: {
        labels: {
          show: false,
          style: {
            colors: '#6C6A6F',
            fontSize: '12px',
            fontFamily: 'DM Sans',
          },
        },
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
      },
      yaxis: [
        {
          min: 0,
          max: 100,
          tickAmount: 4,
          labels: {
            formatter: (val) => val,
            style: {
              colors: '#6C6A6F',
              fontSize: '12px',
              fontFamily: 'DM Sans',
            },
          },
        },
        {
          opposite: true,
          min: 0,
          max: 100,
          tickAmount: 4,
          labels: {
            formatter: (val) => val,
            style: {
              colors: '#6C6A6F',
              fontSize: '12px',
              fontFamily: 'DM Sans',
            },
          },
        },
      ],
      legend: {
        show: false,
      },
      tooltip: {
        show: false,
      },
    },
    options,
  );
};

export const generateAreaChartOptions = (options) =>
  merge(
    {
      chart: {
        type: 'area',
        fontFamily: 'inherit',
        toolbar: {
          show: false,
        },
      },
      plotOptions: {
        bar: {
          columnWidth: '50%',
          borderRadius: 1,
          dataLabels: {
            position: 'top',
          },
        },
      },
      tooltip: {
        theme: 'dark',
      },
      grid: {
        padding: {
          top: -20,
          right: 0,
          left: -4,
          bottom: -4,
        },
        strokeDashArray: 1,
      },
      legend: {
        show: false,
      },
    },
    options,
  );
