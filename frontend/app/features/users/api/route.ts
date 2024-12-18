const VITE_REST_URL = import.meta.env.VITE_REST_URL;

export const API_ROUTES = {
  INSERT_USER: `${VITE_REST_URL}/user`,
  GET_USER: `${VITE_REST_URL}/user`,
};
