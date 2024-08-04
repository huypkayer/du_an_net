import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import LoginComponent from './LoginComponent';
import UserInfo from './UserInfo';
import './header.css';
import Fuse from 'fuse.js';

const Header = ({ onSearch }) => {
  const [user, setUser] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [products, setProducts] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const userData = localStorage.getItem('user');
    if (userData) {
      try {
        setUser(JSON.parse(userData));
      } catch (e) {
        console.error('Lỗi khi phân tích dữ liệu người dùng:', e);
      }
    }

    fetch('/api/products')
      .then(response => response.json())
      .then(data => setProducts(data))
      .catch(error => console.error('Lỗi khi lấy dữ liệu sản phẩm:', error));
  }, []);

  const handleLogin = (userData) => {
    localStorage.setItem('user', JSON.stringify(userData));
    setUser(userData);
  };

  const handleLogout = () => {
    localStorage.removeItem('user');
    setUser(null);
    navigate('/'); 
  };

  const handleSearchChange = (e) => {
    setSearchQuery(e.target.value);
  };

  const handleSearchClick = () => {
    if (typeof onSearch !== 'function') {
      console.error('onSearch is not a function');
      return;
    }

    const fuse = new Fuse(products, {
      keys: ['name'],
      threshold: 0.3,
    });
    const results = fuse.search(searchQuery);
    const searchResults = results.map(result => result.item);
    onSearch(searchResults);
    navigate(`/search?query=${encodeURIComponent(searchQuery)}`);
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      handleSearchClick();
    }
  };

  return (
    <header className="header">
      <div className="container">
        <div className="header_inner">
          <div className="header_inner_left">
            <div className="logo">
              <img src="./img/icon/logo.svg" alt="logo" className="logo_img" />
              <p>SNEAKER SHOP</p>
            </div>
            <nav className="nav_bar">
              <ul className="navbar_list">
                <li className="navbar_item"><Link to="/" className="navbar_link">HOME</Link></li>
                <li className="navbar_item"><Link to="/nike" className="navbar_link">NIKE</Link></li>
                <li className="navbar_item"><Link to="/adidas" className="navbar_link">ADIDAS</Link></li>
                <li className="navbar_item"><Link to="/yeezy" className="navbar_link">YEEZY</Link></li>
                <li className="navbar_item"><Link to="/sale" className="navbar_link">SALE</Link></li>
              </ul>
            </nav>
          </div>
          <div className="format">
            <div className="search">
              <input 
                type="text" 
                placeholder="Tìm kiếm" 
                value={searchQuery} 
                onChange={handleSearchChange} 
                onKeyDown={handleKeyDown}
              />
              <button onClick={handleSearchClick} className="search-button">
                <i className="fa-solid fa-magnifying-glass"></i>
              </button>
            </div>
            <div className="top_cart">
              <Link to="/cart" className="link_cart">
                <img src="./img/icon/Buy.svg" alt="cart" className="cart_icon" />
              </Link>
            </div>
            <div className="auth_section">
              {user ? (
                <UserInfo user={user} onLogout={handleLogout} />
              ) : (
                <LoginComponent onLogin={handleLogin} />
              )}
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
