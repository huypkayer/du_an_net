import React, { useState } from 'react';
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';
import "./signin.css";

function Signin() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const response = await axios.post('http://localhost:5179/api/Users/login', {
        email,
        password,
      });

      const user = response.data;
      if (!user.UserId) {
        throw new Error('Không có UserId trong phản hồi');
      }

      localStorage.setItem('UserId', user.UserId);

      const userDetailsResponse = await axios.get(`http://localhost:5179/api/Users/${user.UserId}`);
      const userDetails = userDetailsResponse.data;

      localStorage.setItem('user', JSON.stringify({
        userId: userDetails.UserId,
        username: userDetails.Username,
        role: userDetails.Role,
        avatarUrl: userDetails.AvatarUrl,
      }));

      setMessage('Đăng nhập thành công!');
      navigate(userDetails.Role === 'Admin' ? '/admin' : '/');
    } catch (error) {
      const errorMessage = error.response?.status === 401
        ? 'Đăng nhập thất bại: Email hoặc mật khẩu không chính xác.'
        : 'Đăng nhập thất bại: ' + (error.response?.data?.message || error.message);
      setMessage(errorMessage);
    }
  };

  const handleForgotPassword = () => {
    alert('Chức năng quên UserID/Mật khẩu đang được phát triển.');
  };

  return (
    <div className="signin">
      <div className="container">
        <div className="login-form">
          <h1>Đăng Nhập</h1>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label htmlFor="email">Địa chỉ Email</label>
              <input
                type="email"
                id="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Vui lòng nhập địa chỉ email của bạn"
                required
              />
            </div>
            <div className="form-group">
              <label htmlFor="password">Mật khẩu</label>
              <input
                type="password"
                id="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Vui lòng nhập mật khẩu của bạn"
                required
              />
            </div>
            <Link to="#" className="forgot-password" onClick={handleForgotPassword}>
              Quên UserID/Mật khẩu
            </Link>
            <button type="submit">Đăng Nhập</button>
          </form>
          {message && <p className="message">{message}</p>}
        </div>
        <div className="register-prompt">
          <p>Chưa đăng ký thành viên?</p>
          <Link to="/signup" className="register-button">
            Đăng ký thành viên mới (Miễn phí)
          </Link>
        </div>
      </div>
    </div>
  );
}

export default Signin;
