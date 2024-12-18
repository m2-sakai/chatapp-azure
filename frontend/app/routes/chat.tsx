import { useEffect, useRef, useState } from 'react';
import { redirect, useLoaderData } from '@remix-run/react';
import { Button } from '../components/ui/button';
import { ChatMessage } from '../features/chats/model/ChatMessage';
import { fetchUserData } from '../features/users/api/userapi';
import { fetchToken } from '../features/chats/api/chatapi';
import ReconnectingWebSocket from 'reconnecting-websocket';
import { v4 as uuidv4 } from 'uuid';
import useWebSocket from '../hooks/useWebsocket';

export const clientLoader = async () => {
  try {
    const email = localStorage.getItem('email');
    const userData = await fetchUserData(email);
    return {
      userData,
    };
  } catch (error) {
    console.error(`There was an error fetching the user data: ${error}`);
    return redirect(`/`);
  }
};

export default function Chat() {
  const { userData } = useLoaderData<typeof clientLoader>();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const socketRef = useRef<ReconnectingWebSocket>();
  const [url, setUrl] = useState<string | null>(null);

  useEffect(() => {
    const getToken = async () => {
      try {
        const url = await fetchToken();
        setUrl(url);
      } catch (error) {
        console.error('Error fetching token:', error);
      }
    };

    getToken();
  }, []);

  useWebSocket(url, (message: ChatMessage) => {
    setMessages((prevMessages) => [...prevMessages, message]);
  });

  const sendMessage = () => {
    if (socketRef.current && socketRef.current.readyState === WebSocket.OPEN) {
      const message: ChatMessage = {
        id: uuidv4(),
        content: input,
        senderName: userData.name,
        senderEmail: userData.email,
        timestamp: new Date().toISOString(),
      };

      socketRef.current.send(
        JSON.stringify({
          type: 'event',
          event: 'createChat',
          dataType: 'json',
          data: message,
        })
      );
      setInput('');
    }
  };

  return (
    <div className='flex flex-col justify-between h-screen'>
      <div className='p-4 bg-blue-600 text-white'>チャットルーム</div>

      <div className='flex-grow overflow-y-auto p-4'>
        {messages.map((message) => (
          <div key={message.id} className={`mb-4 ${message.senderEmail !== userData.email ? 'text-left' : 'text-right'}`}>
            <div className='font-semibold'>{message.senderName}</div>
            <div key={message.id} className={`flex ${message.senderEmail !== userData.email ? 'justify-start' : 'justify-end'} mb-2`}>
              <div className={`rounded-lg px-4 py-2 max-w-xs shadow ${message.senderEmail !== userData.email ? 'bg-gray-300' : 'bg-blue-500 text-white'}`}>{message.content}</div>
            </div>
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
