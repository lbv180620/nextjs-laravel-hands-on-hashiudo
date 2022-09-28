import { memo, FC, ReactNode } from "react";

import { PrimaryButton } from "@/components/atoms";

//* props type
type PropsType = {
  title: string;
  btnTitle: string;
  children: ReactNode;
  onClick: () => Promise<void>;
  message?: string | undefined;
};

export const FormLayout: FC<PropsType> = memo((props) => {
  //* props
  const { title, btnTitle, children, onClick, message } = props;

  return (
    <div className="mx-auto w-2/3 py-24">
      <div className="mx-auto w-1/2 rounded-2xl border-2 px-12 py-16">
        <h3 className="mb-10 text-center text-2xl">{title}</h3>
        {children}
        <PrimaryButton text={btnTitle} onClick={onClick} message={message} />
      </div>
    </div>
  );
});
