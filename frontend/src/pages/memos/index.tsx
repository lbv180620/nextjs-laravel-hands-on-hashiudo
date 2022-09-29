import { AxiosError, AxiosResponse } from "axios";
import { NextPage } from "next";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";

import { useUserState } from "@/atoms";
import { Layout } from "@/components/templates";
import axios from "@/libs/axios";
import { MemoResourceType, MemoType } from "@/types";

//* dummy date
// const tempMemos: MemoType[] = [
//   {
//     title: "仮のタイトル1",
//     body: "仮のメモの内容1",
//   },
//   {
//     title: "仮のタイトル2",
//     body: "仮のメモの内容2",
//   },
//   {
//     title: "仮のタイトル3",
//     body: "仮のメモの内容3",
//   },
//   {
//     title: "仮のタイトル4",
//     body: "仮のメモの内容4",
//   },
//   {
//     title: "仮のタイトル5",
//     body: "仮のメモの内容5",
//   },
// ];

const MemoPage: NextPage = () => {
  //* router
  const router = useRouter();

  //* local state
  const [memos, setMemos] = useState<MemoType[]>([]);

  //* global state
  const { user } = useUserState();

  //* DidMount
  useEffect(() => {
    // 未ログインの場合、ログインページに遷移
    if (!user) {
      void (async () => {
        await router.push("/");
      })();
    }

    void (async () => {
      await axios
        .get("/api/memos")
        .then((res: AxiosResponse<MemoResourceType>) => {
          console.log(res.data);
          setMemos(res.data.data);
        })
        .catch((err: AxiosError) => {
          console.log(err.response);
        });
    })();
  }, [router, user]);

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
