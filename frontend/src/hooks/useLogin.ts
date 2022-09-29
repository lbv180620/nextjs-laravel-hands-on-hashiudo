import { AxiosError, AxiosResponse } from "axios";
import { useRouter } from "next/router";
import { useCallback, useState } from "react";

import { useUserState } from "@/atoms";
import axios from "@/libs/axios";
import { LoginFormType, LoginValidationResponseType, UserResourceType, LoginValidationType } from "@/types";

export const useLogin = () => {
  //* router
  const router = useRouter();

  //* global state
  const { setUser } = useUserState();

  //* local state
  // バリデーションメッセージのstate
  const [validation, setValidation] = useState<LoginValidationType>({});

  //* api
  // ログイン
  const login = useCallback(
    async (data: LoginFormType) => {
      // バリデーションメッセージの初期化
      setValidation({
        email: "",
        password: "",
        loginFailed: "",
      });

      await axios
        // CSRF保護の初期化
        .get("/sanctum/csrf-cookie")
        .then(async () => {
          // ログイン処理
          await axios
            .post("/login", data)
            .then(async (res: AxiosResponse<UserResourceType>) => {
              console.log(res.data);
              setUser(res.data.data);
              await router.push("/memos");
            })
            .catch((err: AxiosError<LoginValidationResponseType>) => {
              console.log(err.response);
              // バリデーションエラー
              if (err.response?.status === 422) {
                // バリデーションのレスポンスの構造を整形する処理
                const errors = err.response?.data.errors;
                // state更新用のオブジェクトを別で定義(整形されたレスポンスが入る変数)
                const validationMessages: { [index: string]: string } = {} as LoginValidationType;
                // ここで整形する
                Object.keys(errors).map((key: string) => {
                  validationMessages[key] = errors[key][0];
                });
                // state更新用オブジェクトに更新
                setValidation(validationMessages);
              }

              if (err.response?.status === 500) {
                //! 本来はエラーページを準備してそのページに自動的に遷移するのが良さそうです。
                alert("システムエラーです。");
              }
            });
        });
    },
    [router, setUser]
  );

  return { login, validation };
};
