import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL } from "../config";
import ButtonAction from "./ui/ButtonAction";
import { MdDelete, MdEditSquare } from "react-icons/md";
import Button from "./ui/Button";
import { RiApps2AddFill } from "react-icons/ri";
import Swal from "sweetalert2";

const SupportedAreaList = () => {
  const [areas, setAreas] = useState([]);

  //fetch all supported areas
  const fetchAreas = async () => {
    try {
      const res = await axios.get(`${API_URL}/supported-area`);
      setAreas(res.data.data);
    } catch (error) {
      console.error(
        "Error fetching data",
        error.response?.data?.message || error.message
      );
    }
  };

  //delete a supported area
  const handleDeleteArea = async (id) => {
    // Menampilkan konfirmasi sebelum melanjutkan penghapusan
    const result = await Swal.fire({
      title: "Are you sure?",
      text: "You won't be able to revert this!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Yes, delete it!",
      cancelButtonText: "Cancel",
      reverseButtons: true,
    });

    if (result.isConfirmed) {
      try {
        await axios.delete(`${API_URL}/supported-area/${id}`);
        Swal.fire(
          "Deleted!",
          "The supported area has been deleted.",
          "success"
        );
        fetchAreas();
      } catch (error) {
        console.error(
          "Failed to delete supported area:",
          error.response?.data?.message || error.message
        );
        Swal.fire(
          "Failed!",
          "There was an error while deleting the area.",
          "error"
        );
      }
    } else {
      Swal.fire("Cancelled", "Your supported area is safe.", "info");
    }
  };

  useEffect(() => {
    fetchAreas();
  }, []);

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-4">Supported Area</h2>
      <Button
        text="Add New"
        to="/supported/area/add"
        iconPosition="left"
        icon={<RiApps2AddFill />}
        width={"w-[120px]"}
      />

      <div className="mt-5 overflow-x-auto bg-white rounded-xl p-4">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm">
              <th className="px-4 py-2 border-b">No</th>
              <th className="px-4 py-2 border-b">Postal Code</th>
              <th className="px-4 py-2 border-b">City</th>
              <th className="px-4 py-2 border-b">State</th>
              <th className="px-4 py-2 border-b">Actions</th>
            </tr>
          </thead>
          <tbody>
            {areas.length > 0 ? (
              areas.map((area, index) => (
                <tr key={area.id} className="text-sm">
                  <td className="px-4 py-2 border-b">{index + 1}</td>
                  <td className="px-4 py-2 border-b">{area.postal_code}</td>
                  <td className="px-4 py-2 border-b">{area.city}</td>
                  <td className="px-4 py-2 border-b">{area.state}</td>
                  <td className="px-4 py-2 border-b">
                    <div className="flex gap-x-2">
                      <ButtonAction
                        to={`/supported/area/edit/${area.id}`}
                        icon={<MdEditSquare />}
                        className={"bg-orange-600 hover:bg-orange-700"}
                      />
                      <ButtonAction
                        onClick={() => handleDeleteArea(area.id)}
                        icon={<MdDelete />}
                        className={"bg-red-600 hover:bg-red-700"}
                      />
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td
                  colSpan="4"
                  className="px-4 py-2 text-center text-gray-500 text-sm"
                >
                  Belum ada data
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default SupportedAreaList;
