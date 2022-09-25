import { memo, FC } from 'react';

//* props type
type PropsType = {
  text: string;
};

export const PrimaryButton: FC<PropsType> = memo(({ text }) => {
  return (
    <div className="mt-12 text-center">
      <button className="cursor-pointer rounded-xl bg-gray-700 py-3 px-10 text-gray-50 drop-shadow-md hover:bg-gray-600 sm:px-20">
        {text}
      </button>
    </div>
  );
});