import React from 'react';
import { Link } from 'react-router-dom'; // Thêm nhập khẩu Link

function LoginComponent() {
  return (
    <div className="signin">
      <Link to="/signin">
        <img src="./img/icon/avatar-user-svgrepo-com.svg" alt="avatar" className="avatar_icon" />
        <p className="account_text">Tài Khoản</p>
      </Link>
    </div>
  );
}

export default LoginComponent;

