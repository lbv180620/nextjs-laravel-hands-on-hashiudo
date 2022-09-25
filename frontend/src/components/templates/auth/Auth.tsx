import { ChangeEvent, FC, memo, useCallback } from "react";

import { PasswordInput, PrimaryInput } from "@/components/atoms";
import { useLogin } from "@/hooks";
// import { ValidationType } from "@/types";

import { FormLayout } from "../layout/FormLayout";

export const Auth: FC = memo(() => {
  //* hooks
  // ログイン関係
  const { loginForm, setLoginForm, login } = useLogin();

  //* local state
  // バリデーションメッセージのstate
  // const [validation, setValidation] = useState<ValidationType>({
  //   email: "",
  //   password: "",
  //   loginFailed: "",
  // });

  //* event
  // POSTデータの更新
  const updateLoginForm = useCallback(
    (e: ChangeEvent<HTMLInputElement>) => {
      setLoginForm({ ...loginForm, [e.target.name]: e.target.value });
    },
    [loginForm, setLoginForm]
  );

  return (
    <FormLayout title="ログイン" btnTitle="ログイン" onClick={login}>
      <PrimaryInput text="メールアドレス" name="email" value={loginForm.email} onChange={updateLoginForm} />
      <PasswordInput value={loginForm.password} onChange={updateLoginForm} />
    </FormLayout>
  );
});

/**
 * ! バケツリレーになっている。
 */
