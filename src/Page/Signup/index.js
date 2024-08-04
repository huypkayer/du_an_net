import axios from 'axios';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './signup.css';

function Signup() {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (password !== confirmPassword) {
      alert("Mật khẩu và mật khẩu xác nhận không khớp.");
      return;
    }

    try {
      const newUser = { Username: username, Email: email, Password: password };
      const response = await axios.post('http://localhost:5179/api/Users/register', newUser);
      console.log('Đăng ký thành công:', response.data);
      
      navigate('/signin');

    } catch (error) {
      console.error('Đăng ký không thành công:', error.response ? error.response.data : error.message);
    }
  };

  return (
    <div className='signup'>
    <div className="container">
      <div className="register-form">
        <h1>Đăng Ký</h1>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="username">Tên đăng nhập</label>
            <input
              type="text"
              id="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Vui lòng nhập tên đăng nhập của bạn"
              required
            />
          </div>
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
          <div className="form-group">
            <label htmlFor="confirmPassword">Nhập lại mật khẩu</label>
            <input
              type="password"
              id="confirmPassword"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              placeholder="Vui lòng nhập lại mật khẩu của bạn"
              required
            />
          </div>
          <button type="submit">Đăng Ký</button>
        </form>
      </div>
    </div>
    </div>
  );
}

export default Signup;
