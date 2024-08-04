import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link, useLocation } from 'react-router-dom';
import './search.css';

const SearchPage = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredProducts, setFilteredProducts] = useState([]);

  const location = useLocation();
  const queryParams = new URLSearchParams(location.search);
  const query = queryParams.get('query') || '';

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const response = await axios.get('http://localhost:5179/api/Products');
        setProducts(response.data);
        setFilteredProducts(response.data);
      } catch (error) {
        console.error('Error fetching products:', error);
        setError('Lỗi khi tải sản phẩm');
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  useEffect(() => {
    setSearchTerm(query);
    setFilteredProducts(
      products.filter(product =>
        product.Name.toLowerCase().includes(query.toLowerCase())
      )
    );
  }, [query, products]);

  const handleSearchChange = (e) => {
    setSearchTerm(e.target.value);
  };

  return (
    <section className="search-page">
      <div className="search-page-container">
        <input
          type="text"
          placeholder="Tìm kiếm sản phẩm..."
          value={searchTerm}
          onChange={handleSearchChange}
        />
        {loading && <div>Đang tải...</div>}
        {error && <div>{error}</div>}
        {filteredProducts.length === 0 && !loading && !error && <div>Không có sản phẩm nào</div>}
        <div className="search-results">
          {filteredProducts.map(product => (
            <div key={product.ProductId} className="product-item">
              <Link to={`/product/${product.ProductId}`}>
                <img src={product.ProductImgUrl} alt={product.Name} />
                <div className="product-details">
                  <h2>{product.Name}</h2>
                  <p>{new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND',
                  }).format(product.Price)}</p>
                </div>
              </Link>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default SearchPage;
