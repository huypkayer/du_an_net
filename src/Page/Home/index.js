import React, { useState, useEffect } from "react";
import Slider from "react-slick";
import axios from "axios";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";
import "./home.module.css";

function CenterMode() {
  const settings = {
    className: "center",
    centerMode: true,
    infinite: true,
    centerPadding: "60px",
    slidesToShow: 3,
    speed: 500,
  };

  const formatPrice = (price) => {
    const formatter = new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND',
      minimumFractionDigits: 0
    });
    return formatter.format(price);
  };

  const getRandomProducts = (products, count = 3) => {
    const shuffled = [...products].sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
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
          const allProducts = response.data;
          const filtered = filterProducts(allProducts, categoryId);
          const randomProducts = getRandomProducts(filtered);
          setProducts(allProducts);
          setFilteredProducts(randomProducts);
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
      const filtered = filterProducts(products, categoryId);
      const randomProducts = getRandomProducts(filtered);
      setFilteredProducts(randomProducts);
    }, [categoryId, products]);

    if (loading) {
      return <div>Đang tải...</div>;
    }

    if (error) {
      return <div>{error}</div>;
    }

    return (
      <div className="container w-4/5">
        <div className="slider-container">
          <Slider {...settings}>
            <div>
              <img src="./img/slide1.jpg" alt="Slide 1" />
            </div>
            <div>
              <img src="./img/slide2.jpg" alt="Slide 2" />
            </div>
            <div>
              <img src="./img/slide3.jpg" alt="Slide 3" />
            </div>
          </Slider>
        </div>
        <div className="Frame1142 w-96 h-11 px-5 py-2 bg-white border-l-4 border-black justify-start items-start inline-flex mt-10 ml-10">
          <div className="text-black text-xl font-bold font-['Noto Sans'] leading-loose">
            Sản phẩm nổi bật
          </div>
        </div>
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
      </div>
    );
  }

  return <ProductList />;
}

export default CenterMode;
