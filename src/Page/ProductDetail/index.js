import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useParams } from 'react-router-dom';
import { useCart } from '../../Context/CartContext';
import './ProductDetail.css';

const ProductDetails = () => {
  const { id } = useParams();
  const [product, setProduct] = useState(null);
  const [productImages, setProductImages] = useState([]);
  const [mainImage, setMainImage] = useState('./img/default.jpg');
  const [selectedSize, setSelectedSize] = useState(null);
  const [quantity, setQuantity] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { addProductToCart } = useCart();
  const [shoeSizes, setShoeSizes] = useState([]);

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        // Fetch product details
        const productResponse = await axios.get(`http://localhost:5179/api/Products/${id}`);
        console.log('Product Response:', productResponse.data); // Log the product data
        setProduct(productResponse.data);
        setProductImages(productResponse.data.ProductImages || []);
        if (productResponse.data.ProductImages && productResponse.data.ProductImages.length > 0) {
          setMainImage(productResponse.data.ProductImages[0].ImageUrl);
        }

        // Extract shoe sizes from product data
        setShoeSizes(productResponse.data.ProductSizes || []);
      } catch (error) {
        console.error('Error fetching product details:', error); // Log the error
        setError('Lỗi khi tải chi tiết sản phẩm');
      } finally {
        setLoading(false);
      }
    };

    fetchProduct();
  }, [id]);

  const handleThumbnailClick = (image) => {
    setMainImage(image);
  };

  const formatPriceToVND = (price) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND',
    }).format(price);
  };

  const handleAddToCart = () => {
    if (selectedSize && quantity > 0) {
      const selectedSizeObj = shoeSizes.find(size => size.Size === selectedSize);
      if (selectedSizeObj) {
        console.log('Adding to Cart:', {
          productId: product.ProductId,
          size: selectedSize,
          quantity,
          price: product.Price
        });
        addProductToCart(product.ProductId, selectedSize, quantity, product.Price);
        console.log("Thêm giỏ hàng thành công");
        alert('Thêm vào giỏ hàng thành công');
      } else {
        alert('Kích thước không hợp lệ.');
      }
    } else {
      alert('Vui lòng chọn kích thước và số lượng hợp lệ.');
    }
  };

  if (loading) return <div>Đang tải...</div>;
  if (error) return <div>{error}</div>;
  if (!product) return <div>Không tìm thấy sản phẩm</div>;

  return (
    <section className="product-details">
      <div className="product-details-container">
        <div className="product-details-grid">
          <div className="product-details-left">
            <img className="main-image" src={mainImage} alt={product.Name} />
            <div className="product-details-images">
              {productImages.length > 0 ? (
                productImages.slice(0, 5).map((img, index) => (
                  <img
                    key={index}
                    className={mainImage === img.ImageUrl ? 'active' : ''}
                    src={img.ImageUrl}
                    alt={`Thumbnail ${index + 1}`}
                    onClick={() => handleThumbnailClick(img.ImageUrl)}
                  />
                ))
              ) : (
                <p>Không có hình ảnh</p>
              )}
            </div>
          </div>
          <div className="product-details-right">
            <div className="product-details-info">
              <h1>{product.Name}</h1>
              <p>{formatPriceToVND(product.Price)}</p>
            </div>
            <div className="product-details-buttons">
              {shoeSizes.length > 0 ? (
                shoeSizes.map((size, index) => (
                  <button
                    key={index}
                    className={`product-size-btn ${size.StockQuantity === 0 ? 'out-of-stock' : ''}`}
                    disabled={size.StockQuantity === 0}
                    onClick={() => setSelectedSize(size.Size)}
                  >
                    {size.Size} ({size.StockQuantity})
                  </button>
                ))
              ) : (
                <p>Không có kích cỡ khả dụng</p>
              )}
            </div>
            <div className="product-details-quantity">
              <h2>Số lượng:</h2>
              <div className="product-quantity-input">
                <input
                  type="number"
                  value={quantity}
                  onChange={(e) => setQuantity(parseInt(e.target.value, 10))}
                  min="1"
                />
              </div>
            </div>
            <div className="product-details-cart">
              <button
                className="add-to-cart-btn"
                onClick={handleAddToCart}
                disabled={!selectedSize || quantity <= 0}
              >
                <i className="fa-solid fa-cart-plus"></i>Thêm vào giỏ hàng
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default ProductDetails;
