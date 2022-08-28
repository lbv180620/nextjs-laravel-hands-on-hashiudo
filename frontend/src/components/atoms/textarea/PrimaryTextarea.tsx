import { FC, memo } from 'react';

import { RequiredMark } from '../mark/RequiredMark';

type PropsType = {
  text: string;
};

export const PrimaryTextarea: FC<PropsType> = memo(({ text }) => {
  return (
    <div className="mb-5">
      <div className="my-2 flex justify-start">
        <p>{text}</p>
        <RequiredMark />
      </div>
      <textarea className="w-full rounded-md border p-2 outline-none" name="body" cols={30} rows={4}></textarea>
    </div>
  );
});
