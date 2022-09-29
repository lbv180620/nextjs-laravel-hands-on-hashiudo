import { NextPage } from "next";
import { ChangeEvent, useCallback } from "react";

import { PasswordInput, PrimaryInput } from "@/components/atoms";
import { FormLayout, Layout } from "@/components/templates";
import { useLogin } from "@/hooks";

const Home: NextPage = () => {
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
    <Layout title="ログイン">
      <FormLayout title="ログイン" btnTitle="ログイン" onClick={login} message={validation?.loginFailed}>
        <PrimaryInput
          text="メールアドレス"
          name="email"
          value={loginForm.email}
          onChange={updateLoginForm}
          message={validation?.email}
        />
        <PasswordInput value={loginForm.password} onChange={updateLoginForm} message={validation?.password} />
      </FormLayout>
    </Layout>
  );
};
export default Home;
