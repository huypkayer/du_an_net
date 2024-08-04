import React, { createContext, useContext, useState, useEffect, useRef } from 'react';
import { addToCart, getCart, completeCheckout, removeCartItem, updateCartItemQuantity } from '../Service/CarService'; // Thêm import mới

const CartContext = createContext();

export const CartProvider = ({ children }) => {
  const [cart, setCart] = useState(null);
  const [cartItems, setCartItems] = useState([]);
  const [loading, setLoading] = useState(false);
  const [userId, setUserId] = useState(null);
  const prevUserIdRef = useRef(null);

  // Fetch cart and cart items
  const fetchCartAndItems = async () => {
    if (userId) {
      setLoading(true);
      try {
        const cartResponse = await getCart(userId);
        console.log('Cart response:', cartResponse);

        // Update cart and cart items based on the response
        setCart(cartResponse);
        if (cartResponse && cartResponse.CartItems) {
          setCartItems(cartResponse.CartItems);
        }
      } catch (err) {
        console.error('Error fetching cart and items:', err);
      } finally {
        setLoading(false);
      }
    }
  };

  useEffect(() => {
    const storedUserId = localStorage.getItem('UserId');
    if (storedUserId && storedUserId !== 'undefined') {
      setUserId(JSON.parse(storedUserId));
    }
  }, []);

  useEffect(() => {
    if (userId && prevUserIdRef.current !== userId) {
      fetchCartAndItems();
      prevUserIdRef.current = userId;
    }
  }, [userId]);

  const addProductToCart = async (productId, size, quantity, price) => {
    if (!productId || !size || quantity === undefined || price === undefined) {
      console.error('Incomplete information to add product to cart:', { productId, size, quantity, price });
      return;
    }

    const addToCartRequest = {
      userId: userId, 
      ProductId: productId,
      Size: size,
      Quantity: quantity,
      Price: price,
    };

    setLoading(true);
    try {
      await addToCart(addToCartRequest);
      await fetchCartAndItems(); // Refresh cart and items after adding
    } catch (error) {
      console.error('Error adding product to cart:', error.response ? error.response.data : error);
    } finally {
      setLoading(false);
    }
  };

  const completePayment = async () => {
    const completePaymentRequest = {
      userId: userId || '',
    };
    setLoading(true);
    try {
      await completeCheckout(completePaymentRequest);
      await fetchCartAndItems(); // Refresh cart and items after payment
    } catch (err) {
      console.error('Error completing payment:', err);
    } finally {
      setLoading(false);
    }
  };

  const removeItem = async (cartItemId) => {
    setLoading(true);
    try {
      await removeCartItem(cartItemId);
      await fetchCartAndItems(); // Refresh cart and items after removal
    } catch (err) {
      console.error('Error removing item from cart:', err);
    } finally {
      setLoading(false);
    }
  };

  // Hàm cập nhật số lượng sản phẩm trong giỏ hàng
  const updateQuantity = async (cartItemId, quantity) => {
    const updateQuantityRequest = {
      CartItemId: cartItemId,
      Quantity: quantity,
    };

    setLoading(true);
    try {
      await updateCartItemQuantity(updateQuantityRequest);
      await fetchCartAndItems(); // Refresh cart and items after updating quantity
    } catch (error) {
      console.error('Error updating cart item quantity:', error.response ? error.response.data : error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <CartContext.Provider
      value={{
        cart,
        cartItems,
        addProductToCart,
        completePayment,
        removeItem,
        updateQuantity, // Thêm updateQuantity vào value
        loading
      }}
    >
      {children}
    </CartContext.Provider>
  );
};

export const useCart = () => useContext(CartContext);
