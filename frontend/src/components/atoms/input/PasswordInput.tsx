import { ChangeEvent, FC, memo } from "react";

import { RequiredMark } from "../mark/RequiredMark";

type PropsType = {
  value: string;
  onChange: (e: ChangeEvent<HTMLInputElement>) => void;
};

export const PasswordInput: FC<PropsType> = memo(({ value, onChange }) => {
  return (
    <div className="mb-5">
      <div className="my-2 flex justify-start">
        <p>パスワード</p>
        <RequiredMark />
      </div>
      <small className="mb-2 block text-gray-500">8文字以上の半角英数字で入力してください</small>
      <input
        className="w-full rounded-md border p-2 outline-none"
        type="password"
        name="password"
        value={value}
        onChange={onChange}
      />
    </div>
  );
});
