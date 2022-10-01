import { FC, memo, ReactNode } from "react";

import { RequiredMark } from "../mark/RequiredMark";

//* props type
type PropsType = {
  text: string;
  children: ReactNode;
  message: string | undefined;
};

export const PrimaryInput: FC<PropsType> = memo(
  ({ text, children, message }) => {
    return (
      <div className="mb-5">
        <div className="my-2 flex justify-start">
          <p>{text}</p>
          <RequiredMark />
        </div>
        {children}
        {message && <p className="py-3 text-red-500">{message}</p>}
      </div>
    );
  }
);
