import { AxiosError, AxiosResponse } from "axios";
import { useRouter } from "next/router";
import { useCallback, useState } from "react";

import axios from "@/libs/axios";
import { LoginFormType } from "@/types";

export const useLogin = () => {
  //* router
  const router = useRouter();

  //* local state
  // POSTデータのstate
  const [loginForm, setLoginForm] = useState<LoginFormType>({
    email: "",
    password: "",
  });

  //* api
  // ログイン
  const login = useCallback(async () => {
    await axios
      // CSRF保護の初期化
      .get("/sanctum/csrf-cookie")
      .then(async () => {
        // ログイン処理
        await axios
          .post("/login", loginForm)
          .then(async (res: AxiosResponse) => {
            console.log(res.data);
            await router.push("/memos");
          })
          .catch((err: AxiosError) => {
            console.log(err.response);
          });
      });
  }, [loginForm, router]);

  return { loginForm, setLoginForm, login };
};
