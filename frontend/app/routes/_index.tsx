import type { MetaFunction } from '@remix-run/node';
import { FormCn, FormControl, FormField, FormItem, FormLabel, FormMessage } from '../components/ui/form';
import { useForm } from 'react-hook-form';
import { Input } from '../components/ui/input';
import { Button } from '../components/ui/button';
import { ClientActionFunctionArgs, Form, redirect } from '@remix-run/react';
import { UserInfo } from '../features/users/model/UserInfo';
import { insertUser } from '../features/users/api/userapi';

export const meta: MetaFunction = () => {
  return [{ title: 'Remix Chat App' }, { name: 'description', content: 'チャットアプリ' }];
};

export const clientAction = async ({ request }: ClientActionFunctionArgs) => {
  const body = await request.formData();
  const email = body.get('email') as string | null;
  const name = body.get('name') as string | null;
  localStorage.setItem('email', email ?? '');

  await insertUser(name, email);
  return redirect(`/chat`);
};

export default function Index() {
  const form = useForm<UserInfo>();

  return (
    <div className='flex flex-col items-center justify-center min-h-screen bg-gray-100'>
      <h1 className='text-xl font-bold mb-6'>以下にユーザ名とメールアドレスを入力してください</h1>
      <FormCn {...form}>
        <Form method='post' className='grid gap-4'>
          <FormField
            name='name'
            render={({ field }) => (
              <FormItem>
                <FormLabel>Name</FormLabel>
                <FormControl>
                  <Input type='text' placeholder='山田 太郎' autoComplete='name' {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            name='email'
            render={({ field }) => (
              <FormItem>
                <FormLabel>Email</FormLabel>
                <FormControl>
                  <Input type='text' placeholder='sample@gmail.com' autoComplete='email' {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Button type='submit'>送信</Button>
        </Form>
      </FormCn>
    </div>
  );
}
