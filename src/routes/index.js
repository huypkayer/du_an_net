import { HasFooterLayout, NoLayout } from '../components/Layout';

import Home from '../Page/Home';
import Nike from '../Page/Nike';
import Adidas from '../Page/Adidas';
import Yeezy from '../Page/Yeezy';
import Sale from '../Page/Sale';
import Signup from '../Page/Signup';
import Signin from '../Page/Signin';
import Cart from '../Page/Cart';
import ProductDetail from '../Page/ProductDetail';
import Admin from '../Page/Admin';
import Addsp from '../Page/Addsp';
import Addnv from '../Page/Addnv';
import Profile from '../Page/Profile';
import Search from '../Page/Search';

// public
const publicRoutes = [
    { path: '/', component: Home },
    { path: '/Nike', component: Nike },
    { path: '/Adidas', component: Adidas },
    { path: '/Yeezy', component: Yeezy },
    { path: '/Sale', component: Sale },
    { path: '/Cart', component: Cart },
    { path: '/Signin', component: Signin, layout: NoLayout },
    { path: '/Signup', component: Signup, layout: NoLayout },
    { path: '/Admin', component: Admin, layout: NoLayout },
    { path: '/Addsp', component: Addsp, layout: NoLayout },
    { path: '/Addnv', component: Addnv, layout: NoLayout },
    { path: '/Profile', component: Profile },
    { path: '/productdetail/:id', component: ProductDetail },
    { path: '/Search', component: Search  },

];

const privateRoutes = [];

export { publicRoutes, privateRoutes };
