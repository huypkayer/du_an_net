import axios from 'axios';

const API_BASE_URL = 'http://localhost:5179/api';

// Lấy dữ liệu giỏ hàng theo userId
export const getCart = async (userId) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/Cart/${userId}`);
    return response.data;
  } catch (error) {
    console.error('Error fetching cart:', error);
    throw error;
  }
};

// Thêm sản phẩm vào giỏ hàng
export const addToCart = async (addToCartRequest) => {
  try {
    const response = await axios.post(`${API_BASE_URL}/Cart/addToCart`, addToCartRequest);
    return response.data;
  } catch (error) {
    console.error('Error adding product to cart:', error);
    throw error;
  }
};

// Cập nhật số lượng mục trong giỏ hàng
export const updateCartItemQuantity = async (updateQuantityRequest) => {
  try {
    const response = await axios.put(`${API_BASE_URL}/Cart/updateQuantity`, updateQuantityRequest);
    return response.data;
  } catch (error) {
    console.error('Error updating cart item quantity:', error);
    throw error;
  }
};


// Hoàn tất thanh toán
export const completeCheckout = async (completeCheckoutRequest) => {
  try {
    const response = await axios.post(`${API_BASE_URL}/Cart/completeCheckout`, completeCheckoutRequest);
    return response.data;
  } catch (error) {
    console.error('Error completing checkout:', error);
    throw error;
  }
};

// Xóa mục khỏi giỏ hàng
export const removeCartItem = async (cartItemId) => {
  try {
    await axios.delete(`${API_BASE_URL}/Cart/removeItem/${cartItemId}`);
  } catch (error) {
    console.error('Error removing cart item:', error);
    throw error;
  }
};
