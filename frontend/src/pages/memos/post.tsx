import { NextPage } from "next";
import { useRouter } from "next/router";
import { ChangeEvent, useCallback, useEffect } from "react";

import { PrimaryInput, PrimaryTextarea } from "@/components/atoms";
import { FormLayout, Layout } from "@/components/templates";
import { useAuth, useMemoPost } from "@/hooks";

const PostPage: NextPage = () => {
  //* router
  const router = useRouter();

  //* hooks
  const { memoForm, setMemoForm, createMemo, validation } = useMemoPost();
  const { checkLoggedIn } = useAuth();

  //* event
  // POSTデータの更新
  const updateMemoForm = useCallback(
    (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
      setMemoForm({ ...memoForm, [e.target.name]: e.target.value });
    },
    [memoForm, setMemoForm]
  );

  //* DidMount
  useEffect(() => {
    void (async () => {
      // ログイン中か判定
      const res: boolean = await checkLoggedIn();
      if (!res) {
        await router.push("/");
      }
    })();
  }, [router, checkLoggedIn]);

  return (
    <Layout title="メモの登録">
      <FormLayout title="メモの登録" btnTitle="登録する" onClick={createMemo}>
        <PrimaryInput
          text="タイトル"
          name="title"
          value={memoForm.title}
          onChange={updateMemoForm}
          message={validation?.title}
        />
        <PrimaryTextarea text="メモの内容" value={memoForm.body} onChange={updateMemoForm} message={validation?.body} />
      </FormLayout>
    </Layout>
  );
};

export default PostPage;
