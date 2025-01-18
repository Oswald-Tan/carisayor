import { DateTime } from "luxon"; // Pastikan luxon sudah di-install

/**
 * Format tanggal dan jam menjadi 'DD MMMM YYYY, HH:mm:ss'.
 * @param {string} dateStr - Tanggal dalam format ISO string.
 * @returns {string} - Tanggal dalam format 'DD MMMM YYYY, HH:mm:ss'.
 */
const formatDate = (dateStr) => {
  return DateTime.fromISO(dateStr).toFormat('dd MMMM yyyy, HH:mm:ss');
};

export default formatDate;
