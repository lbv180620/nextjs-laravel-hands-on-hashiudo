import { ChangeEvent, FC, memo } from "react";

import { RequiredMark } from "../mark/RequiredMark";

//* props type
type PropsType = {
  text: string;
  name: string;
  value: string;
  onChange: (e: ChangeEvent<HTMLInputElement>) => void;
  message: string | undefined;
};

export const PrimaryInput: FC<PropsType> = memo(({ text, name, value, onChange, message }) => {
  return (
    <div className="mb-5">
      <div className="my-2 flex justify-start">
        <p>{text}</p>
        <RequiredMark />
      </div>
      <input className="w-full rounded-md border p-2 outline-none" name={name} value={value} onChange={onChange} />
      {message && <p className="py-3 text-red-500">{message}</p>}
    </div>
  );
});
