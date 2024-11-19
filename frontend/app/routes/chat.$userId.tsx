import { ClientLoaderFunctionArgs, json, redirect, useLoaderData } from '@remix-run/react';

export const clientLoader = async ({ params }: ClientLoaderFunctionArgs) => {
  // TODO: DBからuserIDを取得し、なければ初期画面にリダイレクト
  if (params.userId == 'dummy') {
    return redirect(`/`);
  }
  const data = {
    userId: 'aaa',
    name: 'test',
    email: 'test@xxx.com',
  };
  return json(data);
};

type Message = {
  id: number;
  text: string;
  sender: string;
};

const messages: Message[] = [
  { id: 1, text: 'こんにちは！', sender: 'you' },
  { id: 2, text: 'こんにちは！お元気ですか？', sender: 'other' },
  { id: 3, text: '元気です！今日は何をしていますか？', sender: 'you' },
  { id: 4, text: 'プログラミングをしています！', sender: 'other' },
];

export default function Chat() {
  const data = useLoaderData<typeof clientLoader>();
  return (
    <div className='flex flex-col justify-between h-screen'>
      <div className='p-4 bg-blue-600 text-white'>チャット - {data.name}</div>

      <div className='flex-grow overflow-y-auto p-4'>
        {messages.map((message) => (
          <div key={message.id} className={`flex ${message.sender === 'you' ? 'justify-start' : 'justify-end'} mb-2`}>
            <div className={`rounded-lg p-2 max-w-xs shadow ${message.sender === 'you' ? 'bg-gray-300' : 'bg-blue-500 text-white'}`}>{message.text}</div>
          </div>
        ))}
      </div>

      <div className='p-4 bg-gray-100'>
        <input type='text' className='w-full p-2 border rounded-lg' placeholder='メッセージを入力...' />
      </div>
    </div>
  );
}
