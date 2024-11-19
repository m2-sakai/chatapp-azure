import type { MetaFunction } from '@remix-run/node';
import { UserInputForm } from '../components/user-input-form';

export const meta: MetaFunction = () => {
  return [{ title: 'Remix Chat App' }, { name: 'description', content: 'チャットアプリ' }];
};

export default function Index() {
  return (
    <div className='flex flex-col items-center justify-center min-h-screen bg-gray-100'>
      <h1 className='text-xl font-bold mb-6'>以下にユーザ名とメールアドレスを入力してください</h1>
      <UserInputForm />
    </div>
  );
}
