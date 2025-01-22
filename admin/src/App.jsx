import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import AdminLayout from "./layout/Layout";
import Dashboard from "./pages/Dashboard";
import Login from "./pages/Login/Login";
import Transaction from "./pages/Transaction";
import User from "./pages/Users";
import UserDetail from "./pages/UserDetail";
import UserStats from "./pages/UserStats";
import Products from "./pages/Products";
import AddUser from "./pages/AddUser";
import EditUser from "./pages/EditUser";
import AddProduct from "./pages/AddProduct";
import EditProduct from "./pages/EditProduct";
import HargaPoin from "./pages/HargaPoin";
import AddHargaPoin from "./pages/AddHargaPoin";
import EditHargaPoin from "./pages/EditHargaPoin";
import Poin from "./pages/Poin";
import AddPoin from "./pages/AddPoin";
import EditPoin from "./pages/EditPoin";
import DiscountPoin from "./pages/DiscountPoin";
import EditDiscountPoin from "./pages/EditDiscountPoin";
import AddDiscountPoin from "./pages/AddDiscountPoin";
import TopUpPoin from "./pages/TopUpPoin";
import EditTopUpPoin from "./pages/EditTopUpPoin";
import Pesanan from "./pages/Pesanan";
import EditPesanan from "./pages/EditPesanan";
import HargaPoinProduct from "./pages/HargaPoinProduct";
import EditHargaPoinProduct from "./pages/EditHargaPoinProduct";
import AddHargaPoinProduct from "./pages/AddHargaPoinProduct";
import SupporedArea from "./pages/SupportedArea";
import AddSupportedArea from "./pages/AddSupportedArea";
import EditSupportedArea from "./pages/EditSupportedArea";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />

        <Route element={<AdminLayout />}>
          <Route path="/dashboard" element={<Dashboard />} exact />
          
          <Route path="/users" element={<User />} exact />
          <Route path="/users/add" element={<AddUser />} exact />
          <Route path="/users/edit/:id" element={<EditUser />} exact />
          <Route path="/users/:id/details" element={<UserDetail />} exact />
          <Route path="/users/:id/stats" element={<UserStats />} exact />

          <Route path="/products" element={<Products />} exact />
          <Route path="/products/add" element={<AddProduct />} exact />
          <Route path="/products/edit/:id" element={<EditProduct />} exact />

          <Route path="/transaction" element={<Transaction />} exact />

          <Route path="/harga/poin" element={<HargaPoin />} exact />
          <Route path="/harga/poin/add" element={<AddHargaPoin />} exact />
          <Route path="/harga/poin/edit/:id" element={<EditHargaPoin />} exact />

          <Route path="/poin" element={<Poin />} exact />
          <Route path="/poin/add" element={<AddPoin />} exact />
          <Route path="/poin/add/discount/:id" element={<AddDiscountPoin />} exact />
          <Route path="/poin/edit/:id" element={<EditPoin />} exact />

          <Route path="/discount/poin" element={<DiscountPoin />} exact />
          <Route path="/discount/poin/add" element={<AddDiscountPoin />} exact />
          <Route path="/discount/poin/edit/:id" element={<EditDiscountPoin />} exact />

          <Route path="/topup/poin" element={<TopUpPoin />} exact />
          <Route path="/topup/poin/edit/:id" element={<EditTopUpPoin />} exact />

          <Route path="/pesanan" element={<Pesanan />} exact />
          <Route path="/pesanan/edit/:id" element={<EditPesanan />} exact />

          <Route path="/harga/poin/product" element={<HargaPoinProduct />} exact />
          <Route path="/harga/poin/product/add" element={<AddHargaPoinProduct />} exact />
          <Route path="/harga/poin/product/edit/:id" element={<EditHargaPoinProduct />} exact />
        
          <Route path="/supported/area" element={<SupporedArea />} exact />
          <Route path="/supported/area/add" element={<AddSupportedArea />} exact />
          <Route path="/supported/area/edit/:id" element={<EditSupportedArea />} exact />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
