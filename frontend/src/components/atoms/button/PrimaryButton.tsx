import { memo, FC, ReactNode } from "react";

//* props type
type PropsType = {
  children: ReactNode;
  message?: string | undefined;
};

export const PrimaryButton: FC<PropsType> = memo(({ children, message }) => {
  return (
    <div className="mt-12 text-center">
      {message !== undefined && message && (
        <p className="py-3 text-red-500">{message}</p>
      )}
      {children}
    </div>
  );
});
