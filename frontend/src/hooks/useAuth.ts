import { useCallback } from "react";

import { useUserState } from "@/atoms";
import axios from "@/libs/axios";
import { UserResourceType } from "@/types";

export const useAuth = () => {
  //* global state
  const { user, setUser } = useUserState();

  const checkLoggedIn: () => Promise<boolean> = useCallback(async () => {
    if (user) {
      return true;
    }

    try {
      const res = await axios.get<UserResourceType>("api/user");

      if (!res.data.data) {
        return false;
      }

      setUser(res.data.data);
      return true;
    } catch {
      return false;
    }
  }, [setUser, user]);

  return { checkLoggedIn };
};
