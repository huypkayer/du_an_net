import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './productlist.css';

const formatPrice = (price) => {
  const formatter = new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
    minimumFractionDigits: 0
  });
  return formatter.format(price);
};

const ProductList = ({ categoryId, size, priceRange, sort }) => {
  const [products, setProducts] = useState([]);
  const [filteredProducts, setFilteredProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const filterProducts = (products, categoryId) => {
    return categoryId
      ? products.filter(product => product.CategoryId === categoryId)
      : products;
  };

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const response = await axios.get('http://localhost:5179/api/Products', {
          params: {
            size: size || 'all',
            priceRange: priceRange || 'all',
            sort: sort || 'price-asc'
          }
        });
        console.log('Dữ liệu sản phẩm:', response.data);
        setProducts(response.data);
        setFilteredProducts(filterProducts(response.data, categoryId));
      } catch (error) {
        console.error('Lỗi khi lấy dữ liệu sản phẩm:', error);
        setError('Lỗi khi lấy dữ liệu sản phẩm');
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, [categoryId, size, priceRange, sort]);

  useEffect(() => {
    setFilteredProducts(filterProducts(products, categoryId));
  }, [categoryId, products]);

  if (loading) {
    return <div>Đang tải...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  return (
    <div className='product'>
      <div className="product-list">
        {filteredProducts.length > 0 ? (
          filteredProducts.map(product => (
            <div className="product-list-item" key={product.ProductId}>
              <div className="product-list-img">
                <a href={`/productdetail/${product.ProductId}`} className="product-link">
                  <img
                    src={product.ProductImages?.[0]?.ImageUrl || 'default-image-url.jpg'}
                    alt={product.Name}
                    className="product-img"
                  />
                </a>
              </div>
              <div className="product-content">
                <a href={`/productdetail/${product.ProductId}`}>{product.Name}</a>
                <span className="product-price">{formatPrice(product.Price)}</span>
              </div>
            </div>
          ))
        ) : (
          <div>Không tìm thấy sản phẩm</div>
        )}
      </div>
    </div>
  );
};

export default ProductList;
