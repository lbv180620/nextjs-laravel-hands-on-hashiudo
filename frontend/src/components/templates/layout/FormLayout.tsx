import { memo, FC, ReactNode } from "react";

//* props type
type PropsType = {
  title: string;
  children: ReactNode;
};

export const FormLayout: FC<PropsType> = memo(({ title, children }) => {
  return (
    <div className="mx-auto w-2/3 py-24">
      <div className="mx-auto w-1/2 rounded-2xl border-2 px-12 py-16">
        <h3 className="mb-10 text-center text-2xl">{title}</h3>
        {children}
      </div>
    </div>
  );
});
