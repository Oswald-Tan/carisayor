import PropTypes from "prop-types";

const Card = ({ title, count, icon, iconColor }) => {
  return (
    <div className="flex items-center justify-between p-5 bg-white rounded-lg">
      <div>
        <h5 className="text-sm text-gray-700">{title}</h5>
        <p className="text-2xl font-bold text-gray-900">{count}</p>
      </div>
      <div className={`text-2xl ${iconColor}`}>{icon}</div>
    </div>
  );
};

Card.propTypes = {
  title: PropTypes.string.isRequired,
  count: PropTypes.number.isRequired,
  icon: PropTypes.element.isRequired,
  iconColor: PropTypes.string,
};

Card.defaultProps = {
    iconColor: "text-blue-500",
  };

export default Card;
