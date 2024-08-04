import React, { useState } from 'react';
import './search.css';

const Search = ({ onSearch }) => {
  const [selectedSize, setSelectedSize] = useState('all');
  const [selectedPriceRange, setSelectedPriceRange] = useState('all');
  const [selectedSort, setSelectedSort] = useState('price-asc');

  const handleSearch = () => {
    onSearch({
      size: selectedSize,
      priceRange: selectedPriceRange,
      sort: selectedSort
    });
  };

  return (
    <div className="search">
      <div className="form-container">
        <div className="form-group">
          <label htmlFor="size">Chọn Size Giày</label>
          <select
            id="size"
            value={selectedSize}
            onChange={(e) => setSelectedSize(e.target.value)}
            aria-label="Select shoe size"
          >
            <option value="all">Tất cả</option>
            <option value="38">38</option>
            <option value="39">39</option>
            <option value="40">40</option>
            <option value="41">41</option>
            <option value="42">42</option>
          </select>
        </div>
        <div className="form-group">
          <label htmlFor="price">Khoảng Giá</label>
          <select
            id="price"
            value={selectedPriceRange}
            onChange={(e) => setSelectedPriceRange(e.target.value)}
            aria-label="Select price range"
          >
            <option value="all">Tất cả</option>
            <option value="0-1000000">Dưới 1.000.000</option>
            <option value="1000000-2000000">1.000.000 - 2.000.000</option>
            <option value="2000000-3000000">2.000.000 - 3.000.000</option>
            <option value="3000000-4000000">3.000.000 - 4.000.000</option>
            <option value="4000000-5000000">4.000.000 - 5.000.000</option>
            <option value="5000000-10000000">Trên 5.000.000</option>
          </select>
        </div>
        <div className="form-group">
          <label htmlFor="sort">Sắp Xếp Theo</label>
          <select
            id="sort"
            value={selectedSort}
            onChange={(e) => setSelectedSort(e.target.value)}
            aria-label="Sort products"
          >
            <option value="price-asc">Giá thấp đến cao</option>
            <option value="name-asc">Tên A-Z</option>
            <option value="name-desc">Tên Z-A</option>
          </select>
        </div>
        <button className="search-btn" onClick={handleSearch}>Tìm Giày Ngay</button>
      </div>
    </div>
  );
};

export default Search;
