import express from "express";
  import { getProvinceAndCity, getCity, createProvinceAndCity, deleteProvinceAndCities } from "../../controllers/cityProvinceController.js";
  import { verifyUser } from "../../middleware/authUser.js";
  
  const router = express.Router();
  
  router.get("/", getProvinceAndCity);
  router.get("/cities", verifyUser, getCity);
  router.post("/", createProvinceAndCity);
  router.delete("/:id", deleteProvinceAndCities);
  
  export default router;
  