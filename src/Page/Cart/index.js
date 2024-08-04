import React, { useEffect, useState } from 'react';
import { useCart } from '../../Context/CartContext'; // Đảm bảo đường dẫn chính xác
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import './cart.css';

const Cart = () => {
  const { cartItems, removeItem, updateQuantity, loading, completePayment } = useCart();
  const [quantities, setQuantities] = useState({});
  const [showShippingInfo, setShowShippingInfo] = useState(false);
  const [profile, setProfile] = useState({
    username: '',
    phonenumber: '',
    address: ''
  });
  const [loadingProfile, setLoadingProfile] = useState(false);
  const navigate = useNavigate(); // Sử dụng hook useNavigate

  const totalAmount = cartItems.reduce((total, item) => 
    total + item.Product.Price * (quantities[item.CartItemId] || item.Quantity), 0);

  const handleDeleteItem = async (cartItemId) => {
    try {
      console.log(`Deleting item ${cartItemId}`);
      await removeItem(cartItemId);
    } catch (err) {
      console.error("Error removing item:", err);
    }
  };

  const handleQuantityChange = async (cartItemId, newQuantity) => {
    setQuantities(prevQuantities => ({
      ...prevQuantities,
      [cartItemId]: newQuantity
    }));

    try {
      await updateQuantity(cartItemId, newQuantity);
    } catch (err) {
      console.error("Error updating quantity:", err);
    }
  };

  const handleShippingInfoAndCartSubmit = async () => {
    try {
      const userId = localStorage.getItem('UserId');
      if (!userId) {
        throw new Error('Người dùng chưa đăng nhập');
      }

      const orderData = {
        userId,
        userName: profile.username, // Đổi từ username thành userName
        phoneNumber: profile.phonenumber.toString(), // Đổi từ phonenumber thành phoneNumber
        address: profile.address,
        cartItems: cartItems.map(item => ({
          productId: item.Product.ProductId,
          quantity: quantities[item.CartItemId] || item.Quantity,
          price: item.Product.Price,
          size: item.Size,
        })),
        totalAmount
      };
      
      await axios.post('http://localhost:5179/api/Cart/completeCheckout', orderData);
      alert('Đơn hàng đã được gửi.');
      navigate('/'); // Chuyển hướng người dùng tới trang chủ
    } catch (error) {
      console.error('Lỗi khi gửi đơn hàng', error);
      alert('Không thể gửi đơn hàng.');
    }
  };

  const handleInputChange = (e) => {
    const { id, value } = e.target;
    setProfile(prevProfile => ({
      ...prevProfile,
      [id]: value
    }));
  };

  useEffect(() => {
    const fetchProfile = async () => {
      setLoadingProfile(true);
      try {
        const userId = localStorage.getItem('UserId');
        if (!userId) {
          throw new Error('Người dùng chưa đăng nhập');
        }
        console.log('Đang tải hồ sơ cho UserId:', userId);
        const response = await axios.get(`http://localhost:5179/api/Users/${userId}`);
        console.log('Dữ liệu hồ sơ nhận được:', response.data);

        setProfile({
          username: response.data.Username || '',
          email: response.data.Email || '',
          phonenumber: response.data.PhoneNumber || '',
          address: response.data.Address || ''
        });
      } catch (error) {
        console.error('Lỗi khi tải dữ liệu hồ sơ', error);
        alert('Không thể tải thông tin hồ sơ.');
      } finally {
        setLoadingProfile(false);
      }
    };

    fetchProfile();
  }, []);

  useEffect(() => {
    console.log('Loading:', loading);
    console.log('Cart Items:', cartItems);
  }, [loading, cartItems]);

  return (
    <div className='cart'>
      {loading && <div className="loading">Đang tải...</div>}
      <div className="cart_section">
        <div className="cart_section_container">
          <div className="cart_section_rowgrid">
            <div className="cart_section_left">
              <h2>CHI TIẾT ĐƠN HÀNG</h2>
              <div className="cart_section_left_detail">
                <div className="cart_section_left_detail_img">
                  <span>ẢNH</span>
                </div>
                <div>
                  <span>SẢN PHẨM</span>
                </div>
                <div>
                  <span>SIZE</span>
                </div>
                <div>
                  <span>SỐ LƯỢNG</span>
                </div>
                <div>
                  <span>GIÁ</span>
                </div>
                <div></div>
              </div>
              {cartItems.map((item) => (
                <div key={item.CartItemId} className="cart_section_left_detail">
                  <div className="cart_section_left_detail_img">
                    <img src={item.Product.ProductImgUrl} alt="product" />
                  </div>
                  <div>
                    <span>{item.Product.Name}</span>
                  </div>
                  <div>
                    <span>{item.Size}</span>
                  </div>
                  <div>
                    <input
                      type="number"
                      value={quantities[item.CartItemId] || item.Quantity}
                      onChange={(e) => handleQuantityChange(item.CartItemId, parseInt(e.target.value))}
                      min="1"
                    />
                  </div>
                  <div>
                    <span>{item.Product.Price.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}</span>
                  </div>
                  <div>
                    <button onClick={() => handleDeleteItem(item.CartItemId)}>Xóa</button>
                  </div>
                </div>
              ))}
              <div className="total_amount">
                <h3>TỔNG TIỀN: {totalAmount.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}</h3>
              </div>
              {cartItems.length > 0 && !showShippingInfo && (
                <button onClick={() => setShowShippingInfo(true)}>Xác nhận đơn hàng</button>
              )}
            </div>
            {showShippingInfo && (
              <div className="cart_section_right">
                <h2>THÔNG TIN GIAO HÀNG</h2>
                <div className="form_group">
                  <label htmlFor="username">Tên người dùng:</label>
                  <input
                    type="text"
                    id="username"
                    value={profile.username}
                    onChange={handleInputChange}
                    disabled={loadingProfile}
                  />
                </div>
                <div className="form_group">
                  <label htmlFor="phonenumber">Số điện thoại:</label>
                  <input
                    type="text"
                    id="phonenumber"
                    value={profile.phonenumber}
                    onChange={handleInputChange}
                    disabled={loadingProfile}
                  />
                </div>
                <div className="form_group">
                  <label htmlFor="address">Địa chỉ:</label>
                  <input
                    type="text"
                    id="address"
                    value={profile.address}
                    onChange={handleInputChange}
                    disabled={loadingProfile}
                  />
                </div>
                <button onClick={handleShippingInfoAndCartSubmit}>Hoàn tất đơn hàng</button>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Cart;
