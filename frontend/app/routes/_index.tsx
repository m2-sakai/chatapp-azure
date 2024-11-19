import type { MetaFunction } from '@remix-run/node';
import { Button } from '~/components/ui/button';

export const meta: MetaFunction = () => {
  return [{ title: 'Remix Chat App' }, { name: 'description', content: 'チャットアプリ' }];
};

export default function Index() {
  return (
    <div>
      <h1>Welcome to Remix</h1>
      <ul>
        <li>Awesome</li>
        <li>Features</li>
      </ul>
      <Button>Click me</Button>
    </div>
  );
}
