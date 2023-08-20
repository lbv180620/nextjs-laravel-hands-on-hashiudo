import { AxiosError, AxiosResponse } from "axios";
import { useRouter } from "next/router";
import { useCallback } from "react";

import axios from "@/libs/axios";
import { LogoutResponseIF } from "@/types";

export const useLogout = () => {
  //* router
  const router = useRouter();

  //* api
  // ログアウト
  const logout = useCallback(async () => {
    await axios
      // CSRF保護の初期化
      .get("/sanctum/csrf-cookie")
      .then(async () => {
        // ログアウト処理
        await axios
          .post("/logout")
          .then(async (res: AxiosResponse<LogoutResponseIF>) => {
            console.log(res.data);
            alert(res.data.success.message);
            await router.push("/");
          })
          .catch((err: AxiosError) => {
            console.log(err.response);
            if (err.response?.status === 500) {
              //! 本来はエラーページを準備してそのページに自動的に遷移するのが良さそうです。
              alert("システムエラーです。");
            }
          });
      });
  }, [router]);

  return { logout };
};
