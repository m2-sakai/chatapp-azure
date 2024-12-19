import { useEffect, useRef, useState } from 'react';
import { redirect, useLoaderData } from '@remix-run/react';
import { Button } from '../components/ui/button';
import { ChatMessage } from '../features/chats/model/ChatMessage';
import { fetchUserData } from '../features/users/api/userapi';
import { fetchChatList, fetchToken } from '../features/chats/api/chatapi';
import ReconnectingWebSocket from 'reconnecting-websocket';
import { v4 as uuidv4 } from 'uuid';
import { API_ROUTES } from '../features/chats/api/route';
import Header from '../components/header';

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
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const fetchChats = async () => {
      const allChats = await fetchChatList();
      setMessages(allChats);
    };

    const negotiateAndConnect = async () => {
      if (socketRef.current) {
        return;
      }
      try {
        const accessToken = await fetchToken();
        const websocket = new ReconnectingWebSocket(`${API_ROUTES.WSS_CONNECT}?access_token=${accessToken}`);
        socketRef.current = websocket;

        websocket.onopen = () => {
          console.log('WebSocket接続がオープンしました。');
        };

        websocket.onmessage = (event) => {
          const messageData = JSON.parse(event.data);
          setMessages((prevMessages) => [...prevMessages, messageData]);
        };
      } catch (error) {
        console.error('WebSocket接続中にエラーが発生しました:', error);
      }
    };

    fetchChats();
    negotiateAndConnect();

    return () => {
      if (socketRef.current) {
        socketRef.current.close();
      }
    };
  }, []);

  useEffect(() => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages]);

  const sendMessage = () => {
    if (socketRef.current && socketRef.current.readyState === WebSocket.OPEN) {
      const message: ChatMessage = {
        id: uuidv4(),
        content: input,
        senderName: userData.name,
        senderEmail: userData.email,
        timestamp: new Date().toISOString(),
      };

      console.log(message);

      socketRef.current.send(JSON.stringify(message));
      setInput('');
    }
  };

  const handleKeyDown = (e: any) => {
    if (e.key === 'Enter' && e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  return (
    <>
      <Header />
      <div className='flex flex-col justify-between h-screen'>
        <div className='flex-grow overflow-y-auto p-4 mt-[50px] mb-[100px]'>
          {messages.map((message) => (
            <div key={message.id} className={`mb-4 ${message.senderEmail !== userData.email ? 'text-left' : 'text-right'}`}>
              <div className='font-semibold'>{message.senderName}</div>
              <div className={`flex ${message.senderEmail !== userData.email ? 'justify-start' : 'justify-end'} mb-2`}>
                <div className={`rounded-lg px-4 py-2 max-w-1/3 shadow break-words whitespace-pre-wrap ${message.senderEmail !== userData.email ? 'bg-gray-300' : 'bg-blue-500 text-white'}`}>
                  {message.content}
                  <div className={`text-xs ${message.senderEmail !== userData.email ? 'bg-gray-300' : 'bg-blue-500 text-white'}`}>{new Date(message.timestamp).toLocaleString()}</div>
                </div>
              </div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>

        <div className='flex p-4 bg-gray-100 fixed bottom-0 left-0 right-0'>
          <textarea className='w-full p-2 border rounded-lg' value={input} onChange={(e) => setInput(e.target.value)} onKeyDown={handleKeyDown} placeholder='メッセージを入力...' rows={2} />
          <Button className='mt-8' onClick={sendMessage}>
            送信
          </Button>
        </div>
      </div>
    </>
  );
}
