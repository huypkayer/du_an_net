import React, { useEffect, useRef } from "react";
import { Chart, registerables } from "chart.js";
import styles from "./dashboard.module.css"; // Nhập CSS Module

// Đăng ký các thành phần cần thiết cho Chart.js
Chart.register(...registerables);

const Admin = () => {
  const chartRef = useRef(null);
  const chartInstance = useRef(null);

  useEffect(() => {
    // Hủy bỏ biểu đồ cũ nếu có
    if (chartInstance.current) {
      chartInstance.current.destroy();
    }

    // Khởi tạo biểu đồ mới
    const ctx = chartRef.current.getContext("2d");
    chartInstance.current = new Chart(ctx, {
      type: "line",
      data: {
        labels: [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
        ],
        datasets: [
          {
            label: "Unique Visitors",
            data: [10, 20, 30, 40, 50, 60, 70],
            borderColor: "rgba(75, 192, 192, 1)",
            backgroundColor: "rgba(75, 192, 192, 0.2)",
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "top",
          },
          tooltip: {
            callbacks: {
              label: function (context) {
                return context.dataset.label + ": " + context.parsed.y;
              },
            },
          },
        },
        scales: {
          y: {
            beginAtZero: true,
          },
        },
      },
    });

    // Cleanup on component unmount
    return () => {
      if (chartInstance.current) {
        chartInstance.current.destroy();
      }
    };
  }, []);

  return (
    <div className={styles.mainContent}>
      <header>
        <h1>Dashboard</h1>
      </header>
      <main>
        <section className={styles.cards}>
          <div className={styles.card}>
            <h2>Products Sold</h2>
            <p>
              57{" "}
              <span className={styles.percentage}>
                12% <i className="material-icons">arrow_upward</i>
              </span>
            </p>
          </div>
          <div className={styles.card}>
            <h2>Gross Profit</h2>
            <p>
              $457{" "}
              <span className={styles.percentage}>
                12% <i className="material-icons">arrow_downward</i>
              </span>
            </p>
          </div>
          <div className={styles.card}>
            <h2>New Customers</h2>
            <p>
              125{" "}
              <span className={styles.percentage}>
                9% <i className="material-icons">arrow_downward</i>
              </span>
            </p>
          </div>
        </section>
        <section className={styles.charts}>
          <div className={styles.chart}>
            <h2>Unique Visitors Graph</h2>
            <canvas ref={chartRef} id="visitorsChart"></canvas>
          </div>
        </section>
        <section className={styles.orders}>
          <h2>New Orders</h2>
          <table>
            <thead>
              <tr>
                <th>Customer Name</th>
                <th>Products Ordered</th>
                <th>Status</th>
                <th>Order Total</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>John Mayers</td>
                <td>5 more</td>
                <td>
                  <span className={`${styles.status} ${styles.delivered}`}>
                    Delivered
                  </span>
                </td>
                <td>$354</td>
              </tr>
              <tr>
                <td>Kelly Brans</td>
                <td>2 more</td>
                <td>
                  <span className={`${styles.status} ${styles.pending}`}>
                    Pending
                  </span>
                </td>
                <td>$94</td>
              </tr>
              <tr>
                <td>Tim Howard</td>
                <td>3 more</td>
                <td>
                  <span className={`${styles.status} ${styles.delivered}`}>
                    Delivered
                  </span>
                </td>
                <td>$156</td>
              </tr>
              <tr>
                <td>Joe Trulli</td>
                <td>2 more</td>
                <td>
                  <span className={`${styles.status} ${styles.cancelled}`}>
                    Cancelled
                  </span>
                </td>
                <td>$1,120</td>
              </tr>
            </tbody>
          </table>
        </section>
      </main>
    </div>
  );
};

export default Admin;
