const VITE_REST_URL = import.meta.env.VITE_REST_URL;
const VITE_WSS_URL = import.meta.env.VITE_WSS_URL;

export const API_ROUTES = {
  GET_TOKEN: `${VITE_REST_URL}/token`,
  LIST_CHAT: `${VITE_REST_URL}/chats`,
  WSS_CONNECT: `${VITE_WSS_URL}/client/hubs/chatroom`,
};
