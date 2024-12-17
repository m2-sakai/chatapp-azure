import { useEffect, useRef, useState } from 'react';
import { json, redirect, useLoaderData } from '@remix-run/react';
import { Button } from '../components/ui/button';
import { ChatMessage } from '../features/chats/model/ChatMessage';

export const clientLoader = async () => {
  try {
    const email = localStorage.getItem('email');
    const response = await fetch(`http://localhost:7147/api/GetUser?email=${email}`);

    if (!response.ok) {
      console.error(`Failed to fetch user data: ${response.status}`);
      return redirect(`/`);
    }
    const userData = await response.json();

    return json(userData);
  } catch (error) {
    console.error(`There was an error fetching the user data: ${error}`);
    return redirect(`/`);
  }
};

export default function Chat() {
  const { userId, name } = useLoaderData<typeof clientLoader>();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const socketRef = useRef<WebSocket | null>(null);

  useEffect(() => {
    const negotiateAndConnect = async () => {
      try {
        const response = await fetch('http://localhost:7147/api/GetToken');
        const { url } = await response.json();

        const websocket = new WebSocket(url);
        socketRef.current = websocket;

        websocket.onopen = () => {
          console.log('WebSocket接続がオープンしました。');
        };

        websocket.onmessage = (event) => {
          const messageData = JSON.parse(event.data);
          console.log(messageData);
          setMessages((prevMessages) => [...prevMessages, messageData]);
        };
      } catch (error) {
        console.error('WebSocket接続中にエラーが発生しました:', error);
      }
    };

    negotiateAndConnect();

    return () => {
      if (socketRef.current) {
        socketRef.current.close();
      }
    };
  }, []);

  const sendMessage = () => {
    if (socketRef.current && socketRef.current.readyState === WebSocket.OPEN) {
      const message: ChatMessage = {
        id: Date.now(),
        content: input,
        senderId: userId,
        timestamp: new Date().toISOString(),
      };

      socketRef.current.send(JSON.stringify(message));
      setInput('');
    }
  };

  return (
    <div className='flex flex-col justify-between h-screen'>
      <div className='p-4 bg-blue-600 text-white'>チャット - {name}</div>

      <div className='flex-grow overflow-y-auto p-4'>
        {messages.map((message) => (
          <div key={message.id} className={`flex ${message.senderId === userId ? 'justify-start' : 'justify-end'} mb-2`}>
            <div className={`rounded-lg p-2 max-w-xs shadow ${message.senderId === userId ? 'bg-gray-300' : 'bg-blue-500 text-white'}`}>{message.content}</div>
          </div>
        ))}
      </div>

      <div className='flex p-4 bg-gray-100'>
        <input type='text' className='w-full p-2 border rounded-lg' value={input} onChange={(e) => setInput(e.target.value)} placeholder='メッセージを入力...' />
        <Button onClick={sendMessage}>送信</Button>
      </div>
    </div>
  );
}
