import Pesanan from "../models/pesanan.js";

export const getTotalPesananPending = async (req, res) => {
    try {
      const totalPesananPending = await Pesanan.count(
        {
          where: { status: "pending" },
        }
      ) 
  
      console.log(totalPesananPending);
  
      res.status(200).json({ totalPesananPending });
    } catch (error) {
      res.status(500).json({ message: "Error" }); 
    }
  };