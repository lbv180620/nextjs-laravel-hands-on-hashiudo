import { ErrorMessage } from "@hookform/error-message";
import { NextPage } from "next";
import { useRouter } from "next/router";
import { useEffect } from "react";
import { useForm } from "react-hook-form";

import { PrimaryButton, PrimaryInput, PrimaryTextarea } from "@/components/atoms";
import { FormLayout, Layout } from "@/components/templates";
import { useAuth, useMemoPost } from "@/hooks";
import { MemoFormType } from "@/types";

const PostPage: NextPage = () => {
  //* router
  const router = useRouter();

  //* hooks
  const { createMemo, validation } = useMemoPost();
  const { checkLoggedIn } = useAuth();

  //* react-hook-form
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<MemoFormType>();

  //* DidMount
  useEffect(() => {
    void (async () => {
      // ログイン中か判定
      const res: boolean = await checkLoggedIn();
      if (!res) {
        await router.push("/");
        return;
      }
    })();
  }, [router, checkLoggedIn]);

  return (
    <Layout title="メモの登録">
      <FormLayout title="メモの登録">
        <PrimaryInput text="タイトル" message={validation?.title}>
          <input
            className="w-full rounded-md border p-2 outline-none"
            {...register("title", { required: "必須入力です。" })}
          />
          <ErrorMessage
            errors={errors}
            name={"title"}
            render={({ message }) => <p className="py-3 text-red-500">{message}</p>}
          />
        </PrimaryInput>
        <PrimaryTextarea text="メモの内容" message={validation?.body}>
          <textarea
            className="w-full rounded-md border p-2 outline-none"
            cols={30}
            rows={4}
            {...register("body", { required: "必須入力です。" })}
          />
          <ErrorMessage
            errors={errors}
            name={"body"}
            render={({ message }) => <p className="py-3 text-red-500">{message}</p>}
          />
        </PrimaryTextarea>
        <PrimaryButton>
          <button
            className="cursor-pointer rounded-xl bg-gray-700 py-3 px-10 text-gray-50 drop-shadow-md hover:bg-gray-600 sm:px-20"
            onClick={handleSubmit(createMemo)}
          >
            登録する
          </button>
        </PrimaryButton>
      </FormLayout>
    </Layout>
  );
};

export default PostPage;
