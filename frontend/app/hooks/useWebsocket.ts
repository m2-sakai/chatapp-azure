import { useEffect, useRef } from 'react';
import ReconnectingWebSocket from 'reconnecting-websocket';

type OnMessageHandler = (data: any) => void;

const useWebSocket = (url: string | null, onMessage: OnMessageHandler) => {
  const socketRef = useRef<ReconnectingWebSocket | undefined>();

  useEffect(() => {
    if (!url) return;

    const websocket = new ReconnectingWebSocket(url);
    socketRef.current = websocket;

    websocket.onopen = () => {
      // console.log('WebSocket接続がオープンしました。');
    };

    websocket.onmessage = (event: MessageEvent) => {
      const messageData = JSON.parse(event.data);
      onMessage(messageData);
    };

    return () => {
      if (socketRef.current) {
        socketRef.current.close();
      }
    };
  }, [url, onMessage]);

  return socketRef;
};

export default useWebSocket;
