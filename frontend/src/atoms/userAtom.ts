import { atom, useRecoilState } from "recoil";

type UserStateType = {
  id: number;
} | null;

const userState = atom<UserStateType>({
  key: "user",
  default: null,
});

export const useUserState = () => {
  const [user, setUser] = useRecoilState<UserStateType>(userState);

  return { user, setUser };
};
