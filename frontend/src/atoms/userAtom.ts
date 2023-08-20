import { atom, useRecoilState } from "recoil";

// type UserStateType = {
//   id: number;
// } | null;

type LoginUserStateType = {
  id: number;
  name: string;
  email: string;
} | null;

// const userState = atom<UserStateType>({
//   key: "user",
//   default: null,
// });

// export const useUserState = () => {
//   const [user, setUser] = useRecoilState<UserStateType>(userState);

//   return { user, setUser };
// };

const loginUserState = atom<LoginUserStateType>({
  key: "loginUser",
  default: null,
});

export const useLoginUserState = () => {
  const [loginUser, setLoginUser] = useRecoilState<LoginUserStateType>(loginUserState);

  return { loginUser, setLoginUser };
};
