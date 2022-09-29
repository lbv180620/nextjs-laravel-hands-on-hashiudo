import { AxiosError, AxiosResponse } from "axios";
import { NextPage } from "next";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";

import { Loading } from "@/components/molecules";
import { Layout } from "@/components/templates";
import { useAuth } from "@/hooks";
import axios from "@/libs/axios";
import { MemoResourceType, MemoType } from "@/types";

const MemoPage: NextPage = () => {
  //* router
  const router = useRouter();

  //* local state
  const [memos, setMemos] = useState<MemoType[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  //* hooks
  const { checkLoggedIn } = useAuth();

  //* DidMount
  useEffect(() => {
    void (async () => {
      const res: boolean = await checkLoggedIn();
      if (!res) {
        await router.push("/");
        return;
      }

      await axios
        .get("/api/memos")
        .then((res: AxiosResponse<MemoResourceType>) => {
          console.log(res.data);
          setMemos(res.data.data);
        })
        .catch((err: AxiosError) => {
          console.log(err.response);
        })
        .finally(() => {
          setIsLoading(false);
        });
    })();
  }, [router, checkLoggedIn, setIsLoading]);

  //* component
  if (isLoading) return <Loading />;

  //* JSX
  return (
    <Layout title="メモ一覧">
      <div className="mx-auto mt-32 w-2/3">
        <div className="mx-auto w-1/2 text-center">
          <button
            className="mb-12 rounded-3xl bg-blue-500 py-3 px-10 text-xl text-white drop-shadow-md hover:bg-blue-400"
            onClick={() => router.push("/memos/post")}
            // onClick={() => void (async () => router.push('/memos/post'))()}
          >
            メモを追加する
          </button>
        </div>

        <div className="mt-3">
          <div className="mx-auto grid w-2/3 grid-cols-2 gap-4  ">
            {memos?.map((memo: MemoType, idx) => (
              <div className="mb-5 bg-gray-100 p-4 shadow-lg" key={idx.toString()}>
                <p className="mb-1 text-lg font-bold">{memo.title}</p>
                <p className="">{memo.body}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default MemoPage;
