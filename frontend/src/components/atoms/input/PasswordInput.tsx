import { FC, memo } from 'react';

import { RequiredMark } from '../mark/RequiredMark';

export const PasswordInput: FC = memo(() => {
  return (
    <div className="mb-5">
      <div className="my-2 flex justify-start">
        <p>パスワード</p>
        <RequiredMark />
      </div>
      <small className="mb-2 block text-gray-500">8文字以上の半角英数字で入力してください</small>
      <input className="w-full rounded-md border p-2 outline-none" type="password" name="password" />
    </div>
  );
});
