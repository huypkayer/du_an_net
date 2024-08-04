import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import DefaultLayout from "./components/Layout/DefaultLayout";  // Nhập khẩu đúng cách
import { publicRoutes } from "./routes";
import "./index.css";

function App() {
  const handleSearchResults = (results) => {
    // Xử lý kết quả tìm kiếm ở đây
  };

  return (
    <Router>
      <div className="App">
        <Routes>
          {publicRoutes.map((route, index) => {
            const { component: Page, layout: LayoutComponent } = route;

            const Layout = LayoutComponent || DefaultLayout;

            return (
              <Route
                key={index}
                path={route.path}
                element={
                  <Layout onSearch={handleSearchResults}>
                    <Page />
                  </Layout>
                }
              />
            );
          })}
        </Routes>
      </div>
    </Router>
  );
}

export default App;
