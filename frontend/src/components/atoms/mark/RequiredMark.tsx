import { FC, memo } from "react";

export const RequiredMark: FC = memo(() => {
  return (
    <p className="ml-2 rounded-full bg-red-400 py-1 px-2 text-xs text-gray-50">
      必須
    </p>
  );
});
