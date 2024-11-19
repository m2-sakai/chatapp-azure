import type { MetaFunction } from '@remix-run/node';
import { Button } from '~/components/ui/button';
import { Link } from '@remix-run/react';

export const meta: MetaFunction = () => {
  return [{ title: 'SVB向け標準化ポータル' }, { name: 'description', content: 'SVB向け標準化ポータル' }];
};

export default function Test() {
  return (
    <div className='font-sans p-4'>
      <h1 className='text-3xl'>SVB向け標準化ポータル(テストページ)</h1>
      <br />
      <Link to='/'>
        <Button>戻る</Button>
      </Link>
    </div>
  );
}
