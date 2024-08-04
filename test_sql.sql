CREATE DATABASE Test;
GO

USE Test;
GO

-- Tạo bảng Users
CREATE TABLE Users (
    UserId INT PRIMARY KEY ,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Role NVARCHAR(50) NOT NULL DEFAULT 'User',
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    Address NVARCHAR(500),
    Salary DECIMAL(18, 2),
    IsActive BIT NOT NULL DEFAULT 1,
    AvatarUrl NVARCHAR(MAX),
    LastLogin DATETIME,
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    CONSTRAINT CK_Users_Salary CHECK (Salary >= 0)
);
GO



-- Tạo bảng Categories
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME
);
GO

-- Tạo bảng Products
CREATE TABLE Products (
    ProductId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(200) NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    Description NVARCHAR(MAX),
    CategoryId INT,
    Brand NVARCHAR(100),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    IsFeatured BIT NOT NULL DEFAULT 0,
    Discount DECIMAL(5, 2) DEFAULT 0,
    ProductImgUrl NVARCHAR(MAX),
    StockQuantity INT NOT NULL DEFAULT 0,
    CONSTRAINT CK_Products_Price CHECK (Price > 0),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);
GO

-- Tạo bảng ProductImages
CREATE TABLE ProductImages (
    ImageId INT PRIMARY KEY IDENTITY,
    ProductId INT NOT NULL,
    ImageUrl NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_ProductImages_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

-- Tạo bảng ProductSizes
CREATE TABLE ProductSizes (
    ProductSizeId INT PRIMARY KEY IDENTITY,
    ProductId INT NOT NULL,
    Size INT NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    CONSTRAINT CK_ProductSizes_StockQuantity CHECK (StockQuantity >= 0),
    CONSTRAINT FK_ProductSizes_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

CREATE TABLE Cart (
    CartId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL,
    Status BIT NOT NULL DEFAULT 0, -- Trạng thái giỏ hàng, 0 là chưa đặt hàng, 1 là đã đặt hàng
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    CONSTRAINT CK_Cart_Quantity CHECK (Quantity > 0),
    CONSTRAINT FK_Cart_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Cart_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
go


-- Tạo bảng CartItems với các thuộc tính bổ sung
CREATE TABLE CartItems (
    CartItemId INT PRIMARY KEY IDENTITY,
    CartId INT NOT NULL,
    ProductId INT NOT NULL,
    Size INT NOT NULL, -- Kích thước giày
    Quantity INT NOT NULL DEFAULT 1,
    Price DECIMAL(18, 2) NOT NULL, -- Giá của sản phẩm
    PurchaseDate DATETIME NULL, -- Ngày mua (có thể null nếu chưa được thanh toán)
    CONSTRAINT CK_CartItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT FK_CartItems_Cart FOREIGN KEY (CartId) REFERENCES Cart(CartId),
    CONSTRAINT FK_CartItems_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

ALTER TABLE Cart
DROP CONSTRAINT FK_Cart_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID);




-- Thêm dữ liệu vào bảng Categories
INSERT INTO Categories (Name, Description, CreatedAt, UpdatedAt)
VALUES
    ('Nike', 
     N'Nike là một thương hiệu thể thao toàn cầu được biết đến với trang phục, giày dép và thiết bị thể thao sáng tạo và chất lượng cao.', 
     GETDATE(), 
     NULL),
    
    ('Adidas', 
     N'Adidas là một trong những thương hiệu hàng đầu về sản phẩm thể thao, được biết đến với các sản phẩm chất lượng cao và thiết kế đột phá.', 
     GETDATE(), 
     NULL),
    
    ('Yeezy', 
     N'Yeezy là sự hợp tác thời trang giữa Kanye West và Adidas, được biết đến với những đôi giày thể thao và quần áo thời trang và được săn đón.', 
     GETDATE(), 
     NULL);

    
INSERT INTO Products (Name, Price, Description, CategoryId, Brand, CreatedAt, UpdatedAt, IsFeatured, Discount)
VALUES
    ('Samba OG', 29.99, N'Sinh ra trên sân cỏ, Samba là biểu tượng vượt thời gian của phong cách đường phố. Hình dáng này vẫn đúng với di sản của nó với mặt trên bằng da mềm mại, kiểu dáng thấp, trang nhã, lớp phủ da lộn và đế cao su, khiến nó trở thành một món đồ không thể thiếu trong tủ đồ của mọi người - trong và ngoài sân cỏ', 1, 'Adidas', GETDATE(), NULL, 0, 10.00),
    ('Samba OG', 29.99, N'Sinh ra trên sân cỏ, Samba là biểu tượng vượt thời gian của phong cách đường phố. Hình dáng này vẫn đúng với di sản của nó với mặt trên bằng da mềm mại, kiểu dáng thấp, trang nhã, lớp phủ da lộn và đế cao su, khiến nó trở thành một món đồ không thể thiếu trong tủ đồ của mọi người - trong và ngoài sân cỏ', 1, 'Adidas', GETDATE(), NULL, 1, 10.00),
    ('Stan Smith', 39.99, N'Cuộn với cổ điển. Ngày xưa Stan Smith thắng lớn trên sân quần vợt. Hãy mang vào đôi giày adidas xứng đáng với tên tuổi của anh ấy và bạn sẽ thắng lớn trên đường phố. Từ trên xuống dưới, những đôi giày này mang phong cách thiết yếu của nguyên bản năm 1971, với chất liệu da tối giản và đường viền gọn gàng.', 1, 'Adidas', GETDATE(), NULL, 0, 10.00),
    ('Stan Smith', 39.99, N'Cuộn với cổ điển. Ngày xưa Stan Smith thắng lớn trên sân quần vợt. Hãy mang vào đôi giày adidas xứng đáng với tên tuổi của anh ấy và bạn sẽ thắng lớn trên đường phố. Từ trên xuống dưới, những đôi giày này mang phong cách thiết yếu của nguyên bản năm 1971, với chất liệu da tối giản và đường viền gọn gàng.', 1, 'Adidas', GETDATE(), NULL, 1, 10.00),
    ('NMD R1', 45.00, N'Kêu gọi tất cả các nhà thám hiểm thành phố. Đôi giày adidas NMD_R1 này được thiết kế dành cho bạn. Chúng được thiết kế cực kỳ thoải mái để bạn có thể đi bộ không ngừng nghỉ và xem sự tò mò sẽ dẫn bạn đến đâu. Tất cả là nhờ lớp đệm BOOST phía trên có khả năng thích ứng và linh hoạt. Là sự phát triển tiên tiến của giày chạy bộ thập niên 80, chúng có kiểu dáng đẹp, nhanh nhẹn, phù hợp với mọi trang phục và mọi điểm đến.', 1, 'Adidas', GETDATE(), NULL, 1, 10.00),
    ('NMD G1', 49.99, N'Tương lai đáp ứng các tác phẩm kinh điển. Đôi giày adidas này tạo nên những chi tiết tiến bộ mang đậm dấu ấn của huyền thoại chạy bộ thập niên 80. Thân giày bằng vải dệt kim thoáng khí giúp mọi thứ luôn thoáng mát và lớp phủ cao su tạo thêm nét đẹp cyberpunk. Cảm nhận ngay cả quá khứ và tương lai dưới chân: BOOST sang trọng và đế giữa EVA mang đến sự thoải mái với kiểu dáng cổ điển. Các mấu kéo ở lưỡi giày và gót chân thể hiện phong cách adidas của OG. Đôi giày này mời bạn tham gia vào tương lai trước khi nó ở đây.', 1, 'Adidas', GETDATE(), NULL, 0, 10.00),
    ('NMD G1', 49.99, N'Tương lai đáp ứng các tác phẩm kinh điển. Đôi giày adidas này tạo nên những chi tiết tiến bộ mang đậm dấu ấn của huyền thoại chạy bộ thập niên 80. Thân giày bằng vải dệt kim thoáng khí giúp mọi thứ luôn thoáng mát và lớp phủ cao su tạo thêm nét đẹp cyberpunk. Cảm nhận ngay cả quá khứ và tương lai dưới chân: BOOST sang trọng và đế giữa EVA mang đến sự thoải mái với kiểu dáng cổ điển. Các mấu kéo ở lưỡi giày và gót chân thể hiện phong cách adidas của OG. Đôi giày này mời bạn tham gia vào tương lai trước khi nó ở đây.', 1, 'Adidas', GETDATE(), NULL, 1, 10.00),
    ('NMD V3', 44.99, N'Bạn không sống trong quá khứ, vậy tại sao huấn luyện viên của bạn lại nên làm vậy? Một ngày dành cho đôi giày adidas NMD_V3 này là một ngày dũng cảm tiến về phía trước. Đế ngoài bằng cao su là nền tảng hoàn hảo cho thiết kế sáng tạo này trong khi đế giữa BOOST có độ đàn hồi cao mang lại sự thoải mái ở mức độ cao và khả năng hoàn trả năng lượng đáng kể. Hãy đeo những thứ này khi bạn muốn được truyền cảm hứng, tràn đầy năng lượng và động lực.', 1, 'Adidas', GETDATE(), NULL, 0, 10.00),
    ('NMD V3', 44.99, N'Bạn không sống trong quá khứ, vậy tại sao huấn luyện viên của bạn lại nên làm vậy? Một ngày dành cho đôi giày adidas NMD_V3 này là một ngày dũng cảm tiến về phía trước. Đế ngoài bằng cao su là nền tảng hoàn hảo cho thiết kế sáng tạo này trong khi đế giữa BOOST có độ đàn hồi cao mang lại sự thoải mái ở mức độ cao và khả năng hoàn trả năng lượng đáng kể. Hãy đeo những thứ này khi bạn muốn được truyền cảm hứng, tràn đầy năng lượng và động lực.', 1, 'Adidas', GETDATE(), NULL, 1, 10.00),
    ('NMD R1', 45.00, N'Kêu gọi tất cả các nhà thám hiểm thành phố. Đôi giày adidas NMD_R1 này được thiết kế dành cho bạn. Chúng được thiết kế cực kỳ thoải mái để bạn có thể đi bộ không ngừng nghỉ và xem sự tò mò sẽ dẫn bạn đến đâu. Tất cả là nhờ lớp đệm BOOST phía trên có khả năng thích ứng và linh hoạt. Là sự phát triển tiên tiến của giày chạy bộ thập niên 80, chúng có kiểu dáng đẹp, nhanh nhẹn, phù hợp với mọi trang phục và mọi điểm đến.', 1, 'Adidas', GETDATE(), NULL, 0, 10.00);

INSERT INTO Products (Name, Price, Description, CategoryId, Brand, CreatedAt, UpdatedAt, IsFeatured, Discount)
VALUES
	('Air Jordan 1 Low', 29.99, N'Lấy cảm hứng từ bản gốc ra mắt vào năm 1985, Air Jordan 1 Low mang đến một cái nhìn cổ điển, sạch sẽ, quen thuộc nhưng luôn tươi mới. Với thiết kế mang tính biểu tượng kết hợp hoàn hảo với bất kỳ sự phù hợp nào, những cú đá này đảm bảo bạn sẽ luôn đi đúng hướng.', 2, 'Nike', GETDATE(), NULL, 0, 10.00),
	('Air Jordan 1 Mid', 29.99, N'Air Jordan 1 Mid mang đến phong cách toàn sân và sự thoải mái cao cấp cho một cái nhìn mang tính biểu tượng. Đệm đơn vị Air-Sole của nó chơi trên gỗ cứng, trong khi cổ áo đệm mang lại cho bạn cảm giác hỗ trợ.', 2, 'Nike', GETDATE(), NULL, 1, 10.00),
    ('Air Jordan 1 Mid', 29.99, N'Air Jordan 1 Mid mang đến phong cách toàn sân và sự thoải mái cao cấp cho một cái nhìn mang tính biểu tượng. Đệm đơn vị Air-Sole của nó chơi trên gỗ cứng, trong khi cổ áo đệm mang lại cho bạn cảm giác hỗ trợ.', 2, 'Nike', GETDATE(), NULL, 0, 10.00),
    ('Air Jordan 1 Low G NRG', 29.99, N'Bạn hình dung trò chơi sẽ đi về đâu trong nhiều năm kể từ bây giờ? Sự phát triển sắp tới là ngày hôm nay, trong AJ1 Low đặc biệt này. Một thiết kế Swoosh đôi óng ánh và kết thúc bằng kim loại là một cái gật đầu cho tương lai của golf thông qua một ống kính sang trọng, khi trò chơi tiếp tục phát triển và các liên kết bắt đầu khuấy động một lần nữa. Bạn vẫn có được tất cả sự mát mẻ của câu lạc bộ AJ1 ban đầu — đệm Nike Air, logo Wings và da thật — cộng với mô hình lực kéo sẵn sàng cho 18 lỗ.', 2, 'Nike', GETDATE(), NULL, 0, 10.00),
    ('Air Jordan 1 Low SE', 29.99, N'Biểu tượng kiểu phù hợp với các biểu tượng kiểu. AJ1 này kết hợp các vật liệu cao cấp với các chi tiết bắt mắt bao gồm logo Swoosh giống như gel và đế ngoài bằng cao su băng giá cho vẻ ngoài làm tăng nhiệt.', 2, 'Nike', GETDATE(), NULL, 0, 10.00),
    ('Nike Blazer Mid 77 Vintage', 29.99, N'Vào những năm 70, Nike là đôi giày mới trên khối. Vì vậy, mới trong thực tế, chúng tôi vẫn đang đột nhập vào bối cảnh bóng rổ và thử nghiệm các nguyên mẫu trên đôi chân của đội địa phương của chúng tôi. Tất nhiên, thiết kế được cải thiện qua nhiều năm, nhưng tên bị mắc kẹt. Nike Blazer Mid 77 Vintage—cổ điển ngay từ đầu.', 2, 'Nike', GETDATE(), NULL, 0, 10.00),
    ('Nike Blazer Phantom Low', 29.99, N'Đúng với DNA của Nike, được xây dựng cho ngày hôm nay. Blazer Phantom mô phỏng lại một hình bóng cổ điển trong một cấu hình thấp, kiểu dáng đẹp. Một cảm giác dưới chân được cải thiện với các thành bên dày hơn khuếch đại sự thoải mái mà không tạo ra số lượng lớn.', 2, 'Nike', GETDATE(), NULL, 1, 10.00),
    ('Nike Dunk High Retro', 29.99, N'Được tạo ra cho gỗ cứng nhưng được đưa ra đường phố, biểu tượng bóng rổ thập niên 80 trở lại với lớp phủ sáng bóng hoàn hảo và màu sắc nguyên bản của trường đại học. Với thiết kế vòng cổ điển, Nike Dunk High Retro truyền tải cổ điển thập niên 80 trở lại đường phố trong khi cổ áo cao, đệm của nó thêm một cái nhìn trường học cũ bắt nguồn từ sự thoải mái.', 2, 'Nike', GETDATE(), NULL, 1, 10.00),
    ('Nike Dunk Low SE', 29.99, N'Nike Dunk Low là một điểm số dễ dàng cho tủ quần áo của bạn. Biểu tượng thập niên 80 này trở lại với thiết kế đặc biệt lấy cảm hứng từ cách chúng ta di chuyển. Các chi tiết thiết kế phản chiếu và làn sóng màu sắc tươi sáng giúp các bước di chuyển của bạn bật lên và ra khỏi sàn nhảy, trong khi đệm nhẹ và đế ngoài chắc chắn mang lại sự thoải mái kéo dài.', 2, 'Nike', GETDATE(), NULL, 1, 10.00),
    ('Nike Dunk Low', 29.99, N'Được thiết kế cho bóng rổ nhưng được chấp nhận bởi những người trượt băng, Nike Dunk Low đã giúp xác định văn hóa giày thể thao. Bây giờ biểu tượng giữa những năm 80 này là một điểm dễ dàng cho tủ quần áo của bạn. Với đệm mắt cá chân và lực kéo cao su bền, đây là một cú dunk slam cho dù bạn đang học trượt băng hay chuẩn bị đi học.', 2, 'Nike', GETDATE(), NULL, 0, 10.00);
    
INSERT INTO Products (Name, Price, Description, CategoryId, Brand, CreatedAt, UpdatedAt, IsFeatured, Discount)
VALUES
	('Yeezy Boost 350 V2', 29.99, N'YEEZY BOOST 350 V2 có phần trên được làm bằng vải Primeknit được thiết kế lại. Đế giữa sử dụng công nghệ BOOST™ cải tiến của adidas. YEEZY BOOST 350 V2 được sản xuất bằng nhiều loại vật liệu tái chế và ít nhất 50% mặt trên có hàm lượng tái chế, sản phẩm này chỉ là một trong những giải pháp của chúng tôi nhằm giúp chấm dứt rác thải nhựa.', 3, 'Yeezy', GETDATE(), NULL, 1, 10.00),
	('YZY Foam RNR', 29.99, N'YZY FOAM RNR, ĐƯỢC SẢN XUẤT TẠI MỸ, CÓ TÍNH NĂNG BỌT EVA ĐƯỢC TIÊM ĐỂ CUNG CẤP ĐỘ BỀN NHẸ. MÔ HÌNH NÀY ĐƯỢC LÀM BẰNG CÔNG NGHỆ THU HOẠCH Tảo GIÚP GIỮ SẠCH HỒ. LỚP TRÊN MỀM TRONG CH N mang lại cảm giác THOẢI MÁI NGAY LẬP TỨC. Các lỗ thông hơi được lập bản đồ chiến lược xung quanh bàn chân mang lại luồng không khí và khả năng thở. NGOÀI RA, YZY FOAM RNR SẼ MỞ RỘNG MỘT X Y DỰNG HỘP MỚI CẦN ÍT VẬT LIỆU HƠN, DẪN ĐẾN ÍT LÃI THẢI VẬT LIỆU BÔNG TÔNG', 3, 'Yeezy', GETDATE(), NULL, 1, 10.00),
	('YZY Foam RNR Adult', 29.99, N'YZY FOAM RNR, ĐƯỢC SẢN XUẤT TẠI MỸ, CÓ TÍNH NĂNG BỌT EVA ĐƯỢC TIÊM ĐỂ CUNG CẤP ĐỘ BỀN NHẸ. MÔ HÌNH NÀY ĐƯỢC LÀM BẰNG CÔNG NGHỆ THU HOẠCH Tảo GIÚP GIỮ SẠCH HỒ. LỚP TRÊN MỀM TRONG CH N mang lại cảm giác THOẢI MÁI NGAY LẬP TỨC. Các lỗ thông hơi được lập bản đồ chiến lược xung quanh bàn chân mang lại luồng không khí và khả năng thở. NGOÀI RA, YZY FOAM RNR SẼ MỞ RỘNG MỘT X Y DỰNG HỘP MỚI CẦN ÍT VẬT LIỆU HƠN, DẪN ĐẾN ÍT LÃI THẢI VẬT LIỆU BÔNG TÔNG', 3, 'Yeezy', GETDATE(), NULL, 0, 10.00),
	('Yeezy Boost 350 V2 Onyx', 29.99, N'YEEZY BOOST 350 V2 Onyx có phần trên được làm bằng vải Primeknit được thiết kế lại. Đế giữa sử dụng công nghệ BOOST™ cải tiến của adidas. YEEZY BOOST 350 V2 Onyx được sản xuất bằng nhiều loại vật liệu tái chế và ít nhất 50% mặt trên có hàm lượng tái chế, sản phẩm này chỉ là một trong những giải pháp của chúng tôi nhằm giúp chấm dứt rác thải nhựa.', 3, 'Yeezy', GETDATE(), NULL, 1, 10.00),
	('Yeezy 500', 29.99, N'YEEZY 500 có phần trên được làm bằng da nguyên hạt và lớp phủ da lộn mang lại lớp hoàn thiện cao cấp, cảm giác cầm tay mềm mại cùng với khả năng hỗ trợ và độ bền khi đeo. Lớp lót lưới mang đến sự thoáng khí nhẹ và thoải mái khi cần thiết, trong khi các chi tiết đường ống phản chiếu tạo thêm dấu hiệu thiết kế độc đáo và sự thú vị về mặt thị giác. Một lớp bọc cao su dọc theo đế giữa giúp hỗ trợ và chống mài mòn. Lớp đệm The adiPRENE hấp thụ lực tác động và tối ưu hóa khả năng bật lại trong khi đế ngoài bằng cao su nhẹ mang lại lực kéo.', 3, 'Yeezy', GETDATE(), NULL, 1, 10.00),
	('Yeezy 500', 29.99, N'YEEZY 500 có phần trên được làm bằng da nguyên hạt và lớp phủ da lộn mang lại lớp hoàn thiện cao cấp, cảm giác cầm tay mềm mại cùng với khả năng hỗ trợ và độ bền khi đeo. Lớp lót lưới mang đến sự thoáng khí nhẹ và thoải mái khi cần thiết, trong khi các chi tiết đường ống phản chiếu tạo thêm dấu hiệu thiết kế độc đáo và sự thú vị về mặt thị giác. Một lớp bọc cao su dọc theo đế giữa giúp hỗ trợ và chống mài mòn. Lớp đệm The adiPRENE hấp thụ lực tác động và tối ưu hóa khả năng bật lại trong khi đế ngoài bằng cao su nhẹ mang lại lực kéo.', 3, 'Yeezy', GETDATE(), NULL, 0, 10.00),
	('Yeezy Boost 700 MNVN', 29.99, N'YEEZY BOOST 700 MNVN có phần thân trên được làm bằng polyester nhẹ với lớp phủ không đường may giúp tăng cường khả năng thở, tính linh hoạt và thoải mái. Về mặt thiết kế, cặp đôi này khác rất ít so với các sản phẩm trước đó. Màu sắc của phần trên bằng nylon được chuyển đơn giản thành “Resin”, được mô tả tốt nhất là màu xanh lục nhạt, im lặng. Phía trên, dòng chữ “700” được tô điểm đậm bằng kim loại màu bạc, phù hợp với đề can ở cả ngón chân và gót chân. Đối với phần ren và đế giữa, cả hai đều chọn màu đen sẫm; lớp đệm BOOST cũng phù hợp, mang lại vẻ ngoài gọn gàng hơn nhiều cho đế. Vật liệu phản chiếu phát ra ánh sáng trong bóng tối trên khắp các khu vực cụ thể của mẫu. Đế giữa Boost có chiều dài tối đa mang lại trải nghiệm đệm dưới chân tối ưu, trong khi đế giữa PU tăng thêm sự thoải mái và độ bền.', 3, 'Yeezy', GETDATE(), NULL, 1, 10.00),
	('Yeezy Boost 700 MNVN', 29.99, N'YEEZY BOOST 700 MNVN có phần thân trên được làm bằng polyester nhẹ với lớp phủ không đường may giúp tăng cường khả năng thở, tính linh hoạt và thoải mái. Về mặt thiết kế, cặp đôi này khác rất ít so với các sản phẩm trước đó. Màu sắc của phần trên bằng nylon được chuyển đơn giản thành “Resin”, được mô tả tốt nhất là màu xanh lục nhạt, im lặng. Phía trên, dòng chữ “700” được tô điểm đậm bằng kim loại màu bạc, phù hợp với đề can ở cả ngón chân và gót chân. Đối với phần ren và đế giữa, cả hai đều chọn màu đen sẫm; lớp đệm BOOST cũng phù hợp, mang lại vẻ ngoài gọn gàng hơn nhiều cho đế. Vật liệu phản chiếu phát ra ánh sáng trong bóng tối trên khắp các khu vực cụ thể của mẫu. Đế giữa Boost có chiều dài tối đa mang lại trải nghiệm đệm dưới chân tối ưu, trong khi đế giữa PU tăng thêm sự thoải mái và độ bền.', 3, 'Yeezy', GETDATE(), NULL, 0, 10.00),
	('Yeezy Slide', 29.99, N'YEEZY SLIDE có tính năng xốp EVA được phun để mang lại độ bền nhẹ, lớp trên cùng mềm mại ở phần lót chân mang lại sự thoải mái ngay lập tức. Đế ngoài sử dụng vị trí rãnh chiến lược để tạo sự thoải mái và lực kéo tối ưu.', 3, 'Yeezy', GETDATE(), NULL, 1, 10.00),
	('Yeezy Slide', 29.99, N'YEEZY SLIDE có tính năng xốp EVA được phun để mang lại độ bền nhẹ, lớp trên cùng mềm mại ở phần lót chân mang lại sự thoải mái ngay lập tức. Đế ngoài sử dụng vị trí rãnh chiến lược để tạo sự thoải mái và lực kéo tối ưu.', 3, 'Yeezy', GETDATE(), NULL, 0, 10.00);

UPDATE Products
SET Price = CAST(ROUND(RAND(CHECKSUM(NEWID())) * (5000000 - 500000) + 500000, 0) AS INT);



INSERT INTO ProductImages (ProductId, ImageUrl, CreatedAt)
VALUES
    (1, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/3bbecbdf584e40398446a8bf0117cf62_9366/Samba_OG_Shoes_White_B75806_01_standard.jpg', GETDATE()),
	(1, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/07567ea7d2bb425b8651a8bf0117e4f1_9366/Samba_OG_Shoes_White_B75806_06_standard.jpg', GETDATE()),
	(1, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/ec595635a2994adea094a8bf0117ef1a_9366/Samba_OG_Shoes_White_B75806_02_standard.jpg', GETDATE()),
	(1, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/97cd0902ae2e402b895aa8bf0117f98f_9366/Samba_OG_Shoes_White_B75806_03_standard.jpg', GETDATE()),
	(1, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/f9ce5733049f4ca8a93aa8bf011858bd_9366/Samba_OG_Shoes_White_B75806_09_standard.jpg', GETDATE()),
	
	(2, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/4c70105150234ac4b948a8bf01187e0c_9366/Samba_OG_Shoes_Black_B75807_01_standard.jpg', GETDATE()),
	(2, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/afa5435f1b5241eaba01a8bf01189c56_9366/Samba_OG_Shoes_Black_B75807_06_standard.jpg', GETDATE()),
	(2, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/309a0c8f53dd45d3a3bea8bf0118aa6b_9366/Samba_OG_Shoes_Black_B75807_02_standard.jpg', GETDATE()),
	(2, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a3ffa88f92a74c6d9979a8bf0118b9d0_9366/Samba_OG_Shoes_Black_B75807_03_standard.jpg', GETDATE()),
	(2, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/d0561b42bd25442e9144a8bf0119046b_9366/Samba_OG_Shoes_Black_B75807_09_standard.jpg', GETDATE()),
	
	(3, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/4edaa6d5b65a40d19f20a7fa00ea641f_9366/Stan_Smith_Shoes_White_M20325_01_standard.jpg', GETDATE()),
	(3, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/9484876cdcb94b17a496a7fa00ea6ee9_9366/Stan_Smith_Shoes_White_M20325_06_standard.jpg', GETDATE()),
	(3, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/032883d31557442c8275a347004753a4_9366/Stan_Smith_Shoes_White_M20325_02_standard_hover.jpg', GETDATE()),
	(3, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/d4dff87f03d84a4c92dca34700474f79_9366/Stan_Smith_Shoes_White_M20325_03_standard.jpg', GETDATE()),
	(3, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/bdccdf07da8044e7a3aea6a5011cd730_9366/Stan_Smith_Shoes_White_M20325_09_standard.jpg', GETDATE()),
	
	(4, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/69721f2e7c934d909168a80e00818569_9366/Stan_Smith_Shoes_White_M20324_01_standard.jpg', GETDATE()),
	(4, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/578fc42585f84690a0f0a80e008188cf_9366/Stan_Smith_Shoes_White_M20324_06_standard.jpg', GETDATE()),
	(4, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/7bc16c0933f849a1bbeba3470047af60_9366/Stan_Smith_Shoes_White_M20324_02_standard_hover.jpg', GETDATE()),
	(4, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8279e1e982284860b38da3470047ab6d_9366/Stan_Smith_Shoes_White_M20324_03_standard.jpg', GETDATE()),
	(4, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/86ed42c633404d5fb377a6a500989c17_9366/Stan_Smith_Shoes_White_M20324_09_standard.jpg', GETDATE()),
	
	(5, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/76752172861843209f02aef900fd6858_9366/NMD_R1_Shoes_White_HQ4451_01_standard.jpg', GETDATE()),
	(5, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/5597b46cc52b438998c0aef900fd74c8_9366/NMD_R1_Shoes_White_HQ4451_06_standard.jpg', GETDATE()),
	(5, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/1c3d884f0e0043408142aef900fd8116_9366/NMD_R1_Shoes_White_HQ4451_02_standard_hover.jpg', GETDATE()),
	(5, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c271388c25ab49658ceaaef900fd8d1b_9366/NMD_R1_Shoes_White_HQ4451_03_standard.jpg', GETDATE()),
	(5, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/98dbe5e6e0784717ba03aef900fdc891_9366/NMD_R1_Shoes_White_HQ4451_09_standard.jpg', GETDATE()),
	
	(6, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/f9d3ccc7a04f47f9b3b1da8a103e5715_9366/NMD_G1_Shoes_White_IF3455_01_standard.jpg', GETDATE()),
	(6, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/b8979e7c415541bea16775584be2488f_9366/NMD_G1_Shoes_White_IF3455_06_standard.jpg', GETDATE()),
	(6, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/6f3db3ec507e46648ed379c2114bba86_9366/NMD_G1_Shoes_White_IF3455_02_standard_hover.jpg', GETDATE()),
	(6, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/ef4a7655cb694876bd293707b70d312c_9366/NMD_G1_Shoes_White_IF3455_03_standard.jpg', GETDATE()),
	(6, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/749c5bab7f59420782e59966b3dedcf6_9366/NMD_G1_Shoes_White_IF3455_09_standard.jpg', GETDATE()),
	
	(7, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/b9ed1ab6b84d4efbbbe0e8d01223c704_9366/NMD_G1_Shoes_White_IE4569_01_standard.jpg', GETDATE()),
	(7, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/b469ccdc0abb4c40bdb182499d644f80_9366/NMD_G1_Shoes_White_IE4569_06_standard.jpg', GETDATE()),
	(7, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/fe540c3db62643f3842de131f29b1246_9366/NMD_G1_Shoes_White_IE4569_02_standard.jpg', GETDATE()),
	(7, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/6762915231f245e19cd8356159967c25_9366/NMD_G1_Shoes_White_IE4569_03_standard.jpg', GETDATE()),
	(7, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c8544d17e533434aafb24f819ae6db2c_9366/NMD_G1_Shoes_White_IE4569_09_standard.jpg', GETDATE()),
	
	(8, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/fe1b22491f254a3f8e4faf4701718958_9366/NMD_V3_Shoes_Grey_IF9904_01_standard.jpg', GETDATE()),
	(8, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/adc7a3b6af944e33adabaf47017190f8_9366/NMD_V3_Shoes_Grey_IF9904_06_standard.jpg', GETDATE()),
	(8, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/0afac528cafe4606b6eaaf47017198e6_9366/NMD_V3_Shoes_Grey_IF9904_02_standard_hover.jpg', GETDATE()),
	(8, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/378834b597c346aaa23eaf470171a155_9366/NMD_V3_Shoes_Grey_IF9904_03_standard.jpg', GETDATE()),
	(8, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/240def5c07a149dfac8caf470171d44a_9366/NMD_V3_Shoes_Grey_IF9904_09_standard.jpg', GETDATE()),
	
	(9, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/1876faccc13a4820a171ae8b009a01e6_9366/NMD_V3_Shoes_Black_GX2084_01_standard.jpg', GETDATE()),
	(9, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/9973d8d8e02b4e458ffbae8b009a17df_9366/NMD_V3_Shoes_Black_GX2084_06_standard.jpg', GETDATE()),
	(9, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/6a3a8b9092d04509b43bae8b009a2b1a_9366/NMD_V3_Shoes_Black_GX2084_02_standard_hover.jpg', GETDATE()),
	(9, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/689984ce2aac4f549f39ae8b009a3e62_9366/NMD_V3_Shoes_Black_GX2084_03_standard.jpg', GETDATE()),
	(9, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/917b60d0037c4c74abe4ae8b01675e5d_9366/NMD_V3_Shoes_Black_GX2084_09_standard.jpg', GETDATE()),
	
	(10, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/9356564dbc9549299132ae200019ef9b_9366/NMD_R1_Shoes_White_GW5699_01_standard.jpg', GETDATE()),
	(10, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/e80e88e01e554adfb82eae20001a3bd1_9366/NMD_R1_Shoes_White_GW5699_06_standard.jpg', GETDATE()),
	(10, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8c3be0f89637477bbf47ae20001a61a1_9366/NMD_R1_Shoes_White_GW5699_02_standard.jpg', GETDATE()),
	(10, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/76eeb74534a44310b184ae200018697d_9366/NMD_R1_Shoes_White_GW5699_03_standard.jpg', GETDATE()),
	(10, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/f0848bf633cd4b5aafcbae2000199cae_9366/NMD_R1_Shoes_White_GW5699_09_standard.jpg', GETDATE()),

	(11, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/1c0c434c-9802-4556-89c7-a8600b2828d8/air-jordan-1-low-shoes-lFCSjp.png', GETDATE()),
	(11, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/fe657d71-ee16-43ca-b7de-3e9313b288a1/air-jordan-1-low-shoes-lFCSjp.png', GETDATE()),
	(11, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/7ce75f02-661e-4726-a940-bdcaff08caab/air-jordan-1-low-shoes-lFCSjp.png', GETDATE()),
	(11, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/a21d548e-eb3d-4a1b-a086-fffc780f0e0a/air-jordan-1-low-shoes-lFCSjp.png', GETDATE()),
	(11, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/ade1053d-9b68-49dc-9eeb-278b29daa5d7/air-jordan-1-low-shoes-lFCSjp.png', GETDATE()),

	(12, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/d63cb565-a8fa-4731-89c9-144b41591c4f/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(12, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/fc70cdfe-351b-41e3-8e05-3f7614121d0b/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(12, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/247aba17-a66e-4304-91b3-8fc5bbc7451c/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(12, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/9308717c-6972-4820-bd74-04a22dc2af04/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(12, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/34555a8c-76ca-49f9-b403-88890e337f94/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),

	(13, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/b720303b-a097-4a59-98c8-fdedaf369ad6/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(13, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/46343791-01b7-473f-a694-3db507749138/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(13, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/28f35d50-c02a-443b-b8e0-de67434518a9/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(13, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/8bc3aaf6-20c9-438c-bceb-821969169387/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),
	(13, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/f99c49da-b65a-4f2f-a04f-aae8b5e27834/air-jordan-1-mid-shoes-86f1ZW.png', GETDATE()),

	(14, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/8e2656f4-79b6-4d37-93c1-ea558a1c6a6d/air-jordan-1-low-g-nrg-golf-shoes-bf4r0T.png', GETDATE()),
	(14, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/471d20e6-0e19-4f18-a19f-2720112dfb92/air-jordan-1-low-g-nrg-golf-shoes-bf4r0T.png', GETDATE()),
	(14, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/726568ab-ce89-4345-be6c-e6eb95f90b7d/air-jordan-1-low-g-nrg-golf-shoes-bf4r0T.png', GETDATE()),
	(14, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/bb661baf-eb54-4038-b458-087e7cc35fce/air-jordan-1-low-g-nrg-golf-shoes-bf4r0T.png', GETDATE()),
	(14, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/1d1abbe6-fdc0-4be7-9a4c-a19617323d54/air-jordan-1-low-g-nrg-golf-shoes-bf4r0T.png', GETDATE()),

	(15, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/cd9a47bf-aa7b-43fc-a6ae-c3350d01696f/air-jordan-1-low-se-older-shoes-25Z2Mg.png', GETDATE()),
	(15, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/003804cf-46dd-44ca-88a6-5c8a82f6c446/air-jordan-1-low-se-older-shoes-25Z2Mg.png', GETDATE()),
	(15, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/717bbec6-595d-414c-887a-cf5037aac0a1/air-jordan-1-low-se-older-shoes-25Z2Mg.png', GETDATE()),
	(15, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/0dd5f003-15e9-465a-8e5f-453117ac135d/air-jordan-1-low-se-older-shoes-25Z2Mg.png', GETDATE()),
	(15, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/78ed8f0b-7d5e-4e25-9e32-e71de33b86e2/air-jordan-1-low-se-older-shoes-25Z2Mg.png', GETDATE()),

	(16, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/fb7eda3c-5ac8-4d05-a18f-1c2c5e82e36e/blazer-mid-77-vintage-shoes-dNWPTj.png', GETDATE()),
	(16, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/6eea83ac-7862-459e-abf5-2f566e2f0ac1/blazer-mid-77-vintage-shoes-dNWPTj.png', GETDATE()),
	(16, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/cacf1d36-8769-41b2-8616-a351efae9ce5/blazer-mid-77-vintage-shoes-dNWPTj.png', GETDATE()),
	(16, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/ef4dbed6-c621-4879-8db3-f87296bfb570/blazer-mid-77-vintage-shoes-dNWPTj.png', GETDATE()),
	(16, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/2d9fe33e-9a31-4e7b-9d7c-c4ecf7abd2bb/blazer-mid-77-vintage-shoes-dNWPTj.png', GETDATE()),

	(17, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/447931e0-979b-4c2a-83b2-3e25b59c7308/blazer-phantom-low-shoes-W3wHpj.png', GETDATE()),
	(17, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/0b611fd7-4e2f-45df-9a27-b76def539364/blazer-phantom-low-shoes-W3wHpj.png', GETDATE()),
	(17, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/247dca21-6da7-423d-ab25-e64df8535101/blazer-phantom-low-shoes-W3wHpj.png', GETDATE()),
	(17, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/84e9724c-ece9-494f-899c-37e93f2418de/blazer-phantom-low-shoes-W3wHpj.png', GETDATE()),
	(17, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/745a8e69-b6b4-4763-bf89-9c51bbd9dd78/blazer-phantom-low-shoes-W3wHpj.png', GETDATE()),

	(18, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/5e7687f1-c13e-4bac-8ffa-a6f863ae9157/dunk-high-retro-shoe-DdRmMZ.png', GETDATE()),
	(18, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/45bb2189-245f-4b78-8cad-485bbc723c39/dunk-high-retro-shoe-DdRmMZ.png', GETDATE()),
	(18, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/332da330-4bb3-42d3-9123-5c7e64789342/dunk-high-retro-shoe-DdRmMZ.png', GETDATE()),
	(18, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/ac4c2d4d-06fc-4e92-9fec-c78cbb110c5f/dunk-high-retro-shoe-DdRmMZ.png', GETDATE()),
	(18, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/4a789a9d-dc8b-420f-ac4e-4dcc4a232c54/dunk-high-retro-shoe-DdRmMZ.png', GETDATE()),

	(19, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/06bdcd0d-8d6a-4225-8f55-c6f1ca1f5c80/dunk-low-se-older-shoes-836LrT.png', GETDATE()),
	(19, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/50f1be79-e3d6-47c7-83b2-e7a3ab01fed2/dunk-low-se-older-shoes-836LrT.png', GETDATE()),
	(19, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/b4c8843e-31ac-4979-bb28-f2f6c84ef703/dunk-low-se-older-shoes-836LrT.png', GETDATE()),
	(19, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/b0ac05d9-1bcc-4f00-acee-70653f0fdd64/dunk-low-se-older-shoes-836LrT.png', GETDATE()),
	(19, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/09cc2934-758f-4305-a16a-35c35c547088/dunk-low-se-older-shoes-836LrT.png', GETDATE()),

	(20, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/f2a9595e-d7b2-4b43-a146-f4b8a9d0bc70/dunk-low-older-shoes-C7T1cx.png', GETDATE()),
	(20, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/a78647c2-e6cb-4040-bad8-289ff2b604b8/dunk-low-older-shoes-C7T1cx.png', GETDATE()),
	(20, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/3e2f09f1-054a-4579-aac0-e4de39f5bd96/dunk-low-older-shoes-C7T1cx.png', GETDATE()),
	(20, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/72936e14-5b8f-4adc-a39a-4f1ca60cf482/dunk-low-older-shoes-C7T1cx.png', GETDATE()),
	(20, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/889d8231-92de-44b2-87c8-0a969ee3f819/dunk-low-older-shoes-C7T1cx.png', GETDATE()),

	(21, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/49852affde7f49dcb970a9ae017c284e_9366/YEEZY_BOOST_350_V2_White_EF2905_01_standard.jpg', GETDATE()),
	(21, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/210c8691de0e4b10895ea9ae017c25ab_9366/YEEZY_BOOST_350_V2_White_EF2905_01_standard1_hover.jpg', GETDATE()),
	(21, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/265347698c4c46ee9fe9a9ae017c25f4_9366/YEEZY_BOOST_350_V2_White_EF2905_01_standard2.jpg', GETDATE()),
	(21, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/57d7b527ef7744ed9b99a9ae017c272c_9366/YEEZY_BOOST_350_V2_White_EF2905_02_standard.jpg', GETDATE()),
	(21, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/d0684da71c914d68b233a9ae017c29cb_9366/YEEZY_BOOST_350_V2_White_EF2905_03_standard.jpg', GETDATE()),

	(22, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a51ee1fd15a343e9b4649d7679fe8ef1_9366/YZY_FOAM_RNR_Grey_IE4931_01_standard.jpg', GETDATE()),
	(22, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/9baaf56eb56941feba7a4e3ae6f83f91_9366/YZY_FOAM_RNR_Grey_IE4931_01_standard1_hover.jpg', GETDATE()),
	(22, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/038d28a9ba9441009bbc0a45eda1a103_9366/YZY_FOAM_RNR_Grey_IE4931_01_standard2.jpg', GETDATE()),
	(22, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a180757c66064fac9b9613b66b452b8c_9366/YZY_FOAM_RNR_Grey_IE4931_02_standard.jpg', GETDATE()),
	(22, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c04f8fb0e2a44b0e8ecf990cc4918aab_9366/YZY_FOAM_RNR_Grey_IE4931_03_standard.jpg', GETDATE()),

	(23, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/cb7c33b2d12f4c0fab07ae9e01333e64_9366/YZY_FOAM_RNR_ADULTS_Grey_HP8739_01_standard.jpg', GETDATE()),
	(23, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/e6b7a37d6a4e4d45b2c4ae9e01333734_9366/YZY_FOAM_RNR_ADULTS_Grey_HP8739_01_standard1_hover.jpg', GETDATE()),
	(23, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/47be766db64246c5a5a4ae9e01333617_9366/YZY_FOAM_RNR_ADULTS_Grey_HP8739_01_standard2.jpg', GETDATE()),
	(23, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/2834dda2af844a0cb95cae9e01333a62_9366/YZY_FOAM_RNR_ADULTS_Grey_HP8739_02_standard.jpg', GETDATE()),
	(23, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/d35d8372f5a14939b091ae9e013336c7_9366/YZY_FOAM_RNR_ADULTS_Grey_HP8739_03_standard.jpg', GETDATE()),

	(24, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/3f30703f195a4333aa3b9fc125b58b05_9366/YEEZY_BOOST_350_V2_Grey_HQ4540_01_standard.jpg', GETDATE()),
	(24, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/472553c2d42947ca976efe17431ea189_9366/YEEZY_BOOST_350_V2_Grey_HQ4540_01_standard1_hover.jpg', GETDATE()),
	(24, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/b3c8af7edc1243b88a047ff27ddf281d_9366/YEEZY_BOOST_350_V2_Grey_HQ4540_01_standard2.jpg', GETDATE()),
	(24, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/cd88366305fd4d1195ab12d3ae4d1e3f_9366/YEEZY_BOOST_350_V2_Grey_HQ4540_02_standard.jpg', GETDATE()),
	(24, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/0723a46cbbf24cee8dd1fd6612629bba_9366/YEEZY_BOOST_350_V2_Grey_HQ4540_03_standard.jpg', GETDATE()),

	(25, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/70527924db74408dad17a90b0158e203_9366/YEEZY_500_Black_F36640_01_standard.jpg', GETDATE()),
	(25, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/e18ecf82eeea4a479338a90b0158e132_9366/YEEZY_500_Black_F36640_01_standard1_hover.jpg', GETDATE()),
	(25, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/0288d7e7818a47fe8a24a90b0158dff3_9366/YEEZY_500_Black_F36640_01_standard2.jpg', GETDATE()),
	(25, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/1c8676eef65f4201a6c1a90b0158dd54_9366/YEEZY_500_Black_F36640_02_standard.jpg', GETDATE()),
	(25, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/6220ea37bf1e4ba28a3ea90b0158ddc7_9366/YEEZY_500_Black_F36640_03_standard.jpg', GETDATE()),

	(26, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/28664520320a449081ff724221f5b573_9366/YEEZY_500_White_ID5114_01_standard.jpg', GETDATE()),
	(26, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/460cd5ea46eb448fa2e93dbf78099432_9366/YEEZY_500_White_ID5114_01_standard1_hover.jpg', GETDATE()),
	(26, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/727a023a21ec4ffa8a21dbfcc2e4f876_9366/YEEZY_500_White_ID5114_01_standard2.jpg', GETDATE()),
	(26, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/16373331577b4c4bbeabd33f1559f0a5_9366/YEEZY_500_White_ID5114_02_standard.jpg', GETDATE()),
	(26, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/f5205622d3e54759affac1fa0ac2b335_9366/YEEZY_500_White_ID5114_03_standard.jpg', GETDATE()),

	(27, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/5382869cfa9343d2a3a0adf901694e7d_9366/YEEZY_700_MNVN_Grey_GW9524_01_standard.jpg', GETDATE()),
	(27, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/88f65fb3ac344912874eadf901694ed7_9366/YEEZY_700_MNVN_Grey_GW9524_01_standard1_hover.jpg', GETDATE()),
	(27, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/63d8858535d646d19b4aadf901694d73_9366/YEEZY_700_MNVN_Grey_GW9524_01_standard2.jpg', GETDATE()),
	(27, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/9ba0c28dd2784cfa94ddadf901694d52_9366/YEEZY_700_MNVN_Grey_GW9524_02_standard.jpg', GETDATE()),
	(27, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/9289ef87da2a4035ab20adf90169504e_9366/YEEZY_700_MNVN_Grey_GW9524_03_standard.jpg', GETDATE()),

	(28, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/3a4f528ebd224f0f8da2af10013b9015_9366/YZY_700_MNVN_Yellow_IG4798_01_standard.jpg', GETDATE()),
	(28, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/f1b2dd0a6ee44ae89670af10013b915b_9366/YZY_700_MNVN_Yellow_IG4798_01_standard1_hover.jpg', GETDATE()),
	(28, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/86058b1059f749f69746af10013b9184_9366/YZY_700_MNVN_Yellow_IG4798_01_standard2.jpg', GETDATE()),
	(28, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8a5c00b8d59b4775847baf10013b905b_9366/YZY_700_MNVN_Yellow_IG4798_02_standard.jpg', GETDATE()),
	(28, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/0d2ebc635a2742ea90f9af10013b9216_9366/YZY_700_MNVN_Yellow_IG4798_03_standard.jpg', GETDATE()),

	(29, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/b184431de8ad48a2a071a6ff27a353f8_9366/YEEZY_SLIDE_Grey_ID4132_01_standard.jpg', GETDATE()),
	(29, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8591ded3ca594974a2e30361fee52cf9_9366/YEEZY_SLIDE_Grey_ID4132_01_standard1_hover.jpg', GETDATE()),
	(29, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8aa5d2dfaedd477b8d488366b8f94f45_9366/YEEZY_SLIDE_Grey_ID4132_01_standard2.jpg', GETDATE()),
	(29, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/cde79907629a47a8a0907f084b78b5b1_9366/YEEZY_SLIDE_Grey_ID4132_02_standard.jpg', GETDATE()),
	(29, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/cf2ff13c763f46baad0c0996db7e2e06_9366/YEEZY_SLIDE_Grey_ID4132_03_standard.jpg', GETDATE()),

	(30, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/9993e8950bf547c9813adcac89b9ff90_9366/YEEZY_SLIDE_Blue_ID4133_01_standard.jpg', GETDATE()),
	(30, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c4cd2eccbec541ad89faf0fac14cf474_9366/YEEZY_SLIDE_Blue_ID4133_01_standard1_hover.jpg', GETDATE()),
	(30, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/340fc8ec37c5426fb0ff2b77afd5b6f0_9366/YEEZY_SLIDE_Blue_ID4133_01_standard2.jpg', GETDATE()),
	(30, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/7ff7a791e2c04a88ab189226849066fc_9366/YEEZY_SLIDE_Blue_ID4133_02_standard.jpg', GETDATE()),
	(30, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/b1830dfb79a745438d0eb81f709dc0b8_9366/YEEZY_SLIDE_Blue_ID4133_03_standard.jpg', GETDATE());


INSERT INTO ProductSizes (ProductId, Size, StockQuantity) VALUES
    (1, 35, 50), (1, 36, 30), (1, 37, 20), (1, 38, 15), (1, 39, 10), (1, 40, 40), (1, 41, 25), (1, 42, 35), (1, 43, 45), (1, 44, 55), (1, 45, 5),
    (2, 35, 60), (2, 36, 40), (2, 37, 30), (2, 38, 20), (2, 39, 10), (2, 40, 50), (2, 41, 35), (2, 42, 45), (2, 43, 25), (2, 44, 55), (2, 45, 15),
    (3, 35, 70), (3, 36, 50), (3, 37, 40), (3, 38, 30), (3, 39, 20), (3, 40, 60), (3, 41, 45), (3, 42, 55), (3, 43, 35), (3, 44, 65), (3, 45, 25),
    (4, 35, 80), (4, 36, 60), (4, 37, 50), (4, 38, 40), (4, 39, 30), (4, 40, 70), (4, 41, 55), (4, 42, 65), (4, 43, 45), (4, 44, 75), (4, 45, 35),
    (5, 35, 90), (5, 36, 70), (5, 37, 60), (5, 38, 50), (5, 39, 40), (5, 40, 65), (5, 41, 75), (5, 42, 55), (5, 43, 85), (5, 44, 45),
    (6, 35, 100), (6, 36, 80), (6, 37, 70), (6, 38, 50), (6, 40, 90), (6, 41, 75), (6, 42, 85), (6, 43, 65), (6, 44, 95), (6, 45, 55),
    (7, 35, 110), (7, 36, 90), (7, 37, 80), (7, 38, 70), (7, 39, 60), (7, 40, 100), (7, 41, 85), (7, 42, 95), (7, 43, 75), (7, 44, 105), (7, 45, 65),
    (8, 35, 120), (8, 36, 100), (8, 37, 90), (8, 38, 80), (8, 39, 70), (8, 40, 110), (8, 41, 95), (8, 42, 105), (8, 43, 85), (8, 44, 115), (8, 45, 75),
    (9, 35, 130), (9, 36, 110), (9, 37, 100), (9, 38, 90), (9, 39, 80), (9, 40, 120), (9, 41, 105), (9, 42, 115), (9, 43, 95), (9, 44, 125), (9, 45, 85),
    (10, 35, 140), (10, 36, 120), (10, 37, 110), (10, 38, 100), (10, 39, 90), (10, 40, 130), (10, 41, 115), (10, 42, 125), (10, 43, 105), (10, 44, 135), (10, 45, 95),
    (11, 35, 150), (11, 36, 130), (11, 37, 120), (11, 38, 110), (11, 39, 100), (11, 40, 140), (11, 41, 125), (11, 42, 135), (11, 43, 115), (11, 44, 145), (11, 45, 105),
    (12, 35, 160), (12, 36, 140), (12, 37, 130), (12, 38, 120), (12, 39, 110), (12, 40, 150), (12, 41, 135), (12, 42, 145), (12, 43, 125), (12, 44, 155), (12, 45, 115),
    (13, 35, 170), (13, 36, 150), (13, 37, 140), (13, 38, 130), (13, 39, 120), (13, 40, 160), (13, 41, 145), (13, 42, 155), (13, 43, 135), (13, 44, 165), (13, 45, 125),
    (14, 35, 180), (14, 36, 160), (14, 37, 150), (14, 38, 140), (14, 39, 130), (14, 40, 170), (14, 41, 155), (14, 42, 165), (14, 43, 145), (14, 44, 175), (14, 45, 135),
    (15, 35, 190), (15, 36, 170), (15, 37, 160), (15, 38, 150), (15, 39, 140), (15, 40, 180), (15, 41, 165), (15, 42, 175), (15, 43, 155), (15, 44, 185), (15, 45, 145),
    (16, 35, 200), (16, 36, 180), (16, 37, 170), (16, 38, 160), (16, 39, 150), (16, 40, 190), (16, 41, 175), (16, 42, 185), (16, 43, 165), (16, 44, 195), (16, 45, 155),
    (17, 35, 210), (17, 36, 190), (17, 37, 180), (17, 38, 170), (17, 39, 160), (17, 40, 200), (17, 41, 185), (17, 42, 195), (17, 43, 175), (17, 44, 205), (17, 45, 165),
    (18, 35, 220), (18, 36, 200), (18, 37, 190), (18, 38, 180), (18, 39, 170), (18, 40, 210), (18, 41, 195), (18, 42, 205), (18, 43, 185), (18, 44, 215), (18, 45, 175),
    (19, 35, 230), (19, 36, 210), (19, 37, 200), (19, 38, 190), (19, 39, 180), (19, 40, 220), (19, 41, 205), (19, 42, 215), (19, 43, 195), (19, 44, 225), (19, 45, 185),
    (20, 35, 230), (20, 36, 210), (20, 37, 200), (20, 38, 190), (20, 39, 180), (20, 40, 220), (20, 41, 205), (20, 42, 215), (20, 43, 195), (20, 44, 225), (20, 45, 185),
    (30, 35, 130), (30, 36, 120), (30, 37, 110), (30, 38, 100), (30, 39, 90), (30, 40, 130), (30, 41, 115), (30, 42, 125), (30, 43, 105), (30, 44, 135), (30, 45, 95);

	-- Chọn dữ liệu từ bảng Users
SELECT * FROM Users;
GO

-- Chọn dữ liệu từ bảng Categories
SELECT * FROM Categories;
GO

-- Chọn dữ liệu từ bảng Products
SELECT * FROM Products;
GO

-- Chọn dữ liệu từ bảng ProductImages
SELECT * FROM ProductImages;
GO

-- Chọn dữ liệu từ bảng ProductSizes
SELECT * FROM ProductSizes;
GO

-- Chọn dữ liệu từ bảng Cart
SELECT * FROM Cart;
GO


SELECT * FROM CartItems;

