// Sidebar.js
import React from "react";
import styles from "./sidebar.module.css"; 

const Sidebar = () => {
  return (
    <div className={styles.sidebar}>
      <div className={styles.sidebarHeader}>
        <h3>Shop Giày</h3>
        <div className={styles.userInfo}>
          <img src="./img/avatat.jpg" alt="User" className={styles.userImg} />
          <p>
            ADMIN
            <br />
            <small>Administrator</small>
          </p>
        </div>
      </div>
      <ul className={styles.sidebarMenu}>
        <li>
          <a href="./admin">Dashboard</a>
        </li>
        <li>
          <a href="./addnv">Quản lí nhân viên</a>
        </li>
        <li>
          <a href="./addsp">Quản lí sản phẩm</a>
        </li>
      </ul>
    </div>
  );
};

export default Sidebar;
