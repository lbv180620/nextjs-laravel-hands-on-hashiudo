import { useCallback } from "react";

import { useLoginUserState } from "@/atoms";
import axios from "@/libs/axios";
import { SuccessResponseBodyType, LoginUserFetchSuccessResponseDataType } from "@/types";

export const useAuth = () => {
  //* global state
  const { loginUser, setLoginUser } = useLoginUserState();

  const checkLoggedIn: () => Promise<boolean> = useCallback(async () => {
    if (loginUser) {
      return true;
    }

    try {
      const res = await axios.get<SuccessResponseBodyType<LoginUserFetchSuccessResponseDataType>>("api/me");

      if (!res.data.success.data) {
        return false;
      }

      setLoginUser(res.data.success.data);
      return true;
    } catch {
      return false;
    }
  }, [setLoginUser, loginUser]);

  return { checkLoggedIn };
};
