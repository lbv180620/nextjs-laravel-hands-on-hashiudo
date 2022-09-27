import { AxiosError, AxiosResponse } from "axios";
import { useRouter } from "next/router";
import { useCallback, useState } from "react";

import axios from "@/libs/axios";
import { MemoFormType } from "@/types";

export const useMemoPost = () => {
  //* router
  const router = useRouter();

  //* local state
  const [memoForm, setMemoForm] = useState<MemoFormType>({
    title: "",
    body: "",
  });

  // メモの登録
  const createMemo = useCallback(async () => {
    await axios
      // CSRF保護の初期化
      .get("/sanctum/csrf-cookie")
      .then(() => {
        // APIへのリクエスト
        axios
          .post("/api/memos", memoForm)
          .then(async (res: AxiosResponse) => {
            console.log(res.data);
            await router.push("/memos");
          })
          .catch((err: AxiosError) => {
            console.log(err.response);
          });
      });
  }, [memoForm, router]);

  return { memoForm, setMemoForm, createMemo };
};
