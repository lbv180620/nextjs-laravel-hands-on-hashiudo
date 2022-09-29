import { AxiosError, AxiosResponse } from "axios";
import { useRouter } from "next/router";
import { useCallback, useState } from "react";

import axios from "@/libs/axios";
import { MemoFormType, MemoValidationResponseType, MemoValidationType } from "@/types";

export const useMemoPost = () => {
  //* router
  const router = useRouter();

  //* local state
  const [validation, setValidation] = useState<MemoValidationType>({});

  // メモの登録
  const createMemo = useCallback(
    async (data: MemoFormType) => {
      // バリデーションメッセージの初期化
      setValidation({});

      await axios
        // CSRF保護の初期化
        .get("/sanctum/csrf-cookie")
        .then(() => {
          // APIへのリクエスト
          axios
            .post("/api/memos", data)
            .then(async (res: AxiosResponse) => {
              console.log(res.data);
              await router.push("/memos");
            })
            .catch((err: AxiosError<MemoValidationResponseType>) => {
              console.log(err.response);
              if (err.response?.status === 422) {
                const errors = err.response.data.errors;
                // state更新用のオブジェクトを別で定義
                const validationMessages: { [index: string]: string } = {} as MemoValidationType;
                Object.keys(errors).map((key: string) => {
                  validationMessages[key] = errors[key][0];
                });
                // state更新用オブジェクトに更新
                setValidation(validationMessages);
              }

              if (err.response?.status === 500) {
                alert("システムエラーです。");
              }
            });
        });
    },
    [router]
  );

  return { createMemo, validation };
};
