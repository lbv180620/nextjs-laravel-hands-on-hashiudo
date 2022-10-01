import Head from "next/head";
import { FC, ReactNode } from "react";

type PropsType = {
  children: ReactNode;
  title: string;
};

export const Layout: FC<PropsType> = ({
  children,
  title = "Default title",
}) => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center font-mono">
      <Head>
        <title>{title}</title>
      </Head>

      <main className="flex w-screen flex-1 flex-col items-center justify-center">
        {children}
      </main>

      <footer className="flex h-6 w-full items-center justify-center text-sm text-gray-500">
        @Hashiudo 2022
      </footer>
    </div>
  );
};
