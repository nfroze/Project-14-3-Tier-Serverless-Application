import { useReducer } from "react";
import { toast } from "react-toastify";

const initialState = {
  orders: [],
  order_to_be_canceled: null,
};

const actions = Object.freeze({
  GET_ORDERS: "GET_ORDERS",
  GET_ORDER_TO_BE_CANCELED: "GET_ORDER_TO_BE_CANCELED",
});

const reducer = (state, action) => {
  if (action.type == actions.GET_ORDERS) {
    return { ...state, orders: action.orders };
  }

  if (action.type == actions.GET_ORDER_TO_BE_CANCELED) {
    return { ...state, order_to_be_canceled: action.order_id };
  }
  return state;
};

const useOrders = () => {
  const [state, dispatch] = useReducer(reducer, initialState);

  const getOrders = async (user_id) => {
    toast.info("Orders not implemented in demo");
    return [];
  };

  const setOrderToBeCanceled = (order_id) => {
    dispatch({ type: actions.GET_ORDER_TO_BE_CANCELED, order_id });
  };

  const cancelOrder = async (order_id) => {
    toast.info("Order cancellation not implemented in demo");
    return { error: "Not implemented" };
  };

  return { state, getOrders, setOrderToBeCanceled, cancelOrder };
};

export default useOrders;