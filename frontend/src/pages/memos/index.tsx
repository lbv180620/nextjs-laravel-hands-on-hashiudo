import { NextPage } from 'next';
import { useRouter } from 'next/router';

import { MemoType } from '@/types';

//* dummy date
const tempMemos: MemoType[] = [
  {
    title: '仮のタイトル1',
    body: '仮のメモの内容1',
  },
  {
    title: '仮のタイトル2',
    body: '仮のメモの内容2',
  },
  {
    title: '仮のタイトル3',
    body: '仮のメモの内容3',
  },
  {
    title: '仮のタイトル4',
    body: '仮のメモの内容4',
  },
  {
    title: '仮のタイトル5',
    body: '仮のメモの内容5',
  },
];

const MemoPage: NextPage = () => {
  //* router
  const router = useRouter();

  return (
    <div className="mx-auto mt-32 w-2/3">
      <div className="mx-auto w-1/2 text-center">
        <button
          className="mb-12 rounded-3xl bg-blue-500 py-3 px-10 text-xl text-white drop-shadow-md hover:bg-blue-400"
          onClick={() => router.push('/memos/post')}
          // onClick={() => void (async () => router.push('/memos/post'))()}
        >
          メモを追加する
        </button>
      </div>

      <div className="mt-3">
        <div className="mx-auto grid w-2/3 grid-cols-2 gap-4  ">
          {tempMemos?.map((memo: MemoType, idx) => (
            <div className="mb-5 bg-gray-100 p-4 shadow-lg" key={idx.toString()}>
              <p className="mb-1 text-lg font-bold">{memo.title}</p>
              <p className="">{memo.body}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default MemoPage;
