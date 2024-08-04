// Admin.js
import React, { useEffect } from "react";
import Sidebar from "../../components/Sidebar";
import Chart from "chart.js/auto";
import styles from "./admin.module.css"; // Import CSS module

const Admin = () => {
  useEffect(() => {
    const canvas = document.getElementById("visitorsChart");
    const ctx = canvas.getContext("2d");

    if (canvas.chartInstance) {
      canvas.chartInstance.destroy();
    }

    const visitorsChart = new Chart(ctx, {
      type: "line",
      data: {
        labels: ["1", "5", "10", "15", "20", "25", "30", "35"],
        datasets: [
          {
            label: "Unique Visitors",
            data: [1200, 1400, 1500, 1700, 1800, 1900, 2000, 2100],
            borderColor: "#1E88E5",
            fill: false,
            tension: 0.1,
          },
        ],
      },
      options: {
        scales: {
          x: {
            beginAtZero: true,
          },
          y: {
            beginAtZero: true,
          },
        },
      },
    });

    canvas.chartInstance = visitorsChart;

    return () => {
      if (canvas.chartInstance) {
        canvas.chartInstance.destroy();
      }
    };
  }, []);

  return (
    <div className={styles.admin}>
      <Sidebar />
      <div className={styles.mainContent}>
        <header>
          <h1>Dashboard</h1>
        </header>
        <main>
          <section className={styles.cards}>
            <div className={styles.card}>
              <h2>Products Sold</h2>
              <p>
                57
                <span className={styles.percentage}>
                  12% <i className="material-icons">arrow_upward</i>
                </span>
              </p>
            </div>
            <div className={styles.card}>
              <h2>Gross Profit</h2>
              <p>
                $457
                <span className={styles.percentage}>
                  12% <i className="material-icons">arrow_downward</i>
                </span>
              </p>
            </div>
            <div className={styles.card}>
              <h2>New Customers</h2>
              <p>
                125
                <span className={styles.percentage}>
                  9% <i className="material-icons">arrow_downward</i>
                </span>
              </p>
            </div>
          </section>
          <section className={styles.charts}>
            <div className={styles.chart}>
              <h2>Unique Visitors Graph</h2>
              <canvas id="visitorsChart"></canvas>
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
    </div>
  );
};

export default Admin;
