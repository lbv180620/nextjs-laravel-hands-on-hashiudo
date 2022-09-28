import { ChangeEvent, FC, memo, useCallback } from "react";

import { PasswordInput, PrimaryInput } from "@/components/atoms";
import { useLogin } from "@/hooks";

import { FormLayout } from "../layout/FormLayout";

export const Auth: FC = memo(() => {
  //* hooks
  // ログイン関係
  const { loginForm, setLoginForm, login, validation } = useLogin();

  //* event
  // POSTデータの更新
  const updateLoginForm = useCallback(
    (e: ChangeEvent<HTMLInputElement>) => {
      setLoginForm({ ...loginForm, [e.target.name]: e.target.value });
    },
    [loginForm, setLoginForm]
  );

  return (
    <FormLayout title="ログイン" btnTitle="ログイン" onClick={login} message={validation.loginFailed}>
      <PrimaryInput
        text="メールアドレス"
        name="email"
        value={loginForm.email}
        onChange={updateLoginForm}
        message={validation.email}
      />
      <PasswordInput value={loginForm.password} onChange={updateLoginForm} message={validation.password} />
    </FormLayout>
  );
});

/**
 * ! バケツリレーになっている。
 */
