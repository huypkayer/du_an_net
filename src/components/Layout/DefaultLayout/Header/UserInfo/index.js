import React from 'react';
import { useNavigate } from 'react-router-dom';
import './userinfo.css';

function UserInfo({ user, onLogout }) {
  const navigate = useNavigate();

  const handleProfileClick = () => {
    navigate('/profile');
  };

  return (
    <div className="user-info signin">
      <img 
        src={user.avatarUrl || './img/icon/avatar-user-svgrepo-com.svg'} 
        alt="avatar" 
        className="avatar_icon" 
        onClick={handleProfileClick}
      />
      <p 
        className="account_text" 
        onClick={handleProfileClick} 
      >
        {user.username || 'user'}
      </p>
      {user.role !== 'User' && (
        <button onClick={() => navigate('/admin')}>Admin</button>
      )}
      <button onClick={onLogout}>Đăng xuất</button>
    </div>
  );
}

export default UserInfo;
