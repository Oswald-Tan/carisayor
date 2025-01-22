import { motion, AnimatePresence } from "framer-motion";
import PropTypes from "prop-types";

const ModalPesanan = ({ pesanan, onClose }) => {
  return (
    <AnimatePresence>
      {pesanan && (
        <motion.div
          className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-40"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.3 }}
        >
          <motion.div
            className="bg-white rounded-lg p-5 w-[500px]"
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            transition={{ duration: 0.3 }}
          >
            <h2 className="text-xl font-semibold mb-4">Detail Pesanan</h2>
            <p>
              <strong>Order Id:</strong> {pesanan.orderId || "-"}
            </p>
            <p>
              <strong>Username:</strong> {pesanan.User?.username || "-"}
            </p>
            <p>
              <strong>Nama Produk:</strong> {pesanan.nama || "-"}
            </p>
            <p>
              <strong>Harga Produk:</strong> {pesanan.hargaPoin ? (
                      <span className="px-2 py-1 text-xs text-white bg-yellow-500 rounded-lg">{`${pesanan.hargaPoin} Poin`}</span>
                    ) : pesanan.hargaRp ? (
                      <span className="px-2 py-1 text-xs text-white bg-green-500 rounded-lg">
                        Rp. {pesanan.hargaRp.toLocaleString("id-ID")}
                      </span>
                    ) : (
                      "-"
                    )}
            </p>
            <p>
              <strong>Alamat:</strong> {pesanan?.User?.user[0]?.address_line_1 || "-"} {pesanan.User.user[0]?.city || "-"}
            </p>
            <p>
              <strong>Total Bayar:</strong>{" "}
              {pesanan.hargaPoin ? (
                <span className="px-2 py-1 text-xs text-white bg-yellow-500 rounded-lg">{`${pesanan.totalBayar} Poin`}</span>
              ) : pesanan.hargaRp ? (
                <span className="px-2 py-1 text-xs text-white bg-green-500 rounded-lg">
                  Rp. {pesanan.totalBayar.toLocaleString("id-ID")}
                </span>
              ) : (
                "-"
              )}
            </p>

            <p>
              <strong>Status:</strong> {pesanan.status || "-"}
            </p>
            <button
              onClick={onClose}
              className="mt-4 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
            >
              Tutup
            </button>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

ModalPesanan.propTypes = {
  pesanan: PropTypes.object.isRequired,
  onClose: PropTypes.func.isRequired,
};

export default ModalPesanan;
