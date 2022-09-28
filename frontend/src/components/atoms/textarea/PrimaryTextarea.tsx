import { ChangeEvent, FC, memo } from "react";

import { RequiredMark } from "../mark/RequiredMark";

type PropsType = {
  text: string;
  value: string;
  onChange: (e: ChangeEvent<HTMLTextAreaElement>) => void;
  message: string | undefined;
};

export const PrimaryTextarea: FC<PropsType> = memo(({ text, value, onChange, message }) => {
  return (
    <div className="mb-5">
      <div className="my-2 flex justify-start">
        <p>{text}</p>
        <RequiredMark />
      </div>
      <textarea
        className="w-full rounded-md border p-2 outline-none"
        name="body"
        cols={30}
        rows={4}
        onChange={onChange}
        value={value}
      />
      {message && <p className="py-3 text-red-500">{message}</p>}
    </div>
  );
});
