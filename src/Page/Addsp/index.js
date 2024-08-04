import React, { useState, useEffect } from "react";
import Sidebar from "../../components/Sidebar";
import styles from "./addsp.module.css"; // Import CSS module

const ProductManagement = () => {
  const [productName, setProductName] = useState("");
  const [material, setMaterial] = useState("");
  const [sellingPrice, setSellingPrice] = useState("");
  const [discountPrice, setDiscountPrice] = useState("");
  const [features, setFeatures] = useState("");
  const [productDescription, setProductDescription] = useState("");
  const [productImage, setProductImage] = useState(null);
  const [products, setProducts] = useState([]);

  useEffect(() => {
    // Fetch products from API when component mounts
    fetch("http://localhost:5179/api/Products/all")
      .then((response) => response.json())
      .then((data) => setProducts(data))
      .catch((error) => console.error("Error fetching products:", error));
  }, []);

  const handleImageUpload = (event) => {
    setProductImage(event.target.files[0]);
  };

  const handleAddProduct = (event) => {
    event.preventDefault();

    const newProduct = {
      productName,
      material,
      sellingPrice,
      discountPrice,
      features,
      productDescription,
      image: productImage ? URL.createObjectURL(productImage) : "",
    };

    setProducts([...products, newProduct]);

    setProductName("");
    setMaterial("");
    setSellingPrice("");
    setDiscountPrice("");
    setFeatures("");
    setProductDescription("");
    setProductImage(null);
  };

  return (
    <div className={styles.mainContent}>
      <Sidebar />
      <header>
        <h1>Quản lí sản phẩm</h1>
      </header>
      <main>
        <section className={styles.formSection}>
          <h2>Thêm sản phẩm</h2>
          <form id="productForm" onSubmit={handleAddProduct}>
            <div className={styles.formGroup}>
              <label htmlFor="productName">Tên sản phẩm:</label>
              <input
                type="text"
                id="productName"
                name="productName"
                value={productName}
                onChange={(e) => setProductName(e.target.value)}
                required
              />
            </div>
            {/* Các trường khác */}
            <div className={styles.formGroup}>
              <label htmlFor="productImage">Hình ảnh:</label>
              <input
                type="file"
                id="productImage"
                name="productImage"
                accept="image/*"
                onChange={handleImageUpload}
              />
            </div>
            <button type="submit">Gửi</button>
          </form>
        </section>
        <section className={styles.tableSection}>
          <h2>Danh sách sản phẩm</h2>
          <table id="productTable">
            <thead>
              <tr>
                <th>Tên sản phẩm</th>
                <th>Giá bán</th>
                <th>Mô tả sản phẩm</th>
                <th>Hình ảnh</th>
              </tr>
            </thead>
            <tbody>
              {products.map((product) => (
                <tr key={product.ProductId}>
                  <td>{product.Name}</td>
                  <td>{product.Price}</td>
                  <td>{product.Description}</td>
                  <td>
                    {product.ProductImgUrl && (
                      <img src={product.ProductImgUrl} alt="Product" width="100" />
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      </main>
    </div>
  );
};

export default ProductManagement;