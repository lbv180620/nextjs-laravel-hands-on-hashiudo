import { FC, memo } from 'react';

import { RequiredMark } from '../mark/RequiredMark';

//* props type
type PropsType = {
  text: string;
  name: string;
};

export const PrimaryInput: FC<PropsType> = memo(({ text, name }) => {
  return (
    <div className="mb-5">
      <div className="my-2 flex justify-start">
        <p>{text}</p>
        <RequiredMark />
      </div>
      <input className="w-full rounded-md border p-2 outline-none" name={name} />
    </div>
  );
});
