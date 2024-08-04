import Header from './Header';
import Footer from '../Footer';

function DefaultLayout({ children, onSearch }) {
    return (
        <div>
            <Header onSearch={onSearch} />
            <div className="main">{children}</div>
            <Footer />
        </div>
    );
}

export default DefaultLayout;  // Đây là export mặc định
