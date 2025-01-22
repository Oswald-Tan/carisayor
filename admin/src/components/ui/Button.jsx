import PropTypes from "prop-types";
import { Link } from "react-router-dom";

const Button = ({ text, icon, iconPosition = "left", onClick, className, to, width }) => {
  const content = (
    <>
      {iconPosition === "left" && icon && <span className="icon">{icon}</span>}
      <span className="text">{text}</span>
      {iconPosition === "right" && icon && <span className="icon">{icon}</span>}
    </>
  );

  const buttonClasses = `flex items-center justify-center gap-2 px-4 py-2 text-xs rounded-lg text-white bg-purple-500 hover:bg-purple-600 transition-all duration-150 ${className} ${width ? width : 'w-auto'}`;

  if (to) {
    return (
      <Link to={to} className={buttonClasses}>
        {content}
      </Link>
    );
  }

  return (
    <button onClick={onClick} className={buttonClasses}>
      {content}
    </button>
  );
};

Button.propTypes = {
  text: PropTypes.string.isRequired,
  icon: PropTypes.node,
  iconPosition: PropTypes.oneOf(["left", "right"]),
  onClick: PropTypes.func,
  className: PropTypes.string,
  to: PropTypes.string, // 'to' adalah prop opsional untuk link
  width: PropTypes.string, // Opsional untuk mengatur lebar button
};

export default Button;
