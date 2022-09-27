import { ChangeEvent, FC, memo } from "react";

import { RequiredMark } from "../mark/RequiredMark";

type PropsType = {
  text: string;
  value: string;
  onChange: (e: ChangeEvent<HTMLTextAreaElement>) => void;
};

export const PrimaryTextarea: FC<PropsType> = memo(({ text, value, onChange }) => {
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
      ></textarea>
    </div>
  );
});
