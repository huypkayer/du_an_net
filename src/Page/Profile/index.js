  import React, { useState, useEffect } from 'react';
  import axios from 'axios';
  import './profile.css';

  const Profile = () => {
    const [profile, setProfile] = useState({
      username: '',
      email: '',
      phonenumber: '',
      gender: 'other',
      profilePicture: './img/icon/logo.svg', // Đường dẫn ảnh mặc định
    });
    const [addressList, setAddressList] = useState([]);
    const [isAddressFormVisible, setIsAddressFormVisible] = useState(false);
    const [addressForm, setAddressForm] = useState({
      name: '',
      phonenumber: '',
      address: '',
    });
    const [selectedAddressIndex, setSelectedAddressIndex] = useState(null);
    const [activeSection, setActiveSection] = useState('profile');
    const [loading, setLoading] = useState(true);
    const [formError, setFormError] = useState('');
    const [orderHistory, setOrderHistory] = useState([]);
    const [selectedOrder, setSelectedOrder] = useState(null); // Trạng thái cho đơn hàng đã chọn
    const [selectedProduct, setSelectedProduct] = useState(null); // Trạng thái cho sản phẩm đã chọn

    useEffect(() => {
      const fetchProfile = async () => {
        setLoading(true);
        try {
          const userId = localStorage.getItem('UserId');
          if (!userId) {
            throw new Error('Người dùng chưa đăng nhập');
          }
          console.log('Đang tải hồ sơ cho UserId:', userId);
          const response = await axios.get(`http://localhost:5179/api/Users/${userId}`);
          console.log('Dữ liệu hồ sơ nhận được:', response.data);
          
          setProfile(prevState => ({
            ...prevState,
            username: response.data.Username || '',
            email: response.data.Email || '',
            phonenumber: response.data.phonenumber || '',
            gender: response.data.Gender || 'other',
            profilePicture: response.data.AvatarUrl || './img/icon/logo.svg',
            address: response.data.Address || '',
            isActive: response.data.IsActive !== undefined ? response.data.IsActive : true,
            lastLogin: response.data.LastLogin || '',
            role: response.data.Role || 'User',
            salary: response.data.Salary || 0,
            createdAt: response.data.CreatedAt || '',
            updatedAt: response.data.UpdatedAt || '',
            userId: response.data.UserId || null,
            carts: response.data.Carts || [],
          }));
        } catch (error) {
          console.error('Lỗi khi tải dữ liệu hồ sơ', error);
          alert('Không thể tải thông tin hồ sơ.');
        } finally {
          setLoading(false);
        }
      };

      const fetchOrderHistory = async () => {
        setLoading(true);
        try {
          const userId = localStorage.getItem('UserId');
          if (!userId) {
            throw new Error('Người dùng chưa đăng nhập');
          }
          console.log('Đang tải lịch sử đơn hàng cho UserId:', userId);
          const response = await axios.get(`http://localhost:5179/api/Cart/history/${userId}`);
          console.log('Dữ liệu lịch sử đơn hàng nhận được:', response.data);
          
          setOrderHistory(Array.isArray(response.data) ? response.data : []);
        } catch (error) {
          console.error('Lỗi khi tải dữ liệu lịch sử đơn hàng', error);
          alert('Không thể tải thông tin lịch sử đơn hàng.');
        } finally {
          setLoading(false);
        }
      };

      fetchProfile();
      fetchOrderHistory();
    }, []);

    const handleInputChange = (e) => {
      const { id, value } = e.target;
      setProfile(prevState => ({
        ...prevState,
        [id]: value,
      }));
    };

    const handleFormSubmit = async (e) => {
      e.preventDefault();
      try {
        const userId = localStorage.getItem('UserId');
        if (!userId) {
          throw new Error('Người dùng chưa đăng nhập');
        }

        const updatedUserData = {
          username: profile.username,
          email: profile.email,
          address: profile.address,
          phonenumber: profile.phonenumber,
          gender: profile.gender,
          role: profile.role
        };

        console.log('Dữ liệu sẽ được gửi để cập nhật:', updatedUserData);

        const response = await axios.put(`http://localhost:5179/api/Users/${userId}`, updatedUserData, {
          headers: {
            "Content-Type": "application/json",
          },
        });
        console.log('Phản hồi từ API sau khi cập nhật:', response.data);
        alert('Dữ liệu hồ sơ đã được cập nhật thành công!');
        setFormError('');
      } catch (error) {
        if (error.response) {
          console.error('Lỗi khi cập nhật dữ liệu hồ sơ', error.response.data);
          const errorMessage = error.response.data.errors
            ? Object.values(error.response.data.errors).flat().join(', ')
            : 'Lỗi không xác định';
          setFormError(`Lỗi khi cập nhật dữ liệu hồ sơ: ${errorMessage}`);
        } else {
          console.error('Lỗi khi cập nhật dữ liệu hồ sơ', error.message);
          setFormError('Lỗi khi cập nhật dữ liệu hồ sơ. Vui lòng kiểm tra lại thông tin.');
        }
      }
    };

    const handleMenuClick = (section) => {
      setActiveSection(section);
    };

    const handleOrderClick = (order) => {
      setSelectedOrder(order);
      setSelectedProduct(null); // Đặt lại thông tin sản phẩm khi chọn đơn hàng mới
    };

    const handleProductClick = async (productId) => {
      try {
        const response = await axios.get(`http://localhost:5179/api/Products/${productId}`);
        setSelectedProduct(response.data);
      } catch (error) {
        console.error('Lỗi khi tải thông tin chi tiết sản phẩm', error);
        alert('Không thể tải thông tin chi tiết sản phẩm.');
      }
    };

    return (
      <div className='profile'>
        <div className="profile-container">
          <div className="profile-sidebar">
            <div className="profile-picture">
              <img
                src={profile.profilePicture || './img/icon/logo.svg'}
                alt="Avatar"
              />
            </div>
            <div className="profile-menu">
              <ul>
                <li
                  className={`profile-menu-item ${activeSection === 'profile' ? 'active' : ''}`}
                  onClick={() => handleMenuClick('profile')}
                >
                  Hồ Sơ
                </li>
                <li
                  className={`profile-menu-item ${activeSection === 'password' ? 'active' : ''}`}
                  onClick={() => handleMenuClick('password')}
                >
                  Đổi Mật Khẩu
                </li>
                <li
                  className={`profile-menu-item ${activeSection === 'orders' ? 'active' : ''}`}
                  onClick={() => handleMenuClick('orders')}
                >
                  Thông Tin Đơn Hàng
                </li>
              </ul>
            </div>
          </div>
          <div className="profile-main-content">
            {loading && <p>Đang tải dữ liệu...</p>}

            {activeSection === 'profile' && (
              <div className="profile-content-section">
                <h2>Hồ Sơ Của Tôi</h2>
                <p>Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                {formError && <div className="error-message">{formError}</div>}
                <form id="profile-form" onSubmit={handleFormSubmit}>
                  <div className="form-group">
                    <label htmlFor="username">Tên Đăng Nhập</label>
                    <input
                      type="text"
                      id="username"
                      value={profile.username}
                      onChange={handleInputChange}
                    />
                  </div>
                  <div className="form-group">
                    <label htmlFor="email">Email</label>
                    <input
                      type="email"
                      id="email"
                      value={profile.email}
                      onChange={handleInputChange}
                    />
                  </div>
                  <div className="form-group">
                    <label htmlFor="address">Địa chỉ</label>
                    <input
                      type="text"
                      id="address"
                      value={profile.address}
                      onChange={handleInputChange}
                    />
                  </div>
                  <div className="form-group">
                    <label htmlFor="phonenumber">Số Điện Thoại</label>
                    <input
                      type="text"
                      id="phonenumber"
                      value={profile.phonenumber}
                      onChange={handleInputChange}
                    />
                  </div>
                  <div className="form-group">
                    <label htmlFor="gender">Giới Tính</label>
                    <select
                      id="gender"
                      value={profile.gender}
                      onChange={handleInputChange}
                    >
                      <option value="male">Nam</option>
                      <option value="female">Nữ</option>
                      <option value="other">Khác</option>
                    </select>
                  </div>
                  <button type="submit">Lưu Thay Đổi</button>
                </form>
              </div>
            )}

            {activeSection === 'orders' && (
              <div className="profile-content-section">
                <h2>Lịch Sử Đơn Hàng</h2>
                {orderHistory.length === 0 ? (
                  <p>Không có đơn hàng nào.</p>
                ) : (
                  <div>
                    <table className="order-history-table">
                      <thead>
                        <tr>
                          <th>Đơn hàng ID</th>
                          <th>Ngày</th>
                          <th>Trạng thái</th>
                          <th>Tổng giá trị</th>
                          <th>Chi tiết</th>
                        </tr>
                      </thead>
                      <tbody>
                        {orderHistory.map((order) => {
                          // Tính tổng tiền
                          const totalPrice = order.CartItems.reduce((total, item) => total + (item.Price * item.Quantity), 0);

                          return (
                            <tr key={order.CartId}>
                              <td>{order.CartId}</td>
                              <td>{new Date(order.CreatedAt).toLocaleDateString()}</td>
                              <td>{order.Status ? 'Hoàn tất' : 'Chưa hoàn tất'}</td>
                              <td>{totalPrice.toLocaleString()}</td> {/* Hiển thị tổng giá trị */}
                              <td>
                                <button onClick={() => handleOrderClick(order)}>Xem Chi Tiết</button>
                              </td>
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                    {selectedOrder && (
                      <div className="order-details">
                        <h3>Sản phẩm trong đơn hàng {selectedOrder.CartId}</h3>
                        <ul>
                          {selectedOrder.CartItems.map((item) => (
                            <li key={item.CartItemId} onClick={() => handleProductClick(item.ProductId)}>
                              {item.Product.Name} - {item.Quantity} x {item.Price} (Size: {item.Size}) {/* Hiển thị kích thước */}
                            </li>
                          ))}
                        </ul>
                        {selectedProduct && (
                          <div className="product-details">
                            <h3>Chi Tiết Sản Phẩm</h3>
                            <p><strong>Tên:</strong> {selectedProduct.Name}</p>
                            <p><strong>Giá:</strong> {selectedProduct.Price}</p>
                            <img src={selectedProduct.ProductImgUrl} alt={selectedProduct.Name} />
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    );
  };

  export default Profile;
