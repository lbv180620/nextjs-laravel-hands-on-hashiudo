import { ErrorMessage } from "@hookform/error-message";
import { AxiosError, AxiosResponse } from "axios";
import { NextPage } from "next";
import { useRouter } from "next/router";
import { useCallback, useState } from "react";
import { useForm } from "react-hook-form";

import { PrimaryButton, PrimaryInput } from "@/components/atoms";
import { Loading } from "@/components/molecules";
import { FormLayout, Layout } from "@/components/templates";
import { useLogin } from "@/hooks";
import axios from "@/libs/axios";
import { LoginFormType, RedirectResourceType } from "@/types";

const Home: NextPage = () => {
  //* router
  const router = useRouter();

  //* hooks
  // ログイン関係
  const { login, validation } = useLogin();

  //* local state
  const [isLoading, setIsLoading] = useState(false);

  //* react-hook-form
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginFormType>();

  //* Socialite
  const signIn = useCallback(async () => {
    setIsLoading(true);
    await axios
      .get("/login/google")
      .then(async (res: AxiosResponse<RedirectResourceType>) => {
        console.log(res.data);
        await router.push(res.data.redirect_url);
      })
      .catch((err: AxiosError) => {
        console.log(err.response);
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, [router]);

  //* component
  if (isLoading) return <Loading />;

  return (
    <Layout title="ログイン">
      <FormLayout title="ログイン">
        <PrimaryInput text="メールアドレス" message={validation?.email}>
          <input
            className="w-full rounded-md border p-2 outline-none"
            {...register("email", {
              required: "必須入力です。",
              pattern: {
                value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                message: "有効なメールアドレスを入力してください。",
              },
            })}
          />
          <ErrorMessage
            errors={errors}
            name={"email"}
            render={({ message }) => <p className="py-3 text-red-500">{message}</p>}
          />
        </PrimaryInput>
        <PrimaryInput text="パスワード" message={validation.password}>
          <small className="mb-2 block text-gray-500">8文字以上の半角英数字で入力してください</small>
          <input
            className="w-full rounded-md border p-2 outline-none"
            type="password"
            {...register("password", {
              required: "必須入力です。",
              pattern: {
                value: /^[a-zA-Z0-9]{8,}$/,
                message: "8文字以上の半角英数字で入力してください",
              },
            })}
          />
          <ErrorMessage
            errors={errors}
            name={"password"}
            render={({ message }) => <p className="py-3 text-red-500">{message}</p>}
          />
        </PrimaryInput>
        <PrimaryButton message={validation?.loginFailed}>
          <button
            className="cursor-pointer rounded-xl bg-gray-700 py-3 px-10 text-gray-50 drop-shadow-md hover:bg-gray-600 sm:px-20"
            onClick={handleSubmit(login)}
          >
            ログイン
          </button>
        </PrimaryButton>
        <div className="mt-8 text-center">
          <p className="text-sm text-gray-500">Googleアカウントでサインイン</p>
          <button className="mt-2 rounded bg-blue-400 py-2 px-4 text-white" onClick={() => signIn()}>
            Sign in
          </button>
        </div>
      </FormLayout>
    </Layout>
  );
};
export default Home;
